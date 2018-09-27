#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

rethresholdProbMap(){


	ID=$1
	studyFolder=$2
	probThr=$3

	echo "UBO Detector: re-thresholding probability map (ID = ${ID}) ..."

	probThr_str=`echo ${probThr} | sed 's/\./_/g'`

	if [ -f "${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii" ] && [ ! -f "${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii.gz" ]; then

		{FSLDIR}/bin/fslchfiletype NIFTI_GZ ${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii

	elif [ -f "${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii" ] && [ -f "${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii.gz" ]; then

		rm -f ${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii

	elif [ ! -f "${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii" ] && [ ! -f "${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap.nii.gz" ]; then

		echo "Error: probability map does not exist (ID = ${ID})."
	fi

	## Re-threshold
	${FSLDIR}/bin/fslmaths ${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap \
							-thr ${probThr} \
							-bin \
							${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_Prob${probThr_str}


	# smooth the probability map by 5 mm
	# ${FSLDIR}/bin/fslmaths ${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap \
	# 						-kernel gauss 1.27399 -fmean \
	# 						${subj_dir}/${ID}/mri/extractedWMH/${ID}_WMH_ProbMap_FWMH3mmSmooth




	## replace the header of extracted WMH with restore FLAIR (MATLAB generated nii's are 1*1*1),
	## and swap orientation
	# echo "--== swap orientation ==--"
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




	################################################
	###   distinguish peri-ventricle from deep   ###
	###   also segment according to lobes        ###
	################################################

	# before-refinement image as final WMH (fslmaths does nothing but duplicate)
	${FSLDIR}/bin/fslmaths ${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH_Prob${probThr_str} \
							${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH


}

# $1 = ID
# $2 = study folder
# $3 = probability threshold

rethresholdProbMap $1 $2 $3