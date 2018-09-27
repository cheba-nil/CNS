#!/bin/bash

combineTrainingTextfiles(){

	ID=$1
	studyFolder=$2

	ind_feature="${studyFolder}/customiseClassifier/textfiles/${ID}_feature_forTraining_VisAdj_final.txt"
	ind_decision="${studyFolder}/customiseClassifier/textfiles/${ID}_decision_forTraining_VisAdj_final.txt"
	ind_lookup="${studyFolder}/customiseClassifier/textfiles/${ID}_lookUp_forTraining_VisAdj_final.txt"
	final_feature="${studyFolder}/customiseClassifier/textfiles/feature_forTraining.txt"
	final_decision="${studyFolder}/customiseClassifier/textfiles/decision_forTraining.txt"
	final_lookup="${studyFolder}/customiseClassifier/textfiles/lookup_forTraining.txt"

	cat ${ind_decision} >> ${final_decision}
	cat ${ind_feature} >> ${final_feature}
	cat ${ind_lookup} >> ${final_lookup}
}

combineTrainingTextfiles $1 $2