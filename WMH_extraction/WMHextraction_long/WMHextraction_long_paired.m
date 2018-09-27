% UBO Detector (longitudinal processing, paried sample)
%
% DESCRIPTION: subjects need to be scanned at all time points
%              to fit in this script.
%
    
function WMHextraction_long_paired (studyFolder, ...
                                        Ntp, ...
                                        spm12path, ...
                                        dartelTemplate, ...
                                        k, ...
                                        PVWMH_magnitude, ...
                                        coregExcldList, ...
                                        segExcldList, ...
                                        classifier, ...
                                        ageRange, ...
                                        probThr, ...
                                        outputFormat ...
                                        )


    tic;
    
    % training features 
    trainingFeatures1 = 1:9;
    trainingFeatures2 = 10:12;

    % add path
    CNSP_path = fileparts(fileparts(fileparts(which([mfilename '.m']))));

    addpath (spm12path);
    addpath(genpath(CNSP_path));
    
    fprintf ('\n');
    fprintf ('*******************************************\n');
    fprintf ('        WMH extraction pipeline        \n');
    fprintf ('   longitudinal analyses (paired sample)    \n');
    fprintf ('             No QC stops               \n');
    fprintf ('*******************************************\n');
    fprintf ('           Neuroimaging Lab            \n');
    fprintf ('   Centre for Healthy Brain Ageing   \n');
    fprintf ('*******************************************\n');
    fprintf ('\n');

    excldList = [coregExcldList ' ' segExcldList];
    excldIDs = strsplit (excldList, ' ');
 

    %% Organising folders 

    fprintf ('UBO Detector (paired long): organising folders ...\n');
    
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
    [Nt1,n] = size (T1folder);
    
    % gunzip niftis
    parfor i = 1:Nt1
        CNSP_gunzipnii ([studyFolder '/originalImg/T1/' T1folder(i).name]);
        CNSP_gunzipnii ([studyFolder '/originalImg/FLAIR/' FLAIRfolder(i).name]);
    end

    % re-list all T1 and FLAIR (all .nii)
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    tp1T1folder = dir (strcat (studyFolder,'/originalImg/T1/*_tp1_*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
    [Nt1,~] = size (T1folder);
    [Ntp1T1,~] = size (tp1T1folder);
    Nsubj = Nt1 / Ntp;
    
    % create a folder for each subject under subjects
    % folder, using ID as folder name. Copy corresponding T1 and FLAIR to the
    % orig folder of each subject
    parfor i = 1:Nt1
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        subjID = T1imgNames{1};   % first section is ID
        tpID = T1imgNames{2};
        fullID = [subjID '_' tpID];
        mkdir (strcat(studyFolder,'/subjects/',fullID,'/mri'),'orig');  % create orig folder under each subject folder
        copyfile (strcat (studyFolder,'/originalImg/T1/', T1folder(i).name), strcat(studyFolder,'/subjects/',fullID,'/mri/orig/'));        % copy T1 to each subject folder
        copyfile (strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name), strcat(studyFolder,'/subjects/',fullID,'/mri/orig/'));  % copy FLAIR to each subject folder
        
        mkdir ([studyFolder '/subjects/' fullID '/mri'], 'preprocessing');
    end

       
    %% other T1 register to first time point's T1
    fprintf ('UBO Detector (paired long): registering all time points'' T1 to the first time point ...\n');


    for f = 2:Ntp
%         tpXt1Folder = dir ([studyFolder '/originalImg/T1/*_tp' num2str(f) '_*.nii']);
%         [N_tpXt1Folder, ~] = size (tpXt1Folder);
        
        parfor i = 1:Nsubj
               
               tp1T1Name = tp1T1folder(i).name;
               
               tp1T1NameParts = strsplit (tp1T1Name, '_');
               subjID = tp1T1NameParts{1};
    %            tpID =  tp1t1NameParts{2};
               fullID = [subjID '_tp' num2str(f)];
               
               refImgName = dir ([studyFolder '/originalImg/T1/' subjID '_tp1_*.nii']);
               srcImgName = dir ([studyFolder '/originalImg/T1/' fullID '_*.nii']);

               CNSP_registration ([studyFolder '/originalImg/T1/' srcImgName(1).name], ...
                                    [studyFolder '/originalImg/T1/' refImgName(1).name], ...
                                    [studyFolder '/subjects/' fullID '/mri/preprocessing']);

               % rename coregistered T1 to "kr*"
               movefile ([studyFolder '/subjects/' fullID '/mri/preprocessing/r' srcImgName(1).name], ...
                            [studyFolder '/subjects/' fullID '/mri/preprocessing/kr' srcImgName(1).name]);

        end
    end
    
    

    

    %% register all flair to first time point's T1
    fprintf ('UBO Detector (paired long): registering all time points'' FLAIR to the first time point''s T1 ...\n');

    for f = 1:Ntp
        tpXflairFolder = dir ([studyFolder '/originalImg/FLAIR/*_tp' num2str(f) '_*.nii']);
        [NtpXflair,~] = size (tpXflairFolder);

        parfor i = 1:NtpXflair
          flairName = tpXflairFolder(i).name;
          flairNameParts = strsplit (flairName , '_');
          subjID = flairNameParts{1};

          refImgName = dir ([studyFolder '/originalImg/T1/' subjID '_tp1_*.nii']);
          CNSP_registration ([studyFolder '/originalImg/FLAIR/' flairName], ...
                        [studyFolder '/originalImg/T1/' refImgName(1).name], ...
                        [studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing']);
        end
    end
  

    fprintf ('UBO Detector (paired long): generating coregistration QC images ...\n');
    WMHextraction_QC_1 (studyFolder, outputFormat, 'long');   


    %% tp1 T1 segmentation, run DARTEL, and bring to DARTEL

    fprintf ('UBO Detector (paired long): time point 1''s T1 segmentation, run DARTEL, and bring to DARTEL ...\n');

    template1 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_1.nii'];
    template2 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_2.nii'];
    template3 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_3.nii'];
    template4 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_4.nii'];
    template5 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_5.nii'];
    template6 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_6.nii'];

                        
    
    
    parfor i = 1:Ntp1T1
        
        tp1T1name = tp1T1folder(i).name;
        tp1T1nameParts = strsplit (tp1T1name, '_');
        subjID = tp1T1nameParts{1};        
        [cGMtp1,cWMtp1,cCSFtp1,rcGMtp1,rcWMtp1,rcCSFtp1,seg8mattp1] = CNSP_segmentation ([studyFolder '/originalImg/T1/' tp1T1name], spm12path);

        flowMap = CNSP_runDARTELe (rcGMtp1, rcWMtp1, rcCSFtp1, template1, template2, template3, template4, template5, template6);

        % tp1 cCSF warp to DARTEL
        wcCSFtp1 = CNSP_nativeToDARTEL (cCSFtp1, flowMap);
        
        % tp1 T1 warp to DARTEL
        wT1onDARTEL = CNSP_nativeToDARTEL ([studyFolder '/originalImg/T1/' tp1T1name], flowMap);


        for f = 1:Ntp
            
            
            rFLAIRname_struct = dir ([studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/r' subjID '_' 'tp' num2str(f) '_*.nii']);
            rFLAIRname = rFLAIRname_struct(1).name;
            
            % all tps' rFLAIR warp to DARTEL
            wrFLAIRonDARTEL = CNSP_nativeToDARTEL ([studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/' rFLAIRname], flowMap);
            movefile (wrFLAIRonDARTEL, [studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing'], 'f');
            
            
            if f ~= 1
             
                krT1name_struct = dir ([studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/kr' subjID '_tp' num2str(f) '_*.nii']);
                krT1name = krT1name_struct(1).name;
                
                tp2endT1name_struct = dir ([studyFolder '/originalImg/T1/' subjID '_tp' num2str(f) '_*.nii']);
                tp2endT1name = tp2endT1name_struct(1).name;
                
                % tp2-end T1 segmentation
                [ckrGMtpX,ckrWMtpX,ckrCSFtpX,rckrGMtpX,rckrWMtpX,rckrCSFtpX,seg8mattpX] = CNSP_segmentation ([studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/' krT1name], spm12path);
                
                % tp2-end cCSF warp to DARTEL
                wckrCSFtpX = CNSP_nativeToDARTEL (ckrCSFtpX, flowMap);
                
                % tp2-end T1 warp to DARTEL
                wkrT1onDARTEL = CNSP_nativeToDARTEL ([studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/' krT1name], flowMap);
                
                movefile (wkrT1onDARTEL, [studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/w' tp2endT1name], 'f'); % rename to wT1
                
                movefile (ckrGMtpX, [studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/c1' tp2endT1name], 'f');
                movefile (ckrWMtpX, [studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/c2' tp2endT1name], 'f');
                movefile (ckrCSFtpX, [studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/c3' tp2endT1name], 'f');
                movefile (rckrGMtpX, [studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/rc1' tp2endT1name], 'f');
                movefile (rckrWMtpX, [studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/rc2' tp2endT1name], 'f');
                movefile (rckrCSFtpX, [studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/rc3' tp2endT1name], 'f');
                movefile (wckrCSFtpX, [studyFolder '/subjects/' subjID '_tp' num2str(f) '/mri/preprocessing/wc3' tp2endT1name], 'f');
            end
            
        end
        
        
        % moving tp1 files to preprocessing folder

        movefile (cGMtp1, [studyFolder '/subjects/' subjID '_tp1/mri/preprocessing'], 'f');
        movefile (cWMtp1, [studyFolder '/subjects/' subjID '_tp1/mri/preprocessing'], 'f');
        movefile (cCSFtp1, [studyFolder '/subjects/' subjID '_tp1/mri/preprocessing'], 'f');
        movefile (rcGMtp1, [studyFolder '/subjects/' subjID '_tp1/mri/preprocessing'], 'f');
        movefile (rcWMtp1, [studyFolder '/subjects/' subjID '_tp1/mri/preprocessing'], 'f');
        movefile (rcCSFtp1, [studyFolder '/subjects/' subjID '_tp1/mri/preprocessing'], 'f');
        movefile (wcCSFtp1, [studyFolder '/subjects/' subjID '_tp1/mri/preprocessing'], 'f');
        movefile (seg8mattp1, [studyFolder '/subjects/' subjID '_tp1/mri/preprocessing'], 'f');
        
        movefile (wT1onDARTEL, [studyFolder '/subjects/' subjID '_tp1/mri/preprocessing'], 'f');

        movefile (flowMap, [studyFolder '/subjects/' subjID '_tp1/mri/preprocessing'], 'f');
    end

    fprintf ('UBO Detector (paired long): generating segmentation QC images ...\n');
    WMHextraction_QC_2 (studyFolder, coregExcldList, outputFormat, 'long');





    %% non-brain tissue removal & FSL FAST
    
    fprintf ('UBO Detector (paired long): skull striping and FSL FAST ...\n');
    
   
    parfor i = 1:Nt1
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        subjID = T1imgNames{1};
        tpID = T1imgNames{2};
        fullID = [subjID '_' tpID];

        if ismember(subjID, excldIDs) == 0

            cmd_skullStriping_FAST_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_SkullStriping_and_FAST.sh ' ...
                                                                                                                            T1folder(i).name ' ' ...
                                                                                                                            FLAIRfolder(i).name ' ' ...
                                                                                                                            studyFolder '/subjects ' ...
                                                                                                                            fullID ' ' ...
                                                                                                                            CNSP_path ' ' ...
                                                                                                                            strrep(dartelTemplate, ' ', '_') ' ' ...
                                                                                                                            ageRange];
                                                                                                            % T1folder(i).name ' ' ...
                                                                                                            % FLAIRfolder(i).name ' ' ...
                                                                                                            % studyFolder '/subjects ' ...
                                                                                                            % fullID ' ' ...
                                                                                                            % CNSP_path];
            system (cmd_skullStriping_FAST_2);
        end

    end


    %% preprocessing for kNN
    fprintf ('UBO Detector (paired long): preprocessing for kNN ...\n');

    parfor i = 1:Nt1
        T1imgNames = strsplit (T1folder(i).name, '_');
        subjID = T1imgNames{1};
        tpID =  T1imgNames{2};
        fullID = [subjID '_' tpID];

        if ismember(subjID, excldIDs) == 0
            cmd_kNN_step1_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step1.sh ' ...
                                                                                                            fullID ' ' ...
                                                                                                            studyFolder '/subjects ' ...
                                                                                                            CNSP_path ' ' ...
                                                                                                            strrep(dartelTemplate, ' ', '_') ' ' ...
                                                                                                            ageRange];


                                                                                                % fullID ' ' ...
                                                                                                % studyFolder '/subjects ' ...
                                                                                                % CNSP_path];
            system (cmd_kNN_step1_2);
        end
    end



    %% kNN calculation
    fprintf ('UBO Detector (paired long): kNN calculation ...\n');
     
    parfor i = 1:Nt1
        T1imgNames = strsplit (T1folder(i).name, '_');
        subjID = T1imgNames{1};
        tpID =  T1imgNames{2};
        fullID = [subjID '_' tpID];
        
        if ismember(subjID, excldIDs) == 0
            WMHextraction_kNNdiscovery_Step2 (k, ...
                                              fullID, ...
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


    %% post-processing 1
    fprintf ('UBO Detector (paired long): post-processing ...\n');
    probThr_str = num2str (probThr, '%1.2f');

    parfor i = 1:Nt1
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        subjID = T1imgNames{1};   % first section is ID
        tpID =  T1imgNames{2};
        fullID = [subjID '_' tpID];

        if ismember(subjID, excldIDs) == 0
            cmd_kNN_step3_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh ' ...
                                                                                                fullID ' ' ...
                                                                                                studyFolder '/subjects ' ...
                                                                                                CNSP_path '/WMH_extraction ' ...
                                                                                                PVWMH_magnitude ' ' ...
                                                                                                probThr_str ...
                                                                                                ];
            system (cmd_kNN_step3_2);
        end
    end

    system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);
    
    for i = 1:Nt1
        T1imgNames = strsplit (T1folder(i).name, '_');
        subjID = T1imgNames{1};
        tpID =  T1imgNames{2};
        fullID = [subjID '_' tpID];

        if ismember(subjID, excldIDs) == 0
            cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' fullID ' ' studyFolder '/subjects'];
            system (cmd_merge_WMHresults_4);
        end
    end                                



    %%%%%%%%%%%%%%%%%%%%%%
    % QC_3: final output %
    %%%%%%%%%%%%%%%%%%%%%%
    fprintf ('UBO Detector (paired long): generating images for quality assurance of the final output ...\n');    
    WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, outputFormat, 'long');
    
    
    fprintf ('UBO Detector (paired long): FINISHED !\n');
    
    total_time = toc/3600; % in hrs
    fprintf ('UBO Detector (paired long): %.2f hours elapsed to finish the whole extraction procedure.\n', total_time);
    fprintf ('');
    