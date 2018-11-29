


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
        subtemp = copy(template)

        if ismember(ID, excldIDs) == 0

            matlabbatch = [];   % preallocate to enable parfor
            spm_jobman('initcfg');
            
            % We need to do something different if we are to process in native space
            if strcmp(template.name, 'native template')
                % set the subtemp's ID
                subtemp.subID = i
                % Need to copy the flair image to preproc
                flair=strcat(studyFolder,'/subjects/',ID,'/mri/orig/',FLAIRfolder(i).name)
                rflair = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/r', FLAIRfolder(i).name);
                wflair = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/wr', FLAIRfolder(i).name);
                %reslice_nii(flair,wflair,[],[2])
                copyfile(flair,wflair) % trying to avoid reslicing

                % Because spm is annoying, let's be lazy and temporarily move rc[1-3]
                rc1 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/rc1',T1folder(i).name)
                rc2 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/rc2',T1folder(i).name)
                rc3 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/rc3',T1folder(i).name)
                tc1 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/tc1',T1folder(i).name)
                tc2 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/tc2',T1folder(i).name)
                tc3 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/tc3',T1folder(i).name)
                wc1 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/wc1',T1folder(i).name)
                wc2 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/wc2',T1folder(i).name)
                wc3 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/wc3',T1folder(i).name)
                c1 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/c1',T1folder(i).name)
                c2 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/c2',T1folder(i).name)
                c3 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/c3',T1folder(i).name)
                movefile(rc1,tc1)
                movefile(rc2,tc2)
                movefile(rc3,tc3)
    
                % Prep a few more variable names
                t1 = strcat(studyFolder,'/subjects/',ID,'/mri/orig/',T1folder(i).name)                
                rt1_o = strcat(studyFolder,'/subjects/',ID,'/mri/orig/r',T1folder(i).name)                
                rt1 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/r',T1folder(i).name)
                wt1 = strcat(studyFolder,'/subjects/',ID,'/mri/preprocessing/w',T1folder(i).name)
    
                % Perform the coregistrations to FLAIR dimensions
                CNSP_registration(rflair,wflair,pwd,c1) 
                CNSP_registration(rflair,wflair,pwd,c2) 
                CNSP_registration(rflair,wflair,pwd,c3) 
                CNSP_registration(rflair,wflair,pwd,t1) 
                
                % Some cleanup for compatibility
                movefile(rt1_o,wt1)
                movefile(rc1,wc1)
                movefile(rc2,wc2)
                movefile(rc3,wc3)
                movefile(tc1,rc1)
                movefile(tc2,rc2)
                movefile(tc3,rc3)

            else
                switch template.name
                    case 'existing template'
                        flowMap = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/u_rc1', T1folder(i).name);
                    
                    case 'creating template'
                        flowMap = [studyFolder '/subjects/' ID '/mri/preprocessing/u_rc1' T1imgFileName '_Template.nii'];

                end

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
