   
    
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
                                        outputFormat, ...
                                        nsegs ...
                                        )


    tic;

    % training features 
    trainingFeatures1 = 1:9;
    trainingFeatures2 = 10:12;

    % add path
    WMHextractionPath = fileparts(fileparts(fileparts(which([mfilename '.m']))));
    CNSP_path = fileparts (WMHextractionPath);
    addpath (spm12path, genpath(WMHextractionPath), [CNSP_path '/Scripts'], [CNSP_path '/downloaded_scipts/NIfTI_tools']);

    % Initialize our template
    switch dartelTemplate
        case 'existing template'
            template = DartelTemplate(CNSP_path,ageRange,studyFolder);
        case 'creating template'
            template = CohortTemplate(strcat(studyFolder,'/subjects'));
        case 'native template'
            template = NativeTemplate(CNSP_path,ageRange,studyFolder);
    end
    
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
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        CNSP_gunzipnii ([studyFolder '/originalImg/T1/' T1folder(i).name]);
        CNSP_gunzipnii ([studyFolder '/originalImg/FLAIR/' FLAIRfolder(i).name]);

        mkdir (strcat(studyFolder,'/subjects/',ID,'/mri'),'orig');  % create orig folder under each subject folder
        copyfile (strcat (studyFolder,'/originalImg/T1/', T1folder(i).name), strcat(studyFolder,'/subjects/',ID,'/mri/orig/'));        % copy T1 to each subject folder
        copyfile (strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name), strcat(studyFolder,'/subjects/',ID,'/mri/orig/'));  % copy FLAIR to each subject folder

    
        %%%%%%%%%%%%%%%%%
        % Run SPM steps %
        %%%%%%%%%%%%%%%%%
        fprintf ('WMH extraction step 1: T1 & FLAIR coregistration ...\n');
        WMHextraction_preprocessing_Step1 (studyFolder,i); % Step 1: coregistration
        
        %fprintf ('Generating coregistration QC images ...\n');
        % TODO: figure out what to do here
        %WMHextraction_QC_1 (studyFolder, outputFormat); % coregistration QC
        

        fprintf ('WMH extraction step 2: T1 segmentation ...\n');
        WMHextraction_preprocessing_Step2 (studyFolder, spm12path, coregExcldList,i); % Step 2: segmentation
      
        %fprintf ('Generating segmentation QC images ...\n');
        % TODO: figure out what to do here
        %WMHextraction_QC_2 (studyFolder, coregExcldList, outputFormat); % segmentation QC
        
        fprintf ('WMH extraction step 3: Running DARTEL ...\n');
        
        fprintf ('3.1 Running DARTEL ...\n');
        WMHextraction_preprocessing_Step3 (studyFolder, ...
                                            CNSP_path, ...
                                            template, ...
                                            coregExcldList, ...
                                            segExcldList, ...
                                            ageRange,...
                                            i); 

        fprintf ('3.2: Bring to DARTEL ...\n');
        WMHextraction_preprocessing_Step4 (studyFolder, template, coregExcldList, segExcldList, CNSP_path,i); % Step 4: bring to DARTEL

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % non-brain tissue removal & FSL FAST %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        fprintf ('3.3 WMH extraction using kNN ...\n');
    
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            subtemp = copy(template);
            if strcmp(template.name, 'native template')
                subtemp.subID = i; % need to set the template subject if native
            end 
            subject_log('Running WMHextraction_SkullStriping_and_FAST ...\n\n',studyFolder,ID);

            cmd_skullStriping_FAST_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_SkullStriping_and_FAST.sh ' ...
                T1folder(i).name ' '...
                FLAIRfolder(i).name ' ' ...
                studyFolder '/subjects ' ...
                ID ' ' ...
                subtemp.brain_mask ' ' ...
                strrep(subtemp.name, ' ', '_') ' ' ...
                subtemp.gm_prob ' ' ...
                char(string(nsegs))];
            [status,cmdout] = system (cmd_skullStriping_FAST_2);
            subject_log(cmdout,studyFolder,ID);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % kNN WMH discovery Step 1: Preprocessing %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            subject_log('Running WMHextraction_kNNdiscovery_Step1.sh ...\n\n',studyFolder,ID);
            cmd_kNN_step1_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step1.sh ' ...
                ID ' ' ...
                studyFolder '/subjects ' ...
                subtemp.wm_prob_thr ' ' ...
                strrep(subtemp.name, ' ', '_') ' ' ...
                char(string(nsegs))];
            [status,cmdout] = system (cmd_kNN_step1_2);
            subject_log(cmdout,studyFolder,ID);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % kNN WMH discovery Step 2: kNN calculation %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
            subject_log('Running WMHextraction_kNNdiscovery_Step2 ...\n\n',studyFolder,ID);
            WMHextraction_kNNdiscovery_Step2 (k, ...
                                              ID, ...
                                              classifier, ...
                                              subtemp, ...
                                              probThr, ...
                                              trainingFeatures1, ...
                                              trainingFeatures2, ...
                                              nsegs ...
                                              );


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % kNN WMH discovery Step 3: Postprocessing and cleanup %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            probThr_str = num2str (probThr, '%1.2f');
    
            subject_log('Running WMHextraction_kNNdiscovery_Step3.sh...\n\n',studyFolder,ID);
            cmd_kNN_step3_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh ' ...
                        ID ' ' ...
                        studyFolder '/subjects ' ...
                        CNSP_path '/WMH_extraction ' ...
                        PVWMH_magnitude ' ' ...
                        probThr_str ' ' ...
                        subtemp.wm_prob_thr ' ' ...
                        subtemp.ventricles ' ' ...
                        subtemp.lobar ' ' ...
                        subtemp.arterial ' ' 
                        ];
            [status,cmdout] = system (cmd_kNN_step3_2);
            subject_log(cmdout,studyFolder,ID);
        end
    end

    
    
    %%%%%%%%%%%%%%%%%%%%%
    % Generating output %
    %%%%%%%%%%%%%%%%%%%%%
    
    fprintf ('3.4 Generating output ...\n');

    system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);

    for i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            subject_log('Running WMHextraction_kNNdiscovery_Step4.sh ...\n\n',studyFolder,ID)
            cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ID ' ' studyFolder '/subjects'];
            [status,cmdout] = system (cmd_merge_WMHresults_4);
            subject_log(cmdout,studyFolder,ID)
        end
    end                                
    
    fprintf ('Generating coregistration QC images ...\n');
    WMHextraction_QC_1 (studyFolder, outputFormat); % coregistration QC
    fprintf ('Generating segmentation QC images ...\n');
    WMHextraction_QC_2 (studyFolder, coregExcldList, outputFormat); % segmentation QC
    fprintf ('3.5 Generating images for quality assurance of the final output ...\n');
    WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, outputFormat);

    if ~strcmp(template.name, 'native template')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Bring back to native space %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf ('3.6 Bringing DARTEL space WMH mask to native space ...\n');


        parfor i = 1:Nsubj
            T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
            ID = T1imgNames{1};   % first section is ID
            
            if ismember(ID, excldIDs) == 0
                switch template.name
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
    end 


    %%%%%%%%%%%%%%%%%%%%%%
    %% "finish" message %%
    %%%%%%%%%%%%%%%%%%%%%%

    fprintf ('*** FINISHED ! ***\n');

    
    total_time = toc/3600; % in hrs
    fprintf ('');
    fprintf ('%.2f hours elapsed to finish.\n', total_time);
    fprintf ('');
