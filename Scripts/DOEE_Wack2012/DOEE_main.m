% doee_main

% rater1 (e.g. machine-derived WMH) and rater2 (e.g. manual traced WMH)
% are saved in two folders - rater1 and rater2, respectively, which are
% saved in a folder (raw_data_folder). Images are gzipped (ID_*.nii.gz).

% ID is unique, and is the first part of filename (delimited by _)

function DOEE_main (raw_data_folder, spm12path)

% raw_data_folder = '/data_pri/jiyang/wmhProject/manualTracing4paper/Rebecca_review/Similarity/calculate_doee_Wack2012';
% spm12path = '/usr/share/spm12';

addpath (fileparts (mfilename ('fullpath')));

% raw_data = dir ([raw_data_folder '/*FLAIRspace.nii.gz']);

rater1_filename_struct = dir ([raw_data_folder '/rater1/*.nii.gz']);
rater2_filename_struct = dir ([raw_data_folder '/rater2/*.nii.gz']);
[N_rater1_imgs, ~] = size (rater1_filename_struct);

parfor i = 1:N_rater1_imgs
	rater1_filename = rater1_filename_struct(i).name;
	rater2_filename	= rater2_filename_struct(i).name;

	rater1_filename_parts = strsplit (rater1_filename, '_');

	ID = rater1_filename_parts{1};


	% output folder - folder name as ID
	system (['mkdir ' raw_data_folder '/' ID]);
	% system (['cp ' raw_data_folder '/rater?/' ID '*.nii.gz ' raw_data_folder '/' ID]);

	% rater1 = UBO Detector
	% rater2 = manual tracing
	rater1_result = [raw_data_folder '/rater1/' rater1_filename];
	rater2_result = [raw_data_folder '/rater2/' rater2_filename];

	% output folder
	outputDIR = [raw_data_folder '/' ID];

	% run doee_singlerun
	DOEE_singlerun (rater1_result, rater2_result, outputDIR, spm12path)

end