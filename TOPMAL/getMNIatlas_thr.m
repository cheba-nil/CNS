function MNIatlas = getMNIatlas_thr (studyFolder, atlasCode, atlasProbThr)

switch atlasCode

    %% JHU WM prob 1mm
    case 'JNU-ICBM_WM_tract_prob_1mm'

         if strcmp (atlasProbThr, '0') || strcmp (atlasProbThr, '25') || strcmp (atlasProbThr, '50')
                 cp_commonFiles_to_studyFolder ('existing_MNI_thrJHUwmTracts', studyFolder, atlasCode, atlasProbThr);
                 MNIatlas = [studyFolder '/subjects/Atlases/JHU-ICBM-tracts-maxprob-thr' atlasProbThr '-1mm.nii'];
         else
                 fprintf (['Generating a JNU-ICBM_WM_tract_prob_1mm atlas with threshold of ' atlasProbThr '\n']);
                 cp_commonFiles_to_studyFolder ('MNI_JHUwmTractsProb_1mm', studyFolder, 'NA', 'NA');

                 % threshold tract prob map
                 thr4DatlasProb ([studyFolder '/subjects/Atlases/JHU-ICBM-tracts-prob-1mm.nii'], ...
                                    str2num (atlasProbThr), ...
                                    [studyFolder '/subjects/Atlases/JHU-ICBM-tracts-maxprob-thr' atlasProbThr '-1mm.nii']);
                 MNIatlas = [studyFolder '/subjects/Atlases/JHU-ICBM-tracts-maxprob-thr' atlasProbThr '-1mm.nii'];
         end
    
    %% Harvard-Oxford subcortical 1mm
    case 'HO_subcortical_1mm'
        
          if strcmp (atlasProbThr, '0') || strcmp (atlasProbThr, '25') || strcmp (atlasProbThr, '50')
                 cp_commonFiles_to_studyFolder ('existing_MNI_thrHOsubcortical', studyFolder, atlasCode, atlasProbThr);
                 MNIatlas = [studyFolder '/subjects/Atlases/HarvardOxford-sub-maxprob-thr' atlasProbThr '-1mm.nii'];
         else
                 fprintf (['Generating a HarvardOxford_subcortical_prob_1mm atlas with threshold of ' atlasProbThr '\n']);
                 cp_commonFiles_to_studyFolder ('MNI_HOsubcorticalProb_1mm', studyFolder, 'NA', 'NA');
                 
                 % threshold tract prob map
                 thr4DatlasProb ([studyFolder '/subjects/Atlases/HarvardOxford-sub-prob-1mm.nii'], ...
                                    str2num (atlasProbThr), ...
                                    [studyFolder '/subjects/Atlases/HarvardOxford-sub-maxprob-thr' atlasProbThr '-1mm.nii']);
                 MNIatlas = [studyFolder '/subjects/Atlases/HarvardOxford-sub-maxprob-thr' atlasProbThr '-1mm.nii'];
         end       
    
        
        
end