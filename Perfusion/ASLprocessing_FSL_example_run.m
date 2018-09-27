% ===============================
% ASLprocessing_FSL_example_run.m
% ===============================

%% -----===== OATS PASL =====----- 
curr_folder = fileparts (mfilename ('fullpath'));
ASLprocessing_FSL_folder = curr_folder;

addpath (ASLprocessing_FSL_folder);

studyFolder = '/data_pub/jiyang/ASLprocessing/reconvertedRawData_reprocessing/FSL/PASL_FSL_wm';
spm12path = '/usr/share/spm12';
parameters = 'OATS';
ASLtype = 'PASLwM0';
procMode = 'skipPreproc';
tr_slicedt_mode = 'fix';
DICOM_path = 'NA';
refTiss = 'wm';

ASLprocessing_main_FSL (ASLtype, ...
                        studyFolder, ...
                        spm12path, ...
                        parameters, ...
                        procMode, ...
                        tr_slicedt_mode, ...
                        DICOM_path, ...
                        refTiss);

%% -----===== OATS pCASL =====----- 
curr_folder = fileparts (mfilename ('fullpath'));
ASLprocessing_FSL_folder = curr_folder;

addpath (ASLprocessing_FSL_folder);

studyFolder = '/data_pub/jiyang/ASLprocessing/reconvertedRawData_reprocessing/FSL/pCASL_FSL_wm';
spm12path = '/usr/share/spm12';
parameters = 'OATS';
ASLtype = 'pCASL';
procMode = 'skipPreproc';
tr_slicedt_mode = 'fix';
DICOM_path = 'NA';
refTiss = 'wm';

ASLprocessing_main_FSL (ASLtype, ...
                        studyFolder, ...
                        spm12path, ...
                        parameters, ...
                        procMode, ...
                        tr_slicedt_mode, ...
                        DICOM_path, ...
                        refTiss);


% %% -----======== TEST =======-------
% curr_folder = fileparts (mfilename ('fullpath'));
% ASLprocessing_FSL_folder = curr_folder;
% 
% addpath (ASLprocessing_FSL_folder);
% 
% studyFolder = '/data_pub/jiyang/ASLprocessing/reconvertedRawData_reprocessing/FSL/PASL_FSL_wm/test';
% spm12path = '/usr/share/spm12';
% parameters = 'OATS';
% ASLtype = 'PASLwM0';
% procMode = 'skipPreproc';
% tr_slicedt_mode = 'fix';
% DICOM_path = 'NA';
% % DICOM_path = '/data_pub/jiyang/ASLprocessing/reconvertedRawData_reprocessing/FSL/pCASL_FSL_ventCSF/test11325/DICOM';
% refTiss = 'wm';
% 
% ASLprocessing_main_FSL (ASLtype, ...
%                         studyFolder, ...
%                         spm12path, ...
%                         parameters, ...
%                         procMode, ...
%                         tr_slicedt_mode, ...
%                         DICOM_path, ...
%                         refTiss);
%                     
%                     
%                     
% curr_folder = fileparts (mfilename ('fullpath'));
% ASLprocessing_FSL_folder = curr_folder;
% 
% addpath (ASLprocessing_FSL_folder);
% 
% studyFolder = '/data_pub/jiyang/ASLprocessing/reconvertedRawData_reprocessing/FSL/pCASL_FSL_wm/test';
% spm12path = '/usr/share/spm12';
% parameters = 'OATS';
% ASLtype = 'pCASL';
% procMode = 'skipPreproc';
% tr_slicedt_mode = 'fix';
% DICOM_path = 'NA';
% refTiss = 'wm';
% 
% ASLprocessing_main_FSL (ASLtype, ...
%                         studyFolder, ...
%                         spm12path, ...
%                         parameters, ...
%                         procMode, ...
%                         tr_slicedt_mode, ...
%                         DICOM_path, ...
%                         refTiss);
