function WMHextraction_long_paired (studyFolder, spm12path, Ntp, ageRange)

% add path
CNSP_path = fileparts(fileparts(fileparts(which([mfilename '.m']))));

addpath (spm12path);
addpath(genpath(CNSP_path));


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
fprintf ('UBO Detector (paired long): gunzip images ...\n');

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
fprintf ('UBO Detector (paired long): organising folders ...\n');

mkdir (studyFolder, 'subjects');
mkdir (studyFolder, 'originalImg');
movefile ([studyFolder '/T1'], [studyFolder '/originalImg'], 'f');
movefile ([studyFolder '/FLAIR'], [studyFolder '/originalImg'], 'f');


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


% register all tp T1 to tp1
fprintf ('UBO Detector (paired long): registering all time points'' T1 to the first time point ...\n');

for f = 2:Ntp
    t1Folder = dir ([studyFolder '/originalImg/T1/tp' num2str(f) '/*.nii']);
    [Nt1,~] = size (t1Folder);
    
    parfor i = 1:Nt1
       t1Name = t1Folder(i).name;
       t1NameParts = strsplit (t1Name , '_');
       ID = t1NameParts{1};
       
       mkdir ([studyFolder '/subjects/tp' num2str(f) '/' ID], 'mri');
       mkdir ([studyFolder '/subjects/tp' num2str(f) '/' ID '/mri'], 'preprocessing');
       
       refImgName = dir ([studyFolder '/originalImg/T1/tp1/' ID '_*.nii']);
       
       CNSP_registration ([studyFolder '/originalImg/T1/tp' num2str(f) '/' t1Name], ...
                            [studyFolder '/originalImg/T1/tp1/' refImgName], ...
                            [studyFolder '/subjects/tp' num2str(f) '/' ID '/mri/preprocessing']);
        
    end
end




% register FLAIR to tp1's T1
fprintf ('UBO Detector (paired long): registering all tiem points'' FLAIR to the first time point''s T1 ...\n');

for f = 1:Ntp
    flairFolder = dir ([studyFolder '/originalImg/FLAIR/tp' num2str(f) '/*.nii']);
    [Nflair,~] = size (flairFolder);
    
    parfor i = 1:Nflair
      flairName = flairFolder(i).name;
      flairNameParts = strsplit (flairName , '_');
      ID = flairNameParts{1};

      if f == 1
        mkdir ([studyFolder '/subjects/tp1/' ID], 'preprocessing'); % tp1 preprocessing folder
      end
      
      refImgName = dir ([studyFolder '/originalImg/T1/tp1/' ID '_*.nii']);
      CNSP_registration ([studyFolder '/originalImg/FLAIR/tp' num2str(f) '/' flairName], ...
                    [studyFolder '/originalImg/T1/tp1/' refImgName], ...
                    [studyFolder '/subjects/tp' num2str '/' ID '/mri/preprocessing']);
    end
end


% tp1 T1 segmentation and DARTEL

fprintf ('UBO Detector (paired long): time point 1''s T1 segmentation and DARTEL ...\n');

tp1T1folder = dir ([studyFolder '/originalImg/tp1/T1/*.nii']);
[Ntp1t1,~] = size (tp1T1folder);

template1 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                        ageRange ...
                        '/Template_1.nii'];
template2 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                        ageRange ...
                        '/Template_2.nii'];
template3 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                        ageRange ...
                        '/Template_3.nii'];
template4 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                        ageRange ...
                        '/Template_4.nii'];
template5 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                        ageRange ...
                        '/Template_5.nii'];
template6 = [CNSP_path '/Templates/DARTEL_0to6_templates/' ...
                        ageRange ...
                        '/Template_6.nii'];

parfor i = 1:Ntp1t1
    tp1T1name = tp1T1folder(i).name;
    tp1T1nameParts = strsplit (tp1T1name, '_');
    ID = tp1T1nameParts{1};
    
    [cGM,cWM,cCSF,rcGM,rcWM,rcCSF,seg8mat] = CNSP_segmentation ([studyFolder '/originalImg/tp1/T1/' tp1T1name], spm12path);
    
    flowMap = CNSP_runDARTELe (rcGM, rcWM, rcCSF, template1, template2, template3, template4, template5, template6);
    
    for f = 1:Ntp
        rFLAIRname = dir ([studyFolder '/subjects/tp' num2str(f) '/' ID '/preprocessing/r' ID '_*.nii']);
        rFLAIRonDARTEL = CNSP_nativeToDARTEL ([studyFolder '/subjects/tp' num2str(f) '/' ID '/preprocessing/' rFLAIRname], flowMap);
        movefile (rFLAIRonDARTEL, [studyFolder '/subjects/tp' num2str(f) '/' ID '/preprocessing'], 'f');
    end
    
    movefile (cGM, [studyFolder '/subjects/tp1/' ID '/preprocessing'], 'f');
    movefile (cWM, [studyFolder '/subjects/tp1/' ID '/preprocessing'], 'f');
    movefile (cCSF, [studyFolder '/subjects/tp1/' ID '/preprocessing'], 'f');
    movefile (rcGM, [studyFolder '/subjects/tp1/' ID '/preprocessing'], 'f');
    movefile (rcWM, [studyFolder '/subjects/tp1/' ID '/preprocessing'], 'f');
    movefile (rcCSF, [studyFolder '/subjects/tp1/' ID '/preprocessing'], 'f');
    movefile (seg8mat, [studyFolder '/subjects/tp1/' ID '/preprocessing'], 'f');
    
    movefile (flowMap, [studyFolder '/subjects/tp1/' ID '/preprocessing'], 'f');
end





