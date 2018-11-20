%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AbstractTemplate.m
% 
% To add a new template, create a new class
% which inherits from AbstractTemplate
% and fills out the specified properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Abstract) AbstractTemplate
    properties (Abstract)
        % Name, for compatibility with legacy code
        name

        % Brain Mask
        brain_mask

        % Probability Maps
        gm_prob
        wm_prob
        csf_prob

        % Thresholded (p >= 0.8) Probability Maps
        gm_prob_thr
        wm_prob_thr
        csf_prob_thr

        % Ventricle Distance
        ventricles
        
        % Arterial and Lobar templates
        lobar
        arterial

        % For convenience, perhaps we store
        % the 'space' of this template?
        space
    end
end
