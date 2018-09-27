#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

calPerfMeas(){
	output_folder=$1
	ID=$2
	manTracedWMH=$3
	# threshold integer, i.e. 8 is for 0.8
	thr_int=$4

	echo "Calculating performance measures for ${ID} ..."

	# measures before masking
	bianca_overlap_measures ${output_folder}/BIANCA_result/${ID}_BIANCA_output_thr0_${thr_int} \
							0 \
							${manTracedWMH} \
							1

	mv ${output_folder}/BIANCA_result/Overlap_and_Volumes_${ID}_BIANCA_output_thr0_${thr_int}_0.txt \
		${output_folder}/BIANCA_performance_measures/${ID}_PerfMeas_thr0_${thr_int}_beforeMask.txt



	# measures after masking
	bianca_overlap_measures ${output_folder}/BIANCA_result/${ID}_BIANCA_output_thr0_${thr_int}_masked \
							0 \
							${manTracedWMH} \
							1
							
	mv ${output_folder}/BIANCA_result/Overlap_and_Volumes_${ID}_BIANCA_output_thr0_${thr_int}_masked_0.txt \
		${output_folder}/BIANCA_performance_measures/${ID}_PerfMeas_thr0_${thr_int}_afterMask.txt


}

calPerfMeas $1 $2 $3 $4