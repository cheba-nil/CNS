function [Nvols, MNI_threeD_dischargedAtlases] = TOPMAL_getMNIatlas_unthr_allprob (studyFolder, atlasCode)

fprintf ('TOPMAL_getMNIatlas_unthr_allprob: get MNI atlas (%s)\n', atlasCode);

switch atlasCode

    %% JHU WM prob 1mm
    case 'JHU-ICBM_WM_tract_prob_1mm'

             TOPMAL_cp_commonFiles_to_studyFolder ('MNI_JHUwmTractsProb_1mm', studyFolder, 'NA', 'NA');
             [Nvols, MNI_threeD_dischargedAtlases] = TOPMAL_construct3Dimg_allprob_fromUnthrAtlas ([studyFolder '/subjects/Atlases/JHU-ICBM-tracts-prob-1mm.nii']);
%              MNIatlas = [studyFolder '/subjects/Atlases/JHU-ICBM-tracts-maxprob-unthr-1mm.nii'];
    
    %% Harvard-Oxford subcortical 1mm
    case 'HO_subcortical_1mm'

             TOPMAL_cp_commonFiles_to_studyFolder ('MNI_HOsubcorticalProb_1mm', studyFolder, 'NA', 'NA');
             % threshold tract prob map
             [Nvols, MNI_threeD_dischargedAtlases] = TOPMAL_construct3Dimg_allprob_fromUnthrAtlas ([studyFolder '/subjects/Atlases/HarvardOxford-sub-prob-1mm.nii']);
%              MNIatlas = [studyFolder '/subjects/Atlases/HarvardOxford-sub-maxprob-unthr-1mm.nii'];       
        
    %% Oxford thalamic connectivity
	case 'OXF_thalamic_conn_1mm'
end

fprintf ('TOPMAL_getMNIatlas_unthr_allprob: Done\n');