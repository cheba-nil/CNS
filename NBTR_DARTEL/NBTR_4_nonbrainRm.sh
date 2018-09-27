#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

NBTR_SkullStriping(){

	img=$1
	imgFolder=$2
	CNSP_path=$3

	${FSLDIR}/bin/fslmaths ${imgFolder}/spmoutput/w${img} \
							-mas ${CNSP_path}/Templates/DARTEL_brain_mask/DARTEL_brain_mask \
							${imgFolder}/nonbrainRemoved/${img}_nonbrainRemoved_DARTEL

}

# $1 = img filename
# $2 = img folder
# $3 = CNSP folder
NBTR_SkullStriping $1 $2 $3