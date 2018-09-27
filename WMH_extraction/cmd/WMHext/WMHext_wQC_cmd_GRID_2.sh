#!/bin/bash

disp_usage(){
	echo ""
	echo "`basename $0`: WMH extraction with QC stops (Step 2: segmentation)"
	echo ""
	echo "Usage:  `basename $0` [option] [argument]"
	echo ""
	echo "                        -s, --studyFolder       <study_folder>            Specify study folder containing T1 and FLAIR. Either -s or -c needs to be specified."
	echo "                        -c, --currentFolder                               Use the working directory as study folder. Either -s or -c needs to be specified."
	echo "                        -x1, --coregExcld       <coreg_excld_IDs>         IDs did not pass coregistration QC (separated by coma). Mandatory opton, use \"none\" if all passed QC."
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
							if [ "${2}" == "" ] || [ "$2" == "-n" ] || [ "$2" == "-x1" ]; then
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

		-*)
							disp_usage
							exit 1
							;;
	esac
done

# echo "studyFolder = ${studyFolder}"
# echo "coregExcld = ${coregExcld}"
# if studyFolder or coregEx
if [ -z "${studyFolder}" ] || [ -z "${coregExcld}" ]; then
	disp_usage
	exit 1
else
	echo "study folder = ${studyFolder}"
	echo "coregExcld IDs = ${coregExcld}"

	echo "CNSP: WMH extraction with QC (Step 2) ..."

	export TZ='Australia/Sydney'
	CNSP_path=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")

	matlab -nodesktop -nosplash -r "addpath(genpath('${CNSP_path}'));\
									c=parcluster('local');\
									c.NumWorkers=${Nworkers};\
									parpool(c,c.NumWorkers);\
									WMHextraction_wQC_cmd_2('${studyFolder}',\
															'/usr/share/spm12',\
															'${coregExcld}',\
															'arch');\
									exit" \
									-logfile ${studyFolder}/logfile2.out \
									</dev/null

	echo "CNSP: WMH extraction step 2 finished."
	echo "Segmentation QC download link: ${studyFolder}/subjects/QC/QC_seg/QC_segmentation.zip"
fi



