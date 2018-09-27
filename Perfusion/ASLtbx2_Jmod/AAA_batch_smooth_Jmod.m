% Toolbox for batch processing ASL perfusion based fMRI data.
% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
%
% Smoothing batch file for SPM2

% Get subject etc parameters
disp ('===========================================');
disp ('Smoothing rM0 and realigned rASL images ...');
disp ('===========================================');

global PAR;

% org_pwd=pwd;
% dirnames,
% get the subdirectories in the main directory
parfor sb = 1:PAR.Nids % for each subject

    str   = sprintf('sub #%3d/%3d: %-5s',sb,PAR.Nids,PAR.ids{sb});
    fprintf('\r%-40s  %30s',str,' ')
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...smoothing')  %-#

    % for c=1:PAR.ncond
        %P=[];
        %dir_func = fullfile(PAR.root, PAR.subjects{s},PAR.sesses{ses},PAR.condirs{c});
        
              
        rM0img = spm_select('FPList', char(PAR.M0folder{sb}), ['^r' PAR.M0prefs{sb} '\.nii$']);

        % smoothing M0
        ASLtbx_smoothing(rM0img, PAR.FWHM);


        fltimgs = spm_select('FPList', PAR.ASLfolder{sb}, ['^ASLflt_r' PAR.ASLprefs{sb} '\.nii$']); % output from temporal filtering
        

        % if isempty(fltimgs), fprintf('You didn''t selecte any images!\n'); return;end;
        if size(fltimgs,1)==1
            [pth,nam,ext,num] = spm_fileparts(fltimgs);
            fltimgs=fullfile(pth, [nam ext]);
        end
        [pth,nam,ext,num] = spm_fileparts(fltimgs(1,:));


         ASLtbx_smoothing(fltimgs, PAR.FWHM);
        
       
    % end
% 
end
% cd(org_pwd);
