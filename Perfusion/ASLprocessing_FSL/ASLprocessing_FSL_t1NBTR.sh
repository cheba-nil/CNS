#!/bin/bash

T1_NBTR(){
	
	ID=$1
	indFolder=$2
	CNSP_path=$3
	spm12path=$4

	gunzip ${indFolder}/${ID}_T1.nii.gz
	matlab -nodisplay -nosplash -nojvm -r "addpath('${CNSP_path}/Scripts');\
										   [cGM,cWM,cCSF,rcGM,rcWM,rcCSF]=CNSP_segmentation('${indFolder}/${ID}_T1.nii',\
										   													'${spm12path}');\
											CNSP_NBTRn('${indFolder}/${ID}_T1.nii',\
														cGM,\
														cWM,\
														cCSF,\
														'${indFolder}/${ID}_T1_brain');\
											exit" \
											>> ${indFolder}/${ID}_logfile.txt
	

	

	# cleanup c and rc images
	if [ -d "${indFolder}/intermediateOutput" ]; then
		rm -fr ${indFolder}/intermediateOutput
	fi
	mkdir ${indFolder}/intermediateOutput

	mv ${indFolder}/rc1${ID}_T1.nii \
	  ${indFolder}/rc2${ID}_T1.nii \
	  ${indFolder}/rc3${ID}_T1.nii \
	  ${indFolder}/c1${ID}_T1.nii \
	  ${indFolder}/c2${ID}_T1.nii \
	  ${indFolder}/c3${ID}_T1.nii \
	  ${indFolder}/${ID}_T1_seg8.mat \
	  ${indFolder}/intermediateOutput/.


}

T1_NBTR $1 $2 $3 $4