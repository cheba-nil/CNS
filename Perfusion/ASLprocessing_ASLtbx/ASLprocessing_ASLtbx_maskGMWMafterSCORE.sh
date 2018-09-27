#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

maskGMWM(){
	ID=$1
	imgs4ASLtbx_folder=$2

	if [ -d "${imgs4ASLtbx_folder}/temp_maskGMWMafterSCORE" ]; then
		rm -fr ${imgs4ASLtbx_folder}/temp_maskGMWMafterSCORE
	fi
	mkdir ${imgs4ASLtbx_folder}/temp_maskGMWMafterSCORE

	cp ${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE/tiss_SCORE_cbf_* \
		${imgs4ASLtbx_folder}/temp_maskGMWMafterSCORE/.

	tissSCOREcbf=`ls ${imgs4ASLtbx_folder}/temp_maskGMWMafterSCORE/tiss_SCORE_cbf_*`
	tissSCOREcbf_filename=`echo $(basename "${tissSCOREcbf}") | awk -F'.' '{print $1}'`
	tissSCOREcbf_folder=$(dirname "${tissSCOREcbf}")

	# threshold GM/WM mask
	rbk_cGM=`ls ${imgs4ASLtbx_folder}/rbk_c1*.nii`
	rbk_cWM=`ls ${imgs4ASLtbx_folder}/rbk_c2*.nii`

	fslmaths ${rbk_cGM} \
			 -thr 0.9 \
			 -bin \
			 ${imgs4ASLtbx_folder}/temp_maskGMWMafterSCORE/GMmask		 

	fslmaths ${rbk_cWM} \
			 -thr 0.9 \
			 -bin \
			 ${imgs4ASLtbx_folder}/temp_maskGMWMafterSCORE/WMmask

	gmMask="${imgs4ASLtbx_folder}/temp_maskGMWMafterSCORE/GMmask.nii.gz"
	wmMask="${imgs4ASLtbx_folder}/temp_maskGMWMafterSCORE/WMmask.nii.gz"


	# mask GM/WM on CBF
	fslmaths ${tissSCOREcbf} \
			 -mas ${gmMask} \
			 ${tissSCOREcbf_folder}/${tissSCOREcbf_filename}_GM

	fslmaths ${tissSCOREcbf} \
			 -mas ${wmMask} \
			 ${tissSCOREcbf_folder}/${tissSCOREcbf_filename}_WM

	
}

maskGMWM $1 $2