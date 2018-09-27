% par.m - J modified
%
% DATA PREPARATION
% ----------------
% A Study Folder should contain three folders - M0, PASL/pCASL, T1
% with images named as ID_M0.nii, ID_PASL/pCASL.nii, ID_T1.nii
%
%
% AFTER PROCESSING
% ----------------
% orig folder holds the original nii data:
% .../studyFolder/subjects/ID/mri/orig/ID_M0.nii
% .../studyFolder/subjects/ID/mri/orig/ID_PASL.nii or .../studyFolder/subjects/ID/mri/orig/ID_pCASL.nii
% .../studyFolder/subjects/ID/mri/orig/ID_T1.nii
%

function AAA_par_Jmod (spm12path, ...
                       studyFolder, ...
                       IDlist_cerrArr, ...
                       PASL_or_pCASL, ...
                       aslTR, ...
                       firstImgType, ...
                       subtractionType, ...
                       subtractionOrder, ...
                       fixM0, ...
                       M0wmcsf2estimateM0b, ...
                       ASLtype_code, ...
                       labelEfficiency, ...
                       magnituteType, ...
                       labelTime, ...
                       delayTime, ...
                       sliceTime, ...
                       TE)



fprintf('\r%s\n',repmat(sprintf('-'),1,30))
fprintf('%s','Set PAR')

subjects_folder = [studyFolder '/subjects'];


clear PAR
global PAR
PAR=[];

%% SPM12 path
% PAR.SPM_path=spm('Dir');
PAR.SPM_path = spm12path;
addpath(PAR.SPM_path);


%%%%%%%%%%%%%%%%%%%%%
%                   %
%   GENERAL PREFS   %
%                   %
%%%%%%%%%%%%%%%%%%%%%%


% Where the subjects' data directories are stored

% ASLtbx2 folder
PAR.ASLtbx2Dir = fileparts(mfilename('fullpath'));
addpath(PAR.ASLtbx2Dir);


% old_pwd=pwd;
% cd(PAR.ASLtbx2Dir);
% cd ../
% data_root=pwd;
% cd(old_pwd);

% subjects folder
PAR.subjDir = subjects_folder;

% ID directories
PAR.ids = IDlist_cerrArr;
PAR.Nids = length(PAR.ids);


% Anatomical directory name
% PAR.structfilter='T1';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the anatomical image directories automatically %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for sb=1:PAR.Nids
    % T1 raw data stored in /.../subjects/ID/mri/orig/T1/ID_*.nii
%     tmp = dir(fullfile(PAR.subjDir,PAR.ids{sb},['mri/orig/' PAR.structfilter]));
    % if size(tmp,1)==0
    %     sprintf('Can not find the anatomical directory for subject\n')
    %     sprintf('%s: \n', char(PAR.ids{sb}))
    %     error('Can not find the anatomical directory for subject');
    % end
    % if size(tmp,1)>1
    %     sprintf('More than 1 anatomical directories for subject: %s are found here!\n',char(PAR.ids{sb}))
    %     error('More than 1 anatomical directories are found')
    % end
%     PAR.T1folder{sb} = fullfile(PAR.subjDir,PAR.ids{sb},spm_str_manip(char(tmp(1).name),'d'));

    PAR.T1folder{sb} = fullfile (PAR.subjDir, PAR.ids{sb}, 'orig');
    % prefixes for filenames of structural 3D images.
    % T1 images should be named as ID_T1.nii
    PAR.T1prefs{sb} = [IDlist_cerrArr{sb} '_T1'];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Getting condition directories
% PAR.ASLfolderFilter={PASL_or_pCASL};
% PAR.M0folderFilter = {'M0'};

% PAR.ASLimgFilter={PASL_or_pCASL}; %filters for finding the images
% PAR.N_ASLimgs=length(PAR.ASLimgFilter);

% PAR.M0imgFilter = {[ID '_M0']}; % for finding M0 image

% The condition names are assumed same for different sessions

for sb=1:PAR.Nids
    % for c=1:PAR.N_ASLimgs

        % ASL folder
%         tmp=dir(fullfile(PAR.subjDir,PAR.ids{sb},['mri/orig/' PAR.ASLfolderFilter]));

        % if size(tmp,1)==0
        %     sprintf('Can not find the condition directory for subject\n')
        %     sprintf('%s: \n', char(PAR.ids{sb}))
        %     error('Can not find the condition directory for subject');
        % end

        % if size(tmp,1)>1
        %     sprintf('Panic! subject %s has more than 1 directories!\n', [PAR.ids{sb}])
        %     error('Panic! condition has more than 1 directories!')
        %     %return;
        % end
%         PAR.ASLfolder{sb}=fullfile(PAR.subjDir,PAR.ids{sb},spm_str_manip(char(tmp(1).name),'d'));
        PAR.ASLfolder{sb} = fullfile(PAR.subjDir, PAR.ids{sb}, 'orig');
        PAR.ASLprefs{sb} = [IDlist_cerrArr{sb} '_' PASL_or_pCASL];
        
        
%         tmp=dir(fullfile(PAR.subjDir,PAR.ids{sb},['mri/orig/' PAR.M0folderFilter]));
        %      if size(tmp,1)==0
        %     sprintf('Can not find the M0 directory for subject\n')
        %     sprintf('%s: \n', char(PAR.ids{sb}))
        %     error('Can not find the M0 directory for subject');
        % end

        % if size(tmp,1)>1
        %     sprintf('Panic! subject %s has more than 1 M0 directories!\n', [PAR.ids{sb}])
        %     error('Panic! condition has more than 1 M0 directories!')
        %     %return;
        % end
        
        PAR.M0folder{sb} = fullfile(PAR.subjDir,PAR.ids{sb},'orig');
        PAR.M0prefs{sb} = [IDlist_cerrArr{sb} '_M0'];
        

        PAR.imgs4ASLtbxFolder{sb} = [PAR.subjDir '/' PAR.ids{sb} '/imgs4ASLtbx'];
        PAR.origFolder{sb} = [PAR.subjDir '/' PAR.ids{sb} '/orig'];
    % end
end

% Smoothing kernel size
PAR.FWHM = [6];

PAR.TR = aslTR;
% PAR.mp='no';

%
PAR.mp='no'; % J: What is this?
%
% PAR.groupdir = ['group_anasmallPerf_sinc'];

%contrast names
PAR.con_names={'tap_rest'};

PAR.subtractiontype = subtractionType;

for sb=1:PAR.Nids
    PAR.glcbffile{sb} = ['globalsg_' num2str(PAR.subtractiontype) '_' PAR.ids{sb} '.txt'];
end

PAR.img4analysis='cbf'; % or 'Perf'
PAR.ana_dir = ['glm_' PAR.img4analysis];
PAR.Filter='cbf_0_sr';


% parameters for cbf quantification
% PAR.FirstimageType = firstImgType;          % 0 means labeling first (images are acquired in an order of label control label ...
% PAR.SubtractionType = subtractionType;      % 0: simple subtraction, 1: surround subtraction, 2: sinc subtraction
% PAR.SubtractionOrder = subtractionOrder;    % 0: label - control, 1: control - label
% PAR.MaskFlag=1;    % Flag #1, 1 means masking out images using an implicit or explicit mask image
% PAR.MeanFlag=1;    % Flag #2, 1 means creating mean images (for the non-subtracted raw data, ASL CBF images, or the perfusion difference images
% PAR.CBFFlag=1;     % Flag #3, 1 means calculating CBF (this is the default value)
% PAR.BOLDFlag=1;    % Flag #4, 1 means extracting pseudo BOLD images (an obsolete option)
% PAR.OutPerfFlag=1; % Flag #5, 1 means saving the perfusion difference images (the perfusion weighted images)
% PAR.OutCBFFlag=1;  % Flag #6, 1 means saving CBF images rather than only the mean CBF map if MeanFlag is on
% PAR.QuantFlag = fixM0;                 % Flag #7, 1 means using a unique M0 value for the whole brain during CBF calculation
% PAR.ImgformatFlag=1;                   % Flag #8, 1 means saving images in NifTI format
% PAR.D4Flag=1;                          % Flag #9, 1 means saving the image series in 4D format
% PAR.M0wmcsfFlag = M0wmcsf2estimateM0b; % Flag #10, 1 means using M0csf to estimate M0b, 0 means using M0wm
% PAR.Flags=[PAR.MaskFlag   PAR.MeanFlag  PAR.CBFFlag       PAR.BOLDFlag PAR.OutPerfFlag ...
%            PAR.OutCBFFlag PAR.QuantFlag PAR.ImgformatFlag PAR.D4Flag   PAR.M0wmcsfFlag];
% PAR.TimeShift = 0.5;                %  time shift for sinc interpolation. 0.5 means moving half of TR
% PAR.ASLType  = ASLtype_code;        % 1 means CASL or PCASL, 0 means PASL
% PAR.Labeff   = labelEfficiency;     % label efficiency
% PAR.MagType  = magnituteType;       % 1 means 3T   (please read the header in asl_perf_subtrac.m for more details
% PAR.Labeltime = labelTime;          % labeling time in secs. For PASL, this parameter is for passing the TI1. If it is >1, this value will be disabled.
% PAR.Delaytime = delayTime;          % post labeling delay time. For QUIPSS, this should be set to TI2. 
% PAR.slicetime = sliceTime;          % slice acquisition time in msec.  Refer to the manual for how to calculate it.
% PAR.TE = TE;                        % in msecs



fprintf('%s','     -----     DONE')

fprintf('\r%s\n',repmat(sprintf('-'),1,30))
