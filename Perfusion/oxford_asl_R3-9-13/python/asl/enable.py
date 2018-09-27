#!/usr/bin/env python
# ENABLE package for ASL

import os, sys
import glob
import shutil
import math
from optparse import OptionParser, OptionGroup

import nibabel as nib
import numpy as np
import scipy.stats

from . import fslwrap as fsl
from .image import AslImage, AslOptionParser, AslWorkspace

__version__ = "v0.3.3-4-g88e961e"
__timestamp__ = "Thu Mar 1 11:02:28 2018"

def get_rois(wsp, t1, ref, noise_roi, gm_roi, options, log=sys.stdout):
    log.write("Generating ROIs...\n")

    # Bet the T1 - we will need this for the noise ROI and the GM ROI
    log.write("Brain-extracting T1 image\n")
    t1_bet, t1_mask = wsp.bet(t1, args="-B -f 0.3", mask=True)

    if gm_roi is None:
        # If we need a GM ROI use FAST to segment T1 
        log.write("Generating GM ROI by segmenting T1 image\n")
        fastdir = wsp.sub("fast", imgs=[t1_bet])
        gm_roi = fastdir.fast(t1_bet, args="-p")
        d = gm_roi.data()
        d[np.logical_or(d<1.5, d > 2.5)] = 0
        gm_roi = gm_roi.derived(d, suffix="_GM")
        wsp.add_img(gm_roi)
        options.gm_from_t1 = True

    if noise_roi is None:
        # If we need a noise ROI, invert the T1 brain mask
        log.write("Generating noise ROI by inverting T1 brain mask\n")
        noise_roi = t1_mask.derived(1-t1_mask.data(), suffix="_inv")
        wsp.add_img(noise_roi)
        options.noise_from_t1 = True

    if options.noise_from_t1 or options.gm_from_t1:
        # Need to register T1 to ASL space so we can apply the transform the the 
        # either or both of the noise/GM ROIs
        log.write("Registering ROIs to ASL space\n")

        # Bet the reference image to use as a reg target
        ref_bet = wsp.bet(ref)

        # This is done to avoid the contrast enhanced rim resulting from low intensity ref image
        d = ref_bet.data()
        thr_ref = np.percentile(d[d!=0], 10.0)
        d[d<thr_ref] = 0
        raw_bet = ref_bet.derived(d)
        wsp.add_img(raw_bet)

        asl2t1, asl2t1_mat, t12asl_mat = wsp.flirt(ref_bet, t1_bet, args="-dof 7", 
                                                   output_name="ASL_2T1", 
                                                   output_mat="ASL_2T1.mat",
                                                   output_invmat="T1_2ASL.mat")

        if options.noise_from_t1:
            # Register noise ROI to ASL space since it was defined in T1 space
            noise_roi = wsp.apply_xfm(noise_roi, ref_bet, t12asl_mat, 
                                      args="-interp nearestneighbour", 
                                      output_name="%s_2asl" % noise_roi.iname)

        if options.gm_from_t1:
            # Register GM ROI to ASL space since it was defined in T1 space
            gm_roi = wsp.apply_xfm(gm_roi, ref_bet, t12asl_mat, 
                                   args="-interp nearestneighbour", 
                                   output_name="%s_2asl" % gm_roi.iname)

    log.write("DONE\n\n")
    return noise_roi, gm_roi

def tsf(df, t):
    """ 
    Survival function (1-CDF) of the t-distribution

    Heuristics to agree with FSL ttologp but not properly justified
    """
    if t < 0:
        return 1-tsf(df, -t)
    elif t > 700:
        return scipy.stats.t.sf(t, df)
    else:
        return 1-scipy.special.stdtr(df, t)

def calculate_cnr(asl_data, gm_roi, noise_roi, log=sys.stdout):
    """
    Sort ASL images based on CNR (Contrast:Noise ratio). 

    CNR is defined as mean difference signal divided by nonbrain standard deviation

    :param asl_data: Differenced single-TI ASL data
    :param gm_roi: Grey-matter mask
    :param noise_roi: Noise mask (typically all non-brain parts of the image)
    
    :returns: 4D image in which volumes have been sorted from highest to lowest CNR
    """
    log.write("Sort ASL-diff images based on CNR...\n")

    tdim = asl_data.shape[3]
    cnrs = []
    for i in range(tdim):
        vol_data = asl_data.data()[:,:,:,i].astype(np.float32)
        meanGM = np.mean(vol_data[gm_roi.data() > 0])
        noisestd = np.std(vol_data[noise_roi.data() > 0])
        cnr = meanGM/noisestd
        if cnr < 0:
            log.write("WARNING: CNR was negative - are your tag-control pairs the right way round?")
        cnrs.append(cnr)

    return cnrs

def sort_cnr(asl_data, cnrs, log=sys.stdout):
    # Sort by decreasing CNR
    sorted_cnrs = sorted(enumerate(cnrs), key=lambda x: x[1], reverse=True)

    # Create re-ordered data array
    log.write("Images sorted by CNR\n\n")
    log.write("Volume\tCNR\n")
    sorted_data = np.zeros(asl_data.shape)
    for idx, cnr in enumerate(sorted_cnrs):
        vol_data = asl_data.data()[:,:,:,cnr[0]].astype(np.float32)
        sorted_data[:,:,:,idx] = vol_data
        log.write("%i\t%.3f\n" % (cnr[0], cnr[1]))

    log.write("DONE\n\n")

    sorted_cnrs = [(idx, cnr[0], cnr[1]) for idx, cnr in enumerate(sorted_cnrs)]
    return asl_data.derived(sorted_data, suffix="_sorted"), sorted_cnrs

def calculate_quality_measures(asl_data, gm_roi, noise_roi, min_nvols, log=sys.stdout):
    """
    Calculate quality measures for ASL data, sorted by CNR
    """
    log.write("Calculate quality measures...\n")
    if min_nvols < 2:
        raise RuntimeError("Need to keep at least 2 volumes to calculate quality measures")

    tdim = asl_data.shape[3]
    gm_roi = gm_roi.data()
    noise_roi = noise_roi.data()
    num_gm_voxels = np.count_nonzero(gm_roi)

    log.write("Volumes\ttCNR\tDETECT\tCOV\ttSNR\n")
    qms = {"tcnr" : [], "detect" : [], "cov" : [], "tsnr" : []}
    
    for i in range(min_nvols, tdim+1, 1):
        temp_data = asl_data.data()[:,:,:,:i]

        mean = np.mean(temp_data, 3)
        std = np.std(temp_data, 3, ddof=1)

        # STD = 0 means constant data across volumes, do something sane
        std[std == 0] = 1
        mean[std == 0] = 0

        snr = mean / std
        serr = std / math.sqrt(float(i))
        tstats = mean / serr

        # Annoyingly this is slower than using ttologp. scipy.special.stdtr
        # is fast but not accurate enough. Need to understand exactly what 
        # this is doing, however, because it seems to rely on 'anything below
        # float32 minimum == 0'
        calc_p = np.vectorize(lambda x: tsf(i, x))
        p1 = calc_p(tstats).astype(np.float32)
        p1[p1 > 0.05] = 0
        sigvox2 = p1
        sigvoxGM2 = np.count_nonzero(sigvox2[gm_roi > 0])

        DetectGM = float(sigvoxGM2)/num_gm_voxels
        tSNRGM = np.mean(snr[gm_roi > 0])
        meanGM = np.mean(mean[gm_roi > 0])
        stdGM = np.std(mean[gm_roi > 0], ddof=1)
        CoVGM = 100*float(stdGM)/float(meanGM)

        noisestd = np.std(mean[noise_roi > 0], ddof=1)
        SNRGM = float(meanGM)/float(noisestd)
        qms["tcnr"].append(SNRGM)
        qms["detect"].append(DetectGM)
        qms["cov"].append(CoVGM)
        qms["tsnr"].append(tSNRGM)
        log.write("%i\t%.3f\t%.3f\t%.3f\t%.3f\n" % (i, SNRGM, DetectGM, CoVGM, tSNRGM))

    log.write("DONE\n\n")  
    return qms

def get_combined_quality(qms, ti, b0="3T", log=sys.stdout):

    # Weightings from the ENABLE paper, these vary by PLD
    sampling_plds = [0.1, 0.5, 0.9, 1.3, 1.7, 2.1]
    coef={
        "3T" : {
            "tcnr" : [0.4, 0.3, 0.7, 0.1, 0.5, 0.3],
            "detect" : [1.6, 1.7, 1.0, 1.8, 1.4, 1.8],
            "cov" : [-0.9, -0.9, -0.3, -1.0, -0.8, -0.6],
            "tsnr" : [-1.1, -1.0, -1.1, -1.0, -1.0, -0.8],
        },
        "1.5T" : {
            "tcnr" : [0.5, 0.7, 0.7, 0.8, 0.2, 0.1],
            "detect" : [1.3, 1.2, 1.0, 0.8, 1.5, 1.6],
            "cov" : [-0.5, -0.7, -0.3, -0.4, -0.6, -0.7],
            "tsnr" : [-1.2, -1.0, -1.1, -1.0, -1.0, -1.0],
        }
    }

    if b0 not in coef:
        raise RuntimeError("We don't have data for B0=%s" % b0)
    coeffs = coef[b0]

    num_meas = len(qms["detect"])
    qual = np.zeros([num_meas], dtype=np.float)
    for meas, vals in qms.items():
        c = np.interp([ti], sampling_plds, coeffs[meas])

        # Try to ensure numerical errors do not affect the result
        vals[vals == np.inf] = 0
        vals[vals == -np.inf] = 0
        vals = np.nan_to_num(vals)

        normed = np.array(vals, dtype=np.float) / max(vals)
        qual += c * normed
    
    return qual

def enable(wsp, asldata, noise_roi, gm_roi, min_nvols, log=sys.stdout):
    asldata = asldata.diff().reorder("rt")
    results = []
    ti_data = []

    # Process each TI in turn
    for idx, ti in enumerate(asldata.tis):
        log.write("\nProcessing TI: %i (%s)\n" % (idx, str(ti)))
        
        # Create workspace for TI
        data_singleti = asldata.single_ti(idx)
        ti_results = []

        wsp_ti = wsp.sub("ti_%s" % str(ti), imgs=[data_singleti])
    
        # Write out the mean differenced image for comparison
        meandata_orig = data_singleti.mean_across_repeats()
        meandata_orig.save()

        # Sorting and calculation of quality measures
        cnrs = calculate_cnr(data_singleti, gm_roi, noise_roi)

        sorted_data, sorted_cnrs = sort_cnr(data_singleti, cnrs)
        sorted_data.save()
        for sorted_order, orig_vol, cnr in sorted_cnrs:
            ti_results.append(
                {"ti" : ti, "rpt" : orig_vol, "cnr" : cnr,
                 "tcnr" : 0.0, "detect" : 0.0, "cov" : 0.0, "tsnr" : 0.0, "qual" : 0.0}
            )

        qms = calculate_quality_measures(sorted_data, gm_roi, noise_roi, min_nvols=min_nvols)
        for meas in "tcnr", "detect", "cov", "tsnr":
            for idx, val in enumerate(qms[meas]):
                ti_results[idx+min_nvols-1][meas] = val
           

        # Get the image at which the combined quality measure has its maximum
        combined_q = get_combined_quality(qms, ti)
        log.write("Volumes\tOverall Quality\n")
        for idx, q in enumerate(combined_q):
            log.write("%i\t%.3f\n" % (idx, q))
            ti_results[idx+min_nvols-1]["qual"] = q
            
        # Generate data subset with maximum quality
        best_num_vols = np.argmax(combined_q) + min_nvols
        maxqual = ti_results[best_num_vols-1]["qual"]
        log.write("Maximum quality %.3f with %i volumes\n" % (maxqual, best_num_vols))

        for idx, result in enumerate(ti_results):
            result["selected"] = idx < best_num_vols
            
        asldata_enable = AslImage(name=sorted_data.ipath + "_enable", 
                                  data=sorted_data.data()[:,:,:,:best_num_vols], 
                                  order=sorted_data.order, ntis=1, nrpts=best_num_vols,
                                  base=sorted_data,
                                  save=True)

        meandata_enable = asldata_enable.mean_across_repeats()
        meandata_enable.save()

        ti_data.append(asldata_enable)
        results += ti_results

    # Create combined data set
    rpts = [img.rpts[0] for img in ti_data]
    combined_data = np.zeros(list(asldata.shape[:3]) + [sum(rpts),])
    start = 0
    for nrpts, img in zip(rpts, ti_data):
        combined_data[:,:,:,start:start+nrpts] = img.data()
        start += nrpts
    log.write("\nCombined data has %i volumes (repeats: %s)\n" % (sum(rpts), str(rpts)))
    combined_img = AslImage(name=asldata.ipath + "_enable",
                            data=combined_data,
                            order="rt", tis=asldata.tis, rpts=rpts,
                            base=asldata, save=True)
    return combined_img, results

def main():
    usage = """ENABLE

    enable -i <ASL input file> -t1 <T1 image> -n <Noise ROI image> -o <Output dir>"""

    try:
        p = AslOptionParser(usage="asl_enable", version=__version__, ignore_stdopt=["--diff", "--reorder"])
        g = OptionGroup(p, "ENABLE options")
        g.add_option("-o", dest="output", help="Output directory")
        g.add_option("--noise", "-n", dest="noise", help="Noise ROI. If not specified, will run BET on T1 image and invert the brain mask")
        g.add_option("--noise-from-t1", dest="noise_from_t1", help="If specified, noise ROI is assumed to be in T1 image space and will be registered to ASL space", action="store_true", default=False)
        g.add_option("--gm", dest="gm", help="Grey matter ROI. If not specified, FAST will be run on the T1 image")
        g.add_option("--gm-from-t1", dest="gm_from_t1", help="If specified, GM ROI is assumed to be in T1 image space and will be registered to ASL space", action="store_true", default=False)
        g.add_option("--ref", dest="ref", help="Reference image in ASL space for registration and motion correction. If not specified will use middle volume of ASL data")
        g.add_option("--min-nvols", dest="min_nvols", help="Minimum number of volumes to keep for each TI", type="int", default=6)
        p.add_option_group(g)
        options, args = p.parse_args(sys.argv)
        
        print("ASL_ENABLE %s (%s)" % (__version__, __timestamp__))
        asldata = AslImage(options.asldata, role="Input", **vars(options))
        
        wsp = AslWorkspace(options.output, echo=options.debug)
        asldata.summary()
        print("")
        wsp.add_img(asldata)

        # Reference image for registration/MoCo
        if options.ref is not None:
            ref = fsl.Image(options.ref, role="Reference image")
        else:
            # Use middle volume of ASL data if not given
            middle = int(asldata.shape[3]/2)
            ref = fsl.Image(asldata.iname + "_ref", data=asldata.data()[:,:,:,middle], base=asldata)
        wsp.add_img(ref)

        # Noise ROI
        if options.noise is not None:
            print("\n\nLooking for noise", options.noise)
            noise_roi = fsl.Image(options.noise, role="Noise ROI")
            wsp.add_img(noise_roi)
        else:
            # Will derive a noise ROI by inverting the T1 brain mask
            noise_roi = None

        # Grey matter ROI
        if options.gm is not None:
            gm_roi = fsl.Image(options.gm, role="GM ROI")
            wsp.add_img(gm_roi)
        else:
            # Will derive a noise ROI by inverting the T1 brain mask
            gm_roi = None

        # T1 map is required if we need to derive grey matter or noise ROIs
        if gm_roi is not None and noise_roi is not None:
            # Don't need T1
            t1 = None
        elif options.t1 is not None:
            t1 = fsl.Image(options.t1, role="T1 image")
            wsp.add_img(t1)
        else:
            raise RuntimeError("Need to specify a T1 map if not providing both noise and GM ROIs")
            
        # Preprocessing (TC subtraction, optional MoCo/smoothing)
        options.diff = True
        preproc = wsp.preprocess(asldata, options, ref=ref)

        # Get ROIs from T1 if required
        if t1 is not None:
            noise_roi, gm_roi = get_rois(wsp, t1, ref, noise_roi, gm_roi, options)

        combined_img, results = enable(wsp, asldata, noise_roi, gm_roi, options.min_nvols)
        for result in results:
            print("Ti=%.3f, Repeat %i, CNR=%.3f, Q=%.3f, selected=%s" % (result["ti"], result["rpt"], result["cnr"], result["qual"], result["selected"]))
        
        print("\nTo run BASIL use input data %s" % combined_img.ipath)
        print("and %s" % " ".join(["--rpt%i=%i" % (idx+1, rpt) for idx, rpt in enumerate(combined_img.rpts)]))
    
    except RuntimeError as e:
        print("ERROR: " + str(e) + "\n")
        p.print_help()
        sys.exit(1)

if __name__ == "__main__":
    main()
