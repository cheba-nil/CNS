#!/bin/bash

disp_usage(){

	echo ""
	echo "`basename $0`: re-calculate global and regional WMH using manually edited WMH map"
	echo ""
	echo "`basename $0` [option] [argument]"
	echo ""
	echo "            -s, --studyFolder      <study_folder>               Specify study folder. Either -s or -c needs to be specified."
	echo "            -c, --currentFolder                                 Use the working directory as study folder. Either -s or -c needs to be specified."
	echo "            -m, --manualEdit       <manual_editing_tar_gz>      Specify manual editing folder. Should be archived and compressed (.tar.gz). Mandatory option."
	echo ""
}

for arg in $@
do
	case "$1" in 
		-s | --studyFolder)
							if [ ! -z "$2" ]; then
								studyFolder=$2
							else
								disp_usage
								exit 1
							fi
							shift 2
							;;

		-c | --currentFolder)
							studyFolder=`pwd`
							shift
							;;

		-m | --manualEdit)
							if [ ! -z "$2" ]; then
								manEdtTZ=$2
							else
								echo "Error: manual editing files (.tar.gz) needs to be specified."
								disp_usage
								exit 1
							fi
							shift 2
							;;

		-*)
							disp_usage
							exit 1
							;;
	esac
done

if [ -z "${studyFolder}" ] || [ -z "${manEdtTZ}" ]; then
	disp_usage
	exit 1
else
	echo "study folder = ${studyFolder}"
	echo "manual editing = ${manEdtTZ}"
fi

if [ -d "${studyFolder}/manual_editing" ]; then
	rm -fr ${studyFolder}/manual_editing
fi
mkdir ${studyFolder}/manual_editing

mv ${manEdtTZ} ${studyFolder}/manual_editing/.
cd ${studyFolder}/manual_editing

echo "Uncompressing ..."

tar zxf $(basename ${manEdtTZ})
if [ -d "manual_editing" ]; then
	cd manual_editing
fi

if [ -f "${studyFolder}/subjects/WMH_spreadsheet.txt" ]; then
	mv ${studyFolder}/subjects/WMH_spreadsheet.txt ${studyFolder}/subjects/WMH_spreadsheet_bfrEdit.txt
fi

for edtID in `ls -d *`
do
	mv ${studyFolder}/subjects/${edtID}/mri/extractedWMH/${edtID}_WMH.nii.gz \
		${studyFolder}/subjects/${edtID}/mri/extractedWMH/${edtID}_WMH_bfrEdit.nii.gz

	cp ${edtID}/${edtID}_WMH.nii* ${studyFolder}/subjects/${edtID}/mri/extractedWMH/.

	$(dirname $(realpath $0))/WMHext_reSegAftEdt.sh ${edtID} ${studyFolder}/subjects 12

done

# echo "Generating WMH summary spreadsheet for the study ..."

# echo "ID,wholeBrainWMHvol_mm3,PVWMHvol_mm3,DWMHvol_mm3,Lfrontal_WMHvol_mm3,Rfrontal_WMHvol_mm3,Ltemporal_WMHvol_mm3,Rtemporal_WMHvol_mm3,Lparietal_WMHvol_mm3,Rparietal_WMHvol_mm3,Loccipital_WMHvol_mm3,Roccipital_WMHvol_mm3,Lcerebellum_WMHvol_mm3,Rcerebellum_WMHvol_mm3,Brainstem_WMHvol_mm3" \
# > ${studyFolder}/subjects/WMH_spreadsheet.txt

$(dirname $(dirname $(realpath $0)))/WMHextraction/WMHspreadsheetTitle.sh ${studyFolder}/subjects

for T1_path in `ls ${studyFolder}/originalImg/T1/*.nii`
do
	T1_filename=`basename ${T1_path} .nii`
	ID=`echo ${T1_filename} | awk -F'_' '{print $1}'`

	$(dirname $(dirname $(realpath $0)))/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ${ID} ${studyFolder}/subjects
done

rm -fr ${studyFolder}/manual_editing

echo "Finished. Please refer to ${studyFolder}/subjects/WMH_spreadsheet.txt"