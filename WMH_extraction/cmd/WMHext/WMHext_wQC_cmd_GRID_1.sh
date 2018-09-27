#!/bin/bash

disp_usage(){
	echo ""
	echo "`basename $0`: WMH extraction with QC stops (Step 1: coregistration)"
	echo ""
	echo "Usage:  `basename $0` [option] [argument]"
	echo ""
	echo "                        -s, --studyFolder      <study_folder>          Specify study folder containing T1 and FLAIR"
	echo "                        -c, --currentFolder                            Use the working directory as study folder"
	echo "                        -n, --numWorkers                            	 Number of workers"
	echo ""
	exit 1
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
							if [ "$2" != "" ]; then
								studyFolder=$2
								shift 2
							else
								disp_usage
								exit 1
							fi
							;;

		-c | --currentFolder)
							if [ "$2" == "" ] || [ "$2" == "-n" ]; then
								studyFolder=`pwd`
								shift 1
							else
								disp_usage
								exit 1
							fi
							;;

		-*)
							disp_usage
							;;
	esac
done

if [ -z "${studyFolder}" ]; then
    usage
else
	echo "study folder = ${studyFolder}"
	echo "CNSP: WMH extraction with QC (Step 1) ..."

	export TZ='Australia/Sydney'
	CNSP_path=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")

	matlab -nodesktop -nosplash -r "addpath(genpath('${CNSP_path}'));\
									c=parcluster('local');\
									c.NumWorkers=${Nworkers};\
									parpool(c,c.NumWorkers);\
									WMHextraction_wQC_cmd_1('${studyFolder}',\
															'/usr/share/spm12',\
															'arch');\
									exit" \
									-logfile ${studyFolder}/logfile1.out \
									</dev/null

	echo "CNSP: WMH extraction step 1 finished."
	echo "Coregistration QC download link: ${studyFolder}/subjects/QC/QC_coreg/QC_coregistration.zip"
fi