#!/bin/bash


summarisePerfMeas(){

	output_folder=$1
	ID=$2

	beforemaskresult_file=`ls ${output_folder}/BIANCA_performance_measures/${ID}_PerfMeas_thr*_beforeMask.txt`
	aftermaskresult_file=`ls ${output_folder}/BIANCA_performance_measures/${ID}_PerfMeas_thr*_afterMask.txt`

	bfMaskResult=`cat ${beforemaskresult_file} | sed 's/ /,/g'`
	aftMaskResult=`cat ${aftermaskresult_file} | sed 's/ /,/g'`

	echo "${ID},${bfMaskResult},${aftMaskResult}" >> ${output_folder}/BIANCA_performance_measures_summary.txt
	
}

summarisePerfMeas $1 $2
