#!/usr/bin/env python

# ASL_PREPROC: Preprocessing of ASL images tog et data into correct form for Oxford_ASL and BASIL
#
# Michael Chappell & Brad MacIntosh, FMRIB Image Analysis & Physics Groups
#
# Copyright (c) 2008 University of Oxford
#
#   Part of FSL - FMRIB's Software Library
#   http://www.fmrib.ox.ac.uk/fsl
#   fsl@fmrib.ox.ac.uk
#   
#   Developed at FMRIB (Oxford Centre for Functional Magnetic Resonance
#   Imaging of the Brain), Department of Clinical Neurology, Oxford
#   University, Oxford, UK
#   
#   
#   LICENCE
#   
#   FMRIB Software Library, Release 4.0 (c) 2007, The University of
#   Oxford (the "Software")
#   
#   The Software remains the property of the University of Oxford ("the
#   University").
#   
#   The Software is distributed "AS IS" under this Licence solely for
#   non-commercial use in the hope that it will be useful, but in order
#   that the University as a charitable foundation protects its assets for
#   the benefit of its educational and research purposes, the University
#   makes clear that no condition is made or to be implied, nor is any
#   warranty given or to be implied, as to the accuracy of the Software,
#   or that it will be suitable for any particular purpose or for use
#   under any specific conditions. Furthermore, the University disclaims
#   all responsibility for the use which is made of the Software. It
#   further disclaims any liability for the outcomes arising from using
#   the Software.
#   
#   The Licensee agrees to indemnify the University and hold the
#   University harmless from and against any and all claims, damages and
#   liabilities asserted by third parties (including claims for
#   negligence) which arise directly or indirectly from the use of the
#   Software or the sale of any products based on the Software.
#   
#   No part of the Software may be reproduced, modified, transmitted or
#   transferred in any form or by any means, electronic or mechanical,
#   without the express permission of the University. The permission of
#   the University is not required if the said reproduction, modification,
#   transmission or transference is done without financial return, the
#   conditions of this Licence are imposed upon the receiver of the
#   product, and all original and amended source code is included in any
#   transmitted product. You may be held legally responsible for any
#   copyright infringement that is caused or encouraged by your failure to
#   abide by these terms and conditions.
#   
#   You are not permitted under this Licence to use this Software
#   commercially. Use for which any financial return is received shall be
#   defined as commercial use, and includes (1) integration of all or part
#   of the source code or the Software into a product for sale or license
#   by or on behalf of Licensee to third parties or (2) use of the
#   Software or any derivative of it for research with the final aim of
#   developing software products for sale or license to a third party or
#   (3) use of the Software or any derivative of it for research with the
#   final aim of developing non-software products for sale or license to a
#   third party, or (4) use of the Software to provide any service to an
#   external organisation for which payment is received. If you are
#   interested in using the Software commercially, please contact Isis
#   Innovation Limited ("Isis"), the technology transfer company of the
#   University, to negotiate a licence. Contact details are:
#   innovation@isis.ox.ac.uk quoting reference DE/1112.

import os, sys
import shutil
from optparse import OptionParser, OptionGroup

import numpy as np

import fslhelpers as fsl

usage = """ASL_PREPROC"

Assembles Multi-TI ASL images into correct form for Oxford_ASL and BASIL"
"""

def preproc(infile, nrp, nti, outfile, smooth=False, fwhm=6, mc=False, log=sys.stdout):
    log.write("Preprocessing with multi-TI ASL data\n")

    # Total number of TC pairs and volumes
    npairs=nti*nrp
    input_nvols = fsl.Image(infile).shape[3]
    
    log.write("Working on data %s\n" % infile)
    log.write("Number of TIs                 : %i\n" % nti)
    log.write("Number of repeats             : %i\n" % nrp)
    log.write("Total number of TC pairs      : %i\n" % npairs)
    log.write("Input data number of volumes  : %i\n" % input_nvols)

    fsl.mkdir("asl_preproc_temp")
    fsl.imcp(infile, "asl_preproc_temp/stacked_asaq")
    
    ntc = 2
    if npairs == input_nvols:
        log.write("Data appears to be differenced already - will not perform TC subtraction\n")
        ntc = 1
    elif npairs*2 > input_nvols:
        raise Exception("Not enough volumes in input data (%i - required %i)\n" % (input_nvols, npairs*2))
    elif npairs*2 < input_nvols:
        log.write("Warning: Input data contained more volumes than required (%i - required %i) - some will be ignored" % (input_nvols, npairs*2))

    if mc:
        log.write("Warning: Motion correction is untested - check your results carefuly!\n")
        fsl.Prog("mcflirt").run("-in asl_preproc_temp/stacked_asaq -out asl_preproc_temp/stacked_asaq -cost mutualinfo")

    stacked_nii = fsl.Image("asl_preproc_temp/stacked_asaq")
    stacked_data = stacked_nii.data()
    input_nvols = stacked_data.shape[3]

    log.write("Assembling data for each TI and differencing\n")

    shape_3d = list(stacked_data.shape[:3])
    diffs_stacked = np.zeros(shape_3d + [npairs])
    for ti in range(nti):
        diffs_ti = np.zeros(shape_3d + [nrp])
        for rp in range(nrp):
            v = ntc*rp*nti + ntc*ti
            if ntc == 2:
                tag = stacked_data[:,:,:,v]
                ctrl = stacked_data[:,:,:,v+1]
                diffs_ti[:,:,:,rp] = tag - ctrl
            else:
                diffs_ti[:,:,:,rp] = stacked_data[:,:,:,v]

        diffs_stacked[:,:,:,ti*nrp:(ti+1)*nrp] = diffs_ti
    
    # take the mean across the repeats
    diffs_mean = np.zeros(shape_3d)
    diffs_mean[:,:,:] = np.mean(diffs_stacked, 3)

    log.write("Assembling stacked data file\n")

    stacked_nii.new_nifti(diffs_stacked).to_filename("%s.nii.gz" % outfile)
    stacked_nii.new_nifti(diffs_mean).to_filename("%s_mean.nii.gz" % outfile)

    log.write("ASL data file is: %s\n" % outfile)
    log.write("ASL mean data file is: %s_mean\n" % outfile)

    if smooth:
        # Do spatial smoothing
        sigma = round(fwhm/2.355, 2)
        log.write("Performing spatial smoothing with FWHM: %f (sigma=%f)\n" % (fwhm, sigma))
        fsl.maths.run("%s -kernel gauss %f -fmean %s_smooth" % (outfile, sigma, outfile))
        fsl.maths.run("%s_mean -kernel gauss %f -fmean %s_smooth_mean" % (outfile, sigma, outfile))

        log.write("Smoothed ASL data file is: %s_smooth" % outfile)
        log.write("Smoothed ASL mean data file is: %s_smooth_mean" % outfile)

    shutil.rmtree("asl_preproc_temp")
    log.write("DONE\n")

if __name__ == "__main__":
    try:
        p = OptionParser(usage=usage, version="@VERSION@")
        p.add_option("-i", dest="infile", help="Name of (stacked) ASL data file")
        p.add_option("--nrp", dest="nrp", help="Number of repeats", type="int")
        p.add_option("--nti", dest="nti", help="Number of TIs in data", type="int")
        p.add_option("-o", dest="output", help="Output name", default="asldata")
        p.add_option("-s", dest="smooth", help="Spatially smooth data", action="store_true")
        p.add_option("--fwhm", dest="fwhm", help="FWHM for spatial filter kernel", type="float", default=6)
        p.add_option("-m", dest="mc", help="Motion correct data", action="store_true", default=False)
        options, args = p.parse_args(sys.argv)

        preproc(options.infile, options.nrp, options.nti, options.outfile, optinos.smooth, optinos.fwhm, options.mc)
    except Exception as e:
        print("ERROR: " + str(e) + "\n")


