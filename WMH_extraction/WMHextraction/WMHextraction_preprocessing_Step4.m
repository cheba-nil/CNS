


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Step 4:  bring T1, FLAIR, GM, WM, and CSF to DARTEL space  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function WMHextraction_preprocessing_Step4 (studyFolder, template, coregExcldList, segExcldList, CNSP_path)

    excldList = [coregExcldList ' ' segExcldList];
    excldIDs = strsplit (excldList, ' ');

    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));

    [Nsubj,n] = size (T1folder);


    %% SPM segmentation

    spm('defaults', 'fmri');

    parfor i = 1:Nsubj

        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        T1imgFileNames = strsplit (T1folder(i).name, '.');
        ID = T1imgNames{1};   % first section is ID
        T1imgFileName = T1imgFileNames{1};

        if ismember(ID, excldIDs) == 0

            matlabbatch = [];   % preallocate to enable parfor
            spm_jobman('initcfg');

            switch template.name
                case 'existing template'
                    flowMap = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/u_rc1', T1folder(i).name);
                
                case 'creating template'
                    flowMap = [studyFolder '/subjects/' ID '/mri/preprocessing/u_rc1' T1imgFileName '_Template.nii'];

            end
%             
            
            

            origT1 = strcat (studyFolder, '/subjects/', ID, '/mri/orig/', T1folder(i).name);
            rFLAIR = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/r', FLAIRfolder(i).name);
            cGM = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/c1', T1folder(i).name);
            cWM = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/c2', T1folder(i).name);
            cCSF = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/c3', T1folder(i).name);


            matlabbatch{1}.spm.tools.dartel.crt_warped.flowfields = {flowMap};
            matlabbatch{1}.spm.tools.dartel.crt_warped.images = {
                                                                 {origT1}
                                                                 {rFLAIR}
                                                                 {cGM}
                                                                 {cWM}
                                                                 {cCSF}
                                                                 }';
            matlabbatch{1}.spm.tools.dartel.crt_warped.jactransf = 0;
            matlabbatch{1}.spm.tools.dartel.crt_warped.K = 6;
            matlabbatch{1}.spm.tools.dartel.crt_warped.interp = 1;

            output = spm_jobman ('run',matlabbatch);

        end
    end
    

    if strcmp (template.name,'creating template')

            % create studyFolder/subjects/cohort_probability_maps
            if exist([studyFolder '/subjects/cohort_probability_maps'],'dir') == 7
                rmdir ([studyFolder '/subjects/cohort_probability_maps'],'s');
            end
            mkdir ([studyFolder '/subjects'], 'cohort_probability_maps');


            % average wcGM/wcWM/wcCSF
            wcGMarr = cell (Nsubj,1);
            wcWMarr = cell (Nsubj,1);
            wcCSFarr = cell (Nsubj,1);

            for j = 1:Nsubj
                T1imgNames = strsplit (T1folder(j).name, '_');   % split T1 image name, delimiter is underscore
                ID = T1imgNames{1};   % first section is ID
                
                wcGMarr{j,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/wc1' T1folder(j).name];
                wcWMarr{j,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/wc2' T1folder(j).name];
                wcCSFarr{j,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/wc3' T1folder(j).name];
            end

            outputDir = [studyFolder '/subjects/cohort_probability_maps'];

            GMavg = CNSP_imgCal ('avg', ...
                                outputDir, ...
                                'cohort_GM_probability_map', ...
                                Nsubj, ...
                                wcGMarr...
                                );
            WMavg = CNSP_imgCal ('avg', ...
                                outputDir, ...
                                'cohort_WM_probability_map', ...
                                Nsubj, ...
                                wcWMarr...
                                );
            CSFavg = CNSP_imgCal ('avg', ...
                                outputDir, ...
                                'cohort_CSF_probability_map', ...
                                Nsubj, ...
                                wcCSFarr...
                                );

            % cohort probability maps thr 0.8
%             system (['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/cohortAvgProbMaps_thr0_8.sh']);
            system ([CNSP_path '/WMH_extraction/WMHextraction/cohortAvgProbMaps_thr0_8.sh ' ...
                                                                            GMavg ' ' ...
                                                                            WMavg ' ' ...
                                                                            CSFavg ' ' ...
                                                                            outputDir...
                                                                            ]);


            % move generated Template0-6
            cmd_mvTemplate_1 = ['if [ ! -d ' studyFolder '/subjects/DARTELtemplate ]; then mkdir ' studyFolder '/subjects/DARTELtemplate; fi'];
            system (cmd_mvTemplate_1);
            % SubjDirExistingFolders = dir (strcat(studyFolder, '/subjects'));
            % firstID = SubjDirExistingFolders(3).name;
            % cmd_mvTemplate_2 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_0.nii ' studyFolder '/subjects/DARTELtemplate'];
            % cmd_mvTemplate_3 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_1.nii ' studyFolder '/subjects/DARTELtemplate'];
            % cmd_mvTemplate_4 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_2.nii ' studyFolder '/subjects/DARTELtemplate'];
            % cmd_mvTemplate_5 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_3.nii ' studyFolder '/subjects/DARTELtemplate'];
            % cmd_mvTemplate_6 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_4.nii ' studyFolder '/subjects/DARTELtemplate'];
            % cmd_mvTemplate_7 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_5.nii ' studyFolder '/subjects/DARTELtemplate'];
            % cmd_mvTemplate_8 = ['mv ' studyFolder '/subjects/' firstID '/mri/preprocessing/Template_6.nii ' studyFolder '/subjects/DARTELtemplate'];
            cmd_mvTemplate_2 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_0.nii ' studyFolder '/subjects/DARTELtemplate'];
            cmd_mvTemplate_3 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_1.nii ' studyFolder '/subjects/DARTELtemplate'];
            cmd_mvTemplate_4 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_2.nii ' studyFolder '/subjects/DARTELtemplate'];
            cmd_mvTemplate_5 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_3.nii ' studyFolder '/subjects/DARTELtemplate'];
            cmd_mvTemplate_6 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_4.nii ' studyFolder '/subjects/DARTELtemplate'];
            cmd_mvTemplate_7 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_5.nii ' studyFolder '/subjects/DARTELtemplate'];
            cmd_mvTemplate_8 = ['mv ' studyFolder '/subjects/*/mri/preprocessing/Template_6.nii ' studyFolder '/subjects/DARTELtemplate'];
            system (cmd_mvTemplate_2);
            system (cmd_mvTemplate_3);
            system (cmd_mvTemplate_4);
            system (cmd_mvTemplate_5);
            system (cmd_mvTemplate_6);
            system (cmd_mvTemplate_7);
            system (cmd_mvTemplate_8);
 

    end
