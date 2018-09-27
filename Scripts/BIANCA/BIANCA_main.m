% -----------
% BIANCA main
% -----------
%
% DESCRIPTION:
% ------------
% A pipeline to run FSL BIANCA.
%
%
% USAGE:
% ------
% output_folder = the study folder that all operations are conducted
%
% rawT1 & rawFLAIR folders should be under output_folder, containing T1 and FLAIR images
% of BOTH training AND predicting subjects. The images should be named as ID_*.nii.gz.
%
% A list of IDs (training IDs followed by predicting IDs) is needed under output_folder
%
% labelledMasks_folder = the folder for TRAINING set with manually labelled WMH, 
%                        named as ID_labelledMask.nii.gz
%
% manTracedWMH_folder = the folder for PREDICTING set with manually traced WMH, 
%                       named as ID_manTracedWMH.nii.gz. This is varargin{1}, and only needed for 
%                       calculating BIANCA performance measures. If this argument is passed to
%                       BIANCA_main, performance measures are automatically calculated.
%
% threshold = probability threshold applied to BIANCA probability map (e.g. 8 means a threshold of 0.8)
%
% testingID_startPoint = the line number of the first predicting ID in the ID list. E.g. in the ID list,
%                        10 training subjects are followed by 40 predicting subjects. Then the 
%                        testingID_startPoint = 11.
% 
%
% OTHER INFO:
% -----------
% check T1 to FLAIR registration if observing abnormal results, and cut neck
%
%
% EXAMPLE:
% --------
% spm12path = '/home/jiyang/Work/BIANCA_training10_testing40_comparisonForPaper/scripts/spm12';
% output_folder = '/home/jiyang/Work/BIANCA_training10_testing40_comparisonForPaper/testing5';
% outputFodler_parentFolder = fileparts (output_folder);
% labelledMasks_folder = [outputFodler_parentFolder '/training10/manuallyLabelledMask_nativeFLAIRspace'];
% threshold = 8; % 0.8 as probability threshold
% testingID_startingPoint = 11;
%
% BIANCA_main (spm12path, output_folder, labelledMasks_folder, threshold, testingID_startingPoint)

function BIANCA_main (spm12path, output_folder, labelledMasks_folder, threshold, testingID_startingPoint, varargin)

% need an ID list in text file
IDlist = [output_folder '/IDlist.txt'];

trainingID_list = '';
for m = 1:(testingID_startingPoint-2)
	trainingID_list = [trainingID_list num2str(m) ','];
end
trainingID_list = [trainingID_list num2str(testingID_startingPoint-1)];

% Clean previous results
if exist ([output_folder '/T1reg2FLAIR'], 'dir') == 7
	system (['rm -fr ' output_folder '/T1reg2FLAIR']);
end

if exist ([output_folder '/T1reg2FLAIR_mtx'], 'dir') == 7
	system (['rm -fr ' output_folder '/T1reg2FLAIR_mtx']);
end

if exist ([output_folder '/gmwmcsf_segments'], 'dir') == 7
	system (['rm -fr ' output_folder '/gmwmcsf_segments']);
end

if exist ([output_folder '/FLAIRspace2MNI'], 'dir') == 7
	system (['rm -fr ' output_folder '/FLAIRspace2MNI']);
end

if exist ([output_folder '/BIANCA_result'], 'dir') == 7
	system (['rm -fr ' output_folder '/BIANCA_result']);
end

if exist ([output_folder '/T1_fsl_anat'], 'dir') == 7
	system (['rm -fr ' output_folder '/T1_fsl_anat']);
end

if exist ([output_folder '/BIANCA_mask'], 'dir') == 7
	system (['rm -fr ' output_folder '/BIANCA_mask']);
end

if exist ([output_folder '/BIANCA_performance_measures'], 'dir') == 7
	system (['rm -fr ' output_folder '/BIANCA_performance_measures']);
end

system (['mkdir ' output_folder '/T1reg2FLAIR']);
system (['mkdir ' output_folder '/T1reg2FLAIR_mtx']);
system (['mkdir ' output_folder '/gmwmcsf_segments']);
system (['mkdir ' output_folder '/FLAIRspace2MNI']);
system (['mkdir ' output_folder '/BIANCA_result']);
system (['mkdir ' output_folder '/T1_fsl_anat']);
system (['mkdir ' output_folder '/BIANCA_mask']);
system (['mkdir ' output_folder '/BIANCA_performance_measures']);

% system (['rm -f ' output_folder '/rawFLAIR/*brain.nii.gz']);
system (['rm -fr ' output_folder '/rawFLAIR/NBTR']);

rawT1_folder = [output_folder '/rawT1'];
rawFLAIR_folder = [output_folder '/rawFLAIR'];
curr_folder = fileparts (mfilename ('fullpath'));

% rawT1_struct = dir ([rawT1_folder '/*.nii.gz']);
% rawFLAIR_struct = dir ([rawFLAIR_folder '/*.nii.gz']);

addpath (spm12path, fileparts(curr_folder), curr_folder);

IDlist_fid = fopen (IDlist);
IDlist_cellArr_in1stElement = textscan (IDlist_fid, '%s', 'Delimiter', '\n');
IDlist_cellArr = IDlist_cellArr_in1stElement{1};
fclose (IDlist_fid);

[N_subj, ~] = size (IDlist_cellArr);



parfor i = 1:N_subj
	rawT1_struct = dir ([rawT1_folder '/' IDlist_cellArr{i} '_*.nii.gz'])
	rawT1_filename = rawT1_struct(1).name;
	rawT1 = [rawT1_folder '/' rawT1_filename];

	rawFLAIR_struct = dir ([rawFLAIR_folder '/' IDlist_cellArr{i} '_*.nii.gz']);
	rawFLAIR_filename = rawFLAIR_struct(1).name;
	rawFLAIR = [rawFLAIR_folder '/' rawFLAIR_filename];

	% T1 flirt to FLAIR
	fprintf ('FLIRT T1 to FLAIR --- (ID = %s)\n', IDlist_cellArr{i});

	system ([curr_folder '/BIANCA_T1toFLAIR_flirt.sh ' rawT1 ' ' ...
														rawFLAIR ' ' ...
														output_folder ' ' ...
														IDlist_cellArr{i}]);

	% NBTR for T1 in FLAIR space
	fprintf ('NBTR for T1 in FLAIR space --- (ID = %s)\n', IDlist_cellArr{i});
	system (['gunzip ' output_folder '/T1reg2FLAIR/' IDlist_cellArr{i} '_T1flirt2FLAIR.nii.gz']);
	[cGM,cWM,cCSF,rcGM,rcWM,rcCSF,seg8mat] = CNSP_segmentation ([output_folder '/T1reg2FLAIR/' IDlist_cellArr{i} '_T1flirt2FLAIR.nii'], ...
																spm12path);
	CNSP_NBTRn (rawFLAIR, cGM, cWM, cCSF, [rawFLAIR_folder '/' IDlist_cellArr{i} '_FLAIR_brain.nii.gz']);
	CNSP_NBTRn ([output_folder '/T1reg2FLAIR/' IDlist_cellArr{i} '_T1flirt2FLAIR.nii.gz'], ...
									cGM, cWM, cCSF, [rawFLAIR_folder '/' IDlist_cellArr{i} '_T1_FLAIRspace_brain.nii.gz']);
	system (['gzip ' output_folder '/T1reg2FLAIR/' IDlist_cellArr{i} '_T1flirt2FLAIR.nii']);
	system (['mv ' cGM ' ' cWM ' ' cCSF ' ' output_folder '/gmwmcsf_segments']);
	system (['rm -f ' rcGM ' ' rcWM ' ' rcCSF ' ' seg8mat]);


	% T1 in FLAIR space FLIRT to MNI
	fprintf ('FLIRT T1 (registered to FLAIR) to MNI space --- (ID = %s)\n', IDlist_cellArr{i});
	system ([curr_folder '/BIANCA_T1toMNI_flirt.sh ' rawFLAIR_folder '/' IDlist_cellArr{i} '_T1_FLAIRspace_brain.nii.gz ' ...
														output_folder ' ' ...
														IDlist_cellArr{i}]);
end


% Write to BIANCA_masterfile.txt
system ([curr_folder '/BIANCA_build_masterfile.sh ' output_folder ' ' ...
													labelledMasks_folder ' ' ...
													IDlist]);



% Run BIANCA
parfor k = testingID_startingPoint:N_subj

	system ([curr_folder '/BIANCA_runBIANCA.sh ' output_folder ' ' ...
												num2str(k) ' ' ...
												IDlist_cellArr{k} ' ' ...
												trainingID_list]);

end


% threshold prob map
system ([curr_folder '/BIANCA_thrProbMap.sh ' output_folder ' ' num2str(threshold)]);


% clean NBTR FLAIR and T1onFLAIRspace in rawFLAIR folder
system (['mkdir ' rawFLAIR_folder '/NBTR']);
system (['mv ' rawFLAIR_folder '/*_brain.nii.gz ' rawFLAIR_folder '/NBTR']);

% masking
parfor m = testingID_startingPoint:N_subj
	rawFLAIR_struct = dir ([rawFLAIR_folder '/' IDlist_cellArr{m} '_*.nii.gz']);
	rawFLAIR_filename = rawFLAIR_struct(1).name;
	rawFLAIR = [rawFLAIR_folder '/' rawFLAIR_filename];

	system ([curr_folder '/BIANCA_masking.sh ' output_folder ' ' IDlist_cellArr{m} ' ' rawFLAIR ' ' num2str(threshold)])
end

% calculating performance evaluation measures
if nargin == 6

	% calculating individual measures
	manTracedWMH_folder = varargin{1};
	parfor n = testingID_startingPoint:N_subj
		system ([curr_folder '/BIANCA_performanceMeasurements.sh ' output_folder ' ' ...
																  IDlist_cellArr{n} ' ' ...
																  manTracedWMH_folder '/' IDlist_cellArr{n} '_manTracedWMH.nii.gz ' ...
																  num2str(threshold)]);
	end

	% summarise cohort measures
	%
	% create title for the summary file
	system ([curr_folder '/BIANCA_summarisePerfMeas_createTitle.sh ' output_folder]);

	% summarise for cohort
	for j = testingID_startingPoint:N_subj
		system ([curr_folder '/BIANCA_summarisePerfMeas.sh ' output_folder ' ' ...
															 IDlist_cellArr{j}]);
	end
end

% display
BIANCA_displayResults (output_folder, ...
						testingID_startingPoint, ...
						(N_subj - testingID_startingPoint + 1), ...
						num2str(threshold))