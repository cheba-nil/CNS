#!/bin/bash

preprocessingASL(){

	ID=$1
	indFolder=$2
	CNSP_path=$3
	spm12path=$4
	ASLtype=$5

	if [ -f "${indFolder}/${ID}_logfile.txt" ]; then
		rm -f ${indFolder}/${ID}_logfile.txt
	fi

	ASLprocessing_FSL_folder=$(dirname "$0")

	#########################
	# separate M0 from PASL #
	#########################

	if [ "${ASLtype}" = "PASLwM0" ]; then

		echo "Separate M0 from PASL, assuming the first volume is M0 (ID = ${ID}) ..."
		echo "Separate M0 from PASL, assuming the first volume is M0" >> ${indFolder}/${ID}_logfile.txt
		echo "" >> ${indFolder}/${ID}_logfile.txt


		${ASLprocessing_FSL_folder}/ASLprocessing_FSL_separateM0fromPASL.sh \
												${indFolder}/${ID}_PASLwM0.nii.gz

		M0=${indFolder}/${ID}_M0.nii.gz
		PASL=${indFolder}/${ID}_PASL.nii.gz

		echo "###################################" >> ${indFolder}/${ID}_logfile.txt
		echo "" >> ${indFolder}/${ID}_logfile.txt
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

	# # Realign all volumes
	# echo "Preprocessing (Realign all ASL volumes) ..."
	# echo "Preprocessing (Realign all ASL volumes)" >> ${indFolder}/${ID}_logfile.txt
	# echo "" >> ${indFolder}/${ID}_logfile.txt

	# Perfusion_folder=$(dirname "$(dirname "$0")")
	# ASLtbx2_Jmod_folder=${Perfusion_folder}/ASLtbx2_Jmod

	# gunzip ${indFolder}/${ID}_pCASL.nii.gz
	# # matlab -nodisplay -nosplash -nojvm -r "addpath('${spm12path}');\
	# # 									   spm_realign('${indFolder}/${ID}_pCASL.nii');\
	# # 									   exit" \
	# # 									   >> ${indFolder}/${ID}_logfile.txt

	# matlab -nodisplay -nosplash -nojvm -r "addpath ('${ASLtbx2_Jmod_folder}');\
	# 									   AAA_batch_realign_Jmod_function ('${spm12path}',\
	# 																		'${ID}',\
	# 																		'${indFolder}',\
	# 																		'pCASL');\
	# 									   exit" \
	# 									   >> ${indFolder}/${ID}_logfile.txt

	# mv ${indFolder}/${ID}_pCASL.nii ${indFolder}/${ID}_pCASL_realigned.nii
	# mv ${indFolder}/r${ID}_pCASL.nii ${indFolder}/${ID}_pCASL.nii # now ID_pCASL.nii is realigned and resliced.

	# gzip ${indFolder}/${ID}_pCASL.nii

	# echo "" >> ${indFolder}/${ID}_logfile.txt



	################################################
	# Step 1: use asl_file to process the raw data #
	################################################
	#
	# ASL data = indFolder/ID_pCASL.nii.gz
	# nubmer of TIs = 1
	# input ASL format = control-tag pairs
	# perform control-tag differencing for each control-tag pair
	# output with filename ID_pCASL_diff
	# average the difference across all repeats/pairs

	# echo "Step 1 : difference TC/CT pairs ..."
	# echo "Step 1 : difference TC/CT pairs" >> ${indFolder}/${ID}_logfile.txt
	# echo "" >> ${indFolder}/${ID}_logfile.txt

	# ${FSLDIR}/bin/asl_file \
	# 						--data=${indFolder}/${ID}_pCASL \
	# 						--ntis=1 \
	# 						--iaf=${acq_order} \
	# 						--diff \
	# 						--out=${indFolder}/${ID}_pCASL_diff \
	# 						--mean=${indFolder}/${ID}_pCASL_diff_mean \
	# 						>> ${indFolder}/${ID}_logfile.txt

	# echo "" >> ${indFolder}/${ID}_logfile.txt


	####################################
	# Step 2: invert the kinetic model #
	####################################
	#
	# ID_pCASL_diff - differenced data - as input
	# output folder = ID_Step2
	# TI = laballing time (1.8s) + post-labelling delay time (2s)
	# bolus (labelling time) = 1.8s
	# this example is a pCASL (therefore --casal)
	# bolus arrival time = 0.7 (for PASL), and 1.3 (for pCASL)
	# --wp : use white paper suggestions
	# TI = labelling time + post label delay time
	# time for each slice (slidedt) = TR - T1 / No_of_slices
	# --mc : motion correction via mcflirt
	# --tr : TR of calibration
	# --te : TE of calibration


	# echo "Step 2 : invert kinetic model (ASL space)" >> ${indFolder}/${ID}_logfile.txt
	# echo "" >> ${indFolder}/${ID}_logfile.txt
	# echo "Step 2 : invert kinetic model (ASL space) ..."

	# ${FSLDIR}/oxford_asl-3.9.6/oxford_asl \
	# 										-i ${indFolder}/${ID}_pCASL \
	# 										-o ${indFolder}/${ID}_Step2 \
	# 										--wp \
	# 										--iaf=ct \
	# 										--tis 3.8 \
	# 										--bolus 1.8 \
	# 										--casl \
	# 										--slicedt=0.0353125 \
	# 										-c ${indFolder}/${ID}_M0 \
	# 										--mc \
	# 										--tr 6.0 \
	# 										--te 12 \
	# 										>> ${indFolder}/${ID}_logfile.txt

	# echo "" >> ${indFolder}/${ID}_logfile.txt



	

	# ========================================== #
	# fsl_anat - for newer release of oxford_asl #
	# ========================================== #
	echo "performing fsl_anat, this will take a while (ID = ${ID}) ..."
	echo "fsl_anat : " >> ${indFolder}/${ID}_logfile.txt
	echo "" >> ${indFolder}/${ID}_logfile.txt


	${ASLprocessing_FSL_folder}/ASLprocessing_FSL_fsl-anat.sh \
															  ${ID} \
															  ${indFolder}



	echo "" >> ${indFolder}/${ID}_logfile.txt
	echo "" >> ${indFolder}/${ID}_logfile.txt







	# ======= #
	# T1 NBTR #
	# ======= #
	echo "T1 NBTR (ID = ${ID})..."
	echo "T1 NBTR" >> ${indFolder}/${ID}_logfile.txt


	${ASLprocessing_FSL_folder}/ASLprocessing_FSL_t1NBTR.sh \
															${ID} \
															${indFolder} \
															${CNSP_path} \
															${spm12path}

	echo "###################################" >> ${indFolder}/${ID}_logfile.txt
	echo "" >> ${indFolder}/${ID}_logfile.txt







	# ======= #
	# M0 NBTR #
	# ======= #

	echo "M0 NBTR (ID = ${ID}) ..."
	echo "M0 NBTR" >> ${indFolder}/${ID}_logfile.txt	

	
	${ASLprocessing_FSL_folder}/ASLprocessing_FSL_m0NBTR.sh \
															${ID} \
															${indFolder} \
															${CNSP_path} \
															${spm12path}


	echo "###################################" >> ${indFolder}/${ID}_logfile.txt
	echo "" >> ${indFolder}/${ID}_logfile.txt







	# ========================== #
	# segment M0 space ventricle #
	# ========================== #

	echo "Extract lateral ventricles from M0 (ID = ${ID}) ..."
	echo "Extract lateral ventricles from M0" >> ${indFolder}/${ID}_logfile.txt	


	${ASLprocessing_FSL_folder}/ASLprocessing_FSL_getM0ventricle.sh \
																	${ID} \
																	${indFolder} \
																	${CNSP_path} \
																	${spm12path}


	echo "###################################" >> ${indFolder}/${ID}_logfile.txt
	echo "" >> ${indFolder}/${ID}_logfile.txt


}


preprocessingASL $1 $2 $3 $4 $5