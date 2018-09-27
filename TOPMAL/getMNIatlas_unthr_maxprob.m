function MNIatlas = getMNIatlas_unthr_maxprob (studyFolder, atlasCode)

switch atlasCode

    %% JHU WM prob 1mm
    case 'JNU-ICBM_WM_tract_prob_1mm'

             cp_commonFiles_to_studyFolder ('MNI_JHUwmTractsProb_1mm', studyFolder, 'NA', 'NA');
             % threshold tract prob map
             construct3Dimg_maxprob_fromUnthrAtlas ([studyFolder '/subjects/Atlases/JHU-ICBM-tracts-prob-1mm.nii'], ...
                                                    [studyFolder '/subjects/Atlases/JHU-ICBM-tracts-maxprob-unthr-1mm.nii']);
             MNIatlas = [studyFolder '/subjects/Atlases/JHU-ICBM-tracts-maxprob-unthr-1mm.nii'];
    
    %% Harvard-Oxford subcortical 1mm
    case 'HO_subcortical_1mm'

             cp_commonFiles_to_studyFolder ('MNI_HOsubcorticalProb_1mm', studyFolder, 'NA', 'NA');
             % threshold tract prob map
             construct3Dimg_maxprob_fromUnthrAtlas ([studyFolder '/subjects/Atlases/HarvardOxford-sub-prob-1mm.nii'], ...
                                                    [studyFolder '/subjects/Atlases/HarvardOxford-sub-maxprob-unthr-1mm.nii']);
             MNIatlas = [studyFolder '/subjects/Atlases/HarvardOxford-sub-maxprob-unthr-1mm.nii'];       
        
end