% batch file to do coregistration between mean BOLD and T1
% 


disp('Coregistration between structural images and the functional images for all subjects, it takes a while....');
par;
defaults=spm_get_defaults;
%spm_defaults;
flags = defaults.coreg;
resFlags = struct(...
        'interp', 1,...                       % trilinear interpolation
        'wrap', flags.write.wrap,...           % wrapping info (ignore...)
        'mask', flags.write.mask,...           % masking (see spm_reslice)
        'which',1,...                         % write reslice time series for later use, don't write the first 1
        'mean',0);                            % do write mean image

% dirnames,
% get the subdirectories in the main directory
for s = 1:length(PAR.subjects) % for each subject
    %take the dir where the mean image (reslice) is stored (only first condition)
    sprintf('\nNow coregister %s''s data\n',char(PAR.subjects{s}))
    dir_fun = PAR.condirs{s,1};
    %take the structural directory
    dir_anat = PAR.structdir{s};
    PF=spm_select('FPList', dir_anat, ['^' PAR.structprefs '.*\.nii$']);
    if isempty(PF)
        fprintf('No T1 exist for %s!\n',PAR.structdir{s});
        continue;
    end
    PF1=fullfile(spm_str_manip(PF(1,:),'h'), ['bk_' spm_str_manip(PF(1,:),'t')]);
    % make a copy of T1
    cpstr=['copyfile '  PF ' ' PF1  ];
    eval(cpstr);    % make a copy of the T1
    % source
    PF=PF1;
    VF = spm_vol(PF);
    % copy c1 c2 and c3
    PO=spm_select('FPList', dir_anat, ['^c.*\.nii$']);
    % make a copy of the segmented maps since we will do registration of T1 to mean ASL image for each of the 2 PASL and each of the pCASL sequence separately.
    if size(PO,1)~=2, 
       fprintf('Only %d segmented maps were found for %s ', size(PO,1),PAR.strudirses{sb,nses});
       continue;
    end
    for i=1:size(PO,1)
         cpstr=['copyfile ' PO(i,:) ' ' fullfile(spm_str_manip(PO(i,:),'h'), ['bk_' spm_str_manip(PO(i,:),'t')]) ];
         eval(cpstr);
    end
    PO=spm_select('FPList', dir_anat, ['^bk_c.*\.nii$']);
    
    
    % target
    PG=spm_select('FPList', dir_fun, ['^mean' PAR.confilters{1} '\w*\.nii$']);
    PG=PG(1,:);
    VG = spm_vol(PG);

        
    %   ana_dir = fullfile(PAR.root,PAR.subjects{s},PAR.ana_dir);
    %   confile=spm_select('FPList',ana_dir,['^con_00\w*\.img$']);
    %   PO=strvcat(PO,confile);
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
    P=strvcat(PG,PO);
    spm_reslice_flt(P,resFlags);
    eval(['delete '  dir_anat '/bk_*.nii']);
    
end
  
