#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

getMeanASLandBrainTissueMask(){

	ID=$1
	indFolder=$2
	CNSP_path=$3
	spm12path=$4
	ASLtype=$5

	if [ "${ASLtype}" = "PASLwM0" ]; then
		ASLtype="PASL"
	fi

	fslmaths ${indFolder}/${ID}_${ASLtype} \
				-Tmean ${indFolder}/${ID}_${ASLtype}_mean

	
	bet ${indFolder}/${ID}_${ASLtype}_mean \
		${indFolder}/${ID}_${ASLtype}_mean_brain

	gunzip ${indFolder}/${ID}_${ASLtype}_mean_brain.nii.gz \
			${indFolder}/${ID}_T1_brain.nii.gz

	cp ${indFolder}/intermediateOutput/c1${ID}_T1.nii \
		${indFolder}/T1space_GMmask_prob.nii

	cp ${indFolder}/intermediateOutput/c2${ID}_T1.nii \
		${indFolder}/T1space_WMmask_prob.nii

	matlab -nodisplay -nosplash -nojvm -r "addpath('${CNSP_path}/Scripts','${spm12path}');\
											CNSP_reverse_registration_wMx ('${indFolder}/${ID}_${ASLtype}_mean_brain.nii',\
																			'${indFolder}/${ID}_T1_brain.nii',\
																			'${indFolder}/T1space_GMmask_prob.nii',\
																			'Tri');\
											CNSP_reverse_registration_wMx ('${indFolder}/${ID}_${ASLtype}_mean_brain.nii',\
																			'${indFolder}/${ID}_T1_brain.nii',\
																			'${indFolder}/T1space_WMmask_prob.nii',\
																			'Tri');\
											exit" \
											>> ${indFolder}/${ID}_logfile.txt

	mv ${indFolder}/rT1space_GMmask_prob.nii ${indFolder}/ASLspace_GMmask_prob.nii
	mv ${indFolder}/rT1space_WMmask_prob.nii ${indFolder}/ASLspace_WMmask_prob.nii

	gzip -f ${indFolder}/${ID}_${ASLtype}_mean_brain.nii \
			${indFolder}/${ID}_T1_brain.nii \
			${indFolder}/ASLspace_GMmask_prob.nii \
			${indFolder}/ASLspace_WMmask_prob.nii \
			${indFolder}/T1space_GMmask_prob.nii \
			${indFolder}/T1space_WMmask_prob.nii

	fslmaths ${indFolder}/ASLspace_GMmask_prob \
			 -add ${indFolder}/ASLspace_WMmask_prob \
			 -thr 0.7 \
			 -bin \
			 ${indFolder}/ASLspace_brainTissueMask_thr7


	fslmaths ${indFolder}/ASLspace_GMmask_prob \
			 -thr 0.7 \
			 -bin \
			 ${indFolder}/ASLspace_GMmask_thr7

	fslmaths ${indFolder}/ASLspace_WMmask_prob \
			 -thr 0.7 \
			 -bin \
			 ${indFolder}/ASLspace_WMmask_thr7
}

getMeanASLandBrainTissueMask $1 $2 $3 $4 $5