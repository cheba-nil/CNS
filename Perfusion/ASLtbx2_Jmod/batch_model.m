% Model batch script for SPM5
% Based on Karl's original batch script

% This pretend (ish) batch file, assumes that you have already
% parsed your onset information, into a text file, specified in
% the subject definition stuff.  In this text file, there
% are three columns:
% Column 1: condition number
% Column 2: onset in TRs
% Column 2: duration in TRs
%
% The myv file also specifies condition names

% The model file will almost always need to be tuned directly
% This is a per-subject fixed effects analysis.

% Subject and session numbers


% load SPM defaults
global defaults;
spm_defaults;
defaults.mask.thresh=-inf;%8000;
% store path
pwd_orig = pwd;

% specify filter for filenames
Filter             =PAR.Filter
%Filter             = 'swPerf*.img';
for sb = 1:PAR.nsubs

    clear SPM
    % get, make, goto SPM results directory
    ana_dir_pref = fullfile(PAR.root,PAR.subjects{sb});
    ana_dir = fullfile(ana_dir_pref, PAR.ana_dir);

    %this would be the case for an analysis for each of the sessions
    %the better thing to do is ONE only analysis and then extract
    %conclusions by means of contrasts
    %for ses=1:nsesses
    %ana_dir = fullfile(PAR.root,[PAR.prefixes{sb} PAR.subjects{sb}],PAR.sesses{ses},PAR.ana_dir);
    %ana_dir_pref = fullfile(PAR.root,[PAR.prefixes{sb} PAR.subjects{sb}],PAR.sesses{ses});
    if ~(exist(ana_dir))
        mdcom=['!mkdir ' fullfile(ana_dir_pref,PAR.ana_dir)];
        eval(mdcom);
    end
    cd(ana_dir);
    !rm SPM.mat
    % file list
    P = [];
    PP = [];

    SPM.xBF.name='hrf';
    SPM.xBF.length=1/16*PAR.TRs(1,sb);
    SPM.xBF.order=0;
    SPM.xBF.T  =16;
    SPM.xBF.T0=1;
    SPM.xBF.UNITS='scans';
    SPM.xBF.Volterra=1;
    %%%%%%%%%%%%%%%%%%%%%%
    for ses=1:1
        for c=1:PAR.condnum
            SPM.Sess(ses).U(c).name={PAR.cond_names{c}};
            SPM.Sess(ses).U(c).ons= PAR.Onsets{c};
            SPM.Sess(ses).U(c).dur= PAR.Durations{c};
            SPM.Sess(ses).U(c).P(1).name='none';
        end
    end


    %load TR data info
    SPM.xY.RT = PAR.TRs(1,sb);
    % Specify part of the design
    %===========================================================================
    % global normalization: OPTIONS:'Scaling'|'None'
    %---------------------------------------------------------------------------
    SPM.xGX.iGXcalc       = 'None';

    % intrinsic autocorrelations: OPTIONS: 'none'|'AR(1) + w'
    %-----------------------------------------------------------------------
    %SPM.xVi.form       = 'AR(0.2)';
    SPM.xVi.form       = 'none';
    % condition per session stuff
    for sessno=1:1

        % low frequency confound: high-pass cutoff (secs) [Inf = no filtering]
        %---------------------------------------------------------------------------
        %SPM.xX.K(sessno).HParam    = 80;
        SPM.xX.K(sessno).HParam    = Inf;
        SPM.Sess(sessno).C.C=[];
        SPM.Sess(sessno).C.name={};

        % file selection

        for c=1:PAR.ncond
            file_dir_pref = PAR.condirs{sb,c};
            if isunix
                P = strvcat(P,spm_select('FPList',file_dir_pref,['^' Filter '\w*\.img$']));
                if isempty(P)||strcmp(P,'/'),
                    P = strvcat(P,spm_select('FPList',file_dir_pref,['^' Filter '\w*\.nii$']));
                end
            else
                P = strvcat(P,spm_select('FPList',file_dir_pref,['^' Filter '\w*\.(img|nii)$']));
            end
        end
        ana_dir_pref = fullfile(PAR.root,PAR.subjects{sb},PAR.condirs{sb,1});
        SPM.nscan=size(P,1);
        %     % design (user specified covariates)
        %     %------------------------------------------------------------------
        %     % realignment parameters to add to model
        %     % mp = 'yes' -> get them into. Otherwise... OUT!
        if strcmp(PAR.mp,'yes')
            movefil = spm_select('FPList', ana_dir_pref,   ['rp_' '*.txt']);
            moves = spm_load(movefil);

            SPM.Sess(sessno).C.C    = moves;     % [n x c double] covariates
            move_names={'m1' 'm2' 'm3' 'm4' 'm5' 'm6'};
            SPM.Sess(sessno).C.name = move_names; % [1 x c cell]   names

        end

    end %for each session
    %PP = strvcat(PP,P);

    % set files
    SPM.xY.P           = P;
    defaults.modality='FMRI';
    % Configure design matrix
    SPM = spm_fmri_spm_ui(SPM);
    SPM.xGX.gSF=ones(SPM.nscan,1);
    save SPM SPM;
    % Estimate parameters
    spm_unlink(fullfile('.', 'mask.img')); % avoid overwrite dialog
    SPM = spm_spm(SPM);

    % back to initial directory
    cd(pwd_orig);
end
