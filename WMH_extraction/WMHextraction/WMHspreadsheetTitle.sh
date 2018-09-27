#!/bin/bash

WMHspreadsheetTitle(){
    
    subj_dir=$1

    if [ -f "${subj_dir}/WMH_spreadsheet.txt" ]; then
        rm -f ${subj_dir}/WMH_spreadsheet.txt
    fi

    # title
    echo -n "ID,wholeBrainWMHvol_mm3,PVWMHvol_mm3,DWMHvol_mm3,Lfrontal_WMHvol_mm3,Rfrontal_WMHvol_mm3,Ltemporal_WMHvol_mm3,Rtemporal_WMHvol_mm3,Lparietal_WMHvol_mm3,Rparietal_WMHvol_mm3,Loccipital_WMHvol_mm3,Roccipital_WMHvol_mm3,Lcerebellum_WMHvol_mm3,Rcerebellum_WMHvol_mm3,Brainstem_WMHvol_mm3," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo -n "lAAH_WMHvol_mm3,rAAH_WMHvol_mm3,lMAH_WMHvol_mm3,rMAH_WMHvol_mm3,lAAML_WMHvol_mm3,rAAML_WMHvol_mm3,lAAC_WMHvol_mm3,rAAC_WMHvol_mm3,lMALL_WMHvol_mm3,rMALL_WMHvol_mm3,lPATMP_WMHvol_mm3,rPATMP_WMHvol_mm3,lPAH_WMHvol_mm3,rPAH_WMHvol_mm3,lPAC_WMHvol_mm3,rPAC_WMHvol_mm3," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo -n "wholeBrain_WMHnoc_total,PV_WMHnoc_total,Lfontal_WMHnoc_total,Rfontal_WMHnoc_total,Ltemporal_WMHnoc_total,Rtemporal_WMHnoc_total,Lparietal_WMHnoc_total,Rparietal_WMHnoc_total,Loccipital_WMHnoc_total,Roccipital_WMHnoc_total,Lcerebellum_WMHnoc_total,Rcerebellum_WMHnoc_total,Brainstem_WMHnoc_total," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo -n "lAAH_WMHnoc_total,rAAH_WMHnoc_total,lMAH_WMHnoc_total,rMAH_WMHnoc_total,lAAML_WMHnoc_total,rAAML_WMHnoc_total,lAAC_WMHnoc_total,rAAC_WMHnoc_total,lMALL_WMHnoc_total,rMALL_WMHnoc_total,lPATMP_WMHnoc_total,rPATMP_WMHnoc_total,lPAH_WMHnoc_total,rPAH_WMHnoc_total,lPAC_WMHnoc_total,rPAC_WMHnoc_total," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo -n "wholeBrain_WMHnoc_punctuate,PV_WMHnoc_punctuate,Lfrontal_WMHnoc_punctuate,Rfrontal_WMHnoc_punctuate,Ltemporal_WMHnoc_punctuate,Rtemporal_WMHnoc_punctuate,Lparietal_WMHnoc_punctuate,Rparietal_WMHnoc_punctuate,Loccipital_WMHnoc_punctuate,Roccipital_WMHnoc_punctuate,Lcerebellum_WMHnoc_punctuate,Rcerebellum_WMHnoc_punctuate,Brainstem_WMHnoc_punctuate," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo -n "lAAH_WMHnoc_punctuate,rAAH_WMHnoc_punctuate,lMAH_WMHnoc_punctuate,rMAH_WMHnoc_punctuate,lAAML_WMHnoc_punctuate,rAAML_WMHnoc_punctuate,lAAC_WMHnoc_punctuate,rAAC_WMHnoc_punctuate,lMALL_WMHnoc_punctuate,rMALL_WMHnoc_punctuate,lPATMP_WMHnoc_punctuate,rPATMP_WMHnoc_punctuate,lPAH_WMHnoc_punctuate,rPAH_WMHnoc_punctuate,lPAC_WMHnoc_punctuate,rPAC_WMHnoc_punctuate," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo -n "wholeBrain_WMHnoc_focal,PV_WMHnoc_focal,Lfrontal_WMHnoc_focal,Rfrontal_WMHnoc_focal,Ltemporal_WMHnoc_focal,Rtemporal_WMHnoc_focal,Lparietal_WMHnoc_focal,Rparietal_WMHnoc_focal,Loccipital_WMHnoc_focal,Roccipital_WMHnoc_focal,Lcerebellum_WMHnoc_focal,Rcerebellum_WMHnoc_focal,Brainstem_WMHnoc_focal," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo -n "lAAH_WMHnoc_focal,rAAH_WMHnoc_focal,lMAH_WMHnoc_focal,rMAH_WMHnoc_focal,lAAML_WMHnoc_focal,rAAML_WMHnoc_focal,lAAC_WMHnoc_focal,rAAC_WMHnoc_focal,lMALL_WMHnoc_focal,rMALL_WMHnoc_focal,lPATMP_WMHnoc_focal,rPATMP_WMHnoc_focal,lPAH_WMHnoc_focal,rPAH_WMHnoc_focal,lPAC_WMHnoc_focal,rPAC_WMHnoc_focal," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo -n "wholeBrain_WMHnoc_medium,PV_WMHnoc_medium,Lfrontal_WMHnoc_medium,Rfrontal_WMHnoc_medium,Ltemporal_WMHnoc_medium,Rtemporal_WMHnoc_medium,Lparietal_WMHnoc_medium,Rparietal_WMHnoc_medium,Loccipital_WMHnoc_medium,Roccipital_WMHnoc_medium,Lcerebellum_WMHnoc_medium,Rcerebellum_WMHnoc_medium,Brainstem_WMHnoc_medium," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo -n "lAAH_WMHnoc_medium,rAAH_WMHnoc_medium,lMAH_WMHnoc_medium,rMAH_WMHnoc_medium,lAAML_WMHnoc_medium,rAAML_WMHnoc_medium,lAAC_WMHnoc_medium,rAAC_WMHnoc_medium,lMALL_WMHnoc_medium,rMALL_WMHnoc_medium,lPATMP_WMHnoc_medium,rPATMP_WMHnoc_medium,lPAH_WMHnoc_medium,rPAH_WMHnoc_medium,lPAC_WMHnoc_medium,rPAC_WMHnoc_medium," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo -n "wholeBrain_WMHnoc_confluent,PV_WMHnoc_confluent,Lfrontal_WMHnoc_confluent,Rfrontal_WMHnoc_confluent,Ltemporal_WMHnoc_confluent,Rtemporal_WMHnoc_confluent,Lparietal_WMHnoc_confluent,Rparietal_WMHnoc_confluent,Loccipital_WMHnoc_confluent,Roccipital_WMHnoc_confluent,Lcerebellum_WMHnoc_confluent,Rcerebellum_WMHnoc_confluent,Brainstem_WMHnoc_confluent," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    echo "lAAH_WMHnoc_confluent,rAAH_WMHnoc_confluent,lMAH_WMHnoc_confluent,rMAH_WMHnoc_confluent,lAAML_WMHnoc_confluent,rAAML_WMHnoc_confluent,lAAC_WMHnoc_confluent,rAAC_WMHnoc_confluent,lMALL_WMHnoc_confluent,rMALL_WMHnoc_confluent,lPATMP_WMHnoc_confluent,rPATMP_WMHnoc_confluent,lPAH_WMHnoc_confluent,rPAH_WMHnoc_confluent,lPAC_WMHnoc_confluent,rPAC_WMHnoc_confluent" \
            >> ${subj_dir}/WMH_spreadsheet.txt
}

WMHspreadsheetTitle $1