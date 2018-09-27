#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

CNSP_fslFASTforWMH(){

	output=$1
	srcImg_NBTR=$2

	${FSLDIR}/bin/fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -g -B -o \
						${output} \
						${srcImg_NBTR}
}


# $1 = output folder/filename
# $2 = DARTEL space FLAIR after non-brain removal
CNSP_fslFASTforWMH $1 $2