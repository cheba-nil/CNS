#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

getJmodGMWMcbf(){
	ID=$1
	indFolder=$2
	CNSP_path=$3

	pvcorr_folder="${indFolder}/${ID}_invKineticMdl_wT1/native_space/pvcorr"

	# get Jmod GM/WM CBF maps
	# Note that the number get from fslstats -M may be different 
	# from pipeline output. As pipeline calculates mean in GM/WM
	# mask, therefore including voxels with intensity of 0
	fslmaths ${pvcorr_folder}/perfusion_wm_calib_masked \
			 -mas ${indFolder}/ASLspace_WMmask_thr7 \
			 ${pvcorr_folder}/perfusion_calib_WM_Jmod

	fslmaths ${pvcorr_folder}/perfusion_calib_masked \
			 -mas ${indFolder}/ASLspace_GMmask_thr7 \
			 ${pvcorr_folder}/perfusion_calib_GM_Jmod


	# get Jmod GM/WM CBF
	nativeSpaceFolder="${indFolder}/${ID}_invKineticMdl_wT1/native_space"

	matlab -nodisplay -nosplash -nojvm -r "addpath ('${CNSP_path}/Scripts');\
										   meanInt=CNSP_getMeanIntensityWithinMask('${pvcorr_folder}/perfusion_wm_calib_masked.nii.gz',\
										   											'${indFolder}/ASLspace_WMmask_thr7.nii.gz',\
										   											'write');\
										   exit" \
										   >> ${indFolder}/${ID}_logfile.txt

	mv ${pvcorr_folder}/meanInt.txt ${pvcorr_folder}/meanInt_WM.txt


	matlab -nodisplay -nosplash -nojvm -r "addpath ('${CNSP_path}/Scripts');\
										   meanInt=CNSP_getMeanIntensityWithinMask('${pvcorr_folder}/perfusion_calib_masked.nii.gz',\
										   											'${indFolder}/ASLspace_GMmask_thr7.nii.gz',\
										   											'write');\
										   exit" \
										   >> ${indFolder}/${ID}_logfile.txt
										   
	mv ${pvcorr_folder}/meanInt.txt ${pvcorr_folder}/meanInt_GM.txt
}

getJmodGMWMcbf $1 $2 $3