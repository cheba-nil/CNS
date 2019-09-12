TOolbox for Probablistic MApping of Lesions (TOPMAL)
====================================================
TOPMAL can map any lesion masks in DARTEL space to Johns Hopkins White Matter Tractography Atlas (JHU-WM atlas) or Harvard-Oxford (HO) Subcortical Atlas. The output of lesion loadings can be used for region-of-interest (ROI) lesion- symptom mapping (LSM) studies (see `Biesbroek JM, et al. <https://www.ncbi.nlm.nih.gov/pubmed/28385827>`_ for a review).

Citation
--------

If TOPMAL is used in your study, please cite:

*Jiang, J., Paradise, M., Liu, T., Armstrong, N. J., Zhu, W., Kochan, N. A., Brodaty, H., Sachdev, P. S., Wen, W. The association of regional white matter lesions with cognition in a community-based cohort of older individuals, NeuroImage: Clinical 19:14-21 (2018), doi.org/10.1016/j.nicl.2018.03.035*

Please also refer to `this website <https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Atlases>`_ for proper citation of the atlases.

TOPMAL GUI User Guide
----------------------

**Step 1:** In MATLAB, add CNS to your path: `addpath ('/path/to/CNS');`

**Step 2:** Open CNS by typing `CNS`

**Step 3:** In the menu, select `map2atlas -> TOPMAL`. You will see the user interface of TOPMAL.

**Step 4:** If your lesion masks are white matter lesion (WML) masks generated using UBO Detector which follows a specific folder structure, please select **Yes** to the question "Lesion masks from UBO Detector?". Otherwise, please choose **No**, and prepare a folder with lesion masks in DARTEL space, and name them as `ID_lesMask.nii`.

**Step 5:** Use the `Find` button to specify the path to the study folder where the output will be saved.

**Step 6:** Use the `Find` button to specify the path to the folder where the lesion masks are stored. These lesion masks should have been warped to DARTEL space. This step is not necessary for WML masks generated from UBO Detector (i.e. answering "Yes" to Step 4).

**Step 7:** Use the `Find` button to specify the path to SPM12 folder.

**Step 8:** If you are using WML lesion masks generated from the `UBO_Detector`_, and used the "existing template" option in UBO Detector to map to the existing DARTEL templates, i.e. either existing DARTEL templates for less than 55 years old, 65-75 years old, or 70-80 years old, please select `existing template for less than 55 yo`, `existing template for 65 to 75 yo`, or `existing template for 70 to 80 yo` correspondingly. In such cases, we have stored the warped atlases in DARTEL space in CNS, and you do not need to rerun DARTEL. Otherwise, please select `creating template`, and TOPMAL will pop up a window to ask for Template1.nii, Template2.nii, ... Template6.nii for the MNI-to-DARTEL transformation.

**Step 9:** Choose the atlas you want to map the lesion masks to. `"JHU-ICBM_WM_tract_prob_1mm"` represents the Johns Hopkins White Matter Tractography Atlas, and `"HO_subcortical_1mm"` is the Harvard-Oxford Subcortical Structural Atlas.

**Step 10:** Input the IDs (separated by space) you want to exclude from the TOPMAL analysis. This text box is only activated if you choose "Yes" to the question of "Lesion masks from UBO Detector", meaning that if you excluded any subjects from UBO Detector, please list them in this text box.

**Step 11:** Click `Run TOPMAL` to run the analysis.

TOPMAL Commandline User Guide
-----------------------------

Users can run commandline from MATLAB command window (or with a bit of coding from Linux shell).

**Step 1:** Add TOPMAL folder to path: `addpath ('/path_to_CNS/TOPMAL');`

**Step 2:** Run TOPMAL. If the lesion masks were WML masks from UBO Detector, please use TOPMAL_UDver.m. For example:

	`TOPMAL_UDver ('/path/to/study/folder', DARTELtemplate, ageRange, '/path/to/SPM12', atlasCode, excldList);`

If the lesion masks were from elsewhere, please use TOPMAL_generic.m. For example,

	`TOPMAL_generic ('/path/to/DARTEL/lesion/masks/folder', '/path/to/study/folder', DARTELtemplate, ageRange, '/path/to/SPM12', atlasCode);`

    
	- `DARTELtemplate` can be either 'existing template' or 'creating template'.
	- `ageRange` can be 'lt55', '65to75', or '70to80' for 'existing template', or 'NA' for 'creating template'.
	- `atlasCode` can be 'JHU-ICBM_WM_tract_prob_1mm' or 'HO_subcortical_1mm'.
	- `excludList` is the list of IDs, separated by space, that you want to exclude from TOPMAL analyses.

TOPMAL Output
=============

Image output from TOPMAL
------------------------

The images showing lesion masks mapping to atlas can be found at `/path_to_study_folder/subjects/ID/mri/TOPMAL`

The atlases are in 4D format, with each volume showing one structure. The image outputs from TOPMAL are in 3D with each image showing one structure.

Text output from TOPMAL
------------------------

For each subject, the text output can be found at `/path_to_study_folder/subjects/ID/stats`

Each row represents one structure (see Appendix A for structure name). The five columns are **Absolute loading**, **Fractional loading**, **Number of voxels where lesion mask overlaps with each 3D atlas** (i.e. the 3D atlases (each represents one structure) splitted from the 4D atlas), **Number of completely void voxels**, and **Void loading of partially void voxels**. Please note the same number is shown in Column 4 and 5, respectively. This is because for one subject the number of completely void voxels and the void loading of partially void voxels are fixed.

For the whole cohort, TOPMAL outputs are summarised in:

    `/path_to_study_folder/subjects/TOPMAL_JHUwm_allprob.txt`

OR

    `/path_to_study_folder/subjects/TOPMAL_HOsub_allprob.txt`

Where \*_absLoading is the absolute loading; \*_fraLoading is the fractional loading; \*_Nvox is the number of voxels where lesion mask overlaps with the structure; N_complete_void_vox is the number of completely void voxels; totalVoidLoading_partialVoidVox is the total void loading of partially void voxels.
Appendix A: Structure name for JHU-WM and HO Subcortical atlases

JHU WM tracts
-------------
	- JHU0 anterior_thalamic_radiation_L
	- JHU1 anterior_thalamic_radiation_R
	- JHU2 corticospinal_tract_L
	- JHU3 corticospinal_tract_R
	- JHU4 cingulum_(cingulate_gyrus)_L
	- JHU5 cingulum_(cingulate_gyrus)_R
	- JHU6 cingulum_(hippocampus)_L
	- JHU7 cingulum_(hippocampus)_R
	- JHU8 forceps_major
	- JHU9 forceps_minor
	- JHU10 inferior_fronto-occipital_fasciculus_L
	- JHU11 inferior_fronto-occipital_fasciculus_R
	- JHU12 inferior_longitudinal_fasciculus_L
	- JHU13 inferior_longitudinal_fasciculus_R
	- JHU14 superior_longitudinal_fasciculus_L
	- JHU15 superior_longitudinal_fasciculus_R
	- JHU16 uncinate_fasciculus_L
	- JHU17 uncinate_fasciculus_R
	- JHU18 superior_longitudinal_fasciculus_(temporal_part)_L
	- JHU19 superior_longitudinal_fasciculus_(temporal_part)_R

HO subcortical
--------------
	- HO0 left_cerebral_white_matter
	- HO1 left_cerebral_cortex
	- HO2 left_lateral_ventricle
	- HO3 left_thalamus
	- HO4 left_caudate
	- HO5 left_putamen
	- HO6 left_pallidum
	- HO7 brain-stem
	- HO8 left_hippocampus
	- HO9 left_amygdala
	- HO10 left_accumbens
	- HO11 right_cerebral_white_matter
	- HO12 right_cerebral_cortex
	- HO13 right_lateral_ventricle
	- HO14 right_thalamus
	- HO15 right_caudate
	- HO16 right_putamen
	- HO17 right_pallidum
	- HO18 right_hippocampus
	- HO19 right_amygdala
	- HO20 right_accumbens

.. _UBO_Detector: quickstart.html
