% --- get the number of clusters (seg0 and seg1) of the subject --- %

function [Nseg0, Nseg1] = clusterN (studyFolder, subjID)

seg0 = load_nii ([studyFolder '/subjects/' subjID '/mri/extractedWMH/temp/' subjID '_seg0.nii']);
seg1 = load_nii ([studyFolder '/subjects/' subjID '/mri/extractedWMH/temp/' subjID '_seg1.nii']);

Nseg0 = max(nonzeros(seg0.img));
Nseg1 = max(nonzeros(seg1.img));