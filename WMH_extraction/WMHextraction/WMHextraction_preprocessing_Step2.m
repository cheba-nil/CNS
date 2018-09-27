


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Step 2:  T1 Segmentation  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function WMHextraction_preprocessing_Step2 (studyFolder, spm12path, coregExcldList)

    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));

    [Nsubj,n] = size (T1folder);
    
    coregExcldIDs = strsplit (coregExcldList, ' ');

    cmd_createCoregFailureFolder = ['if [ ! -d ' studyFolder '/subjects/coregQCfailure ]; then mkdir ' studyFolder '/subjects/coregQCfailure; fi'];
    

    
    system (cmd_createCoregFailureFolder);
    
    %% SPM segmentation

    spm('defaults', 'fmri');

            
    parfor i = 1:Nsubj

        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, coregExcldIDs) == 0
            
            matlabbatch = [];   % preallocate to enable parfor
            spm_jobman('initcfg');


            volume = strcat (studyFolder, '/subjects/', ID, '/mri/orig/', T1folder(i).name, ',1');
            tpm1 = strcat (spm12path, '/tpm/TPM.nii,1');
            tpm2 = strcat (spm12path, '/tpm/TPM.nii,2');
            tpm3 = strcat (spm12path, '/tpm/TPM.nii,3');
            tpm4 = strcat (spm12path, '/tpm/TPM.nii,4');
            tpm5 = strcat (spm12path, '/tpm/TPM.nii,5');
            tpm6 = strcat (spm12path, '/tpm/TPM.nii,6');


            matlabbatch{1}.spm.spatial.preproc.channel.vols = {volume};
            matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
            matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
            matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {tpm1};
            matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
            matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1];
            matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {tpm2};
            matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
            matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
            matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {tpm3};
            matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
            matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 1];
            matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {tpm4};
            matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
            matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {tpm5};
            matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
            matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {tpm6};
            matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
            matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
            matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
            matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
            matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
            matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
            matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
            matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];

            output = spm_jobman ('run',matlabbatch);

            movefile (strcat (studyFolder, '/subjects/', ID, '/mri/orig/c*'), strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing'), 'f'); % move the segmented T1 to preprocessing folder
            movefile (strcat (studyFolder, '/subjects/', ID, '/mri/orig/rc*'), strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing'), 'f'); % move the segmented T1 to preprocessing folder
            movefile (strcat (studyFolder, '/subjects/', ID, '/mri/orig/*.mat'), strcat (studyFolder, '/subjects/', ID, '/mri/preprocessing'), 'f');

            
        else
            movefile (strcat (studyFolder, '/subjects/', ID), strcat (studyFolder, '/subjects/coregQCfailure'), 'f');
        end
    end
    
    
    
    
    
    
    
    
    
    