% Spatial normalization using the new segmentation algorithm
% This scripts include two step: estimation (brain segmentation) and writing. The first part can
% be used for structural image analysis such as VBM.
% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
%
% Get subject etc parameters

close all;
global defaults;
spm_defaults;
defs = defaults.normalise;
PAR.SPM_path=spm('Dir');

% defs.write.vox= [1.5 1.5 1.5];

% defs.write.bb=[-84  -110   -60
%     84    80  85];
clear matlabbatch subs;

nP=[];
for sb = 1:PAR.nsubs
    sprintf('Batch normalization for #%u -th subject....',sb)
    P=spm_select('ExtFPList',PAR.structdir{sb},['^' PAR.structprefs '.*\.nii$']);
    matname = fullfile(PAR.structdir{sb}, ['y_' spm_str_manip(P,'dst') '.nii']);
    if exist(matname, 'file')==0
        nP=strvcat(nP, P);
    end
end
%ASLtbx_spm12normest(nP);
ASLtbx_spmnsegment(nP);
