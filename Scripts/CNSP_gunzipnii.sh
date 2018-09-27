#!/bin/bash

# To gunzip .nii.gz

. ${FSLDIR}/etc/fslconf/fsl.sh

CNSP_gunzip(){
	nifti_gz=$1
	${FSLDIR}/bin/fslchfiletype NIFTI ${nifti_gz}
}

# $1 = .nii.gz image
CNSP_gunzip $1