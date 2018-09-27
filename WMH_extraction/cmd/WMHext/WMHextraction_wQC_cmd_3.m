%% Stage 3

function WMHextraction_wQC_cmd_3 (studyFolder, ...
                                    spm12path, ...
                                    dartelTemplate, ...
                                    k, ...% integer
                                    PVWMH_magnitude, ...% string
                                    coregExcldList, ...
                                    segExcldList, ...
                                    classifier, ...
                                    ageRange, ...
                                    probThr, ...% float
                                    outputFormat ...
                                    )

    tic;

    trainingFeatures1 = 1:9;
    trainingFeatures2 = 10:12;

    if strcmp (coregExcldList, 'none') || strcmp (coregExcldList, '')
        coregExcldList = '';
    end

    if strcmp (segExcldList, 'none') || strcmp (segExcldList, '')
        segExcldList = '';
    end
    
    addpath (spm12path);
    CNSP_path = fileparts(fileparts(fileparts(fileparts(which([mfilename '.m'])))));
    addpath ([CNSP_path '/Scripts']);
    addpath ([CNSP_path '/WMH_extraction/WMHextraction']);
    addpath ([CNSP_path '/downloaded_scipts/NIfTI_tools']);

    excldList = [strrep(coregExcldList,',',' ') ' ' strrep(segExcldList,',',' ')];
    excldIDs = strsplit (excldList, ' ');
    
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
    [Nsubj,n] = size (T1folder);
    
    
    fprintf ('WMH extraction step 3: DARTEL and kNN ...\n');
    
    fprintf ('3.1 Running DARTEL ...\n');
    WMHextraction_preprocessing_Step3 (studyFolder, ...
                                        CNSP_path, ...
                                        dartelTemplate, ...
                                        coregExcldList, ...
                                        segExcldList, ...
                                        ageRange...
                                        );

    fprintf ('3.2 Bring to DARTEL space ...\n');
    WMHextraction_preprocessing_Step4 (studyFolder, dartelTemplate, coregExcldList, segExcldList, CNSP_path);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% non-brain tissue removal & FSL FAST %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    fprintf ('3.3 WMH extraction using kNN ...\n');
    
    % cmd_skullStriping_FAST_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction_SkullStriping_and_FAST.sh'];
    % system (cmd_skullStriping_FAST_1);
    
    % cmd_kNN_step1_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction_kNNdiscovery_Step1.sh'];
    % system (cmd_kNN_step1_1);
    
    probThr_str = num2str (probThr, '%1.2f');
    
    % cmd_kNN_step3_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction_kNNdiscovery_Step3.sh'];
    % system (cmd_kNN_step3_1);
    
    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            
            % 3.1.1 skull striping and FSL FAST
            cmd_skullStriping_FAST_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_SkullStriping_and_FAST.sh ' ...
                                                                                                                            T1folder(i).name ' ' ...
                                                                                                                            FLAIRfolder(i).name ' ' ...
                                                                                                                            studyFolder '/subjects ' ...
                                                                                                                            ID ' ' ...
                                                                                                                            CNSP_path ' ' ...
                                                                                                                            strrep(dartelTemplate, ' ', '_') ' ' ...
                                                                                                                            ageRange];
            system (cmd_skullStriping_FAST_2);
            
            % 3.1.2 kNN step 1
            cmd_kNN_step1_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step1.sh ' ...
                                                                                                            ID ' ' ...
                                                                                                            studyFolder '/subjects ' ...
                                                                                                            CNSP_path ' ' ...
                                                                                                            strrep(dartelTemplate, ' ', '_') ' ' ...
                                                                                                            ageRange];
            system (cmd_kNN_step1_2);
            
            % 3.1.3 kNN step 2
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
            % 3.1.4 kNN step 3
                                          
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



    % merge WMH results into one spreadsheet.
    fprintf ('3.4 Generating output ...\n');

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
    %         fprintf ('Download link: %s/subjects/QC/QC_final/QC_final.zip', studyFolder);
    %     case 'web&arch'
    %         fprintf ('Download link: %s/subjects/QC/QC_final/QC_final.zip', studyFolder);
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
    fprintf ('%.2f hours elapsed to finish the 3rd step.\n', total_time);
    fprintf ('');
    
