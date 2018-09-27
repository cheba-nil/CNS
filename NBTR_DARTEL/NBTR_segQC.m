
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Checking Segmentation   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function NBTR_segQC (imgFolder, CNSP_path)

    cmd_1 = ['chmod +x ' CNSP_path '/NBTR_DARTEL/generateQCimgs.sh'];
    system (cmd_1);

    cmd_2 = [' if [ ! -d ' imgFolder '/QC ]; then mkdir ' imgFolder '/QC; fi'];
    system (cmd_2);

    cmd_3 = ['if [ -f ' imgFolder '/QC/QC_Segmentation.html ]; then rm -f ' imgFolder '/QC/QC_Segmentation.html; fi'];
    system (cmd_3);

    cmd_4 = ['echo "<HTML><TITLE>QC_Segmentation</TITLE><BODY BGCOLOR="#aaaaff">" >> ' imgFolder '/QC/QC_Segmentation.html'];
    system (cmd_4);


    % loop through all subjects

    imgs = dir (strcat (imgFolder,'/*.nii'));
    [Nsubj,n] = size (imgs);

    for i = 1:Nsubj

        imgNames = strsplit (imgs(i).name, '_');   % split T1 image name, delimiter is underscore
        imgFilenames = strsplit (imgs(i).name, '.');
        ID = imgNames{1};   % first section is ID
        imgFilename = imgFilenames{1};

        cmd = [CNSP_path '/NBTR_DARTEL/generateQCimgs.sh ' ID ' ' imgFolder ' ' imgFilename];
        system (cmd);
    end



    cmd_6 = ['echo "</BODY></HTML>" >> ' imgFolder '/QC/QC_Segmentation.html'];
    system (cmd_6);

    % cmd_7 = ['firefox ' studyFolder '/subjects/QC/QC_Segmentation.html'];   % use firefox to open the webpage - what if not installed?
    % cmd_7 = ['open ' studyFolder '/subjects/QC/QC_Segmentation.html'];       % for MAC OS
    % system (cmd_7);


    QC_seg = [imgFolder '/QC/QC_Segmentation.html'];
    web (QC_seg, '-new');

