% Toolbox for batch processing ASL perfusion based fMRI data.
% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
%
% Smoothing batch file for SPM2

% Get subject etc parameters
disp('Smoothing the realigned functional images, it is quick....');
org_pwd=pwd;
% dirnames,
% get the subdirectories in the main directory
for sb = 1:PAR.nsubs % for each subject

    str   = sprintf('sub #%3d/%3d: %-5s',sb,PAR.nsubs,PAR.subjects{sb});
    fprintf('\r%-40s  %30s',str,' ')
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...smoothing')  %-#

    for c=1:PAR.ncond
        meanimg=spm_select('FPList', PAR.condirs{sb,c}, ['^mean' PAR.confilters{1} '\w*\.nii$']);
        ASLtbx_createbrainmask(meanimg);
        rimgs=spm_select('EXTFPList', char(PAR.condirs{sb,c}), ['^r' PAR.confilters{c} '.*nii'], 1:1000);
        maskimg=spm_select('FPList', PAR.condirs{sb,c}, ['^brainmask\.nii']);
        ASLtbx_asltemporalfiltering(rimgs, maskimg);
    end
end