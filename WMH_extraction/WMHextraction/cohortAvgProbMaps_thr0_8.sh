#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

cohortAvgProbMaps_thr0_8(){
	GMavgprob=$1
	WMavgprob=$2
	CSFavgprob=$3
	outputFolder=$4

	${FSLDIR}/bin/fslmaths ${GMavgprob} \
							-thr 0.8 \
							${outputFolder}/cohort_GM_probability_map_thr0_8

	${FSLDIR}/bin/fslmaths ${WMavgprob} \
							-thr 0.8 \
							${outputFolder}/cohort_WM_probability_map_thr0_8

	# ${FSLDIR}/bin/fslmaths ${CSFavgprob} \
	# 						-thr 0.8 \
	# 						${outputFolder}/cohort_CSF_probability_map_thr0_8
}

cohortAvgProbMaps_thr0_8 $1 $2 $3 $4