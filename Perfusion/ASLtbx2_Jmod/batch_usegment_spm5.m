% batch segmentation using the unified segmentation approach in spm5
% Toolbox for batch processing ASL perfusion based fMRI data.
% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
%segment spm
% apply segm to already normalized images

% Get subject etc parameters

close all;
global defaults;
spm_defaults;
defs = defaults.normalise;
PAR.SPM_path=spm('Dir');
%defs.write.vox= [1 1 1];
defs.write.vox= [1.5 1.5 1.5];

defs.write.bb=[-90 -126 -72;  90    90  108]; %[-84  -110   -60;  84    80  85];
clear jobs T1;
jobs{1}.spatial{1}.preproc.data{1} = char(['mprage.img,1' ]);
jobs{1}.spatial{1}.preproc.output.GM = reshape(double([0 0 0]),[1,3]);
jobs{1}.spatial{1}.preproc.output.WM = reshape(double([ 0 0 0 ]),[1,3]);
jobs{1}.spatial{1}.preproc.output.CSF = reshape(double([ 0 0 0 ]),[1,3]);
jobs{1}.spatial{1}.preproc.output.biascor = reshape(double([ 0 ]),[1,1]);
jobs{1}.spatial{1}.preproc.output.cleanup = reshape(double([ 0]),[1,1]);
%            |-tpm
jobs{1}.spatial{1}.preproc.opts.tpm{1,1} = char(fullfile(PAR.SPM_path, 'tpm','grey.nii'));
jobs{1}.spatial{1}.preproc.opts.tpm{2,1} = char(fullfile(PAR.SPM_path, 'tpm','white.nii'));
jobs{1}.spatial{1}.preproc.opts.tpm{3,1} = char(fullfile(PAR.SPM_path, 'tpm','csf.nii'));
jobs{1}.spatial{1}.preproc.opts.ngaus = reshape(double([ 2 2 2 4 ]),[1,4]);
jobs{1}.spatial{1}.preproc.opts.regtype = char(['mni']);
jobs{1}.spatial{1}.preproc.opts.warpreg = reshape(double([ 1]),[1,1]);
jobs{1}.spatial{1}.preproc.opts.warpco = reshape(double([25]),[1,1]);
jobs{1}.spatial{1}.preproc.opts.biasreg = reshape(double([ 0.0001 ]),[1,1]);
jobs{1}.spatial{1}.preproc.opts.biasfwhm = reshape(double([ 60]),[1,1]);
jobs{1}.spatial{1}.preproc.opts.samp = reshape(double([ 3 ]),[1,1]);
%            \-msk
jobs{1}.spatial{1}.preproc.opts.msk{1} = char(['']);

nsubs=length(PAR.subjects);
for sb = 1:PAR.nsubs
    sprintf('Batch normalization for #%u -th subject....',sb)
    
    P = spm_select('FPList',PAR.structdir{sb},['^' PAR.structprefs '.*\.nii$']);
    matfile = spm_select('FPList',PAR.structdir{sb}, ['.*seg_.*\.mat']);
    if exist(matfile, 'file') continue; end
    T1{1,1} = P(1,:);
    jobs{1}.spatial{:}.preproc.data=T1;
    spm_jobman('run',jobs);
end


for sb = 1:PAR.nsubs
    P = spm_select('FPList',PAR.structdir{sb},['^' PAR.structprefs '.*\.nii$']);
    P = P(1,:);
    imgs=spm_select('FPList', char(PAR.condirs{sb,c}), ['^meanCBF.*\.nii']);
    matname = [spm_str_manip(P,'sd') '_seg_sn.mat'];
    spm_write_sn(imgs, matname,defs.write,'');
end
