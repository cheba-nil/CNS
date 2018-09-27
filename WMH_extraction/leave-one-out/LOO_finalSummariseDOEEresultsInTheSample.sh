#!/bin/bash

LOO_summariseCohortResult(){
	DOEE_folder=$1

	if [ -f "${DOEE_folder}/cohortDOEEsummary_ID_SI_DER_OER.txt" ]; then
		rm -f ${DOEE_folder}/cohortDOEEsummary_ID_SI_DER_OER.txt
	fi

	IDlist=`cat ${DOEE_folder}/*/summary_output.txt | grep "ID" | awk '{print $3}' | tr "\n" "\t"`
	SIlist=`cat ${DOEE_folder}/*/summary_output.txt | grep "SI" | awk '{print $3}' | tr "\n" "\t"`
	DERlist=`cat ${DOEE_folder}/*/summary_output.txt | grep "DER" | awk '{print $3}' | tr "\n" "\t"`
	OERlist=`cat ${DOEE_folder}/*/summary_output.txt | grep "OER" | awk '{print $3}' | tr "\n" "\t"`

	echo ${IDlist} >> ${DOEE_folder}/cohortDOEEsummary_ID_SI_DER_OER.txt
	echo ${SIlist} >> ${DOEE_folder}/cohortDOEEsummary_ID_SI_DER_OER.txt
	echo ${DERlist} >> ${DOEE_folder}/cohortDOEEsummary_ID_SI_DER_OER.txt
	echo ${OERlist} >> ${DOEE_folder}/cohortDOEEsummary_ID_SI_DER_OER.txt

}

LOO_summariseCohortResult $1