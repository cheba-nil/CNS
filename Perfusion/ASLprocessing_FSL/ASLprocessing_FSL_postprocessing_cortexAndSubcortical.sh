#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

ASLprocessing_FSL_folder=$(dirname $(which $0))
Perfusion_folder=$(dirname "${ASLprocessing_FSL_folder}")
CNS_folder=$(dirname "${Perfusion_folder}")

# ================ usage function ================= #
usage()
{
cat << EOF

DESCRIPTION: This script is part of ASLprocessing_FSL, aiming at extracting CBF in cerebral cortex and subcortical structures (as a whole).

USAGE:
			--Sdir|-s             <study folder>                  path to study folder
			--Iden|-id            <ID>                            ID
			--help|-h                                             display this message

EOF
}


# ================= passing arguments ==================== #
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
			exit 1
			;;
	esac
done


# ================ check if arguments are null ================= #
if [ -z ${studyFolder+a} ]; then
	echo
	echo "ERROR: study folder (--Sdir|-s) is not properly set."
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


# ============= Now do the job ============== #

# ----------------------
# get native-space atlas
# ----------------------
MNI_subcor_atls=${CNS_folder}/Templates/MNI_HarvardOxford_maxthr50_subcortical_Jmod/MNI_HO_maxthr50_subcor_Jmod_LRsubcor.nii.gz
MNI_cort_atls=${CNS_folder}/Templates/MNI_HarvardOxford_maxthr50_subcortical_Jmod/MNI_HO_maxthr50_subcor_Jmod_LRcortex.nii.gz

cp ${MNI_subcor_atls} ${MNI_cort_atls} ${studyFolder}/subjects/${ID}/Atlas/.

MNI_subcor_atls_local=${studyFolder}/subjects/${ID}/Atlas/MNI_HO_maxthr50_subcor_Jmod_LRsubcor.nii.gz
MNI_cort_atls_local=${studyFolder}/subjects/${ID}/Atlas/MNI_HO_maxthr50_subcor_Jmod_LRcortex.nii.gz


# call AAAI to warp MNI atlas to native
echo -n "Warping MNI subcortical and cortical atlases to native space ..."

ASL_mean_brain=`ls ${studyFolder}/subjects/${ID}/${ID}_*ASL_mean_brain.nii.gz`
T1=${studyFolder}/subjects/${ID}/${ID}_T1.nii.gz
T1_mask=${studyFolder}/subjects/${ID}/${ID}_T1_brainmask.nii.gz

${CNS_folder}/AAAI/MNIatlas2native/AAAI_MNIatlas2nativeSpace.sh --natv ${ASL_mean_brain} \
																--t1 ${T1} \
																--t1msk ${T1_mask} \
																--atlas ${MNI_subcor_atls_local} \
																--Odir ${studyFolder}/subjects/${ID}/Atlas \
																--Onam ${ID}_nativeMNIsubcor

${CNS_folder}/AAAI/MNIatlas2native/AAAI_MNIatlas2nativeSpace.sh --natv ${ASL_mean_brain} \
																--t1 ${T1} \
																--t1msk ${T1_mask} \
																--atlas ${MNI_cort_atls_local} \
																--Odir ${studyFolder}/subjects/${ID}/Atlas \
																--Onam ${ID}_nativeMNIcort

nativeSpace_subcor_atls=${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIsubcor_native_mask.nii.gz
nativeSpace_cort_atls=${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIcort_native_mask.nii.gz

echo "   Done."

# ------------------------------------------
# Now applying native-space atlas to CBF map
# ------------------------------------------

echo -n "Applying subcortical and cortical atlases ..."

# parameters for subregions
pvcorr_folder=${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/native_space/pvcorr

pvcorr_CBF_GM=${pvcorr_folder}/perfusion_calib_GM_Jmod.nii.gz
# pvcorr_CBF_global=${pvcorr_folder}/arterialTerr_Jmod/perfusion_calib_global_Jmod.nii.gz


# make a directory arterialTerr_Jmod for arterial 
# territories results
if [ -d "${pvcorr_folder}/cortSubcor_Jmod" ]; then
	rm -fr ${pvcorr_folder}/cortSubcor_Jmod
fi

mkdir ${pvcorr_folder}/cortSubcor_Jmod


# apply mask
fslmaths ${pvcorr_CBF_GM} \
		 -mas ${nativeSpace_subcor_atls} \
		 ${pvcorr_folder}/cortSubcor_Jmod/${ID}_CBF_MNIsubcor_GM

fslmaths ${pvcorr_CBF_GM} \
		 -mas ${nativeSpace_cort_atls} \
		 ${pvcorr_folder}/cortSubcor_Jmod/${ID}_CBF_MNIcort_GM


echo "   Done."

