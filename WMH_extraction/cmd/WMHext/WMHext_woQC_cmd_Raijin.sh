#!/bin/bash

##Project ID
#PBS -P ey6

##Queue type
#PBS -q hugemem

##Wall time
#PBS -l walltime=01:30:00

##Number of CPU cores
#PBS -l ncpus=14

##specify MATLAB (licensed) is going to be used
#PBS -lsoftware=matlab_unsw

##requested memory per node
#PBS -l mem=256GB

##Disk space
#PBS -l jobfs=5GB

##Job is excuted from current working dir instead of home
#PBS -l wd

##Send email when begin, abort, end
#PBS -M jiyang.jiang@unsw.edu.au
#PBS -m abe

studyFolder='/short/ey6/jyj561/fiveSubj'
spm12path='/home/561/jyj561/Software/spm12'
CNSP_path='/home/561/jyj561/Software/CNS'

module load matlab/R2017a
module load fsl/5.0.4


## Copy study directory to PBS job file system
echo "study folder = ${studyFolder}"
echo "CNS path = ${CNSP_path}"
echo "Copying study folder to PBS file system ..."
cp -r ${studyFolder} ${PBS_JOBFS}/.
echo "Finished copying."
echo "Temporary PBS working directory = ${PBS_JOBFS}/$(basename "${studyFolder}")"

echo "CNSP: WMH extraction without QC ..."

matlab -nodesktop -nosplash -r "addpath(genpath('${CNSP_path}'));\
								parpool($PBS_NCPUS),\
								WMHextraction_woQC_cmd('${PBS_JOBFS}/$(basename "${studyFolder}")',\
														'${spm12path}',\
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
								> $PBS_JOBID.log


echo "CNSP: WMH extraction finished."


echo "Copying results back to study folder ..."
## copy results back to study folder
mv ${PBS_JOBFS}/$(basename "${studyFolder}")/subjects ${studyFolder}/.
mkdir ${studyFolder}/originalImg
mv ${studyFolder}/T1 ${studyFolder}/FLAIR ${studyFolder}/originalImg/.
echo "Finished copying."

echo "Coregistration QC download link: ${studyFolder}/subjects/QC/QC_coreg/QC_coregistration.zip"
echo "Segmentation QC download link: ${studyFolder}/subjects/QC/QC_seg/QC_segmentation.zip"
echo "Final QC download link: ${studyFolder}/subjects/QC/QC_final/QC_final.zip"
echo "WMH summary: ${studyFolder}/subjects/WMH_spreadsheet.txt"
