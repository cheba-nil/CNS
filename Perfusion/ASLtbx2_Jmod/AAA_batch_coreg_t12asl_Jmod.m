% batch file to do coregistration between mean BOLD and T1
% 


% disp('Coregistration between structural images and the functional images for all subjects, it takes a while....');
% par;

global PAR;

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
parfor s = 1:PAR.Nids % for each subject

    fprintf('\nNow coregister %s''s data\n',char(PAR.ids{s}));


    %take the dir where the mean image (reslice) is stored (only first condition)
    % PAR.ASLfolder{s} = PAR.condirs{s,1};


    %take the structural directory
    % PAR.T1folder{s} = PAR.structdir{s};

    % T1
    T1 = spm_select ('FPList', PAR.T1folder{s}, ['^' PAR.T1prefs{s} '.*\.nii$']);
    % if isempty(T1)
    %     fprintf('No T1 exist for %s!\n',PAR.structdir{s});
    %     continue;
    % end



    % backup T1
    % T1backup = fullfile (spm_str_manip(T1(1,:),'h'), ['bk_' spm_str_manip(T1(1,:),'t')]); % bk for backup
    T1backup = [PAR.T1folder{s} '/bk_' PAR.T1prefs{s} '.nii'];
    % make a copy of T1
    system (['cp '  T1 ' ' T1backup]);% make a copy of the T1
    

    % source
    T1 = T1backup;
    T1_vol = spm_vol(T1);



    % other
    % copy c1 c2 and c3
    c1 = spm_select('FPList', [PAR.imgs4ASLtbxFolder{s} '/temp_CNSPgetWMmask'], ['^c1.*\.nii$']);
    c2 = spm_select('FPList', [PAR.imgs4ASLtbxFolder{s} '/temp_CNSPgetWMmask'], ['^c2.*\.nii$']);
    c3 = spm_select('FPList', [PAR.imgs4ASLtbxFolder{s} '/temp_CNSPgetWMmask'], ['^c3.*\.nii$']);
    
    % make a copy of the segmented maps since we will do registration of T1 to mean ASL image for each of the 2 PASL and each of the pCASL sequence separately.
    % if size(c123,1)~=3, 
    %    fprintf('Only %d segmented maps were found ', size(c123,1));
    %    continue;
    % end
    % for i=1:size(c123,1)
        c1_backup = fullfile(spm_str_manip(c1,'h'), ['bk_' spm_str_manip(c1,'t')]);
        c2_backup = fullfile(spm_str_manip(c2,'h'), ['bk_' spm_str_manip(c2,'t')]);
        c3_backup = fullfile(spm_str_manip(c3,'h'), ['bk_' spm_str_manip(c3,'t')]);
        system (['cp ' c1 ' ' c1_backup]);
        system (['cp ' c2 ' ' c2_backup]);
        system (['cp ' c3 ' ' c3_backup]);
    % end

    c123=spm_select('FPList', [PAR.imgs4ASLtbxFolder{s} '/temp_CNSPgetWMmask'], ['^bk_c.*\.nii$']);
    
    
    % target
    meanASL = spm_select('FPList', PAR.ASLfolder{s}, ['^mean' PAR.ASLprefs{s} '\.nii$']);
    meanASL_vol = spm_vol (meanASL);

        
    %   ana_dir = fullfile(PAR.root,PAR.subjects{s},PAR.ana_dir);
    %   confile=spm_select('FPList',ana_dir,['^con_00\w*\.img$']);
    %   c123=strvcat(c123,confile);
    %c123 = T1; --> this if there are no 'other' images
    % if isempty(c123) | c123=='/'
    %     c123=T1;
    % else
    %     c123 = strvcat(T1,c123);
    % end

    %do coregistration
    %this method from spm_coreg_ui.m
    %get coregistration parameters
    x  = spm_coreg (meanASL_vol, T1_vol,flags.estimate);

    %get the transformation to be applied with parameters 'x'
    M  = inv(spm_matrix(x));
    %transform the mean image
    %spm_get_space(deblank(meanASL),M);
    %in MM we put the transformations for the 'other' images
    MM = zeros(4,4,size(c123,1));
    for j=1:size(c123,1),
        %get the transformation matrix for every image
        MM(:,:,j) = spm_get_space(deblank(c123(j,:)));
    end
    for j=1:size(c123,1),
        %write the transformation applied to every image
        %filename: deblank(c123(j,:))
        spm_get_space(deblank(c123(j,:)), M*MM(:,:,j));
    end
    P=strvcat(meanASL,c123);
    spm_reslice_flt(P,resFlags);
    % eval(['delete '  PAR.T1folder{s} '/bk_*.nii']);
    system (['mv ' PAR.imgs4ASLtbxFolder{s} '/temp_CNSPgetWMmask/rbk_c*.nii ' ...
                    PAR.imgs4ASLtbxFolder{s}]);
    system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
             'fslmaths ' PAR.imgs4ASLtbxFolder{s} '/rbk_c1' PAR.ids{s} '_T1 -nan ' PAR.imgs4ASLtbxFolder{s} '/rbk_c1' PAR.ids{s} '_T1;' ...
             'fslmaths ' PAR.imgs4ASLtbxFolder{s} '/rbk_c2' PAR.ids{s} '_T1 -nan ' PAR.imgs4ASLtbxFolder{s} '/rbk_c2' PAR.ids{s} '_T1;' ...
             'fslmaths ' PAR.imgs4ASLtbxFolder{s} '/rbk_c3' PAR.ids{s} '_T1 -nan ' PAR.imgs4ASLtbxFolder{s} '/rbk_c3' PAR.ids{s} '_T1;' ...
             'rm -f ' PAR.imgs4ASLtbxFolder{s} '/rbk_c1' PAR.ids{s} '_T1.nii;' ...
             'rm -f ' PAR.imgs4ASLtbxFolder{s} '/rbk_c2' PAR.ids{s} '_T1.nii;' ...
             'rm -f ' PAR.imgs4ASLtbxFolder{s} '/rbk_c3' PAR.ids{s} '_T1.nii;' ...
             'gunzip ' PAR.imgs4ASLtbxFolder{s} '/rbk_c1' PAR.ids{s} '_T1.nii.gz;' ...
             'gunzip ' PAR.imgs4ASLtbxFolder{s} '/rbk_c2' PAR.ids{s} '_T1.nii.gz;' ...
             'gunzip ' PAR.imgs4ASLtbxFolder{s} '/rbk_c3' PAR.ids{s} '_T1.nii.gz;']);
end
  
