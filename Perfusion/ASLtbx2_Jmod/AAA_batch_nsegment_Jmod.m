% Spatial normalization using the new segmentation algorithm
% This scripts include two step: estimation (brain segmentation) and writing. The first part can
% be used for structural image analysis such as VBM.
% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
%
% Get subject etc parameters
%
% Jmod: this script is to segment c123 - not needed as has been done in previous steps.
%
%

% close all;
global defaults;
defaults=spm_get_defaults;
global PAR;

defs = defaults.normalise;
PAR.SPM_path=spm('Dir');

% defs.write.vox= [1.5 1.5 1.5];

% defs.write.bb=[-84  -110   -60
%     84    80  85];
clear matlabbatch subs;

ASLtbx2_Jmod_folder = fileparts (mfilename ('fullpath'));

% nP=[];
T1list = [];
parfor sb = 1:PAR.Nids
    sprintf ('Segmenting #%u -th subject....',sb);

    T1 = spm_select ('ExtFPList',PAR.T1folder{sb},['^' PAR.T1prefs{sb} '\.nii$']);

    % y_T1.nii - what is it used for?
    % system (['cp ' ASLtbx2_Jmod_folder '/y_T1.nii ' PAR.T1folder{sb}]);
    % matname = fullfile(PAR.T1folder{sb}, '^y_T1\.nii$'); % what is this y_T1.nii used for?



    % if exist(matname, 'file')==0
    %     nP=strvcat(nP, P);
    % end
    T1list = strvcat (T1list, T1)
end
%ASLtbx_spm12normest(nP);
ASLtbx_spmnsegment(T1list);
