#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

BIANCA_masking(){
	output_folder=$1
	ID=$2
	rawFLAIR=$3
	thr=$4

	echo "Creating BIANCA mask for ${ID} ..."

	# run fsl_anat to generate warping field and CSF pve
	echo "Running fsl_anat for ${ID} ..."
	echo "This will take a while ..."
	fsl_anat -i ${output_folder}/rawT1/${ID}_* \
			-o ${output_folder}/T1_fsl_anat/${ID}_T1 \
			> ${output_folder}/T1_fsl_anat/${ID}_T1_fsl_anat_text_output_log.txt

	# Building BIANCA mask in T1 space
	# The generated BIANCA mask is saved in fsl_anat directory (.anat) !!!
	echo "Building BIANCA masks in T1 space for ${ID} ..."
	make_bianca_mask ${output_folder}/T1_fsl_anat/${ID}_T1.anat/T1_biascorr \
						${output_folder}/T1_fsl_anat/${ID}_T1.anat/T1_fast_pve_0 \
						${output_folder}/T1_fsl_anat/${ID}_T1.anat/MNI_to_T1_nonlin_field \
						1
	mv ${output_folder}/T1_fsl_anat/${ID}_T1.anat/T1_biascorr_bianca_mask.nii.gz \
		${output_folder}/BIANCA_mask/${ID}_bianca_mask_fslanatT1space.nii.gz



	# Register fsl_anat T1-space BIANCA mask to FLAIR space
	#
	# NOTE: The T1_biascorr.nii.gz after fsl_anat is in a different space
	#       from the raw T1 before fsl_anat. Therefore, the rawT1->rawFLAIR
	#       matrix cannot be used to bring T1_biascorr to FLAIR space
	
	# FLAIR --> fsl_anat T1_biascorr
	flirt -ref ${output_folder}/T1_fsl_anat/${ID}_T1.anat/T1_biascorr \
			-in ${rawFLAIR} \
			-out ${output_folder}/T1reg2FLAIR/${ID}_rawFLAIR_to_T1biascorr \
			-omat ${output_folder}/T1reg2FLAIR_mtx/${ID}_rawFLAIR_to_T1biascorr_mtx.mat \
			-searchrx 0 0 \
			-searchry 0 0 \
			-searchrz 0 0 \
			-dof 6

	# then invert matrix
	convert_xfm -omat ${output_folder}/T1reg2FLAIR_mtx/${ID}_T1biascorr_to_rawFLAIR_mtx.mat \
				-inverse ${output_folder}/T1reg2FLAIR_mtx/${ID}_rawFLAIR_to_T1biascorr_mtx.mat

	# apply inversed matrix
	flirt -in ${output_folder}/BIANCA_mask/${ID}_bianca_mask_fslanatT1space \
			-ref ${rawFLAIR} \
			-out ${output_folder}/BIANCA_mask/${ID}_bianca_mask_FLAIRspace \
			-init ${output_folder}/T1reg2FLAIR_mtx/${ID}_T1biascorr_to_rawFLAIR_mtx.mat \
			-applyxfm

	# threshold FLAIR-space BIANCA mask with 0.9
	fslmaths ${output_folder}/BIANCA_mask/${ID}_bianca_mask_FLAIRspace \
				-thr 0.9 \
				${output_folder}/BIANCA_mask/${ID}_bianca_mask_FLAIRspace_thr0_9

	# apply FLAIR-space BIANCA mask to BIANCA output (i.e. WMH segmentation)
	fslmaths ${output_folder}/BIANCA_result/${ID}_BIANCA_output_thr0_${thr} \
				-mas ${output_folder}/BIANCA_mask/${ID}_bianca_mask_FLAIRspace_thr0_9 \
				${output_folder}/BIANCA_result/${ID}_BIANCA_output_thr0_${thr}_masked
}

BIANCA_masking $1 $2 $3 $4