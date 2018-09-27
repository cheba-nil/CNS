% Toolbox for batch processing ASL perfusion based fMRI data.
% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
%
% Smoothing batch file for SPM2

% Get subject etc parameters
disp ('====================================================');
disp ('Temporal filtering for the realigned rASL images ...');
disp ('====================================================');

global PAR;

% org_pwd=pwd;
% dirnames,
% get the subdirectories in the main directory
parfor sb = 1:PAR.Nids % for each subject

    str   = sprintf('subject #%3d/%3d: %-5s',sb,PAR.Nids,PAR.ids{sb});
    fprintf('\r%-40s  %30s',str,' ')
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...Temporal filtering')  %-#

    % for c=1:PAR.ncond
        ASLmean = spm_select('FPList', PAR.ASLfolder{sb}, ['^mean' PAR.ASLprefs{sb} '\.nii$']);
        
        % creat brain mask with ASLmean img
        ASLtbx_createbrainmask(ASLmean);

        rASL = spm_select('EXTFPList', char(PAR.ASLfolder{sb}), ['^r' PAR.ASLprefs{sb} '\.nii$'], Inf);
        system (['mv ' PAR.ASLfolder{sb} '/brainmask.nii ' ...
                        PAR.ASLfolder{sb} '/ASLmean_brainmask.nii']);
        brainmask = spm_select('FPList', PAR.ASLfolder{sb}, ['^ASLmean_brainmask\.nii$']);


        ASLtbx_asltemporalfiltering (rASL, brainmask);
    % end
end