#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh


M0_NBTR(){

	ID=$1
	indFolder=$2
	CNSP_path=$3
	spm12path=$4

	gunzip ${indFolder}/${ID}_M0.nii.gz

	# matlab -nodisplay -nosplash -nojvm -r "addpath('${CNSP_path}/Scripts','${spm12path}');\
	# 										CNSP_registration ('${indFolder}/${ID}_M0.nii',\
	# 															'${indFolder}/${ID}_T1.nii',\
	# 															'${indFolder}/intermediateOutput');\
	# 										exit" \
	# 										>> ${indFolder}/${ID}_logfile.txt

	${FSLDIR}/bin/fslmaths ${indFolder}/intermediateOutput/c1${ID}_T1.nii \
							-add ${indFolder}/intermediateOutput/c2${ID}_T1.nii \
							-add ${indFolder}/intermediateOutput/c3${ID}_T1.nii \
							-thr 0.3 \
							-bin \
							${indFolder}/intermediateOutput/${ID}_T1_brainmask


	gunzip ${indFolder}/intermediateOutput/${ID}_T1_brainmask.nii.gz
	
	matlab -nodisplay -nosplash -nojvm -r "addpath('${CNSP_path}/Scripts','${spm12path}');\
											CNSP_reverse_registration_wMx ('${indFolder}/${ID}_M0.nii',\
																			'${indFolder}/${ID}_T1.nii',\
																			'${indFolder}/intermediateOutput/${ID}_T1_brainmask.nii');\
											exit" \
											>> ${indFolder}/${ID}_logfile.txt

	gzip ${indFolder}/${ID}_T1.nii
	gzip ${indFolder}/${ID}_M0.nii
	gzip ${indFolder}/intermediateOutput/r${ID}_T1_brainmask.nii
	# gzip ${indFolder}/intermediateOutput/rr${ID}_M0_brain.nii

	mv ${indFolder}/intermediateOutput/r${ID}_T1_brainmask.nii.gz \
		${indFolder}/${ID}_M0_brainmask.nii.gz

	${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_M0_brainmask \
							-nan \
							${indFolder}/${ID}_M0_brainmask

	${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_M0 \
							-mas ${indFolder}/${ID}_M0_brainmask \
							${indFolder}/${ID}_M0_brain
}

M0_NBTR $1 $2 $3 $4