#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

NBTR_Native_combNthrNbin(){

	imgFolder=$1
	ID=$2
	threshold=$3
	imgname=$4
	imgFilename=$5


	${FSLDIR}/bin/fslmaths ${imgFolder}/segmentation/GM/${ID}_GM_Native.nii \
                            -add ${imgFolder}/segmentation/WM/${ID}_WM_Native.nii \
                            -add ${imgFolder}/segmentation/CSF/${ID}_CSF_Native.nii \
                            -thr ${threshold} \
                            -bin \
                            -mul ${imgFolder}/${imgname} \
                            ${imgFolder}/nonbrainRemoved/${imgFilename}_nonbrainRemoved_NATIVE                                
                                
}

# $1 = image folder
# $2 = ID
# $3 = threshold
# $4 = image name
# $5 = image filename

NBTR_Native_combNthrNbin $1 $2 $3 $4 $5

