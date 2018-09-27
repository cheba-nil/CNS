#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

getRegionalMeas(){
	ID=$1
	indFolder=$2

	curr_folder=$(dirname "$0")

	ASLspaceAtlas="${indFolder}/Atlas/MNI-maxprob-thr50-2mm_ASLspace.nii.gz"


	if [ -d "${indFolder}/${ID}_invKineticMdl_wT1/native_space/pvcorr/regionalMeas_Jmod" ]; then
		rm -fr ${indFolder}/${ID}_invKineticMdl_wT1/native_space/pvcorr/regionalMeas_Jmod
	fi
	mkdir ${indFolder}/${ID}_invKineticMdl_wT1/native_space/pvcorr/regionalMeas_Jmod
	regionalMeasJmod_folder="${indFolder}/${ID}_invKineticMdl_wT1/native_space/pvcorr/regionalMeas_Jmod"
	pvcorr_folder="${indFolder}/${ID}_invKineticMdl_wT1/native_space/pvcorr"

	if [ -d "${regionalMeasJmod_folder}/regionalMeas.txt" ]; then
		rm -f ${regionalMeasJmod_folder}/regionalMeas.txt
	fi

	for i in {1..9}
	do
		# split atlas to individual atlases
		fslmaths ${ASLspaceAtlas} \
				 -thr $i \
				 -uthr $i \
				 -bin \
				 ${indFolder}/Atlas/MNI-maxprob-thr50-2mm_ASLspace_${i}


		# mask pvcorr Jmod GM CBF map
		fslmaths ${pvcorr_folder}/perfusion_calib_GM_Jmod \
				 -mas ${indFolder}/Atlas/MNI-maxprob-thr50-2mm_ASLspace_${i} \
				 ${regionalMeasJmod_folder}/perfusion_calib_GM_Jmod_MNIatlas-${i}

		# extract regional CBF
		regionalMeas=`fslstats ${regionalMeasJmod_folder}/perfusion_calib_GM_Jmod_MNIatlas-${i} -M`
		structure=`grep -w "MS${i}" ${curr_folder}/MNI_structural_atlas_LUT.txt | awk '{print $2}'`
		echo "${structure}	${regionalMeas}" >> ${regionalMeasJmod_folder}/regionalMeas.txt
	done
}

getRegionalMeas $1 $2