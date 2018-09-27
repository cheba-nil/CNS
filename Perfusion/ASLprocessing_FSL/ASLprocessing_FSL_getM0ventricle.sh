#!/bin/bash

getM0ventricle(){

	ID=$1
	indFolder=$2
	CNSP_path=$3
	spm12path=$4


	gunzip ${indFolder}/${ID}_M0.nii.gz
	# gunzip ${indFolder}/${ID}_M0_brain.nii.gz
	gunzip ${indFolder}/${ID}_T1.nii.gz
	matlab -nodisplay -nosplash -nojvm -r "addpath('${CNSP_path}/Scripts','${spm12path}');\
											ventricle=CNSP_getLatVentricles('${indFolder}/${ID}_M0.nii',\
																			'${indFolder}/${ID}_T1.nii',\
																			'${indFolder}/intermediateOutput',\
																			'${spm12path}');\
											copyfile(ventricle,\
													'${indFolder}/${ID}_M0_ventricle.nii');\
											exit" \
											>> ${indFolder}/${ID}_logfile.txt

	gzip ${indFolder}/${ID}_T1.nii
	gzip ${indFolder}/${ID}_M0.nii
	gzip ${indFolder}/${ID}_M0_ventricle.nii
}

getM0ventricle $1 $2 $3 $4