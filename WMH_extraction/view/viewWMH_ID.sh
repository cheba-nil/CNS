#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

viewWMH_ID(){

	studyFolder=$1
	ID=$2

	restoreFLAIR=`ls ${studyFolder}/subjects/${ID}/mri/preprocessing/FAST_nonBrainRemoved_wr${ID}_*_restore.nii*`
	restoreMIN=`${FSLDIR}/bin/fslstats ${restoreFLAIR} -R | awk '{print $1}'`
	restoreMAX=`${FSLDIR}/bin/fslstats ${restoreFLAIR} -R | awk '{print $2}'`

	${FSLDIR}/bin/fslview ${restoreFLAIR} \
								-b ${restoreMIN},${restoreMAX} \
								${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH \
								-t 0.8 \
								-l "Red"
}

# $1 = study folder
# $2 = ID

viewWMH_ID $1 $2 