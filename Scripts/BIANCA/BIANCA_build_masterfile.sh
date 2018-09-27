#!/bin/bash

build_masterfile(){

	output_folder=$1
	labelledMask_folder=$2
	IDlist=$3
	rawFLAIR_folder=${output_folder}/rawFLAIR

	if [ -f "${output_folder}/BIANCA_masterfile.txt" ]; then
		rm -f ${output_folder}/BIANCA_masterfile.txt
	fi

	while read ID
	do
		FLAIRbrain=${rawFLAIR_folder}/${ID}_FLAIR_brain.nii.gz
		T1_FLAIRspace=${rawFLAIR_folder}/${ID}_T1_FLAIRspace_brain.nii.gz
		# cout=${output_folder}/FLAIRspace2MNI/${ID}_fnirt2MNI_cout.nii.gz
		flair2mni_flirt_mtx=${output_folder}/FLAIRspace2MNI/${ID}_flirt2MNI_mtx.mat

		if [ -f "${labelledMask_folder}/${ID}_labelledMask.nii.gz" ]; then
			labelledMask=${labelledMask_folder}/${ID}_labelledMask.nii.gz
		else
			labelledMask="noLabelledMask"
		fi
		
		echo "${FLAIRbrain}	${T1_FLAIRspace}	${flair2mni_flirt_mtx}	${labelledMask}" >> ${output_folder}/BIANCA_masterfile.txt

	done < ${IDlist}

}

build_masterfile $1 $2 $3