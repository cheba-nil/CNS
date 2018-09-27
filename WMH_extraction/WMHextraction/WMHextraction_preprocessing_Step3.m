


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Step 3:  Run DARTEL     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function WMHextraction_preprocessing_Step3 (studyFolder, ...
                                            CNSP_path, ...
                                            dartelTemplate, ...
                                            coregExcldList, ...
                                            segExcldList, ...
                                            ageRange)


    cmd_createSegFailureFolder = ['if [ ! -d ' studyFolder '/subjects/segQCfailure ]; then mkdir ' studyFolder '/subjects/segQCfailure; fi'];
    system (cmd_createSegFailureFolder);
    
    % SPM DARTEL

    spm('defaults', 'fmri');
    
    switch dartelTemplate
        case 'existing template'
            existingTemplateDARTELrun (studyFolder, CNSP_path, coregExcldList, segExcldList, ageRange)
            
        case 'creating template'
            creatingTemplateDARTELrun (studyFolder, coregExcldList, segExcldList);

    end
    
    
    
 %% existing template DARTEL run
function existingTemplateDARTELrun (studyFolder, CNSP_path, coregExcldList, segExcldList, ageRange)
    
    
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
    [Nsubj,n] = size (T1folder);

    excldList = [coregExcldList ' ' segExcldList];
    excldIDs = strsplit (excldList, ' ');
    
    segExcldIDs = strsplit (segExcldList, ' ');


    template1 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_1.nii'];
    template2 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_2.nii'];
    template3 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_3.nii'];
    template4 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_4.nii'];
    template5 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_5.nii'];
    template6 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                            ageRange ...
                            '/Template_6.nii'];
 


    parfor i = 1:Nsubj

        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0

            matlabbatch = [];   % preallocate to enable parfor
            spm_jobman('initcfg');

            rcimage1 = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/rc1', T1folder(i).name, ',1');
            rcimage2 = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/rc2', T1folder(i).name, ',1');
            rcimage3 = strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing/rc3', T1folder(i).name, ',1');


            matlabbatch{1}.spm.tools.dartel.warp1.images = {
                                                    {rcimage1}
                                                    {rcimage2}
                                                    {rcimage3}
                                                    }';
            matlabbatch{1}.spm.tools.dartel.warp1.settings.rform = 0;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).its = 3;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).rparam = [4 2 1e-06];
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).K = 0;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).template = {template1};
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).its = 3;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).rparam = [2 1 1e-06];
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).K = 0;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).template = {template2};
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).its = 3;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).rparam = [1 0.5 1e-06];
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).K = 1;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).template = {template3};
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).its = 3;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).rparam = [0.5 0.25 1e-06];
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).K = 2;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).template = {template4};
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).its = 3;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).rparam = [0.25 0.125 1e-06];
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).K = 4;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).template = {template5};
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).its = 3;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).rparam = [0.25 0.125 1e-06];
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).K = 6;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).template = {template6};
            matlabbatch{1}.spm.tools.dartel.warp1.settings.optim.lmreg = 0.01;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.optim.cyc = 3;
            matlabbatch{1}.spm.tools.dartel.warp1.settings.optim.its = 3;

            output = spm_jobman ('run',matlabbatch);

        elseif ismember(ID, segExcldIDs) == 1
            movefile (strcat (studyFolder, '/subjects/', ID), strcat (studyFolder, '/subjects/segQCfailure'));

        end

    end
    
    
    %% creating template
function creatingTemplateDARTELrun (studyFolder, coregExcldList, segExcldList)

    rcCellArray = cell(3,1);

    excldList = [coregExcldList ' ' segExcldList];
    excldIDs = strsplit (excldList, ' ');
%         [k,sizeExcldIDarray] = size (excldIDs);

    segExcldIDs = strsplit (segExcldList, ' ');

    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
%         FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*'));

    [Nsubj,n] = size (T1folder);

    cmd_createSegFailureFolder = ['if [ ! -d ' studyFolder '/subjects/segQCfailure ]; then mkdir ' studyFolder '/subjects/segQCfailure; fi'];
    system (cmd_createSegFailureFolder);

    for i = 1:Nsubj

        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            rcCellArray{1}{end+1,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/rc1' T1folder(i).name ',1'];
            rcCellArray{2}{end+1,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/rc2' T1folder(i).name ',1'];
            rcCellArray{3}{end+1,1} = [studyFolder '/subjects/' ID '/mri/preprocessing/rc3' T1folder(i).name ',1'];
        elseif ismember (ID, segExcldIDs) ==1
            movefile (strcat (studyFolder, '/subjects/', ID), strcat (studyFolder, '/subjects/segQCfailure'));
        end
    end



    matlabbatch{1}.spm.tools.dartel.warp.images = rcCellArray;
%%
    matlabbatch{1}.spm.tools.dartel.warp.settings.template = 'Template';
    matlabbatch{1}.spm.tools.dartel.warp.settings.rform = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).K = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).slam = 16;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).K = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).slam = 8;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).K = 1;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).slam = 4;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).K = 2;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).slam = 2;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).K = 4;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).slam = 1;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).K = 6;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.cyc = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.its = 3;
    
    output = spm_jobman ('run',matlabbatch);

    