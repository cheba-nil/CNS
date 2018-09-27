function DARTELatlas = getThresholdedDARTELatlas (studyFolder, DARtem, ageRange, spm12path, atlasCode, atlasProbThr)

% add paths
[map2atlasPath, ~, ~] = fileparts (which(mfilename));
[CNSPpath, ~, ~] = fileparts (map2atlasPath);
addpath (map2atlasPath, [CNSPpath '/Scripts'], spm12path);

% Select DARTEL template
switch DARtem
    case 'creating template'
        createdDARtem = spm_select (6,...
                                    'image',...
                                    'Select Template 1-6 from created template DARTEL processing ...',...
                                    {},...
                                    pwd,...
                                    '.nii*',...
                                    [1 1 1 1 1 1]);
                                
        % copy 'rc123_MNI152_T1_1mm' images to study folder
        cp_commonFiles_to_studyFolder ('rc123_MNI152_T1_1mm', studyFolder, 'NA', 'NA');
        
        % remove ,1 from the end of image name
        Template1 = strsplit (createdDARtem(1,:),',');
        Template2 = strsplit (createdDARtem(2,:),',');
        Template3 = strsplit (createdDARtem(3,:),',');
        Template4 = strsplit (createdDARtem(4,:),',');
        Template5 = strsplit (createdDARtem(5,:),',');
        Template6 = strsplit (createdDARtem(6,:),',');
        
        % run DARTEL with existing templates
        fprintf ('Generating MNI-to-DARTEL flow map.\n');
        flowMap = CNSP_runDARTELe ([studyFolder '/subjects/Atlases/rc1_MNI152_T1_1mm.nii'], ...
                                    [studyFolder '/subjects/Atlases/rc2_MNI152_T1_1mm.nii'], ...
                                    [studyFolder '/subjects/Atlases/rc3_MNI152_T1_1mm.nii'], ...
                                    Template1{1}, ...
                                    Template2{1}, ...
                                    Template3{1}, ...
                                    Template4{1}, ...
                                    Template5{1}, ...
                                    Template6{1});
                                
         % pre-processing (sort out) the selected atlas
         fprintf ('Sorting out seleted atlas for following processing.\n');
         MNIatlas = getMNIatlas_thr (studyFolder, atlasCode, atlasProbThr);
         
         % apply flow map, bring to DARTEL
         fprintf ('Register to DARTEL with the flow map.\n');
         DARTELatlas = CNSP_nativeToDARTEL (MNIatlas, flowMap, 'NN');
                                
         
    case 'existing template'
        
        % if thr = 0,25,50, use existing wATLAS_ageRange
        if strcmp (atlasProbThr, '0') || strcmp (atlasProbThr, '25') || strcmp (atlasProbThr, '50')
            switch atlasCode
                % JHU WM tract map - existing (0, 25, 50)
                case 'JNU-ICBM_WM_tract_prob_1mm'
                    % copy DARTELatlas to subjects/Atlas
                    cp_commonFiles_to_studyFolder ('existing_DARTEL_MNIatlas_JHUwmTracts', studyFolder, atlasProbThr, ageRange);
                    % output
                    DARTELatlas = [studyFolder '/subjects/Atlases/wJHU-ICBM-tracts-maxprob-thr' atlasProbThr '-1mm_' ageRange '.nii'];
                
                % Harvard-Oxford subcortical 1mm
                case 'HO_subcortical_1mm'
                    % copy DARTELatlas to subjects/Atlas
                    cp_commonFiles_to_studyFolder ('existing_DARTEL_MNIatlas_HOsubcortical', studyFolder, atlasProbThr, ageRange);
                    % output
                    DARTELatlas = [studyFolder '/subjects/Atlases/wHarvardOxford-sub-maxprob-thr' atlasProbThr '-1mm_' ageRange '.nii'];
            end
        
        % if thr != 0,25,50, use existing flowMap to apply to customised
        % atlas with user defined thr.
        else
            
            % copy flowMap to subjects/Atlas
            cp_commonFiles_to_studyFolder ('existing_MNI2DARTEL_flowMap', studyFolder, atlasProbThr, ageRange);
            existingMNI2DARTELflowMap = [studyFolder '/subjects/Atlases/MNI2DARTEL_flowMap_' ageRange '.nii'];
            % threshold MNI atlas to generate selected atlas
            MNIatlas = getMNIatlas_thr (studyFolder, atlasCode, atlasProbThr);
            % output
            DARTELatlas = CNSP_nativeToDARTEL (MNIatlas, existingMNI2DARTELflowMap, 'NN');
        end
end