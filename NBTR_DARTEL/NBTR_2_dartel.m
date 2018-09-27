


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Step 3:  Run DARTEL     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function NBTR_2_dartel (imgFolder, CNSP_path, dartelTemplate, ageRange, segExcldList)

    excldIDs = strsplit (segExcldList, ' ');
   
    % SPM DARTEL

    spm('defaults', 'fmri');
    
    switch dartelTemplate
        case 'existing'
            existingTemplateDARTELrun (imgFolder, CNSP_path, ageRange, excldIDs)
        case 'creating'
            creatingTemplateDARTELrun (imgFolder, excldIDs);

    end
    
    
    
 %% existing template DARTEL run
function existingTemplateDARTELrun (imgFolder, CNSP_path, ageRange, excldIDs)
    
    
    imgs = dir (strcat (imgFolder,'/*.nii'));
    [Nsubj,n] = size (imgs);
    
    % excldIDs_list = strsplit (excldIDs, ' ');

        
    template1 = strcat (CNSP_path, '/Templates/DARTEL_0to6_templates/', ageRange, '/Template_1.nii');
    template2 = strcat (CNSP_path, '/Templates/DARTEL_0to6_templates/', ageRange, '/Template_2.nii');
    template3 = strcat (CNSP_path, '/Templates/DARTEL_0to6_templates/', ageRange, '/Template_3.nii');
    template4 = strcat (CNSP_path, '/Templates/DARTEL_0to6_templates/', ageRange, '/Template_4.nii');
    template5 = strcat (CNSP_path, '/Templates/DARTEL_0to6_templates/', ageRange, '/Template_5.nii');
    template6 = strcat (CNSP_path, '/Templates/DARTEL_0to6_templates/', ageRange, '/Template_6.nii');



    parfor i = 1:Nsubj   % skip the current and parent folder

        imgNames = strsplit (imgs(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0

            matlabbatch = [];   % preallocate to enable parfor
            spm_jobman('initcfg');

            rcimage1 = strcat (imgFolder, '/spmoutput/rc1', imgs(i).name, ',1');
            rcimage2 = strcat (imgFolder, '/spmoutput/rc2', imgs(i).name, ',1');
            rcimage3 = strcat (imgFolder, '/spmoutput/rc3', imgs(i).name, ',1');


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
        end

    end
    
    
    %% creating template
function creatingTemplateDARTELrun (imgFolder, excldIDs)

    rcCellArray = cell(3,1);

    % excldIDs_list = strsplit (excldIDs, ' ');

    imgs = dir (strcat (imgFolder,'/*.nii'));
    [Nsubj,n] = size (imgs);
    
    for i = 1:Nsubj   % skip the current and parent folder

        imgNames = strsplit (imgs(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            rcCellArray{1}{end+1,1} = [imgFolder '/spmoutput/rc1' imgs(i).name ',1'];
            rcCellArray{2}{end+1,1} = [imgFolder '/spmoutput/rc2' imgs(i).name ',1'];
            rcCellArray{3}{end+1,1} = [imgFolder '/spmoutput/rc3' imgs(i).name ',1'];
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
