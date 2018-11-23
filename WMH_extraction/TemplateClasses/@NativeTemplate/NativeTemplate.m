%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NativeTemplate.m
% 
% Constructor for NativeTemplate class : NativeTemplate(CNS_path, age_range); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef NativeTemplate < AbstractTemplate
    methods
        function template = NativeTemplate(CNS_path, age_range, studyFolder, subID);
            template.CNS_path = CNS_path;
            template.age_range = age_range;
            template.studyFolder = studyFolder;
            template.subID = subID;
            template.dir = strcat(studyFolder,'/subjects/', ...
                           subID,'/NativeTemplate')

            template.name = 'native template';



            template.brain_mask = strcat(template.dir,'/rwbrain_mask.nii') 

            template.gm_prob = strcat(template.dir,'/rwGM_prob_map.nii')
            template.wm_prob = strcat(template.dir,'/rwWM_prob_map.nii') 
            template.csf_prob = strcat(template.dir,'/rwCSF_prob_map.nii') 

            template.gm_prob_thr = strcat(template.dir,'/rwGM_prob_map_thr0_8.nii') 
            template.wm_prob_thr = strcat(template.dir,'/rwWM_prob_map_thr0_8.nii') 
            template.ventricles = strcat(template.dir,'/rwVentricle_distance_map.nii') 
            template.lobar = strcat(template.dir,'/rwCSF_lobar.nii') 
            template.arterial = strcat(template.dir,'/rwCSF_arterial.nii') 

            template.space = 'FLAIR';
        end
    end
    properties
        name
        brain_mask
        gm_prob
        wm_prob
        csf_prob
        gm_prob_thr
        wm_prob_thr
        ventricles
        lobar
        arterial
        space
        CNS_path
        age_range
        studyFolder
        subID
        dir
    end
end
