#!/bin/bash

createTitle(){
	output_folder=$1
	
	if [ -f "${output_folder}/BIANCA_performance_measures_summary.txt" ]; then
		rm -f ${output_folder}/BIANCA_performance_measures_summary.txt
	fi

	echo -n "ID,SI_bfmask,FPF_bfmask,FNR_bfmask,FPF_cluster_bfmask,FNR_cluster_bfmask,DER_bfmask,OER_bfmask,MTA_bfmask,lesion_mask_vol_bfmask,manual_mask_vol_bfmask," \
			>> ${output_folder}/BIANCA_performance_measures_summary.txt

	echo "SI_aftmask,FPF_aftmask,FNR_aftmask,FPF_cluster_aftmask,FNR_cluster_aftmask,DER_aftmask,OER_aftmask,MTA_aftmask,lesion_mask_vol_aftmask,manual_mask_vol_aftmask" \
			>> ${output_folder}/BIANCA_performance_measures_summary.txt

}

createTitle $1