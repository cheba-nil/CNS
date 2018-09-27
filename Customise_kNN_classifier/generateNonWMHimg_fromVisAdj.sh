#!/bin/bash


. ${FSLDIR}/etc/fslconf/fsl.sh

generateNonWMHimg_fromVisAdj(){

	WMHimg=$1
	ID=$2
	studyFolder=$3

	custClssfrFolder="${studyFolder}/customiseClassifier"
	seg0=`ls ${custClssfrFolder}/subjects/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg0.nii*`
	seg1=`ls ${custClssfrFolder}/subjects/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg1.nii*`
	seg2=`ls ${custClssfrFolder}/subjects/${ID}/mri/kNN_intermediateOutput/${ID}_accurateCSFmasked_seg2.nii*`

	seg0_nonWMH="${custClssfrFolder}/subjects/${ID}/mri/extractedWMH/manuallyModified/${ID}_seg0_nonWMH"
	seg1_nonWMH="${custClssfrFolder}/subjects/${ID}/mri/extractedWMH/manuallyModified/${ID}_seg1_nonWMH"
	seg2_nonWMH="${custClssfrFolder}/subjects/${ID}/mri/extractedWMH/manuallyModified/${ID}_seg2_nonWMH"
	nonWMH="${custClssfrFolder}/subjects/${ID}/mri/extractedWMH/manuallyModified/${ID}_seg012_nonWMH"

	${FSLDIR}/bin/fslmaths ${seg0} \
				-sub ${WMHimg} \
				-thr 0 \
				${seg0_nonWMH}

	${FSLDIR}/bin/fslmaths ${seg1} \
				-sub ${WMHimg} \
				-thr 0 \
				${seg1_nonWMH}

	${FSLDIR}/bin/fslmaths ${seg2} \
				-sub ${WMHimg} \
				-thr 0 \
				${seg2_nonWMH}

	${FSLDIR}/bin/fslmaths ${seg0_nonWMH} -add \
				${seg1_nonWMH} -add \
				${seg2_nonWMH} \
				${nonWMH}

}


# $1 = VisAdj WMH img
# $2 = ID
# $3 = studyFolder

generateNonWMHimg_fromVisAdj $1 $2 $3