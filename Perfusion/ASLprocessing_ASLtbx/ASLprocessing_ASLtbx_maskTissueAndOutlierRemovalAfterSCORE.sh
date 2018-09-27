#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

maskAndOutlierRemoval(){
	ID=$1
	imgs4ASLtbx_folder=$2

	SCOREcbf=`ls ${imgs4ASLtbx_folder}/SCORE_cbf_*_4D*.nii`
	SCOREcbf_filename=`echo "$(basename "${SCOREcbf}")" | awk -F'.' '{print $1}'`
	SCOREcbf_folder=$(dirname "${SCOREcbf}")

	if [ -d "${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE" ]; then
		rm -fr ${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE
	fi
	mkdir ${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE

	cp ${SCOREcbf} ${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE/.

	SCOREcbf=`ls ${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE/SCORE_cbf_*_4D*.nii`

	rbk_cGM=`ls ${imgs4ASLtbx_folder}/rbk_c1*.nii`
	rbk_cWM=`ls ${imgs4ASLtbx_folder}/rbk_c2*.nii`


	# generate tissue mask
	fslmaths ${rbk_cGM} \
			 -add ${rbk_cWM} \
			 -thr 0.7 \
			 -bin \
			 ${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE/tissueMask

	tissue_mask="${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE/tissueMask.nii.gz"



	# mask SCORE_cbf with tissue mask
	fslmaths ${SCOREcbf} \
			 -mas ${tissue_mask} \
			 ${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE/tiss_${SCOREcbf_filename}

	tiss_SCOREcbf="${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE/tiss_${SCOREcbf_filename}.nii.gz"

	# further thresholding
	fslmaths ${tiss_SCOREcbf} \
			 -thr 0 \
			 -uthr 140 \
			 ${tiss_SCOREcbf}

	cp ${tiss_SCOREcbf} ${SCOREcbf_folder}

}

maskAndOutlierRemoval $1 $2