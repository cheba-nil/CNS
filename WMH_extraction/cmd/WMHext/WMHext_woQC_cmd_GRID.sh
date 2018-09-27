#!/bin/bash

usage(){

	echo ""
	echo "`basename $0`: WMH extraction without QC stops"
	echo ""
	echo "Usage:  `basename $0` [option] [argument]"
	echo ""
	echo "                     -s, --studyFolder      <study_folder>          Specify study folder which contains T1 and FLAIR"
	echo "                     -c, --currentFolder                            Use the working directory as study folder"
	echo "                     -n, --numWorkers                            	  Number of workers"
	
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
								usage
								exit 1
							fi

							;;


        -s | --studyFolder)
				            
				            if [ "$2" == "" ]; then
				            	usage
				            	exit 1
				            else
								studyFolder=${2}
								shift 2
							fi

				            ;;


		-c | --currentFolder)
							
							if [ "$2" != "" ]&&[ "$2" != "-n" ]; then
								usage
								exit 1
								
							else
								studyFolder=`pwd`
								shift 1
							fi

							;;
        -*)
			usage
            ;;
	esac
done

# shift $((OPTIND-1))

if [ -z "${studyFolder}" ]; then
    usage
elif [ -z "${Nworkers}" ]; then
	usage
else
	
    # start of invoking matlab code
	echo "study folder = ${studyFolder}"
	echo "CNSP: WMH extraction without QC ..."
	export TZ='Australia/Sydney'
	CNSP_path=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
	matlab -nodesktop -nosplash -r "addpath(genpath('${CNSP_path}'));\
											c=parcluster('local');\
											c.NumWorkers=${Nworkers};\
											parpool(c,c.NumWorkers);\
											WMHextraction_woQC_cmd('${studyFolder}',\
																	'/usr/share/spm12',\
																	'existing template',\
																	5,\
																	'12',\
																	'',\
																	'',\
																	'built-in',\
																	'65to75',\
																	0.7,\
																	'arch');\
									exit" \
									-logfile ${studyFolder}/logfile.out \
									</dev/null

	echo "CNSP: WMH extraction finished."
	echo "Coregistration QC download link: ${studyFolder}/subjects/QC/QC_coreg/QC_coregistration.zip"
	echo "Segmentation QC download link: ${studyFolder}/subjects/QC/QC_seg/QC_segmentation.zip"
	echo "Final QC download link: ${studyFolder}/subjects/QC/QC_final/QC_final.zip"
	echo "WMH summary: ${studyFolder}/subjects/WMH_spreadsheet.txt"
fi






