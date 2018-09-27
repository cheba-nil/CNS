% This function copy any necessary files for TOPMAL

function TOPMAL_cp_commonFiles_to_studyFolder (common_file, studyFolder, atlasProbThr, ageRange)

[map2atlasPath, ~, ~] = fileparts (which(mfilename));
[CNSPpath, ~, ~] = fileparts (map2atlasPath);

% chech if studyfolder/Atlases folder exists
if exist ([studyFolder '/Atlases'], 'dir') ~= 7
    [success, message, ~] = mkdir ([studyFolder '/subjects'], 'Atlases');
    if success == 0
        fprintf ('Error creating Atlases folder: %s\n', message);
    end
end

% copy common files
switch common_file
 

    %  ==========================
    %  cp rc123 for MNI152_T1_1mm
    %  ==========================
    case 'rc123_MNI152_T1_1mm'
        [rc1_cp_status, rc1_cp_msg, ~] = copyfile ([CNSPpath '/Templates/DARTEL_FSLatlases/rc123_MNI152_T1_1mm/rc1_MNI152_T1_1mm.nii.gz'], ...
                                                    [studyFolder '/subjects/Atlases'], ...
                                                    'f');
        [rc2_cp_status, rc2_cp_msg, ~] =  copyfile ([CNSPpath '/Templates/DARTEL_FSLatlases/rc123_MNI152_T1_1mm/rc2_MNI152_T1_1mm.nii.gz'], ...
                                                    [studyFolder '/subjects/Atlases'], ...
                                                    'f');
        [rc3_cp_status, rc3_cp_msg, ~] =  copyfile ([CNSPpath '/Templates/DARTEL_FSLatlases/rc123_MNI152_T1_1mm/rc3_MNI152_T1_1mm.nii.gz'], ...
                                                    [studyFolder '/subjects/Atlases'], ...
                                                    'f');
        if ~rc1_cp_status
            fprintf ('Error copying rc1: %s\n', rc1_cp_msg);
        elseif ~rc2_cp_status
            fprintf ('Error copying rc2: %s\n', rc2_cp_msg);
        elseif ~rc3_cp_status
            fprintf ('Error copying rc3: %s\n', rc3_cp_msg);
        end
                
        % gunzip
        CNSP_gunzipnii ([studyFolder '/subjects/Atlases/rc1_MNI152_T1_1mm.nii.gz'], [studyFolder '/subjects/Atlases']);
        CNSP_gunzipnii ([studyFolder '/subjects/Atlases/rc2_MNI152_T1_1mm.nii.gz'], [studyFolder '/subjects/Atlases']);
        CNSP_gunzipnii ([studyFolder '/subjects/Atlases/rc3_MNI152_T1_1mm.nii.gz'], [studyFolder '/subjects/Atlases']);
        
        fprintf ('rc123_MNI152_T1_1mm copied.\n');



    %  ========================================================================
    %  DARTEL thresholded atlases
    %  --- Not used in TOPMAL
    %  --- Used in TOMALwMAP (TOolbox for MApping Lesions with MAx Probability)
    %  ========================================================================
    case 'existing_DARTEL_MNIatlas_JHUwmTracts'
        DARTELatlas_gz = [CNSPpath ...
                            '/Templates/DARTEL_FSLatlases/DARTEL_FSLatlases_existingTemplates/' ...
                            'wJHU-ICBM-tracts-maxprob-thr' atlasProbThr '-1mm_' ageRange '.nii.gz'];
        copyfile (DARTELatlas_gz, [studyFolder '/subjects/Atlases'], 'f');
        CNSP_gunzipnii ([studyFolder '/subjects/Atlases/wJHU-ICBM-tracts-maxprob-thr' atlasProbThr '-1mm_' ageRange '.nii.gz']);
        
        fprintf ('existing_DARTEL_MNIatlas copied.\n');
        
    case 'existing_DARTEL_MNIatlas_HOsubcortical'
        DARTELatlas_gz = [CNSPpath ...
                            '/Templates/DARTEL_FSLatlases/DARTEL_FSLatlases_existingTemplates/' ...
                            'wHarvardOxford-sub-maxprob-thr' atlasProbThr '-1mm_' ageRange '.nii.gz'];
        copyfile (DARTELatlas_gz, [studyFolder '/subjects/Atlases'], 'f');
        CNSP_gunzipnii ([studyFolder '/subjects/Atlases/wHarvardOxford-sub-maxprob-thr' atlasProbThr '-1mm_' ageRange '.nii.gz']);
        
        fprintf ('existing_DARTEL_MNIatlas_HOsubcortical copied.\n');




    %  ========================================================================
    %  MNI thresholded atlases
    %  --- Not used in TOPMAL
    %  --- Used in TOMALwMAP (TOolbox for MApping Lesions with MAx Probability)
    %  ========================================================================
    case 'existing_MNI_thrJHUwmTracts'
        [status, atlas] = system (['ls ${FSLDIR}/data/atlases/JHU/JHU-ICBM-tracts-maxprob-thr' atlasProbThr '-1mm.nii.gz']);

        if status
            fprintf ('Error finding atlas: %s.\n', atlas);
        end

        copyfile (atlas, [studyFolder '/subjects/Atlases'], 'f');
        CNSP_gunzipnii ([studyFolder '/subjects/Atlases/JHU-ICBM-tracts-maxprob-thr' atlasProbThr '-1mm.nii.gz']);
        
    case 'existing_MNI_thrHOsubcortical'
        [status, atlas] = system (['ls ${FSLDIR}/data/atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr' atlasProbThr '-1mm.nii.gz']);

        if status
            fprintf ('Error finding atlas: %s.\n', atlas);
        end

        copyfile (atlas, [studyFolder '/subjects/Atlases'], 'f');
        CNSP_gunzipnii ([studyFolder '/subjects/Atlases/HarvardOxford-sub-maxprob-thr' atlasProbThr '-1mm.nii.gz']);





    %  ===============================================
    %  existing DARTEL discharged 3D atlases
    %  for existing ageRange (65to75, 70to80 and lt55)
    %  ===============================================
    case 'existing_DARTEL_MNIatlas_JHUwmTracts_allprob_discharged3D'
        for i = 1:20
            DARTELatlas_gz = [CNSPpath ...
                                '/Templates/DARTEL_FSLatlases/DARTEL_FSLatlases_existingTemplates/' ...
                                'wJHU-ICBM-tracts-prob-1mm_' num2str(i) '_' ageRange '.nii.gz'];

            copyfile (DARTELatlas_gz, [studyFolder '/subjects/Atlases'], 'f');
            CNSP_gunzipnii ([studyFolder '/subjects/Atlases/wJHU-ICBM-tracts-prob-1mm_' num2str(i) '_' ageRange '.nii.gz']);
        end
        
        fprintf ('existing_DARTEL_MNIatlas copied.\n');
        
        
    case 'existing_DARTEL_MNIatlas_HOsubcortical_allprob_discharged3D'
        
        for i = 1:21
            DARTELatlas_gz = [CNSPpath ...
                                '/Templates/DARTEL_FSLatlases/DARTEL_FSLatlases_existingTemplates/' ...
                                'wHarvardOxford-sub-prob-1mm_' num2str(i) '_' ageRange '.nii.gz'];

            copyfile (DARTELatlas_gz, [studyFolder '/subjects/Atlases'], 'f');

            CNSP_gunzipnii ([studyFolder '/subjects/Atlases/wHarvardOxford-sub-prob-1mm_' num2str(i) '_' ageRange '.nii.gz']);
        end
        
        fprintf ('existing_DARTEL_MNIatlas_HOsubcortical copied.\n');
        
        

        
    %  ===============================    
    %  existing MNI-to-DARTEL flow map
    %  ===============================
    case 'existing_MNI2DARTEL_flowMap'
        existingMNI2DARTELflowMap_gz = [CNSPpath ...
                                        '/Templates/DARTEL_FSLatlases/MNI2DARTEL_flowMaps/' ...
                                        'MNI2DARTEL_flowMap_' ageRange '.nii.gz'];
        copyfile (existingMNI2DARTELflowMap_gz, [studyFolder '/subjects/Atlases'], 'f');
        CNSP_gunzipnii ([studyFolder '/subjects/Atlases/MNI2DARTEL_flowMap_' ageRange '.nii.gz']);
        
        fprintf ('existing_MNI2DARTEL_flowMap copied.\n');
        



    %  ========================
    %  MNI_1mm probability maps
    %  --- Used in TOPMAL
    %  ========================
    case 'MNI_JHUwmTractsProb_1mm'
         [status, JHUwmTractsProb_gz] = system ('ls ${FSLDIR}/data/atlases/JHU/JHU-ICBM-tracts-prob-1mm.nii.gz');

         if status
             fprintf ('Error finding atlas: %s.\n', JHUwmTractsProb_gz);
         end

         copyfile (JHUwmTractsProb_gz, [studyFolder '/subjects/Atlases'], 'f');
         CNSP_gunzipnii ([studyFolder '/subjects/Atlases/JHU-ICBM-tracts-prob-1mm.nii.gz']);
         
    case 'MNI_HOsubcorticalProb_1mm'
        [status, atlasgz] = system ('ls ${FSLDIR}/data/atlases/HarvardOxford/HarvardOxford-sub-prob-1mm.nii.gz');

         if status
             fprintf ('Error finding atlas: %s.\n', atlasgz);
         end

         copyfile (atlasgz, [studyFolder '/subjects/Atlases'], 'f');
         CNSP_gunzipnii ([studyFolder '/subjects/Atlases/HarvardOxford-sub-prob-1mm.nii.gz']);
            
end
