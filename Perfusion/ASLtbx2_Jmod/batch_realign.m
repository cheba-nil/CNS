% Toolbox for batch processing ASL perfusion based fMRI data.
% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
% Batch realigning images.
% Get the global subject information
clear
par;
disp('We are now realigning raw EPI images for all subjects, just wait....');
% load spm defaults
global defaults;
spm_defaults;

% Get realignment defaults
defs = defaults.realign;

% Flags to pass to routine to calculate realignment parameters
% (spm_realign)

%as (possibly) seen at spm_realign_ui,
% -fwhm = 5 for fMRI
% -rtm = 0 for fMRI
% for this particular data set, we did not perform a second realignment to the mean
% the coregistration between the reference control and label volume is also omitted
reaFlags = struct(...
    'quality', defs.estimate.quality,...  % estimation quality
    'fwhm', 5,...                         % smooth before calculation
    'rtm', 1,...                          % whether to realign to mean
    'PW',''...                            %
    );

% Flags to pass to routine to create resliced images
% (spm_reslice)
resFlags = struct(...
    'interp', 1,...                       % trilinear interpolation
    'wrap', defs.write.wrap,...           % wrapping info (ignore...)
    'mask', defs.write.mask,...           % masking (see spm_reslice)
    'which',2,...                         % write reslice time series for later use
    'mean',1);                            % do write mean image


% dirnames,
% get the subdirectories in the main directory
for sb =1:PAR.nsubs % for each subject
    str   = sprintf('sub #%3d/%3d: %-5s',sb,PAR.nsubs,PAR.subjects{sb} );
    fprintf('\r%-40s  %30s',str,' ')
    P=[];
    for c=1:PAR.ncond
        % get files in this directory
        Ptmp=spm_select('ExtFPList',PAR.condirs{sb,c},['^' PAR.confilters{c} '\w*\.nii$'],1:400);
        P=strvcat(P,Ptmp);
%         Ptmp=spm_select('FPList', char(PAR.M0dirs{sb,c}), ['^' PAR.M0filters{c} '\w*\.nii$']);
%         P=strvcat(P,Ptmp);
        
    end
    spm_realign_asl(P, reaFlags);
    % Run reslice
    spm_reslice(P, resFlags);

end
