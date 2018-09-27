#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

WMHextraction_SkullStriping_and_FAST(){

	T1=$1
	FLAIR=$2
	subjectsDir=$3
	ID=$4
	CNSP_path=$5
	DARTELtemplate=$6
	ageRange=$7

	if [ "${DARTELtemplate}" = "existing_template" ]; then
		${FSLDIR}/bin/fslmaths ${subjectsDir}/${ID}/mri/preprocessing/w${T1} \
								-nan \
								-mas ${CNSP_path}/Templates/DARTEL_brain_mask/${ageRange}/DARTEL_brain_mask \
								${subjectsDir}/${ID}/mri/preprocessing/nonBrainRemoved_w${T1}

		${FSLDIR}/bin/fslmaths ${subjectsDir}/${ID}/mri/preprocessing/wr${FLAIR} \
								-nan \
								-mas ${CNSP_path}/Templates/DARTEL_brain_mask/${ageRange}/DARTEL_brain_mask \
								${subjectsDir}/${ID}/mri/preprocessing/nonBrainRemoved_wr${FLAIR}

	elif [ "${DARTELtemplate}" = "creating_template" ]; then
		${FSLDIR}/bin/fslmaths ${subj_dir}/cohort_probability_maps/cohort_WM_probability_map \
								-add ${subj_dir}/cohort_probability_maps/cohort_GM_probability_map \
								-thr 0.5 \
								-bin \
								${subj_dir}/cohort_probability_maps/DARTEL_cohort_brain_mask

		${FSLDIR}/bin/fslmaths ${subjectsDir}/${ID}/mri/preprocessing/w${T1} \
								-nan \
								-mas ${subj_dir}/cohort_probability_maps/DARTEL_cohort_brain_mask \
								${subjectsDir}/${ID}/mri/preprocessing/nonBrainRemoved_w${T1}

		${FSLDIR}/bin/fslmaths ${subjectsDir}/${ID}/mri/preprocessing/wr${FLAIR} \
								-nan \
								-mas ${subj_dir}/cohort_probability_maps/DARTEL_cohort_brain_mask \
								${subjectsDir}/${ID}/mri/preprocessing/nonBrainRemoved_wr${FLAIR}
	fi

#	${FSLDIR}/bin/fslmaths ${subjectsDir}/${ID}/mri/preprocessing/wc1${T1} \
#							-mas ${CNSP_path}/Templates/DARTEL_brain_mask/DARTEL_brain_mask \
#							${subjectsDir}/${ID}/mri/preprocessing/nonBrainRemoved_w${T1}

	${FSLDIR}/bin/fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -g -B -o \
							${subjectsDir}/${ID}/mri/preprocessing/FAST_nonBrainRemoved_wr${FLAIR} \
							${subjectsDir}/${ID}/mri/preprocessing/nonBrainRemoved_wr${FLAIR}

}

# $1 = T1 filename
# $2 = FLAIR filename
# $3 = subjects dir
# $4 = ID
# $5 = CNSP_path
# $6 = DARTEL template
# $7 = age range
WMHextraction_SkullStriping_and_FAST $1 $2 $3 $4 $5 $6 $7