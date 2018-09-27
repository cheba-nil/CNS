%------------------
% CNSP_registration 
%------------------
%
% DESCRIPTION:
%   To register source image to reference image.
%
% INPUT:
%   srcImg = path to source image
%   refImg = path to reference image
%   outputFolder = path to the folder of the registered image
%   varargin{1} = other image
% 
% USAGE:
%   CNSP_registration (FLAIR,T1,'/home/ABC');
%

function CNSP_registration (srcImg, refImg, outputFolder, varargin)

    if nargin == 4
        otherImg = varargin{1};
    elseif nargin == 3
        otherImg = '';
    end

    if (nargin == 5) && strcmp(varargin{2}, 'NN')
        interp = 0;
        otherImg = varargin{1};
    elseif (nargin == 5) && strcmp(varargin{2}, 'Tri')
        interp = 1;
        otherImg = varargin{1};
    else
        interp = 4;
    end


    spm('defaults', 'fmri');
    spm_jobman('initcfg');
    
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {[refImg ',1']};
    matlabbatch{1}.spm.spatial.coreg.estwrite.source = {[srcImg ',1']};
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = {otherImg};
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = interp;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

    output = spm_jobman ('run',matlabbatch);
    
    % move coregistered source image to outputFolder
    [srcImgParentFolder, srcImgFilename, srcImgExt] = fileparts (srcImg);
    system (['mv ' srcImgParentFolder '/r' srcImgFilename srcImgExt ' ' outputFolder]);
