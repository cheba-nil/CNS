#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

fsl_dtifit(){

	inputImg=$1
	outputImg=$2
	mask=$3
	bvec=$4
	bval=$5


	${FSLDIR}/bin/dtifit --data=${inputImg} \
	--out=${outputImg} \
	--mask=${mask} \
	--bvecs=${bvec} \
	--bvals=${bval}
}


# $1 = input image
# $2 = output image
# $3 = mask
# $4 = bvec
# $5 = bval

# Note: 
#  inputImg, mask, bvec, bval needs full name with suffix
#  outputImg only needs filename without suffix
fsl_dtifit $1 $2 $3 $4 $5

