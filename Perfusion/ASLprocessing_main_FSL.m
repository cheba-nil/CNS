% ============================
% Pipeline to process ASL data
% ============================
%
% -----------
% DESCRIPTION
% -----------
% Processing ASL data (pCASL and PASL) using oxford_asl.
%
% ----------------
% DATA PREPARATION
% ----------------
% In the study folder, the following folders and data
% should exist:
%
% For pCASL:
%          - M0 folder (ID_M0.nii.gz)
%          - pCASL folder (ID_pCASL.nii.gz)
%          - T1 folder (ID_T1.nii.gz)
%
% For PASL:
%          - PASLwM0 folder - PASL with M0 as the first volume (ID_PASLwM0.nii.gz)
%          - T1 folder (ID_T1.nii.gz)
%
% -----
% USAGE
% -----
% ASLtype = 'pCASL'; % or 'PASLwM0'
% studyFolder = '/data_pub/jiyang/O_Syd_W4_pCASL_fromForrest';
% spm12path = '/usr/share/spm12';
% parameters = 'OATS' or a cell array with parameters for (TI bolus bat slicedt TR TE acq_order)
%
% if parameters = 'OATS'
%   TI = 3.8 (pCASL) or 1.8 (PASL)
%   bolus = 1.8 (pCASL) or 0.7 (PASL)
%   bolus arrival time (BAT) = 1.3 (pCASL) or 0.7 (PASL)
%   slicedt = 0.0353125 (pCASL) or 0.0466666667 (PASL)
%   TR = 6 (pCASL) or 2.5 (PASL)
%   TE = 12 (pCASL) or 11 (PASL)
%   acq_order = ct (pCASL) or tc (PASL)
% elseif parameters = 'other'
%   specify parameters in a cell array in order [TI bolus bat slicedt TR TE acq_order] and input as varargin{1}
% end
%
% procMode = 'wholeProc', 'skipPreproc', 'postprocAndExtract', 'onlyExtract'
%
% tr_slicedt_mode = 'fix' or 'auto' - fix TR and slicedt or automatically calculate TR/slicedt for each subject.
%
% DICOM_path = path to a folder containing one DICOM file for each subject (filename = ID_DICOM). Use 'NA'
%              if tr_slicedt_mode is specified as 'fix'
% 
% refTiss = reference tissue for calibration - 'ventricularCSF', 'voxel' (white paper mode), and 'wm'
%
%
% -----
% NOTES
% -----
% In ASLprocessing_main_FSL, PASL is supposed to have M0 as the first volume, whereas pCASL should have M0 as a
% separate image.
%
% ---------
% DEVELOPER
% ---------
%
% Dr. Jiyang Jiang (jiyang.jiang@unsw.edu.au)
% December, 2017
%
% Copyright Reserved
%
%
% ------------------
% FUTURE IMPROVEMENT
% ------------------
% 1) Need to implement PASL with separate M0. Now only able to process PASL with first volume as M0.
%




function ASLprocessing_main_FSL (ASLtype, ...
                                 studyFolder, ...
                                 spm12path, ...
                                 parameters, ...
                                 procMode, ...
                                 tr_slicedt_mode, ...
                                 DICOM_path, ...
                                 refTiss, ...
                                 varargin)

Perfusion_folder = fileparts (mfilename ('fullpath'));
ASLprocessing_FSL_folder = [Perfusion_folder '/ASLprocessing_FSL'];
CNSP_path = fileparts (Perfusion_folder);

addpath ([CNSP_path '/Scripts']);

% resolve paramCellArr
if strcmp (parameters, 'OATS')
    if strcmp (ASLtype, 'pCASL')
        TI = '3.8';
        bolus = '1.8';
        BAT = '1.3';
        slicedt = '0.0353125';
        TR = '6';
        TE = '12';
        acq_order = 'ct';
        fprintf ('\n');
        fprintf ('OATS pCASL parameters are used:\n');
        fprintf ('TI = %s\n', TI);
        fprintf ('bolus = %s\n', bolus);
        fprintf ('BAT = %s\n', BAT);
        fprintf ('slicedt = %s\n', slicedt);
        fprintf ('TR = %s\n', TR);
        fprintf ('TE = %s\n', TE);
        fprintf ('acquisition order = %s\n', acq_order);
        fprintf ('\n');
    elseif strcmp (ASLtype, 'PASLwM0')
        TI = '1.8';
        bolus = '0.7';
        BAT = '0.7';
        slicedt = '0.0466666667';
        TR = '2.5';
        TE = '11';
        acq_order = 'tc';
        fprintf ('\n');
        fprintf ('OATS PASL parameters are used:\n');
        fprintf ('TI = %s\n', TI);
        fprintf ('bolus = %s\n', bolus);
        fprintf ('BAT = %s\n', BAT);
        fprintf ('slicedt = %s\n', slicedt);
        fprintf ('TR = %s\n', TR);
        fprintf ('TE = %s\n', TE);
        fprintf ('acquisition order = %s\n', acq_order);
        fprintf ('\n');
    end
elseif strcmp (parameters, 'other')
    paramCellArr = varargin{1};
    
    TI = num2str (paramCellArr{1});
    bolus = num2str (paramCellArr{2});
    BAT = num2str (paramCellArr{3});
    slicedt = num2str (paramCellArr{4});
    TR = num2str (paramCellArr{5});
    TE = num2str (paramCellArr{6});
    acq_order = paramCellArr{7};
    fprintf ('\n');
    fprintf ('Following parameters are specified:\n');
    fprintf ('TI = %s\n', TI);
    fprintf ('bolus = %s\n', bolus);
    fprintf ('BAT = %s\n', BAT);
    fprintf ('slicedt = %s\n', slicedt);
    fprintf ('TR = %s\n', TR);
    fprintf ('TE = %s\n', TE);
    fprintf ('acquisition order = %s\n', acq_order);
    fprintf ('\n');
end

fprintf ('Reference tissue = %s\n\n', refTiss);

% cleanup previous results - only if wholeProc

if strcmp (procMode, 'wholeProc')
    if exist ([studyFolder '/originalImg'], 'dir') == 7
        if strcmp (ASLtype, 'pCASL')
            movefile ([studyFolder '/originalImg/M0'], ...
                        studyFolder);
            movefile ([studyFolder '/originalImg/T1'], ...
                        studyFolder);
            movefile ([studyFolder '/originalImg/pCASL'], ...
                        studyFolder);
        elseif strcmp (ASLtype, 'PASLwM0')
            movefile ([studyFolder '/originalImg/T1'], ...
                        studyFolder);
            movefile ([studyFolder '/originalImg/PASLwM0'], ...
                        studyFolder);
        end
                
        rmdir ([studyFolder '/originalImg'], 's');
        rmdir ([studyFolder '/subjects'], 's');         
    end

    % start new processing
    mkdir (studyFolder, 'originalImg');
    mkdir (studyFolder, 'subjects');

    if strcmp (ASLtype, 'pCASL')
        movefile ([studyFolder '/M0'], ...
                        [studyFolder '/originalImg']);
        movefile ([studyFolder '/T1'], ...
                        [studyFolder '/originalImg']);
        movefile ([studyFolder '/pCASL'], ...
                        [studyFolder '/originalImg']);
    elseif strcmp (ASLtype, 'PASLwM0')
        movefile ([studyFolder '/T1'], ...
                        [studyFolder '/originalImg']);
        movefile ([studyFolder '/PASLwM0'], ...
                        [studyFolder '/originalImg']);
    end    

    fprintf ('gzipping, please wait ...');
    system (['gzip -f ' studyFolder '/originalImg/*/*.nii']); % gzip all nii
    fprintf ('            Done.\n');

% ~ wholeProc
else
    fprintf ('%s mode - not cleaning up existing folders.\n', procMode);
end

T1list_struct = dir ([studyFolder '/originalImg/T1/*.nii.gz']);
[Nt1,~] = size (T1list_struct);

fprintf ('%d subjects in %s\n', Nt1, studyFolder);



% variables for QC
GM_CBF_Jmod_cellArr = cell (Nt1, 1);
ASLspaceAtlas_cellArr = cell (Nt1, 1);
system (['if [ -d "' studyFolder '/subjects/QC" ]; then rm -fr ' studyFolder '/subjects/QC; fi']);
system (['mkdir ' studyFolder '/subjects/QC']);



% ################ %
% process ASL data %
% ################ %



% ================ %
% if ~ onlyExtract %
% ================ %
if ~strcmp (procMode, 'onlyExtract')

    parfor i = 1:Nt1
        T1name = T1list_struct(i).name;
        T1name_parts = strsplit (T1name, '_');
        ID = T1name_parts{1};
        mkdir ([studyFolder '/subjects'], ...
                ID);



       

        % ===== %
        % pCASL %
        % ===== %

        if strcmp (ASLtype, 'pCASL')
            
            % copy T1, pCASL, M0 to individual folder
            copyfile ([studyFolder '/originalImg/T1/' ID '_T1.nii.gz'],...
                        [studyFolder '/subjects/' ID]);
            copyfile ([studyFolder '/originalImg/pCASL/' ID '_pCASL.nii.gz'],...
                        [studyFolder '/subjects/' ID]);
            copyfile ([studyFolder '/originalImg/M0/' ID '_M0.nii.gz'],...
                        [studyFolder '/subjects/' ID]);
            


            % ====================================== %
            % pCASL - whether skipping preprocessing %
            % ====================================== %

            if strcmp (procMode, 'wholeProc')
                fprintf ('%s mode - preprocessing started.\n', procMode);
                system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_preprocessing.sh ' ...
                                                                                      ID ' ' ...
                                                                                      studyFolder '/subjects/' ID ' ' ...
                                                                                      CNSP_path ' ' ...
                                                                                      spm12path ' ' ...
                                                                                      ASLtype]);

            else

                fprintf ('%s mode - preprocessing skipped.\n', procMode);

            end

            % ============================= %
            % pCASL - whether process pCASL %
            % ============================= %
            if strcmp (procMode, 'onlyExtract') || ...
                strcmp (procMode, 'postprocAndExtract')

                fprintf ('%s mode - oxford_asl processing step skipped.\n', procMode);

            else

                fprintf ('%s mode - oxford_asl processing started.\n', procMode);
                system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_processpCASL.sh ' ...
                                                                                    ID ' ' ...
                                                                                    spm12path ' ' ...
                                                                                    studyFolder ' ' ...
                                                                                    TI ' ' ...
                                                                                    bolus ' ' ...
                                                                                    BAT ' ' ...
                                                                                    slicedt ' ' ...
                                                                                    TR ' ' ...
                                                                                    TE ' ' ...
                                                                                    acq_order ' ' ...
                                                                                    tr_slicedt_mode ' ' ...
                                                                                    DICOM_path ' ' ...
                                                                                    refTiss]);
            end
            

            % =================== %
            % pCASL - postprocess %
            % =================== %
            fprintf ('Postprocessing started.\n');
            system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_postprocessing_globalMeas.sh ' ...
                                                                                                ID ' ' ...
                                                                                                studyFolder '/subjects/' ID ' ' ...
                                                                                                CNSP_path ' ' ...
                                                                                                spm12path ' ' ...
                                                                                                ASLtype]);

            system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_postprocessing_regionalMeas.sh ' ...
                                                                                                ID ' ' ...
                                                                                                studyFolder '/subjects/' ID ' ' ...
                                                                                                CNSP_path ' ' ...
                                                                                                ASLtype]);


        % ==== %
        % PASL %
        % ==== %

        elseif strcmp (ASLtype, 'PASLwM0')

            % copy T1 and PASLwM0
            copyfile ([studyFolder '/originalImg/T1/' ID '_T1.nii.gz'], ...
                        [studyFolder '/subjects/' ID]);
            copyfile ([studyFolder '/originalImg/PASLwM0/' ID '_PASLwM0.nii.gz'], ...
                        [studyFolder '/subjects/' ID]);



            % ===================================== %
            % PASL - whether skipping preprocessing %
            % ===================================== %
            if strcmp (procMode, 'wholeProc')
                fprintf ('%s mode - preprocessing started.\n', procMode);
                system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_preprocessing.sh ' ...
                                                                                      ID ' ' ...
                                                                                      studyFolder '/subjects/' ID ' ' ...
                                                                                      CNSP_path ' ' ...
                                                                                      spm12path ' ' ...
                                                                                      ASLtype]);


            else
                fprintf ('%s mode - preprocessing skipped.\n', procMode);
               
            end

            % =========================== %
            % PASL - whether process PASL %
            % =========================== %
            if strcmp (procMode, 'onlyExtract') || ...
                strcmp (procMode, 'postprocAndExtract')

                fprintf ('%s mode - oxford_asl processing step skipped.\n', procMode);

            else

                fprintf ('%s mode - oxford_asl processing started.\n', procMode);
                system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_processPASL.sh ' ...
                                                                                    ID ' ' ...
                                                                                    spm12path ' ' ...
                                                                                    studyFolder ' ' ...
                                                                                    TI ' ' ...
                                                                                    bolus ' ' ...
                                                                                    BAT ' ' ...
                                                                                    slicedt ' ' ...
                                                                                    TR ' ' ...
                                                                                    TE ' ' ...
                                                                                    acq_order ' ' ...
                                                                                    tr_slicedt_mode ' ' ...
                                                                                    DICOM_path ' ' ...
                                                                                    refTiss]);
            end


            % ================== %
            % PASL - postprocess %
            % ================== %
            fprintf ('Postprocessing started.\n');
            system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_postprocessing_globalMeas.sh ' ...
                                                                                                ID ' ' ...
                                                                                                studyFolder '/subjects/' ID ' ' ...
                                                                                                CNSP_path ' ' ...
                                                                                                spm12path ' ' ...
                                                                                                ASLtype]);

            system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_postprocessing_regionalMeas.sh ' ...
                                                                                                ID ' ' ...
                                                                                                studyFolder '/subjects/' ID ' ' ...
                                                                                                CNSP_path ' ' ...
                                                                                                ASLtype]);
            
        end
        
        
        
        % =========================== %
        % cell array of images for QC %
        % =========================== %
        GM_CBF_Jmod_cellArr{i,1} = [studyFolder '/subjects/' ID '/' ID '_invKineticMdl_wT1/native_space/pvcorr/perfusion_calib_GM_Jmod.nii.gz'];
        ASLspaceAtlas_cellArr{i,1} = [studyFolder '/subjects/' ID '/Atlas/MNI-maxprob-thr50-2mm_ASLspace.nii.gz'];
        system (['cp ' GM_CBF_Jmod_cellArr{i, 1} ' ' studyFolder '/subjects/QC/' ID '_GM_CBF_Jmod.nii.gz']);
        system (['cp ' ASLspaceAtlas_cellArr{i, 1} ' ' studyFolder '/subjects/QC/' ID '_ASLspace_atlas.nii.gz']);
        GM_CBF_Jmod_cellArr{i, 1} = [studyFolder '/subjects/QC/' ID '_GM_CBF_Jmod.nii.gz'];
        ASLspaceAtlas_cellArr{i, 1} = [studyFolder '/subjects/QC/' ID '_ASLspace_atlas.nii.gz'];
    end





    % ========================= %
    % extract perfusion results %
    % ========================= %
    fprintf ('Extracting perfusion results to %s/perfusion_results.txt\n', studyFolder);

    system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_createResultFile.sh ' studyFolder]);

    for i = 1:Nt1
        T1name = T1list_struct(i).name;
        T1name_parts = strsplit (T1name, '_');
        ID = T1name_parts{1};

        system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_extractASLresults.sh ' ID ' ' studyFolder]);
    end


    
% ============== %
% if onlyExtract %
% ============== %
else

    % extract perfusion results
    fprintf ('Extracting perfusion results to %s/perfusion_results.txt\n', studyFolder);

    system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_createResultFile.sh ' studyFolder]);

    for i = 1:Nt1
        T1name = T1list_struct(i).name;
        T1name_parts = strsplit (T1name, '_');
        ID = T1name_parts{1};

        system ([ASLprocessing_FSL_folder '/ASLprocessing_FSL_extractASLresults.sh ' ID ' ' studyFolder]);


        % =========================== %
        % cell array of images for QC %
        % =========================== %
        GM_CBF = [studyFolder '/subjects/' ID '/' ID '_invKineticMdl_wT1/native_space/pvcorr/perfusion_calib_GM_Jmod.nii.gz'];
        ASLspaceAtlas = [studyFolder '/subjects/' ID '/Atlas/MNI-maxprob-thr50-2mm_ASLspace.nii.gz'];
        system (['cp ' GM_CBF ' ' studyFolder '/subjects/QC/' ID '_GM_CBF_Jmod.nii.gz']);
        system (['cp ' ASLspaceAtlas ' ' studyFolder '/subjects/QC/' ID '_ASLspace_atlas.nii.gz']);
        GM_CBF_Jmod_cellArr{i, 1} = [studyFolder '/subjects/QC/' ID '_GM_CBF_Jmod.nii.gz'];
        ASLspaceAtlas_cellArr{i, 1} = [studyFolder '/subjects/QC/' ID '_ASLspace_atlas.nii.gz'];
    end
end



% == %
% QC %
% == %

CNSP_webViewSlices_pair (GM_CBF_Jmod_cellArr, ...
                         ASLspaceAtlas_cellArr, ...
                         [studyFolder '/subjects/QC'], ...
                         'ASLprocessing_FSL_QC', ...
                         'web');
