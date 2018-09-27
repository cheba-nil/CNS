#!/bin/bash

disp_usage(){
	echo ""
	echo "`basename "$0"`: Check the WMH extraction progress"
	echo ""
	echo "Usage: `basename "$0"` [option] [argument]"
	echo ""
	echo "            -s, --studyFolder      <study_folder>          Specify the study folder. Either -s or -c needs to be specified."
	echo "            -c, --currentFolder                            Working directory as study folder. Either -s or -c needs to be specified."
	echo "            --cross                                        For cross-sectional processing. Either --cross or --long needs to be specified."
	echo "            --long                                         For longitudinal processing. Either --cross or --long needs to be specified."
	echo ""
}


for arg in $@
do
	case "$arg" in
		-s | --studyFolder)
							if [ ! -z "$2" ]; then
								studyFolder=$2
								shift 2
							else
								disp_usage
								exit 1
							fi
							
							;;

		-c | --currentFolder)
							studyFolder=`pwd`
							shift 1
							;;

		--cross)
							studyType="cross"
							shift 1
							;;

		--long)
							studyType="long"
							shift 1
							;;

		-*)
							disp_usage
							exit 1
							;;
	esac
done

if [ "${studyType}" != "cross" ] && [ "${studyType}" != "long" ]; then
	disp_usage
	exit 1
fi

# if [ $# -eq 3 ] && ([ "$1" = "-s" ] || [ "$1" = "--studyFolder" ]) && [ ! -z "$2" ]; then

# 	studyFolder=$2
	
# elif [ $# -eq 1 ] && ([ "$1" = "-c" ] || [ "$1" = "--currentFolder" ]); then

# 	studyFolder=`pwd`

# else

# 	disp_usage
# 	exit 1
# fi

echo ""
echo "study folder = ${studyFolder}"
echo "Please wait ..."

totalN=`find ${studyFolder}/originalImg/T1 -maxdepth 1 -name "*.nii" | wc -l | awk '{print $1}'`


# subjects/coregQCfailure
if [ -d "${studyFolder}/subjects/coregQCfailure" ]; then
	N_coregFailure=`find ${studyFolder}/subjects/coregQCfailure -maxdepth 1 -type d | wc | awk '{print $1}'`
	N_coregFailure=`bc <<< "${N_coregFailure} - 1"` # ignore the base folder
else
	N_coregFailure=0
fi

# subjects/segQCfailure
if [ -d "${studyFolder}/subjects/segQCfailure" ]; then
	N_segFailure=`find ${studyFolder}/subjects/segQCfailure -maxdepth 1 -type d | wc | awk '{print $1}'`
	N_segFailure=`bc <<< "${N_segFailure} - 1"`
else
	N_segFailure=0
fi

# subjects/ID/mri/preprocessing/rFLAIR
N_rFLAIR=0
N_wrFLAIR=0
N_NBTRwrFLAIR=0
N_FLAIRrestore=0
N_c3T1=0
N_u_rc1T1=0
N_accCSF_seg2=0
N_availWMH=0
N_stats=0


for flair_path in `ls ${studyFolder}/originalImg/FLAIR/*.nii`
do
	flair_imgname=`basename ${flair_path}`
	flair_filename=`basename ${flair_path} .nii`

	if [ "${studyType}" = "cross" ]; then
		ID=`echo ${flair_filename} | awk -F'_' '{print $1}'`
	elif [ "${studyType}" = "long" ]; then
		subjID=`echo ${flair_filename} | awk -F'_' '{print $1}'`
		tpID=`echo ${flair_filename} | awk -F'_' '{print $2}'`
		ID="${subjID}_${tpID}"
	fi

	# subjects/ID/mri/preprocessing/rFLAIR
	if [ -d "${studyFolder}/subjects/${ID}/mri/preprocessing" ] && [ $(find ${studyFolder}/subjects/${ID}/mri/preprocessing -name "r${flair_imgname}") ] ; then
		N_rFLAIR=`bc <<< "${N_rFLAIR} + 1"`
	fi

	# subjects/ID/mri/preprocessing/wrFLAIR
	if [ -d "${studyFolder}/subjects/${ID}/mri/preprocessing" ] && [ $(find ${studyFolder}/subjects/${ID}/mri/preprocessing -name "wr${flair_imgname}") ] ; then
		N_wrFLAIR=`bc <<< "${N_wrFLAIR} + 1"`
	fi

	# subjects/ID/mri/preprocessing/nonBrainRemoved_wrFLAIR
	if [ -d "${studyFolder}/subjects/${ID}/mri/preprocessing" ] && [ $(find ${studyFolder}/subjects/${ID}/mri/preprocessing -name "nonBrainRemoved_wr${flair_imgname}*") ] ; then
		N_NBTRwrFLAIR=`bc <<< "${N_NBTRwrFLAIR} + 1"`
	fi

	# subjects/ID/mri/preprocessing/FAST_nonBrainRemoved_wrFLAIR_restore.nii*
	if [ -d "${studyFolder}/subjects/${ID}/mri/preprocessing" ] && [ $(find ${studyFolder}/subjects/${ID}/mri/preprocessing -name "FAST_nonBrainRemoved_wr${flair_filename}_restore.nii*") ] ; then
		N_FLAIRrestore=`bc <<< "${N_FLAIRrestore} + 1"`
	fi
done


for T1_path in `ls ${studyFolder}/originalImg/T1/*.nii`
do
	T1_imgname=`basename ${T1_path}`
	T1_filename=`basename ${T1_path} .nii`

	if [ "${studyType}" = "cross" ]; then
		ID=`echo ${T1_filename} | awk -F'_' '{print $1}'`
	elif [ "${studyType}" = "long" ]; then
		subjID=`echo ${T1_filename} | awk -F'_' '{print $1}'`
		tpID=`echo ${T1_filename} | awk -F'_' '{print $2}'`
		ID="${subjID}_${tpID}"
	fi

	# subjects/ID/mri/preprocessing/c3T1
	# if [ -d "${studyFolder}/subjects/${ID}/mri/preprocessing" ] && [ $(find ${studyFolder}/subjects/${ID}/mri/preprocessing -name "c3*") ]; then
	if [ -d "${studyFolder}/subjects/${ID}/mri/preprocessing" ] && [ $(find ${studyFolder}/subjects/${ID}/mri/preprocessing -name "c3${T1_imgname}") ]; then
		N_c3T1=`bc <<< "${N_c3T1} + 1"`
	fi

	# subjects/ID/mri/preprocessing/u_rc1*
	if [ -d "${studyFolder}/subjects/${ID}/mri/preprocessing" ] && [ $(find ${studyFolder}/subjects/${ID}/mri/preprocessing -name "u_rc1*.nii") ]; then
		N_u_rc1T1=`bc <<< "${N_u_rc1T1} + 1"`
	fi

	# subjects/ID/mri/kNN_intermediateOutput/ID_accurateCSFmasked_seg2.nii*
	if [ -d "${studyFolder}/subjects/${ID}/mri/kNN_intermediateOutput" ] && [ $(find ${studyFolder}/subjects/${ID}/mri/kNN_intermediateOutput -name "${ID}_accurateCSFmasked_seg2.nii*") ]; then
		N_accCSF_seg2=`bc <<< "${N_accCSF_seg2} + 1"`
	fi

	# subjects/ID/mri/extractedWMH/ID_WMH_Prob0_??.nii*
	if [ -d "${studyFolder}/subjects/${ID}/mri/extractedWMH" ] && [ $(find ${studyFolder}/subjects/${ID}/mri/extractedWMH -name "${ID}_WMH_Prob0_??.nii*") ]; then
		N_availWMH=`bc <<< "${N_availWMH} + 1"`
	fi

	# subjects/ID/stats/ID_WMH_stats.txt
	if [ -d "${studyFolder}/subjects/${ID}/stats" ] && [ $(find ${studyFolder}/subjects/${ID}/stats -name "${ID}_WMH_NoI.txt") ]; then
		N_stats=`bc <<< "${N_stats} + 1"`
	fi

done
# N_c3T1_plus_segFailure=`bc <<< "${N_c3T1} + ${N_segFailure}"`

# subjects/ID/mri/preprocessing/u_rc1*
# N_u_rc1T1=0
# for T1_path in `ls ${studyFolder}/originalImg/T1/*.nii`
# do
# 	T1_imgname=`basename ${T1_path}`
# 	T1_filename=`basename ${T1_path} .nii`
# 	ID=`echo ${T1_filename} | awk -F'_' '{print $1}'`

# 	if [ $(find ${studyFolder}/subjects/*/mri/preprocessing -name "u_rc1*.nii") ]; then
# 		N_u_rc1T1=`bc <<< "${N_u_rc1T1} + 1"`
# 	fi
# done
# N_u_rc1=`find ${studyFolder}/subjects/*/mri/preprocessing -name "u_rc1*.nii" | wc | awk '{print $1}'`
# N_u_rc1_plus_Failure=`bc <<< "${N_u_rc1} + ${N_coregFailure} + ${N_segFailure}"`

# subjects/ID/mri/preprocessing/wrFLAIR
# N_wrFLAIR=0
# for flair_path in `ls ${studyFolder}/originalImg/FLAIR/*.nii`
# do
# 	flair_imgname=`basename ${flair_path}`
# 	flair_filename=`basename ${flair_path} .nii`
# 	ID=`echo ${flair_filename} | awk -F'_' '{print $1}'`

# 	if [ $(find ${studyFolder}/subjects/${ID}/mri/preprocessing -name "wr${flair_imgname}") ] ; then
# 		N_wrFLAIR=`bc <<< "${N_wrFLAIR} + 1"`
# 	fi
# done
# N_wrFLAIR_plus_Failure=`bc <<< "${N_wrFLAIR} + ${N_coregFailure} + ${N_segFailure}"`


# subjects/ID/mri/preprocessing/nonBrainRemoved_wrFLAIR
# N_NBTRwrFLAIR=0
# for flair_path in `ls ${studyFolder}/originalImg/FLAIR/*.nii`
# do
# 	flair_imgname=`basename ${flair_path}`
# 	flair_filename=`basename ${flair_path} .nii`
# 	ID=`echo ${flair_filename} | awk -F'_' '{print $1}'`

# 	if [ $(find ${studyFolder}/subjects/${ID}/mri/preprocessing -name "nonBrainRemoved_wr${flair_imgname}*") ] ; then
# 		N_NBTRwrFLAIR=`bc <<< "${N_NBTRwrFLAIR} + 1"`
# 	fi
# done
# N_NBTRwrFLAIR_plus_Failure=`bc <<< "${N_NBTRwrFLAIR} + ${N_coregFailure} + ${N_segFailure}"`


# subjects/ID/mri/preprocessing/FAST_nonBrainRemoved_wrFLAIR_restore.nii*
# N_FLAIRrestore=0
# for flair_path in `ls ${studyFolder}/originalImg/FLAIR/*.nii`
# do
# 	flair_imgname=`basename ${flair_path}`
# 	flair_filename=`basename ${flair_path} .nii`
# 	ID=`echo ${flair_filename} | awk -F'_' '{print $1}'`

# 	if [ $(find ${studyFolder}/subjects/${ID}/mri/preprocessing -name "FAST_nonBrainRemoved_wr${flair_filename}_restore.nii*") ] ; then
# 		N_FLAIRrestore=`bc <<< "${N_FLAIRrestore} + 1"`
# 	fi
# done
# N_FLAIRrestore=`find ${studyFolder}/subjects/*/mri/preprocessing -name "*restore.nii*" | wc | awk '{print $1}'`
# N_FLAIRrestore_plus_Failure=`bc <<< "${N_FLAIRrestore} + ${N_coregFailure} + ${N_segFailure}"`






# N_accCSF_seg2=`find ${studyFolder}/subjects/*/mri/kNN_intermediateOutput -name "*_accurateCSFmasked_seg2.nii*" | wc | awk '{print $1}'`
# N_accCSF_seg2_plus_Failure=`bc <<< "${N_accCSF_seg2} + ${N_coregFailure} + ${N_segFailure}"`


# sujects/ID/mri/extractedWMH/ID_WMH.nii*
# N_availWMH=`find ${studyFolder}/subjects/*/mri/extractedWMH -maxdepth 1 -name "*_WMH_Prob0_*.nii*" | wc | awk '{print $1}'`
# N_availWMH_plus_Failure=`bc <<< "${N_availWMH} + ${N_coregFailure} + ${N_segFailure}"`


# subjects/ID/stats/*_WMH_stats.txt
# N_stats=`find ${studyFolder}/subjects/*/stats -name "*_WMH_stats.txt" | wc | awk '{print $1}'`
# N_stats_plus_Failure=`bc <<< "${N_stats} + ${N_coregFailure} + ${N_segFailure}"`


# Display
echo ""
date
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

# if [ $((${N_rFLAIR})) -eq $((${totalN})) ]; then
# 	echo "Coregistration:		${N_rFLAIR} / ${totalN}	(Finished.)"
# else
	echo "Coregistration:		${N_rFLAIR} / ${totalN}	(N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# fi

# if [ $((${N_c3T1_plus_segFailure})) -eq $((${totalN})) ]; then
# 	echo "Segmentation:		${N_c3T1} / ${totalN}	(Finished. N_coregFailure = ${N_coregFailure})"
# else
	echo "Segmentation:		${N_c3T1} / ${totalN}	(N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# fi

# if [ $((${N_u_rc1_plus_Failure})) -eq $((${totalN})) ]; then
# 	echo "Run DARTEL:		${N_u_rc1} / ${totalN}	(Finished. N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# else
	echo "Run DARTEL:		${N_u_rc1T1} / ${totalN}	(N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# fi

# if [ $((${N_wrFLAIR_plus_Failure})) -eq $((${totalN})) ]; then
# 	echo "Map to DARTEL:		${N_wrFLAIR} / ${totalN}	(Finished. N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# else
	echo "Map to DARTEL:		${N_wrFLAIR} / ${totalN}	(N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# fi

# if [ $((${N_NBTRwrFLAIR_plus_Failure})) -eq $((${totalN})) ]; then
# 	echo "Skull strip:		${N_NBTRwrFLAIR} / ${totalN}	(Finished. N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# else
	echo "Skull strip:		${N_NBTRwrFLAIR} / ${totalN}	(N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# fi

# if [ $((${N_FLAIRrestore_plus_Failure})) -eq $((${totalN})) ]; then
# 	echo "FSL FAST:		${N_FLAIRrestore} / ${totalN}	(Finished. N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# else
	echo "FSL FAST:		${N_FLAIRrestore} / ${totalN}	(N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# fi

# if [ $((${N_accCSF_seg2_plus_Failure})) -eq $((${totalN})) ]; then
# 	echo "kNN preparation:	${N_accCSF_seg2} / ${totalN}	(Finished. N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# else
	echo "kNN preparation:	${N_accCSF_seg2} / ${totalN}	(N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# fi

# if [ $((${N_availWMH_plus_Failure})) -eq $((${totalN})) ]; then
# 	echo "WMH extraction:		${N_availWMH} / ${totalN}	(Finished. N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# else
	echo "WMH extraction:		${N_availWMH} / ${totalN}	(N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# fi

# if [ $((${N_stats_plus_Failure})) -eq $((${totalN})) ]; then
# 	echo "Completed:		${N_stats} / ${totalN}	(Finished. N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# else
	echo "Completed:		${N_stats} / ${totalN}	(N_coregFailure = ${N_coregFailure}; N_segFailure = ${N_segFailure})"
# fi

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"