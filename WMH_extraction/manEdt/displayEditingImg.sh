#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

dispEdtImg(){

	studyFolder=$1
	ID=$2
	ver=$3

	flairPath=`ls ${studyFolder}/originalImg/FLAIR/${ID}_*.nii*`
	flairFilename=`echo $(basename ${flairPath}) | awk -F'.' '{print $1}'`

	flairLow=`${FSLDIR}/bin/fslstats ${flairPath} -r | awk '{print $1}'`
	flairHi=`${FSLDIR}/bin/fslstats ${flairPath} -r | awk '{print $2}'`

	if [ "${ver}" = "old" ]; then
		${FSLDIR}/bin/fslview ${studyFolder}/subjects/${ID}/mri/preprocessing/wr${flairFilename} \
								-l Greyscale -b ${flairLow},${flairHi} \
								${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH \
								-l Yellow
	elif [ "${ver}" = "new" ]; then
		${FSLDIR}/bin/fslview_deprecated ${studyFolder}/subjects/${ID}/mri/preprocessing/wr${flairFilename} \
											-l Greyscale -b ${flairLow},${flairHi} \
											${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH \
											-l Yellow
	fi
}

dispEdtImg $1 $2 $3