% Toolbox for batch processing ASL perfusion based fMRI data.
% All rights reserved.
% Ze Wang @ TRC, CFN, Upenn 2004
%
%
% Smoothing batch file for SPM2

% Get subject etc parameters
disp('Smoothing the normalised functional images, it is quick....');
org_pwd=pwd;
% dirnames,
% get the subdirectories in the main directory
P=[];
norm_dir=fullfile(PAR.root,PAR.groupdir,PAR.con_names{1});
files=spm_select('FPList',norm_dir,'^wcon\w*\.img$');
P=strvcat(P,files);

for im=1:size(P,1)
    Pim=P(im,:);
    [pth,name,ext]=fileparts(Pim);
    Qim=fullfile(pth,['s' spm_str_manip(Pim,'dt')]);
    spm_smooth(Pim,Qim,[5 5 5]);
end
cd(org_pwd);