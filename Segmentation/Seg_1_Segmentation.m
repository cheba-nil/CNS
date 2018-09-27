
%%%%%%%%%%%%%%%%%%%
%   Segmentation  %
%%%%%%%%%%%%%%%%%%%



function Seg_1_Segmentation (imgFolder, spm12path)

    imgs = dir (strcat (imgFolder,'/*.nii'));
    [Nsubj,n] = size (imgs);
    

    if exist ([imgFolder '/spmoutput'],'dir') ~= 7
        mkdir ([imgFolder '/spmoutput']);
    end
     
    %% SPM segmentation

    spm('defaults', 'fmri');

    parfor i = 1:Nsubj

        imgNames = strsplit (imgs(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = imgNames{1};   % first section is ID
        imgFilenames = strsplit (imgs(i).name, '.');
        imgFilename = imgFilenames{1};

        matlabbatch = [];   % preallocate to enable parfor
        spm_jobman('initcfg');


        volume = strcat (imgFolder, '/', imgs(i).name, ',1');
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
        
         movefile (strcat (imgFolder, '/c1', imgFilename, '.nii'), strcat (imgFolder, '/spmoutput'), 'f');
         movefile (strcat (imgFolder, '/c2', imgFilename, '.nii'), strcat (imgFolder, '/spmoutput'), 'f');
         movefile (strcat (imgFolder, '/c3', imgFilename, '.nii'), strcat (imgFolder, '/spmoutput'), 'f');
         movefile (strcat (imgFolder, '/rc1', imgFilename, '.nii'), strcat (imgFolder, '/spmoutput'), 'f');
         movefile (strcat (imgFolder, '/rc2', imgFilename, '.nii'), strcat (imgFolder, '/spmoutput'), 'f');
         movefile (strcat (imgFolder, '/rc3', imgFilename, '.nii'), strcat (imgFolder, '/spmoutput'), 'f');
         movefile (strcat (imgFolder, '/', imgFilename, '_seg8.mat'), strcat (imgFolder, '/spmoutput'), 'f');

         copyfile ([imgFolder '/spmoutput/c1' imgFilename '.nii'],[imgFolder '/segmentation/GM/' ID '_GM_Native.nii']);
         copyfile ([imgFolder '/spmoutput/c2' imgFilename '.nii'],[imgFolder '/segmentation/WM/' ID '_WM_Native.nii']);
         copyfile ([imgFolder '/spmoutput/c3' imgFilename '.nii'],[imgFolder '/segmentation/CSF/' ID '_CSF_Native.nii']);

    end
    

    
    
    
    
    
    
    
    
    
    