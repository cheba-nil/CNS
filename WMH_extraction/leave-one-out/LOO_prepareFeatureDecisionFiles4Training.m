function uniqueIDs_cellArr = LOO_prepareFeatureDecisionFiles4Training (completeFeatureFile, completeDecisionFile, completeLookupFile, operationFolder)

	fid = fopen (completeLookupFile);
	completeLookup = textscan (fid, '%s%d%d', 'Delimiter', ' ');
	fclose (fid);
	completeFeature = importdata (completeFeatureFile);
	completeDecision = importdata (completeDecisionFile);
	% completeLookup = importdata (completeLookupFile);

	% [a,b] = size (completeFeature)
	% [c,d] = size (completeDecision)
	% [e,f] = size (completeLookup)

	completeTraining = horzcat (completeLookup{1}, ...
								num2cell(completeLookup{2}), ...
								num2cell(completeLookup{3}), ...
								num2cell(completeFeature), ...
								completeDecision);

	uniqueIDs_cellArr = unique (completeLookup{1});
	[N_uniqueIDs, ~] = size (uniqueIDs_cellArr);

	fprintf ('%d unique IDs found in the complete training data.\n', N_uniqueIDs);

	parfor i = 1:N_uniqueIDs
		excludeID = uniqueIDs_cellArr{i};
		excludeID_idx = strcmp (completeLookup{1}(:), excludeID);
		trimmed_completeTraining = completeTraining;
		trimmed_completeTraining (excludeID_idx,:) = [];

		trimmed_lookup_cellArr = trimmed_completeTraining (:,1:3);
		trimmed_feature_cellArr = trimmed_completeTraining (:,4:15);
		trimmed_decision_cellArr = trimmed_completeTraining (:,16);

		% write to textfile
		trimmed_lookup_TBL = cell2table (trimmed_lookup_cellArr);
		trimmed_feature_TBL = cell2table (trimmed_feature_cellArr);
		trimmed_decision_TBL = cell2table (trimmed_decision_cellArr);


		if exist ([operationFolder '/LOO_predict' excludeID], 'dir') ~= 7
			system (['mkdir ' operationFolder '/LOO_predict' excludeID]);
			system (['mkdir ' operationFolder '/LOO_predict' excludeID '/customiseClassifier']);
			system (['mkdir ' operationFolder '/LOO_predict' excludeID '/customiseClassifier/textfiles']);
		elseif exist ([operationFolder '/LOO_predict' excludeID '/customiseClassifier'], 'dir') ~= 7
			system (['mkdir ' operationFolder '/LOO_predict' excludeID '/customiseClassifier']);
			system (['mkdir ' operationFolder '/LOO_predict' excludeID '/customiseClassifier/textfiles']);
		elseif exist ([operationFolder '/LOO_predict' excludeID '/customiseClassifier/textfiles'], 'dir') ~= 7
			system (['mkdir ' operationFolder '/LOO_predict' excludeID '/customiseClassifier/textfiles']);
		end

		trimmed_feature_path = [operationFolder '/LOO_predict' excludeID '/customiseClassifier/textfiles/feature_forTraining.txt'];
		trimmed_decision_path = [operationFolder '/LOO_predict' excludeID '/customiseClassifier/textfiles/decision_forTraining.txt'];
		ttrimmed_lookup_path = [operationFolder '/LOO_predict' excludeID '/customiseClassifier/textfiles/lookup_forTraining.txt'];

		writetable (trimmed_feature_TBL, ...
		            trimmed_feature_path, ...
		            'WriteVariableNames', false, ...
		            'WriteRowNames', false, ...
		            'Delimiter', ' '...
		            );

		writetable (trimmed_decision_TBL, ...
		            trimmed_decision_path, ...
		            'WriteVariableNames', false, ...
		            'WriteRowNames', false, ...
		            'Delimiter', ' '...
		            );

		writetable (trimmed_lookup_TBL, ...
		            ttrimmed_lookup_path, ...
		            'WriteVariableNames', false, ...
		            'WriteRowNames', false, ...
		            'Delimiter', ' '...
		            );
	end