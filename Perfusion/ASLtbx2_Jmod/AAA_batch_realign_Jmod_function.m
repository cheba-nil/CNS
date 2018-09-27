function AAA_batch_realign_Jmod_function (spm12path, ID, indFolder, ASLtype)

% current folder is ASLtbx2_Jmod folder
curr_folder = fileparts (mfilename ('fullpath'));
addpath (curr_folder);

addpath (spm12path);

% load spm defaults
global defaults;
defaults=spm_get_defaults;

global PAR;

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


fprintf ('Now realigning and reslicing %s ...\n', ID);

ASLimg=spm_select('ExtFPList',indFolder,['^' ID '_' ASLtype '\.nii$'],Inf);

% the spm_realign_asl.m in ASLtbx2,
% taken into account differences in 
% ASl tag/control pairs
spm_realign_asl(ASLimg, reaFlags);

% reslice
spm_reslice(ASLimg, resFlags);

