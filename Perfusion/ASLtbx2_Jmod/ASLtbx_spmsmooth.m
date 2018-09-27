function ASLtbx_spmsmooth(files, ker, prefix)
%-----------------------------------------------------------------------
% Job saved on 03-May-2015 22:44:15 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
% Input: files -  a string array containing all images,
%        ker - smoothing kernel size,
%        prefix - prefix for the output image.
% Output will be a 4D image.
% Saved by Ze Wang, May 3rd 2015
%-----------------------------------------------------------------------
if prod(size(ker))==1, ker=[ker ker ker]; end
for i=1:size(files,1)
    data{i,:}=deblank(files(i,:));
end
matlabbatch{1}.spm.spatial.smooth.data = data;
matlabbatch{1}.spm.spatial.smooth.fwhm = ker;
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = prefix;
cfg_util('run', matlabbatch);