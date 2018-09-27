function dti_preprocessing (studyFolder,fthr,gthr)

CNSP_path = getappdata(0,'CNSP_path');
DTIimgfolder = dir ([studyFolder '/images/*.nii*']);
[Nsubj,~] = size (DTIimgfolder);

system (['chmod +x ' CNSP_path '/Scripts/fsl_bet.sh']);
system (['chmod +x ' CNSP_path '/Scripts/fsl_dtifit.sh']);

% reset folders
if exist ([studyFolder '/masks'],'dir') == 7
    rmdir ([studyFolder '/masks'],'s');
end
mkdir (studyFolder,'masks');

if exist ([studyFolder '/output'],'dir') == 7
    rmdir ([studyFolder '/output'],'s');
end
mkdir (studyFolder,'output');
mkdir ([studyFolder '/output'],'FA');
mkdir ([studyFolder '/output'],'MD');
mkdir ([studyFolder '/output'],'L1');
mkdir ([studyFolder '/output'],'L2');
mkdir ([studyFolder '/output'],'L3');
mkdir ([studyFolder '/output'],'MO');
mkdir ([studyFolder '/output'],'S0');
mkdir ([studyFolder '/output'],'V1');
mkdir ([studyFolder '/output'],'V2');
mkdir ([studyFolder '/output'],'V3');

parfor i = 1:Nsubj
    DTIimgNames = strsplit (DTIimgfolder(i).name, '_');
    ID = DTIimgNames{1};
    DTIimgfilename_parts = strsplit (DTIimgfolder(i).name, '.');
    DTIimgfilename = DTIimgfilename_parts{1};
    
    % FSL bet
    system ([CNSP_path '/Scripts/fsl_bet.sh ' studyFolder '/images/' DTIimgfilename ' ' ...
                                              studyFolder '/masks/' DTIimgfilename '_brainmask ' ...
                                              fthr ' ' ...
                                              gthr]);
    
    % FSL dtifit
    system ([CNSP_path '/Scripts/fsl_dtifit.sh ' studyFolder '/images/' DTIimgfolder(i).name ' ' ...
                                                 studyFolder '/output/' DTIimgfilename ' ' ...
                                                 studyFolder '/masks/' DTIimgfilename '_brainmask.nii.gz ' ...
                                                 studyFolder '/BVEC/' DTIimgfilename '.bvec ' ...
                                                 studyFolder '/BVAL/' DTIimgfilename '.bval']);
                                             
    movefile ([studyFolder '/output/' DTIimgfilename '_FA.nii.gz'],[studyFolder '/output/FA']);
    movefile ([studyFolder '/output/' DTIimgfilename '_MD.nii.gz'],[studyFolder '/output/MD']);
    movefile ([studyFolder '/output/' DTIimgfilename '_L1.nii.gz'],[studyFolder '/output/L1']);
    movefile ([studyFolder '/output/' DTIimgfilename '_L2.nii.gz'],[studyFolder '/output/L2']);
    movefile ([studyFolder '/output/' DTIimgfilename '_L3.nii.gz'],[studyFolder '/output/L3']);
    movefile ([studyFolder '/output/' DTIimgfilename '_MO.nii.gz'],[studyFolder '/output/MO']);
    movefile ([studyFolder '/output/' DTIimgfilename '_S0.nii.gz'],[studyFolder '/output/S0']);
    movefile ([studyFolder '/output/' DTIimgfilename '_V1.nii.gz'],[studyFolder '/output/V1']);
    movefile ([studyFolder '/output/' DTIimgfilename '_V2.nii.gz'],[studyFolder '/output/V2']);
    movefile ([studyFolder '/output/' DTIimgfilename '_V3.nii.gz'],[studyFolder '/output/V3']);
end