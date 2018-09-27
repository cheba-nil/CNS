#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

calculateM0MeanWithMask(){
	M0=$1
	WMmask=$2
	CSFmask=$3
	studyFolder=$4
	ID=$5

	fslmaths ${M0} \
			 -mas ${WMmask} \
			 ${studyFolder}/subjects/${ID}/imgs4ASLtbx/intermediateOutput/${ID}_M0_WMmasked

	fslmaths ${M0} \
			 -mas ${CSFmask} \
			 ${studyFolder}/subjects/${ID}/imgs4ASLtbx/intermediateOutput/${ID}_M0_CSFmasked

	if [ -f "${studyFolder}/subjects/${ID}/imgs4ASLtbx/M0WMCSF.txt" ]; then
		rm -f ${studyFolder}/subjects/${ID}/imgs4ASLtbx/M0WMCSF.txt
	fi

	M0WM=`fslstats ${studyFolder}/subjects/${ID}/imgs4ASLtbx/intermediateOutput/${ID}_M0_WMmasked -M`
	M0CSF=`fslstats ${studyFolder}/subjects/${ID}/imgs4ASLtbx/intermediateOutput/${ID}_M0_CSFmasked -M`

	echo "M0_WM,M0_CSF" >> ${studyFolder}/subjects/${ID}/imgs4ASLtbx/M0WMCSF.txt
	echo "${M0WM},${M0CSF}" | sed 's/ //g' >> ${studyFolder}/subjects/${ID}/imgs4ASLtbx/M0WMCSF.txt
}

echo "Calculating M0 mean in WM and CSF ($5) ..."
calculateM0MeanWithMask $1 $2 $3 $4 $5