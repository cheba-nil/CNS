%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate.m
%
% This function will warp the indicated Dartel template into native space.
% It requires rc(1-3)(obj.subID)_T1.nii to have been created already 
% Furthermore WMHextraction_preprocessing_Step3 must have been called using 
% a Dartel space template.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function generate(obj);
    
    % first setup the required folders
    mkdir(obj.dir);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % UGLY CODE ALERT:
    % The following code chunk has been moved to the
    % native template section withing Step3
    % to avoid each subject being processed multiple times
    % as a result TAKE NOTE OF THE FOLLOWING LINE:
    % preproc_Step3 must be called for the DARTEL template
    % before a native template can be established 
    % FOR ANY OF THE SUBJECTS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % this little hack is required for now to get the 
    % DARTEL template into native space
    dtemplate = DartelTemplate(obj.CNS_path, obj.age_range, obj.studyFolder);
    %WMHextraction_preprocessing_Step3(obj.studyFolder,obj.CNS_path, ... 
    %                                  dtemplate,'','',obj.age_range);

    tmpf = strcat(obj.dir,'/tmp.nii.gz');

    % and move the warp to our template directory
    warpfile = strcat('u_rc1',obj.subID,'_T1.nii');
    movefile(strcat(obj.studyFolder,'/subjects/',obj.subID,...
                    '/mri/preprocessing/',warpfile), ...
             strcat(obj.dir,'/',warpfile));
 
    % unzip into our template directory
    copyfile(dtemplate.brain_mask,obj.dir);
    copyfile(dtemplate.gm_prob,obj.dir);
    copyfile(dtemplate.wm_prob,obj.dir);
    copyfile(dtemplate.csf_prob,obj.dir);
    copyfile(dtemplate.ventricles,obj.dir);
    copyfile(dtemplate.lobar,obj.dir);
    copyfile(dtemplate.arterial,obj.dir);

    % set variables pointing to the unzipped masks in the template folder
    brain_mask = strcat( ...
            obj.dir, '/DARTEL_brain_mask.nii');
    gm_prob = strcat( ...
            obj.dir,'/DARTEL_GM_prob_map.nii');
    wm_prob = strcat( ...
            obj.dir,'/DARTEL_WM_prob_map.nii');
    csf_prob = strcat( ...
            obj.dir,'/DARTEL_CSF_prob_map.nii');
    ventricles = strcat( ...
            obj.dir,'/DARTEL_ventricle_distance_map.nii');
    lobar = strcat( ...
            obj.dir, '/DARTEL_lobar_template.nii');
    arterial = strcat( ...
            obj.dir,'/DARTEL_arterial_template.nii');


    % now apply the warp to each of the template files
    fn_wbrain_mask = CNSP_DARTELtoNative( ... 
            brain_mask,strcat(obj.dir,'/',warpfile),'NN');
    fn_wgm_prob = CNSP_DARTELtoNative( ... 
            gm_prob,strcat(obj.dir,'/',warpfile));
    fn_wwm_prob = CNSP_DARTELtoNative( ...
            wm_prob,strcat(obj.dir,'/',warpfile));
    fn_wcsf_prob = CNSP_DARTELtoNative( ... 
            csf_prob,strcat(obj.dir,'/',warpfile));
    fn_wventricles = CNSP_DARTELtoNative( ... 
            ventricles,strcat(obj.dir,'/',warpfile));
    fn_wlobar = CNSP_DARTELtoNative( ... 
            lobar,strcat(obj.dir,'/',warpfile),'NN');
    fn_warterial = CNSP_DARTELtoNative( ... 
            arterial,strcat(obj.dir,'/',warpfile),'NN');

    % remove the old unziped files
    delete(brain_mask);
    delete(gm_prob);
    delete(wm_prob);
    delete(csf_prob);
    delete(ventricles);
    delete(lobar);
    delete(arterial);

    % set some variables
    wbrain_mask = strcat(obj.dir,'/wbrain_mask.nii');
    wgm_prob = strcat(obj.dir,'/wGM_prob_map.nii');
    wwm_prob = strcat(obj.dir,'/wWM_prob_map.nii');
    wcsf_prob = strcat(obj.dir,'/wCSF_prob_map.nii'); 
    wventricles = strcat(obj.dir,'/wVentricle_distance_map.nii'); 
    wlobar = strcat(obj.dir,'/wlobar_template.nii'); 
    warterial = strcat(obj.dir,'/warterial_template.nii');

    % rename
    movefile(fn_wbrain_mask,wbrain_mask);
    movefile(fn_wgm_prob,wgm_prob);
    movefile(fn_wwm_prob,wwm_prob);
    movefile(fn_wcsf_prob,wcsf_prob);
    movefile(fn_wventricles,wventricles);
    movefile(fn_wlobar,wlobar);
    movefile(fn_warterial,warterial);

    % Perform reslicing and registration
    flair = strcat(obj.studyFolder,'/subjects/',obj.subID,...
                    '/mri/orig/',obj.subID,'_FLAIR.nii'); ...
    t1 = strcat(obj.studyFolder,'/subjects/',obj.subID,...
                    '/mri/orig/',obj.subID,'_T1.nii'); ...
    
    CNSP_reverse_registration_wMx(flair,t1,obj.dir,wbrain_mask);
    CNSP_reverse_registration_wMx(flair,t1,obj.dir,wgm_prob,'Tri');
    CNSP_reverse_registration_wMx(flair,t1,obj.dir,wwm_prob,'Tri');
    CNSP_reverse_registration_wMx(flair,t1,obj.dir,wcsf_prob,'Tri');
    CNSP_reverse_registration_wMx(flair,t1,obj.dir,wventricles,'Tri');
    CNSP_reverse_registration_wMx(flair,t1,obj.dir,wlobar);
    CNSP_reverse_registration_wMx(flair,t1,obj.dir,warterial);

    % Remove NaN's because they're evil
    tmpfuz = strcat(obj.dir,'/tmp.nii');

    system(['$FSLDIR/bin/fslmaths ',obj.brain_mask,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,obj.brain_mask);

    system(['$FSLDIR/bin/fslmaths ',obj.gm_prob,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,obj.gm_prob);

    system(['$FSLDIR/bin/fslmaths ',obj.wm_prob,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,obj.wm_prob);

    system(['$FSLDIR/bin/fslmaths ',obj.csf_prob,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,obj.csf_prob);

    system(['$FSLDIR/bin/fslmaths ',obj.ventricles,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,obj.ventricles);

    system(['$FSLDIR/bin/fslmaths ',obj.lobar,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,obj.lobar);

    system(['$FSLDIR/bin/fslmaths ',obj.arterial,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,obj.arterial);
    
    delete(tmpf);

    % Create our new thresholded maps ...
    system(['$FSLDIR/bin/fslmaths ',obj.gm_prob, ...
            ' -thr 0.8 ',strcat(obj.gm_prob_thr,'.gz')]);
    gunzip(strcat(obj.gm_prob_thr,'.gz'));
    delete(strcat(obj.gm_prob_thr,'.gz'));
    system(['$FSLDIR/bin/fslmaths ',obj.wm_prob, ...
            ' -thr 0.8 ',strcat(obj.wm_prob_thr,'.gz')]);
    gunzip(strcat(obj.wm_prob_thr,'.gz'));
    delete(strcat(obj.wm_prob_thr,'.gz'));
