#!/bin/bash

. ${FSLDIR}/etc/fslconf/fsl.sh

extractASLresults(){
	ID=$1
	studyFolder=$2

	globalCBF_native_inclCSF=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/native_space/perfusion_calib -M`

	# gm_perfusionCalib_nativespace=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/native_space/perfusion_calib_GM -M`
	# wm_perfusionCalib_nativespace=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/native_space/perfusion_calib_WM -M`

	# whlBrn_perfusionCalib_T1space=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/struct_space_SPM/perfusion_calib -M`
	# gm_perfusionCalib_T1space=`${FSLDIR}/bin/fslstats ${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/struct_space_SPM/perfusion_calib_GM -M`

	nativePvcorrFolder="${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/native_space/pvcorr"

	gmCBF_native_pvcorr_FSL=`cat ${nativePvcorrFolder}/perfusion_calib_gm_mean.txt`
	wmCBF_native_pvcorr_FSL=`cat ${nativePvcorrFolder}/perfusion_wm_calib_wm_mean.txt`


	nativeSpaceFolder=$(dirname "${nativePvcorrFolder}")

	globalCBF_native_exclCSF=`cat ${nativeSpaceFolder}/meanInt_global.txt`

	gmCBF_native_pvcorr_Jmod=`cat ${nativePvcorrFolder}/meanInt_GM.txt`
	wmCBF_native_pvcorr_Jmod=`cat ${nativePvcorrFolder}/meanInt_WM.txt`


	regionalMeasFolder="${studyFolder}/subjects/${ID}/${ID}_invKineticMdl_wT1/native_space/pvcorr/regionalMeas_Jmod"
	
	caudate_CBF=`grep -w "caudate" ${regionalMeasFolder}/regionalMeas.txt | awk '{print $2}'`
	cerebellum_CBF=`grep -w "cerebellum" ${regionalMeasFolder}/regionalMeas.txt | awk '{print $2}'`
	frontalLobe_CBF=`grep -w "frontal_lobe" ${regionalMeasFolder}/regionalMeas.txt | awk '{print $2}'`
	insula_CBF=`grep -w "insula" ${regionalMeasFolder}/regionalMeas.txt | awk '{print $2}'`
	occipitalLobe_CBF=`grep -w "occipital_lobe" ${regionalMeasFolder}/regionalMeas.txt | awk '{print $2}'`
	parietalLobe_CBF=`grep -w "parietal_lobe" ${regionalMeasFolder}/regionalMeas.txt | awk '{print $2}'`
	putamen_CBF=`grep -w "putamen" ${regionalMeasFolder}/regionalMeas.txt | awk '{print $2}'`
	temporalLobe_CBF=`grep -w "temporal_lobe" ${regionalMeasFolder}/regionalMeas.txt | awk '{print $2}'`
	thalamus_CBF=`grep -w "thalamus" ${regionalMeasFolder}/regionalMeas.txt | awk '{print $2}'`	

	echo -n "${ID}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${globalCBF_native_inclCSF}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${gmCBF_native_pvcorr_FSL}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${wmCBF_native_pvcorr_FSL}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${globalCBF_native_exclCSF}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${gmCBF_native_pvcorr_Jmod}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${wmCBF_native_pvcorr_Jmod}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${caudate_CBF}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${cerebellum_CBF}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${frontalLobe_CBF}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${insula_CBF}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${occipitalLobe_CBF}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${parietalLobe_CBF}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${putamen_CBF}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo -n "${temporalLobe_CBF}," | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt
	echo "${thalamus_CBF}" | sed 's/ //g' >> ${studyFolder}/subjects/perfusion_results.txt

}


# ID = $1
# study folder = $2
extractASLresults $1 $2