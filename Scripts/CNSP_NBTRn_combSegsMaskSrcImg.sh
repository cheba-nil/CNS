#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

CNSP_NBTRn_combSegsMaskSrcImg(){
	
	srcImg=$1
	GM=$2
	WM=$3
	CSF=$4
	outImg=$5

	if [ "$6" = "" ]; then

		${FSLDIR}/bin/fslmaths ${GM} \
                            -add ${WM} \
                            -add ${CSF} \
                            -thr 0.3 \
                            -bin \
                            -mul ${srcImg} \
                            ${outImg}

	elif [ "$6" = "maskout" ]; then

		${FSLDIR}/bin/fslmaths ${GM} \
                            -add ${WM} \
                            -add ${CSF} \
                            -thr 0.3 \
                            -bin \
                            -mul ${srcImg} \
                            ${outImg}

        outImg_folder=$(dirname "${outImg}")
        outImg_filename=`echo $(basename "${outImg}") | awk -F'.' '{print $1}'`

        ${FSLDIR}/bin/fslmaths ${GM} \
        					   -add ${WM} \
        					   -add ${CSF} \
        					   -thr 0.3 \
        					   -bin \
        					   ${outImg_folder}/${outImg_filename}_mask
	fi


}

# $1 = src img
# $2 = GM img
# $3 = WM img
# $4 = CSF img
# $5 = output img
CNSP_NBTRn_combSegsMaskSrcImg $1 $2 $3 $4 $5 $6