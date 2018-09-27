% ------------------------------------
% --- WMH extraction with QC stops ---
% ---   Stage 1: Coregistration    ---
% ------------------------------------

%% Note:

% 1. addpath before calling the command
% 2. 'arch' is recommended for QC. If you want to use 'web'
%    or 'web&arch' to display on screen, please do not add
%    "exit" to the command, otherwise the webpage will be 
%    closed.
%    e.g. matlab -nojvm -nodesktop -nosplash -r "addpath('CNSP/WMH_extraction');try WMHextraction_wQC_cmd_1('/study/folder','/spm12/folder','web');catch;end"


%% Examples:

% The following shell command will run the current script without parallel
% pool:
%     matlab -nojvm -nodesktop -nosplash -r "addpath('CNSP/WMH_extraction');WMHextraction_wQC_cmd_1('/study/folder','/spm12/folder','arch')"
% or safer:
%     matlab -nojvm -nodesktop -nosplash -r "addpath('CNSP/WMH_extraction');try WMHextraction_wQC_cmd_1('/study/folder','/spm12/folder','arch');catch;end;exit"

% The following command will run the current script with parallel
% pool:
%     matlab -nodesktop -nosplash -r "addpath('CNSP/WMH_extraction');WMHextraction_wQC_cmd_1('/study/folder','/spm12/folder','arch')"
% or safer:
%     matlab -nodesktop -nosplash -r "addpath('CNSP/WMH_extraction');try WMHextraction_wQC_cmd_1('/study/folder','/spm12/folder','arch');catch;end;exit"



function WMHextraction_wQC_cmd_1 (studyFolder, spm12path, outputFormat)

    tic;
    
    fprintf ('*******************************************\n');
    fprintf ('        WMH extraction pipeline        \n');
    fprintf ('*******************************************\n');
    fprintf ('           Neuroimaging Lab            \n');
    fprintf ('   Centre for Healthy Brain Ageing   \n');
    fprintf ('*******************************************\n\n');

    % add path
    addpath (spm12path);
    
    CNSP_path = fileparts(fileparts(fileparts(fileparts(which([mfilename '.m'])))));
    addpath ([CNSP_path '/Scripts']);
    addpath ([CNSP_path '/WMH_extraction/WMHextraction']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    %% Organising folders %%
    %%%%%%%%%%%%%%%%%%%%%%%%

    fprintf ('Organising folders ...\n');

    % if previously processed, copy T1 and FLAIR folders to studyFolder,
    % delete subjects dir
    if exist ([studyFolder '/originalImg'],'dir') == 7
        movefile ([studyFolder '/originalImg/T1'], [studyFolder '/T1']);
        movefile ([studyFolder '/originalImg/FLAIR'], [studyFolder '/FLAIR']);
        rmdir ([studyFolder '/originalImg'],'s');
    end
    
    if exist ([studyFolder '/subjects'],'dir') == 7
        rmdir ([studyFolder '/subjects'],'s');
    end
    
    % create originalImg folder, and move T1 and FLAIR to originalImg
    mkdir (studyFolder, 'originalImg');
    movefile (strcat (studyFolder,'/T1'), strcat (studyFolder,'/originalImg'), 'f'); % move T1 folder to originalImg folder
    movefile (strcat (studyFolder,'/FLAIR'), strcat (studyFolder,'/originalImg'), 'f'); % move FLAIR folder to originalImg folder
   
    % create subjects folder, 
    mkdir (studyFolder, 'subjects');

    % list all T1 and FLAIR (may be .nii.gz)
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii*'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii*'));
    [Nsubj,~] = size (T1folder);
    
    % gunzip niftis
    parfor i = 1:Nsubj
        CNSP_gunzipnii ([studyFolder '/originalImg/T1/' T1folder(i).name]);
        CNSP_gunzipnii ([studyFolder '/originalImg/FLAIR/' FLAIRfolder(i).name]);
    end

    % refresh list of nii after gunzip
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
    [Nsubj,~] = size (T1folder);

    % create a folder for each subject under subjects
    % folder, using ID as folder name. Copy corresponding T1 and FLAIR to the
    % orig folder of each subject
    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        mkdir (strcat(studyFolder,'/subjects/',ID,'/mri'),'orig');  % create orig folder under each subject folder
        copyfile (strcat (studyFolder,'/originalImg/T1/', T1folder(i).name), strcat(studyFolder,'/subjects/',ID,'/mri/orig/'));        % copy T1 to each subject folder
        copyfile (strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name), strcat(studyFolder,'/subjects/',ID,'/mri/orig/'));  % copy FLAIR to each subject folder
    end
    
    
    %%%%%%%%%%%%%%%%%%%
    %% Run SPM steps %%
    %%%%%%%%%%%%%%%%%%%

    fprintf ('WMH extraction step 1: T1 & FLAIR coregistration ...\n');
    WMHextraction_preprocessing_Step1 (studyFolder);
    
    fprintf ('Generating coregistration QC images ...\n');  
    WMHextraction_QC_1 (studyFolder, outputFormat); % coregistration QC
    
    % switch outputFormat
    %     case 'web'
    %         % display on screen
    %     case 'arch'
    %         fprintf (['Download link: ' studyFolder '/subjects/QC/QC_coreg/QC_coregistration.zip']);
    %     case 'web&arch'
    %         fprintf (['Download link: ' studyFolder '/subjects/QC/QC_coreg/QC_coregistration.zip']);
    % end
    
    stage1_time = toc/60; % in min
    fprintf ('');
    fprintf ('%.2f minutes elapsed so far.\n', stage1_time);
    fprintf ('');
    
