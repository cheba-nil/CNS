# ASL DEBLUR: asl_deblur(dir,data_name,residual_name,mask_name,output_name,kernel,sigma)
# Perform z-deblurring of ASL data
#
# kernel options are:
#   direct - estimate kernel directly from data
#   gauss  - use gauss kernel, but estimate size from data
#   manual - gauss kernel with size given by sigma
#   lorentz - lorentzain kernel, estimate size from data
#   lorwein - lorentzian kernel with weiner type filter
#
# deblur methods are:
#   fft - do division in FFT domain
#   lucy - Lucy-Richardson (ML solution) for Gaussian noise
#
# (c) Michael A. Chappell, University of Oxford, 2009-2014
# MAC 27-2-2009
import os, sys
from math import exp, pi, ceil, floor, sqrt
import glob
import tempfile
from optparse import OptionParser, OptionGroup

import numpy as np
import nibabel as nib
from scipy.fftpack import fft, ifft
from scipy.signal import tukey
from scipy.optimize import curve_fit
from scipy.linalg import svd

import asl.fslhelpers as fsl

def thresh(arr, thresh, useabs=False, binarise=False):
    """
    If useabs=False, set all x<thresh = 0
    If useabse=True, set all |x|<thresh = 0
    If binarise=True, also set all other values to 1 
    """
    if useabs:
        arr = p.absolute(arr)
       
    arr[arr < thresh] = 0
    if binarise: arr[arr >= thresh] = 1
    return arr

def flattenmask(mask, thr):
    if thr > mask.shape[2]:
        raise RuntimeError("Cannot flatten mask with a threshold larger than the z dimension")

    # Set all unmasked voxels to 1
    # FIXME need to copy mask?
    mask[mask > 0] = 1

    # Create a 2D array whose values are 1 if there are at least
    # 'thr' unmasked voxels in the z direction, 0 otherwise.
    return thresh(np.sum(mask, 2), thr, binarise=True)

def zdeblur_make_spec(resids, flatmask):
    np.set_printoptions(precision=16)
    zdata = Zvols2matrix(resids,flatmask)
    ztemp = np.zeros(zdata.shape)
    mean = zdata.mean(axis=1, dtype=np.float64)
    ztemp = zdata - mean[:,np.newaxis]
    
    f1 = fft(ztemp,axis=1)
    thepsd = np.absolute(fft(ztemp,axis=1))
    thepsd = np.mean(thepsd, 0)
    return thepsd

def Zvols2matrix(data,mask):
    """
    Takes 4D volume and 2D (xy) or 3D (xyt) mask and return 2D matrix
    (space-time x z-dimension)
    
    Just vols2matrix but choosing the Z-dimension
    """
    # Mask is 2D need to repeat by number of t points
    if mask.ndim == 2:
        mask = np.expand_dims(mask, -1)

    if mask.shape[2] == 1:
        mask = np.repeat(mask, data.shape[3], 2)
    
    # Flatten with extra z dimension
    mask = np.reshape(mask,[mask.size]) > 0
    
    # need to swap axes so 2nd dim of 2D array is Z not T
    data = np.transpose(data, [0,1,3,2])
    data2 = np.reshape(data,[mask.size, data.shape[3]])
    return data2[mask,:]

def lorentzian(x, gamma):
    return (1/pi * (0.5*gamma)/(np.square(x)+(0.5*gamma)**2))

def lorentzian_kern(gamma,len,demean=True):
    half = (float(len)-1)/2
    x = range(0, int(ceil(half))+1) + range(int(floor(half)), 0, -1)
    out = lorentzian(x,gamma)
    if demean: out = out - np.mean(out) #zero mean/DC
    return out

def lorentzian_autocorr(len, gamma):
    return np.real(ifft(np.square(np.absolute(fft(lorentzian_kern(gamma,len,1))))))

def lorentzian_wiener(len, gamma, tunef):
    thefft = np.absolute(fft(lorentzian_kern(gamma,len,True)))
    thepsd = np.square(thefft)
    tune = tunef*np.mean(thepsd)
    wien = np.divide(thepsd, thepsd+tune)
    wien[0]=1 # we are about to dealing with a demeaned kernel
    out = np.real(ifft(np.divide(thepsd, np.square(wien))))
    return out/max(out)

def gaussian_autocorr(len, sig):
    """
    Returns the autocorrelation function for Gaussian smoothed white
    noise with len data points, where the Gaussian std dev is sigma 
    """

    # For now we go via the gaussian fourier transform
    # (autocorr is ifft of the power spectral density)
    # ideally , we should just analytically calc the autocorr
    gfft=gaussian_fft(sig,len)
    x = np.real(ifft(np.square(gfft))) 

    if max(x)>0: x = x/max(x)
    return x

def gaussian_fft(sig,len,demean=True):
    """
    Returns the fourier transform function for Gaussian smoothed white
    noise with len data points, where the Gaussian std dev is sigma 
    """
    tres=1.0
    fres=1.0/(tres*len)
    maxk=1/tres
    krange=np.linspace(fres, maxk, len)
    
    x=[sig*exp(-(0.5*sig**2*(2*pi*k)**2))+sqrt(2*pi)*sig*exp(-(0.5*sig**2*(2*pi*((maxk+fres)-k))**2))
        for k in krange]
    if demean: x[0]=0
    return x

def fit_gaussian_autocorr(thefft):
    """
    Fit a Gaussian autocorrelation model to the data and return the
    std dev sigma
    """

    # (autocorr is ifft of the power spectral density)
    data_raw_autocorr = np.real(ifft(np.square(np.absolute(thefft))))
    data_raw_autocorr = data_raw_autocorr/max(data_raw_autocorr)

    popt, pcov = curve_fit(gaussian_autocorr,len(data_raw_autocorr),data_raw_autocorr,1)
    return popt[0]

def create_deblur_kern(thefft,kernel,kernlen,sig=1):
    np.set_printoptions(precision=16)
    if kernel == "direct":
        slope = thefft[1]-thefft[2]
        thefft[0] = thefft[1]+slope #put the mean in for tapering of the AC
        thefft = thefft/(thefft[1]+slope) #normalise, we want DC=1, but we will have to extrapolate as we dont ahve DC
        
        # multiply AC by tukey window
        i1 = np.real(ifft(np.square(thefft)))
        t1 = 1-tukey(len(thefft), sig)
        thefft = np.sqrt(np.absolute(fft(np.multiply(i1, t1))))
        thefft[0] = 0 # back to zero mean
    elif kernel == "lorentz":
        ac = np.real(ifft(np.square(thefft))) # autocorrelation
        ac = ac/max(ac)
        popt, pcov = curve_fit(lorentzian_autocorr, len(ac), ac, 2)
        gamma = popt[0]
        lozac = lorentzian_autocorr(kernlen, gamma)
        lozac = lozac/max(lozac)
        thefft = np.absolute(fft(lorentzian_kern(gamma,kernlen,True))) # when getting final spec. den. include mean        
    elif kernel == "lorwien":
        ac = np.real(ifft(np.square(thefft))) # autocorrelation
        ac = ac/max(ac)
        popt, pcov = curve_fit(lorentzian_wiener, len(ac), ac, (2, 0.01))
        gamma, tunef = popt
        lozac = lorentzian_wiener(kernlen, gamma, tunef)
        thefft = np.absolute(fft(lorentzian_kern(gamma,kernlen,True))) # when getting final spec. den. include mean
        thepsd = np.square(thefft)
        tune = tunef*np.mean(thepsd)
        wien = np.divide(thepsd, thepsd+tune)
        wien[0]=1
        thefft = np.divide(thefft, wien)
    elif kernel == "gauss":
        sigfit = fit_gaussian_autocorr(thefft)
        thefft = gaussian_fft(sigfit,kernlen,True) # When getting final spec. den. include mean
    elif kernel == "manual":
        if len(sig) != kernlen:
            raise RuntimeError("Manual deblur kernel requires signal of length %i" % kernlen)
        thefft = gaussian_fft(sig,kernlen,True)
    else:
        raise RuntimeError("Unknown kernel: %s" % kernel)

    # note that currently all the ffts have zero DC term!
    invkern = np.reciprocal(np.clip(thefft[1:], 1e-50, None))
    kern = np.real(ifft(np.insert(invkern, 0, 0)))
    
    # Code below is commented out in MATLAB original - preserving for now

    # Weiner filter
    # thepsd = thefft.^2
    # tune = 0.01*mean(thepsd)
    # invkern = 1./thefft.*(thepsd./(thepsd+tune))

    # The ffts should be already correctly normalized (unity DC)

    # normalise
    #if sum(kern)>0.01
    #   kern = kern/(sum(kern))
    #else
    #    warning('normalization of kernel skipped')
    #end

    if len(kern) < kernlen:
        # if the kernel is shorter than required pad in the middle by zeros
        n = kernlen-len(kern)
        i1 = int(len(kern)/2)
        kern = np.concatenate((kern[:i1], np.zeros(n), kern[i1:]))
    return kern
   
def zdeblur_with_kern(volume, kern, deblur_method="fft"):

    if deblur_method == "fft":

        # FIXME MATLAB code below transposes and takes complex conjugate 
        # We don't need to transpose, so just take conjugate. However not 
        # completely clear if complex conjugate is required or if this is
        # an unintentional side-effect of the transpose
        fftkern=np.conj(fft(kern))
        #if size(fftkern,2)==1
        #    fftkern = fftkern'
        #end

        # demean volume (in z) - 'cos kern is zero mean
        m = np.expand_dims(np.mean(volume, 2), 2)
        zmean = np.repeat(m, volume.shape[2], 2)
        volume = volume  - zmean
        
        fftkern = np.expand_dims(fftkern, 0)
        fftkern = np.expand_dims(fftkern, 0)
        fftkern = np.expand_dims(fftkern, -1)
        fftkern2 = np.zeros(volume.shape, dtype=complex)
        fftkern2[:,:,:,:] = fftkern
        fftvol = fft(volume,axis=2)
        v1 = np.multiply(fftkern2, fftvol)
        volout = np.real(ifft(np.multiply(fftkern2, fftvol), axis=2))
        volout += zmean
        return volout

    elif deblur_method == "lucy":
        volout = filter_matrix(volume, kern)
    else:
        raise RuntimeError("Unknown deblur method: %s" % deblur_method)

def filter_matrix(data, kernel):
    # This is the wrapper for the Lucy-Richardson deconvolution
    #
    # Filter matrix creates the different matrices before applying the
    # deblurring algorithm
    # Input --> original deltaM maps kernel
    # Output --> deblurred deltaM maps
    #
    # (c) Michael A. Chappell & Illaria Boscolo Galazzo, University of Oxford, 2012-2014

    # MAC 4/4/14 removed the creation of the lorentz kernel and allow to accept
    # any kernel
    #
    # FIXME this code is not complete because we get numerical problems and it is not
    # clear if the method is correctly implemented.
    raise RuntimeError("Lucy-Richardson deconvolution not supported in this version of ASL_DEBLUR")

    nr,nc,ns,nt = data.shape
    # Matrix K 
    kernel_max = kernel/np.sum(kernel)
    matrix_kernel = np.zeros((len(kernel), ns))
    matrix_kernel[:,0] = kernel_max
    for i in range(1, ns):
        matrix_kernel[:,i] = np.concatenate([np.zeros(i), kernel_max[:ns-i]])
    
    # Invert with SVD
    U,S,V = svd(matrix_kernel)
    #W = np.diag(np.reciprocal(np.diag(S)))
    #W[S < (0.2*S[0])] = 0
    #inverse_matrix = V*W*U.'
    inverse_matrix = np.linalg.inv(matrix_kernel)
    
    # Deblurring Algorithm
    #h = waitbar(0,'Deblurring Algorithm')
    index = 1
    for i in range(1, nr+1):
        for j in range(1, nc+1):
            for k in range (1, nt+1):
                index = index+1
                #waitbar(index/(nt*nc*nc),h)
                data_vettore = data[i,j,:,k]
                initial_estimate = np.dot(inverse_matrix, data_vettore)
    #            deblur = deconvlucy_asl(data_vettore,kernel,8,initial_estimate)
    #            deblur_image[i,j,:,k] = deblur
    #return deblur_image 

def asl_deblur_core(data_name,residual_name,mask_name,out_name,kernel="direct",sig=1,deblur_method="fft"):

    print('asl_deblur_core')
    print('Deblurring kernel: %s' % kernel)
    print('Deblurring method: %s' % deblur_method)

    # load the data
    print('Input data is: %s' % data_name)

    data_nii = nib.load(data_name)
    data = data_nii.get_data().astype(np.float64)
    resid_nii = nib.load(residual_name)
    resid = resid_nii.get_data().astype(np.float64)
    mask_nii = nib.load(mask_name)
    mask = mask_nii.get_data()
    
    #pad the data - 2 slices top and bottom
    data = np.pad(data, [(0, 0), (0, 0), (2, 2), (0, 0)], 'edge')

    maskser = np.sum(mask, (0, 1))
    nslices = np.sum(maskser>0) # number of slices that are non zero in mask

    flatmask = flattenmask(mask,nslices-2)
    # Commented out in MATLAB code
    # residser = zdeblur_make_series(resids,flatmask)
    thespecd = zdeblur_make_spec(resid,flatmask)
    #NB data has more slices than residuals
    kern = create_deblur_kern(thespecd,kernel,data.shape[2],sig)

    # deblur
    dataout = zdeblur_with_kern(data,kern,deblur_method)
    
    # discard padding
    dataout = dataout[:,:,2:-2,:]

    # save
    dataout_nii = nib.Nifti1Image(dataout, data_nii.get_header().get_best_affine(), data_nii.get_header())
    dataout_nii.to_filename(out_name)
    print('asl_deblur_core complete')

def deblur(options, tempdir, infile, mask, resids, outname, copyto):
    asl_deblur_core(infile, resids, mask, "%s/%s" % (tempdir, outname),
                    kernel=options.kernel, deblur_method=options.method)
    fsl.imcp("%s/%s" % (tempdir, outname), copyto)

def main():
    usage = """ASL_DEBLUR
    Correct T2 (z) blurring of GRASE-ASL

    asl_deblur -i <input> -m <mask> --matlab <path> [options]"""

    p = OptionParser(usage=usage, version="v0.1.0-2-g9aa28b5 (Thu Jan 25 10:43:07 2018)")
    p.add_option("--matlab", dest="matlab", help="Location to find MATLAB installation or MATLAB Compiler Runtime\nThe latter may be obtained from www.mathworks.com/products/complier")
    p.add_option("-i", dest="input", help="ASL data file")
    p.add_option("-o", dest="output", help="Output file name", default="asldata_deblur")
    p.add_option("-m", dest="mask", help="Mask (in native space of ASL data)")
    p.add_option("--kernel", dest="kernel", help="Deblurring kernel", default="direct")
    p.add_option("--method", dest="method", help="Deblurring method", default="fft")
    p.add_option("-c", dest="calib", help="Calibration image to deblur, if required")
    p.add_option("--calibout", dest="calibout", help="Output filename for deblurred calibration image")
    p.add_option("--debug", action="store_true", dest="debug", help="Enable debug mode", default=False)

    g = OptionGroup(p, "Supply existing residuals")
    g.add_option("--residuals", dest="residuals", help="Image containging the resdiuals from a model fit")
    p.add_option_group(g)

    g = OptionGroup(p, "Calculate residuals from model fit (using BASIL)")
    g.add_option("--tis", dest="tis", help="comma separated list of inversion times, e.g. --tis 0.2,0.4,0.6")
    g.add_option("--casl", action="store_true", dest="casl", default=False, help="Labelling was cASL rather than pASL")
    g.add_option("--bolus", type="float", dest="tau", help="Bolus duration", default=1)
    g.add_option("--t1", type="float", dest="t1", help="Tissue T1 value", default=1.3)
    g.add_option("--t1b", type="float", dest="t1b", help="Blood T1 value", default=1.6)
    g.add_option("--inferart", action="store_true", dest="inferart", default=False, help="Infer arterial signal - e.g. arterial suppression has not been applied")
    g.add_option("--infertau", action="store_true", dest="infertau", default=False, help="Infer bolus duration (otherwise it is fixed, e.g. by QUIPSSII or CASL)")
    p.add_option_group(g)

    options, args = p.parse_args()

    if options.debug:
        tempdir = os.path.join(os.getcwd(), "tmp_asl_deblur_py")
        fsl.mkdir(tempdir)
    else:
        tempdir = tempfile.mkdtemp("_asl_deblur")
    print("Using temporary dir: %s" % tempdir)

    infile = fsl.Image(options.input, "input")
    mask = fsl.Image(options.mask, "mask")

    if options.residuals is None:
        # Process using BASIL to get the residuals
        # Write options file for BASIL
        if options.tis is None:
            raise RuntimeError("No residuals specified, and no TIs to run BASIL either")
        tis = options.tis.split(",")
        tilist_args=""
        for idx, ti in enumerate(tis):
            tilist_args += "--ti%i=%s " % (idx+1, ti)

        tpoints = infile.shape[3]
        ntis = len(tis)
        if tpoints % ntis != 0:
            raise RuntimeError("%i TIs given, but input data has %i timepoints - not a multiple" % (ntis, tpoints))
        repeats = tpoints / ntis
        
        print("Number of inversion times: %i" % ntis)
        print("Number of timepoints in data: %i" % tpoints)
        print("Number of repeats in data: %i" % repeats)

        f = open(os.path.join(tempdir, "basil_options.txt"), "w")
        f.write("--t1=%.3f\n" % options.t1)
        f.write("--t1b=%.3f\n" % options.t1b)
        f.write("--tau=%.3f\n" % options.tau)
        f.write("--repeats=%i\n" % repeats)
        if options.casl: f.write("--casl\n")
        if options.inferart: f.write("--inferart\n")
        if options.infertau: f.write("--infertau\n")
        f.write("%s\n" % tilist_args)
        f.write("--save-residuals\n")
        f.close()

        print("Calling BASIL")
        fsl.Prog("basil").run("-i %s -o %s/basil -m %s -@ %s/basil_options.txt" % (options.input, tempdir, options.mask, tempdir))

        # Work out which is the final step from BASIL
        steps = glob.glob(os.path.join(tempdir, "basil/step*"))
        final_step = max([int(fname[-1]) for fname in steps])

        fsl.imcp("%s/basil/step%i/residuals" % (tempdir, final_step), "%s/residuals" % tempdir)
        fsl.imcp("%s/residuals" % tempdir, "%s/%s_residuals" % (tempdir, options.output))
    else:
        fsl.imcp(options.residuals, "%s/residuals" % tempdir)

    resid = fsl.Image("%s/residuals" % tempdir, "residuals")
    deblur(options, tempdir, infile.full, mask.full, resid.full, "deblurdata", options.output)

    # Also deblur the calibration image (if supplied)
    if options.calib:
        if options.calibout is None: options.calibout = "%s_deblur" % options.calib
        deblur(options, tempdir, options.calib, mask.full, resid.full, "calibdeblurdata", options.calibout)

    if not options.debug:
        pass
        #rm -r $tempdir

    print("Output is %s" % options.output)
    print("ASL_DEBLUR - done.")

if __name__ == "__main__":
    main()
    # Test
    #asl_deblur_core("/home/martinc/data/sub1/asldata_stacked.nii",
    #                "/home/martinc/data/sub1/residuals.nii.gz",
    #                "/home/martinc/data/sub1/mask.nii.gz",
    #                "out.nii", kernel="direct")

