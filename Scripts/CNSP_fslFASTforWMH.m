%-------------------
% CNSP_fslFASTforWMH
%-------------------
%
% DESCRIPTION:
%   run FSL FAST to segment image to seg0, seg1, and seg2 for WMH
%   extraction
%
% INPUT:
%   srcImg_NBTR = path to the image that will be segmented. The image needs
%   to be skull-stripped.
%   output = path to output image
%
% OUTPUT:
%   restoreImg = intensity normalised srcImg_NBTR.
%   seg0 = seg0 of srcImg_NBTR
%   seg1 = seg1 of srcImg_NBTR
%   seg2 = seg2 of srcImg_NBTR
%   varargout{1} = seg
%   varargout{2} = pve_0
%   varargout{3} = pve_1
%   varargout{4} = pve_2
%   varargout{5} = pveseg
%   varargout{6} = mixeltype
%
% USAGE:
%   [restoreImg, seg0, seg1, seg2] = CNSP_fslFASTforWMH (srcImg_NBTR, output)
%   [restoreImg, seg0, seg1, seg2, seg] = CNSP_fslFASTforWMH (srcImg_NBTR, output)
%   [restoreImg, seg0, seg1, seg2, seg, pve_0, pve_1, pve_2, pveseg, mixeltype] = CNSP_fslFASTforWMH (srcImg_NBTR, output)
%
% NOTE:
%   use non-brain tissue removed FLAIR as input
%


function [restoreImg, seg0, seg1, seg2, varargout] = CNSP_fslFASTforWMH (srcImg_NBTR, output)

    % get scripts folder
    [scriptsFolder,currMfilename,ext] = fileparts(which([mfilename '.m']));
    
    % get output folder
    [outputFolder,outputFilename,outputExt] = fileparts (output);
    
    system (['chmod +x ' scriptsFolder '/CNSP_fslFASTforWMH.sh']);
    
    % FSL FAST
    system ([scriptsFolder '/CNSP_fslFASTforWMH.sh ' outputFolder '/' outputFilename ' ' srcImg_NBTR]);
    
    [~,restoreImg] = system (['ls ' outputFolder '/' outputFilename '_restore.nii*']);
    [~,seg0] = system (['ls ' outputFolder '/' outputFilename '_seg_0.nii*']);
    [~,seg1] = system (['ls ' outputFolder '/' outputFilename '_seg_1.nii*']);
    [~,seg2] = system (['ls ' outputFolder '/' outputFilename '_seg_2.nii*']);
    

    [~,varargout{1}] = system (['ls ' outputFolder '/' outputFilename '_seg.nii*']);
    [~,varargout{2}] = system (['ls ' outputFolder '/' outputFilename '_pve_0.nii*']);
    [~,varargout{3}] = system (['ls ' outputFolder '/' outputFilename '_pve_1.nii*']);
    [~,varargout{4}] = system (['ls ' outputFolder '/' outputFilename '_pve_2.nii*']);
    [~,varargout{5}] = system (['ls ' outputFolder '/' outputFilename '_pveseg.nii*']);
    [~,varargout{6}] = system (['ls ' outputFolder '/' outputFilename '_mixeltype.nii*']);
    
    