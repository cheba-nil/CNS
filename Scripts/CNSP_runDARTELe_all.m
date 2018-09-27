%--------------------
% CNSP_runDARTELe_all
%--------------------
%
% DESCRIPTION:
%   run DARTEL with existing template (run all subjects together)
%
% INPUT:
%   N = number of input subjects
%   template(1:6) = existing template 1-6 (template 0 is not used)
%   rcGMCellArr_col = a column cell array containing rc1 paths
%   rcWMCellArr_col = a column cell array containing rc2 paths
%   rcCSFCellArr_col = a column cell array containing rc3 paths
%
% OUTPUT:
%   flowMapCellArr = cell array containing flow map for each input subject
%
% USAGE:
%   flowMapCellArr = CNSP_runDARTELe_all(...
%                                       N,...
%                                       template1,template2,template3,template4,template5,template6,...
%                                       rcGMcolumnCellArray,...
%                                       rcWMcolumnCellArray,...
%                                       rcCSFcolumnCellArray,
%                                       );
%
% NOTE:
%   parallel computing (parfor) is used.
%

function flowMapCellArr = CNSP_runDARTELe_all (N,...
                                                template1,...
                                                template2,...
                                                template3,...
                                                template4,...
                                                template5,...
                                                template6,...
                                                rcGMCellArr_col,...
                                                rcWMCellArr_col,...
                                                rcCSFCellArr_col...
                                                )
%% input
if nargin ~= 8
    error ('Incorrect number of input arguments.');
end

rcCellArr = {
             rcGMCellArr_col
             rcWMCellArr_col
             rcCSFCellArr_col
             };

%% SPM
spm('defaults', 'fmri');
         
matlabbatch{1}.spm.tools.dartel.warp1.images = rcCellArr;
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


%% output
flowMapCellArr = cell (N,1);

parfor j = 1:N
    [rc1folder,rc1filename,rc1ext] = fileparts(rcGMCellArr_col{j,1});
    flowMapCellArr{j,1} = [rc1folder '/u_' rc1filename rc1ext];
end

