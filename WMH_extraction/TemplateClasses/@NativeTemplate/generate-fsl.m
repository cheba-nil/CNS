%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate.m
%
% This function will warp the indicated Dartel template into native space.
% It requires rc(1-3)(obj.subID)_T1.nii to have been created already 
% Furthermore WMHextraction_preprocessing_Step3 must have been called using 
% a Dartel space template.
% 
% Note: as mentioned in a comment below, preproc_Step3 must be called
%   for 'existing template' before this function can be successfully run
%
% The general workflow for the function is as follows:
%   1) Apply the flow_map generated from caling preproc_Step3 with 
%       'existing template' to each of the DARTEL templates.
%       This will yield unwarped templates in T1 space
%   2) Generate a transformation matrix from T1 to FLAIR space.
%       This is done by transforming the c1 segmentation into FLAIR space,
%       and then using FLIRT to generate a transformation matrix between
%       the original and output.  (Note: I'm not sure why I didn't just
%       call flirt between the two flair images used in the first transform ....)
%   3) Apply this transformation to each of the unwarped DARTEL templates.
%   4) Apply thresholding to the probablity maps to generate those maps ...
%
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

    % fix geometry issues
    orig_rc1 = strcat(obj.studyFolder,'/subjects/',obj.subID,...
                    '/mri/preprocessing/rc1',obj.subID,'_T1.nii');
    %system(['$FSLDIR/bin/fslcpgeom ',orig_rc1,' ',wbrain_mask]);

    % get c1 into flair dimensions
    flair = strcat(obj.studyFolder,'/subjects/',obj.subID,...
                    '/mri/orig/',obj.subID,'_FLAIR.nii'); ...
    reflair = strcat(obj.dir,'/reslice',obj.subID,'_FLAIR.nii');
    %reslice_nii(flair,reflair,[],[2])
    copyfile(flair,reflair);

    orig_rflair = strcat(obj.studyFolder,'/subjects/',obj.subID,...
                    '/mri/preprocessing/r',obj.subID,'_FLAIR.nii');
    rflair = strcat(obj.dir,'/r',obj.subID,'_FLAIR.nii');
    copyfile(orig_rflair,rflair);


    orig_c1 = strcat(obj.studyFolder,'/subjects/',obj.subID,...
                    '/mri/preprocessing/c1',obj.subID,'_T1.nii');
    c1 = strcat(obj.dir,'/c1',obj.subID,'_T1.nii');
    copyfile(orig_c1,c1);


    fc1 = strcat(obj.dir,'/fc1',obj.subID,'_T1.nii');
        
    CNSP_registration(rflair,reflair,obj.dir,c1);
    movefile(strcat(obj.dir,'/rc1',obj.subID,'_T1.nii'),fc1);

    % this must be done after the movefile on the previous line
    % or else spm will overwrite rc1
    orig_rc1 = strcat(obj.studyFolder,'/subjects/',obj.subID,...
                    '/mri/preprocessing/rc1',obj.subID,'_T1.nii');
    rc1 = strcat(obj.dir,'/rc1',obj.subID,'_T1.nii');
    copyfile(orig_rc1,rc1);
        
    trans = strcat(obj.dir,'/t1_to_flair.mat');

    % remove NaN's ...
    tmpfuz = strcat(obj.dir,'/tmp.nii');

    system(['$FSLDIR/bin/fslmaths ',rc1,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,rc1);

    system(['$FSLDIR/bin/fslmaths ',fc1,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,fc1);

    % generate a transformation matrix from t1 space to flair space
    system(['$FSLDIR/bin/flirt -in ',rc1,' -ref ',fc1,' -omat ',trans]);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % I really should have done a for loop here, but I digress ...
    %
    % In each of the following code blocks I:
    %   1) Remove NaN's (from unwarped template) because they're evil
    %       (the NaN's, not the templates)
    %   2) Apply the tranformation generated above to the template
    %       to get it into flair space
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % brain_mask
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    system(['$FSLDIR/bin/fslmaths ',wbrain_mask,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,wbrain_mask);
    system(['$FSLDIR/bin/flirt -in ',wbrain_mask,' -ref ',fc1,...
        ' -applyxfm -init ',trans,' -interp nearestneighbour -out ',obj.brain_mask]);
    gunzip(strcat(obj.brain_mask,'.gz'))
    delete(strcat(obj.brain_mask,'.gz'))
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % gm_prob
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    system(['$FSLDIR/bin/fslmaths ',wgm_prob,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,wgm_prob);
    system(['$FSLDIR/bin/flirt -in ',wgm_prob,' -ref ',fc1,...
        ' -applyxfm -init ',trans,' -out ',obj.gm_prob]);
    gunzip(strcat(obj.gm_prob,'.gz'))
    delete(strcat(obj.gm_prob,'.gz'))
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % wm_prob
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    system(['$FSLDIR/bin/fslmaths ',wwm_prob,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,wwm_prob);
    system(['$FSLDIR/bin/flirt -in ',wwm_prob,' -ref ',fc1,...
        ' -applyxfm -init ',trans,' -out ',obj.wm_prob]);
    gunzip(strcat(obj.wm_prob,'.gz'))
    delete(strcat(obj.wm_prob,'.gz'))
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % csf_prob
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    system(['$FSLDIR/bin/fslmaths ',wcsf_prob,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,wcsf_prob);
    system(['$FSLDIR/bin/flirt -in ',wcsf_prob,' -ref ',fc1,...
        ' -applyxfm -init ',trans,' -out ',obj.csf_prob]);
    gunzip(strcat(obj.csf_prob,'.gz'))
    delete(strcat(obj.csf_prob,'.gz'))
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ventricles
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    system(['$FSLDIR/bin/fslmaths ',wventricles,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,wventricles);
    system(['$FSLDIR/bin/flirt -in ',wventricles,' -ref ',fc1,...
        ' -applyxfm -init ',trans,' -out ',obj.ventricles]);
    gunzip(strcat(obj.ventricles,'.gz'))
    delete(strcat(obj.ventricles,'.gz'))
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % lobar
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    system(['$FSLDIR/bin/fslmaths ',wlobar,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,wlobar);
    system(['$FSLDIR/bin/flirt -in ',wlobar,' -ref ',fc1,...
        ' -applyxfm -init ',trans,' -interp nearestneighbour -out ',obj.lobar]);
    gunzip(strcat(obj.lobar,'.gz'))
    delete(strcat(obj.lobar,'.gz'))
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % arterial
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    system(['$FSLDIR/bin/fslmaths ',warterial,' -nan ',tmpf]);
    gunzip(tmpf);
    movefile(tmpfuz,warterial);
    system(['$FSLDIR/bin/flirt -in ',warterial,' -ref ',fc1,...
        ' -applyxfm -init ',trans,' -interp nearestneighbour -out ',obj.arterial]);
    gunzip(strcat(obj.arterial,'.gz'))
    delete(strcat(obj.arterial,'.gz'))
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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
