#!/bin/bash

usage()
{
cat << EOF

DESCRIPTION: This script summarises the cortical and subcortical CBF for a subject.

USAGE:
			--Sdir|-s           <study folder>          study folder
			--Iden|-id          <ID>                    ID
			--help|-h                                   display this message

EOF
}

OPTIND=1
if [ "$#" = "0" ]; then
	usage
	exit 0
fi

while [[ $# > 0 ]]; do
	key=$1
	shift

	case ${key} in

		--Sdir|-s)
			studyFolder=$1
			shift
			;;

		--Iden|-id)
			ID=$1
			shift
			;;

		--help|-h)
			usage
			exit 0
			;;

		*)
			echo
			echo "ERROR: unknown option ${key}."
			echo
			usage
			exit
			;;
	esac
done

if [ -z ${studyFolder+a} ]; then
	echo
	echo "ERROR: studyFolder (--Sdir|-s) is not properly set."
	echo
	usage
	exit 1
fi

if [ -z ${ID+a} ]; then
	echo
	echo "ERROR: ID (--Iden|-id) is not properly set."
	echo
	usage
	exit 1
fi

# write to output TXT
TXTout="${studyFolder}/subjects/CBFinCortexAndSubcor.txt"
pvcorr_folder=${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/native_space/pvcorr

subcorGmCBF=`echo $(fslstats ${pvcorr_folder}/cortSubcor_Jmod/${ID}_CBF_MNIsubcor_GM -M) | sed 's/ //g'`
cortGmCBF=`echo $(fslstats ${pvcorr_folder}/cortSubcor_Jmod/${ID}_CBF_MNIcort_GM -M) | sed 's/ //g'`

echo "${ID},${subcorGmCBF},${cortGmCBF}" >> ${TXTout}
