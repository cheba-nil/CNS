#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

disp_usage(){

	echo ""
	echo "`basename $0`: Prepare downloading images for manual editing."
	echo ""
	echo "Usage:  `basename $0` [option] [argument] [option] [argument]"
	echo ""
	echo "                   -s, --studyFolder      <study_folder>       Specify study folder containing T1 and FLAIR. Either -s or -c needs to be specified."
	echo "                   -c, --currentFolder                         Use the working directory as study folder. Either -c or -s needs to be specified."
	echo "                   -i, --id               <list_of_IDs>        List of IDs needing manual editing (separated by a coma)."
	echo ""
}

for arg in $@
do
	case "$1" in
		-s | --studyFolder)
							if [ ! -z "$2" ]; then
								studyFolder=$2
							else
								disp_usage
								exit 1
							fi
							shift 2
							;;

		-c | --currentFolder)
							studyFolder=`pwd`
							shift
							;;

		-i | --id)
							if [ ! -z "$2" ]; then
								IDs=$2
							else
								disp_usage
								exit 1
							fi
							shift 2
							;;

		-*)	
							disp_usage
							exit 1
							;;
	esac
done

if [ -z "${studyFolder}" ] || [ -z "${IDs}" ]; then
	disp_usage
	exit 1
else
	echo "study folder = ${studyFolder}"
	echo -n "editing IDs = ${IDs} "
fi

N_IDs=`echo ${IDs} | sed 's/,/ /g' | wc -w`
echo "(N = ${N_IDs})"

echo "Preparing images for download ..."

if [ -d "${studyFolder}/manual_editing" ]; then
	rm -fr ${studyFolder}/manual_editing
fi
mkdir ${studyFolder}/manual_editing

for manEdtID in `echo ${IDs} | sed 's/,/ /g'`
do
	if [ ! -d "${studyFolder}/subjects/${manEdtID}" ]; then
		echo "Error: ${manEdtID} does not exist!"
		exit 0
	fi

	FLAIRname=`basename ${studyFolder}/originalImg/FLAIR/${manEdtID}_*.nii .nii`
	mkdir ${studyFolder}/manual_editing/${manEdtID}
	
	cp ${studyFolder}/subjects/${manEdtID}/mri/extractedWMH/${manEdtID}_WMH.nii.gz \
		${studyFolder}/manual_editing/${manEdtID}/.
	
	cp ${studyFolder}/subjects/${manEdtID}/mri/preprocessing/wr${FLAIRname}.nii \
		${studyFolder}/manual_editing/${manEdtID}/.

	${FSLDIR}/bin/fslchfiletype NIFTI_GZ ${studyFolder}/manual_editing/${manEdtID}/wr${FLAIRname}
done

cd ${studyFolder}
tar czf ./manual_editing.tar.gz manual_editing/*
rm -fr manual_editing

echo "Finished. Download link: ${studyFolder}/manual_editing.tar.gz"