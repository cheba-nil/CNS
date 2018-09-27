#!/bin/bash

postprocessing_globalMeas(){
	ID=$1
	indFolder=$2
	CNSP_path=$3
	spm12path=$4
	ASLtype=$5

	echo "Postprocessing ${ID} ..."

	curr_folder=$(dirname "$0")

	# get brain tissue mask and Jmod GM/WM masks
	${curr_folder}/ASLprocessing_FSL_getASLmeanAndBrainTissueMask.sh \
																	 ${ID} \
																	 ${indFolder} \
																	 ${CNSP_path} \
																	 ${spm12path} \
																	 ${ASLtype}

	# get Jmod GM/WM CBF
	${curr_folder}/ASLprocessing_FSL_getJmodGMWMcbf.sh \
													   ${ID} \
													   ${indFolder} \
													   ${CNSP_path}


	# get global CBF excl CSF
	nativeSpaceFolder="${indFolder}/${ID}_invKineticMdl_wT1/native_space"

	matlab -nodisplay -nosplash -nojvm -r "addpath ('${CNSP_path}/Scripts');\
										   meanInt=CNSP_getMeanIntensityWithinMask('${nativeSpaceFolder}/perfusion_calib.nii.gz',\
										   											'${indFolder}/ASLspace_brainTissueMask_thr7.nii.gz',\
										   											'write');\
										   exit" \
										   >> ${indFolder}/${ID}_logfile.txt

	mv ${nativeSpaceFolder}/meanInt.txt ${nativeSpaceFolder}/meanInt_global.txt
}

postprocessing_globalMeas $1 $2 $3 $4 $5