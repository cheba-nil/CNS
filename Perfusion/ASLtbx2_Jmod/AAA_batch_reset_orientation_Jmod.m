% batch reset ASL/M0/T1 orientation

global PAR;
% par

fprintf('\r%s\n',repmat(sprintf('-'),1,30))
fprintf('\r%s\n','Reseting ASL/M0/T1 orientation ...')


%%%%% the following codes are changed from batch_smooth

% dirnames,
% get the subdirectories in the main directory
parfor sb = 1:PAR.Nids % for each subject
    %go get the sessions
    str   = sprintf('subject#%3d/%3d: %-5s', sb, PAR.Nids, PAR.ids{sb});
    fprintf('\r%-40s  %30s',str,' ')
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...reseting')  %-#
    %now get all images to reset orientation
    %prepare directory

    % for c=1:PAR.ncond
        % get files in this directory

        % ASL
        ASL = spm_select('FPList', char(PAR.ASLfolder{sb}), ['^' PAR.ASLprefs{sb} '\.nii$']);
        % if isempty(P)
        %     disp('!!!!!!!!\n NO epi file\n!!!!!!!!!!')
        %     continue;
        % end;
        ASLtbx_resetimgorgASL(ASL);
        

        % M0
        M0 = spm_select('FPList', char(PAR.M0folder{sb}), ['^' PAR.M0prefs{sb} '\.nii$']);
        % if isempty(Ptmp)
        %     disp('!!!!!!!!\n NO M0 image selected\n!!!!!!!!!!')
        %     continue;
        % end;
        ASLtbx_resetimgorgASL (M0);      
        % fprintf('======= Reset image orientations =========================');
       
        
        
    % end

    T1 = spm_select('FPList', char(PAR.T1folder{sb}), ['^' PAR.T1prefs{sb} '\.nii$']);

    % if isempty(P)
    %     disp('!!!!!\n NO struct file\n!!!!!!!!!!!!!!!')
    %     continue;
    % end;
    ASLtbx_resetimgorg(T1);
   

    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...done')  %-#
end

fprintf ('\n');
