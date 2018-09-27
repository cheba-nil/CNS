% get actural TR and slicedt for ASL data
%
% DICOM_path = path to DICOM files, all named as ID_DICOM
% write2txt = 'Y' or 'N'. Whether write actTR and slicedt to text file
% ASLtype = 'pCASL' or 'PASLwM0'
% LDtime = (labelTime + delayTime) in pCASL
%           TI2 in PASL
%           LDtime should be passed as char in sec
%
%
% NOTE: Presume actual TR = min TR, otherwise specify varargin{1} as minTR (as char in millisec)

function [ASLactTR, ASLslicedt] = ASLprocessing_FSL_getASLactTRandSlicedt (DICOM_path, ...
                                                                           studyFolder, ...
                                                                           ID, ...
                                                                           ASLtype, ...
                                                                           write2txt, ...
                                                                           LDtime, ...
                                                                           varargin)

dicomInfo = dicominfo ([DICOM_path '/' ID '_DICOM']);

% actual TR
ASLactTR = dicomInfo.RepetitionTime;

% min TR
if nargin == 6
    minTR = ASLactTR;
elseif nargin == 7
    minTR = str2num(varargin{1});
end

% get number of slices for ASL
ASLniigz = [studyFolder '/originalImg/' ASLtype '/' ID '_' ASLtype '.nii.gz'];
[~, Nslices] = system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
                        'fslval ' ASLniigz ' dim3 | tr -d ''\n'' | sed ''s/ //g''']);


% calculate slicedt
ASLslicedt = (minTR - str2num(LDtime)*1000) / str2num(Nslices);

if strcmp (write2txt, 'Y')
    txt = [studyFolder '/subjects/' ID '/tr_slicedt.txt'];
    system (['if [ -f "' txt '" ]; then rm -f ' txt ';fi']);
    fid = fopen (txt, 'w');
    fprintf (fid, '%.5f,%.5f\n', ASLactTR/1000, ASLslicedt/1000);
    fclose (fid);
end