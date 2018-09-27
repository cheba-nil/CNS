#!/bin/bash

# assuming the first volume in PASL data is M0

. ${FSLDIR}/etc/fslconf/fsl.sh

separateM0fromPASL(){
	PASLwM0=$1
	PASLwM0_folder=$(dirname "${PASLwM0}")
	PASLwM0_filename=$(basename "${PASLwM0}")
	ID=`echo ${PASLwM0_filename} | awk -F'_' '{print $1}'`

	if [ -d "${PASLwM0_folder}/tmp_fslsplit" ]; then
		rm -r ${PASLwM0_folder}/tmp_fslsplit
	fi

	mkdir ${PASLwM0_folder}/tmp_fslsplit
	cp ${PASLwM0} ${PASLwM0_folder}/tmp_fslsplit/.

	PASLwM0_Nvol=`echo ${FSLDIR}/bin/fslsize ${PASLwM0} | grep "dim4" | awk '{print $2}'`

	# fslsplit save individual volumes in working directory
	cd ${PASLwM0_folder}/tmp_fslsplit

	${FSLDIR}/bin/fslsplit ${PASLwM0_folder}/tmp_fslsplit/${PASLwM0_filename}

	mv ${PASLwM0_folder}/tmp_fslsplit/vol0000.nii.gz ${PASLwM0_folder}/${ID}_M0.nii.gz

	${FSLDIR}/bin/fslmerge -t ${PASLwM0_folder}/${ID}_PASL ${PASLwM0_folder}/tmp_fslsplit/vol*

	cd -

	rm -fr ${PASLwM0_folder}/tmp_fslsplit
}

# $1 = PASL with M0
separateM0fromPASL $1