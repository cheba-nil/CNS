% batch file to do coregistration between mean BOLD and T1
% 


disp('Coregistration between structural images and the functional images for all subjects, it takes a while....');
global defaults;
spm_defaults;
flags = defaults.coreg;

% dirnames,
% get the subdirectories in the main directory
for sb = 1:length(PAR.subjects) % for each subject
    %take the dir where the mean image (reslice) is stored (only first condition)
    sprintf('\nNow coregister %s''s data\n',char(PAR.subjects{sb}))
    dir_fun = PAR.condirs{sb,1};
    %take the structural directory
    dir_anat = PAR.structdir{sb};
    % get mean in this directory
    %PG - Tar(G)et image, NEVER CHANGED
    %PF - Source image, transformed to match PG
    %PO - (O)ther images, originally realigned to PF and transformed again to PF

    % TARGET
    % get (NOT skull stripped structural from) Structurals
    %PG = spm_get('Files', dir_anat,[PAR.structprefs '*.nii']);
    PG=spm_select('FPList',PAR.structdir{sb},['^' PAR.structprefs '\w*.*\.nii$']);
    PG=PG(1,:);
    VG = spm_vol(PG);

    %SOURCE
    PF = spm_select('FPList', dir_fun, ...
        ['^mean' PAR.confilters{1} '\w*\.nii$']);
    %   PF = spm_get('files', dir_fun, ...
    % 		['r' PAR.confilters{1} '*img']);
    PF=PF(1,:);
    VF = spm_vol(PF);

  
    clear PO;
    PO=[];

    num=0;

    for c=1:PAR.ncond
        % get files in this directory
       % Ptmp=spm_get('files', PAR.condirs{sb,c}, ['r*img']);
        Ptmp=spm_select('EXTFPList', char(PAR.condirs{sb,c}), ['^r' PAR.confilters{c} '\w.*nii'], 1:1000);

        PO=strvcat(PO,Ptmp);
        
       Ptmp=spm_select('EXTFPList', char(PAR.M0dirs{sb,c}),  ['^r' PAR.M0filters{c} '\w.*nii'], 1:1000);
        
        
          PO=strvcat(PO,Ptmp);
    end

    
    %PO = PF; --> this if there are no 'other' images
    if isempty(PO) | PO=='/'
        PO=PF;
    else
        PO = strvcat(PF,PO);
    end

    %do coregistration
    %this method from spm_coreg_ui.m
    %get coregistration parameters
    x  = spm_coreg(VG, VF,flags.estimate);

    %get the transformation to be applied with parameters 'x'
    M  = inv(spm_matrix(x));
    %transform the mean image
    %spm_get_space(deblank(PG),M);
    %in MM we put the transformations for the 'other' images
    MM = zeros(4,4,size(PO,1));
    for j=1:size(PO,1),
        %get the transformation matrix for every image
        MM(:,:,j) = spm_get_space(deblank(PO(j,:)));
    end
    for j=1:size(PO,1),
        %write the transformation applied to every image
        %filename: deblank(PO(j,:))
        spm_get_space(deblank(PO(j,:)), M*MM(:,:,j));
    end
end
