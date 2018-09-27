% leave-one-out cross-validation using training set

% pass more than eight variables to enable calculation of agreement measurements
% varargin{1} = ground truth folder

function LOO_main (operationFolder, ...
					completeFeatureFile, ...
					completeDecisionFile, ...
					completeLookupFile, ...
					spm12path, ...
					k, ...
					ageRange, ...
					probThr, ...
					varargin)


	LOO_folder = fileparts (mfilename ('fullpath'));
	CNSP_folder = fileparts (fileparts (LOO_folder));

	addpath (LOO_folder, [CNSP_folder '/Scripts/DOEE_Wack2012']);

	% output training files for each LOO
	uniqueIDs_cellArr = LOO_prepareFeatureDecisionFiles4Training (completeFeatureFile, completeDecisionFile, completeLookupFile, operationFolder);

	% copy images
	LOO_cpImg2correspondingFolder (uniqueIDs_cellArr, operationFolder);

	% run UBO Detector for LOO
	LOO_runUBOdetector (operationFolder, uniqueIDs_cellArr, spm12path, k, ageRange, probThr);


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% if calculation of measurements is enabled %%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin > 8

		if exist ([operationFolder '/DOEE'], 'dir') == 7
			system (['rm -fr ' operationFolder '/DOEE']);
		end

		system (['mkdir ' operationFolder '/DOEE']);
		system (['mkdir ' operationFolder '/DOEE/rater1 ' operationFolder '/DOEE/rater2']);

		% rater1 = machine (LOO cross-validation results)
		% rater2 = manual tracing
		[N_uniqueIDs, ~] = size (uniqueIDs_cellArr);
		parfor i = 1 : N_uniqueIDs
			system (['cp ' operationFolder '/LOO_predict' uniqueIDs_cellArr{i} '/subjects/' ...
									uniqueIDs_cellArr{i} '/mri/extractedWMH/' uniqueIDs_cellArr{i} '_WMH.nii.gz' ...
									' ' ...
									operationFolder '/DOEE/rater1']);
		end
		system (['cp ' varargin{1} '/*.nii.gz ' operationFolder '/DOEE/rater2']);

		% calculation of DOEE as per Wack et al., 2012
		DOEE_folder = [operationFolder '/DOEE'];

		DOEE_main (DOEE_folder, spm12path);

		% summarise cohort DOEE results
		system ([LOO_folder '/LOO_finalSummariseDOEEresultsInTheSample.sh ' DOEE_folder]);
	end



