  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quality Checking 1 (QC_1) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Checking co-registration %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function WMHextraction_QC_1 (studyFolder, outputFormat, varargin)


% cmd_1 = ['chmod +x ' pipelineFolder '/generateQCimgs_1.sh'];
% system (cmd_1);
% 
% cmd_2 = [' if [ ! -d ' studyFolder '/subjects/QC ]; then mkdir ' studyFolder '/subjects/QC; fi'];
% system (cmd_2);
% 
% cmd_3 = ['if [ -f ' studyFolder '/subjects/QC/QC_coreg.html ]; then rm -f ' studyFolder '/subjects/QC/QC_coreg.html; fi'];
% system (cmd_3);
% 
% % cmd_4 = ['mkdir ' studyFolder '/subjects/QC/QC_final'];
% % system (cmd_4);
% 
% cmd_5 = ['echo "<HTML><TITLE>QC_Coregistration</TITLE><BODY BGCOLOR="#aaaaff">" >> ' studyFolder '/subjects/QC/QC_coreg.html'];
% system (cmd_5);

mkdir ([studyFolder '/subjects'], 'QC');
mkdir ([studyFolder '/subjects/QC'], 'QC_coreg');
mkdir ([studyFolder '/subjects/QC'], 'QC_seg');
mkdir ([studyFolder '/subjects/QC'], 'QC_final');


% loop through all subjects

T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
[Nsubj,n] = size (T1folder);

T1 = cell (Nsubj, 1);
rFLAIR = cell (Nsubj, 1);

for i = 1:Nsubj

    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    if nargin == 2
        ID = T1imgNames{1};
    elseif (nargin == 3) && (strcmp (varargin{1}, 'long'))
        subjID = T1imgNames{1};
        tpID = T1imgNames{2};
        ID = [subjID '_' tpID];
    end
    
    T1{i,1} = [studyFolder '/originalImg/T1/' T1folder(i).name];
    rFLAIR{i,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/r' FLAIRfolder(i).name];

%     cmd = [pipelineFolder '/generateQCimgs_1.sh ' ID ' ' studyFolder '/subjects ' T1folder(i).name];
%     system (cmd);
   
end

    % slice and display
    CNSP_webViewSlices_pair (T1, rFLAIR, [studyFolder '/subjects/QC/QC_coreg'], 'QC_coregistration', outputFormat);
    
    
% 
% cmd_6 = ['echo "</BODY></HTML>" >> ' studyFolder '/subjects/QC/QC_coreg.html'];
% system (cmd_6);
% 
% % cmd_7 = ['firefox ' studyFolder '/subjects/QC/QC_coreg.html'];   % use firefox to open the webpage - what if not installed?
% % cmd_7 = ['open ' studyFolder '/subjects/QC/QC_coreg.html'];     % for MAC OS
% % system (cmd_7);
% 
% QC_coreg = [studyFolder '/subjects/QC/QC_coreg.html'];
% web (QC_coreg, '-new');

