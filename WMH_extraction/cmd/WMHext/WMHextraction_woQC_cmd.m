   
    
%% Without QC stops
    
function WMHextraction_woQC_cmd (studyFolder, ...
                                        spm12path, ...
                                        dartelTemplate, ...
                                        k, ... % integer
                                        PVWMH_magnitude, ... % string
                                        coregExcldList, ...
                                        segExcldList, ...
                                        classifier, ...
                                        ageRange, ...
                                        probThr, ... % float
                                        outputFormat ...
                                        )


    tic;
    
    % training features 
    trainingFeatures1 = 1:9;
    trainingFeatures2 = 10:12;

    % add path
    WMHextractionPath = fileparts(fileparts(fileparts(which([mfilename '.m']))));
    CNSP_path = fileparts (WMHextractionPath);
    addpath (spm12path, genpath(WMHextractionPath), [CNSP_path '/Scripts'], [CNSP_path '/downloaded_scipts/NIfTI_tools']);
    
    fprintf ('\n');
    fprintf ('*******************************************\n');
    fprintf ('        WMH extraction pipeline        \n');
    fprintf ('             No QC stops               \n');
    fprintf ('*******************************************\n');
    fprintf ('           Neuroimaging Lab            \n');
    fprintf ('   Centre for Healthy Brain Ageing   \n');
    fprintf ('*******************************************\n');
    fprintf ('\n');

    excldList = [coregExcldList ' ' segExcldList];
    excldIDs = strsplit (excldList, ' ');
 
    %%%%%%%%%%%%%%%%%%%%%%
    % Organising folders %
    %%%%%%%%%%%%%%%%%%%%%%
    fprintf ('Organising folders ...\n');
    
    if (exist ([studyFolder '/originalImg'],'dir') == 7) && (exist ([studyFolder '/subjects'],'dir') == 7)
        movefile ([studyFolder '/originalImg/T1'], [studyFolder '/T1']);
        movefile ([studyFolder '/originalImg/FLAIR'], [studyFolder '/FLAIR']);
        rmdir ([studyFolder '/originalImg'], 's');
        rmdir ([studyFolder '/subjects'], 's');
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
    [Nsubj,n] = size (T1folder);
    
    % gunzip niftis
    parfor i = 1:Nsubj
        CNSP_gunzipnii ([studyFolder '/originalImg/T1/' T1folder(i).name]);
        CNSP_gunzipnii ([studyFolder '/originalImg/FLAIR/' FLAIRfolder(i).name]);
    end

    % re-list all T1 and FLAIR (all .nii)
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
    [Nsubj,n] = size (T1folder);
    
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

    
    %%%%%%%%%%%%%%%%%
    % Run SPM steps %
    %%%%%%%%%%%%%%%%%
    fprintf ('WMH extraction step 1: T1 & FLAIR coregistration ...\n');
    WMHextraction_preprocessing_Step1 (studyFolder); % Step 1: coregistration
    
    fprintf ('Generating coregistration QC images ...\n');
    WMHextraction_QC_1 (studyFolder, outputFormat); % coregistration QC
    
%     switch outputFormat
%         case 'web'
%             % display on screen
%         case 'arch'
%             fprintf (['Download link: ' studyFolder '/subjects/QC/QC_coreg/QC_coregistration.zip\n']);
%         case 'web&arch'
%             fprintf (['Download link: ' studyFolder '/subjects/QC/QC_coreg/QC_coregistration.zip\n']);
%     end

    fprintf ('WMH extraction step 2: T1 segmentation ...\n');
    WMHextraction_preprocessing_Step2 (studyFolder, spm12path, coregExcldList); % Step 2: segmentation
  
    fprintf ('Generating segmentation QC images ...\n');
    WMHextraction_QC_2 (studyFolder, coregExcldList, outputFormat); % segmentation QC
    
%     switch outputFormat
%         case 'web'
%             % display on screen
%         case 'arch'
%             fprintf (['Download link: ' studyFolder '/subjects/QC/QC_seg/QC_segmentation.zip\n']);
%         case 'web&arch'
%             fprintf (['Download link: ' studyFolder '/subjects/QC/QC_seg/QC_segmentation.zip\n']);
%     end
   
    fprintf ('WMH extraction step 3: Running DARTEL ...\n');
    
    fprintf ('3.1 Running DARTEL ...\n');
    WMHextraction_preprocessing_Step3 (studyFolder, ...
                                        CNSP_path, ...
                                        dartelTemplate, ...
                                        coregExcldList, ...
                                        segExcldList, ...
                                        ageRange...
                                        ); 

    fprintf ('3.2: Bring to DARTEL ...\n');
    WMHextraction_preprocessing_Step4 (studyFolder, dartelTemplate, coregExcldList, segExcldList, CNSP_path); % Step 4: bring to DARTEL

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % non-brain tissue removal & FSL FAST %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf ('3.3 WMH extraction using kNN ...\n');
    
%     cmd_skullStriping_FAST_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction_SkullStriping_and_FAST.sh'];
%     system (cmd_skullStriping_FAST_1);
    
    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0

            cmd_skullStriping_FAST_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_SkullStriping_and_FAST.sh ' ...
                                                                                                                            T1folder(i).name ' ' ...
                                                                                                                            FLAIRfolder(i).name ' ' ...
                                                                                                                            studyFolder '/subjects ' ...
                                                                                                                            ID ' ' ...
                                                                                                                            CNSP_path ' ' ...
                                                                                                                            strrep(dartelTemplate, ' ', '_') ' ' ...
                                                                                                                            ageRange];
            system (cmd_skullStriping_FAST_2);
        end

    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % kNN WMH discovery Step 1: Preprocessing %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%     cmd_kNN_step1_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction_kNNdiscovery_Step1.sh'];
%     system (cmd_kNN_step1_1);


    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            cmd_kNN_step1_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step1.sh ' ...
                                                                                                            ID ' ' ...
                                                                                                            studyFolder '/subjects ' ...
                                                                                                            CNSP_path ' ' ...
                                                                                                            strrep(dartelTemplate, ' ', '_') ' ' ...
                                                                                                            ageRange];
            system (cmd_kNN_step1_2);
        end
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % kNN WMH discovery Step 2: kNN calculation %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        
        if ismember(ID, excldIDs) == 0
            WMHextraction_kNNdiscovery_Step2 (k, ...
                                              ID, ...
                                              CNSP_path, ...
                                              studyFolder, ...
                                              classifier, ...
                                              dartelTemplate, ...
                                              ageRange, ...
                                              probThr, ...
                                              trainingFeatures1, ...
                                              trainingFeatures2 ...
                                              );
        end
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % kNN WMH discovery Step 3: Postprocessing and cleanup %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    probThr_str = num2str (probThr, '%1.2f');
    
%     cmd_kNN_step3_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction_kNNdiscovery_Step3.sh'];
%     system (cmd_kNN_step3_1);

    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            cmd_kNN_step3_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh ' ...
                                                                                                ID ' ' ...
                                                                                                studyFolder '/subjects ' ...
                                                                                                CNSP_path '/WMH_extraction ' ...
                                                                                                PVWMH_magnitude ' ' ...
                                                                                                probThr_str ...
                                                                                                ];
            system (cmd_kNN_step3_2);
        end
    end

    
    
    %%%%%%%%%%%%%%%%%%%%%
    % Generating output %
    %%%%%%%%%%%%%%%%%%%%%
    
    fprintf ('3.4 Generating output ...\n');
%     cmd_merge_WMHresults_1 = ['if [ -f ' studyFolder '/subjects/WMH_spreadsheet.txt ];then rm -f ' studyFolder '/subjects/WMH_spreadsheet.txt;fi'];
%     system (cmd_merge_WMHresults_1);
% 
%     cmd_merge_WMHresults_2 = ['echo "ID,wholeBrainWMHvol_mm3,PVWMHvol_mm3,DWMHvol_mm3,Lfrontal_WMHvol_mm3,Rfrontal_WMHvol_mm3,Ltemporal_WMHvol_mm3,Rtemporal_WMHvol_mm3,Lparietal_WMHvol_mm3,Rparietal_WMHvol_mm3,Loccipital_WMHvol_mm3,Roccipital_WMHvol_mm3,Lcerebellum_WMHvol_mm3,Rcerebellum_WMHvol_mm3,Brainstem_WMHvol_mm3" >> ' ...
%                                     studyFolder '/subjects/WMH_spreadsheet.txt'];
%     system (cmd_merge_WMHresults_2);

%     cmd_merge_WMHresults_3 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction_kNNdiscovery_Step4.sh'];
%     system (cmd_merge_WMHresults_3);

    system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);

    for i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ID ' ' studyFolder '/subjects'];
            system (cmd_merge_WMHresults_4);
        end
    end                                




    %%%%%%%%%%%%%%%%%%%%%%%%
    %% QC_3: final output %%
    %%%%%%%%%%%%%%%%%%%%%%%%
    fprintf ('3.5 Generating images for quality assurance of the final output ...\n');

    
    WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, outputFormat);
    
    % switch outputFormat
    %     case 'web'
    %         % display on screen
    %     case 'arch'
    %         fprintf ('Download link: %s/subjects/QC/QC_final/QC_final.zip\n', studyFolder);
    %     case 'web&arch'
    %         fprintf ('Download link: %s/subjects/QC/QC_final/QC_final.zip\n', studyFolder);
    % end
    


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Bring back to native space %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf ('3.6 Bringing DARTEL space WMH mask to native space ...\n');


    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        
        if ismember(ID, excldIDs) == 0
            switch dartelTemplate
            case 'existing template'
                WMHresultsBack2NativeSpace (studyFolder, ID, spm12path);
            case 'creating template'
                WMHresultsBack2NativeSpace (studyFolder, ID, spm12path, '', 'creating template');
            end
        end
    end

    % webpage display
    % [~, NexcldIDs] = size (excldIDs);
    % indFLAIR_cellArr = cell ((Nsubj - NexcldIDs), 1);
    % indWMH_FLAIRspace_cellArr = cell ((Nsubj - NexcldIDs), 1);
    indFLAIR_cellArr = cell (Nsubj, 1);
    indWMH_FLAIRspace_cellArr = cell (Nsubj, 1);

    for i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        
        if ismember (ID, excldIDs) == 0
            indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
            
            indWMH_FLAIRspace_cellArr{i,1} = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii.gz'];
            
        else % if ID is excluded, display the FLAIR image twice
            indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
            
            indWMH_FLAIRspace_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
        end
    end

    if exist ([studyFolder '/subjects/QC/QC_final_native'], 'dir') ~= 7
        mkdir ([studyFolder '/subjects/QC'], 'QC_final_native');
    end

    CNSP_webViewSlices_overlay (indFLAIR_cellArr, ...
                                indWMH_FLAIRspace_cellArr, ...
                                [studyFolder '/subjects/QC/QC_final_native'], ...
                                'QC_final_native', ...
                                'arch');


    %%%%%%%%%%%%%%%%%%%%%%
    %% "finish" message %%
    %%%%%%%%%%%%%%%%%%%%%%

    fprintf ('*** FINISHED ! ***\n');

    
    total_time = toc/3600; % in hrs
    fprintf ('');
    fprintf ('%.2f hours elapsed to finish.\n', total_time);
    fprintf ('');