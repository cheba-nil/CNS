%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DartelTemplate.m
% 
% Constructor for DartelTemplate class : DartelTemplate(CNS_path, age_range); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef DartelTemplate < AbstractTemplate
    methods
        function template = DartelTemplate(CNS_path, age_range);
            template.name = 'existing template';

            template.brain_mask = strcat( ...
                    CNS_path,'/Templates/DARTEL_brain_mask/', ...
                    age_range, '/DARTEL_brain_mask.nii.gz');

            template.gm_prob = strcat( ...
                    CNS_path,'/Templates/DARTEL_GM_WM_CSF_prob_maps/', ...
                    age_range,'/DARTEL_GM_prob_map.nii.gz');
            template.wm_prob = strcat( ...
                    CNS_path,'/Templates/DARTEL_GM_WM_CSF_prob_maps/', ...
                    age_range,'/DARTEL_WM_prob_map.nii.gz');
            template.csf_prob = strcat( ...
                    CNS_path,'/Templates/DARTEL_GM_WM_CSF_prob_maps/', ...
                    age_range,'/DARTEL_CSF_prob_map.nii.gz');

            template.gm_prob_thr = strcat( ...
                    CNS_path,'/Templates/DARTEL_GM_WM_CSF_prob_maps/', ...
                    age_range,'/DARTEL_GM_prob_map_thr0_8.nii.gz');
            template.wm_prob_thr = strcat( ...
                    CNS_path,'/Templates/DARTEL_GM_WM_CSF_prob_maps/', ...
                    age_range,'/DARTEL_WM_prob_map_thr0_8.nii.gz');
    
            template.ventricles = strcat( ...
                    CNS_path,'/Templates/DARTEL_ventricle_distance_map/', ...
                    'DARTEL_ventricle_distance_map.nii.gz');

            template.lobar = strcat( ...
                    CNS_path,'/Templates/DARTEL_lobar_and_arterial_templates/', ...
                        'DARTEL_lobar_template.nii.gz');
            template.arterial = strcat( ...
                    CNS_path,'/Templates/DARTEL_lobar_and_arterial_templates/', ...
                        'DARTEL_arterial_template.nii.gz');

            template.template1 = strcat( ...
                    CNS_path,'/Templates/DARTEL_0to6_templates/', ...
                    age_range,'/Template_1.nii')
            template.template2 = strcat( ...
                    CNS_path,'/Templates/DARTEL_0to6_templates/', ...
                    age_range,'/Template_2.nii')
            template.template3 = strcat( ...
                    CNS_path,'/Templates/DARTEL_0to6_templates/', ...
                    age_range,'/Template_3.nii')
            template.template4 = strcat( ...
                    CNS_path,'/Templates/DARTEL_0to6_templates/', ...
                    age_range,'/Template_4.nii')
            template.template5 = strcat( ...
                    CNS_path,'/Templates/DARTEL_0to6_templates/', ...
                    age_range,'/Template_5.nii')
            template.template6 = strcat( ...
                    CNS_path,'/Templates/DARTEL_0to6_templates/', ...
                    age_range,'/Template_6.nii')

            template.space = 'DARTEL';
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
        template1
        template2
        template3
        template4
        template5
        template6
    end
end
