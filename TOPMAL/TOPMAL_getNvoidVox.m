function NvoidVox = TOPMAL_getNvoidVox (DARTEL_lesionMask_3Ddata, ...
										DARTEL_threeD_dischargedAtlases_dataPart_4D)

[Nrow, Ncol, Nslices, Nvol] = size (DARTEL_threeD_dischargedAtlases_dataPart_4D);

DARTEL_lesionMask_applied2atlas = zeros (Nrow, Ncol, Nslices, Nvol);

for i = 1:Nvol
    DARTEL_lesionMask_applied2atlas (:,:,:,i) = DARTEL_threeD_dischargedAtlases_dataPart_4D (:,:,:,i) .* DARTEL_lesionMask_3Ddata;
end

DARTEL_lesionMaskOnatlas_overlap = sum (DARTEL_lesionMask_applied2atlas,4);
DARTEL_lesionMaskOnatlas_overlap (DARTEL_lesionMaskOnatlas_overlap ~= 0) = 1;

NvoidVox = nnz (DARTEL_lesionMask_3Ddata) - nnz (DARTEL_lesionMaskOnatlas_overlap);
