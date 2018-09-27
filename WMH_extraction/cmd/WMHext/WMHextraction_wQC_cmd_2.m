% ------------------------------------
% --- WMH extraction with QC stops ---
% ---    Stage 2: Segmentation     ---
% ------------------------------------

%% Note:

% 1. addpath before calling this command
% 2. 'arch' is recommended for QC. If you want to use 'web'
%    or 'web&arch' to display on screen, please do not add
%    "exit" to the command, otherwise the webpage will be 
%    closed.
%    e.g. matlab -nojvm -nodesktop -nosplash -r "addpath('CNSP/WMH_extraction');try WMHextraction_wQC_cmd_2('/study/folder','/spm12/folder', '111 222 333', 'web');catch;end"


%% Examples:

% The following shell command will run the current script without parallel
% pool:
%     matlab -nojvm -nodesktop -nosplash -r "addpath('CNSP/WMH_extraction');WMHextraction_wQC_cmd_2('/study/folder','/spm12/folder', '111 222 333', 'arch')"
% or safer:
%     matlab -nojvm -nodesktop -nosplash -r "addpath('CNSP/WMH_extraction');try WMHextraction_wQC_cmd_2('/study/folder','/spm12/folder','111 222 333', 'arch');catch;end;exit"

% The following command will run the current script with parallel
% pool:
%     matlab -nodesktop -nosplash -r "addpath('CNSP/WMH_extraction');WMHextraction_wQC_cmd_2('/study/folder','/spm12/folder', '111 222 333', 'arch')"
% or safer:
%     matlab -nodesktop -nosplash -r "addpath('CNSP/WMH_extraction');try WMHextraction_wQC_cmd_2('/study/folder','/spm12/folder', '111 222 333', 'arch');catch;end;exit"

   
 function WMHextraction_wQC_cmd_2 (studyFolder, spm12path, coregExcldList, outputFormat)
    tic

    if strcmp (coregExcldList, 'none')
        coregExcldList = '';
    end

    coregExcldList = strrep (coregExcldList, ',', ' ');

    % add path
    addpath (spm12path);
    CNSP_path = fileparts(fileparts(fileparts(fileparts(which([mfilename '.m'])))));
    addpath ([CNSP_path '/Scripts']);
    addpath ([CNSP_path '/WMH_extraction/WMHextraction']);
    
    % segmentation
    fprintf ('WMH extraction step 2: T1 segmentation ...\n');
    WMHextraction_preprocessing_Step2 (studyFolder, spm12path, coregExcldList);
    
    fprintf ('Generating segmentation QC images ...\n');
    WMHextraction_QC_2 (studyFolder, coregExcldList, outputFormat); % segmentation QC
    
    % switch outputFormat
    %     case 'web'
    %         % display on screen
    %     case 'arch'
    %         fprintf (['Download link: ' studyFolder '/subjects/QC/QC_seg/QC_segmentation.zip\n']);
    %     case 'web&arch'
    %         fprintf (['Download link: ' studyFolder '/subjects/QC/QC_seg/QC_segmentation.zip\n']);
    % end
    
  
    stage2_time = toc/60; % in min
    fprintf ('');
    fprintf ('%.2f minutes elapsed to finish Step 2.\n', stage2_time);
    fprintf ('');

