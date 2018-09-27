#!/bin/bash

# Warping other image in ref space to src space

# Notes:
# 	1) work on non-NBTR head, with brain mask passed as an argument.
# 	2) ref is MNI_T1_2mm
# 	3) other image in ref space should be 2mm in resolution, e.g. MNI 2mm atlases
#
# EXAMPLES FOR CHOOSING PARAMETERS:
# 	flirtSearchRange_start = flirtSearchRange_end = 0 and flirtDOF = 6 worked for OATS T1.


. ${FSLDIR}/etc/fslconf/fsl.sh

invWarping(){
	echo "CNSP_reverse_warping_wMx_FSLfnirt.sh: Started. This will take a while..."

	src=$1
	src_brainmask=$2
	other_inRefSpace=$3
	interpMethod=$4 #interpolation method {nn,trilinear,sinc,spline}
	flirtSearchRange_start=$5
	flirtSearchRange_end=$6
	flirtDOF=$7

	# use MNI_2mm_brain as ref
	ref="${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz"
	ref_mask="${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz"

	src_folder=$(dirname "${src}")
	src_filename=$(basename "${src}")
	src_filename=`echo ${src_filename} | awk -F'.nii.gz' '{print $1}'`
	other_inRefSpace_filename=$(basename "${other_inRefSpace}")
	other_inRefSpace_filename=`echo ${other_inRefSpace_filename} | awk -F'.nii.gz' '{print $1}'`
	

	# output intermediate results for checking
	if [ -d "${src_folder}/temp_CNSPrevWarping" ]; then
		rm -fr ${src_folder}/temp_CNSPrevWarping
	fi
	mkdir ${src_folder}/temp_CNSPrevWarping

	
	# get src_brain which is better input for flirt
	fslmaths ${src} \
			 -mas ${src_brainmask} \
			 ${src_folder}/temp_CNSPrevWarping/src_brain



	echo "CNSP_reverse_warping_wMx_FSLfnirt.sh: Intermediate output in ${src_folder}/temp_CNSPrevWarping for checking."

	echo "CNSP_reverse_warping_wMx_FSLfnirt.sh: Flirting ${src_filename} to MNI_2mm standard..."
	flirt -in ${src_folder}/temp_CNSPrevWarping/src_brain \
		  -ref ${ref} \
		  -out ${src_folder}/temp_CNSPrevWarping/flirt_src2ref \
		  -omat ${src_folder}/temp_CNSPrevWarping/flirt_src2ref.mat \
		  -dof ${flirtDOF} \
		  -searchrx ${flirtSearchRange_start} ${flirtSearchRange_end} \
		  -searchry ${flirtSearchRange_start} ${flirtSearchRange_end} \
		  -searchrz ${flirtSearchRange_start} ${flirtSearchRange_end}
		  # -interp trilinear
		  # -cost corratio \

	echo "CNSP_reverse_warping_wMx_FSLfnirt.sh: Fnirting ${src_filename} to MNI_2mm standard..."
	fnirt --in=${src} \
		  --aff=${src_folder}/temp_CNSPrevWarping/flirt_src2ref.mat \
		  --cout=${src_folder}/temp_CNSPrevWarping/fnirt_src2ref_cout \
		  --iout=${src_folder}/temp_CNSPrevWarping/fnirt_src2ref_iout \
		  --jout=${src_folder}/temp_CNSPrevWarping/fnirt_src2ref_jout \
		  --config=T1_2_MNI152_2mm \
		  --ref=${ref} \
	      --refmask=${ref_mask} \
	      --inmask=${src_brainmask} \
	      --applyrefmask=1 \
	      --applyinmask=1
	
	# inverse warping mtx
	echo "CNSP_reverse_warping_wMx_FSLfnirt.sh: Inverse warping ${other_inRefSpace_filename} to ${src_filename} space with reversed warping and affine mtx..."
	invwarp --warp=${src_folder}/temp_CNSPrevWarping/fnirt_src2ref_cout \
			--out=${src_folder}/temp_CNSPrevWarping/ref2src_invwarpcoef \
			--ref=${src}

	# # inverse registration mtx - invwarp alse reverse affine mtx, so no need for convert_xfm
	# convert_xfm -omat ${src_folder}/temp_CNSPrevWarping/flirt_ref2src.mat \
	# 			-inverse ${src_folder}/temp_CNSPrevWarping/flirt_src2ref.mat

	applywarp --in=${other_inRefSpace} \
			  --warp=${src_folder}/temp_CNSPrevWarping/ref2src_invwarpcoef \
			  --ref=${src} \
			  --mask=${src_brainmask} \
			  --out=${src_folder}/${other_inRefSpace_filename}_inverseXformed \
			  --interp=${interpMethod}

			  # it seems invwarp includes inversing affine (i.e. linear reg)
			  # --postmat=${src_folder}/temp_CNSPrevWarping/flirt_ref2src.mat \



	# --postmat in applywarp applies affine matrix after warping, so no need for this
	# flirt -applyxfm
	# flirt -in ${src_folder}/${other_inRefSpace_filename}_invwarped \
	# 	  -ref ${src} \
	# 	  -applyxfm \
	# 	  -init ${src_folder}/temp_CNSPrevWarping/flirt_ref2src.mat \
	# 	  -out ${src_folder}/${other_inRefSpace_filename}_invwarped_invreg

	echo "CNSP_reverse_warping_wMx_FSLfnirt.sh: Finished."
	echo "CNSP_reverse_warping_wMx_FSLfnirt.sh: ${src_folder}/${other_inRefSpace_filename}_inverseXformed.nii.gz"
}

invWarping $1 $2 $3 $4 $5 $6 $7