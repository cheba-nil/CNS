%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Step 1:  T1 & FLAIR Coregistration  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function WMHextraction_preprocessing_Step1 (studyFolder)

T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));

[Nsubj,n] = size (T1folder);


%% SPM coregistration

spm('defaults', 'fmri');

parfor i = 1:Nsubj

    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID
    
    matlabbatch = [];   % preallocate to enable parfor
    spm_jobman('initcfg');
    
    refImg = strcat (studyFolder, '/subjects/', ID, '/mri/orig/', T1folder(i).name, ',1');
    srcImg = strcat (studyFolder, '/subjects/', ID, '/mri/orig/', FLAIRfolder(i).name, ',1');
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {refImg};
    matlabbatch{1}.spm.spatial.coreg.estwrite.source = {srcImg};
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

    output = spm_jobman ('run',matlabbatch);
    
    mkdir (strcat(studyFolder, '/subjects/', ID, '/mri/'), 'preprocessing');
    movefile (strcat (studyFolder, '/subjects/', ID, '/mri/orig/r', FLAIRfolder(i).name), strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing'), 'f'); % move the coregistered flair to preprocessing folder
    
end
