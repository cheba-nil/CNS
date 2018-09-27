function Nvoxs_Vol_onAtlas = calcOverlapVoxVol_thrAtlas_NvoxsVol (DARTEL_lesionMask, DARTEL_atlas, atlasCode, lesionOnAtlasImgOutput)

% No of vols in atlas
switch atlasCode
    case 'JNU-ICBM_WM_tract_prob_1mm'
        atlasNvol = 20;
    case 'HO_subcortical_1mm'
        atlasNvol = 21;
end

% initialise a variable for number of voxels on each region of the atlas
% (column 1), and volume (column 2)
Nvoxs_Vol_onAtlas = zeros (atlasNvol, 2);

% read image to vol
DARTEL_lesionMask_vol = spm_vol (DARTEL_lesionMask);
DARTEL_atlas_vol = spm_vol (DARTEL_atlas);

% read data
DARTEL_lesionMask_3Ddata = spm_read_vols (DARTEL_lesionMask_vol);
DARTEL_atlas_3Ddata = spm_read_vols (DARTEL_atlas_vol);

% element-wise multiplication
DARTEL_lesionOnAtlas_3Ddata = DARTEL_lesionMask_3Ddata .* DARTEL_atlas_3Ddata;

% count number of voxels
for i = 1:atlasNvol
    Nvoxs_Vol_onAtlas (i, 1) = numel (DARTEL_lesionOnAtlas_3Ddata (DARTEL_lesionOnAtlas_3Ddata == i));
    Nvoxs_Vol_onAtlas (i, 2) = Nvoxs_Vol_onAtlas (i, 1) * 1.5 * 1.5 * 1.5;
end

% output lesion/atlas overlap image
lesion_atlas_overlapping = DARTEL_atlas_vol;
lesion_atlas_overlapping.fname = lesionOnAtlasImgOutput;
spm_write_vol (lesion_atlas_overlapping, DARTEL_lesionOnAtlas_3Ddata);