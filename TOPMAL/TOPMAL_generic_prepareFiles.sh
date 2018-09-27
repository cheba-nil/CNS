#!/bin/bash

TOPMAL_generic_prepareFiles(){
	studyFolder=$1
	ID=$2
	DARles_folder=$3

	if [ ! -d "${studyFolder}/subjects" ]; then
		mkdir ${studyFolder}/subjects
	fi

	if [ -d "${studyFolder}/subjects/${ID}" ]; then
		rm -fr ${studyFolder}/subjects/${ID}
	fi
	mkdir ${studyFolder}/subjects/${ID}
	mkdir ${studyFolder}/subjects/${ID}/mri
	mkdir ${studyFolder}/subjects/${ID}/mri/orig
	mkdir ${studyFolder}/subjects/${ID}/mri/TOPMAL


	cp ${DARles_folder}/${ID}_lesMask.nii \
	   ${studyFolder}/subjects/${ID}/mri/orig

	   
}

TOPMAL_generic_prepareFiles $1 $2 $3