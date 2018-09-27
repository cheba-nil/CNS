#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

getM0brainMask(){
	cGM=$1
	cWM=$2
	cCSF=$3
	ID=$4
	studyFolder=$5
	M0=$6

	if [ -d "${studyFolder}/subjects/${ID}/imgs4ASLtbx/temp_getM0brainMask" ]; then
		rm -fr ${studyFolder}/subjects/${ID}/imgs4ASLtbx/temp_getM0brainMask
	fi

	mkdir ${studyFolder}/subjects/${ID}/imgs4ASLtbx/temp_getM0brainMask


	# get T1 brain mask from c123
	fslmaths ${cGM} \
			 -add ${cWM} \
			 -add ${cCSF} \
			 -thr 0.3 \
			 -bin \
			 ${studyFolder}/subjects/${ID}/imgs4ASLtbx/temp_getM0brainMask/${ID}_T1brainmask


    # reverse T1 brain mask to ASL space with mtx
	flirt -in ${studyFolder}/subjects/${ID}/imgs4ASLtbx/temp_getM0brainMask/${ID}_T1brainmask \
			-ref ${M0} \
			-applyxfm \
			-init ${studyFolder}/subjects/${ID}/imgs4ASLtbx/temp_CNSPreverseRegWmxFSLflirt/ref2src_mtx.mat \
			-out ${studyFolder}/subjects/${ID}/imgs4ASLtbx/sr${ID}_M0brainmask

	fslmaths ${studyFolder}/subjects/${ID}/imgs4ASLtbx/sr${ID}_M0brainmask \
			 -thr 0.9 \
			 -bin \
			 ${studyFolder}/subjects/${ID}/imgs4ASLtbx/sr${ID}_M0brainmask

	gunzip ${studyFolder}/subjects/${ID}/imgs4ASLtbx/sr${ID}_M0brainmask.nii.gz
}

getM0brainMask $1 $2 $3 $4 $5 $6