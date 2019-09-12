Other functions after WMH segmentation
======================================

Manual Editing
--------------

After the final QC, you can select the subjects for manual editing, and re-calculate the volumes of global and regional WMH.

a) `/path/to/CNSP/WMH_extraction/cmd/manEdt/WMHext_manEdt_dnld.sh -s /path/to/studyFolder -i [list_of_IDs]`, where `[list_of_IDs]` is the list of IDs you want to edit, separated by coma. The script will generate a manual_editing.tar.gz file under the study folder.

b) After uncompressing, the manual_editing folder contains the subjects you want to edit. For each subject, you can overlay the `ID_WMH.nii.gz` onto `wrID_*.nii.gz`, and editing the `ID_WMH.nii.gz` file in `FSLVIEW`. Replace the `ID_WMH.nii.gz` file with your edited WMH image.

c) After finishing all the subjects, run `tar czvf manual_editing.tar.gz manual_editing/*` in the parent folder of the manual_editing folder.

d) Run `/path/to/CNSP/WMH_extraction/cmd/manEdt/WMHext_manEdt_upld.sh -s /path/to/studyFolder -m /path/to/manual_editing.tar.gz`

Re-extraction
-------------
Users are able to re-extract WMH from middle steps, without the necessity of starting from the beginning after changing settings. This can be done by selecting the ‘Extract again’ menu on the top of UBO Detector GUI. UBO Detector offers options to re-extract WMH with:

 - A different DARTEL template
 - A different kNN classifier
 - A different probability threshold
 - A different PVWMH magnitude

View kNN search
---------------
