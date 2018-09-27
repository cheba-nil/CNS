#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

# DESCRIPTION
# -----------
# This script 

getASLspaceAtlas(){

	ID=$1
	indFolder=$2
	CNSP_path=$3
	ASLtype=$4

	if [ "${ASLtype}" = "PASLwM0" ]; then
		ASLtype="PASL"
	fi

	# T1-to-MNI flirt settings
	# flirtSearch_start=$5 ---> 0
	# flirtSearch_end=$6 ---> 0
	# flirtDOF=$7 ---> 6

	T1="${indFolder}/${ID}_T1.nii.gz"

	T1_brainmask="${indFolder}/intermediateOutput/${ID}_T1_brainmask.nii"
	cp ${T1_brainmask} ${indFolder}/.
	gzip -f ${indFolder}/${ID}_T1_brainmask.nii
	T1_brainmask="${indFolder}/${ID}_T1_brainmask.nii.gz"

	T1_brain="${indFolder}/${ID}_T1_brain.nii.gz"
	ASL_mean_brain="${indFolder}/${ID}_${ASLtype}_mean_brain.nii.gz"

	if [ -d "${indFolder}/Atlas" ] ; then
		rm -fr ${indFolder}/Atlas
	fi
	mkdir ${indFolder}/Atlas

	cp ${FSLDIR}/data/atlases/MNI/MNI-maxprob-thr50-2mm.nii.gz \
	   ${indFolder}/Atlas/.

	MNI_atlas="${indFolder}/Atlas/MNI-maxprob-thr50-2mm.nii.gz"



	# ================== #
	# get T1 space atlas #
	# ================== #
	# ${CNSP_path}/Scripts/CNSP_cpHDR.sh ${T1} ${T1_brainmask} # copy hdr from T1 to T1 brain mask

	fslcpgeom ${T1} ${T1_brainmask} # to make the two imgs exactly the same vox size
									# otherwise a "not the same dimension" error pops up
									# ref: https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=ind1703&L=FSL&P=R64259&1=FSL&9=A&J=on&d=No+Match%3BMatch%3BMatches&z=4

	${CNSP_path}/Scripts/CNSP_reverse_warping_wMx_FSLfnirt.sh \
															  ${T1} \
															  ${T1_brainmask} \
															  ${MNI_atlas} \
															  nn \
															  0 \
															  0 \
															  6

	mv ${indFolder}/MNI-maxprob-thr50-2mm_inverseXformed.nii.gz \
		${indFolder}/Atlas/MNI-maxprob-thr50-2mm_T1space.nii.gz

	T1spaceAtlas="${indFolder}/Atlas/MNI-maxprob-thr50-2mm_T1space.nii.gz"


	# ======================== #
	# bring atlas to ASL space #
	# ======================== #
	${CNSP_path}/Scripts/CNSP_reverse_registration_wMx_FSLflirt.sh \
																   ${T1_brain} \
																   ${ASL_mean_brain} \
																   ${T1spaceAtlas} \
																   ${indFolder} \
																   nearestneighbour \
																   0 \
																   0 \
																   7

	mv ${indFolder}/otherImg_in_srcImgSpace.nii.gz \
		${indFolder}/Atlas/MNI-maxprob-thr50-2mm_ASLspace.nii.gz


}

getASLspaceAtlas $1 $2 $3 $4