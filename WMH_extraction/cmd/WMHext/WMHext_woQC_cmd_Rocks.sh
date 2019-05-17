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
	echo "                     -t, --template                            	  Template choice \"native template\" or \"existing template\""
	echo "                     -S, --segmentations                            Number of segmentations"
    echo "                     -T, --tidy                                     Delete intermediate files after completion"
	
	echo ""
	exit 1
}
template='existing template'
nsegs=3
tidy=''

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
        -t | --template)
				            if [ "$2" == "" ]; then
				            	usage
				            	exit 1
				            else
								template="${2}"
								shift 2
							fi

				            ;;
        -S | --segmentations)
				            if [ "$2" == "" ]; then
				            	usage
				            	exit 1
				            else
								nsegs="${2}"
								shift 2
							fi

				            ;;
                            
        -T | --tidy)
            tidy='true'
            shift 1 
        ;;
        -*)
			usage
            ;;
	esac
done

# make a temporary folder for matlab's jobs
JOB_DIR=$(mktemp -d)

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
                pc=parcluster('local');\
                pc.JobStorageLocation = '$JOB_DIR';\
                pc.NumWorkers=${Nworkers};\
                pool = parpool(pc,pc.NumWorkers);\
                WMHextraction_woQC_cmd('${studyFolder}',\
                                        '/share/apps/MATLAB/add-ons/spm12',\
                                        '${template}',\
                                        5,\
                                        '12',\
                                        '',\
                                        '',\
                                        'built-in',\
                                        '65to75',\
                                        0.7,\
                                        'arch',\
                                        $nsegs);\
                delete(pool);\
        exit" \
        -logfile ${studyFolder}/logfile.out \
        </dev/null

	echo "CNSP: WMH extraction finished."
fi

if [ $tidy != '' ]; then
    # tidy up
    orig_dir=$(pwd)

    cd ${studyFolder}
    rm *.nii
    #rm -r originalImg
    rm -r subjects/QC
    for sub in $(ls subjects); do
        rm -r subjects/$sub/NativeTemplate 
        rm -r subjects/$sub/mri/kNN_intermediateOutput
        rm -r subjects/$sub/mri/orig
        rm -r subjects/$sub/mri/preprocessing
        rm subjects/$sub/mri/extractedWMH/temp/${sub}_seg?.nii
        rm subjects/$sub/mri/extractedWMH/${sub}_ProbMap_FWMH3mmSmooth.nii.gz
    done 
    cd $orig_dir
fi
