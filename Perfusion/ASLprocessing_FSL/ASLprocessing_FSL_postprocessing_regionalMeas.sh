#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

postprocessing_regionalMeas(){

	ID=$1
	indFolder=$2
	CNSP_path=$3
	ASLtype=$4


	curr_folder=$(dirname "$0")

	# get ASL space MNI atlas
	echo "Warping MNI atlas to T1 space (ID = ${ID}) ..."
	${curr_folder}/ASLprocessing_FSL_getASLspaceAtlas.sh \
														${ID} \
														${indFolder} \
														${CNSP_path} \
														${ASLtype}


	# extract regional measures
	echo "Extracting regional CBF (ID = ${ID}) ..."
	${curr_folder}/ASLprocessing_FSL_getRegionalMeas.sh \
													    ${ID} \
													    ${indFolder}

}

postprocessing_regionalMeas $1 $2 $3 $4