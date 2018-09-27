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


matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72;  90    90  108]; %[-78 -112 -70; 78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
for sb = 1:PAR.nsubs
    P = spm_select('FPList',PAR.structdir{sb},['^' PAR.structprefs '.*\.nii$']);
    P = P(1,:);
    
    imgs{1,1}=spm_select('FPList', char(PAR.condirs{sb}), ['^cmeanCBF.*\.nii']);
    %%% if you want to normalize the cbf image series, you can enable the
    %%% following lines
%     cbfimgs=spm_select('EXTFPList', char(PAR.condirs{sb,c}), ['^cbf_.*\.nii'], 1:1000);
%     for i=1:size(cbfimgs,1)
%         imgs{1+i,1}=deblank(cbfimgs(i,:));
%     end
    
    % Make the default normalization parameters file name
    matname = fullfile(PAR.structdir{sb}, ['y_' spm_str_manip(P,'dst') '.nii']);
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.def{1} =matname;
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = imgs;
    cfg_util('run', matlabbatch);
end
clear matlabbatch;