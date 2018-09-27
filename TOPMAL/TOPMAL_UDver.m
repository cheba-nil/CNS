%
% TOPMAL_UDver.m
%
% -----------
% DESCRIPTION
% -----------
% TOolbox for Probabilistic MApping of Lesions (TOPMAL) is a toolbox for probabilistic mapping of
% cerebral small vessel disease (CSVD)-related lesions to atlases (e.g. JHU WM atlas and Harvard-Oxford subcortical atlas)
% to perform lesion-symptom mapping (LSM) analyses (Biesbroek 2017, Clinical Science).
% 
% This version of TOPMAL runs on UBO Detector-generated WMH. It requires the folder structure
% was kept after running UBO Detector.
%
%
% ----------------
% DATA PREPARATION
% ----------------
% This script runs on UBO Detector output.
%
% 
% -----
% USAGE
% -----
% studyFolder = the study folder when running UBO Detector.
% DARtem = DARTEL template (either 'creating template' or 'existing template'). This needs to be the same method/option as 
%                                                                               the one used for processing with UBO Detector
% ageRange = '65to75' or '70to80' (need to implement lt55 later)
% spm12path = path to spm12
% atlasCode = 'JHU-ICBM_WM_tract_prob_1mm' or 'HO_subcortical_1mm'
% excldList = excluded IDs separated by a space.
%
%
% -----------------------------------------------
% Written by Dr. Jiyang Jiang
% -- First version (August 2017)
% -- Updated in March 2017 after paper published
% -----------------------------------------------
%
% -----------------------------------------------
% Citation
%
% -- If you used this script, please cite:
%
% -- If you also used UBO Detector, please also cite:
%
% Jiyang Jiang, Tao Liu, Wanlin Zhu, Rebecca Koncz, Hao Liu, Teresa Lee, Perminder S. Sachdev, Wei Wen
% "UBO Detector – A cluster-based, fully automated pipeline for extracting white matter hyperintensities"
% NeuroImage, doi.org/10.1016/j.neuroimage.2018.03.050
% 
%



function TOPMAL_UDver (studyFolder, DARtem, ageRange, spm12path, atlasCode, excldList)
tic;

% stop scientific notation
format long

% add paths
[TOPMALpath, ~, ~] = fileparts (which(mfilename));
[CNSPpath, ~, ~] = fileparts (TOPMALpath);
addpath (TOPMALpath, [CNSPpath '/Scripts'], spm12path);


% clear studyFolder/subjects/Atlases
if exist ([studyFolder '/subjects/Atlases'], 'dir') == 7
    system (['rm -f ' studyFolder '/subjects/Atlases/*']);
end

% get DARTEL atlas
[NatlasVols, DARTEL_threeD_dischargedAtlases] = TOPMAL_getUnthresholdedDARTELatlas_allprob (studyFolder, ...
                                                                                            DARtem, ...
                                                                                            ageRange, ...
                                                                                            spm12path, ...
                                                                                            atlasCode);


% read DARTEL 3D atlases into memory
% DARTEL_threeD_dischargedAtlases_dataPart = cell (Nvols, 1);
% parfor j = 1:Nvols
%     DARTEL_threeD_dischargedAtlases_vol = spm_vol (DARTEL_threeD_dischargedAtlases);
%     DARTEL_threeD_dischargedAtlases_dataPart{j,1} = spm_read_vols (DARTEL_threeD_dischargedAtlases_vol);
% end


% prepare list of subjects
T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
[Nsubj,~] = size (T1folder);

excldIDs = strsplit (excldList, ' ');

% loop all subjects
parfor i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    if ismember(ID, excldIDs) == 0 
        % WMH.nii.gz may be eliminated if an error occurred in last TOPMAL run, therefore copy
        % backup to WMH.nii.gz
        if exist ([studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii.gz'], 'file') ~= 2
            copyfile ([studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii.gz.backup'], ...
                       [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii.gz']);
        end
        
        DARTEL_lesionMask = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii.gz'];
        
        if exist ([studyFolder '/subjects/' ID '/mri/TOPMAL'], 'dir') == 7
            rmdir ([studyFolder '/subjects/' ID '/mri/TOPMAL'], 's');
        end
        
        [~, ~, ~] = mkdir ([studyFolder '/subjects/' ID '/mri/TOPMAL']);
        
        switch atlasCode
            case 'JHU-ICBM_WM_tract_prob_1mm'
                atlasAbb = 'JHUwm';
            case 'HO_subcortical_1mm'
                atlasAbb = 'HOsub';
        end
        
        lesionOnAtlasImgOutput = [studyFolder '/subjects/' ID '/mri/TOPMAL/' ID '_lesionOn_' atlasAbb '_allprob.nii'];
        
        % backup losion mask, because it could be deleted if error happened when processing
        fprintf ([ID ': Backup lesion map.\n']);
        copyfile (DARTEL_lesionMask, [DARTEL_lesionMask '.backup'], 'f');

        % unzip lesion mask
        [DARTEL_lesionMask_path, DARTEL_lesionMask_filename, DARTEL_lesionMask_ext] = fileparts (DARTEL_lesionMask);
        
        if exist ([DARTEL_lesionMask_path '/' DARTEL_lesionMask_filename], 'file') == 2
            delete ([DARTEL_lesionMask_path '/' DARTEL_lesionMask_filename]);
        end

        system (['gunzip ' DARTEL_lesionMask]);
        DARTEL_lesionMask = [DARTEL_lesionMask_path '/' DARTEL_lesionMask_filename];


        % calculate output
        fprintf ([ID ': Calculating output.\n']);
        
        lesionLoadingOnAtlas = TOPMAL_calcOverlapVoxVol_unthrAtlas_allprob (DARTEL_lesionMask, ...
                                                                            DARTEL_threeD_dischargedAtlases, ...
                                                                            NatlasVols, ...
                                                                            lesionOnAtlasImgOutput);
        
        
        %zip back WMH mask
        system (['gzip ' DARTEL_lesionMask]);
        
        
        % write loading measures to csv file
        fprintf ([ID ': Writing to textfile.\n']);
        [lesionOnAtlasImgOutput_path, lesionOnAtlasImgOutput_filename, ~] = fileparts (lesionOnAtlasImgOutput);
        csvOutput = [lesionOnAtlasImgOutput_path '/' lesionOnAtlasImgOutput_filename '.dat'];

        if exist (csvOutput, 'file') == 2
            delete (csvOutput);
        end
        csvwrite (csvOutput, lesionLoadingOnAtlas);
        
        
        % save a copy of csv in ID/stats
        if exist ([studyFolder '/subjects/' ID '/stats'], 'dir') ~= 7
            mkdir ([studyFolder '/subjects/' ID], 'stats');
        end
        copyfile (csvOutput, ...
                  [studyFolder '/subjects/' ID '/stats/' ID '_TOPMAL_' atlasAbb '_allprob.dat'], 'f');
        
    end
end


 % summarise TOPMAL results cohort-wise
fprintf ('Summarise TOPMAL results cohort-wise.\n');
TOPMAL_summariseOutputInCohort_UDver (studyFolder, atlasCode, 'NA', excldList, 'allprob');



time_min = toc/60;
fprintf ('Finished. %.2f min\n', time_min);