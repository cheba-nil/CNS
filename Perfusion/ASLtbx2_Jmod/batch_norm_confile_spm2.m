% Normalization batch file for SPM2

defs.write.vox= [1.5 1.5 1.5];
% defs.write.bb=[-90 -126 -72
%                 90    90  108];
% defs.write.bb=[-78  -112   -60
%             78    76    100];

defs.write.bb=[-84  -110   -60
    84    80  85];
% Template image; here NOT skull stripped template image ???
temp_imgs = fullfile(spm('Dir'),'templates', 'T1.nii');
% temp_imgs = '/jet/zwang/testretest/template_int.img';
clear imgs;
for sb = 1:length(PAR.subjects) % for each subject
    %subj_dir = fullfile(PAR.root, PAR.subjects{s},PAR.structdir)

    % Get (NOT skull stripped) structural for this sbuject
    P = spm_select('FPList',PAR.structdir{sb},['^' PAR.structprefs '\w*\.img$']);
    P = P(1,:);

    % Make the default normalization parameters file name
    matname = [spm_str_manip(P,'sd') '_sn.mat'];

    % Set the mask for subject to empty by default
    objmask = ''; % object mask
    
    if exist(matname)==0
        spm_normalise(temp_imgs, P, matname,...
            defs.estimate.weight, objmask, ...
            defs.estimate);
    end
    [PATHSTR,NAME,EXT,VERSN] = fileparts(deblank(P));
    norname=spm_get('files',PATHSTR,'w*.img');
    conf_dir=fullfile(PAR.root,PAR.groupdir,PAR.con_names{i});
    PP=spm_select('FPList',conf_dir,['^con_' PAR.subjects{sb} '_' num2str(sb) '\w*\.img$']);
    spm_write_sn(PP,matname,defs.write,'');
end
% norm_dir=fullfile(PAR.root,PAR.fMRI,PAR.groupdir,PAR.con_names{1},PAR.spm2normdir);
% eval(['!mkdir ' norm_dir]);
% eval(['!mv ' conf_dir '/w*  ' norm_dir '/.']);
% clear sb