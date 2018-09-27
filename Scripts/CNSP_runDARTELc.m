%----------------
% CNSP_runDARTELc
%----------------
%
% DESCRIPTION:
%   creating template DARTEL run
%
% INPUT:
%   N = number of subjects
%
%   for i = 0:(N-1)
%       varargin{i*3+1} = path to rcGM
%       varargin{i*3+2} = path to rcWM
%       varargin{i*3+3} = path to rcCSF
%
% OUTPUT:
%   flowMap = cell array containing path to each subject's flow map
%   varargout {1:7} = Template_{0-6}.nii
%
% USAGE:
%   flowMapCellArr = CNSP_runDARTELc (N,...
%                                      rcGMcellArr_col,...
%                                      rcWMcellArr_col,...
%                                      rcCSFcellArr_col);
%
%   [flowMapCellArr,T0,T1,T2,T3,T4,T5,T6] = CNSP_runDARTELc (N,...
%                                                            rcGMcellArr_col,...
%                                                            rcWMcellArr_col,...
%                                                            rcCSFcellArr_col);
%
% NOTE:
%   need to run CNSP_segmentation to generate rcGM, rcWM, and rcCSF
%



function [flowMapCellArr,varargout] = CNSP_runDARTELc (N, ...
                                                        rcGMcellArr_col, rcWMcellArr_col, rcCSFcellArr_col)
    
    %% input
    if nargin ~= 4
        error ('incorrect number of input arguments.');
    end
    
    %% SPM
    spm('defaults', 'fmri');
    matlabbatch{1}.spm.tools.dartel.warp.images = {
                                                    rcGMcellArr_col
                                                    rcWMcellArr_col
                                                    rcCSFcellArr_col
                                                  };
    matlabbatch{1}.spm.tools.dartel.warp.settings.template = 'Template';
    matlabbatch{1}.spm.tools.dartel.warp.settings.rform = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).K = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).slam = 16;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).K = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).slam = 8;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).K = 1;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).slam = 4;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).K = 2;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).slam = 2;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).K = 4;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).slam = 1;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).K = 6;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.cyc = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.its = 3;
    
    output = spm_jobman ('run',matlabbatch);

    
    %% output
    [rcGM1folder,~,~] = fileparts(rcGMcellArr_col{1,1});
    flowMapCellArr = cell(N,1);
    
    for i = 1:N
        [curr_rcGMfolder,curr_rcGMfilename,~] = fileparts(rcGMcellArr_col{i,1});
        flowMapCellArr {i,1} = [curr_rcGMfolder '/u_' curr_rcGMfilename '_Template.nii'];
    end
    
    varargout{1} = [rcGM1folder '/Template_0.nii'];
    varargout{2} = [rcGM1folder '/Template_1.nii'];
    varargout{3} = [rcGM1folder '/Template_2.nii'];
    varargout{4} = [rcGM1folder '/Template_3.nii'];
    varargout{5} = [rcGM1folder '/Template_4.nii'];
    varargout{6} = [rcGM1folder '/Template_5.nii'];
    varargout{7} = [rcGM1folder '/Template_6.nii'];



    
    