%
%
% DESCRIPTION
% -----------
% This TOPMAL script can work with any cerebral small vassel disease
% (CSVD)-related lesions in DARTEL space. It will map these lesions to
% atlases, e.g., JHU WM and Harvard-Oxford subcortical atlases.
%
%
% DATA PREPARATION
% ----------------
% CSVD-related lesions need to be warpped to DARTEL space. The way of the
% warping, i.e., creating or existing template, should be the same as the
% DARtem input in the current function.
%
%
% USAGE
% -----
% DARles_folder = The folder containing the lesion masks in DARTEL space.
%                 All lesion masks should be renamed as "ID_lesMask.nii".
%                 It does not have to be under study_folder.
%
% study_folder = The folder where analyses will be carried out. Output will
%                be in the same structure as UBO Detector, etc. i.e.
%                .../study_folder/subjects/ID/...
%
% DARtem = either 'creating template' or 'existing template'. TOPMAL offers
%          two built-in DARTEL templates for OATS (ageRange = '65to75') and
%          Sydney MAS (ageRange = '70to80') which we used for older brains.
%          If your lesion masks are warpped to any of these two DARTEL
%          templates, you can specify DARtem = 'existing template' and the
%          corresponding ageRange. Otherwise, please use 'creating
%          template', and TOPMAL will ask for the Template1-6.nii generated
%          from DARTEL processing.
%
% atlasCode = 'JHU-ICBM_WM_tract_prob_1mm' or 'HO_subcortical_1mm'
%

function TOPMAL_generic (DARles_folder, ...
                         studyFolder, ...
                         DARtem, ...
                         ageRange, ...
                         spm12path, ...
                         atlasCode)

tic;

% add path
TOPMAL_folder = fileparts (mfilename ('fullpath'));
CNSP_folder = fileparts (TOPMAL_folder);
addpath (TOPMAL_folder, [CNSP_folder '/Scripts'], spm12path);


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

% get lesion images                     
DARles_list = dir ([DARles_folder '/*_lesMask.nii']);
[Nsubj, ~] = size (DARles_list);

% loop all subjects
parfor i = 1:Nsubj
    DARles_filenameParts = strsplit (DARles_list(i).name, '_');
    ID = DARles_filenameParts{1};
    
    % prepare image files
    system ([TOPMAL_folder '/TOPMAL_generic_prepareFiles.sh ' studyFolder ' ' ...
                                                              ID ' ' ...
                                                              DARles_folder]);
    switch atlasCode
        case 'JHU-ICBM_WM_tract_prob_1mm'
            atlasAbb = 'JHUwm';
        case 'HO_subcortical_1mm'
            atlasAbb = 'HOsub';
    end
    
    
        
    % backup losion mask, because it could be deleted if error happened when processing
%     fprintf ([ID ': Backup lesion map.\n']);
%     copyfile (DARTEL_lesionMask, [DARTEL_lesionMask '.backup'], 'f');

    % unzip lesion mask
%     [DARTEL_lesionMask_path, DARTEL_lesionMask_filename, DARTEL_lesionMask_ext] = fileparts (DARTEL_lesionMask);
% 
%     if exist ([DARTEL_lesionMask_path '/' DARTEL_lesionMask_filename], 'file') == 2
%         delete ([DARTEL_lesionMask_path '/' DARTEL_lesionMask_filename]);
%     end
% 
%     system (['gunzip ' DARTEL_lesionMask]);
    


    % calculate output
    fprintf ([ID ': Calculating output.\n']);
    DARTEL_lesionMask = [studyFolder '/subjects/' ID '/mri/orig/' ID '_lesMask.nii'];
    lesionOnAtlasImgOutput = [studyFolder '/subjects/' ID '/mri/TOPMAL/' ID '_lesionOn_' atlasAbb '_allprob.nii'];
    lesionLoadingOnAtlas = TOPMAL_calcOverlapVoxVol_unthrAtlas_allprob (DARTEL_lesionMask, ...
                                                                        DARTEL_threeD_dischargedAtlases, ...
                                                                        NatlasVols, ...
                                                                        lesionOnAtlasImgOutput);


    %zip back WMH mask
%     system (['gzip ' DARTEL_lesionMask]);


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


 % summarise TOPMAL results cohort-wise
fprintf ('Summarise TOPMAL results cohort-wise.\n');
% TOPMAL_summariseOutputInCohort_UDver (studyFolder, atlasCode, 'NA', excldList, 'allprob');
TOPMAL_summariseOutputInCohort_generic (studyFolder, DARles_folder, atlasCode, 'NA', 'allprob');



time_min = toc/60;
fprintf ('Finished. %.2f min\n', time_min);
	
end



