#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

visualAdjustment_1Yes(){

	studyFolder=$1
	ID=$2
	basedOn=$3
	YesIndex=$4


	restoreFLAIR=`ls ${studyFolder}/customiseClassifier/subjects/${ID}/mri/preprocessing/FAST_nonBrainRemoved_wr${ID}*_restore.nii*`
	restoreMIN=`${FSLDIR}/bin/fslstats ${restoreFLAIR} -R | awk '{print $1}'`
	restoreMAX=`${FSLDIR}/bin/fslstats ${restoreFLAIR} -R | awk '{print $2}'`



	if [ "${basedOn}" == "built-in" ]; then

		${FSLDIR}/bin/fslview ${restoreFLAIR} \
								-b ${restoreMIN},${restoreMAX} \
								${studyFolder}/customiseClassifier/subjects/${ID}/mri/extractedWMH/${ID}_predicted_WMH_clusters \
								-t 0.8 \
								-l "Red"

	elif [ "${basedOn}" == "rudeTraining" ]; then

		${FSLDIR}/bin/fslview ${restoreFLAIR} \
								-b ${restoreMIN},${restoreMAX} \
								${studyFolder}/customiseClassifier/subjects/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg${YesIndex} \
								-t 0.8 \
								-l "Red"
	fi


}

# $1 = studyFolder
# $2 = ID
# $3 = based on rude training or built-in results
# $4 = YesIndex+1
visualAdjustment_1Yes $1 $2 $3 $4