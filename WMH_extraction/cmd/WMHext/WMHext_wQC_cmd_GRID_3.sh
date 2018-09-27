#!/bin/bash

disp_usage(){
	echo ""
	echo "`basename $0`: WMH extraction with QC stops (Step 3: WMH extraction using kNN)"
	echo ""
	echo "Usage:  `basename $0` [option] [argument]"
	echo ""
	echo "                        -s, --studyFolder       <study_folder>            Specify study folder containing T1 and FLAIR. Either -s or -c needs to be specified."
	echo "                        -c, --currentFolder                               Use the working directory as study folder. Either -s or -c needs to be specified."
	echo "                        -x1, --coregExcld       <coreg_excld_IDs>         IDs did not pass coregistration QC (separated by coma). Mandatory option, use \"none\" if all passed."
	echo "                        -x2, --segExcld         <seg_excld_IDs>           IDs did not pass segmentation QC (separated by coma). Mandatory option, use \"none\" if all passed."
	echo "                        -n, --numWorkers                            	 	Number of workers"
	
	echo ""
}

for arg in $@
do
	case "$arg" in
		-n | --numWorkers)
						if [ "$2" != "" ]; then
							Nworkers=$(($2))
							shift 2
						else
							disp_usage
							exit 1
						fi
						;;

		-s | --studyFolder)
						if [ ! -z "$2" ]; then
							studyFolder=$2
							shift 2
						else
							disp_usage
							exit 1
						fi
						
						;;

		-c | --currentFolder)
						if [ "$2" == "" ] || [ "$2" == "-n" ] || [ "$2" == "-x1" ] || [ "$2" == "-x2" ]; then
							studyFolder=`pwd`
							shift 1
						else
							disp_usage
							exit 1
						fi
						;;

		-x1 | --coregExcld)
						if [ ! -z "$2" ]; then
							coregExcld=$2
							shift 2
						else
							disp_usage
							exit 1
						fi
							;;

		-x2 | --segExcld)
						if [ ! -z "$2" ]; then
							segExcld=$2
							shift 2
						else
							disp_usage
							exit 1
						fi
						;;

		-*)
							disp_usage
							exit 1
							;;
	esac
done


# if studyFolder or coregEx
if [ -z "${studyFolder}" ] || [ -z "${coregExcld}" ] || [ -z "${segExcld}" ]; then
	disp_usage
	exit 1
else
	echo "study folder = ${studyFolder}"
	echo "coregExcld IDs = ${coregExcld}"
	echo "segExcld IDs = ${segExcld}"

	echo "CNSP: WMH extraction with QC (Step 3) ..."
	export TZ='Australia/Sydney'

	CNSP_path=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")

	matlab -nodesktop -nosplash -r "addpath(genpath('${CNSP_path}'));\
									c=parcluster('local');\
									c.NumWorkers=${Nworkers};\
									parpool(c,c.NumWorkers);\
									WMHextraction_wQC_cmd_3('${studyFolder}',\
															'/usr/share/spm12',\
															'existing template', \
															5,\
															'12',\
															'${coregExcld}',\
															'${segExcld}',\
															'built-in', \
															'65to75',\
															0.7,\
															'arch');\
									exit" \
									-logfile ${studyFolder}/logfile3.out \
									</dev/null

	echo "CNSP: WMH extraction finished."
	echo "Final QC download link:	${studyFolder}/subjects/QC/QC_final/QC_final.zip"
	echo "WMH summary:				${studyFolder}/subjects/WMH_spreadsheet.txt"
fi



