#!/bin/bash

# assuming the first volume in ASL data is M0

. ${FSLDIR}/etc/fslconf/fsl.sh

separateM0fromASL(){
	ASLwM0=$1
	ASLtype=$2

	ASLwM0_folder=$(dirname "${ASLwM0}")
	ASLwM0_filename=$(basename "${ASLwM0}")
	ID=`echo ${ASLwM0_filename} | awk -F'_' '{print $1}'`

	if [ -d "${ASLwM0_folder}/tmp_fslsplit" ]; then
		rm -r ${ASLwM0_folder}/tmp_fslsplit
	fi

	mkdir ${ASLwM0_folder}/tmp_fslsplit
	cp ${ASLwM0} ${ASLwM0_folder}/tmp_fslsplit/.
	mv ${ASLwM0} ${ASLwM0_folder}/${ID}_${ASLtype}_origWithM0.nii

	ASLwM0_Nvol=`echo ${FSLDIR}/bin/fslsize ${ASLwM0} | grep "dim4" | awk '{print $2}'`

	# fslsplit save individual volumes in working directory
	cd ${ASLwM0_folder}/tmp_fslsplit

	${FSLDIR}/bin/fslsplit ${ASLwM0_folder}/tmp_fslsplit/${ASLwM0_filename}

	mv ${ASLwM0_folder}/tmp_fslsplit/vol0000.nii.gz ${ASLwM0_folder}/${ID}_M0.nii.gz

	${FSLDIR}/bin/fslmerge -t ${ASLwM0_folder}/${ID}_${ASLtype} \
								${ASLwM0_folder}/tmp_fslsplit/vol*

	cd -

	rm -fr ${ASLwM0_folder}/tmp_fslsplit

	gunzip ${ASLwM0_folder}/${ID}_M0.nii.gz \
			${ASLwM0_folder}/${ID}_${ASLtype}.nii.gz
}

# $1 = ASL with M0
# $2 = ASL type
echo "Separating M0 from ASL. Presume the first volume as M0 ..."
separateM0fromASL $1 $2