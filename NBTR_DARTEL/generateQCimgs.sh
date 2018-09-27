#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

generateQCimgs(){

	ID=$1
	imgFolder=$2
	imgFilename=$3

	## create QC directory
	if [ ! -d ${imgFolder}/QC ]; then
		mkdir ${imgFolder}/QC
	fi

	T1="${imgFolder}/${imgFilename}.nii"
	GMseg="${imgFolder}/spmoutput/c1${imgFilename}.nii"
	WMseg="${imgFolder}/spmoutput/c2${imgFilename}.nii"
	CSFseg="${imgFolder}/spmoutput/c3${imgFilename}.nii"


	min_T1=`${FSLDIR}/bin/fslstats ${T1} -R | awk '{print $1}'`
	max_T1=`${FSLDIR}/bin/fslstats ${T1} -R | awk '{print $2}'`
	min_GMseg=`${FSLDIR}/bin/fslstats ${GMseg} -R | awk '{print $1}'`
	max_GMseg=`${FSLDIR}/bin/fslstats ${GMseg} -R | awk '{print $2}'`
	min_WMseg=`${FSLDIR}/bin/fslstats ${WMseg} -R | awk '{print $1}'`
	max_WMseg=`${FSLDIR}/bin/fslstats ${WMseg} -R | awk '{print $2}'`
	min_CSFseg=`${FSLDIR}/bin/fslstats ${CSFseg} -R | awk '{print $1}'`
	max_CSFseg=`${FSLDIR}/bin/fslstats ${CSFseg} -R | awk '{print $2}'`



	## Generate GM-on-T1 image
	${FSLDIR}/bin/overlay 1 0 ${T1} \
		${min_T1} ${max_T1} \
		${GMseg} 0.01 ${max_GMseg} \
		${imgFolder}/QC/${ID}_GM_on_T1

	## Generate WM-on-T1 image
	${FSLDIR}/bin/overlay 1 0 ${T1} \
		${min_T1} ${max_T1} \
		${WMseg} 0.01 ${max_WMseg} \
		${imgFolder}/QC/${ID}_WM_on_T1

	## Generate CSF-on-T1 image
	${FSLDIR}/bin/overlay 1 0 ${T1} \
		${min_T1} ${max_T1} \
		${CSFseg} 0.01 ${max_CSFseg} \
		${imgFolder}/QC/${ID}_CSF_on_T1

	## slice T1
	${FSLDIR}/bin/slicer ${T1} -i ${min_T1} ${max_T1} -u \
		-x 0.4 ${imgFolder}/QC/${ID}_wT1_Slice_x1.png \
		-x 0.5 ${imgFolder}/QC/${ID}_wT1_Slice_x2.png \
		-x 0.6 ${imgFolder}/QC/${ID}_wT1_Slice_x3.png \
		-y 0.4 ${imgFolder}/QC/${ID}_wT1_Slice_y1.png \
		-y 0.5 ${imgFolder}/QC/${ID}_wT1_Slice_y2.png \
		-y 0.6 ${imgFolder}/QC/${ID}_wT1_Slice_y3.png \
		-z 0.4 ${imgFolder}/QC/${ID}_wT1_Slice_z1.png \
		-z 0.5 ${imgFolder}/QC/${ID}_wT1_Slice_z2.png \
		-z 0.6 ${imgFolder}/QC/${ID}_wT1_Slice_z3.png


	## sclice GM-on-T1 image
	${FSLDIR}/bin/slicer ${imgFolder}/QC/${ID}_GM_on_T1 -u \
		-x 0.4 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_x1.png \
		-x 0.5 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_x2.png \
		-x 0.6 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_x3.png \
		-y 0.4 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_y1.png \
		-y 0.5 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_y2.png \
		-y 0.6 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_y3.png \
		-z 0.4 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_z1.png \
		-z 0.5 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_z2.png \
		-z 0.6 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_z3.png

	## sclice WM-on-T1 image
	${FSLDIR}/bin/slicer ${imgFolder}/QC/${ID}_WM_on_T1 -u \
		-x 0.4 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_x1.png \
		-x 0.5 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_x2.png \
		-x 0.6 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_x3.png \
		-y 0.4 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_y1.png \
		-y 0.5 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_y2.png \
		-y 0.6 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_y3.png \
		-z 0.4 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_z1.png \
		-z 0.5 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_z2.png \
		-z 0.6 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_z3.png

	## sclice CSF-on-T1 image
	${FSLDIR}/bin/slicer ${imgFolder}/QC/${ID}_CSF_on_T1 -u \
		-x 0.4 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_x1.png \
		-x 0.5 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_x2.png \
		-x 0.6 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_x3.png \
		-y 0.4 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_y1.png \
		-y 0.5 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_y2.png \
		-y 0.6 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_y3.png \
		-z 0.4 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_z1.png \
		-z 0.5 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_z2.png \
		-z 0.6 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_z3.png

	## merge T1 slices
	${FSLDIR}/bin/pngappend ${imgFolder}/QC/${ID}_wT1_Slice_x1.png \
		+ 10 ${imgFolder}/QC/${ID}_wT1_Slice_x2.png \
		+ 10 ${imgFolder}/QC/${ID}_wT1_Slice_x3.png \
		+ 10 ${imgFolder}/QC/${ID}_wT1_Slice_y1.png \
		+ 10 ${imgFolder}/QC/${ID}_wT1_Slice_y2.png \
		+ 10 ${imgFolder}/QC/${ID}_wT1_Slice_y3.png \
		+ 10 ${imgFolder}/QC/${ID}_wT1_Slice_z1.png \
		+ 10 ${imgFolder}/QC/${ID}_wT1_Slice_z2.png \
		+ 10 ${imgFolder}/QC/${ID}_wT1_Slice_z3.png \
		${imgFolder}/QC/${ID}_wT1_Slices_merged.png


	## merge GM-on-T1 slices
	${FSLDIR}/bin/pngappend ${imgFolder}/QC/${ID}_GM_on_T1_Slice_x1.png \
		+ 10 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_x2.png \
		+ 10 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_x3.png \
		+ 10 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_y1.png \
		+ 10 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_y2.png \
		+ 10 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_y3.png \
		+ 10 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_z1.png \
		+ 10 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_z2.png \
		+ 10 ${imgFolder}/QC/${ID}_GM_on_T1_Slice_z3.png \
		${imgFolder}/QC/${ID}_GM_on_T1_Slices_merged.png

	## merge WM-on-T1 slices
	${FSLDIR}/bin/pngappend ${imgFolder}/QC/${ID}_WM_on_T1_Slice_x1.png \
		+ 10 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_x2.png \
		+ 10 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_x3.png \
		+ 10 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_y1.png \
		+ 10 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_y2.png \
		+ 10 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_y3.png \
		+ 10 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_z1.png \
		+ 10 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_z2.png \
		+ 10 ${imgFolder}/QC/${ID}_WM_on_T1_Slice_z3.png \
		${imgFolder}/QC/${ID}_WM_on_T1_Slices_merged.png

	## merge CSF-on-T1 slices
	${FSLDIR}/bin/pngappend ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_x1.png \
		+ 10 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_x2.png \
		+ 10 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_x3.png \
		+ 10 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_y1.png \
		+ 10 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_y2.png \
		+ 10 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_y3.png \
		+ 10 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_z1.png \
		+ 10 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_z2.png \
		+ 10 ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_z3.png \
		${imgFolder}/QC/${ID}_CSF_on_T1_Slices_merged.png

	## remove individual GM_on_T1 slices
	rm -f ${imgFolder}/QC/${ID}_GM_on_T1_Slice_??.png
	## remove individual WM_on_T1 slices
	rm -f ${imgFolder}/QC/${ID}_WM_on_T1_Slice_??.png
	## remove individual CSF_on_T1 slices
	rm -f ${imgFolder}/QC/${ID}_CSF_on_T1_Slice_??.png
	

	echo "<a><img src=\"${imgFolder}/QC/${ID}_wT1_Slices_merged.png\" WIDTH=1000 > ${ID}_T1</a><br>" >> ${imgFolder}/QC/QC_Segmentation.html
	echo "<a><img src=\"${imgFolder}/QC/${ID}_GM_on_T1_Slices_merged.png\" WIDTH=1000 > ${ID}_GM_on_T1</a><br>" >> ${imgFolder}/QC/QC_Segmentation.html
	echo "<a><img src=\"${imgFolder}/QC/${ID}_WM_on_T1_Slices_merged.png\" WIDTH=1000 > ${ID}_WM_on_T1</a><br>" >> ${imgFolder}/QC/QC_Segmentation.html
	echo "<a><img src=\"${imgFolder}/QC/${ID}_CSF_on_T1_Slices_merged.png\" WIDTH=1000 > ${ID}_CSF_on_T1</a><br>" >> ${imgFolder}/QC/QC_Segmentation.html
	

}


# $1 = ID
# $2 = image folder
generateQCimgs $1 $2 $3


