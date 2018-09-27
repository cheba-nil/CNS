#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

runBIANCA(){

	output_folder=$1
	query_subject_num=$2
	query_subject_ID=$3
	training_nums=$4

	bianca --singlefile=${output_folder}/BIANCA_masterfile.txt \
			--labelfeaturenum=4 \
			--brainmaskfeaturenum=1 \
			--querysubjectnum=${query_subject_num} \
			--trainingnums=${training_nums} \
			--featuresubset=1,2 \
			--matfeaturenum=3 \
			--trainingpts=2000 \
			--nonlespts=10000 \
			--selectpts=noborder \
			-o ${output_folder}/BIANCA_result/${query_subject_ID}_BIANCA_output \
			-v

}

runBIANCA $1 $2 $3 $4
