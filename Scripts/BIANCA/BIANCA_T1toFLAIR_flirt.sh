#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

T1toFLAIR_flirt(){

	rawT1=$1
	rawFLAIR=$2
	outputFolder=$3
	ID=$4

	# fslreorient2std ${rawT1}
	# fslreorient2std ${rawFLAIR}

	# FLAIR --> T1
	# Here dof should be 7 if FLAIR and T1 have different voxel size. 6 if the same voxel size.
	# Future improvement: use NBTR T1 and FLAIR may generate better flirt results
	flirt -ref ${rawT1} \
			-in ${rawFLAIR} \
			-omat ${outputFolder}/T1reg2FLAIR_mtx/${ID}_FLAIRflirt2T1_mtx.mat \
			-out ${outputFolder}/T1reg2FLAIR/${ID}_FLAIRflirt2T1 \
			-searchrx 0 0 \
			-searchry 0 0 \
			-searchrz 0 0 \
			-dof 6

	# then invert matrix
	convert_xfm -omat ${outputFolder}/T1reg2FLAIR_mtx/${ID}_T1flirt2FLAIR_mtx.mat \
				-inverse ${outputFolder}/T1reg2FLAIR_mtx/${ID}_FLAIRflirt2T1_mtx.mat

	# apply inverted matrix to T1
	flirt -in ${rawT1} \
			-ref ${rawFLAIR} \
			-applyxfm \
			-init ${outputFolder}/T1reg2FLAIR_mtx/${ID}_T1flirt2FLAIR_mtx.mat \
			-out ${outputFolder}/T1reg2FLAIR/${ID}_T1flirt2FLAIR


	# flirt -in ${rawT1} \
	# 		-ref ${rawFLAIR} \
	# 		-out ${outputFolder}/T1reg2FLAIR/${ID}_T1flirt2FLAIR \
	# 		-omat ${outputFolder}/T1reg2FLAIR_mtx/${ID}_T1flirt2FLAIR_mtx.mat \
	# 		-searchrx 0 0 \
	# 		-searchry 0 0 \
	# 		-searchrz 0 0 \
	# 		-dof 6
}

T1toFLAIR_flirt $1 $2 $3 $4