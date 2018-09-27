#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

maskMNIatlas(){
	ID=$1
	imgs4ASLtbx_folder=$2

	ASLprocessing_ASLtbx_folder=$(dirname "$0")
	Perfusion_folder=$(dirname "${ASLprocessing_ASLtbx_folder}")
	CNSP_path=$(dirname "${Perfusion_folder}")

	orig_folder="$(dirname "${imgs4ASLtbx_folder}")/orig"

	if [ -d "${imgs4ASLtbx_folder}/temp_maskMNIatlas" ]; then
		rm -fr ${imgs4ASLtbx_folder}/temp_maskMNIatlas
	fi
	mkdir ${imgs4ASLtbx_folder}/temp_maskMNIatlas

	cp ${FSLDIR}/data/atlases/MNI/MNI-maxprob-thr50-2mm.nii.gz \
		${imgs4ASLtbx_folder}/temp_maskMNIatlas

	MNIspace_atlas="${imgs4ASLtbx_folder}/temp_maskMNIatlas/MNI-maxprob-thr50-2mm.nii.gz"
	T1="${orig_folder}/${ID}_T1.nii"
	T1_brainmask="${imgs4ASLtbx_folder}/temp_getM0brainMask/${ID}_T1brainmask.nii.gz"


	# ================== #
	# get T1 space atlas #
	# ================== #
	fslcpgeom ${T1} ${T1_brainmask} # to make the two imgs exactly the same vox size
									# otherwise a "not the same dimension" error pops up
									# ref: https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=ind1703&L=FSL&P=R64259&1=FSL&9=A&J=on&d=No+Match%3BMatch%3BMatches&z=4

	${CNSP_path}/Scripts/CNSP_reverse_warping_wMx_FSLfnirt.sh \
															  ${T1} \
															  ${T1_brainmask} \
															  ${MNIspace_atlas} \
															  nn \
															  0 \
															  0 \
															  6

	mv ${orig_folder}/MNI-maxprob-thr50-2mm_inverseXformed.nii.gz \
	   ${imgs4ASLtbx_folder}

	T1space_atlas="${imgs4ASLtbx_folder}/MNI-maxprob-thr50-2mm_inverseXformed.nii.gz"

	
	# ============ #
	# get T1 brain #
	# ============ #
	fslmaths ${T1} \
			 -mas ${T1_brainmask} \
			 ${imgs4ASLtbx_folder}/temp_maskMNIatlas/${ID}_T1brain

	T1_brain="${imgs4ASLtbx_folder}/temp_maskMNIatlas/${ID}_T1brain.nii.gz"


	# ================== #
	# get ASL mean brain #
	# ================== #
	fslmaths ${imgs4ASLtbx_folder}/rbk_c1${ID}_T1.nii \
			 -add ${imgs4ASLtbx_folder}/rbk_c2${ID}_T1.nii \
			 -add ${imgs4ASLtbx_folder}/rbk_c3${ID}_T1.nii \
			 -thr 0.3 \
			 -bin \
			 ${imgs4ASLtbx_folder}/ASL_brainmask

	asl_brainmask="${imgs4ASLtbx_folder}/ASL_brainmask.nii.gz"

	cp ${orig_folder}/mean${ID}_*ASL.nii \
		${imgs4ASLtbx_folder}

	ASLmean=`ls ${imgs4ASLtbx_folder}/mean${ID}_*ASL.nii`

	fslmaths ${ASLmean} \
			 -mas ${asl_brainmask} \
			 ${imgs4ASLtbx_folder}/${ID}_ASLmean_brain

	ASLmeanBrain="${imgs4ASLtbx_folder}/${ID}_ASLmean_brain.nii.gz"



	# ======================== #
	# bring atlas to ASL space #
	# ======================== #

	${CNSP_path}/Scripts/CNSP_reverse_registration_wMx_FSLflirt.sh \
																   ${T1_brain} \
																   ${ASLmeanBrain} \
																   ${T1space_atlas} \
																   ${imgs4ASLtbx_folder}/temp_maskMNIatlas \
																   nearestneighbour \
																   0 \
																   0 \
																   7

	mv ${imgs4ASLtbx_folder}/temp_maskMNIatlas/otherImg_in_srcImgSpace.nii.gz \
	   ${imgs4ASLtbx_folder}/temp_maskMNIatlas/ASLspace_atlas.nii.gz

	ASLspace_atlas="${imgs4ASLtbx_folder}/temp_maskMNIatlas/ASLspace_atlas.nii.gz"


	# =================== #
	# split to 3D atlases #
	# =================== #
	cp ${imgs4ASLtbx_folder}/temp_maskTissueAndOutlierRemovalAfterSCORE/tiss_SCORE_cbf_* \
	   ${imgs4ASLtbx_folder}/temp_maskMNIatlas/.

	tissSCOREcbf=`ls ${imgs4ASLtbx_folder}/temp_maskMNIatlas/tiss_SCORE_cbf_*`

	for i in {1..9}
	do
		fslmaths ${ASLspace_atlas} \
				 -thr ${i} \
				 -uthr ${i} \
				 -bin \
				 ${imgs4ASLtbx_folder}/temp_maskMNIatlas/ASLspace_atlas_${i}

		fslmaths ${tissSCOREcbf} \
				 -mas ${imgs4ASLtbx_folder}/temp_maskMNIatlas/ASLspace_atlas_${i} \
				 ${imgs4ASLtbx_folder}/temp_maskMNIatlas/tissSCOREcbf_atlas${i}
	done


	


}

maskMNIatlas $1 $2