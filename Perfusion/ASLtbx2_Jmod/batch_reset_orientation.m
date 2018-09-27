% batch reset T1 orientation

global PAR
par

fprintf('\r%s\n',repmat(sprintf('-'),1,30))
fprintf('\r%s\n','batch reset orientation ')


%%%%% the following codes are changed from batch_smooth

% dirnames,
% get the subdirectories in the main directory
for sb = 1:PAR.nsubs % for each subject
    %go get the sessions
    str   = sprintf('sub #%3d/%3d: %-5s',sb,PAR.nsubs,PAR.subjects{sb} );
    fprintf('\r%-40s  %30s',str,' ')
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...reseting')  %-#
    %now get all images to reset orientation
    %prepare directory

    for c=1:PAR.ncond
        % get files in this directory
        P=spm_select('FPList', char(PAR.condirs{sb,c}), ['^' PAR.confilters{c} '.*\.nii$']);
        if isempty(P)
            disp('!!!!!!!!\n NO epi file\n!!!!!!!!!!')
            continue;
        end;
        ASLtbx_resetimgorgASL(P);
        
        Ptmp=spm_select('FPList', char(PAR.M0dirs{sb,c}), ['^' PAR.M0filters{c} '.*\.nii$']);
        if isempty(Ptmp)
            disp('!!!!!!!!\n NO M0 image selected\n!!!!!!!!!!')
            continue;
        end;
        ASLtbx_resetimgorgASL(Ptmp);      
        fprintf('======= Reset image orientations =========================');
       
        
        
    end

    P=[];
    P=spm_select('FPList', char(PAR.structdir{sb}), ['^' PAR.structprefs '.*.nii$']);

    if isempty(P)
        disp('!!!!!\n NO struct file\n!!!!!!!!!!!!!!!')
        continue;
    end;
    ASLtbx_resetimgorg(P);
   

    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...done')  %-#
end
