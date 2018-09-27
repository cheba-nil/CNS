#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

CNSP_webViewSlices_sliceOverlayOnBaseImg(){

	baseImgFolder=$1
	baseImgFilename=$2
	overlayImgFolder=$3
	overlayImgFilename=$4
	outputDir=$5

	overlayOnBaseImg=`echo ${overlayImgFilename}_on_${baseImgFilename}`

	${FSLDIR}/bin/fslmaths ${baseImgFolder}/${baseImgFilename} -nan ${baseImgFolder}/${baseImgFilename}
	${FSLDIR}/bin/fslmaths ${overlayImgFolder}/${overlayImgFilename} -nan ${overlayImgFolder}/${overlayImgFilename}

	if [ -f "${baseImgFolder}/${baseImgFilename}.nii" ] && [ -f "${baseImgFolder}/${baseImgFilename}.nii.gz" ]; then
		rm -f ${baseImgFolder}/${baseImgFilename}.nii
		# ${FSLDIR}/bin/fslchfiletype NIFTI ${baseImgFolder}/${baseImgFilename}.nii.gz
		gunzip ${baseImgFolder}/${baseImgFilename}.nii.gz
	fi

	if [ -f "${overlayImgFolder}/${overlayImgFilename}.nii" ] && [ -f "${overlayImgFolder}/${overlayImgFilename}.nii.gz" ]; then
		rm -f ${overlayImgFolder}/${overlayImgFilename}.nii
		# ${FSLDIR}/bin/fslchfiletype NIFTI ${overlayImgFolder}/${overlayImgFilename}.nii.gz
		gunzip ${overlayImgFolder}/${overlayImgFilename}.nii.gz
	fi

	# min_baseImg=`${FSLDIR}/bin/fslstats ${baseImgFolder}/${baseImgFilename} -R | awk '{print $1}'`
	# max_baseImg=`${FSLDIR}/bin/fslstats ${baseImgFolder}/${baseImgFilename} -R | awk '{print $2}'`
	min_baseImg=0
	max_baseImg=`${FSLDIR}/bin/fslstats ${baseImgFolder}/${baseImgFilename} -p 99.9`

	# max_baseImg_0_85=`bc <<< "0.85 * ${max_baseImg}"`

	## Generate overlay-on-base image
	${FSLDIR}/bin/overlay 1 0 ${baseImgFolder}/${baseImgFilename} \
		${min_baseImg} ${max_baseImg} \
		${overlayImgFolder}/${overlayImgFilename} 0.5 1 \
		${outputDir}/${overlayOnBaseImg}

	## sclice overlay-on-base image
	${FSLDIR}/bin/slicer ${outputDir}/${overlayOnBaseImg} -u \
		-x 0.4 ${outputDir}/${overlayOnBaseImg}_Slice_x1.png \
		-x 0.5 ${outputDir}/${overlayOnBaseImg}_Slice_x2.png \
		-x 0.6 ${outputDir}/${overlayOnBaseImg}_Slice_x3.png \
		-y 0.4 ${outputDir}/${overlayOnBaseImg}_Slice_y1.png \
		-y 0.5 ${outputDir}/${overlayOnBaseImg}_Slice_y2.png \
		-y 0.6 ${outputDir}/${overlayOnBaseImg}_Slice_y3.png \
		-z 0.4 ${outputDir}/${overlayOnBaseImg}_Slice_z1.png \
		-z 0.5 ${outputDir}/${overlayOnBaseImg}_Slice_z2.png \
		-z 0.6 ${outputDir}/${overlayOnBaseImg}_Slice_z3.png

	## merge overlay-on-base slices
	${FSLDIR}/bin/pngappend ${outputDir}/${overlayOnBaseImg}_Slice_x1.png \
		+ 10 ${outputDir}/${overlayOnBaseImg}_Slice_x2.png \
		+ 10 ${outputDir}/${overlayOnBaseImg}_Slice_x3.png \
		+ 10 ${outputDir}/${overlayOnBaseImg}_Slice_y1.png \
		+ 10 ${outputDir}/${overlayOnBaseImg}_Slice_y2.png \
		+ 10 ${outputDir}/${overlayOnBaseImg}_Slice_y3.png \
		+ 10 ${outputDir}/${overlayOnBaseImg}_Slice_z1.png \
		+ 10 ${outputDir}/${overlayOnBaseImg}_Slice_z2.png \
		+ 10 ${outputDir}/${overlayOnBaseImg}_Slice_z3.png \
		${outputDir}/${overlayOnBaseImg}_Slices_merged.png

	## remove overlay-on-base slices
	rm -f ${outputDir}/${overlayOnBaseImg}_Slice_??.png

}


# $1 = base img folder
# $2 = base img filename
# $3 = overlay img folder
# $4 = overlay img filename
# $5 = output directory

CNSP_webViewSlices_sliceOverlayOnBaseImg $1 $2 $3 $4 $5