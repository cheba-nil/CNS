function map2atlas_parallel_maxprob (studyFolder, DARtem, ageRange, spm12path, atlasCode, atlasProbThr, thrORunthr, excldList)
tic;

% stop scientific notation
format short

% add paths
[map2atlasPath, ~, ~] = fileparts (which(mfilename));
[CNSPpath, ~, ~] = fileparts (map2atlasPath);
addpath (map2atlasPath, [CNSPpath '/Scripts'], spm12path);

% get DARTEL atlas
switch thrORunthr
    case 'thr'
        DARTELatlas = getThresholdedDARTELatlas (studyFolder, DARtem, ageRange, spm12path, atlasCode, atlasProbThr);
        
    case 'unthr'
        DARTELatlas = getUnthresholdedDARTELatlas_maxprob (studyFolder, DARtem, ageRange, spm12path, atlasCode, atlasProbThr);
end

% prepare list of subjects
T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
[Nsubj,~] = size (T1folder);

excldIDs = strsplit (excldList, ' ');

% loop all subjects
parfor i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    if ismember(ID, excldIDs) == 0 
        % if WMH.nii.gz does not exist due to error in last run, copy
        % backup to WMH.nii.gz
        if exist ([studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii.gz'], 'file') ~= 2
            copyfile ([studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii.gz.backup'], ...
                       [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii.gz']);
        end
        DARTEL_lesionMask = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii.gz'];
        if exist ([studyFolder '/subjects/' ID '/mri/map2atlas'], 'dir') == 7
            rmdir ([studyFolder '/subjects/' ID '/mri/map2atlas'], 's');
        end
        [~, ~, ~] = mkdir ([studyFolder '/subjects/' ID '/mri/map2atlas']);
        switch atlasCode
            case 'JNU-ICBM_WM_tract_prob_1mm'
                atlasAbb = 'JHUwm';
            case 'HO_subcortical_1mm'
                atlasAbb = 'HOsub';
        end
        lesionOnAtlasImgOutput = [studyFolder '/subjects/' ID '/mri/map2atlas/' ID '_lesionOn_' atlasAbb '_maxprob' atlasProbThr '.nii'];
        
        % backup losion mask, because it could be deleted if error happened when processing
        fprintf ([ID ': Backup lesion map.\n']);
        copyfile (DARTEL_lesionMask, [DARTEL_lesionMask '.backup'], 'f');

        % unzip lesion mask
        [DARTEL_lesionMask_path, DARTEL_lesionMask_filename, DARTEL_lesionMask_ext] = fileparts (DARTEL_lesionMask);
        if strcmp (DARTEL_lesionMask_ext, '.gz')
            CNSP_gunzipnii (DARTEL_lesionMask);
            DARTEL_lesionMask = [DARTEL_lesionMask_path '/' DARTEL_lesionMask_filename];
        end

        % calculate output
        fprintf ([ID ': Calculating output.\n']);
        
        switch thrORunthr
            case 'thr'
                Nvoxs_Vol_onAtlas = calcOverlapVoxVol_thrAtlas (DARTEL_lesionMask, DARTELatlas, atlasCode, lesionOnAtlasImgOutput);       
            case 'unthr'
                Nvoxs_Vol_onAtlas = calcOverlapVoxVol_unthrAtlas_maxprob (DARTEL_lesionMask, DARTELatlas, atlasCode, lesionOnAtlasImgOutput);
        end

        % gunzip WMH for storage and future re-processing
        system (['${FSLDIR}/bin/fslchfiletype NIFTI_GZ ' DARTEL_lesionMask]);

        % write Nvoxs and Vol to csv file
        fprintf ([ID ': Writing to textfile.\n']);
        [lesionOnAtlasImgOutput_path, lesionOnAtlasImgOutput_filename, ~] = fileparts (lesionOnAtlasImgOutput);
        csvOutput = [lesionOnAtlasImgOutput_path '/' lesionOnAtlasImgOutput_filename '.dat'];

        if exist (csvOutput, 'file') == 2
            delete (csvOutput);
        end
        csvwrite (csvOutput, Nvoxs_Vol_onAtlas);
        
        % save a copy of csv in ID/stats
        copyfile (csvOutput, [studyFolder '/subjects/' ID '/stats/' ID '_map2atlas_' atlasAbb '_' atlasProbThr '.dat'], 'f');
    end
end


% summarise map2atlas results cohort-wise
fprintf ('Summarise map2atlas results cohort-wise.\n');
summariseOutputInCohort (studyFolder, atlasCode, atlasProbThr, excldList);

time_min = toc/60;
fprintf ('Finished. %.2f min\n', time_min);