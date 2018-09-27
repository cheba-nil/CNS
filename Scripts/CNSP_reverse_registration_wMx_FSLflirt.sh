#!/bin/bash

# otherImg is the image in ref space that needs to linearly transferred to src space
#
# NOTE: Better to use NBTR'ed ref and src image
#

. ${FSLDIR}/etc/fslconf/fsl.sh


reverseReg(){

	refImg=$1
	srcImg=$2
	otherImg=$3
	outputFolder=$4

	# default interp is trilinear
	if [ "$5" = "" ]; then
		interpMethod="trilinear"
	else
		interpMethod=$5
	fi

	# default flirt search start = 0
	if [ "$6" = "" ]; then
		flirtSearch_start="0"
	else
		flirtSearch_start=$6
	fi


	# default flirt search end = 0
	if [ "$7" = "" ]; then
		flirtSearch_end="0"
	else
		flirtSearch_end=$7
	fi


	# default flirt dof = 7
	if [ "$8" = "" ]; then
		dof="7"
	else
		dof=$8
	fi


	if [ -d "${outputFolder}/temp_CNSPreverseRegWmxFSLflirt" ]; then
		rm -fr ${outputFolder}/temp_CNSPreverseRegWmxFSLflirt
	fi

	mkdir ${outputFolder}/temp_CNSPreverseRegWmxFSLflirt

	# src --> ref transformation matrix
	# dof=7 as intra-subject registration with different voxel size
	flirt -ref ${refImg} \
			-in ${srcImg} \
			-omat ${outputFolder}/temp_CNSPreverseRegWmxFSLflirt/src2ref_mtx.mat \
			-out ${outputFolder}/temp_CNSPreverseRegWmxFSLflirt/src2ref \
			-searchrx ${flirtSearch_start} ${flirtSearch_end} \
			-searchry ${flirtSearch_start} ${flirtSearch_end} \
			-searchrz ${flirtSearch_start} ${flirtSearch_end} \
			-dof ${dof}

	# reverse matrix
	convert_xfm -omat ${outputFolder}/temp_CNSPreverseRegWmxFSLflirt/ref2src_mtx.mat \
				-inverse ${outputFolder}/temp_CNSPreverseRegWmxFSLflirt/src2ref_mtx.mat


	# bring otherImg in ref space to src space by applying reversed matrix
	flirt -in ${otherImg} \
			-ref ${srcImg} \
			-applyxfm \
			-init ${outputFolder}/temp_CNSPreverseRegWmxFSLflirt/ref2src_mtx.mat \
			-interp ${interpMethod} \
			-out ${outputFolder}/otherImg_in_srcImgSpace
}

echo "CNSP_reverse_registration_wMx_FSLflirt.sh: Reversing ..."
reverseReg $1 $2 $3 $4 $5 $6 $7 $8
