% -------------------------
% ASLprocessing_main_ASLtbx
% -------------------------
%
%
% DESCRIPTION
% -----------
% Calculating CBF with Ze Wang's ASLtbx
%
%
% DATA PREPARATION & USAGE
% ------------------------
% ASLtype = 'pCASL' or 'PASL'
%
% studyFolder = The study folder containing raw NIfTI data. T1, M0 and
%               pCASL/PASL should exist in the study folder. All T1 images
%               should be renamed as ID_T1.nii, pCASL images are named as
%               ID_pCASL.nii, M0 named as ID_M0.nii, PASL named as
%               ID_PASL.nii. If M0 is the first volume of pCASL/PASL, two
%               folders (T1 and pCASL/PASL) should exist, and 
%               sepM0fromPASLasFirstVol should be set to 'Y'.
%
% parameters = 'OATS' or 'other'.
%
% M0roiMask = 'vent' or 'wm'. i.e. using ventricular CSF or WM
%
% varargin = If parameters = 'other', varargin{1} is a cell containing
%            a cell array {firstImgType; ...
%                          subtractionType; ...
%                          subtractionOrder; ...
%                          ASLtbx_flag; ...
%                          timeShift; ...
%                          ASLtype_code; ...
%                          labelEfficiency; ...
%                          magnituteType; ...
%                          labelTime; ...
%                          delayTime; ...
%                          sliceTime; ...
%                          TE; ...  <-- in millisec
%                          TR}      <-- in sec
%
% sepM0fromPASLasFirstVol = 'Y' or 'N'. Whether separate the first volume
%                           of ASL as M0
%
% procMode = 'wholeProc', 'postproc'
%
%
% ---=== ASLtbx_running_modes ===---
%
% Mode 1: Voxel-wise M0 calibration
%
%         calib_voxORfixVal = 'voxel'; calib_wmORcsf = 'WM' or 'CSF' 
%         (voxel M0 mode does not look at calib_voxORfixVal). M0 image
%         should be passed to function.
%
%
% Mode 2: fixed M0 (type 1) - pipeline calculates and specifies M0wm/M0csf
%         values
%
%         calib_voxORfixVal = 'fixVal1'; calib_wmORcsf = 'WM' or 'CSF' (this
%         will be depending on whether WM or CSF will be used to calculate
%         M0). This pipeline will calculate M0wm and M0csf, and pass to
%         ASLtbx according to calib_wmORcsf.
%
%
% Mode 3: fixed M0 (type 2) - ASLtbx calculate M0wm/M0csf from M0img 
%         and M0roi mask
%
%         calib_voxORfixVal = 'fixVal2'; calib_wmORcsf = 'WM' or 'CSF'
%         (this will be depending on whether WM or CSF will be used to
%         calculate M0). M0img and M0roi mask will be passed to ASLtbx. The
%         choice of M0roi mask depends on calib_wmORcsf
%
% 
%
%
% OTHER INFO
% ----------
% Remember to cite Ze Wang's publications.
% Ze Wang, Geoffrey K. Aguirre, Hengyi Rao, Jiongjiong Wang,
% Maria A. Fernandez-Seara, Anna R. Childress, and John A. Detre, Empirical
% optimization of ASL data analysis using an ASL data processing toolbox:
% ASLtbx, Magnetic Resonance Imaging, 2008, 26(2):261-9.
%
% ==========================================================================

function ASLprocessing_main_ASLtbx (ASLtype, ...
                                    studyFolder, ...
                                    spm12path, ...
                                    parameters, ...
                                    sepM0fromPASLasFirstVol, ...
                                    calib_voxORfixVal, ...
                                    calib_wmORcsf, ...
                                    procMode, ...
                                    varargin)
               
currFolder = fileparts (mfilename ('fullpath'));
CNS_path = fileparts (currFolder);



if strcmp (procMode, 'wholeProc')
    % If previously processed, reset.
    % If not, create originalImg and subjects, and move data.
    if exist ([studyFolder '/subjects'], 'dir') == 7 && ...
            exist ([studyFolder '/originalImg'], 'dir') == 7
        system (['rm -fr ' studyFolder '/subjects']);
        system (['mv ' studyFolder '/originalImg/* ' studyFolder]);
        system (['rm -fr ' studyFolder '/originalImg']);
    end

    system (['mkdir ' studyFolder '/originalImg ' ...
                        studyFolder '/subjects']);
    system (['mv ' studyFolder '/T1 ' ...
                    studyFolder '/*ASL ' ...
                    studyFolder '/originalImg']);

    if strcmp (sepM0fromPASLasFirstVol, 'N')
        system (['mv ' studyFolder '/M0 ' ...
                        studyFolder '/originalImg']);
    end

    % gunzip
    fprintf ('gunzipping, please wait ...');
    system (['gunzip ' studyFolder '/originalImg/*/*.nii.gz']);
    fprintf ('                 Doen.\n');
end



%% internal mode
% set ASLtbx_path
ASLtbx_path = [CNS_path '/Perfusion/ASLtbx2_Jmod'];


%% add path
addpath (spm12path, ASLtbx_path, [CNS_path '/Scripts']);


%% get ASL image list
switch ASLtype
    case 'pCASL'
        ASL_list = spm_select ('FPList', ...
                                [studyFolder '/originalImg/pCASL'], ...
                                '.*_pCASL\.nii');
    case 'PASL'
        ASL_list = spm_select ('FPList', ...
                                [studyFolder '/originalImg/PASL'], ...
                                '.*_PASL\.nii');
end


%% Resolve the arguments

switch calib_voxORfixVal
    case 'voxel'
        fixM0 = 0;
        M0wmcsf2estimateM0b = -1; % disabled if voxel M0
    case {'fixVal1', 'fixVal2'}
        fixM0 = 1;
        switch calib_wmORcsf
            case 'WM'
                M0wmcsf2estimateM0b = 0; % WM M0 to estimate M0b
            case 'CSF'
                M0wmcsf2estimateM0b = 1; % CSF M0 to estimate M0b
        end
end

switch parameters
    case 'OATS'
        
        subtractionType = 0; % simple subtraction
        subtractionOrder = 0; % tag - control
        

        ASLtbx_flags = [1 ... % will mask out the background voxel
                         1 ... % will output mean images (mean PERF, mean CBF, and mean BOLD)
                         1 ... % will calculate CBF
                         1 ... % will save pseudo BOLD
                         1 ... % will save the perfusion difference image series
                         1 ... % will save CBF image series
                         fixM0 ... % will use voxel-wise or fixed M0
                         1 ... % will output NIfTI format
                         1 ... % will output 4D img
                         M0wmcsf2estimateM0b];   % will use M0csf or M0wm to estimate M0b, or disable
             
        timeShift = 0.5; % time shift for interpolation. useless for simple subtraction
        magnituteType = 1; % 3T scanner
        
        switch ASLtype
            case 'pCASL'
                
                firstImgType = 0; % first image = control (1). Reversed to 0 due to negative values.
                ASLtype_code = 1; % CASL
                labelEfficiency = 0.85;
                labelTime = 1.8; % label for 1.8 seconds
                delayTime = 2.0; % post label delay for 2.0 seconds
                sliceTime = 35.3125; % (minTR - labelTime - delayTime) / #slices; in millisec
                TE = 12; % in millisec; of pCASL?
                TR = 4.365; % in sec
                
            case 'PASL'
                
                firstImgType = 1; % first image = tag (0). Reversed to 1 due to negative values.
                ASLtype_code = 0; % PASL
                labelEfficiency = 0.95;
                labelTime = 0.7; % TI1
                delayTime = 1.8; % TI1 = 0.7, TI2 = 1.8
                                 % https://groups.google.com/forum/#!topic/asltbx-discussion-board/4A3GyZEQsOE
                                 % The above reference delayTime should be TI2-TI1
                                 % https://groups.google.com/forum/#!topic/asltbx-discussion-board/sXZNVUzRr7A
                                 % However, this reference said it should be TI2
                sliceTime = 46.6666667; % (minTR - labelTime - delayTime) / #slices; in millisec
                TE = 11; % in millisec
                TR = 2.5; % in sec
                
        end

    case 'ASLtbx2_example'
        subtractionType = 0;
        subtractionOrder = 1;
        ASLtbx_flags = [1 1 1 0 0 1 0 1 1 0];
        timeShift = 0.5;
        magnituteType = 1;
        firstImgType = 0;
        ASLtype_code = 0;
        labelEfficiency = 0.9;
        labelTime = 0.7;
        delayTime = 1.9;
        sliceTime = 40;
        TE = 17;
        TR = 6.76; % Calculated. labelTime + delayTime + sliceTime * 104 (52 pairs) / 1000 (millisec to sec)

        
    case 'other'
        argsCellArr = varargin{1};
        
        firstImgType = argsCellArr{1};
        subtractionType = argsCellArr{2};
        subtractionOrder = argsCellArr{3};
        ASLtbx_flags = argsCellArr{4};

        % no matter what the input is,
        % set these two ASLtbx_flags automatically
        ASLtbx_flags(7) = fixM0;
        ASLtbx_flags(10) = M0wmcsf2estimateM0b;

        timeShift = argsCellArr{5};
        ASLtype_code = argsCellArr{6};
        labelEfficiency = argsCellArr{7};
        magnituteType = argsCellArr{8};
        labelTime = argsCellArr{9};
        delayTime = argsCellArr{10};
        sliceTime = argsCellArr{11};
        TE = argsCellArr{12};
        TR = argsCellArr{13};
end

%% display
fprintf ('\n');
fprintf ('firstImgType = %d\n', firstImgType);
fprintf ('subtractionType = %d\n', subtractionType);
fprintf ('subtractionOrder = %d\n', subtractionOrder);
fprintf ('ASLtbx_flags = %d %d %d %d %d %d %d %d %d %d\n', ASLtbx_flags(:));
fprintf ('timeShift = %.2f\n', timeShift);
fprintf ('ASLtype_code = %d\n', ASLtype_code);
fprintf ('labelEfficiency = %.2f\n', labelEfficiency);
fprintf ('magnituteType = %d\n', magnituteType);
fprintf ('labelTime = %.2f\n', labelTime);
fprintf ('delayTime = %.2f\n', delayTime);
fprintf ('sliceTime = %.5f\n', sliceTime);
fprintf ('TE = %d millisec\n', TE);
fprintf ('TR = %f sec\n', TR);
fprintf ('\n');


%% Get file/folder structure ready
[Nsubj, ~] = size (ASL_list);







% ================ %
% sorting out data %
% ================ %
parfor i = 1:Nsubj
    [path, filename, ext] = fileparts (ASL_list (i,:));
    filenameparts = strsplit (filename, '_');
    ID = filenameparts{1};

    IDlist_cerrArr{i} = ID;


    if strcmp (procMode, 'wholeProc')
        %% creating subjects/ID folder and copy orig img
        system (['mkdir ' studyFolder '/subjects/' ID]);
        system (['mkdir ' studyFolder '/subjects/' ID '/orig']);
        switch ASLtype
            case 'pCASL'
                system (['cp ' studyFolder '/originalImg/pCASL/' ID '_pCASL.nii ' ...
                                studyFolder '/subjects/' ID '/orig']);
                system (['cp ' studyFolder '/originalImg/T1/' ID '_T1.nii ' ...
                                studyFolder '/subjects/' ID '/orig']);
            case 'PASL'
                system (['cp ' studyFolder '/originalImg/PASL/' ID '_PASL.nii ' ...
                                studyFolder '/subjects/' ID '/orig']);
                system (['cp ' studyFolder '/originalImg/T1/' ID '_T1.nii ' ...
                                studyFolder '/subjects/' ID '/orig']);
        end
        
        %% separate first volume of ASL as M0
        % or copy existing M0
        if strcmp (sepM0fromPASLasFirstVol, 'Y')
            system ([currFolder '/ASLprocessing_ASLtbx/ASLprocessing_ASLtbx_separateM0fromASL.sh ' ...
                                                                                                  studyFolder '/subjects/' ID '/orig/' ID '_' ASLtype '.nii ' ...
                                                                                                  ASLtype]);
        elseif strcmp (sepM0fromPASLasFirstVol, 'N')
            system (['cp ' studyFolder '/originalImg/M0/' ID '_M0.nii ' ...
                            studyFolder '/subjects/' ID '/orig']);
        end
    end
end
   



%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      %%
%% ASLtbx Preprocessing %%
%%                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%


% set PAR
AAA_par_Jmod (spm12path, ...
               studyFolder, ...
               IDlist_cerrArr, ...
               ASLtype, ...
               TR, ...
               firstImgType, ...
               subtractionType, ...
               subtractionOrder, ...
               fixM0, ...
               M0wmcsf2estimateM0b, ...
               ASLtype_code, ...
               labelEfficiency, ...
               magnituteType, ...
               labelTime, ...
               delayTime, ...
               sliceTime, ...
               TE);



if strcmp (procMode, 'wholeProc')
    % reset ASL/M0/T1
    AAA_batch_reset_orientation_Jmod;

    % realign the ASL images to the first volume for each subject
    AAA_batch_realign_Jmod;

    % M0-to-ASLmean registration
    AAA_batch_coreg_M0_to_ASLmean_Jmod;

    % ASLmean-to-T1 registration, and bring rM0 and rASL to T1 space
    AAA_batch_coreg_ASLmean_to_T1_Jmod;

    % temporal filtering rASL
    AAA_batch_filtering_Jmod;

    % smothing rM0 and realigned and filtered rASL
    AAA_batch_smooth_Jmod;
end



% ========================================= %̄
% preparation and running asl_perf_subtract %
% ========================================= %̄
meanCBF_cellArr = cell (Nsubj, 1);
ID_cellArr = cell (Nsubj, 1);

parfor i = 1:Nsubj
    [path, filename, ext] = fileparts (ASL_list (i,:));
    filenameparts = strsplit (filename, '_');
    ID = filenameparts{1};

    ID_cellArr{i} = ID;


    if strcmp (procMode, 'wholeProc')

        system (['mkdir ' studyFolder '/subjects/' ID '/imgs4ASLtbx']);
        imgs4ASLtbx_folder = [studyFolder '/subjects/' ID '/imgs4ASLtbx'];
        system (['mkdir ' imgs4ASLtbx_folder '/intermediateOutput']);
        T1img = [studyFolder '/subjects/' ID '/orig/' ID '_T1.nii'];
        
        system (['cp ' studyFolder '/subjects/' ID '/orig/sr' ID '_M0.nii ' ...
                        imgs4ASLtbx_folder]);
        M0img = [imgs4ASLtbx_folder '/sr' ID '_M0.nii'];
        
        % ventricular mask of M0
        M0ventMask = CNSP_getLatVentricles (M0img, ...
                                            T1img, ...
                                            imgs4ASLtbx_folder, ...
                                            spm12path);

        system (['mv ' M0ventMask ' ' imgs4ASLtbx_folder '/sr' ID '_M0_ventMask.nii']);
        M0ventMask = [imgs4ASLtbx_folder '/sr' ID '_M0_ventMask.nii'];

        
        % cleanup intermediate output from CNSP_getLatVentricles
        system (['mkdir ' imgs4ASLtbx_folder '/temp_cleanup']);
        system (['mv ' imgs4ASLtbx_folder '/sr' ID '_M0.nii ' ...
                        imgs4ASLtbx_folder '/sr' ID '_M0_ventMask.nii ' ...
                        imgs4ASLtbx_folder '/temp_cleanup']);
        system (['rm -f ' imgs4ASLtbx_folder '/*.*']);
        system (['mv ' imgs4ASLtbx_folder '/temp_cleanup/* ' ...
                        imgs4ASLtbx_folder]);
    	system (['rm -fr ' imgs4ASLtbx_folder '/temp_cleanup']);
        
        % WM mask of M0
        CNSP_getWMmask (M0img, ...
                        T1img, ...
                        imgs4ASLtbx_folder, ...
                        spm12path);

        system (['. ${FSLDIR}/etc/fslconf/fsl.sh;fslmaths ' ...
                                                          imgs4ASLtbx_folder '/WMprobmask.nii.gz ' ...
                                                          '-thr 0.6 ' ...
                                                          '-bin ' ...
                                                          imgs4ASLtbx_folder '/WMmask']); % threshold WM prob mask

        system (['mv ' imgs4ASLtbx_folder '/WMmask.nii.gz ' imgs4ASLtbx_folder '/sr' ID '_M0_WMmask.nii.gz']);
        system (['mv ' imgs4ASLtbx_folder '/WMprobmask.nii.gz ' ...
                        imgs4ASLtbx_folder '/intermediateOutput']);
        system (['gunzip ' imgs4ASLtbx_folder '/sr' ID '_M0_WMmask.nii.gz']);
        M0wmMask = [imgs4ASLtbx_folder '/sr' ID '_M0_WMmask.nii'];
        system (['mv ' imgs4ASLtbx_folder '/WMmask_T1space.nii.gz ' ...
                        imgs4ASLtbx_folder '/temp_CNSPgetWMmask']);

        % ASL brain mask
        system ([currFolder '/ASLprocessing_ASLtbx/ASLprocessing_ASLtbx_getM0brainMask.sh ' ...
                                                                                            imgs4ASLtbx_folder '/temp_CNSPgetWMmask/c1' ID '_T1.nii ' ...
                                                                                            imgs4ASLtbx_folder '/temp_CNSPgetWMmask/c2' ID '_T1.nii ' ...
                                                                                            imgs4ASLtbx_folder '/temp_CNSPgetWMmask/c3' ID '_T1.nii ' ...
                                                                                            ID ' ' ...
                                                                                            studyFolder ' ' ...
                                                                                            imgs4ASLtbx_folder '/sr' ID '_M0.nii']);
        M0brainMask = [imgs4ASLtbx_folder '/sr' ID '_M0brainmask.nii'];
        % M0brainMask = [studyFolder '/subjects/' ID '/orig/ASLmean_brainmask.nii'];


        % calculate M0csfMean and M0wmMean
        system ([currFolder '/ASLprocessing_ASLtbx/ASLprocessing_ASLtbx_calculateM0MeanWithMask.sh ' ...
                                                                                                    imgs4ASLtbx_folder '/sr' ID '_M0.nii ' ...
                                                                                                    imgs4ASLtbx_folder '/sr' ID '_M0_WMmask.nii ' ...
                                                                                                    imgs4ASLtbx_folder '/sr' ID '_M0_ventMask.nii ' ...
                                                                                                    studyFolder ' ' ...
                                                                                                    ID]);
        fid = fopen ([imgs4ASLtbx_folder '/M0WMCSF.txt']);
        M0WMCSF = textscan (fid, '%f %f', ...
                            'Delimiter', ',', ...
                            'HeaderLines', 1);
        fclose (fid);

        M0wm = M0WMCSF{1};
        M0csf = M0WMCSF{2};



        %% Resolve ASLtbx running modes
        switch calib_voxORfixVal
            
        % voxel M0 calibration
        case 'voxel'
            M0csf = [];
            M0wm = [];
            M0roi = [];
            
        % fixed M0 calibration (Mode 1)
        % Pipeline calculates M0wm/M0csf values
        case 'fixVal1'
            switch calib_wmORcsf
                case 'WM'
                    M0csf = [];
                    M0img = [];
                    M0roi = [];
                case 'CSF'
                    M0wm = [];
                    M0img = [];
                    M0roi = [];
            end
            
        % fixed M0 calibration (Mode 2)
        % set M0img and M0roi for ASLtbx to calculate M0
        case 'fixVal2'
            switch calib_wmORcsf
                case 'WM'
                    M0roi = M0wmMask;
                    M0wm = [];
                    M0csf = [];
                case 'CSF'
                    M0roi = M0ventMask;
                    M0wm = [];
                    M0csf = [];
            end
        end
        
        sASLflt = [studyFolder '/subjects/' ID '/orig/sASLflt_r' filename '.nii'];
        system (['cp ' sASLflt ' ' ...
                       imgs4ASLtbx_folder]);
        sASLflt = [imgs4ASLtbx_folder '/sASLflt_r' filename '.nii'];
        
        %% running ASLtbx
        [~, meanCBF_cellArr{i}] = asl_perf_subtract (sASLflt, ...
                                                     firstImgType, ...
                                                     subtractionType, ...
                                                     subtractionOrder, ...
                                                     ASLtbx_flags, ...
                                                     0.5, ... % time shift, not used
                                                     ASLtype_code, ...
                                                     labelEfficiency, ...
                                                     magnituteType, ...
                                                     labelTime, ...
                                                     delayTime, ...
                                                     sliceTime, ...
                                                     TE, ...
                                                     M0img, ...
                                                     M0roi, ...
                                                     M0brainMask, ...
                                                     M0csf, ...
                                                     M0wm);
    end

    % move asl_perf_subtract output to subjects/ID/ASLtbx_output
    % system (['mkdir ' studyFolder '/subjects/' ID '/ASLtbx_output']);
    % system (['mv ' studyFolder '/originalImg/' ASLtype '/*_*' ID '_*.nii ' ...
    %                 studyFolder '/originalImg/' ASLtype '/globalsg*_' ID '*.txt ' ...
    %                 studyFolder '/subjects/' ID '/ASLtbx_output']);
    

    % asl_perf_subtract output: 
    % https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!topic/asltbx-discussion-board/g3MVmlMaups

end




% =============== %
% post-processing %
% =============== %
% 'wholeProc' and 'postproc' both need the following steps

% c123 to ASL space
AAA_batch_coreg_t12asl_Jmod;

% SCORE outlier removal
AAA_batch_SCORE_clean_Jmod;


% postprocessing
parfor i = 1:Nsubj
    [path, filename, ext] = fileparts (ASL_list (i,:));
    filenameparts = strsplit (filename, '_');
    ID = filenameparts{1};
    imgs4ASLtbx_folder = [studyFolder '/subjects/' ID '/imgs4ASLtbx'];

    % mask tissue, and further threshold
    system ([currFolder '/ASLprocessing_ASLtbx/ASLprocessing_ASLtbx_maskTissueAndOutlierRemovalAfterSCORE.sh ' ...
                                                                                                            ID ' ' ...
                                                                                                            imgs4ASLtbx_folder]);
    % mask GM/WM
    system ([currFolder '/ASLprocessing_ASLtbx/ASLprocessing_ASLtbx_maskGMWMafterSCORE.sh ' ...
                                                                                        ID ' ' ...
                                                                                        imgs4ASLtbx_folder]);

    % mask GM/WM
    system ([currFolder '/ASLprocessing_ASLtbx/ASLprocessing_ASLtbx_maskWithMNIatlas.sh ' ...
                                                                                        ID ' ' ...
                                                                                        imgs4ASLtbx_folder]);
end


    

% postprocessed ASLtbx results
ASLtbx2_postproc_results_cellArr = cell (Nsubj, 12);

% ASLtbx postprocessed results
for i = 1:Nsubj
    [path, filename, ext] = fileparts (ASL_list (i,:));
    filenameparts = strsplit (filename, '_');
    ID = filenameparts{1};
    imgs4ASLtbx_folder = [studyFolder '/subjects/' ID '/imgs4ASLtbx'];


    [~, tissSCOREcbf] = system (['ls ' imgs4ASLtbx_folder '/temp_maskTissueAndOutlierRemovalAfterSCORE/tiss_SCORE_cbf_* | tr -d ''\n'' | sed ''s/ //g''']);
    [~, tissSCOREcbf_GM] = system (['ls ' imgs4ASLtbx_folder '/temp_maskGMWMafterSCORE/tiss_SCORE_cbf_*_GM.* | tr -d ''\n'' | sed ''s/ //g''']);
    [~, tissSCOREcbf_WM] = system (['ls ' imgs4ASLtbx_folder '/temp_maskGMWMafterSCORE/tiss_SCORE_cbf_*_WM.* | tr -d ''\n'' | sed ''s/ //g''']);


    [~, ASLtbx2_postproc_results_cellArr{i, 1}] = system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
                                                           'fslstats ' tissSCOREcbf ' -M | tr -d ''\n'' | sed ''s/ //g''']);
    [~, ASLtbx2_postproc_results_cellArr{i, 2}] = system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
                                                           'fslstats ' tissSCOREcbf_GM ' -M | tr -d ''\n'' | sed ''s/ //g''']);
    [~, ASLtbx2_postproc_results_cellArr{i, 3}] = system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
                                                           'fslstats ' tissSCOREcbf_WM ' -M | tr -d ''\n'' | sed ''s/ //g''']);

    MNIatlasMasked_folder = [imgs4ASLtbx_folder '/temp_maskMNIatlas'];
    for j = 4:12
        [~, ASLtbx2_postproc_results_cellArr{i, j}] = system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
                                                               'fslstats ' MNIatlasMasked_folder '/tissSCOREcbf_atlas' num2str(j-3) ' -M | tr -d ''\n'' | sed ''s/ //g''']);
    end
end


% ================== %
% Write to text file %
% ================== %
if exist ([studyFolder '/subjects/ASLtbx2_output.txt'], 'file') == 2;
    system (['rm -f ' studyFolder '/subjects/ASLtbx2_output.txt']);
end

textOutput_filename = [studyFolder '/subjects/ASLtbx2_output.txt'];
textOutput_cellArr = [ID_cellArr meanCBF_cellArr ASLtbx2_postproc_results_cellArr];
textOutput_table = cell2table (textOutput_cellArr);

textOutput_table.Properties.VariableNames{'textOutput_cellArr1'} = 'ID';
textOutput_table.Properties.VariableNames{'textOutput_cellArr2'} = 'meanCBF_raw';
textOutput_table.Properties.VariableNames{'textOutput_cellArr3'} = 'meanCBF_tissOutlierRm';
textOutput_table.Properties.VariableNames{'textOutput_cellArr4'} = 'meanCBF_tissOutlierRm_GM';
textOutput_table.Properties.VariableNames{'textOutput_cellArr5'} = 'meanCBF_tissOutlierRm_WM';
textOutput_table.Properties.VariableNames{'textOutput_cellArr6'} = 'meanCBF_tissOutlierRm_caudate';
textOutput_table.Properties.VariableNames{'textOutput_cellArr7'} = 'meanCBF_tissOutlierRm_cerebellum';
textOutput_table.Properties.VariableNames{'textOutput_cellArr8'} = 'meanCBF_tissOutlierRm_frontal';
textOutput_table.Properties.VariableNames{'textOutput_cellArr9'} = 'meanCBF_tissOutlierRm_insula';
textOutput_table.Properties.VariableNames{'textOutput_cellArr10'} = 'meanCBF_tissOutlierRm_occipital';
textOutput_table.Properties.VariableNames{'textOutput_cellArr11'} = 'meanCBF_tissOutlierRm_parietal';
textOutput_table.Properties.VariableNames{'textOutput_cellArr12'} = 'meanCBF_tissOutlierRm_putamen';
textOutput_table.Properties.VariableNames{'textOutput_cellArr13'} = 'meanCBF_tissOutlierRm_temporal';
textOutput_table.Properties.VariableNames{'textOutput_cellArr14'} = 'meanCBF_tissOutlierRm_thalamus';

writetable (textOutput_table, textOutput_filename, ...
            'Delimiter', ',');