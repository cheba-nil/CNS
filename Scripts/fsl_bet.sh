#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

fsl_bet(){

	inputImg=$1
	outputMask=$2
	fthr=`bc -l <<< "$3"`
	gthr=`bc -l <<< "$4"`

	${FSLDIR}/bin/bet ${inputImg} \
					  ${outputMask} \
					  -f ${fthr} \
					  -g ${gthr}
}


# $1 = input dti image (not bval or bvec)
# $2 = output dti image mask
# $3 = fractional intensity threshold
# $4 = vertical gradient in fractional intensity threshold

# use bet --help to see the explanation of -f and -g

fsl_bet $1 $2 $3 $4