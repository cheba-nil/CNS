#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

thrProbMap(){
	output_folder=$1
	BIANCA_output_folder=${output_folder}/BIANCA_result
	thr=$2
	thr=0.${thr}

	echo "Using threshold = ${thr} to threshold prob map"

	for BoutProbMap in `ls ${BIANCA_output_folder}/*_BIANCA_output.nii.gz`
	do
		imageFilename=`echo "$(basename ${BoutProbMap})" | awk -F'.nii.gz' '{print $1}'`

		fslmaths ${BoutProbMap} \
								-thr ${thr} \
								-bin \
								${BIANCA_output_folder}/${imageFilename}_thr0_${2}
	done
}

thrProbMap $1 $2