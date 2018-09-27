function lesionLoadingOnAtlas = TOPMAL_calcOverlapVoxVol_unthrAtlas_allprob (DARTEL_lesionMask, ...
                                                                             DARTEL_threeD_dischargedAtlases, ...
                                                                             NatlasVols, ...
                                                                             lesionOnAtlasImgOutput)

% initialise a variable for output
lesionLoadingOnAtlas = zeros (NatlasVols, 5);


% read lesion image to vol
DARTEL_lesionMask_vol = spm_vol (DARTEL_lesionMask);
DARTEL_lesionMask_3Ddata = spm_read_vols (DARTEL_lesionMask_vol);

DARTEL_dimension = size (DARTEL_lesionMask_3Ddata);



% read discharged 3D atlases, form a 4D matrix with the data parts
DARTEL_dimension_4D = [DARTEL_dimension NatlasVols]; % add the fourth column which equals to Nvol
DARTEL_threeD_dischargedAtlases_dataPart_4D = zeros (DARTEL_dimension_4D);

for j = 1:NatlasVols    
%     DARTEL_threeD_dischargedAtlases_struct = load_nii (char (DARTEL_threeD_dischargedAtlases(j)));
%     DARTEL_threeD_dischargedAtlases_dataPart_4D (:,:,:,j) = DARTEL_threeD_dischargedAtlases_struct.img;
    DARTEL_threeD_dischargedAtlases_vol = spm_vol (char (DARTEL_threeD_dischargedAtlases(j)));
    DARTEL_threeD_dischargedAtlases_data = spm_read_vols (DARTEL_threeD_dischargedAtlases_vol);
    DARTEL_threeD_dischargedAtlases_dataPart_4D (:,:,:,j) = DARTEL_threeD_dischargedAtlases_data;
end



% element-wise multiplying lesion with atlas to get voxel-wise loading on each 3D atlas
DARTEL_lesionOnAtlas_4Ddata = zeros (DARTEL_dimension_4D);
parfor k = 1:NatlasVols
    DARTEL_lesionOnAtlas_4Ddata (:,:,:,k) = DARTEL_lesionMask_3Ddata .* DARTEL_threeD_dischargedAtlases_dataPart_4D (:,:,:,k);
end




% measurement (i.e. loadings)
for i = 1:NatlasVols

    % ====================================================
    % Absolute loading (Column 1)
    % -- lesion mask applied to each 3D probability atlas, 
    %    and sum of probability for each 3D atlas
    % ====================================================
    lesionLoadingOnAtlas (i, 1) = sum ( sum ( sum ((DARTEL_lesionOnAtlas_4Ddata (:,:,:,i))))) / 100;


    % =======================================================
    % Fractional loading (Column 2)
    % -- Absolute loading divided by sum of 
    %    probability of all voxels on the 3D probability mask
    % =======================================================
    lesionLoadingOnAtlas (i, 2) = lesionLoadingOnAtlas (i, 1) ...
                                  / sum ( sum ( sum ( DARTEL_threeD_dischargedAtlases_dataPart_4D (:,:,:,i))));

    % =========================================================================
    % Number of voxels where lesion mask overlaps with 3D prob atlas (Column 3)
    % =========================================================================
    lesionLoadingOnAtlas (i, 3) = nnz (DARTEL_lesionOnAtlas_4Ddata (:,:,:,i));
    

    % ===========================================
    % Number of completely void voxels (Column 4)
    % -- A column with the same number
    % ===========================================
    NvoidVox = TOPMAL_getNvoidVox (DARTEL_lesionMask_3Ddata, ...
                                   DARTEL_threeD_dischargedAtlases_dataPart_4D);
    lesionLoadingOnAtlas (i, 4) = NvoidVox; % a column of the same number


    % ===============================================================
    % Void loading of partially void voxels (Column 5)
    % -- i.e. those voxels with sum of lesion loading between 0 and 1
    % -- A column with the same number
    % ===============================================================
    totalVoidLoading_partiallyVoidVox = TOPMAL_getPartialVoidLoading (DARTEL_lesionMask_3Ddata, ...
                                                                      DARTEL_threeD_dischargedAtlases_dataPart_4D);
    lesionLoadingOnAtlas (i, 5) = totalVoidLoading_partiallyVoidVox; % a column of the same number

end




% output lesion/atlas overlap image
[lesionOnAtlasImgOutput_path, lesionOnAtlasImgOutput_filename, lesionOnAtlasImgOutput_ext] = fileparts (lesionOnAtlasImgOutput);
lesionOnAtlasImgOutput_arr = cell (NatlasVols, 1);

for m = 1:NatlasVols
    lesionOnAtlasImgOutput_arr{m,1} = [lesionOnAtlasImgOutput_path '/' lesionOnAtlasImgOutput_filename '_' num2str(m) lesionOnAtlasImgOutput_ext];
end

for n = 1:NatlasVols
    lesion_atlas_overlapping = DARTEL_lesionMask_vol;
    lesion_atlas_overlapping.fname = lesionOnAtlasImgOutput_arr{n,1};
    lesion_atlas_overlapping.dt(1) = 16;
    temp3Darr = DARTEL_lesionOnAtlas_4Ddata (:,:,:,n);
    spm_write_vol(lesion_atlas_overlapping,temp3Darr);
end

