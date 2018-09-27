% Contrast Batch script for SPM2

% load subject etc details

clear
par;
disp('Close to the end....');
% Load SPM defaults
global defaults;
spm_defaults;
defaults.mask.thresh=-1000;
% Subject and session numbers
nsubjects = length(PAR.subjects);
% nsesses = length(PAR.sesses);
% ntot = nsubjects * nsesses;

% Conditions
nconds = length(PAR.cond_names);

% store path
pwd_orig = pwd;
%allcon=[-1*ones(nconds-1,1) eye(nconds-1)];


allcon=[-1  1  0];
ncons=size(allcon,1);
con_names=PAR.con_names;%PAR.cond_names;
for sub=1:nsubjects


    % get, goto SPM results directory
    ana_dir = fullfile(PAR.root,PAR.subjects{sub},PAR.ana_dir);
    cd(ana_dir);

    % load SPM model; give "SPM" structure
    disp('Loading SPM.mat');
    load('SPM.mat');
    disp('Done');

    % Where we will start filling in the contrasts
    %this length gives how many cons we already have
    xcon_1 = length(SPM.xCon)+1;
    for cn = 1:ncons
        if cn==1&& (isempty(SPM.xCon))                 % setting for spm5
            SPM.xCon=spm_FcUtil('Set',...
                con_names{cn},...
                'T',...
                'c',...
                allcon(cn,:)', ...
                SPM.xX.xKXs);
        else
            SPM.xCon(end + 1)= spm_FcUtil('Set',...
                con_names{cn},...
                'T',...
                'c',...
                allcon(cn,:)', ...
                SPM.xX.xKXs);
        end
    end

    % Estimate only the contrasts we've added
    spm_contrasts(SPM, xcon_1:xcon_1+ncons-1);


end
% back to initial directory
cd(pwd_orig);
