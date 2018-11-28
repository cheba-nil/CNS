%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NativeTemplate.m
% 
% Constructor for NativeTemplate class : NativeTemplate(CNS_path, age_range); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef NativeTemplate < AbstractTemplate
    methods
        function obj = NativeTemplate(CNS_path, age_range, studyFolder);
            obj.CNS_path = CNS_path;
            obj.age_range = age_range;
            obj.studyFolder = studyFolder;
            obj.name = 'native template';
            obj.space = 'FLAIR';
            obj.subID = '';
        end

        function obj = set.subID(obj,i)
            T1folder = dir (strcat (obj.studyFolder,'/originalImg/T1/*.nii'));
            T1imgNames = strsplit (T1folder(i).name, '_');
            obj.subID = T1imgNames{1};
        end

        function value = get.dir(obj)
            value = strcat(obj.studyFolder,'/subjects/', ...
                           obj.subID,'/NativeTemplate');
        end

        function value = get.brain_mask(obj)
            value = strcat(obj.dir,'/rwbrain_mask.nii');
        end

        function value = get.gm_prob(obj)
            value = strcat(obj.dir,'/rwGM_prob_map.nii');
        end

        function value = get.wm_prob(obj)
            value = strcat(obj.dir,'/rwWM_prob_map.nii'); 
        end

        function value = get.csf_prob(obj)
            value = strcat(obj.dir,'/rwCSF_prob_map.nii'); 
        end

        function value = get.gm_prob_thr(obj)
            value = strcat(obj.dir,'/rwGM_prob_map_thr0_8.nii'); 
        end
    
        function value = get.wm_prob_thr(obj)
            value = strcat(obj.dir,'/rwWM_prob_map_thr0_8.nii'); 
        end

        function value = get.ventricles(obj)
            value = strcat(obj.dir,'/rwVentricle_distance_map.nii'); 
        end

        function value = get.lobar(obj)
            value = strcat(obj.dir,'/rwlobar_template.nii'); 
        end

        function value = get.arterial(obj)
            value = strcat(obj.dir,'/rwarterial_template.nii'); 
        end

    end
    properties
        name
        space
        CNS_path
        age_range
        studyFolder
        subID
    end
    properties (Dependent)
        brain_mask
        gm_prob
        wm_prob
        csf_prob
        gm_prob_thr
        wm_prob_thr
        ventricles
        lobar
        arterial
        dir
    end
end
