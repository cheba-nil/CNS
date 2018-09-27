dicomfiles=spm_select;
hdr=spm_dicom_headers(dicomfiles);
spm_dicom_convert(hdr, 'all', 'series', 'nii')  

