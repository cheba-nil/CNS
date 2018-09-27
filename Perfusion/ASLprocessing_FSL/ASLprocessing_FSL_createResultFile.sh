#!/bin/bash

create_perfResult_file(){
	studyFolder=$1

	if [ -e "${studyFolder}/subjects/perfusion_results.txt" ]; then
		rm -f ${studyFolder}/subjects/perfusion_results.txt
	fi

	echo -n "ID," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "globalCBF_native_inclCSF," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "gmCBF_native_pvcorr_FSL," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "wmCBF_native_pvcorr_FSL," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "globalCBF_native_exclCSF," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "gmCBF_native_pvcorr_Jmod," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "wmCBF_native_pvcorr_Jmod," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "caudate," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "cerebellum," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "frontal_lobe," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "insula," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "occipital_lobe," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "parietal_lobe," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "putamen," >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "temporal_lobe," >> ${studyFolder}/subjects/perfusion_results.txt
	echo "thalamus" >> ${studyFolder}/subjects/perfusion_results.txt
}

# study folder = $1
create_perfResult_file $1