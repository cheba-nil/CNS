% mode = 'procAndExt' or 'onlyExt'

function ASLprocessing_main_FSL_postproc_cortSubcor (studyFolder, mode)

	Perfusion_folder = fileparts (mfilename ('fullpath'));

	origT1folder = [studyFolder '/originalImg/T1'];

	origT1folder_contents = dir ([origT1folder '/*.nii.gz']);

	Nsubj = size (origT1folder_contents, 1);

	% text output
	system (['if [ -f "' studyFolder '/subjects/CBFinCortexAndSubcor.txt" ];' ...
				'then rm -f ' studyFolder '/subjects/CBFinCortexAndSubcor.txt;fi']);

	system (['echo ' '"ID,' ...
					 'subcortical,' ...
					 'cortex' ...
					 '" > ' ...
					 studyFolder '/subjects/CBFinCortexAndSubcor.txt']);


	% postprocessing - extract arterial territories
	if strcmp (mode, 'procAndExt')
		parfor i = 1:Nsubj

			T1filenameParts = strsplit (origT1folder_contents(i).name, '_');
			ID = T1filenameParts{1};

			system ([Perfusion_folder '/ASLprocessing_FSL/ASLprocessing_FSL_postprocessing_cortexAndSubcortical.sh ' ...
													'--Sdir ' studyFolder ' -id ' ID]);

		end
	end

	% write TXT output
	fprintf ('Summarising cortical and subcortical CBF ...');

	for i = 1:Nsubj

		T1filenameParts = strsplit (origT1folder_contents(i).name, '_');
		ID = T1filenameParts{1};

		system ([Perfusion_folder '/ASLprocessing_FSL/ASLprocessing_FSL_postprocessing_cortexAndSubcortical_summariseTXToutput.sh ' ...
												'--Sdir ' studyFolder ' -id ' ID]);

	end

	fprintf ('   Done.\n');