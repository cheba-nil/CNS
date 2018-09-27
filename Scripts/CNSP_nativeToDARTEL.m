%-----------------
% CNSP_mapToDARTEL
%-----------------
%
% DESCRIPTION:
%   To map image to DARTEL space
%
% INPUT:
%   srcImg = path to the image (*.nii) that will be mapped to DARTEL space
%   flowMap = flow map of srcImg
%   varargin{1} = 'Trilinear' or 'NN'
%
% OUTPUT:
%   srcImgOnDARTEL = srcImg mapped to DARTEL space
%
% USAGE:
%   srcImgOnDARTEL = CNSP_nativeToDARTEL (srcImg, flowMap)
%
% NOTE:
%   need to run CNSP_runDARTELe or CNSP_runDARTELc to generate flow map
%

function srcImgOnDARTEL = CNSP_nativeToDARTEL (srcImg, flowMap, varargin)

    [flowMapFolder,flowMapFilename,flowMapExt] = fileparts (flowMap);
    [srcImgFolder,srcImgFilename,srcImgExt] = fileparts (srcImg);
    
    if nargin == 3
        switch varargin{1}
            case 'Trilinear'
                interpCode = 1;
            case 'NN'
                interpCode = 0;
        end
    elseif nargin == 2
        interpCode = 1;
    end
    
    spm('defaults', 'fmri');
    spm_jobman('initcfg');

    matlabbatch{1}.spm.tools.dartel.crt_warped.flowfields = {flowMap};
    matlabbatch{1}.spm.tools.dartel.crt_warped.images = {
                                                         {srcImg}
                                                         }';
    matlabbatch{1}.spm.tools.dartel.crt_warped.jactransf = 0;
    matlabbatch{1}.spm.tools.dartel.crt_warped.K = 6;
    matlabbatch{1}.spm.tools.dartel.crt_warped.interp = interpCode;

    output = spm_jobman ('run',matlabbatch);
    
    srcImgOnDARTEL = [flowMapFolder '/w' srcImgFilename srcImgExt];

    % remove nan
    system (['gzip ' srcImgOnDARTEL]);
    system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
             'fslmaths ' srcImgOnDARTEL '.gz -nan ' flowMapFolder '/w' srcImgFilename]);
    system (['gunzip ' flowMapFolder '/w' srcImgFilename '.nii.gz']);