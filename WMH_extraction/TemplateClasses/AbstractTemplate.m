%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AbstractTemplate.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Abstract) AbstractTemplate < matlab.mixin.Copyable
    % Base class for to be used for templates
    % 
    % To add a new template, create a new class
    % which inherits from AbstractTemplate
    % and fills out the specified properties

    properties (Abstract)
        name
        % Name, for compatibility with original code
        brain_mask
        % path to the binary brain mask for this template
        gm_prob
        % path to grey matter probability map
        wm_prob
        % path to white matter probability map
        csf_prob
        % path to CSF probability map
        gm_prob_thr
        % path to thresholded grey matter probability map
        wm_prob_thr
        % path to thresholded white matter probability map
        ventricles
        % path to ventricle distance map
        lobar
        % path to lobar segmentation mask
        arterial
        % path to arterial segmentation mask
        space
        % For convenience, perhaps we store
        % the 'space' of this template?
        % ... I don't think this is currently used
    end
end
