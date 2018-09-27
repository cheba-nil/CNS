function CNSP_reorientImg (img, mx, prefix)

spm('defaults', 'fmri');
spm_jobman('initcfg');

% matlabbatch{1}.spm.util.reorient.srcfiles = {'/Users/jiyang/Desktop/sampleStudy/subjects/MAS0022/mri/extractedWMH/temp/MAS0022_t1_w4.nii,1'};
% matlabbatch{1}.spm.util.reorient.transform.transM = [-1 0 0 0
%                                                      0 1 0 0
%                                                      0 0 1 0
%                                                      0 0 0 1];
matlabbatch{1}.spm.util.reorient.srcfiles = {[img ',1']};
matlabbatch{1}.spm.util.reorient.transform.transM = mx;
matlabbatch{1}.spm.util.reorient.prefix = prefix;

output = spm_jobman ('run',matlabbatch);