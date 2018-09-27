#!/bin/bash

process_PASL(){

	ID=$1
	spm12path=$2
	studyFolder=$3

	indFolder=${studyFolder}/subjects/${ID}

	TI=$4
	bolus=$5
	BAT=$6
	slicedt=$7
	TR=$8
	TE=$9
	acq_order=${10}
	tr_slicedt_mode=${11}
	DICOM_path=${12}
	refTiss=${13}
	minTR=${14}


	ASLprocessing_FSL_folder=$(dirname "$0")
	Perfusion_folder=$(dirname "${ASLprocessing_FSL_folder}")
	CNSP_path=$(dirname "${Perfusion_folder}")


	echo "PASL processing (ID = ${ID}) ..."
	echo -n "Starts at " >> ${indFolder}/${ID}_logfile.txt
	date >> ${indFolder}/${ID}_logfile.txt

	# ============================================ #
	# whether automatically extract TR and slicedt #
	# ============================================ #
	if [ "${tr_slicedt_mode}" = "fix" ]; then
		echo "Fixed TR and slicedt"
	elif [ "${tr_slicedt_mode}" = "auto" ]; then
		echo "Automatically extracting TR and slicedt"

		if [ "${minTR}" = "" ]; then
			matlab -nodisplay -nosplash -nojvm -r "addpath('${ASLprocessing_FSL_folder}');\
												   ASLprocessing_FSL_getASLactTRandSlicedt ('${DICOM_path}',\
																							'${studyFolder}',\
																							'${ID}',\
																							'PASLwM0',\
																							'Y',\
																							'${TI}');\
													exit"
		else
			matlab -nodisplay -nosplash -nojvm -r "addpath('${ASLprocessing_FSL_folder}');\
												   ASLprocessing_FSL_getASLactTRandSlicedt ('${DICOM_path}',\
																							'${studyFolder}',\
																							'${ID}',\
																							'PASLwM0',\
																							'Y',\
																							'${TI}',\
																							'${minTR}');\
													exit"

		fi


			slicedt=`cat ${indFolder}/tr_slicedt.txt | awk -F',' '{print $2}' | tr -d '\n' | sed 's/ //g'`
			echo "slicedt was calculated as ${slicedt}"
		
	fi


	
	#################################################
	# Jiyang added code 1: realign raw ASL data     #
	#                                               #
	# Update 19/04/2018:                            #
	# Calling AAA_batch_realign_Jmod_function.m for #
	# the realignment.                              #
	#                                               #
	# Update 20/04/2018:                            #
	# Use the -mc flag available in new release,    #
	# which calls mcflirt.                          #
	#################################################

	# Realign all volumes
	# echo "Preprocessing (Realign all ASL volumes) ..."
	# echo "Preprocessing (Realign all ASL volumes)" >> ${indFolder}/${ID}_logfile.txt
	# echo "" >> ${indFolder}/${ID}_logfile.txt

	# Perfusion_folder=$(dirname "$(dirname "$0")")
	# ASLtbx2_Jmod_folder=${Perfusion_folder}/ASLtbx2_Jmod

	# gunzip ${PASL}
	# # matlab -nodisplay -nosplash -nojvm -r "addpath('${spm12path}');\
	# # 									   spm_realign('${indFolder}/${ID}_PASL.nii');\
	# # 									   exit" \
	# # 									   >> ${indFolder}/${ID}_logfile.txt

	# matlab -nodisplay -nosplash -nojvm -r "addpath ('${ASLtbx2_Jmod_folder}');\
	# 								   AAA_batch_realign_Jmod_function ('${spm12path}',\
	# 																	'${ID}',\
	# 																	'${indFolder}',\
	# 																	'PASL');\
	# 								   exit" \
	# 								   >> ${indFolder}/${ID}_logfile.txt
	
 #   	mv ${indFolder}/${ID}_PASL.nii ${indFolder}/${ID}_PASL_realigned.nii
	# mv ${indFolder}/r${ID}_PASL.nii ${indFolder}/${ID}_PASL.nii # now ID_PASL.nii is realigned and resliced.


	# gzip ${indFolder}/${ID}_PASL.nii


	# echo "###################################" >> ${indFolder}/${ID}_logfile.txt
	# echo "" >> ${indFolder}/${ID}_logfile.txt



	################################################
	# Step 1: use asl_file to process the raw data #
	################################################

	# echo "Step 1 : difference TC/CT pairs ..."
	# echo "Step 1 : difference TC/CT pairs" >> ${indFolder}/${ID}_logfile.txt
	# echo "" >> ${indFolder}/${ID}_logfile.txt

	# ${FSLDIR}/bin/asl_file \
	# 						--data=${indFolder}/${ID}_PASL \
	# 						--ntis=1 \
	# 						--iaf=${acq_order} \
	# 						--diff \
	# 						--out=${indFolder}/${ID}_PASL_diff \
	# 						--mean=${indFolder}/${ID}_PASL_diff_mean \
	# 						>> ${indFolder}/${ID}_logfile.txt

	# echo "###################################" >> ${indFolder}/${ID}_logfile.txt
	# echo "" >> ${indFolder}/${ID}_logfile.txt




	

	#####################################
	# use current version of oxford_asl #
	# to invert Kinetic model           #
	#####################################
	#
	#
	# ===========================================================
	# Update 18/04/2018
	# added --spatial for smoothing
	#       --fixbolus to turn off auto bolus duration estimation
	#		--pvcorr to conduct partial volume correction
	#		  removed --pvcorr due to inaccurate GM/WM segmentation
	#         NOTE: with --pvcorr, perfusion_calib is the CBF
	#               of GM only. perfusion_wm is the CBF of WM.
	#				Uncorrected CBF is not saved with --pvcorr.
	#
	# Update 20/04/2018
	# Use the latest version 3.9.13 downloaded from github
	# ===========================================================
	

	# ${FSLDIR}/bin/oxford_asl \
	# 						-i ${indFolder}/${ID}_PASL_diff \
	# 						-o ${indFolder}/${ID}_invKineticMdl_wT1 \
	# 						--tis ${TI} \
	# 						--bolus ${bolus} \
	# 						--bat ${BAT} \
	# 						--slicedt=${slicedt} \
	# 						-s ${indFolder}/${ID}_T1_brain \
	# 						-c ${indFolder}/${ID}_M0 \
	# 						--tr ${TR} \
	# 						--te ${TE} \
	# 						--csf ${indFolder}/${ID}_M0_ventricle \
	# 						--regfrom ${indFolder}/${ID}_M0_brain \
	# 						--report \
	# 						--spatial \
	# 						--fixbolus \
	# 						>> ${indFolder}/${ID}_logfile.txt

	Perfusion_folder=$(dirname "$(dirname "$0")")
	newOxfordAsl_folder=${Perfusion_folder}/oxford_asl_R3-9-13

	if [ "${refTiss}" = "ventricularCSF" ]; then
		${newOxfordAsl_folder}/oxford_asl \
									-i ${indFolder}/${ID}_PASL \
									--iaf ${acq_order} \
									--tis ${TI} \
									--artsupp \
									--bolus ${bolus} \
									--bat ${BAT} \
									--slicedt=${slicedt} \
									--fslanat=${indFolder}/${ID}_T1.anat \
									--sbrain ${indFolder}/${ID}_T1_brain \
									-c ${indFolder}/${ID}_M0 \
									--tr ${TR} \
									--cmethod single \
									--tissref csf \
									--csf ${indFolder}/${ID}_M0_ventricle \
									--te ${TE} \
									--fixbolus \
									--pvcorr \
									--spatial \
									--mc \
									-o ${indFolder}/${ID}_invKineticMdl_wT1 \
									>> ${indFolder}/${ID}_logfile.txt
	elif [ "${refTiss}" = "voxel" ]; then
		${newOxfordAsl_folder}/oxford_asl \
									-i ${indFolder}/${ID}_PASL \
									--iaf ${acq_order} \
									--tis ${TI} \
									--artsupp \
									--bolus ${bolus} \
									--bat ${BAT} \
									--slicedt=${slicedt} \
									--fslanat=${indFolder}/${ID}_T1.anat \
									--sbrain ${indFolder}/${ID}_T1_brain \
									-c ${indFolder}/${ID}_M0 \
									--tr ${TR} \
									--cmethod voxel \
									--te ${TE} \
									--fixbolus \
									--pvcorr \
									--spatial \
									--mc \
									--wp \
									-o ${indFolder}/${ID}_invKineticMdl_wT1 \
									>> ${indFolder}/${ID}_logfile.txt
	elif [ "${refTiss}" = "wm" ]; then
		${newOxfordAsl_folder}/oxford_asl \
									-i ${indFolder}/${ID}_PASL \
									--iaf ${acq_order} \
									--tis ${TI} \
									--artsupp \
									--bolus ${bolus} \
									--bat ${BAT} \
									--slicedt=${slicedt} \
									--fslanat=${indFolder}/${ID}_T1.anat \
									--sbrain ${indFolder}/${ID}_T1_brain \
									-c ${indFolder}/${ID}_M0 \
									--tr ${TR} \
									--cmethod single \
									--tissref wm \
									--te ${TE} \
									--fixbolus \
									--pvcorr \
									--spatial \
									--mc \
									-o ${indFolder}/${ID}_invKineticMdl_wT1 \
									>> ${indFolder}/${ID}_logfile.txt

	fi


	# if [ -d "${indFolder}/${ID}_invKineticMdl_wT1/struct_space_FSL" ]; then
	# 	rm -fr ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_FSL
	# fi
	# mv ${indFolder}/${ID}_invKineticMdl_wT1/struct_space ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_FSL

	echo "###################################" >> ${indFolder}/${ID}_logfile.txt
	echo "" >> ${indFolder}/${ID}_logfile.txt




	# ######################################################################
	# # FSL (oxford_asl) is not doing a good job on ASL-to-T1 registration #
	# # Use SPM to perform ASL-T1 registration                             #
	# ######################################################################

	# echo "Step 2.5 : map perfusion_calib from native space to T1 space (SPM) ..."
	# echo "Step 2.5 : map perfusion_calib from native space to T1 space (SPM)" >> ${indFolder}/${ID}_logfile.txt

	# if [ -d "${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM" ]; then
	# 	rm -fr ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM
	# fi
	# mkdir ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM
	# gunzip ${indFolder}/${ID}_invKineticMdl_wT1/native_space/perfusion.nii.gz
	# gunzip ${indFolder}/${ID}_invKineticMdl_wT1/native_space/perfusion_calib.nii.gz
	# gunzip ${indFolder}/${ID}_T1_brain.nii.gz

	# matlab -nodisplay -nosplash -nojvm -r "addpath('${CNSP_path}/Scripts','${spm12path}');\
	# 										CNSP_registration('${indFolder}/${ID}_invKineticMdl_wT1/native_space/perfusion.nii',\
	# 															'${indFolder}/${ID}_T1_brain.nii',\
	# 															'${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM',\
	# 															'',\
	# 															'Tri');\
	# 										CNSP_registration('${indFolder}/${ID}_invKineticMdl_wT1/native_space/perfusion_calib.nii',\
	# 															'${indFolder}/${ID}_T1_brain.nii',\
	# 															'${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM',\
	# 															'',\
	# 															'Tri');\
	# 										exit" \
	# 										>> ${indFolder}/${ID}_logfile.txt

	# gzip ${indFolder}/${ID}_invKineticMdl_wT1/native_space/perfusion.nii
	# gzip ${indFolder}/${ID}_invKineticMdl_wT1/native_space/perfusion_calib.nii
	# gzip ${indFolder}/${ID}_T1_brain.nii
	# gzip ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/rperfusion.nii
	# gzip ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/rperfusion_calib.nii

	# ${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/rperfusion \
	# 						-nan \
	# 						-thr 0 \
	# 						${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/perfusion

	# ${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/rperfusion_calib \
	# 						-nan \
	# 						-thr 0 \
	# 						${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/perfusion_calib
	
	# rm -f ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/rperfusion_calib.nii.gz
	# rm -f ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/rperfusion.nii.gz


	# # GM/WM segmentation
	# cp ${indFolder}/intermediateOutput/c1${ID}_T1.nii ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/GMmask.nii
	# cp ${indFolder}/intermediateOutput/c2${ID}_T1.nii ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/WMmask.nii

	
	# gunzip ${indFolder}/${ID}_M0_brain.nii.gz
	# gunzip ${indFolder}/${ID}_T1_brain.nii.gz

	# # NBTR meanID_pCASL
	# gunzip ${indFolder}/${ID}_T1.nii.gz

	# matlab -nodisplay -nosplash -nojvm -r "addpath('${CNSP_path}/Scripts','${spm12path}');\
	# 										CNSP_reverse_registration_wMx ('${indFolder}/mean${ID}_PASL.nii',\
	# 																		'${indFolder}/${ID}_T1.nii',\
	# 																		'${indFolder}/intermediateOutput/${ID}_T1_brainmask.nii');\
	# 										exit" \
	# 										>> ${indFolder}/${ID}_logfile.txt

	# gzip ${indFolder}/${ID}_T1.nii
	# gzip ${indFolder}/intermediateOutput/r${ID}_T1_brainmask.nii

	# mv ${indFolder}/intermediateOutput/r${ID}_T1_brainmask.nii.gz \
	# 	${indFolder}/mean${ID}_PASL_brainmask.nii.gz

	# ${FSLDIR}/bin/fslmaths ${indFolder}/mean${ID}_PASL_brainmask \
	# 						-nan \
	# 						${indFolder}/mean${ID}_PASL_brainmask

	# ${FSLDIR}/bin/fslmaths ${indFolder}/mean${ID}_PASL \
	# 						-mas ${indFolder}/mean${ID}_PASL_brainmask \
	# 						${indFolder}/mean${ID}_PASL_brain

	# gunzip ${indFolder}/mean${ID}_PASL_brain.nii.gz


	# # get ASL native space GM/WM masks
	# matlab -nodisplay -nosplash -nojvm -r "addpath('${CNSP_path}/Scripts','${spm12path}');\
	# 										CNSP_reverse_registration_wMx ('${indFolder}/mean${ID}_PASL_brain.nii',\
	# 																		'${indFolder}/${ID}_T1_brain.nii',\
	# 																		'${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/GMmask.nii',\
	# 																		'Tri');\
	# 										CNSP_reverse_registration_wMx ('${indFolder}/mean${ID}_PASL_brain.nii',\
	# 																		'${indFolder}/${ID}_T1_brain.nii',\
	# 																		'${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/WMmask.nii',\
	# 																		'Tri');\
	# 										exit" \
	# 										>> ${indFolder}/${ID}_logfile.txt

	# gzip ${indFolder}/${ID}_M0_brain.nii
	# gzip ${indFolder}/${ID}_T1_brain.nii

	# mv ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/rGMmask.nii \
	# 	${indFolder}/${ID}_invKineticMdl_wT1/native_space/GMmask_ASLspace.nii

	# gzip ${indFolder}/${ID}_invKineticMdl_wT1/native_space/GMmask_ASLspace.nii

	# mv ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/rWMmask.nii \
	# 	${indFolder}/${ID}_invKineticMdl_wT1/native_space/WMmask_ASLspace.nii

	# gzip ${indFolder}/${ID}_invKineticMdl_wT1/native_space/WMmask_ASLspace.nii



	# # mask GM/WM in ASL space
	# ${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_invKineticMdl_wT1/native_space/GMmask_ASLspace \
	# 					   -thr 0.3 \
	# 					   -bin \
	# 					   ${indFolder}/${ID}_invKineticMdl_wT1/native_space/GMmask_ASLspace
	# 					   # used 0.3 to threshold GM mask after visual inspection

	# ${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_invKineticMdl_wT1/native_space/WMmask_ASLspace \
	# 					   -thr 0.8 \
	# 					   -bin \
	# 					   ${indFolder}/${ID}_invKineticMdl_wT1/native_space/WMmask_ASLspace

	# ${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_invKineticMdl_wT1/native_space/perfusion_calib \
	# 					   -mas ${indFolder}/${ID}_invKineticMdl_wT1/native_space/GMmask_ASLspace \
	# 					   ${indFolder}/${ID}_invKineticMdl_wT1/native_space/perfusion_calib_GM

	# ${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_invKineticMdl_wT1/native_space/perfusion_calib \
	# 					   -mas ${indFolder}/${ID}_invKineticMdl_wT1/native_space/WMmask_ASLspace \
	# 					   ${indFolder}/${ID}_invKineticMdl_wT1/native_space/perfusion_calib_WM

	# gzip ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/GMmask.nii
	# gzip ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/WMmask.nii



	# # mask GM/WM in T1 space
	# ${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/GMmask \
	# 						-thr 0.8 \
	# 						-bin \
	# 						${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/GMmask

	# ${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/WMmask \
	# 						-thr 0.8 \
	# 						-bin \
	# 						${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/WMmask


	# ${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/perfusion_calib \
	# 						-mas ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/GMmask \
	# 						${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/perfusion_calib_GM

	# ${FSLDIR}/bin/fslmaths ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/perfusion_calib \
	# 						-mas ${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/WMmask \
	# 						${indFolder}/${ID}_invKineticMdl_wT1/struct_space_SPM/perfusion_calib_WM							

	# echo "###################################" >> ${indFolder}/${ID}_logfile.txt
	# echo "" >> ${indFolder}/${ID}_logfile.txt

	# echo "" >> ${indFolder}/${ID}_logfile.txt
	# echo -n "Finished at " >> ${indFolder}/${ID}_logfile.txt
	# date  >> ${indFolder}/${ID}_logfile.txt

}


# echo "#########################"
# echo "Single TI PASL processing"
# echo "#########################"

# echo "Please note that PASL and T1 have to be renamed as ID_PASLwM0.nii.gz and ID_T1.nii.gz"

# echo -n "START FROM "
# date

process_PASL $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14}

# echo -n "FINISHED AT "
# date
