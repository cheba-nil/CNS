function totalVoidLoading_partiallyVoidVox = TOPMAL_getPartialVoidLoading (DARTEL_lesionMask_3Ddata, ...
																  DARTEL_threeD_dischargedAtlases_dataPart_4D)

[Nrow, Ncol, Nslices, Nvol] = size (DARTEL_threeD_dischargedAtlases_dataPart_4D);

DARTEL_lesionMask_applied2atlas = zeros (Nrow, Ncol, Nslices, Nvol);

DARTEL_allOne = ones (Nrow, Ncol, Nslices);

for i = 1:Nvol
    DARTEL_lesionMask_applied2atlas (:,:,:,i) = DARTEL_threeD_dischargedAtlases_dataPart_4D (:,:,:,i) .* DARTEL_lesionMask_3Ddata / 100;
end

DARTEL_lesionMask_atlas_overlap = sum (DARTEL_lesionMask_applied2atlas,4);
DARTEL_allone_MINUS_lesionMask_atlas_overlap = DARTEL_allOne - DARTEL_lesionMask_atlas_overlap;
DARTEL_allone_MINUS_lesionMask_atlas_overlap (DARTEL_allone_MINUS_lesionMask_atlas_overlap >= 1) = 0; % remove completely void voxels; will not be greater 
																									  % than 1 actually.
DARTEL_allone_MINUS_lesionMask_atlas_overlap (DARTEL_allone_MINUS_lesionMask_atlas_overlap <= 0) = 0; % sum of lesion loading >= 1 is not considered as void

totalVoidLoading_partiallyVoidVox = sum( sum( sum( DARTEL_allone_MINUS_lesionMask_atlas_overlap)));