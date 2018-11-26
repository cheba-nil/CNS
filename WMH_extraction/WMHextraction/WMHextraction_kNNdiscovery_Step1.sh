#!/bin/bash


#######################
##    kNN Step 1     ##
#######################
## kNN preprocessing ##
#######################

. ${FSLDIR}/etc/fslconf/fsl.sh



echo "UBO Detector: preprocessing for UBO/WMH extraction (ID = $1) ..."


WMHextraction_kNNdiscovery_Step1(){

	## read the first input as ID
	ID="$1"

	## read the second input as subj_dir
	subj_dir=$2

	wm_0_8_mask=$3

	DARTELtemplate=$4


	## set directory
	seg0="${subj_dir}/${ID}/mri/preprocessing/FAST_nonBrainRemoved_wr${ID}_*_seg_0.nii*"
	seg1="${subj_dir}/${ID}/mri/preprocessing/FAST_nonBrainRemoved_wr${ID}_*_seg_1.nii*"
	seg2="${subj_dir}/${ID}/mri/preprocessing/FAST_nonBrainRemoved_wr${ID}_*_seg_2.nii*"

	csfSeg="${subj_dir}/${ID}/mri/preprocessing/wc3${ID}_*.nii*"

	dartelFLAIR=`ls ${subj_dir}/${ID}/mri/preprocessing/FAST_nonBrainRemoved_wr${ID}_*_restore.nii*`

    # need to create a threshold map ...
	if [ "${DARTELtemplate}" = "creating_template" ]; then
		${FSLDIR}/bin/fslmaths ${subj_dir}/cohort_probability_maps/cohort_WM_probability_map_thr0_8 \
								-bin \
								${subj_dir}/cohort_probability_maps/cohort_WM_probability_map_thr0_8_bin
	fi
		

	## create the folder to contain results
	if [ ! -d "${subj_dir}/${ID}/mri/extractedWMH" ]; then
		mkdir "${subj_dir}/${ID}/mri/extractedWMH"
	fi

	## create the folder to contain temp files for kNN
	if [ ! -d "${subj_dir}/${ID}/mri/extractedWMH/temp" ]; then
		mkdir "${subj_dir}/${ID}/mri/extractedWMH/temp"
	fi

	## create the folder to contain intermediate results
	if [ ! -d "${subj_dir}/${ID}/mri/kNN_intermediateOutput" ]; then
		mkdir "${subj_dir}/${ID}/mri/kNN_intermediateOutput"
	fi

	# nan in CSF is set to zero
	${FSLDIR}/bin/fslmaths ${csfSeg} -nan ${subj_dir}/${ID}/mri/kNN_intermediateOutput/zeroNan_wc3${ID}_t1CSF

	# CSF mask (thr = 0.8)
	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/kNN_intermediateOutput/zeroNan_wc3${ID}_t1CSF \
							-thr 0.8 \
							-bin \
							${subj_dir}/${ID}/mri/kNN_intermediateOutput/binarized_zeroNan_wc3${ID}_t1CSF

	
	# CSF masked FLAIR
	${FSLDIR}/bin/fslmaths ${dartelFLAIR} \
							-mas ${subj_dir}/${ID}/mri/kNN_intermediateOutput/binarized_zeroNan_wc3${ID}_t1CSF \
							${subj_dir}/${ID}/mri/kNN_intermediateOutput/CSFmasked_wr${ID}_dartelFLAIR

	
	

	###################################################
	## Thresholding with mean intensity within 80%WM ##
	###################################################

	${FSLDIR}/bin/fslmaths ${dartelFLAIR} \
							-mas ${wm_0_8_mask} \
							${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_FLAIR_in_WM0_8

	mean_flair_in_wm0_8=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_FLAIR_in_WM0_8 -M`

	wmthr=`bc <<< "1.1 * ${mean_flair_in_wm0_8}"`


	# apply the threshold to only the disconnectLR mask
	# ${FSLDIR}/bin/fslmaths ${dartelFLAIR} \
	# 						-mas ${CNSP_path}/Templates/DARTEL_other_templates/DARTEL_disconnectLR \
	# 						-uthr ${wmthr} \
	# 						-binv \
	# 						${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_FLAIR_thrWM0_8_mask

	# apply the threshold to the whole brain
	${FSLDIR}/bin/fslmaths ${dartelFLAIR} \
							-thr ${wmthr} \
							-bin \
							${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_FLAIR_thrWM0_8_mask


	# apply WM0.8 mask to seg012
	${FSLDIR}/bin/fslmaths ${seg0} \
							-mas ${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_FLAIR_thrWM0_8_mask\
							${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg0

	${FSLDIR}/bin/fslmaths ${seg1} \
							-mas ${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_FLAIR_thrWM0_8_mask\
							${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg1

	${FSLDIR}/bin/fslmaths ${seg2} \
							-mas ${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_FLAIR_thrWM0_8_mask\
							${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg2


	###########################################################################
	###                 Create accurate individual CSF mask                 ###
	###                            29/07/2016                               ###
	###########################################################################

	mean=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/kNN_intermediateOutput/CSFmasked_wr${ID}_dartelFLAIR -M`
	sd=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/kNN_intermediateOutput/CSFmasked_wr${ID}_dartelFLAIR -S`

	# echo "The mean intensity of the regions masked by individual rough_CSF_mask is ${mean} in ${ID}'s FLAIR, and SD is ${sd}."
	# echo "Now building a binarized accurate CSF mask using the mean + 0.8 SD (i.e. zero any voxel above this value)."
	thr=`bc <<< "${mean} + 0.8 * ${sd}"`

	${FSLDIR}/bin/fslmaths ${dartelFLAIR} \
							-uthr ${thr} \
							-binv \
							-mas ${dartelFLAIR} \
							${subj_dir}/${ID}/mri/kNN_intermediateOutput/inv_${ID}_dartelFLAIR_accurateCSFmask	


	#########################
	### Apply 0.8 WM mask ###
	#########################
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/kNN_intermediateOutput/inv_${ID}_dartelFLAIR_accurateCSFmask \
	# 					   -mas ${wm_0_8_mask} \
	# 					   ${subj_dir}/${ID}/mri/kNN_intermediateOutput/inv_${ID}_dartelFLAIR_accurateCSFmask


	
	###################################################
	####  Apply the accurate CSF mask to seg0,1,2, ####
	####  for kNN  				      			   ####
	###################################################
	
	## Only apply accurate CSF mask
	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg0 -mas \
						   ${subj_dir}/${ID}/mri/kNN_intermediateOutput/inv_${ID}_dartelFLAIR_accurateCSFmask \
			               ${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg0

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg1 -mas \
			               ${subj_dir}/${ID}/mri/kNN_intermediateOutput/inv_${ID}_dartelFLAIR_accurateCSFmask \
			               ${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg1

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg2 -mas \
						   ${subj_dir}/${ID}/mri/kNN_intermediateOutput/inv_${ID}_dartelFLAIR_accurateCSFmask \
						   ${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg2
	


	## normalise T1
	# echo "Conducting intensity homogeneity on T1 ..."
	NBTR_wT1=`ls ${subj_dir}/${ID}/mri/preprocessing/nonBrainRemoved_w${ID}_*`
	${FSLDIR}/bin/fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -g -B -o \
							${subj_dir}/${ID}/mri/kNN_intermediateOutput/${ID}_wT1_NBTR_FAST \
							${NBTR_wT1}


}


	
# invoke the function
# $1 = ID
# $2 = subj_dir
# $3 = wm_prob_thr
# $4 = template name

WMHextraction_kNNdiscovery_Step1 $1 $2 $3 $4
