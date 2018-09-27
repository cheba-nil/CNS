%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quality Checking 2 (QC_2) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Checking Segmentation   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function WMHextraction_QC_2 (studyFolder, coregExcldList, outputFormat, varargin)

    coregExcldIDs = strsplit (coregExcldList, ' ');

%     cmd_1 = ['chmod +x ' pipelineFolder '/generateQCimgs_2.sh'];
%     system (cmd_1);
% 
%     cmd_2 = [' if [ ! -d ' studyFolder '/subjects/QC ]; then mkdir ' studyFolder '/subjects/QC; fi'];
%     system (cmd_2);
% 
%     cmd_3 = ['if [ -f ' studyFolder '/subjects/QC/QC_Segmentation.html ]; then rm -f ' studyFolder '/subjects/QC/QC_Segmentation.html; fi'];
%     system (cmd_3);
% 
%     % cmd_4 = ['mkdir ' studyFolder '/subjects/QC/QC_Segmentation'];
%     % system (cmd_4);
% 
%     cmd_5 = ['echo "<HTML><TITLE>QC_Segmentation</TITLE><BODY BGCOLOR="#aaaaff">" >> ' studyFolder '/subjects/QC/QC_Segmentation.html'];
%     system (cmd_5);


    % loop through all subjects

    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
    [Nsubj,n] = size (T1folder);
    [~,Nexcld] = size (coregExcldIDs);
    
    T1 = cell ((Nsubj-Nexcld),1);
    Seg = cell ((Nsubj-Nexcld),3);
    k = 0;

    for i = 1:Nsubj

        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        if nargin == 3
            ID = T1imgNames{1};
        elseif (nargin == 4) && (strcmp (varargin{1}, 'long'))
            subjID = T1imgNames{1};
            tpID = T1imgNames{2};
            ID = [subjID '_' tpID];
        end
            

        if ismember(ID, coregExcldIDs) == 0
            k = k + 1;
            T1{k,1} = [studyFolder '/originalImg/T1/' T1folder(i).name];
            Seg{k,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/c1' T1folder(i).name];
            Seg{k,2} = [studyFolder '/subjects/' ID '/mri/preprocessing/c2' T1folder(i).name];
            Seg{k,3} = [studyFolder '/subjects/' ID '/mri/preprocessing/c3' T1folder(i).name];
%             cmd = [pipelineFolder '/generateQCimgs_2.sh ' ID ' ' studyFolder '/subjects'];
%             system (cmd);
        end
    end

    % slice and display
    CNSP_webViewSlices_overlay (T1, Seg, [studyFolder '/subjects/QC/QC_seg'], 'QC_segmentation', outputFormat);

%     cmd_6 = ['echo "</BODY></HTML>" >> ' studyFolder '/subjects/QC/QC_Segmentation.html'];
%     system (cmd_6);
% 
%     % cmd_7 = ['firefox ' studyFolder '/subjects/QC/QC_Segmentation.html'];   % use firefox to open the webpage - what if not installed?
%     % cmd_7 = ['open ' studyFolder '/subjects/QC/QC_Segmentation.html'];       % for MAC OS
%     % system (cmd_7);
% 
% 
%     QC_seg = [studyFolder '/subjects/QC/QC_Segmentation.html'];
%     web (QC_seg, '-new');

