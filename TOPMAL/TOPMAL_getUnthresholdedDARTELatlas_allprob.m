% Get the atlas in DARTEL space in 3D

function [Nvols, DARTEL_threeD_dischargedAtlases] = TOPMAL_getUnthresholdedDARTELatlas_allprob (studyFolder, DARtem, ageRange, spm12path, atlasCode)

% add paths
[map2atlasPath, ~, ~] = fileparts (which(mfilename));
[CNSPpath, ~, ~] = fileparts (map2atlasPath);
addpath (map2atlasPath, [CNSPpath '/Scripts'], spm12path);


% Select DARTEL template
switch DARtem

    % ---------------------------------
    % creating sample-specific template
    % ---------------------------------
    case 'creating template'
        fprintf ('Please select the Template1-6.nii for the created DARTEL template.\n');

        createdDARtem = spm_select (6,...
                                    'image',...
                                    'Select Template 1-6 from created template DARTEL processing ...',...
                                    {},...
                                    pwd,...
                                    '.nii*',...
                                    [1 1 1 1 1 1]);
                             

        % copy 'rc123_MNI152_T1_1mm' images to study folder
        TOPMAL_cp_commonFiles_to_studyFolder ('rc123_MNI152_T1_1mm', studyFolder, 'NA', 'NA');

        
        % remove ,1 from the end of image name
        Template1 = strsplit (createdDARtem(1,:),',');
        Template2 = strsplit (createdDARtem(2,:),',');
        Template3 = strsplit (createdDARtem(3,:),',');
        Template4 = strsplit (createdDARtem(4,:),',');
        Template5 = strsplit (createdDARtem(5,:),',');
        Template6 = strsplit (createdDARtem(6,:),',');
        
        % run DARTEL with existing templates
        fprintf ('TOPMAL_getUnthresholdedDARTELatlas_allprob: Generating MNI-to-DARTEL flow map.\n');
        flowMap = CNSP_runDARTELe ([studyFolder '/subjects/Atlases/rc1_MNI152_T1_1mm.nii'], ...
                                    [studyFolder '/subjects/Atlases/rc2_MNI152_T1_1mm.nii'], ...
                                    [studyFolder '/subjects/Atlases/rc3_MNI152_T1_1mm.nii'], ...
                                    Template1{1}, ...
                                    Template2{1}, ...
                                    Template3{1}, ...
                                    Template4{1}, ...
                                    Template5{1}, ...
                                    Template6{1});
                                
         % get MNI atlas, and discharge it into 3D images
         fprintf ('TOPMAL_getUnthresholdedDARTELatlas_allprob: Sorting out seleted atlas for following processing.\n');
         [Nvols, MNI_threeD_dischargedAtlases] = TOPMAL_getMNIatlas_unthr_allprob (studyFolder, atlasCode);
         
         % apply flow map to each of 3D atlases, bring them to DARTEL
         fprintf ('TOPMAL_getUnthresholdedDARTELatlas_allprob: Register to DARTEL with the flow map.\n');        
         DARTEL_threeD_dischargedAtlases = cell (Nvols, 1);
         parfor i = 1:Nvols
            DARTEL_threeD_dischargedAtlases{i,1} = CNSP_nativeToDARTEL (MNI_threeD_dischargedAtlases{i,1}, flowMap, 'NN');
         end
                                
    
    % -----------------------------------------------------------
    % existing template for existing ageRange (65to75 and 70to80)
    % -----------------------------------------------------------
    case 'existing template'
        
        switch atlasCode
            case 'JHU-ICBM_WM_tract_prob_1mm'
                TOPMAL_cp_commonFiles_to_studyFolder ('existing_DARTEL_MNIatlas_JHUwmTracts_allprob_discharged3D', ...
                                                      studyFolder, ...
                                                      'NA', ...
                                                      ageRange);
                Nvols = 20;
                DARTEL_threeD_dischargedAtlases = cell (Nvols, 1);
                                            
                for i = 1:Nvols
                    DARTEL_threeD_dischargedAtlases{i,1} = [studyFolder '/subjects/Atlases/wJHU-ICBM-tracts-prob-1mm_' num2str(i) '_' ageRange '.nii'];
                end
                
            case 'HO_subcortical_1mm'
                TOPMAL_cp_commonFiles_to_studyFolder ('existing_DARTEL_MNIatlas_HOsubcortical_allprob_discharged3D', ...
                                                      studyFolder, ...
                                                      'NA', ...
                                                      ageRange);
                                            
                Nvols = 21;
                DARTEL_threeD_dischargedAtlases = cell (Nvols, 1);
                                            
                for i = 1:Nvols
                    DARTEL_threeD_dischargedAtlases{i,1} = [studyFolder '/subjects/Atlases/wHarvardOxford-sub-prob-1mm_' num2str(i) '_' ageRange '.nii'];
                end
        end
%            % copy flowMap to subjects/Atlas
%             cp_commonFiles_to_studyFolder ('existing_MNI2DARTEL_flowMap', studyFolder, 'NA', ageRange);
%             existingMNI2DARTELflowMap = [studyFolder '/subjects/Atlases/MNI2DARTEL_flowMap_' ageRange '.nii'];
%             
%             [Nvols, MNI_threeD_dischargedAtlases] = getMNIatlas_unthr_allprob (studyFolder, atlasCode);
%             % output
%             DARTEL_threeD_dischargedAtlases = cell (Nvols, 1);
%             for i = 1:Nvols
%                 DARTEL_threeD_dischargedAtlases{i,1} = CNSP_nativeToDARTEL (MNI_threeD_dischargedAtlases{i,1}, existingMNI2DARTELflowMap, 'NN');
%             end
end

fprintf ('TOPMAL_getUnthresholdedDARTELatlas_allprob: Done.\n');