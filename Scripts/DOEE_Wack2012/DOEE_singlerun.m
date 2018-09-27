
% rater1_result and rater2_result should be in the same folder, where output is saved to

function DOEE_singlerun (rater1_result, rater2_result, outputDIR, spm12path)


CNSP_path = fileparts (fileparts (fileparts (mfilename ('fullpath'))));

addpath (genpath ([CNSP_path '/Scripts']));

if (exist (rater1_result, 'file') == 2) && (exist (rater2_result, 'file') == 2)
	CNSP_gunzipnii (rater1_result);
	CNSP_gunzipnii (rater2_result);
end

[rater1_result_folder, rater1_result_filename, rater1_result_ext] = fileparts (rater1_result);

rater1_result_filename_parts_CellArr = strsplit (rater1_result_filename, '_');

ID = rater1_result_filename_parts_CellArr{1};

% if strcmp (rater1_result_filename_parts_CellArr{2}, 'WMH')
% 	ID = rater1_result_filename_parts_CellArr{1};
% else
% 	ID = [rater1_result_filename_parts_CellArr{1} '_' rater1_result_filename_parts_CellArr{2}];
% end

rater1_result_parts = strsplit (rater1_result, '.');
rater2_result_parts = strsplit (rater2_result, '.');

rater1_result = [rater1_result_parts{1} '.nii'];
rater2_result = [rater2_result_parts{1} '.nii'];

DOEE_calculation (rater1_result, rater2_result, 6, outputDIR, spm12path, ID);

% finally re-gzip for re-run
% system (['gzip ' outputDIR '/*.nii']);
system (['gzip ' rater1_result ' ' rater2_result]);
