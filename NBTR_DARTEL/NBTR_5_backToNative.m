%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% bring non-brain removed image back to native space %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function NBTR_5_backToNative (imgFolder, dartelTemplate, segExcldList)

excldIDs = strsplit (segExcldList, ' ');

imgs = dir (strcat (imgFolder,'/*.nii'));
[Nsubj,n] = size (imgs);
 
spm('defaults', 'fmri');


parfor i = 1:Nsubj
    
    spm_jobman('initcfg');
    matlabbatch = [];   % preallocate to enable parfor
    
    imgNames = strsplit (imgs(i).name, '_');   % split T1 image name, delimiter is underscore
    imgFileNames = strsplit (imgs(i).name, '.');
    ID = imgNames{1};   % first section is ID
    imgFileName = imgFileNames{1};
    if ismember(ID, excldIDs) == 0
        switch dartelTemplate
            case 'existing'
                flowMap = strcat (imgFolder, '/spmoutput/u_rc1', imgs(i).name);
            case 'creating'
                flowMap = [imgFolder '/spmoutput/u_rc1' imgFileName '_Template.nii'];
        end

        nonbrainRemoved_DARTEL = [imgFolder '/nonbrainRemoved/' imgFileName '_nonbrainRemoved_DARTEL.nii'];

        matlabbatch{1}.spm.tools.dartel.crt_iwarped.flowfields = {flowMap};
        matlabbatch{1}.spm.tools.dartel.crt_iwarped.images = {nonbrainRemoved_DARTEL};
        matlabbatch{1}.spm.tools.dartel.crt_iwarped.K = 6;
        matlabbatch{1}.spm.tools.dartel.crt_iwarped.interp = 1;

        output = spm_jobman ('run',matlabbatch);

        switch dartelTemplate
            case 'existing'
                system (['mv ' imgFolder '/spmoutput/w' imgFileName '_nonbrainRemoved_DARTEL_u_rc1' imgFileName '.nii ' ...
                imgFolder '/nonbrainRemoved/' imgFileName '_nonbrainRemoved_NATIVE.nii']);
            case 'creating'
                system (['mv ' imgFolder '/spmoutput/w' imgFileName '_nonbrainRemoved_DARTEL_u_rc1' imgFileName '_Template.nii ' ...
                imgFolder '/nonbrainRemoved/' imgFileName '_nonbrainRemoved_NATIVE.nii']);
        end
    end
end