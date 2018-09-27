#!/bin/bash

# This script copy header from src image and paste to tgt (target) image

. ${FSLDIR}/etc/fslconf/fsl.sh

cpHDR(){

	srcImg_gz=$1
	tgtImg_gz=$2

	srcImg_gz_folder=$(dirname "${srcImg_gz}")
	tgtImg_gz_folder=$(dirname "${tgtImg_gz}")
	tgtImg_gz_filename=`echo $(basename "${tgtImg_gz}") | awk -F'.' '{print $1}'`

	# make a tgt img backup
	cp ${tgtImg_gz} \
	   ${tgtImg_gz_folder}/${tgtImg_gz_filename}_orig.nii.gz

	${FSLDIR}/bin/fslhd -x ${srcImg_gz} > ${srcImg_gz_folder}/srcImg_hdr.xml

	${FSLDIR}/bin/fslcreatehd ${srcImg_gz_folder}/srcImg_hdr.xml \
							  ${tgtImg_gz}
	
	# mv ${tgtImg_gz} ${tgtImg_gz_folder}/${tgtImg_gz_filename}_cpHDR.nii.gz

	rm -f ${srcImg_gz_folder}/srcImg_hdr.xml
}

cpHDR $1 $2