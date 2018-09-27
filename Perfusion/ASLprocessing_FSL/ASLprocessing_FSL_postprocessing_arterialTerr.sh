#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

ASLprocessing_FSL_folder=$(dirname $(which $0))
Perfusion_folder=$(dirname "${ASLprocessing_FSL_folder}")
CNS_folder=$(dirname "${Perfusion_folder}")

# ================ usage function ================= #
usage()
{
cat << EOF

DESCRIPTION: This script is part of ASLprocessing_FSL, aiming at extracting CBF in arterial territories.

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
MNI_art_atls=${CNS_folder}/Templates/MNI_arterial_territories/MNI_arterial_territories.nii.gz
MNI_art_AMP_atls=${CNS_folder}/Templates/MNI_arterial_territories/MNI_arterial_territories_ACA_MCA_PCA.nii.gz

cp ${MNI_art_atls} ${MNI_art_AMP_atls} ${studyFolder}/subjects/${ID}/Atlas/.

MNI_art_atls_local=${studyFolder}/subjects/${ID}/Atlas/MNI_arterial_territories.nii.gz
MNI_art_AMP_atls_local=${studyFolder}/subjects/${ID}/Atlas/MNI_arterial_territories_ACA_MCA_PCA.nii.gz

MaxInt=`fslstats ${MNI_art_atls_local} -R | awk '{print $2}' | sed 's/ //g'`


# call AAAI to warp MNI atlas to native
ASL_mean_brain=`ls ${studyFolder}/subjects/${ID}/${ID}_*ASL_mean_brain.nii.gz`
T1=${studyFolder}/subjects/${ID}/${ID}_T1.nii.gz
T1_mask=${studyFolder}/subjects/${ID}/${ID}_T1_brainmask.nii.gz

${CNS_folder}/AAAI/MNIatlas2native/AAAI_MNIatlas2nativeSpace.sh --natv ${ASL_mean_brain} \
																--t1 ${T1} \
																--t1msk ${T1_mask} \
																--atlas ${MNI_art_atls_local} \
																--Odir ${studyFolder}/subjects/${ID}/Atlas \
																--Onam ${ID}_nativeMNIart

${CNS_folder}/AAAI/MNIatlas2native/AAAI_MNIatlas2nativeSpace.sh --natv ${ASL_mean_brain} \
																--t1 ${T1} \
																--t1msk ${T1_mask} \
																--atlas ${MNI_art_AMP_atls_local} \
																--Odir ${studyFolder}/subjects/${ID}/Atlas \
																--Onam ${ID}_nativeMNIartAMP


# separate native atlas to individual regions
echo -n "Splitting atlas ..."

nativeSpace_art_atls=${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIart_native_mask.nii.gz
nativeSpace_art_AMP_atls=${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIartAMP_native_mask.nii.gz

for i in $(seq 1 ${MaxInt})
do
	fslmaths ${nativeSpace_art_atls} \
			 -thr ${i} \
			 -uthr ${i} \
			 -bin \
			 ${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIart_native_mask_${i}

done

for i in {1..3}
do
	fslmaths ${nativeSpace_art_AMP_atls} \
			 -thr ${i} \
			 -uthr ${i} \
			 -bin \
			 ${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIartAMP_native_mask_${i}

done


echo "   Done."



# ------------------------------------------
# Now applying native-space atlas to CBF map
# ------------------------------------------

echo -n "Applying arterial territories atlas ..."

# parameters for subregions
pvcorr_folder=${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/native_space/pvcorr

pvcorr_CBF_GM=${pvcorr_folder}/perfusion_calib_GM_Jmod.nii.gz
pvcorr_CBF_WM=${pvcorr_folder}/perfusion_calib_WM_Jmod.nii.gz
pvcorr_CBF_global=${pvcorr_folder}/arterialTerr_Jmod/perfusion_calib_global_Jmod.nii.gz


# make a directory arterialTerr_Jmod for arterial 
# territories results
if [ -d "${pvcorr_folder}/arterialTerr_Jmod" ]; then
	rm -fr ${pvcorr_folder}/arterialTerr_Jmod
fi

mkdir ${pvcorr_folder}/arterialTerr_Jmod


# sum pvcorr/perfusion_calib_GM_Jmod with pvcorr/perfusion_calib_WM_Jmod
# to get pvcorr/arterialTerr_Jmod/perfusion_calib_global_Jmod
fslmaths ${pvcorr_CBF_GM} \
		 -add ${pvcorr_CBF_WM} \
		 ${pvcorr_CBF_global}


# apply mask
for i in $(seq 1 ${MaxInt})
do
	fslmaths ${pvcorr_CBF_GM} \
			 -mas ${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIart_native_mask_${i} \
			 ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerr_GM_${i}

	fslmaths ${pvcorr_CBF_WM} \
			 -mas ${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIart_native_mask_${i} \
			 ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerr_WM_${i}

	fslmaths ${pvcorr_CBF_global} \
			 -mas ${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIart_native_mask_${i} \
			 ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerr_global_${i}
done

for i in {1..3}
do
	fslmaths ${pvcorr_CBF_GM} \
			 -mas ${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIartAMP_native_mask_${i} \
			 ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerrAMP_GM_${i}

	fslmaths ${pvcorr_CBF_WM} \
			 -mas ${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIartAMP_native_mask_${i} \
			 ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerrAMP_WM_${i}

	fslmaths ${pvcorr_CBF_global} \
			 -mas ${studyFolder}/subjects/${ID}/Atlas/${ID}_nativeMNIartAMP_native_mask_${i} \
			 ${pvcorr_folder}/arterialTerr_Jmod/${ID}_CBF_MNIarterialTerrAMP_global_${i}
done

echo "   Done."

