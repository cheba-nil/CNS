#!/bin/bash


################################
##          kNN Step 3        ##
################################
## postprocessing and cleanup ##
################################

. ${FSLDIR}/etc/fslconf/fsl.sh

WMHextraction_kNNdiscovery_Step3(){

	## read the first input as ID
	ID="$1"
	echo "UBO Detector: Segmenting WMH into regions (ID = ${ID}) ..."

	## read the second input as subj_dir
	subj_dir=$2
	studyFolder=$(dirname $subj_dir)

	## pipeline path
	pipelinePath=$3

	## PVWMH magnitude
	PVmag=$4

	## Probability threshold
	probThr_str=`echo $5 | sed 's/\./_/g'`
	# echo $probThr_str
	# probThr_str=`echo $(printf '%1.2f' $5) | sed 's/\./_/g'`

	# change predicted_WMH_clusters_ProbThr0_5.nii to predicted_WMH_clusters_ProbThr0_5.nii.gz
	# change ProbMap.nii to ProbMap.nii.gz
	# if [ -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_LablMap.nii.gz ]; then
	# 	rm -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_LablMap.nii.gz
	# fi
	# if [ -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii.gz ]; then
	# 	rm -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii.gz
	# fi
	# if [ -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_refinementKNN.nii.gz ]; then
	# 	rm -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_refinementKNN.nii.gz
	# fi
	# if [ -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_Prob${probThr_str}.nii.gz ]; then
	# 	rm -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_Prob${probThr_str}.nii.gz
	# fi

	# # echo "--== gzip ==--"
	# if [ -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_LablMap.nii ]; then
	# 	${FSLDIR}/bin/fslchfiletype NIFTI_GZ ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_LablMap.nii
	# fi
	# if [ -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii ]; then
	# 	${FSLDIR}/bin/fslchfiletype NIFTI_GZ ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii
	# fi
	# if [ -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_refinementKNN.nii ]; then
	# 	${FSLDIR}/bin/fslchfiletype NIFTI_GZ ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_refinementKNN.nii
	# fi
	# if [ -f ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_Prob${probThr_str}.nii ]; then
	# 	${FSLDIR}/bin/fslchfiletype NIFTI_GZ ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_Prob${probThr_str}.nii
	# fi

	# # smooth the probability map by 5 mm
	# # echo "--== smooth prob map ==--"
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap \
	# 						-kernel gauss 1.27399 -fmean \
	# 						${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap_FWMH3mmSmooth

	# # apply probability threshold
	# # ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap \
	# # 						-thr ${probThr_num} \
	# # 						-bin \
	# # 						${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbThr${probThr_str}



	# ## replace the header of extracted WMH with restore FLAIR (MATLAB generated nii's are 1*1*1),
	# ## and swap orientation
	# # echo "--== swap orientation ==--"
	# restoreFLAIR=`ls ${subj_dir}/${ID}/mri/preprocessing/FAST_nonBrainRemoved_wr${ID}*_restore*`
	# ${FSLDIR}/bin/fslhd -x ${restoreFLAIR} > ${subj_dir}/${ID}/mri/extractedWMH/restore_hdr.xml

	# # ${FSLDIR}/bin/fslcreatehd ${subj_dir}/${ID}/mri/extractedWMH/restore_hdr.xml ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_LablMap
	# ${FSLDIR}/bin/fslcreatehd ${subj_dir}/${ID}/mri/extractedWMH/restore_hdr.xml ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap
	# # ${FSLDIR}/bin/fslcreatehd ${subj_dir}/${ID}/mri/extractedWMH/restore_hdr.xml ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_refinementKNN
	# ${FSLDIR}/bin/fslcreatehd ${subj_dir}/${ID}/mri/extractedWMH/restore_hdr.xml ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_Prob${probThr_str}

	# # ${FSLDIR}/bin/fslorient -swaporient ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_LablMap
	# ${FSLDIR}/bin/fslorient -swaporient ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap
	# # ${FSLDIR}/bin/fslorient -swaporient ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_refinementKNN
	# ${FSLDIR}/bin/fslorient -swaporient ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_Prob${probThr_str}

	# rm -f ${subj_dir}/${ID}/mri/extractedWMH/restore_hdr.xml




	# ################################################
	# ###   distinguish peri-ventricle from deep   ###
	# ###   also segment according to lobes        ###
	# ################################################

	# # before-refinement image as final WMH (fslmaths does nothing but duplicate)
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_Prob${probThr_str} \
	# 						${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_Prob${probThr_str}_refined \
	# 						${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_refined

	# build periventricle mask
	${FSLDIR}/bin/fslmaths \
		$(dirname ${pipelinePath})/Templates/DARTEL_ventricle_distance_map/DARTEL_ventricle_distance_map \
		 -uthr ${PVmag} \
		 -bin \
		 -fillh \
		 ${subj_dir}/${ID}/mri/extractedWMH/temp/periventricle_mask_${PVmag}


	# apply periventricle mask to predicted WMH clusters
	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH \
		 -mas ${subj_dir}/${ID}/mri/extractedWMH/temp/periventricle_mask_${PVmag} \
		 -bin \
		 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_PVWMH

	# echo "${ID}'s PVWMH has been segmented!"




	# the rest is deep WMH
	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH \
		 -bin \
		 -sub ${subj_dir}/${ID}/mri/extractedWMH/${ID}_PVWMH \
		 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH

	# echo "${ID}'s DWMH has been segmented!"


	# folder for lobar and arterial segmentation
	if [ -d "${subj_dir}/${ID}/mri/extractedWMH/lobarWMH" ]; then
		rm -fr ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH
	fi

	if [ -d "${subj_dir}/${ID}/mri/extractedWMH/arterialWMH" ]; then
		rm -fr ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH
	fi

	# segment nonPVWMH into lobes, cerebellum, and brainstem WMH
	# all in one image
	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH \
							-mul $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_lobar_template \
							${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar

	# ${FSLDIR}/bin/fslmaths  ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
	# 						-bin \
	# 						-mul -1 \
	# 						-add ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH \
	# 						${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_unidentified_lobarWMH



	# segment WMH into arterial territories
	# all in one image
	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH \
							-bin \
							-mul $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_arterial_template \
							${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial

	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
	# 						-bin \
	# 						-mul -1 \
	# 						-add ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH \
	# 						${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_unidentified_arterialWMH


	# # segment DWMH into lobes
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Lfrontal_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Lfrontal

	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Rfrontal_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Rfrontal

	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Ltemporal_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Ltemporal
	
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Rtemporal_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Rtemporal

	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Lparietal_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Lparietal
	
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Rparietal_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Rparietal

	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Loccipital_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Loccipital
	
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Roccipital_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Roccipital


	# # cerebellum and brainstem WMH
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Lcerebellum_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Lcerebellum
	
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Rcerebellum_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Rcerebellum

	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH \
	# 	 -mas $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_Brainstem_template \
	# 	 ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH_Brainstem






	# Generate image for each lobar segment
	
	mkdir ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 7 \
							-uthr 7 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Lfrontal_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 6 \
							-uthr 6 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rfrontal_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 4 \
							-uthr 4 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Ltemporal_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 5 \
							-uthr 5 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rtemporal_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 17 \
							-uthr 17 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Lparietal_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 16 \
							-uthr 16 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rparietal_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 12 \
							-uthr 12 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Loccipital_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 11 \
							-uthr 11 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Roccipital_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 2 \
							-uthr 2 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Lcerebellum_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 1 \
							-uthr 1 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rcerebellum_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_nonPVWMH_lobar \
							-thr 3 \
							-uthr 3 \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Brainstem_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Lfrontal_WMH -add \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rfrontal_WMH -add \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Ltemporal_WMH -add \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rtemporal_WMH -add \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Lparietal_WMH -add \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rparietal_WMH -add \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Loccipital_WMH -add \
							${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Roccipital_WMH \
							${subj_dir}/${ID}/mri/extractedWMH/${ID}_DWMH


	# generate arterial segments
	mkdir ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 1 \
							-uthr 1 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rAAH_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 2 \
							-uthr 2 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lAAH_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 3 \
							-uthr 3 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rMAH_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 6 \
							-uthr 6 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lMAH_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 13 \
							-uthr 13 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rAAML_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 14 \
							-uthr 14 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lAAML_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 7 \
							-uthr 7 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rAAC_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 8 \
							-uthr 8 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lAAC_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 9 \
							-uthr 9 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rMALL_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 10 \
							-uthr 10 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lMALL_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 11 \
							-uthr 11 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rPATMP_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 12 \
							-uthr 12 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lPATMP_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 4 \
							-uthr 4 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rPAH_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 5 \
							-uthr 5 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lPAH_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 15 \
							-uthr 15 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rPAC_WMH

	${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_arterial \
							-thr 16 \
							-uthr 16 \
							${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lPAC_WMH





	### --------------------------------------
	### Write WMH volumetric stats to textfile
	### --------------------------------------

	echo "UBO Detector: calculating WMH volumes (ID = ${ID})..."

	if [ ! -d "${subj_dir}/${ID}/stats" ]; then
		mkdir ${subj_dir}/${ID}/stats
	fi

	if [ -f "${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt" ]; then
		rm -f ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	fi

	# --------------------------------------------------
	# No. of WMH clusters in lobar segments and globally
	# --------------------------------------------------
	No_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH -V | awk '{print $1}'`
	No_PVWMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/${ID}_PVWMH -V | awk '{print $1}'`
	# No_DWMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_DWMH -V | awk '{print $1}'` # DWMH does not include cerebellum and brainstem!

	No_Lfrontal_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Lfrontal_WMH -V | awk '{print $1}'`
	No_Rfrontal_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rfrontal_WMH -V | awk '{print $1}'`
	No_Ltemporal_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Ltemporal_WMH -V | awk '{print $1}'`
	No_Rtemporal_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rtemporal_WMH -V | awk '{print $1}'`
	No_Lparietal_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Lparietal_WMH -V | awk '{print $1}'`
	No_Rparietal_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rparietal_WMH -V | awk '{print $1}'`
	No_Loccipital_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Loccipital_WMH -V | awk '{print $1}'`
	No_Roccipital_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Roccipital_WMH -V | awk '{print $1}'`
	No_Lcerebellum_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Lcerebellum_WMH -V | awk '{print $1}'`
	No_Rcerebellum_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Rcerebellum_WMH -V | awk '{print $1}'`
	No_Brainstem_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_Brainstem_WMH -V | awk '{print $1}'`
	# No_unidentified_lobarWMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_unidentified_lobarWMH -V | awk '{print $1}'`
	No_DWMHclusters=`bc <<< "${No_Lfrontal_WMHclusters} + \
				 ${No_Rfrontal_WMHclusters} + \
				 ${No_Ltemporal_WMHclusters} + \
				 ${No_Rtemporal_WMHclusters} + \
				 ${No_Lparietal_WMHclusters} + \
				 ${No_Rparietal_WMHclusters} + \
				 ${No_Loccipital_WMHclusters} + \
				 ${No_Roccipital_WMHclusters}"`


	# ----------------------------------------
	# No. of WMH clusters in arterial segments
	# ----------------------------------------
	No_rAAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rAAH_WMH -V | awk '{print $1}'`
	No_lAAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lAAH_WMH -V | awk '{print $1}'`
	No_rMAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rMAH_WMH -V | awk '{print $1}'`
	No_lMAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lMAH_WMH -V | awk '{print $1}'`
	No_rAAML_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rAAML_WMH -V | awk '{print $1}'`
	No_lAAML_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lAAML_WMH -V | awk '{print $1}'`
	No_rAAC_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rAAC_WMH -V | awk '{print $1}'`
	No_lAAC_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lAAC_WMH -V | awk '{print $1}'`
	No_rMALL_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rMALL_WMH -V | awk '{print $1}'`
	No_lMALL_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lMALL_WMH -V | awk '{print $1}'`
	No_rPATMP_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rPATMP_WMH -V | awk '{print $1}'`
	No_lPATMP_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lPATMP_WMH -V | awk '{print $1}'`
	No_rPAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rPAH_WMH -V | awk '{print $1}'`
	No_lPAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lPAH_WMH -V | awk '{print $1}'`
	No_rPAC_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rPAC_WMH -V | awk '{print $1}'`
	No_lPAC_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lPAC_WMH -V | awk '{print $1}'`
	


	# -----------------------------
	# Vol. of WMH in lobar segments
	# -----------------------------
	## Volume can also be achieved through fslstats XXX.nii -V | awk '{print $2}'
	Vol_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_WMHclusters}"`
	Vol_PVWMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_PVWMHclusters}"`
	Vol_DWMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_DWMHclusters}"`

	Vol_Lfrontal_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Lfrontal_WMHclusters}"`
	Vol_Rfrontal_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Rfrontal_WMHclusters}"`
	Vol_Ltemporal_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Ltemporal_WMHclusters}"`
	Vol_Rtemporal_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Rtemporal_WMHclusters}"`
	Vol_Lparietal_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Lparietal_WMHclusters}"`
	Vol_Rparietal_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Rparietal_WMHclusters}"`
	Vol_Loccipital_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Loccipital_WMHclusters}"`
	Vol_Roccipital_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Roccipital_WMHclusters}"`
	Vol_Lcerebellum_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Lcerebellum_WMHclusters}"`
	Vol_Rcerebellum_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Rcerebellum_WMHclusters}"`
	Vol_Brainstem_WMHclusters=`bc <<< "1.5 * 1.5 * 1.5 * ${No_Brainstem_WMHclusters}"`

	# Vol_unidentified_lobarWMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/lobarWMH/${ID}_unidentified_lobarWMH -V | awk '{print $2}'`



	# --------------------------------
	# Vol. of WMH in arterial segments
	# --------------------------------
	Vol_rAAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rAAH_WMH -V | awk '{print $2}'`
	Vol_lAAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lAAH_WMH -V | awk '{print $2}'`
	Vol_rMAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rMAH_WMH -V | awk '{print $2}'`
	Vol_lMAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lMAH_WMH -V | awk '{print $2}'`
	Vol_rAAML_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rAAML_WMH -V | awk '{print $2}'`
	Vol_lAAML_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lAAML_WMH -V | awk '{print $2}'`
	Vol_rAAC_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rAAC_WMH -V | awk '{print $2}'`
	Vol_lAAC_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lAAC_WMH -V | awk '{print $2}'`
	Vol_rMALL_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rMALL_WMH -V | awk '{print $2}'`
	Vol_lMALL_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lMALL_WMH -V | awk '{print $2}'`
	Vol_rPATMP_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rPATMP_WMH -V | awk '{print $2}'`
	Vol_lPATMP_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lPATMP_WMH -V | awk '{print $2}'`
	Vol_rPAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rPAH_WMH -V | awk '{print $2}'`
	Vol_lPAH_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lPAH_WMH -V | awk '{print $2}'`
	Vol_rPAC_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_rPAC_WMH -V | awk '{print $2}'`
	Vol_lPAC_WMHclusters=`${FSLDIR}/bin/fslstats ${subj_dir}/${ID}/mri/extractedWMH/arterialWMH/${ID}_lPAC_WMH -V | awk '{print $2}'`


	# -----------------------
	# Write to ID_WMH_vol.txt
	# -----------------------
	echo "UBO Detector: writing WMH volumetrics to text file (ID = ${ID})..."

	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	date >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "WMH Volumetric Measurements" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "==================== Global measures ===========================" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_total_WMH_voxels	${No_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_PVWMH_voxels	${No_PVWMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_DWMH_voxels	${No_DWMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_total_WMH_clusters_in_mm	${Vol_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_PVWMH_clusters_in_mm	${Vol_PVWMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_DWMH_clusters_in_mm	${Vol_DWMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "================================================================" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "===================== Lobar volumetrics ===========================" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Lfrontal_WMH_voxels	${No_Lfrontal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Rfrontal_WMH_voxels	${No_Rfrontal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Ltemporal_WMH_voxels	${No_Ltemporal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Rtemporal_WMH_voxels	${No_Rtemporal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Lparietal_WMH_voxels	${No_Lparietal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Rparietal_WMH_voxels	${No_Rparietal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Loccipital_WMH_voxels	${No_Loccipital_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Roccipital_WMH_voxels	${No_Roccipital_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Lcerebellum_WMH_voxels	${No_Lcerebellum_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Rcerebellum_WMH_voxels	${No_Rcerebellum_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_Brainstem_WMH_voxels	${No_Brainstem_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	# echo "No_of_unidentified_WMH_voxels	${No_unidentified_lobarWMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Lfrontal_WMH_clusters_in_mm	${Vol_Lfrontal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Rfrontal_WMH_clusters_in_mm	${Vol_Rfrontal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Ltemporal_WMH_clusters_in_mm	${Vol_Ltemporal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Rtemporal_WMH_clusters_in_mm	${Vol_Rtemporal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Lparietal_WMH_clusters_in_mm	${Vol_Lparietal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Rparietal_WMH_clusters_in_mm	${Vol_Rparietal_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Loccipital_WMH_clusters_in_mm	${Vol_Loccipital_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Roccipital_WMH_clusters_in_mm	${Vol_Roccipital_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Lcerebellum_WMH_clusters_in_mm	${Vol_Lcerebellum_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Rcerebellum_WMH_clusters_in_mm	${Vol_Rcerebellum_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_Brainstem_WMH_clusters_in_mm	${Vol_Brainstem_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	# echo "Vol_of_unidentified_WMH_clusters_in_mm	${Vol_unidentified_lobarWMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "================================================================" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "=====================  Arterial volumetrics ===========================" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_rAAH_WMH_voxels	${No_rAAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_lAAH_WMH_voxels	${No_lAAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_rMAH_WMH_voxels	${No_rMAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_lMAH_WMH_voxels	${No_lMAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_rAAML_WMH_voxels	${No_rAAML_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_lAAML_WMH_voxels	${No_lAAML_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_rAAC_WMH_voxels	${No_rAAC_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_lAAC_WMH_voxels	${No_lAAC_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_rMALL_WMH_voxels	${No_rMALL_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_lMALL_WMH_voxels	${No_lMALL_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_rPATMP_WMH_voxels	${No_rPATMP_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_lPATMP_WMH_voxels	${No_lPATMP_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_rPAH_WMH_voxels	${No_rPAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_lPAH_WMH_voxels	${No_lPAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_rPAC_WMH_voxels	${No_rPAC_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "No_of_lPAC_WMH_voxels	${No_lPAC_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_rAAH_WMH_clusters_in_mm	${Vol_rAAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_lAAH_WMH_clusters_in_mm	${Vol_lAAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_rMAH_WMH_clusters_in_mm	${Vol_rMAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_lMAH_WMH_clusters_in_mm	${Vol_lMAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_rAAML_WMH_clusters_in_mm	${Vol_rAAML_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_lAAML_WMH_clusters_in_mm	${Vol_lAAML_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_rAAC_WMH_clusters_in_mm	${Vol_rAAC_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_lAAC_WMH_clusters_in_mm	${Vol_lAAC_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_rMALL_WMH_clusters_in_mm	${Vol_rMALL_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_lMALL_WMH_clusters_in_mm	${Vol_lMALL_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_rPATMP_WMH_clusters_in_mm	${Vol_rPATMP_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_lPATMP_WMH_clusters_in_mm	${Vol_lPATMP_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_rPAH_WMH_clusters_in_mm	${Vol_rPAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_lPAH_WMH_clusters_in_mm	${Vol_lPAH_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_rPAC_WMH_clusters_in_mm	${Vol_rPAC_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "Vol_of_lPAC_WMH_clusters_in_mm	${Vol_lPAC_WMHclusters}" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	echo "================================================================" >> ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt
	


















	### --------------------
	### Count WMH incidences
	### --------------------

	echo "UBO Detector: counting WMH incidences (ID = ${ID})..."
	punctuateClusterSize=3
	focalClusterSize=9
	mediumClusterSize=15
	# confluent cluster size is above 15 voxels


	flairImg=`ls ${studyFolder}/originalImg/FLAIR/${ID}_*.nii`
	flair_filename=`echo $(basename ${flairImg}) | awk -F'.' '{print $1}'`

	# generate WMH masked FLAIR image
	${FSLDIR}/bin/fslmaths ${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH \
							-mas $(dirname ${pipelinePath})/Templates/DARTEL_GM_WM_CSF_prob_maps/65to75/DARTEL_WM_prob_map_thr0_8_bin \
							-mul ${studyFolder}/subjects/${ID}/mri/preprocessing/wr${flair_filename} \
							-nan \
							-thr 0 \
							${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR


	# merge PVWMH mask with lobar template
	${FSLDIR}/bin/fslmaths ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/periventricle_mask_${PVmag} \
							-bin \
							-mul 20 \
							${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/periventricle_mask_${PVmag}_mul20

	${FSLDIR}/bin/fslmaths ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/periventricle_mask_${PVmag} \
							-binv \
							-mul $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_lobar_template \
							-add ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/periventricle_mask_${PVmag}_mul20 \
							${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/lobar_map_with_PVmag${PVmag}_periventricle

	# min of WMH masked FLAIR
	WMHonFLAIR_min=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR -l 0 -R | awk '{print $1}'`

	# clusterise
	${FSLDIR}/bin/cluster -i ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR \
							-t ${WMHonFLAIR_min} \
							--connectivity=26 \
							--oindex=${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_index \
							> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary.txt

	# generate ROI with each COG, get corresponding intensity on lobar mask
	if [ -f "${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt" ]; then
		rm -f ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt
	fi

	N_Lfrontal_cluster=0
	N_Lfrontal_cluster_punctuate=0
	N_Lfrontal_cluster_focal=0
	N_Lfrontal_cluster_medium=0
	N_Lfrontal_cluster_confluent=0

	N_Rfrontal_cluster=0
	N_Rfrontal_cluster_punctuate=0
	N_Rfrontal_cluster_focal=0
	N_Rfrontal_cluster_medium=0
	N_Rfrontal_cluster_confluent=0

	N_Ltemporal_cluster=0
	N_Ltemporal_cluster_punctuate=0
	N_Ltemporal_cluster_focal=0
	N_Ltemporal_cluster_medium=0
	N_Ltemporal_cluster_confluent=0

	N_Rtemporal_cluster=0
	N_Rtemporal_cluster_punctuate=0
	N_Rtemporal_cluster_focal=0
	N_Rtemporal_cluster_medium=0
	N_Rtemporal_cluster_confluent=0

	N_Lparietal_cluster=0
	N_Lparietal_cluster_punctuate=0
	N_Lparietal_cluster_focal=0
	N_Lparietal_cluster_medium=0
	N_Lparietal_cluster_confluent=0

	N_Rparietal_cluster=0
	N_Rparietal_cluster_punctuate=0
	N_Rparietal_cluster_focal=0
	N_Rparietal_cluster_medium=0
	N_Rparietal_cluster_confluent=0

	N_Loccipital_cluster=0
	N_Loccipital_cluster_punctuate=0
	N_Loccipital_cluster_focal=0
	N_Loccipital_cluster_medium=0
	N_Loccipital_cluster_confluent=0

	N_Roccipital_cluster=0
	N_Roccipital_cluster_punctuate=0
	N_Roccipital_cluster_focal=0
	N_Roccipital_cluster_medium=0
	N_Roccipital_cluster_confluent=0

	N_Lcerebellum_cluster=0
	N_Lcerebellum_cluster_punctuate=0
	N_Lcerebellum_cluster_focal=0
	N_Lcerebellum_cluster_medium=0
	N_Lcerebellum_cluster_confluent=0

	N_Rcerebellum_cluster=0
	N_Rcerebellum_cluster_punctuate=0
	N_Rcerebellum_cluster_focal=0
	N_Rcerebellum_cluster_medium=0
	N_Rcerebellum_cluster_confluent=0

	N_Brainstem_cluster=0
	N_Brainstem_cluster_punctuate=0
	N_Brainstem_cluster_focal=0
	N_Brainstem_cluster_medium=0
	N_Brainstem_cluster_confluent=0

	N_Periventricle_cluster=0
	N_Periventricle_cluster_punctuate=0
	N_Periventricle_cluster_focal=0
	N_Periventricle_cluster_medium=0
	N_Periventricle_cluster_confluent=0	

	N_rAAH_cluster=0
	N_rAAH_cluster_punctuate=0
	N_rAAH_cluster_focal=0
	N_rAAH_cluster_medium=0
	N_rAAH_cluster_confluent=0

	N_lAAH_cluster=0
	N_lAAH_cluster_punctuate=0
	N_lAAH_cluster_focal=0
	N_lAAH_cluster_medium=0
	N_lAAH_cluster_confluent=0

	N_rMAH_cluster=0
	N_rMAH_cluster_punctuate=0
	N_rMAH_cluster_focal=0
	N_rMAH_cluster_medium=0
	N_rMAH_cluster_confluent=0

	N_lMAH_cluster=0
	N_lMAH_cluster_punctuate=0
	N_lMAH_cluster_focal=0
	N_lMAH_cluster_medium=0
	N_lMAH_cluster_confluent=0

	N_rAAML_cluster=0
	N_rAAML_cluster_punctuate=0
	N_rAAML_cluster_focal=0
	N_rAAML_cluster_medium=0
	N_rAAML_cluster_confluent=0

	N_lAAML_cluster=0
	N_lAAML_cluster_punctuate=0
	N_lAAML_cluster_focal=0
	N_lAAML_cluster_medium=0
	N_lAAML_cluster_confluent=0

	N_rAAC_cluster=0
	N_rAAC_cluster_punctuate=0
	N_rAAC_cluster_focal=0
	N_rAAC_cluster_medium=0
	N_rAAC_cluster_confluent=0

	N_lAAC_cluster=0
	N_lAAC_cluster_punctuate=0
	N_lAAC_cluster_focal=0
	N_lAAC_cluster_medium=0
	N_lAAC_cluster_confluent=0

	N_rMALL_cluster=0
	N_rMALL_cluster_punctuate=0
	N_rMALL_cluster_focal=0
	N_rMALL_cluster_medium=0
	N_rMALL_cluster_confluent=0

	N_lMALL_cluster=0
	N_lMALL_cluster_punctuate=0
	N_lMALL_cluster_focal=0
	N_lMALL_cluster_medium=0
	N_lMALL_cluster_confluent=0

	N_rPATMP_cluster=0
	N_rPATMP_cluster_punctuate=0
	N_rPATMP_cluster_focal=0
	N_rPATMP_cluster_medium=0
	N_rPATMP_cluster_confluent=0

	N_lPATMP_cluster=0
	N_lPATMP_cluster_punctuate=0
	N_lPATMP_cluster_focal=0
	N_lPATMP_cluster_medium=0
	N_lPATMP_cluster_confluent=0

	N_rPAH_cluster=0
	N_rPAH_cluster_punctuate=0
	N_rPAH_cluster_focal=0
	N_rPAH_cluster_medium=0
	N_rPAH_cluster_confluent=0

	N_lPAH_cluster=0
	N_lPAH_cluster_punctuate=0
	N_lPAH_cluster_focal=0
	N_lPAH_cluster_medium=0
	N_lPAH_cluster_confluent=0

	N_rPAC_cluster=0
	N_rPAC_cluster_punctuate=0
	N_rPAC_cluster_focal=0
	N_rPAC_cluster_medium=0
	N_rPAC_cluster_confluent=0

	N_lPAC_cluster=0
	N_lPAC_cluster_punctuate=0
	N_lPAC_cluster_focal=0
	N_lPAC_cluster_medium=0
	N_lPAC_cluster_confluent=0

	N_WhlBrn_cluster_punctuate=0
	N_WhlBrn_cluster_focal=0
	N_WhlBrn_cluster_medium=0
	N_WhlBrn_cluster_confluent=0

	echo "clusterInd,Nvoxels,MAX,MAX_x_vox,MAX_y_vox,MAX_z_vox,COG_x_vox,COG_y_vox,COG_z_vox,COG_int_on_lobar_mask,COG_int_on_arterial_mask" \
			> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt

	# remove title
	sed 1d ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary.txt \
		> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_noTitle.txt


	# whole brain NoI
	N_WhlBrn_cluster=`head -n 1 ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_noTitle.txt | awk '{print $1}'`


	while read cl
	do
		clusterInd=`echo $cl | awk '{print $1}'`
		clusterSize=`echo $cl | awk '{print $2}'`
		cog_x=`echo $cl | awk '{print $7}'`
		cog_y=`echo $cl | awk '{print $8}'`
		cog_z=`echo $cl | awk '{print $9}'`

		${FSLDIR}/bin/fslmaths ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/lobar_map_with_PVmag${PVmag}_periventricle \
								-roi ${cog_x} 1 ${cog_y} 1 ${cog_z} 1 0 1 \
								${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonLobTem \
								-odt int

		${FSLDIR}/bin/fslmaths $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_arterial_template \
								-roi ${cog_x} 1 ${cog_y} 1 ${cog_z} 1 0 1 \
								${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonArtTem \
								-odt int

		cogIntensityOnLobarMask=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonLobTem -R | awk '{print $2}'`
		cogIntensityOnArterialMask=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonArtTem -R | awk '{print $2}'`

		# float to int
		cogIntensityOnLobarMask=`printf "%.0f\n" "${cogIntensityOnLobarMask}"`
		cogIntensityOnArterialMask=`printf "%.0f\n" "${cogIntensityOnArterialMask}"`

		rm -f ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonLobTem.nii*
		rm -f ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonArtTem.nii*

		## whole brain NoI subclassification
		if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
			N_WhlBrn_cluster_punctuate=$((${N_WhlBrn_cluster_punctuate} + 1))
		elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
			N_WhlBrn_cluster_focal=$((${N_WhlBrn_cluster_focal} + 1))
		elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
			N_WhlBrn_cluster_medium=$((${N_WhlBrn_cluster_medium} + 1))
		else
			N_WhlBrn_cluster_confluent=$((${N_WhlBrn_cluster_confluent} + 1))
		fi




		## Count lobar NoI
		
		if [ "${cogIntensityOnLobarMask}" -eq 7 ]; then
			N_Lfrontal_cluster=$((${N_Lfrontal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Lfrontal_cluster_punctuate=$((${N_Lfrontal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Lfrontal_cluster_focal=$((${N_Lfrontal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Lfrontal_cluster_medium=$((${N_Lfrontal_cluster_medium} + 1))
			else
				N_Lfrontal_cluster_confluent=$((${N_Lfrontal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 6 ]; then
			N_Rfrontal_cluster=$((${N_Rfrontal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Rfrontal_cluster_punctuate=$((${N_Rfrontal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Rfrontal_cluster_focal=$((${N_Rfrontal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Rfrontal_cluster_medium=$((${N_Rfrontal_cluster_medium} + 1))
			else
				N_Rfrontal_cluster_confluent=$((${N_Rfrontal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 4 ]; then
			N_Ltemporal_cluster=$((${N_Ltemporal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Ltemporal_cluster_punctuate=$((${N_Ltemporal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Ltemporal_cluster_focal=$((${N_Ltemporal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Ltemporal_cluster_medium=$((${N_Ltemporal_cluster_medium} + 1))
			else
				N_Ltemporal_cluster_confluent=$((${N_Ltemporal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 5 ]; then
			N_Rtemporal_cluster=$((${N_Rtemporal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Rtemporal_cluster_punctuate=$((${N_Rtemporal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Rtemporal_cluster_focal=$((${N_Rtemporal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Rtemporal_cluster_medium=$((${N_Rtemporal_cluster_medium} + 1))
			else
				N_Rtemporal_cluster_confluent=$((${N_Rtemporal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 17 ]; then
			N_Lparietal_cluster=$((${N_Lparietal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Lparietal_cluster_punctuate=$((${N_Lparietal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Lparietal_cluster_focal=$((${N_Lparietal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Lparietal_cluster_medium=$((${N_Lparietal_cluster_medium} + 1))
			else
				N_Lparietal_cluster_confluent=$((${N_Lparietal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 16 ]; then
			N_Rparietal_cluster=$((${N_Rparietal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Rparietal_cluster_punctuate=$((${N_Rparietal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Rparietal_cluster_focal=$((${N_Rparietal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Rparietal_cluster_medium=$((${N_Rparietal_cluster_medium} + 1))
			else
				N_Rparietal_cluster_confluent=$((${N_Rparietal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 12 ]; then
			N_Loccipital_cluster=$((${N_Loccipital_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Loccipital_cluster_punctuate=$((${N_Loccipital_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Loccipital_cluster_focal=$((${N_Loccipital_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Loccipital_cluster_medium=$((${N_Loccipital_cluster_medium} + 1))
			else
				N_Loccipital_cluster_confluent=$((${N_Loccipital_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 11 ]; then
			N_Roccipital_cluster=$((${N_Roccipital_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Roccipital_cluster_punctuate=$((${N_Roccipital_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Roccipital_cluster_focal=$((${N_Roccipital_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Roccipital_cluster_medium=$((${N_Roccipital_cluster_medium} + 1))
			else
				N_Roccipital_cluster_confluent=$((${N_Roccipital_cluster_confluent} + 1))
			fi					
		elif [ "${cogIntensityOnLobarMask}" -eq 2 ]; then
			N_Lcerebellum_cluster=$((${N_Lcerebellum_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Lcerebellum_cluster_punctuate=$((${N_Lcerebellum_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Lcerebellum_cluster_focal=$((${N_Lcerebellum_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Lcerebellum_cluster_medium=$((${N_Lcerebellum_cluster_medium} + 1))
			else
				N_Lcerebellum_cluster_confluent=$((${N_Lcerebellum_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 1 ]; then
			N_Rcerebellum_cluster=$((${N_Rcerebellum_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Rcerebellum_cluster_punctuate=$((${N_Rcerebellum_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Rcerebellum_cluster_focal=$((${N_Rcerebellum_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Rcerebellum_cluster_medium=$((${N_Rcerebellum_cluster_medium} + 1))
			else
				N_Rcerebellum_cluster_confluent=$((${N_Rcerebellum_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 3 ]; then
			N_Brainstem_cluster=$((${N_Brainstem_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Brainstem_cluster_punctuate=$((${N_Brainstem_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Brainstem_cluster_focal=$((${N_Brainstem_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Brainstem_cluster_medium=$((${N_Brainstem_cluster_medium} + 1))
			else
				N_Brainstem_cluster_confluent=$((${N_Brainstem_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 20 ]; then
			N_Periventricle_cluster=$((${N_Periventricle_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Periventricle_cluster_punctuate=$((${N_Periventricle_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Periventricle_cluster_focal=$((${N_Periventricle_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Periventricle_cluster_medium=$((${N_Periventricle_cluster_medium} + 1))
			else
				N_Periventricle_cluster_confluent=$((${N_Periventricle_cluster_confluent} + 1))
			fi
		fi


		



		## Count arterial NoI

		if [ "${cogIntensityOnArterialMask}" -eq 1 ]; then
			N_rAAH_cluster=$((${N_rAAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rAAH_cluster_punctuate=$((${N_rAAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rAAH_cluster_focal=$((${N_rAAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rAAH_cluster_medium=$((${N_rAAH_cluster_medium} + 1))
			else
				N_rAAH_cluster_confluent=$((${N_rAAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 2 ]; then
			N_lAAH_cluster=$((${N_lAAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lAAH_cluster_punctuate=$((${N_lAAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lAAH_cluster_focal=$((${N_lAAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lAAH_cluster_medium=$((${N_lAAH_cluster_medium} + 1))
			else
				N_lAAH_cluster_confluent=$((${N_lAAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 3 ]; then
			N_rMAH_cluster=$((${N_rMAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rMAH_cluster_punctuate=$((${N_rMAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rMAH_cluster_focal=$((${N_rMAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rMAH_cluster_medium=$((${N_rMAH_cluster_medium} + 1))
			else
				N_rMAH_cluster_confluent=$((${N_rMAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 6 ]; then
			N_lMAH_cluster=$((${N_lMAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lMAH_cluster_punctuate=$((${N_lMAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lMAH_cluster_focal=$((${N_lMAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lMAH_cluster_medium=$((${N_lMAH_cluster_medium} + 1))
			else
				N_lMAH_cluster_confluent=$((${N_lMAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 13 ]; then
			N_rAAML_cluster=$((${N_rAAML_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rAAML_cluster_punctuate=$((${N_rAAML_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rAAML_cluster_focal=$((${N_rAAML_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rAAML_cluster_medium=$((${N_rAAML_cluster_medium} + 1))
			else
				N_rAAML_cluster_confluent=$((${N_rAAML_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 14 ]; then
			N_lAAML_cluster=$((${N_rAAML_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lAAML_cluster_punctuate=$((${N_lAAML_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lAAML_cluster_focal=$((${N_lAAML_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lAAML_cluster_medium=$((${N_lAAML_cluster_medium} + 1))
			else
				N_lAAML_cluster_confluent=$((${N_lAAML_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 7 ]; then
			N_rAAC_cluster=$((${N_rAAC_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rAAC_cluster_punctuate=$((${N_rAAC_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rAAC_cluster_focal=$((${N_rAAC_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rAAC_cluster_medium=$((${N_rAAC_cluster_medium} + 1))
			else
				N_rAAC_cluster_confluent=$((${N_rAAC_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 8 ]; then
			N_lAAC_cluster=$((${N_lAAC_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lAAC_cluster_punctuate=$((${N_lAAC_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lAAC_cluster_focal=$((${N_lAAC_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lAAC_cluster_medium=$((${N_lAAC_cluster_medium} + 1))
			else
				N_lAAC_cluster_confluent=$((${N_lAAC_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 9 ]; then
			N_rMALL_cluster=$((${N_rMALL_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rMALL_cluster_punctuate=$((${N_rMALL_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rMALL_cluster_focal=$((${N_rMALL_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rMALL_cluster_medium=$((${N_rMALL_cluster_medium} + 1))
			else
				N_rMALL_cluster_confluent=$((${N_rMALL_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 10 ]; then
			N_lMALL_cluster=$((${N_lMALL_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lMALL_cluster_punctuate=$((${N_lMALL_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lMALL_cluster_focal=$((${N_lMALL_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lMALL_cluster_medium=$((${N_lMALL_cluster_medium} + 1))
			else
				N_lMALL_cluster_confluent=$((${N_lMALL_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 11 ]; then
			N_rPATMP_cluster=$((${N_lPATMP_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rPATMP_cluster_punctuate=$((${N_rPATMP_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rPATMP_cluster_focal=$((${N_rPATMP_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rPATMP_cluster_medium=$((${N_rPATMP_cluster_medium} + 1))
			else
				N_rPATMP_cluster_confluent=$((${N_rPATMP_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 12 ]; then
			N_lPATMP_cluster=$((${N_lPATMP_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lPATMP_cluster_punctuate=$((${N_lPATMP_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lPATMP_cluster_focal=$((${N_lPATMP_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lPATMP_cluster_medium=$((${N_lPATMP_cluster_medium} + 1))
			else
				N_lPATMP_cluster_confluent=$((${N_lPATMP_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 4 ]; then
			N_rPAH_cluster=$((${N_rPAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rPAH_cluster_punctuate=$((${N_rPAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rPAH_cluster_focal=$((${N_rPAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rPAH_cluster_medium=$((${N_rPAH_cluster_medium} + 1))
			else
				N_rPAH_cluster_confluent=$((${N_rPAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 5 ]; then
			N_lPAH_cluster=$((${N_lPAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lPAH_cluster_punctuate=$((${N_lPAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lPAH_cluster_focal=$((${N_lPAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lPAH_cluster_medium=$((${N_lPAH_cluster_medium} + 1))
			else
				N_lPAH_cluster_confluent=$((${N_lPAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 15 ]; then
			N_rPAC_cluster=$((${N_rPAC_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rPAC_cluster_punctuate=$((${N_rPAC_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rPAC_cluster_focal=$((${N_rPAC_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rPAC_cluster_medium=$((${N_rPAC_cluster_medium} + 1))
			else
				N_rPAC_cluster_confluent=$((${N_rPAC_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 16 ]; then
			N_lPAC_cluster=$((${N_lPAC_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lPAC_cluster_punctuate=$((${N_lPAC_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lPAC_cluster_focal=$((${N_lPAC_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lPAC_cluster_medium=$((${N_lPAC_cluster_medium} + 1))
			else
				N_lPAC_cluster_confluent=$((${N_lPAC_cluster_confluent} + 1))
			fi
		fi


		echo -n ${cl//	/,} >> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt
		# echo -n $cl | sed 's/	/,/g' >> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt
		echo ",${cogIntensityOnLobarMask},${cogIntensityOnArterialMask}" >> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt

	# done
	done < ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_noTitle.txt

	rm -f ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_noTitle.txt

	
	if [ -f ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt ]; then
		rm -f ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	fi

	# echo -n "Lfro_NoI,Rfro_NoI,Ltem_NoI,Rtem_NoI,Lpar_NoI,Rpar_NoI,Locc_NoI,Rocc_NoI,Lcer_NoI,Rcer_NoI,Bra_NoI" \
	# 		> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	# echo -n ",Lfro_NoI_f,Rfro_NoI_f,Ltem_NoI_f,Rtem_NoI_f,Lpar_NoI_f,Rpar_NoI_f,Locc_NoI_f,Rocc_NoI_f,Lcer_NoI_f,Rcer_NoI_f,Bra_NoI_f" \
	# 		>> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	# echo -n ",Lfro_NoI_m,Rfro_NoI_m,Ltem_NoI_m,Rtem_NoI_m,Lpar_NoI_m,Rpar_NoI_m,Locc_NoI_m,Rocc_NoI_m,Lcer_NoI_m,Rcer_NoI_m,Bra_NoI_m" \
	# 		>> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	# echo ",Lfro_NoI_c,Rfro_NoI_c,Ltem_NoI_c,Rtem_NoI_c,Lpar_NoI_c,Rpar_NoI_c,Locc_NoI_c,Rocc_NoI_c,Lcer_NoI_c,Rcer_NoI_c,Bra_NoI_c" \
	# 		>> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt


	# ----------------------
	# Wring NoI to text file
	# ----------------------

	echo "UBO Detector: writing number of incidences to text file (ID = ${ID})..."

	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	date >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "--==  Number of WMH incidences (any size) ==--" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_WholeBrain_WMHclusters	${N_WhlBrn_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Periventricle_WMHclusters	${N_Periventricle_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lfrontal_WMHclusters	${N_Lfrontal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rfrontal_WMHclusters	${N_Rfrontal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Ltemporal_WMHclusters	${N_Ltemporal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rtemporal_WMHclusters	${N_Rtemporal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lparietal_WMHclusters	${N_Lparietal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rparietal_WMHclusters	${N_Rparietal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Loccipital_WMHclusters	${N_Loccipital_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Roccipital_WMHclusters	${N_Roccipital_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lcerebellum_WMHclusters	${N_Lcerebellum_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rcerebellum_WMHclusters	${N_Rcerebellum_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Brainstem_WMHclusters	${N_Brainstem_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAH_WMHclusters	${N_lAAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAH_WMHclusters	${N_rAAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lMAH_WMHclusters	${N_lMAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rMAH_WMHclusters	${N_rMAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAML_WMHclusters	${N_lAAML_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAML_WMHclusters	${N_rAAML_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAC_WMHclusters	${N_lAAC_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAC_WMHclusters	${N_rAAC_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lMALL_WMHclusters	${N_lMALL_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rMALL_WMHclusters	${N_rMALL_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPATMP_WMHclusters	${N_lPATMP_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPATMP_WMHclusters	${N_rPATMP_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPAH_WMHclusters	${N_lPAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPAH_WMHclusters	${N_rPAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPAC_WMHclusters	${N_lPAC_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPAC_WMHclusters	${N_rPAC_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt	
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "----------------------------------------------" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "--== Number of WMH incidences (punctuate) ==--" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_WholeBrain_WMHclusters_punctuate	${N_WhlBrn_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Periventricle_WMHclusters_punctuate	${N_Periventricle_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lfrontal_WMHclusters_punctuate	${N_Lfrontal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rfrontal_WMHclusters_punctuate	${N_Rfrontal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Ltemporal_WMHclusters_punctuate	${N_Ltemporal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rtemporal_WMHclusters_punctuate	${N_Rtemporal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lparietal_WMHclusters_punctuate	${N_Lparietal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rparietal_WMHclusters_punctuate	${N_Rparietal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Loccipital_WMHclusters_punctuate	${N_Loccipital_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Roccipital_WMHclusters_punctuate	${N_Roccipital_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lcerebellum_WMHclusters_punctuate	${N_Lcerebellum_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rcerebellum_WMHclusters_punctuate	${N_Rcerebellum_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Brainstem_WMHclusters_punctuate	${N_Brainstem_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAH_WMHclusters_punctuate	${N_lAAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAH_WMHclusters_punctuate	${N_rAAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lMAH_WMHclusters_punctuate	${N_lMAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rMAH_WMHclusters_punctuate	${N_rMAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAML_WMHclusters_punctuate	${N_lAAML_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAML_WMHclusters_punctuate	${N_rAAML_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAC_WMHclusters_punctuate	${N_lAAC_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAC_WMHclusters_punctuate	${N_rAAC_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lMALL_WMHclusters_punctuate	${N_lMALL_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rMALL_WMHclusters_punctuate	${N_rMALL_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPATMP_WMHclusters_punctuate	${N_lPATMP_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPATMP_WMHclusters_punctuate	${N_rPATMP_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPAH_WMHclusters_punctuate	${N_lPAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPAH_WMHclusters_punctuate	${N_rPAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPAC_WMHclusters_punctuate	${N_lPAC_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPAC_WMHclusters_punctuate	${N_rPAC_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "----------------------------------------------" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "--== Number of WMH incidences (focal) ==--" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_WholeBrain_WMHclusters_focal	${N_WhlBrn_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Periventricle_WMHclusters_focal	${N_Periventricle_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lfrontal_WMHclusters_focal	${N_Lfrontal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rfrontal_WMHclusters_focal	${N_Rfrontal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Ltemporal_WMHclusters_focal	${N_Ltemporal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rtemporal_WMHclusters_focal	${N_Rtemporal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lparietal_WMHclusters_focal	${N_Lparietal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rparietal_WMHclusters_focal	${N_Rparietal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Loccipital_WMHclusters_focal	${N_Loccipital_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Roccipital_WMHclusters_focal	${N_Roccipital_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lcerebellum_WMHclusters_focal	${N_Lcerebellum_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rcerebellum_WMHclusters_focal	${N_Rcerebellum_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Brainstem_WMHclusters_focal	${N_Brainstem_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAH_WMHclusters_focal	${N_lAAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAH_WMHclusters_focal	${N_rAAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lMAH_WMHclusters_focal	${N_lMAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rMAH_WMHclusters_focal	${N_rMAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAML_WMHclusters_focal	${N_lAAML_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAML_WMHclusters_focal	${N_rAAML_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAC_WMHclusters_focal	${N_lAAC_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAC_WMHclusters_focal	${N_rAAC_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lMALL_WMHclusters_focal	${N_lMALL_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rMALL_WMHclusters_focal	${N_rMALL_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPATMP_WMHclusters_focal	${N_lPATMP_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPATMP_WMHclusters_focal	${N_rPATMP_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPAH_WMHclusters_focal	${N_lPAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPAH_WMHclusters_focal	${N_rPAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPAC_WMHclusters_focal	${N_lPAC_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPAC_WMHclusters_focal	${N_rPAC_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "----------------------------------------------" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "--== Number of WMH incidences (medium) ==--" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_WholeBrain_WMHclusters_medium	${N_WhlBrn_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Periventricle_WMHclusters_medium	${N_Periventricle_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lfrontal_WMHclusters_medium	${N_Lfrontal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rfrontal_WMHclusters_medium	${N_Rfrontal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Ltemporal_WMHclusters_medium	${N_Ltemporal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rtemporal_WMHclusters_medium	${N_Rtemporal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lparietal_WMHclusters_medium	${N_Lparietal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rparietal_WMHclusters_medium	${N_Rparietal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Loccipital_WMHclusters_medium	${N_Loccipital_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Roccipital_WMHclusters_medium	${N_Roccipital_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lcerebellum_WMHclusters_medium	${N_Lcerebellum_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rcerebellum_WMHclusters_medium	${N_Rcerebellum_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Brainstem_WMHclusters_medium	${N_Brainstem_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAH_WMHclusters_medium	${N_lAAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAH_WMHclusters_medium	${N_rAAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lMAH_WMHclusters_medium	${N_lMAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rMAH_WMHclusters_medium	${N_rMAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAML_WMHclusters_medium	${N_lAAML_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAML_WMHclusters_medium	${N_rAAML_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAC_WMHclusters_medium	${N_lAAC_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAC_WMHclusters_medium	${N_rAAC_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lMALL_WMHclusters_medium	${N_lMALL_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rMALL_WMHclusters_medium	${N_rMALL_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPATMP_WMHclusters_medium	${N_lPATMP_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPATMP_WMHclusters_medium	${N_rPATMP_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPAH_WMHclusters_medium	${N_lPAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPAH_WMHclusters_medium	${N_rPAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPAC_WMHclusters_medium	${N_lPAC_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPAC_WMHclusters_medium	${N_rPAC_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "----------------------------------------------" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "--== Number of WMH incidences (confluent) ==--" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_WholeBrain_WMHclusters_confluent	${N_WhlBrn_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Periventricle_WMHclusters_confluent	${N_Periventricle_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lfrontal_WMHclusters_confluent	${N_Lfrontal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rfrontal_WMHclusters_confluent	${N_Rfrontal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Ltemporal_WMHclusters_confluent	${N_Ltemporal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rtemporal_WMHclusters_confluent	${N_Rtemporal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lparietal_WMHclusters_confluent	${N_Lparietal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rparietal_WMHclusters_confluent	${N_Rparietal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Loccipital_WMHclusters_confluent	${N_Loccipital_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Roccipital_WMHclusters_confluent	${N_Roccipital_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Lcerebellum_WMHclusters_confluent	${N_Lcerebellum_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Rcerebellum_WMHclusters_confluent	${N_Rcerebellum_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_Brainstem_WMHclusters_confluent	${N_Brainstem_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAH_WMHclusters_confluent	${N_lAAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAH_WMHclusters_confluent	${N_rAAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lMAH_WMHclusters_confluent	${N_lMAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rMAH_WMHclusters_confluent	${N_rMAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAML_WMHclusters_confluent	${N_lAAML_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAML_WMHclusters_confluent	${N_rAAML_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lAAC_WMHclusters_confluent	${N_lAAC_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rAAC_WMHclusters_confluent	${N_rAAC_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lMALL_WMHclusters_confluent	${N_lMALL_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rMALL_WMHclusters_confluent	${N_rMALL_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPATMP_WMHclusters_confluent	${N_lPATMP_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPATMP_WMHclusters_confluent	${N_rPATMP_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPAH_WMHclusters_confluent	${N_lPAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPAH_WMHclusters_confluent	${N_rPAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_lPAC_WMHclusters_confluent	${N_lPAC_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "No_of_rPAC_WMHclusters_confluent	${N_rPAC_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "----------------------------------------------" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoI.txt

	echo "UBO Detector: Done."
	
}	
	
########################### END OF FUNCTION #######################################



	
# invoke the function
# $1 = ID
# $2 = subj_dir
# $3 = pipelinePath
# $4 = PVWMH magnitude (in mm)
# $5 = probability threshold as a string

WMHextraction_kNNdiscovery_Step3 $1 $2 $3 $4 $5
#> "${2}/${1}/mri/extractedWMH/${1}.log"





