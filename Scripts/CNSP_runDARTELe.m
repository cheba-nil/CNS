
%----------------
% CNSP_runDARTELe
%----------------
% DESCRIPTION:
%   run DARTEL with existing template (run one subject at a time)
%
% INPUT:
%   rcGM = path to GM segmentation (rc1*.nii)
%   rcWM = path to WM segmentation (rc2*.nii)
%   rcCSF = path to CSF segmentation (rc3*.nii)
%   template 1-6 = path to the existing template 1-6 (template 0 is not used)
%
% OUTPUT:
%   flowMap = path to flow map
%
% USAGE:
%   flowMap = CNSP_runDARTELe (rcGM, rcWM, rcCSF, ...
%                              template1, template2, template3, template4, template5, template6)
% NOTE:
%   need to run CNSP_segmentation to generate rcGM, rcWM, and rcCSF
%


function flowMap = CNSP_runDARTELe (rcGM, rcWM, rcCSF, template1, template2, template3, template4, template5, template6)

    spm_jobman('initcfg');

    matlabbatch{1}.spm.tools.dartel.warp1.images = {
                                            {[rcGM ',1']}
                                            {[rcWM ',1']}
                                            {[rcCSF ',1']}
                                            }';
    matlabbatch{1}.spm.tools.dartel.warp1.settings.rform = 0;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).rparam = [4 2 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).K = 0;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).template = {template1};
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).rparam = [2 1 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).K = 0;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).template = {template2};
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).rparam = [1 0.5 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).K = 1;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).template = {template3};
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).rparam = [0.5 0.25 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).K = 2;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).template = {template4};
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).rparam = [0.25 0.125 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).K = 4;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).template = {template5};
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).rparam = [0.25 0.125 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).K = 6;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).template = {template6};
    matlabbatch{1}.spm.tools.dartel.warp1.settings.optim.lmreg = 0.01;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.optim.cyc = 3;
    matlabbatch{1}.spm.tools.dartel.warp1.settings.optim.its = 3;

    output = spm_jobman ('run',matlabbatch);
    
    [rcGMfolder,rcGMfilename,rcGMext] = fileparts(rcGM);
    flowMap = [rcGMfolder '/u_' rcGMfilename rcGMext];
    
    

   