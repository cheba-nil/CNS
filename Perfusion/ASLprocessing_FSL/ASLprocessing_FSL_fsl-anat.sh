#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh



fslanat(){

	ID=$1
	indFolder=$2

	${FSLDIR}/bin/fsl_anat \
						-i ${indFolder}/${ID}_T1 \
						>> ${indFolder}/${ID}_logfile.txt


}

fslanat $1 $2