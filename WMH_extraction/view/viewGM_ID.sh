#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

viewGM_ID(){

	studyFolder=$1
	ID=$2

	GM=`ls ${studyFolder}/subjects/${ID}/mri/preprocessing/c1${ID}_*.nii*`
	T1=`ls ${studyFolder}/originalImg/T1/${ID}_*.nii*`
	T1_MIN=`${FSLDIR}/bin/fslstats ${T1} -R | awk '{print $1}'`
	T1_MAX=`${FSLDIR}/bin/fslstats ${T1} -R | awk '{print $2}'`

	${FSLDIR}/bin/fslview ${T1} \
								-b ${T1_MIN},${T1_MAX} \
								${GM} \
								-t 0.8 \
								-l "Red-Yellow"
}

# $1 = study folder
# $2 = ID

viewGM_ID $1 $2 