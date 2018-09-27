#!/bin/bash

usage()
{
cat << EOF

DESCRIPTION: This script summarises the arterial territories CBF for a subject.

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
TXTout="${studyFolder}/subjects/CBFinArterialTerritories.txt"
pvcorr_folder=${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/native_space/pvcorr

echo -n "${ID}" >> ${TXTout}

for i in {1..3}
do
	gmCBF_AMP=`echo $(fslstats ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerrAMP_GM_${i} -M) | sed 's/ //g'`
	echo -n ",${gmCBF_AMP}" >> ${TXTout}
done

for i in {1..3}
do
	wmCBF_AMP=`echo $(fslstats ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerrAMP_WM_${i} -M) | sed 's/ //g'`
	echo -n ",${wmCBF_AMP}" >> ${TXTout}
done

for i in {1..3}
do
	globalCBF_AMP=`echo $(fslstats ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerrAMP_global_${i} -M) | sed 's/ //g'`
	echo -n ",${globalCBF_AMP}" >> ${TXTout}
done


for i in {1..16}
do
	gmCBFart=`echo $(fslstats ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerr_GM_${i} -M) | sed 's/ //g'`
	echo -n ",${gmCBFart}" >> ${TXTout}
done

for i in {1..16}
do
	wmCBFart=`echo $(fslstats ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerr_WM_${i} -M) | sed 's/ //g'`
	echo -n ",${wmCBFart}" >> ${TXTout}
done

for i in {1..16}
do
	globalCBFart=`echo $(fslstats ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerr_global_${i} -M) | sed 's/ //g'`
	echo -n ",${globalCBFart}" >> ${TXTout}
done

echo "" >> ${TXTout}