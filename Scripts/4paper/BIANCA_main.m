% BIANCA main

spm12path = '/home/jiyang/Work/BIANCA_training10_testing40_comparisonForPaper/scripts/spm12';

output_folder = '/home/jiyang/Work/BIANCA_training10_testing40_comparisonForPaper/testing40';
% need an ID list in text file
IDlist = [output_folder '/IDlist.txt'];
testingID_startingPoint = 11;

trainingID_list = '';
for m = 1:(testingID_startingPoint-2)
	trainingID_list = [trainingID_list num2str(m) ','];
end
trainingID_list = [trainingID_list num2str(testingID_startingPoint-1)];

% % Number of subj
% N_subj = 40;
rawT1_folder = [output_folder '/rawT1'];
rawFLAIR_folder = [output_folder '/rawFLAIR'];
curr_folder = fileparts (mfilename ('fullpath'));

outputFodler_parentFolder = fileparts (output_folder);
labelledMasks_folder = [outputFodler_parentFolder '/training10/manuallyLabelledMask_nativeFLAIRspace'];
% flirt_output_folder = [output_folder '/T1_reg2FLAIR'];

addpath (spm12path, fileparts(curr_folder));

IDlist_fid = fopen (IDlist);
IDlist_cellArr_in1stElement = textscan (IDlist_fid,'%s',40);
IDlist_cellArr = IDlist_cellArr_in1stElement{1};
fclose (IDlist_fid);

[N_subj, ~] = size (IDlist_cellArr);

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

system (['mkdir ' output_folder '/T1reg2FLAIR']);
system (['mkdir ' output_folder '/T1reg2FLAIR_mtx']);
system (['mkdir ' output_folder '/gmwmcsf_segments']);
system (['mkdir ' output_folder '/FLAIRspace2MNI']);
system (['mkdir ' output_folder '/BIANCA_result']);

parfor i = 1:N_subj
	rawT1_struct = dir ([rawT1_folder '/' IDlist_cellArr{i} '*.nii.gz'])
	rawT1_filename = rawT1_struct(1).name;
	rawT1 = [rawT1_folder '/' rawT1_filename];

	rawFLAIR_struct = dir ([rawFLAIR_folder '/' IDlist_cellArr{i} '*.nii.gz']);
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


	% T1 in FLAIR space FNIRT to MNI
	fprintf ('FNIRT T1 in FLAIR space to MNI space --- (ID = %s)\n', IDlist_cellArr{i});
	system ([curr_folder '/BIANCA_T1toMNI_fnirt.sh ' rawFLAIR_folder '/' IDlist_cellArr{i} '_T1_FLAIRspace_brain.nii.gz ' ...
														output_folder ' ' ...
														IDlist_cellArr{i}]);
end


% Write to BIANCA_masterfile.txt
for j = 1:N_subj
	system ([curr_folder '/BIANCA_build_masterfile.sh ' output_folder ' ' ...
														labelledMasks_folder ' ' ...
														IDlist]);
end

% Run BIANCA
parfor k = testingID_startingPoint:N_subj

	system ([curr_folder '/BIANCA_runBIANCA.sh ' output_folder ' ' ...
												num2str(k) ' ' ...
												IDlist_cellArr{k} ' ' ...
												trainingID_list]);
end