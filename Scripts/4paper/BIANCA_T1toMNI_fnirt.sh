#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

T1toMNI_fnirt(){
	T1brain_FLAIRspace=$1
	output_folder=$2
	ID=$3

	# need to flirt first
	flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain \
			-in ${T1brain_FLAIRspace} \
			-omat ${output_folder}/FLAIRspace2MNI/${ID}_flirt2MNI_mtx.mat \


	## no need for fnirt, bianca only needs native to MNI FLIRT
	#
	# fnirt ${T1} --in=${T1brain_FLAIRspace} \
	# 			--aff=${output_folder}/FLAIRspace2MNI/${ID}_flirt2MNI_mtx.mat \
	# 			--config=T1_2_MNI152_2mm \
	# 			--cout=${output_folder}/FLAIRspace2MNI/${ID}_fnirt2MNI_cout
}

T1toMNI_fnirt $1 $2 $3