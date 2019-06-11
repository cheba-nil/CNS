function subject_log (message,studyFolder,ID)
    fp = fopen(strcat(studyFolder,'/subjects/',ID,'/logfile.txt'),'a');
    fprintf(fp,message);
    fclose(fp);
