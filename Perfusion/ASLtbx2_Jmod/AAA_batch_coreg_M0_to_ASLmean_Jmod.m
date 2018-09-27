% M0-to-ASLmean coregistration

disp ('===================================================');
disp ('M0-to-ASLmean coregistration - it takes a while....');
disp ('===================================================');

global PAR;

global defaults;
defaults=spm_get_defaults;
%spm_defaults;
spm_coreg_flags = defaults.coreg;
resFlags = struct(...
        'interp', 1,...                       % trilinear interpolation
        'wrap', spm_coreg_flags.write.wrap,...           % wrapping info (ignore...)
        'mask', spm_coreg_flags.write.mask,...           % masking (see spm_reslice)
        'which',1,...                         % write reslice time series for later use, don't write the first 1
        'mean',0);                            % do write mean image
% dirnames,
% get the subdirectories in the main directory
parfor sb = 1:PAR.Nids % for each subject
    %take the dir where the mean image (reslice) is stored (only first condition)
    sprintf('\nNow coregister %s''s data\n',char(PAR.ids{sb}));
%     for c=1:PAR.ncond
        
        %take the structural directory

        % get mean in this directory
        %PG (ASL mean) - Tar(G)et image, NEVER CHANGED
        %PF (M0) - Source image, transformed to match PG
        %PO - (O)ther images, originally realigned to PF and transformed again to PF

        % TARGET
        % get (NOT skull stripped structural from) Structurals
        ASLmean = spm_select('FPList', PAR.ASLfolder{sb}, ...
            ['^mean' PAR.ASLprefs{sb} '\.nii$']);
%         PG=PG(1,:);
        ASLmean_vol = spm_vol(ASLmean);
    
        %SOURCE, M0 image here
        M0 = spm_select('FPList',PAR.M0folder{sb}, ['^' PAR.M0prefs{sb} '\.nii$']);
%         PF=PF(1,:);
        M0_vol = spm_vol(M0);

%         PO=spm_select('EXTFPList', char(PAR.M0dirs{sb,c}),  ['^r' PAR.M0filters{c} '.*nii'], 1:1000);
%         
% 
%         %PO = PF; --> this if there are no 'other' images
%         if isempty(PO)
%             PO=M0;
%         else
%             PO = strvcat(M0,PO);
%         end
%         PO = M0;
        %do coregistration
        %this method from spm_coreg_ui.m
        %get coregistration parameters
        x  = spm_coreg (ASLmean_vol, M0_vol, spm_coreg_flags.estimate);

        %get the transformation to be applied with parameters 'x'
%         M  = inv(spm_matrix(x));
        %transform the mean image
        %spm_get_space(deblank(PG),M);
        %in MM we put the transformations for the 'other' images
%         MM = zeros(4,4,size(M0,1));
        M0_space = spm_get_space (M0);
        spm_get_space (M0, inv (spm_matrix(x)) * M0_space);
%         for j=1:size(PO,1)
%             %get the transformation matrix for every image
%             MM(:,:,j) = spm_get_space(deblank(PO(j,:)));
%         end
%         for j=1:size(PO,1),
%             %write the transformation applied to every image
%             %filename: deblank(PO(j,:))
%             spm_get_space(deblank(PO(j,:)), M*MM(:,:,j));
%         end
%         P = strvcat(ASLmean,M0);

        spm_reslice_flt({ASLmean;M0}, resFlags);   % reslicing M0 to ASLmean, creating the rM0 image
%     end
end
