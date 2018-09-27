function ASLtbx_spm12normest(strucimg)
% normalization using SPM12. The new segmentation algorithm was used.
% saved by Ze Wang. May 3 2015

clear matlabbatch subs;

matlabbatch{1}.spm.spatial.normalise.est.eoptions.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.normalise.est.eoptions.biasfwhm = 60;
matlabbatch{1}.spm.spatial.normalise.est.eoptions.tpm = {fullfile(spm('Dir'), 'tpm','TPM.nii')}; 
matlabbatch{1}.spm.spatial.normalise.est.eoptions.affreg = 'mni';
matlabbatch{1}.spm.spatial.normalise.est.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.normalise.est.eoptions.fwhm = 0;
matlabbatch{1}.spm.spatial.normalise.est.eoptions.samp = 3;
for i=1:size(strucimg,1)
    subs(i).vol{1} = deblank(strucimg(i,:));
end
matlabbatch{1}.spm.spatial.normalise.est.subj=subs;
cfg_util('run', matlabbatch);