#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

viewCoreg_ID(){

	studyFolder=$1
	ID=$2

	rFLAIR=`ls ${studyFolder}/subjects/${ID}/mri/preprocessing/r${ID}_*.nii*`
	T1=`ls ${studyFolder}/originalImg/T1/${ID}_*.nii*`
	T1_MIN=`${FSLDIR}/bin/fslstats ${T1} -R | awk '{print $1}'`
	T1_MAX=`${FSLDIR}/bin/fslstats ${T1} -R | awk '{print $2}'`

	${FSLDIR}/bin/fslview ${T1} \
								-b ${T1_MIN},${T1_MAX} \
								${rFLAIR} \
								-t 0.6 \
								-l "Greyscale"
}

# $1 = study folder
# $2 = ID

viewCoreg_ID $1 $2 