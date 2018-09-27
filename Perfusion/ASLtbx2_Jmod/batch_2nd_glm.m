% 2nd level GLM
% 2nd level GLM
% RFX analysis

% load subject etc details
global defaults;
spm_defaults;

disp('Congratuations! Ready to perform group analysis!');
%2nd level-analisis dir
org_dir=pwd;
% group_dir = PAR.groupdir;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usegment
conf_dir=fullfile(PAR.root,PAR.groupdir,PAR.con_names{1});
group_dir = fullfile(PAR.root,char(PAR.groupdir),PAR.con_names{1},'RFX');
if ~exist(group_dir)
    %mkdir(group_dir);
    mdir=['!mkdir ' group_dir];
    eval(mdir);
end
cd(group_dir);
spm_unlink(fullfile('.', 'SPM.mat'));

P=spm_select('FPList',conf_dir,'^swcon\w*\.img$');
nscan=size(P,1);
i1=1:nscan;
i1=i1';
I=[i1 ones(nscan,1) ones(nscan,1) ones(nscan,1)];
defaults.modality='FMRI';
spm_glm_2nd(P,I);
load SPM.mat
% Estimate parameters
spm_unlink(fullfile('.', 'mask.img')); % avoid overwrite dialog

SPM = spm_spm(SPM);

load('SPM.mat');
% now put T contrast per row into SPM structure
if (isempty(SPM.xCon))                 % setting for spm5
    xcon_1 = 1;
    SPM.xCon=spm_FcUtil('Set',...
        'rfx',...
        'T',...
        'c',...
        1, ...
        SPM.xX.xKXs);
else
    xcon_1 = length(SPM.xCon)+1;
    SPM.xCon(end + 1)= spm_FcUtil('Set',...
        'rfx',...
        'T',...
        'c',...
        1, ...
        SPM.xX.xKXs);

end
spm_contrasts(SPM, xcon_1:xcon_1);
