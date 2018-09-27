% ASLmean-to-T1 registration, and bring rM0 and rASL to T1 space

disp ('=======================================================================================');
disp ('ASLmean-to-T1 coregistration, and bring rM0 and rASL to T1 space - it takes a while....');
disp ('=======================================================================================');

global PAR;

global defaults;
defaults=spm_get_defaults;
spm_coreg_flags = defaults.coreg;

% dirnames,
% get the subdirectories in the main directory
parfor sb = 1:PAR.Nids % for each subject
    %take the dir where the mean image (reslice) is stored (only first condition)
    sprintf('\nNow coregister %s''s data (%s / %s)\n',char(PAR.ids{sb}), char(sb), char(PAR.ids));
%     dir_fun = PAR.condirs{sb,1};
    %take the structural directory
%     dir_anat = PAR.structdir{sb};
    % get mean in this directory
    %PG - Tar(G)et image, NEVER CHANGED
    %PF - Source image, transformed to match PG
    %PO - (O)ther images, originally realigned to PF and transformed again to PF

    % TARGET
    % get (NOT skull stripped structural from) Structurals
    %PG = spm_get('Files', dir_anat,[PAR.structprefs '*.nii']);
    
    % =========== %
    % TARGET - T1 %
    % =========== %
    T1_img = spm_select('FPList',PAR.T1folder{sb}, ['^' PAR.T1prefs{sb} '\.nii$']);
%     PG=PG(1,:);
    T1_img_vol = spm_vol(T1_img);
    
    
    
    % ================ %
    % SOURCE - ASLmean %
    % ================ %
    ASLmean_img = spm_select('FPList', PAR.ASLfolder{sb}, ['^mean' PAR.ASLprefs{sb} '\.nii$']);
    %   PF = spm_get('files', dir_fun, ...
    % 		['r' PAR.confilters{1} '*img']);
%     ASLmean_img=ASLmean_img(1,:);
    ASLmean_img_vol = spm_vol(ASLmean_img);

  
%     clear PO;
%     PO=[];

%     num=0;

%     for c=1:PAR.ncond
        % get files in this directory
       % Ptmp=spm_get('files', PAR.condirs{sb,c}, ['r*img']);
%         Ptmp=spm_select('EXTFPList', char(PAR.condirs{sb,c}), ['^r' PAR.confilters{c} '\w.*nii'], 1:1000);
% 
%         PO=strvcat(PO,Ptmp);
%         
%        Ptmp=spm_select('EXTFPList', char(PAR.M0dirs{sb,c}),  ['^r' PAR.M0filters{c} '\w.*nii'], 1:1000);
%         
%         
%           PO=strvcat(PO,Ptmp);
%     end

    % ==================== %
    % OTHER - rM0 and rASL %
    % ==================== %
    rM0_img = spm_select ('EXTFPList', char (PAR.M0folder{sb}), ['^r' PAR.M0prefs{sb} '\.nii$'], Inf);
    rASL_img = spm_select ('EXTFPList', char (PAR.ASLfolder{sb}), ['^r' PAR.ASLprefs{sb} '\.nii$'], Inf);
    
    %PO = PF; --> this if there are no 'other' images
%     if isempty(PO) | PO=='/'
%         PO=ASLmean_img;
%     else
%         PO = strvcat(ASLmean_img,PO);
%     end

    % imgList = [ASLmean_img; rM0_img; rASL_img];

    %do coregistration
    %this method from spm_coreg_ui.m
    %get coregistration parameters
    x  = spm_coreg(T1_img_vol, ASLmean_img_vol, spm_coreg_flags.estimate);
    

    rM0_space = spm_get_space (rM0_img);

    spm_get_space (rM0_img, inv (spm_matrix(x)) * rM0_space);
    
    for i = 1:size(rASL_img,1)    
        rASL_space = spm_get_space (rASL_img(i,:));
        spm_get_space (rASL_img(i,:), inv (spm_matrix(x)) * rASL_space);
    end

    %get the transformation to be applied with parameters 'x'
%     M  = inv(spm_matrix(x));
%     %transform the mean image
%     %spm_get_space(deblank(PG),M);
%     %in MM we put the transformations for the 'other' images
%     MM = zeros(4,4,size(imgList,1));
%     for j=1:size(imgList,1),
%         %get the transformation matrix for every image
%         MM(:,:,j) = spm_get_space(deblank(imgList(j,:)));
%     end
%     for j=1:size(imgList,1),
%         %write the transformation applied to every image
%         %filename: deblank(PO(j,:))
%         spm_get_space(deblank(imgList(j,:)), M*MM(:,:,j));
%     end
end
