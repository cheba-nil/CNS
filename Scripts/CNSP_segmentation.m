%------------------
% CNSP_segmentation
%------------------
%
% DESCRIPTION:
%   To segment input image into GM, WM and CSF (probability maps).
%
% INPUT:
%   inputImg = path to the image to be segmented
%   spm12path = path to SPM12
%
% OUTPUT:
%   cGM = path to c1* image
%   cWM = path to c2* image
%   cCSF = path to c3* image
%   rcGM = path to rc1* image
%   rcWM = path to rc2* image
%   rcCSF = path to rc3* image
%   varargout{1} = *_seg8.mat
%
% USAGE:
%   [cGM,cWM,cCSF,rcGM,rcWM,rcCSF] = CNSP_segmentation (inputImg,spm12path)
%   [cGM,cWM,cCSF,rcGM,rcWM,rcCSF,seg8mat] = CNSP_segmentation (inputImg,spm12path)
%

function [cGM,cWM,cCSF,rcGM,rcWM,rcCSF,varargout] = CNSP_segmentation (inputImg, spm12path)

    addpath (spm12path);

    [inputImgFolder,inputImgFilename,inputImgExt] = fileparts(inputImg);

    spm('defaults', 'fmri');
    spm_jobman('initcfg');


    volume = [inputImg ',1'];
    tpm1 = strcat (spm12path, '/tpm/TPM.nii,1');
    tpm2 = strcat (spm12path, '/tpm/TPM.nii,2');
    tpm3 = strcat (spm12path, '/tpm/TPM.nii,3');
    tpm4 = strcat (spm12path, '/tpm/TPM.nii,4');
    tpm5 = strcat (spm12path, '/tpm/TPM.nii,5');
    tpm6 = strcat (spm12path, '/tpm/TPM.nii,6');

    matlabbatch{1}.spm.spatial.preproc.channel.vols = {volume};
    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {tpm1};
    matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {tpm2};
    matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {tpm3};
    matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {tpm4};
    matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {tpm5};
    matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {tpm6};
    matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];

    output = spm_jobman ('run',matlabbatch);
    
    cGM = [inputImgFolder '/c1' inputImgFilename inputImgExt];
    cWM = [inputImgFolder '/c2' inputImgFilename inputImgExt];
    cCSF = [inputImgFolder '/c3' inputImgFilename inputImgExt];
    
    rcGM = [inputImgFolder '/rc1' inputImgFilename inputImgExt];
    rcWM = [inputImgFolder '/rc2' inputImgFilename inputImgExt];
    rcCSF = [inputImgFolder '/rc3' inputImgFilename inputImgExt];
    
    varargout{1} = [inputImgFolder '/' inputImgFilename '_seg8.mat'];
    
    