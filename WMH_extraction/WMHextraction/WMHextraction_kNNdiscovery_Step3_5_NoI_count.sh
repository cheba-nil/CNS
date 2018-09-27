#!/bin/bash

# count number of WMH incidences basec on intensity-weighted center of gravity

NoC_count(){

	studyFolder=$1
	ID=$2
	pipelinePath=$3
	PVmag=$4

	echo "UBO Detector: Counting number of WMH incidences for ID ${ID}. Please wait ..."

	punctuateClusterSize=3
	focalClusterSize=9
	mediumClusterSize=15
	# confluent cluster size is above 15 voxels

	flairImg=`ls ${studyFolder}/originalImg/FLAIR/${ID}_*.nii`
	flair_filename=`echo $(basename ${flairImg}) | awk -F'.' '{print $1}'`

	# generate WMH masked FLAIR image
	${FSLDIR}/bin/fslmaths ${studyFolder}/subjects/${ID}/mri/extractedWMH/${ID}_WMH \
							-mul ${studyFolder}/subjects/${ID}/mri/preprocessing/wr${flair_filename} \
							-thr 0 \
							${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR




	# merge PVWMH mask with lobar template
	${FSLDIR}/bin/fslmaths ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/periventricle_mask_${PVmag} \
							-bin \
							-mul 20 \
							${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/periventricle_mask_${PVmag}_mul20

	${FSLDIR}/bin/fslmaths ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/periventricle_mask_${PVmag} \
							-binv \
							-mul $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_lobar_template \
							-add ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/periventricle_mask_${PVmag}_mul20 \
							${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/lobar_map_with_PVmag${PVmag}_periventricle

	# min of WMH masked FLAIR
	WMHonFLAIR_min=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR -l 0 -R | awk '{print $1}'`

	# clusterise
	${FSLDIR}/bin/cluster -i ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR \
							-t ${WMHonFLAIR_min} \
							--connectivity=18 \
							--oindex=${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_index \
							> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary.txt

	# generate ROI with each COG, get corresponding intensity on lobar mask
	if [ -f "${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt" ]; then
		rm -f ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt
	fi

	N_Lfrontal_cluster=0
	N_Lfrontal_cluster_punctuate=0
	N_Lfrontal_cluster_focal=0
	N_Lfrontal_cluster_medium=0
	N_Lfrontal_cluster_confluent=0

	N_Rfrontal_cluster=0
	N_Rfrontal_cluster_punctuate=0
	N_Rfrontal_cluster_focal=0
	N_Rfrontal_cluster_medium=0
	N_Rfrontal_cluster_confluent=0

	N_Ltemporal_cluster=0
	N_Ltemporal_cluster_punctuate=0
	N_Ltemporal_cluster_focal=0
	N_Ltemporal_cluster_medium=0
	N_Ltemporal_cluster_confluent=0

	N_Rtemporal_cluster=0
	N_Rtemporal_cluster_punctuate=0
	N_Rtemporal_cluster_focal=0
	N_Rtemporal_cluster_medium=0
	N_Rtemporal_cluster_confluent=0

	N_Lparietal_cluster=0
	N_Lparietal_cluster_punctuate=0
	N_Lparietal_cluster_focal=0
	N_Lparietal_cluster_medium=0
	N_Lparietal_cluster_confluent=0

	N_Rparietal_cluster=0
	N_Rparietal_cluster_punctuate=0
	N_Rparietal_cluster_focal=0
	N_Rparietal_cluster_medium=0
	N_Rparietal_cluster_confluent=0

	N_Loccipital_cluster=0
	N_Loccipital_cluster_punctuate=0
	N_Loccipital_cluster_focal=0
	N_Loccipital_cluster_medium=0
	N_Loccipital_cluster_confluent=0

	N_Roccipital_cluster=0
	N_Roccipital_cluster_punctuate=0
	N_Roccipital_cluster_focal=0
	N_Roccipital_cluster_medium=0
	N_Roccipital_cluster_confluent=0

	N_Lcerebellum_cluster=0
	N_Lcerebellum_cluster_punctuate=0
	N_Lcerebellum_cluster_focal=0
	N_Lcerebellum_cluster_medium=0
	N_Lcerebellum_cluster_confluent=0

	N_Rcerebellum_cluster=0
	N_Rcerebellum_cluster_punctuate=0
	N_Rcerebellum_cluster_focal=0
	N_Rcerebellum_cluster_medium=0
	N_Rcerebellum_cluster_confluent=0

	N_Brainstem_cluster=0
	N_Brainstem_cluster_punctuate=0
	N_Brainstem_cluster_focal=0
	N_Brainstem_cluster_medium=0
	N_Brainstem_cluster_confluent=0

	N_Periventricle_cluster=0
	N_Periventricle_cluster_punctuate=0
	N_Periventricle_cluster_focal=0
	N_Periventricle_cluster_medium=0
	N_Periventricle_cluster_confluent=0	

	N_rAAH_cluster=0
	N_rAAH_cluster_punctuate=0
	N_rAAH_cluster_focal=0
	N_rAAH_cluster_medium=0
	N_rAAH_cluster_confluent=0

	N_lAAH_cluster=0
	N_lAAH_cluster_punctuate=0
	N_lAAH_cluster_focal=0
	N_lAAH_cluster_medium=0
	N_lAAH_cluster_confluent=0

	N_rMAH_cluster=0
	N_rMAH_cluster_punctuate=0
	N_rMAH_cluster_focal=0
	N_rMAH_cluster_medium=0
	N_rMAH_cluster_confluent=0

	N_lMAH_cluster=0
	N_lMAH_cluster_punctuate=0
	N_lMAH_cluster_focal=0
	N_lMAH_cluster_medium=0
	N_lMAH_cluster_confluent=0

	N_rAAML_cluster=0
	N_rAAML_cluster_punctuate=0
	N_rAAML_cluster_focal=0
	N_rAAML_cluster_medium=0
	N_rAAML_cluster_confluent=0

	N_lAAML_cluster=0
	N_lAAML_cluster_punctuate=0
	N_lAAML_cluster_focal=0
	N_lAAML_cluster_medium=0
	N_lAAML_cluster_confluent=0

	N_rAAC_cluster=0
	N_rAAC_cluster_punctuate=0
	N_rAAC_cluster_focal=0
	N_rAAC_cluster_medium=0
	N_rAAC_cluster_confluent=0

	N_lAAC_cluster=0
	N_lAAC_cluster_punctuate=0
	N_lAAC_cluster_focal=0
	N_lAAC_cluster_medium=0
	N_lAAC_cluster_confluent=0

	N_rMALL_cluster=0
	N_rMALL_cluster_punctuate=0
	N_rMALL_cluster_focal=0
	N_rMALL_cluster_medium=0
	N_rMALL_cluster_confluent=0

	N_lMALL_cluster=0
	N_lMALL_cluster_punctuate=0
	N_lMALL_cluster_focal=0
	N_lMALL_cluster_medium=0
	N_lMALL_cluster_confluent=0

	N_rPATMP_cluster=0
	N_rPATMP_cluster_punctuate=0
	N_rPATMP_cluster_focal=0
	N_rPATMP_cluster_medium=0
	N_rPATMP_cluster_confluent=0

	N_lPATMP_cluster=0
	N_lPATMP_cluster_punctuate=0
	N_lPATMP_cluster_focal=0
	N_lPATMP_cluster_medium=0
	N_lPATMP_cluster_confluent=0

	N_rPAH_cluster=0
	N_rPAH_cluster_punctuate=0
	N_rPAH_cluster_focal=0
	N_rPAH_cluster_medium=0
	N_rPAH_cluster_confluent=0

	N_lPAH_cluster=0
	N_lPAH_cluster_punctuate=0
	N_lPAH_cluster_focal=0
	N_lPAH_cluster_medium=0
	N_lPAH_cluster_confluent=0

	N_rPAC_cluster=0
	N_rPAC_cluster_punctuate=0
	N_rPAC_cluster_focal=0
	N_rPAC_cluster_medium=0
	N_rPAC_cluster_confluent=0

	N_lPAC_cluster=0
	N_lPAC_cluster_punctuate=0
	N_lPAC_cluster_focal=0
	N_lPAC_cluster_medium=0
	N_lPAC_cluster_confluent=0

	echo "clusterInd,Nvoxels,MAX,MAX_x_vox,MAX_y_vox,MAX_z_vox,COG_x_vox,COG_y_vox,COG_z_vox,COG_int_on_lobar_mask,COG_int_on_arterial_mask" \
			> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt

	# remove title
	sed 1d ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary.txt \
		> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_noTitle.txt

	while read cl
	do
		clusterInd=`echo $cl | awk '{print $1}'`
		clusterSize=`echo $cl | awk '{print $2}'`
		cog_x=`echo $cl | awk '{print $7}'`
		cog_y=`echo $cl | awk '{print $8}'`
		cog_z=`echo $cl | awk '{print $9}'`

		${FSLDIR}/bin/fslmaths ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/lobar_map_with_PVmag${PVmag}_periventricle \
								-roi ${cog_x} 1 ${cog_y} 1 ${cog_z} 1 0 1 \
								${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonLobTem \
								-odt int

		${FSLDIR}/bin/fslmaths $(dirname ${pipelinePath})/Templates/DARTEL_lobar_and_arterial_templates/DARTEL_arterial_template \
								-roi ${cog_x} 1 ${cog_y} 1 ${cog_z} 1 0 1 \
								${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonArtTem \
								-odt int

		cogIntensityOnLobarMask=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonLobTem -R | awk '{print $2}'`
		cogIntensityOnArterialMask=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonArtTem -R | awk '{print $2}'`

		# float to int
		cogIntensityOnLobarMask=`printf "%.0f\n" "${cogIntensityOnLobarMask}"`
		cogIntensityOnArterialMask=`printf "%.0f\n" "${cogIntensityOnArterialMask}"`

		rm -f ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonLobTem.nii*
		rm -f ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_cl${clusterInd}_COGonArtTem.nii*


		## Count lobar NoC
		
		if [ "${cogIntensityOnLobarMask}" -eq 7 ]; then
			N_Lfrontal_cluster=$((${N_Lfrontal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Lfrontal_cluster_punctuate=$((${N_Lfrontal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Lfrontal_cluster_focal=$((${N_Lfrontal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Lfrontal_cluster_medium=$((${N_Lfrontal_cluster_medium} + 1))
			else
				N_Lfrontal_cluster_confluent=$((${N_Lfrontal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 6 ]; then
			N_Rfrontal_cluster=$((${N_Rfrontal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Rfrontal_cluster_punctuate=$((${N_Rfrontal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Rfrontal_cluster_focal=$((${N_Rfrontal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Rfrontal_cluster_medium=$((${N_Rfrontal_cluster_medium} + 1))
			else
				N_Rfrontal_cluster_confluent=$((${N_Rfrontal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 4 ]; then
			N_Ltemporal_cluster=$((${N_Ltemporal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Ltemporal_cluster_punctuate=$((${N_Ltemporal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Ltemporal_cluster_focal=$((${N_Ltemporal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Ltemporal_cluster_medium=$((${N_Ltemporal_cluster_medium} + 1))
			else
				N_Ltemporal_cluster_confluent=$((${N_Ltemporal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 5 ]; then
			N_Rtemporal_cluster=$((${N_Rtemporal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Rtemporal_cluster_punctuate=$((${N_Rtemporal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Rtemporal_cluster_focal=$((${N_Rtemporal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Rtemporal_cluster_medium=$((${N_Rtemporal_cluster_medium} + 1))
			else
				N_Rtemporal_cluster_confluent=$((${N_Rtemporal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 17 ]; then
			N_Lparietal_cluster=$((${N_Lparietal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Lparietal_cluster_punctuate=$((${N_Lparietal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Lparietal_cluster_focal=$((${N_Lparietal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Lparietal_cluster_medium=$((${N_Lparietal_cluster_medium} + 1))
			else
				N_Lparietal_cluster_confluent=$((${N_Lparietal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 16 ]; then
			N_Rparietal_cluster=$((${N_Rparietal_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Rparietal_cluster_punctuate=$((${N_Rparietal_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Rparietal_cluster_focal=$((${N_Rparietal_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Rparietal_cluster_medium=$((${N_Rparietal_cluster_medium} + 1))
			else
				N_Rparietal_cluster_confluent=$((${N_Rparietal_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 12 ]; then
			N_Loccipital_cluster=$((${N_Loccipital_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Loccipital_cluster_punctuate=$((${N_Loccipital_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Loccipital_cluster_focal=$((${N_Loccipital_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Loccipital_cluster_medium=$((${N_Loccipital_cluster_medium} + 1))
			else
				N_Loccipital_cluster_confluent=$((${N_Loccipital_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 11 ]; then
			N_Roccipital_cluster=$((${N_Roccipital_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Roccipital_cluster_punctuate=$((${N_Roccipital_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Roccipital_cluster_focal=$((${N_Roccipital_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Roccipital_cluster_medium=$((${N_Roccipital_cluster_medium} + 1))
			else
				N_Roccipital_cluster_confluent=$((${N_Roccipital_cluster_confluent} + 1))
			fi					
		elif [ "${cogIntensityOnLobarMask}" -eq 2 ]; then
			N_Lcerebellum_cluster=$((${N_Lcerebellum_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Lcerebellum_cluster_punctuate=$((${N_Lcerebellum_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Lcerebellum_cluster_focal=$((${N_Lcerebellum_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Lcerebellum_cluster_medium=$((${N_Lcerebellum_cluster_medium} + 1))
			else
				N_Lcerebellum_cluster_confluent=$((${N_Lcerebellum_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 1 ]; then
			N_Rcerebellum_cluster=$((${N_Rcerebellum_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Rcerebellum_cluster_punctuate=$((${N_Rcerebellum_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Rcerebellum_cluster_focal=$((${N_Rcerebellum_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Rcerebellum_cluster_medium=$((${N_Rcerebellum_cluster_medium} + 1))
			else
				N_Rcerebellum_cluster_confluent=$((${N_Rcerebellum_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 3 ]; then
			N_Brainstem_cluster=$((${N_Brainstem_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Brainstem_cluster_punctuate=$((${N_Brainstem_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Brainstem_cluster_focal=$((${N_Brainstem_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Brainstem_cluster_medium=$((${N_Brainstem_cluster_medium} + 1))
			else
				N_Brainstem_cluster_confluent=$((${N_Brainstem_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnLobarMask}" -eq 20 ]; then
			N_Periventricle_cluster=$((${N_Periventricle_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_Periventricle_cluster_punctuate=$((${N_Periventricle_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_Periventricle_cluster_focal=$((${N_Periventricle_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_Periventricle_cluster_medium=$((${N_Periventricle_cluster_medium} + 1))
			else
				N_Periventricle_cluster_confluent=$((${N_Periventricle_cluster_confluent} + 1))
			fi
		fi


		



		## Count arterial NoC

		if [ "${cogIntensityOnArterialMask}" -eq 1 ]; then
			N_rAAH_cluster=$((${N_rAAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rAAH_cluster_punctuate=$((${N_rAAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rAAH_cluster_focal=$((${N_rAAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rAAH_cluster_medium=$((${N_rAAH_cluster_medium} + 1))
			else
				N_rAAH_cluster_confluent=$((${N_rAAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 2 ]; then
			N_lAAH_cluster=$((${N_lAAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lAAH_cluster_punctuate=$((${N_lAAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lAAH_cluster_focal=$((${N_lAAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lAAH_cluster_medium=$((${N_lAAH_cluster_medium} + 1))
			else
				N_lAAH_cluster_confluent=$((${N_lAAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 3 ]; then
			N_rMAH_cluster=$((${N_rMAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rMAH_cluster_punctuate=$((${N_rMAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rMAH_cluster_focal=$((${N_rMAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rMAH_cluster_medium=$((${N_rMAH_cluster_medium} + 1))
			else
				N_rMAH_cluster_confluent=$((${N_rMAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 6 ]; then
			N_lMAH_cluster=$((${N_lMAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lMAH_cluster_punctuate=$((${N_lMAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lMAH_cluster_focal=$((${N_lMAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lMAH_cluster_medium=$((${N_lMAH_cluster_medium} + 1))
			else
				N_lMAH_cluster_confluent=$((${N_lMAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 13 ]; then
			N_rAAML_cluster=$((${N_rAAML_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rAAML_cluster_punctuate=$((${N_rAAML_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rAAML_cluster_focal=$((${N_rAAML_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rAAML_cluster_medium=$((${N_rAAML_cluster_medium} + 1))
			else
				N_rAAML_cluster_confluent=$((${N_rAAML_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 14 ]; then
			N_lAAML_cluster=$((${N_rAAML_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lAAML_cluster_punctuate=$((${N_lAAML_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lAAML_cluster_focal=$((${N_lAAML_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lAAML_cluster_medium=$((${N_lAAML_cluster_medium} + 1))
			else
				N_lAAML_cluster_confluent=$((${N_lAAML_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 7 ]; then
			N_rAAC_cluster=$((${N_rAAC_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rAAC_cluster_punctuate=$((${N_rAAC_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rAAC_cluster_focal=$((${N_rAAC_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rAAC_cluster_medium=$((${N_rAAC_cluster_medium} + 1))
			else
				N_rAAC_cluster_confluent=$((${N_rAAC_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 8 ]; then
			N_lAAC_cluster=$((${N_lAAC_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lAAC_cluster_punctuate=$((${N_lAAC_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lAAC_cluster_focal=$((${N_lAAC_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lAAC_cluster_medium=$((${N_lAAC_cluster_medium} + 1))
			else
				N_lAAC_cluster_confluent=$((${N_lAAC_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 9 ]; then
			N_rMALL_cluster=$((${N_rMALL_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rMALL_cluster_punctuate=$((${N_rMALL_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rMALL_cluster_focal=$((${N_rMALL_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rMALL_cluster_medium=$((${N_rMALL_cluster_medium} + 1))
			else
				N_rMALL_cluster_confluent=$((${N_rMALL_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 10 ]; then
			N_lMALL_cluster=$((${N_lMALL_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lMALL_cluster_punctuate=$((${N_lMALL_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lMALL_cluster_focal=$((${N_lMALL_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lMALL_cluster_medium=$((${N_lMALL_cluster_medium} + 1))
			else
				N_lMALL_cluster_confluent=$((${N_lMALL_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 11 ]; then
			N_rPATMP_cluster=$((${N_lPATMP_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rPATMP_cluster_punctuate=$((${N_rPATMP_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rPATMP_cluster_focal=$((${N_rPATMP_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rPATMP_cluster_medium=$((${N_rPATMP_cluster_medium} + 1))
			else
				N_rPATMP_cluster_confluent=$((${N_rPATMP_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 12 ]; then
			N_lPATMP_cluster=$((${N_lPATMP_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lPATMP_cluster_punctuate=$((${N_lPATMP_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lPATMP_cluster_focal=$((${N_lPATMP_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lPATMP_cluster_medium=$((${N_lPATMP_cluster_medium} + 1))
			else
				N_lPATMP_cluster_confluent=$((${N_lPATMP_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 4 ]; then
			N_rPAH_cluster=$((${N_rPAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rPAH_cluster_punctuate=$((${N_rPAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rPAH_cluster_focal=$((${N_rPAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rPAH_cluster_medium=$((${N_rPAH_cluster_medium} + 1))
			else
				N_rPAH_cluster_confluent=$((${N_rPAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 5 ]; then
			N_lPAH_cluster=$((${N_lPAH_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lPAH_cluster_punctuate=$((${N_lPAH_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lPAH_cluster_focal=$((${N_lPAH_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lPAH_cluster_medium=$((${N_lPAH_cluster_medium} + 1))
			else
				N_lPAH_cluster_confluent=$((${N_lPAH_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 15 ]; then
			N_rPAC_cluster=$((${N_rPAC_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_rPAC_cluster_punctuate=$((${N_rPAC_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_rPAC_cluster_focal=$((${N_rPAC_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_rPAC_cluster_medium=$((${N_rPAC_cluster_medium} + 1))
			else
				N_rPAC_cluster_confluent=$((${N_rPAC_cluster_confluent} + 1))
			fi
		elif [ "${cogIntensityOnArterialMask}" -eq 16 ]; then
			N_lPAC_cluster=$((${N_lPAC_cluster} + 1))
			if [ "${clusterSize}" -lt "${punctuateClusterSize}" ]; then
				N_lPAC_cluster_punctuate=$((${N_lPAC_cluster_punctuate} + 1))
			elif [ "${clusterSize}" -lt "${focalClusterSize}" ]; then
				N_lPAC_cluster_focal=$((${N_lPAC_cluster_focal} + 1))
			elif [ "${clusterSize}" -lt "${mediumClusterSize}" ]; then
				N_lPAC_cluster_medium=$((${N_lPAC_cluster_medium} + 1))
			else
				N_lPAC_cluster_confluent=$((${N_lPAC_cluster_confluent} + 1))
			fi
		fi


		echo -n ${cl//	/,} >> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt
		# echo -n $cl | sed 's/	/,/g' >> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt
		echo ",${cogIntensityOnLobarMask},${cogIntensityOnArterialMask}" >> ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_in_regions.txt

	# done
	done < ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_noTitle.txt

	rm -f ${studyFolder}/subjects/${ID}/mri/extractedWMH/temp/${ID}_WMHonFLAIR_cluster_summary_noTitle.txt

	
	if [ -f ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt ]; then
		rm -f ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	fi

	# echo -n "Lfro_NoC,Rfro_NoC,Ltem_NoC,Rtem_NoC,Lpar_NoC,Rpar_NoC,Locc_NoC,Rocc_NoC,Lcer_NoC,Rcer_NoC,Bra_NoC" \
	# 		> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	# echo -n ",Lfro_NoC_f,Rfro_NoC_f,Ltem_NoC_f,Rtem_NoC_f,Lpar_NoC_f,Rpar_NoC_f,Locc_NoC_f,Rocc_NoC_f,Lcer_NoC_f,Rcer_NoC_f,Bra_NoC_f" \
	# 		>> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	# echo -n ",Lfro_NoC_m,Rfro_NoC_m,Ltem_NoC_m,Rtem_NoC_m,Lpar_NoC_m,Rpar_NoC_m,Locc_NoC_m,Rocc_NoC_m,Lcer_NoC_m,Rcer_NoC_m,Bra_NoC_m" \
	# 		>> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	# echo ",Lfro_NoC_c,Rfro_NoC_c,Ltem_NoC_c,Rtem_NoC_c,Lpar_NoC_c,Rpar_NoC_c,Locc_NoC_c,Rocc_NoC_c,Lcer_NoC_c,Rcer_NoC_c,Bra_NoC_c" \
	# 		>> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt

	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	date >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "--==  Number of WMH incidences (any size) ==--" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Periventricle_WMHclusters	${N_Periventricle_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lfrontal_WMHclusters	${N_Lfrontal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rfrontal_WMHclusters	${N_Rfrontal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Ltemporal_WMHclusters	${N_Ltemporal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rtemporal_WMHclusters	${N_Rtemporal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lparietal_WMHclusters	${N_Lparietal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rparietal_WMHclusters	${N_Rparietal_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Loccipital_WMHclusters	${N_Loccipital_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Roccipital_WMHclusters	${N_Roccipital_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lcerebellum_WMHclusters	${N_Lcerebellum_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rcerebellum_WMHclusters	${N_Rcerebellum_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Brainstem_WMHclusters	${N_Brainstem_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAH_WMHclusters	${N_lAAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAH_WMHclusters	${N_rAAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lMAH_WMHclusters	${N_lMAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rMAH_WMHclusters	${N_rMAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAML_WMHclusters	${N_lAAML_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAML_WMHclusters	${N_rAAML_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAC_WMHclusters	${N_lAAC_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAC_WMHclusters	${N_rAAC_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lMALL_WMHclusters	${N_lMALL_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rMALL_WMHclusters	${N_rMALL_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPATMP_WMHclusters	${N_lPATMP_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPATMP_WMHclusters	${N_rPATMP_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPAH_WMHclusters	${N_lPAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPAH_WMHclusters	${N_rPAH_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPAC_WMHclusters	${N_lPAC_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPAC_WMHclusters	${N_rPAC_cluster}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt	
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "----------------------------------------------" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "--== Number of WMH incidences (punctuate) ==--" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Periventricle_WMHclusters_punctuate	${N_Periventricle_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lfrontal_WMHclusters_punctuate	${N_Lfrontal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rfrontal_WMHclusters_punctuate	${N_Rfrontal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Ltemporal_WMHclusters_punctuate	${N_Ltemporal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rtemporal_WMHclusters_punctuate	${N_Rtemporal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lparietal_WMHclusters_punctuate	${N_Lparietal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rparietal_WMHclusters_punctuate	${N_Rparietal_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Loccipital_WMHclusters_punctuate	${N_Loccipital_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Roccipital_WMHclusters_punctuate	${N_Roccipital_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lcerebellum_WMHclusters_punctuate	${N_Lcerebellum_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rcerebellum_WMHclusters_punctuate	${N_Rcerebellum_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Brainstem_WMHclusters_punctuate	${N_Brainstem_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAH_WMHclusters_punctuate	${N_lAAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAH_WMHclusters_punctuate	${N_rAAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lMAH_WMHclusters_punctuate	${N_lMAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rMAH_WMHclusters_punctuate	${N_rMAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAML_WMHclusters_punctuate	${N_lAAML_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAML_WMHclusters_punctuate	${N_rAAML_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAC_WMHclusters_punctuate	${N_lAAC_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAC_WMHclusters_punctuate	${N_rAAC_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lMALL_WMHclusters_punctuate	${N_lMALL_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rMALL_WMHclusters_punctuate	${N_rMALL_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPATMP_WMHclusters_punctuate	${N_lPATMP_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPATMP_WMHclusters_punctuate	${N_rPATMP_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPAH_WMHclusters_punctuate	${N_lPAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPAH_WMHclusters_punctuate	${N_rPAH_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPAC_WMHclusters_punctuate	${N_lPAC_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPAC_WMHclusters_punctuate	${N_rPAC_cluster_punctuate}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "----------------------------------------------" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "--== Number of WMH incidences (focal) ==--" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Periventricle_WMHclusters_focal	${N_Periventricle_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lfrontal_WMHclusters_focal	${N_Lfrontal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rfrontal_WMHclusters_focal	${N_Rfrontal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Ltemporal_WMHclusters_focal	${N_Ltemporal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rtemporal_WMHclusters_focal	${N_Rtemporal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lparietal_WMHclusters_focal	${N_Lparietal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rparietal_WMHclusters_focal	${N_Rparietal_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Loccipital_WMHclusters_focal	${N_Loccipital_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Roccipital_WMHclusters_focal	${N_Roccipital_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lcerebellum_WMHclusters_focal	${N_Lcerebellum_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rcerebellum_WMHclusters_focal	${N_Rcerebellum_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Brainstem_WMHclusters_focal	${N_Brainstem_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAH_WMHclusters_focal	${N_lAAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAH_WMHclusters_focal	${N_rAAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lMAH_WMHclusters_focal	${N_lMAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rMAH_WMHclusters_focal	${N_rMAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAML_WMHclusters_focal	${N_lAAML_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAML_WMHclusters_focal	${N_rAAML_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAC_WMHclusters_focal	${N_lAAC_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAC_WMHclusters_focal	${N_rAAC_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lMALL_WMHclusters_focal	${N_lMALL_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rMALL_WMHclusters_focal	${N_rMALL_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPATMP_WMHclusters_focal	${N_lPATMP_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPATMP_WMHclusters_focal	${N_rPATMP_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPAH_WMHclusters_focal	${N_lPAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPAH_WMHclusters_focal	${N_rPAH_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPAC_WMHclusters_focal	${N_lPAC_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPAC_WMHclusters_focal	${N_rPAC_cluster_focal}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "----------------------------------------------" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "--== Number of WMH incidences (medium) ==--" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Periventricle_WMHclusters_medium	${N_Periventricle_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lfrontal_WMHclusters_medium	${N_Lfrontal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rfrontal_WMHclusters_medium	${N_Rfrontal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Ltemporal_WMHclusters_medium	${N_Ltemporal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rtemporal_WMHclusters_medium	${N_Rtemporal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lparietal_WMHclusters_medium	${N_Lparietal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rparietal_WMHclusters_medium	${N_Rparietal_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Loccipital_WMHclusters_medium	${N_Loccipital_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Roccipital_WMHclusters_medium	${N_Roccipital_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lcerebellum_WMHclusters_medium	${N_Lcerebellum_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rcerebellum_WMHclusters_medium	${N_Rcerebellum_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Brainstem_WMHclusters_medium	${N_Brainstem_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAH_WMHclusters_medium	${N_lAAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAH_WMHclusters_medium	${N_rAAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lMAH_WMHclusters_medium	${N_lMAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rMAH_WMHclusters_medium	${N_rMAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAML_WMHclusters_medium	${N_lAAML_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAML_WMHclusters_medium	${N_rAAML_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAC_WMHclusters_medium	${N_lAAC_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAC_WMHclusters_medium	${N_rAAC_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lMALL_WMHclusters_medium	${N_lMALL_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rMALL_WMHclusters_medium	${N_rMALL_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPATMP_WMHclusters_medium	${N_lPATMP_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPATMP_WMHclusters_medium	${N_rPATMP_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPAH_WMHclusters_medium	${N_lPAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPAH_WMHclusters_medium	${N_rPAH_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPAC_WMHclusters_medium	${N_lPAC_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPAC_WMHclusters_medium	${N_rPAC_cluster_medium}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "----------------------------------------------" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "--== Number of WMH incidences (confluent) ==--" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Periventricle_WMHclusters_confluent	${N_Periventricle_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lfrontal_WMHclusters_confluent	${N_Lfrontal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rfrontal_WMHclusters_confluent	${N_Rfrontal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Ltemporal_WMHclusters_confluent	${N_Ltemporal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rtemporal_WMHclusters_confluent	${N_Rtemporal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lparietal_WMHclusters_confluent	${N_Lparietal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rparietal_WMHclusters_confluent	${N_Rparietal_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Loccipital_WMHclusters_confluent	${N_Loccipital_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Roccipital_WMHclusters_confluent	${N_Roccipital_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Lcerebellum_WMHclusters_confluent	${N_Lcerebellum_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Rcerebellum_WMHclusters_confluent	${N_Rcerebellum_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_Brainstem_WMHclusters_confluent	${N_Brainstem_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAH_WMHclusters_confluent	${N_lAAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAH_WMHclusters_confluent	${N_rAAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lMAH_WMHclusters_confluent	${N_lMAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rMAH_WMHclusters_confluent	${N_rMAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAML_WMHclusters_confluent	${N_lAAML_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAML_WMHclusters_confluent	${N_rAAML_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lAAC_WMHclusters_confluent	${N_lAAC_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rAAC_WMHclusters_confluent	${N_rAAC_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lMALL_WMHclusters_confluent	${N_lMALL_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rMALL_WMHclusters_confluent	${N_rMALL_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPATMP_WMHclusters_confluent	${N_lPATMP_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPATMP_WMHclusters_confluent	${N_rPATMP_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPAH_WMHclusters_confluent	${N_lPAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPAH_WMHclusters_confluent	${N_rPAH_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_lPAC_WMHclusters_confluent	${N_lPAC_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "No_of_rPAC_WMHclusters_confluent	${N_rPAC_cluster_confluent}" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "----------------------------------------------" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt
	echo "" >> ${studyFolder}/subjects/${ID}/stats/${ID}_WMH_NoC.txt



}



# $1 = study folder
# $2 = subject's ID
# $3 = pipeline path
# $4 = periventricle magnitude

NoC_count $1 $2 $3 $4