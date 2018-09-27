#!/bin/bash

# merge the info into one spreadsheet

WMHextraction_kNNdiscovery_Step4(){
	
    ID=$1
	subj_dir=$2
	

	wholeBrainWMHvol=`grep Vol_of_total_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk -F'\t' '{print $2}'`
	PVWMHvol=`grep Vol_of_PVWMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk -F'\t' '{print $2}'`
	DWMHvol=`grep Vol_of_DWMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk -F'\t' '{print $2}'`
	Lfrontal_WMHvol=`grep Vol_of_Lfrontal_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
	Rfrontal_WMHvol=`grep Vol_of_Rfrontal_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    Ltemporal_WMHvol=`grep Vol_of_Ltemporal_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    Rtemporal_WMHvol=`grep Vol_of_Rtemporal_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    Lparietal_WMHvol=`grep Vol_of_Lparietal_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    Rparietal_WMHvol=`grep Vol_of_Rparietal_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    Loccipital_WMHvol=`grep Vol_of_Loccipital_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    Roccipital_WMHvol=`grep Vol_of_Roccipital_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    Lcerebellum_WMHvol=`grep Vol_of_Lcerebellum_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    Rcerebellum_WMHvol=`grep Vol_of_Rcerebellum_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    Brainstem_WMHvol=`grep Vol_of_Brainstem_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`

    rAAH_WMHvol=`grep Vol_of_rAAH_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    lAAH_WMHvol=`grep Vol_of_lAAH_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    rMAH_WMHvol=`grep Vol_of_rMAH_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    lMAH_WMHvol=`grep Vol_of_lMAH_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    rAAML_WMHvol=`grep Vol_of_rAAML_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    lAAML_WMHvol=`grep Vol_of_lAAML_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    rAAC_WMHvol=`grep Vol_of_rAAC_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    lAAC_WMHvol=`grep Vol_of_lAAC_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    rMALL_WMHvol=`grep Vol_of_rMALL_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    lMALL_WMHvol=`grep Vol_of_lMALL_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    rPATMP_WMHvol=`grep Vol_of_rPATMP_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    lPATMP_WMHvol=`grep Vol_of_lPATMP_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    rPAH_WMHvol=`grep Vol_of_rPAH_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    lPAH_WMHvol=`grep Vol_of_lPAH_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    rPAC_WMHvol=`grep Vol_of_rPAC_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`
    lPAC_WMHvol=`grep Vol_of_lPAC_WMH_clusters_in_mm ${subj_dir}/${ID}/stats/${ID}_WMH_vol.txt | awk '{print $2}'`

    wholeBrain_WMHnoc=`grep -w No_of_WholeBrain_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    PV_WMHnoc=`grep -w No_of_Periventricle_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lfontal_WMHnoc=`grep -w No_of_Lfrontal_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rfontal_WMHnoc=`grep -w No_of_Rfrontal_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Ltemporal_WMHnoc=`grep -w No_of_Ltemporal_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rtemporal_WMHnoc=`grep -w No_of_Rtemporal_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lparietal_WMHnoc=`grep -w No_of_Lparietal_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rparietal_WMHnoc=`grep -w No_of_Rparietal_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Loccipital_WMHnoc=`grep -w No_of_Loccipital_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Roccipital_WMHnoc=`grep -w No_of_Roccipital_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lcerebellum_WMHnoc=`grep -w No_of_Lcerebellum_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rcerebellum_WMHnoc=`grep -w No_of_Rcerebellum_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Brainstem_WMHnoc=`grep -w No_of_Brainstem_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    
    lAAH_WMHnoc=`grep -w No_of_lAAH_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAH_WMHnoc=`grep -w No_of_rAAH_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lMAH_WMHnoc=`grep -w No_of_lMAH_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rMAH_WMHnoc=`grep -w No_of_rMAH_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lAAML_WMHnoc=`grep -w No_of_lAAML_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAML_WMHnoc=`grep -w No_of_rAAML_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lAAC_WMHnoc=`grep -w No_of_lAAC_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAC_WMHnoc=`grep -w No_of_rAAC_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lMALL_WMHnoc=`grep -w No_of_lMALL_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rMALL_WMHnoc=`grep -w No_of_rMALL_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPATMP_WMHnoc=`grep -w No_of_lPATMP_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPATMP_WMHnoc=`grep -w No_of_rPATMP_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPAH_WMHnoc=`grep -w No_of_lPAH_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPAH_WMHnoc=`grep -w No_of_rPAH_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPAC_WMHnoc=`grep -w No_of_lPAC_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPAC_WMHnoc=`grep -w No_of_rPAC_WMHclusters ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`

    wholeBrain_WMHnoc_pun=`grep No_of_WholeBrain_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    PV_WMHnoc_pun=`grep No_of_Periventricle_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lfrontal_WMHnoc_pun=`grep No_of_Lfrontal_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rfrontal_WMHnoc_pun=`grep No_of_Rfrontal_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Ltemporal_WMHnoc_pun=`grep No_of_Ltemporal_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rtemporal_WMHnoc_pun=`grep No_of_Rtemporal_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lparietal_WMHnoc_pun=`grep No_of_Lparietal_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rparietal_WMHnoc_pun=`grep No_of_Rparietal_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Loccipital_WMHnoc_pun=`grep No_of_Loccipital_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Roccipital_WMHnoc_pun=`grep No_of_Roccipital_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lcerebellum_WMHnoc_pun=`grep No_of_Lcerebellum_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rcerebellum_WMHnoc_pun=`grep No_of_Rcerebellum_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Brainstem_WMHnoc_pun=`grep No_of_Brainstem_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`

    lAAH_WMHnoc_pun=`grep No_of_lAAH_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAH_WMHnoc_pun=`grep No_of_rAAH_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lMAH_WMHnoc_pun=`grep No_of_lMAH_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rMAH_WMHnoc_pun=`grep No_of_rMAH_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lAAML_WMHnoc_pun=`grep No_of_lAAML_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAML_WMHnoc_pun=`grep No_of_rAAML_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lAAC_WMHnoc_pun=`grep No_of_lAAC_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAC_WMHnoc_pun=`grep No_of_rAAC_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lMALL_WMHnoc_pun=`grep No_of_lMALL_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rMALL_WMHnoc_pun=`grep No_of_rMALL_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPATMP_WMHnoc_pun=`grep No_of_lPATMP_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPATMP_WMHnoc_pun=`grep No_of_rPATMP_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPAH_WMHnoc_pun=`grep No_of_lPAH_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPAH_WMHnoc_pun=`grep No_of_rPAH_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPAC_WMHnoc_pun=`grep No_of_lPAC_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPAC_WMHnoc_pun=`grep No_of_rPAC_WMHclusters_punctuate ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`

    wholeBrain_WMHnoc_foc=`grep No_of_WholeBrain_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    PV_WMHnoc_foc=`grep No_of_Periventricle_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lfrontal_WMHnoc_foc=`grep No_of_Lfrontal_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rfrontal_WMHnoc_foc=`grep No_of_Rfrontal_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Ltemporal_WMHnoc_foc=`grep No_of_Ltemporal_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rtemporal_WMHnoc_foc=`grep No_of_Rtemporal_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lparietal_WMHnoc_foc=`grep No_of_Lparietal_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rparietal_WMHnoc_foc=`grep No_of_Rparietal_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Loccipital_WMHnoc_foc=`grep No_of_Loccipital_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Roccipital_WMHnoc_foc=`grep No_of_Roccipital_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lcerebellum_WMHnoc_foc=`grep No_of_Lcerebellum_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rcerebellum_WMHnoc_foc=`grep No_of_Rcerebellum_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Brainstem_WMHnoc_foc=`grep No_of_Brainstem_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`

    lAAH_WMHnoc_foc=`grep No_of_lAAH_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAH_WMHnoc_foc=`grep No_of_rAAH_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lMAH_WMHnoc_foc=`grep No_of_lMAH_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rMAH_WMHnoc_foc=`grep No_of_rMAH_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lAAML_WMHnoc_foc=`grep No_of_lAAML_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAML_WMHnoc_foc=`grep No_of_rAAML_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lAAC_WMHnoc_foc=`grep No_of_lAAC_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAC_WMHnoc_foc=`grep No_of_rAAC_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lMALL_WMHnoc_foc=`grep No_of_lMALL_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rMALL_WMHnoc_foc=`grep No_of_rMALL_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPATMP_WMHnoc_foc=`grep No_of_lPATMP_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPATMP_WMHnoc_foc=`grep No_of_rPATMP_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPAH_WMHnoc_foc=`grep No_of_lPAH_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPAH_WMHnoc_foc=`grep No_of_rPAH_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPAC_WMHnoc_foc=`grep No_of_lPAC_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPAC_WMHnoc_foc=`grep No_of_rPAC_WMHclusters_focal ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`

    wholeBrain_WMHnoc_med=`grep No_of_WholeBrain_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    PV_WMHnoc_med=`grep No_of_Periventricle_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lfrontal_WMHnoc_med=`grep No_of_Lfrontal_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rfrontal_WMHnoc_med=`grep No_of_Rfrontal_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Ltemporal_WMHnoc_med=`grep No_of_Ltemporal_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rtemporal_WMHnoc_med=`grep No_of_Rtemporal_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lparietal_WMHnoc_med=`grep No_of_Lparietal_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rparietal_WMHnoc_med=`grep No_of_Rparietal_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Loccipital_WMHnoc_med=`grep No_of_Loccipital_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Roccipital_WMHnoc_med=`grep No_of_Roccipital_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lcerebellum_WMHnoc_med=`grep No_of_Lcerebellum_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rcerebellum_WMHnoc_med=`grep No_of_Rcerebellum_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Brainstem_WMHnoc_med=`grep No_of_Brainstem_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`

    lAAH_WMHnoc_med=`grep No_of_lAAH_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAH_WMHnoc_med=`grep No_of_rAAH_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lMAH_WMHnoc_med=`grep No_of_lMAH_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rMAH_WMHnoc_med=`grep No_of_rMAH_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lAAML_WMHnoc_med=`grep No_of_lAAML_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAML_WMHnoc_med=`grep No_of_rAAML_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lAAC_WMHnoc_med=`grep No_of_lAAC_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAC_WMHnoc_med=`grep No_of_rAAC_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lMALL_WMHnoc_med=`grep No_of_lMALL_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rMALL_WMHnoc_med=`grep No_of_rMALL_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPATMP_WMHnoc_med=`grep No_of_lPATMP_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPATMP_WMHnoc_med=`grep No_of_rPATMP_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPAH_WMHnoc_med=`grep No_of_lPAH_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPAH_WMHnoc_med=`grep No_of_rPAH_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPAC_WMHnoc_med=`grep No_of_lPAC_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPAC_WMHnoc_med=`grep No_of_rPAC_WMHclusters_medium ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`

    wholeBrain_WMHnoc_con=`grep No_of_WholeBrain_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    PV_WMHnoc_con=`grep No_of_Periventricle_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lfrontal_WMHnoc_con=`grep No_of_Lfrontal_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rfrontal_WMHnoc_con=`grep No_of_Rfrontal_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Ltemporal_WMHnoc_con=`grep No_of_Ltemporal_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rtemporal_WMHnoc_con=`grep No_of_Rtemporal_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lparietal_WMHnoc_con=`grep No_of_Lparietal_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rparietal_WMHnoc_con=`grep No_of_Rparietal_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Loccipital_WMHnoc_con=`grep No_of_Loccipital_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Roccipital_WMHnoc_con=`grep No_of_Roccipital_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Lcerebellum_WMHnoc_con=`grep No_of_Lcerebellum_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Rcerebellum_WMHnoc_con=`grep No_of_Rcerebellum_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    Brainstem_WMHnoc_con=`grep No_of_Brainstem_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`

    lAAH_WMHnoc_con=`grep No_of_lAAH_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAH_WMHnoc_con=`grep No_of_rAAH_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lMAH_WMHnoc_con=`grep No_of_lMAH_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rMAH_WMHnoc_con=`grep No_of_rMAH_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lAAML_WMHnoc_con=`grep No_of_lAAML_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAML_WMHnoc_con=`grep No_of_rAAML_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lAAC_WMHnoc_con=`grep No_of_lAAC_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rAAC_WMHnoc_con=`grep No_of_rAAC_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lMALL_WMHnoc_con=`grep No_of_lMALL_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rMALL_WMHnoc_con=`grep No_of_rMALL_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPATMP_WMHnoc_con=`grep No_of_lPATMP_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPATMP_WMHnoc_con=`grep No_of_rPATMP_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPAH_WMHnoc_con=`grep No_of_lPAH_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPAH_WMHnoc_con=`grep No_of_rPAH_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    lPAC_WMHnoc_con=`grep No_of_lPAC_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`
    rPAC_WMHnoc_con=`grep No_of_rPAC_WMHclusters_confluent ${subj_dir}/${ID}/stats/${ID}_WMH_NoC.txt | awk '{print $2}'`




    # lobar volume
    echo -n "${ID},${wholeBrainWMHvol},${PVWMHvol},${DWMHvol},${Lfrontal_WMHvol},${Rfrontal_WMHvol},${Ltemporal_WMHvol},${Rtemporal_WMHvol},${Lparietal_WMHvol},${Rparietal_WMHvol},${Loccipital_WMHvol},${Roccipital_WMHvol},${Lcerebellum_WMHvol},${Rcerebellum_WMHvol},${Brainstem_WMHvol}," \
    		>> ${subj_dir}/WMH_spreadsheet.txt

    # arterial volume
    echo -n "${lAAH_WMHvol},${rAAH_WMHvol},${lMAH_WMHvol},${rMAH_WMHvol},${lAAML_WMHvol},${rAAML_WMHvol},${lAAC_WMHvol},${rAAC_WMHvol},${lMALL_WMHvol},${rMALL_WMHvol},${lPATMP_WMHvol},${rPATMP_WMHvol},${lPAH_WMHvol},${rPAH_WMHvol},${lPAC_WMHvol},${rPAC_WMHvol}," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    # lobar total noc
    echo -n "${wholeBrain_WMHnoc},${PV_WMHnoc},${Lfontal_WMHnoc},${Rfontal_WMHnoc},${Ltemporal_WMHnoc},${Rtemporal_WMHnoc},${Lparietal_WMHnoc},${Rparietal_WMHnoc},${Loccipital_WMHnoc},${Roccipital_WMHnoc},${Lcerebellum_WMHnoc},${Rcerebellum_WMHnoc},${Brainstem_WMHnoc}," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    # arterial total noc
    echo -n "${lAAH_WMHnoc},${rAAH_WMHnoc},${lMAH_WMHnoc},${rMAH_WMHnoc},${lAAML_WMHnoc},${rAAML_WMHnoc},${lAAC_WMHnoc},${rAAC_WMHnoc},${lMALL_WMHnoc},${rMALL_WMHnoc},${lPATMP_WMHnoc},${rPATMP_WMHnoc},${lPAH_WMHnoc},${rPAH_WMHnoc},${lPAC_WMHnoc},${rPAC_WMHnoc}," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    # lobar punctuate noc
    echo -n "${wholeBrain_WMHnoc_pun},${PV_WMHnoc_pun},${Lfrontal_WMHnoc_pun},${Rfrontal_WMHnoc_pun},${Ltemporal_WMHnoc_pun},${Rtemporal_WMHnoc_pun},${Lparietal_WMHnoc_pun},${Rparietal_WMHnoc_pun},${Loccipital_WMHnoc_pun},${Roccipital_WMHnoc_pun},${Lcerebellum_WMHnoc_pun},${Rcerebellum_WMHnoc_pun},${Brainstem_WMHnoc_pun}," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    # arterial punctuate noc
    echo -n "${lAAH_WMHnoc_pun},${rAAH_WMHnoc_pun},${lMAH_WMHnoc_pun},${rMAH_WMHnoc_pun},${lAAML_WMHnoc_pun},${rAAML_WMHnoc_pun},${lAAC_WMHnoc_pun},${rAAC_WMHnoc_pun},${lMALL_WMHnoc_pun},${rMALL_WMHnoc_pun},${lPATMP_WMHnoc_pun},${rPATMP_WMHnoc_pun},${lPAH_WMHnoc_pun},${rPAH_WMHnoc_pun},${lPAC_WMHnoc_pun},${rPAC_WMHnoc_pun}," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    # lobar focal noc
    echo -n "${wholeBrain_WMHnoc_foc},${PV_WMHnoc_foc},${Lfrontal_WMHnoc_foc},${Rfrontal_WMHnoc_foc},${Ltemporal_WMHnoc_foc},${Rtemporal_WMHnoc_foc},${Lparietal_WMHnoc_foc},${Rparietal_WMHnoc_foc},${Loccipital_WMHnoc_foc},${Roccipital_WMHnoc_foc},${Lcerebellum_WMHnoc_foc},${Rcerebellum_WMHnoc_foc},${Brainstem_WMHnoc_foc}," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    # arterial focal noc
    echo -n "${lAAH_WMHnoc_foc},${rAAH_WMHnoc_foc},${lMAH_WMHnoc_foc},${rMAH_WMHnoc_foc},${lAAML_WMHnoc_foc},${rAAML_WMHnoc_foc},${lAAC_WMHnoc_foc},${rAAC_WMHnoc_foc},${lMALL_WMHnoc_foc},${rMALL_WMHnoc_foc},${lPATMP_WMHnoc_foc},${rPATMP_WMHnoc_foc},${lPAH_WMHnoc_foc},${rPAH_WMHnoc_foc},${lPAC_WMHnoc_foc},${rPAC_WMHnoc_foc}," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    # lobar medium noc
    echo -n "${wholeBrain_WMHnoc_med},${PV_WMHnoc_med},${Lfrontal_WMHnoc_med},${Rfrontal_WMHnoc_med},${Ltemporal_WMHnoc_med},${Rtemporal_WMHnoc_med},${Lparietal_WMHnoc_med},${Rparietal_WMHnoc_med},${Loccipital_WMHnoc_med},${Roccipital_WMHnoc_med},${Lcerebellum_WMHnoc_med},${Rcerebellum_WMHnoc_med},${Brainstem_WMHnoc_med}," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    # arterial medium noc
    echo -n "${lAAH_WMHnoc_med},${rAAH_WMHnoc_med},${lMAH_WMHnoc_med},${rMAH_WMHnoc_med},${lAAML_WMHnoc_med},${rAAML_WMHnoc_med},${lAAC_WMHnoc_med},${rAAC_WMHnoc_med},${lMALL_WMHnoc_med},${rMALL_WMHnoc_med},${lPATMP_WMHnoc_med},${rPATMP_WMHnoc_med},${lPAH_WMHnoc_med},${rPAH_WMHnoc_med},${lPAC_WMHnoc_med},${rPAC_WMHnoc_med}," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    # lobar confluent noc
    echo -n "${wholeBrain_WMHnoc_con},${PV_WMHnoc_con},${Lfrontal_WMHnoc_con},${Rfrontal_WMHnoc_con},${Ltemporal_WMHnoc_con},${Rtemporal_WMHnoc_con},${Lparietal_WMHnoc_con},${Rparietal_WMHnoc_con},${Loccipital_WMHnoc_con},${Roccipital_WMHnoc_con},${Lcerebellum_WMHnoc_con},${Rcerebellum_WMHnoc_con},${Brainstem_WMHnoc_con}," \
            >> ${subj_dir}/WMH_spreadsheet.txt

    # arterial confluent noc
    echo "${lAAH_WMHnoc_con},${rAAH_WMHnoc_con},${lMAH_WMHnoc_con},${rMAH_WMHnoc_con},${lAAML_WMHnoc_con},${rAAML_WMHnoc_con},${lAAC_WMHnoc_con},${rAAC_WMHnoc_con},${lMALL_WMHnoc_con},${rMALL_WMHnoc_con},${lPATMP_WMHnoc_con},${rPATMP_WMHnoc_con},${lPAH_WMHnoc_con},${rPAH_WMHnoc_con},${lPAC_WMHnoc_con},${rPAC_WMHnoc_con}" \
            >> ${subj_dir}/WMH_spreadsheet.txt
}

WMHextraction_kNNdiscovery_Step4 $1 $2


