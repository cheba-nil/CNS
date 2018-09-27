function WMHextraction_long_unpaired (studyFolder, spm12path, Ntp)

% add path
addpath (spm12path);
addpath(genpath(fileparts(fileparts(fileparts(which([mfilename '.m']))))));

% reset prior processing if necessary
if exist ([studyFolder '/originalImg'], 'dir') == 7
    fprintf ('UBO Detector (paried long): Warning: Previous processing will be overwritten.');
    
    movefile ([studyFolder '/originalImg/T1'], studyFolder);
    movefile ([studyFolder '/originalImg/FLAIR'], studyFolder);
    
    rmdir ([studyFolder '/originalImg'], 's');
    
    if exist ([studyFolder '/subjects'], 'dir') == 7
        rmdir ([studyFolder '/subjects'], 's');
    end
end


% gunzip images, and check pairing and ID
fprintf ('UBO Detector (unpaired long): gunzip images ...\n');

for f = 1:Ntp
    t1Folder = dir ([studyFolder '/T1/tp' num2str(f) '/*.nii*']);
    flairFolder = dir ([studyFolder '/FLAIR/tp' num2str(f) '/*.nii*']);
    
    [Nt1,~] = size (t1Folder);
    [Nflair,~] = size (flairFolder);
    
    % check whether num of T1 matching num of FLAIR
    if Nt1 ~= Nflair
        error ('Num of T1 does not match num of FLAIR.');
    end
    
    parfor i = 1:Nt1
        t1Name = t1Folder(i).name;
        flairName = flairFolder(i).name;

        % check T1-FLAIR matching
        t1NameParts = strsplit (t1Name, '_');
        flairNameParts = strsplit (flairName, '_');

        if ~strcmp (t1NameParts{1}, flairNameParts{1})
            error (['ID in T1 filename not matching FLAIR. ID in T1 = ' t1NameParts{1} '; ID in FLAIR = ' flairNameParts{1}]);
        end
        
        CNSP_gunzipnii ([studyFolder '/T1/tp' num2str(f) '/' t1Name]);
        CNSP_gunzipnii ([studyFolder '/FLAIR/tp' num2str(f) '/' flairName]);
        
    end
end


% organising folders
fprintf ('UBO Detector (unpaired long): organising folders ...\n');

mkdir (studyFolder, 'subjects');
mkdir (studyFolder, 'originalImg');
movefile [studyFolder '/T1'] [studyFolder '/originalImg'] f
movefile [studyFolder '/FLAIR'] [studyFolder '/originalImg'] f


for f = 1:Ntp
    t1Folder = dir ([studyFolder '/originalImg/T1/tp' num2str(f) '/*.nii']);
    [Nt1,~] = size (t1Folder);
    
    mkdir ([studyFolder '/subjects'], ['tp' num2str(f)]);
    
    parfor i = 1:Nt1
       t1Name = t1Folder(i).name;
       t1NameParts = strsplit (t1Name , '_');
       ID = t1NameParts{1};

       mkdir ([studyFolder '/subjects/tp' num2str(f)], ID);
        
    end
end


% register all tp T1 to the first tp
fprintf ('UBO Detector (unpaired long): registering all time points T1 to the first time point ...\n');

for f = 2:Ntp
    t1Folder = dir ([studyFolder '/originalImg/T1/tp' num2str(f) '/*.nii']);
    [Nt1,~] = size (t1Folder);
    
    parfor i = 1:Nt1
       t1Name = t1Folder(i).name;
       t1NameParts = strsplit (t1Name , '_');
       ID = t1NameParts{1};
        
       for j = 1:f
           if ~isempty (dir ([studyFolder '/originalImg/T1/tp' num2str(j) '/' ID '_*.nii']))
               refImg = dir ([studyFolder '/originalImg/T1/tp' num2str(j) '/' ID '_*.nii']);
               CNSP_registration ([studyFolder '/originalImg/T1/tp' num2str(f) '/' t1Name], [studyFolder '/originalImg/T1/tp' num2str(j) '/' refImg]);
               break;
           end
       end
        
    end
end
