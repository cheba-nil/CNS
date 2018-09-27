#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

T1toFLAIR_flirt(){

	rawT1=$1
	rawFLAIR=$2
	outputFolder=$3
	ID=$4


	flirt -in ${rawT1} \
			-ref ${rawFLAIR} \
			-out ${outputFolder}/T1reg2FLAIR/${ID}_T1flirt2FLAIR \
			-omat ${outputFolder}/T1reg2FLAIR_mtx/${ID}_T1flirt2FLAIR_mtx.mat \
			-dof 6
}

T1toFLAIR_flirt $1 $2 $3 $4