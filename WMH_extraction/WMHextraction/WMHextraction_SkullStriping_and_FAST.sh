#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

WMHextraction_SkullStriping_and_FAST(){

	T1=$1
	FLAIR=$2
	subjectsDir=$3
	ID=$4
	brain_mask=$5
	DARTELtemplate=$6
	gm_prob=$7

    # we still need to create the brain mask if creating a new template
	if [ "${DARTELtemplate}" = "creating_template" ]; then
		${FSLDIR}/bin/fslmaths ${subj_dir}/cohort_probability_maps/cohort_WM_probability_map \
								-add $gm_prob \
								-thr 0.5 \
								-bin \
								$brain_mask
	fi

    ${FSLDIR}/bin/fslmaths ${subjectsDir}/${ID}/mri/preprocessing/w${T1} \
                            -nan \
                            -mas $brain_mask \
                            ${subjectsDir}/${ID}/mri/preprocessing/nonBrainRemoved_w${T1}

    ${FSLDIR}/bin/fslmaths ${subjectsDir}/${ID}/mri/preprocessing/wr${FLAIR} \
                            -nan \
                            -mas $brain_mask \
                            ${subjectsDir}/${ID}/mri/preprocessing/nonBrainRemoved_wr${FLAIR}

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
# $5 = Brain Mask
# $6 = DARTEL template
# $7 = GM prob 
WMHextraction_SkullStriping_and_FAST $1 $2 $3 $4 $5 $6 $7
