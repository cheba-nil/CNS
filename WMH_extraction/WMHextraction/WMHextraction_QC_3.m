  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quality Checking 3 (QC_3) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Checking final output   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, outputFormat, varargin)
    excldList = [coregExcldList ' ' segExcldList];
    excldIDs = strsplit (excldList, ' ');
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
    [Nsubj,~] = size (T1folder);
    [~, Nexcld] = size (excldIDs);

    wrFLAIR = cell ((Nsubj-Nexcld),1);
    WMH = cell ((Nsubj-Nexcld),1);
    k = 0;
    
    for i = 1:Nsubj

        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore

        if nargin == 4
            ID = T1imgNames{1};
        elseif (nargin == 5) && (strcmp (varargin{1}, 'long')) % longitudinal run
            subjID = T1imgNames{1};
            tpID =  T1imgNames{2};
            ID = [subjID '_' tpID];
        end

        if ismember(ID, excldIDs) == 0
            k = k + 1;
            wrFLAIR{k,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/wr' FLAIRfolder(i).name];
            WMH{k,1} = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii.gz'];
        end
    end

    if exist ([studyFolder '/subjects/QC'], 'dir') ~= 7
        mkdir ([studyFolder '/subjects'], 'QC');
    end
    
    if exist ([studyFolder '/subjects/QC/QC_final'], 'dir') ~= 7
        mkdir ([studyFolder '/subjects/QC'], 'QC_final');
    end
    
    
    % slice and display
    CNSP_webViewSlices_overlay (wrFLAIR, WMH, [studyFolder '/subjects/QC/QC_final'], 'QC_final', outputFormat);

%     excldList = [coregExcldList ' ' segExcldList];
%     excldIDs = strsplit (excldList, ' ');
% 
% 
%     cmd_1 = ['chmod +x ' pipelineFolder '/generateQCimgs_3.sh'];
%     system (cmd_1);
% 
%     cmd_2 = [' if [ ! -d ' studyFolder '/subjects/QC ]; then mkdir ' studyFolder '/subjects/QC; fi'];
%     system (cmd_2);
% 
%     cmd_3 = ['if [ -f ' studyFolder '/subjects/QC/QC_final.html ]; then rm -f ' studyFolder '/subjects/QC/QC_final.html; fi'];
%     system (cmd_3);
% 
%     % cmd_4 = ['mkdir ' studyFolder '/subjects/QC/QC_final'];
%     % system (cmd_4);
% 
%     cmd_5 = ['echo "<HTML><TITLE>QC_final_output</TITLE><BODY BGCOLOR="#aaaaff">" >> ' studyFolder '/subjects/QC/QC_final.html'];
%     system (cmd_5);
% 
% 
%     % loop through all subjects
% 
%     T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
%     FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
%     [Nsubj,n] = size (T1folder);
% 
%     for i = 1:Nsubj
% 
%         T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
%         ID = T1imgNames{1};   % first section is ID
% 
%         if ismember(ID, excldIDs) == 0
%             cmd = [pipelineFolder '/generateQCimgs_3.sh ' ID ' ' studyFolder '/subjects'];
%             system (cmd);
%         end
%     end
% 
% 
% 
%     cmd_6 = ['echo "</BODY></HTML>" >> ' studyFolder '/subjects/QC/QC_final.html'];
%     system (cmd_6);
% 
%     % cmd_7 = ['firefox ' studyFolder '/subjects/QC/QC_final.html'];   % use firefox to open the webpage - what if not installed?
%     % cmd_7 = ['open ' studyFolder '/subjects/QC/QC_final.html'];      % for MAC OS
%     % system (cmd_7);
% 
%     QC_final = [studyFolder '/subjects/QC/QC_final.html'];
%     web (QC_final, '-new');


% ------ webpage for refined images ------

% baseImgCellArr_Vertical = cell(Nsubj,1);
% overlayImgCellArr_Vertical = cell(Nsubj,1);
% 
% for j = 1:Nsubj
%     T1imgNames = strsplit (T1folder(j).name, '_');
%     FLAIRimgNames = strsplit (FLAIRfolder(j).name,'.');
%     ID = T1imgNames{1};
%     
%     baseImgCellArr_Vertical{j,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/FAST_nonBrainRemoved_wr' FLAIRimgNames{1} '_restore'];
%     overlayImgCellArr_Vertical{j,1} = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_refined'];
% end
% 
% CNSP_webViewSlices (baseImgCellArr_Vertical, overlayImgCellArr_Vertical, [studyFolder '/subjects/QC'], 'refinement_output', 'web')






