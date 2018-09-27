function LOO_cpImg2correspondingFolder (uniqueIDs_cellArr, operationFolder)

	[N_uniqueIDs, ~] = size (uniqueIDs_cellArr);

	parfor i = 1 : N_uniqueIDs
		system (['mkdir ' operationFolder '/LOO_predict' uniqueIDs_cellArr{i} '/T1']);
		system (['mkdir ' operationFolder '/LOO_predict' uniqueIDs_cellArr{i} '/FLAIR']);

		system (['cp ' operationFolder '/T1/' uniqueIDs_cellArr{i} '_*.nii* ' operationFolder '/LOO_predict' uniqueIDs_cellArr{i} '/T1']);
		system (['cp ' operationFolder '/FLAIR/' uniqueIDs_cellArr{i} '_*.nii* ' operationFolder '/LOO_predict' uniqueIDs_cellArr{i} '/FLAIR']);
	end