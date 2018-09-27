function map2atlas_single (studyFolder, DARtem, ageRange, spm12path, atlasCode, atlasProbThr, thrORunthr, DARTEL_lesionMask, lesionOnAtlasImgOutput)

% stop scientific notation
format short

% backup losion mask, because it could be deleted if error happened when processing
copyfile (DARTEL_lesionMask, [DARTEL_lesionMask '.backup'], 'f');

% add paths
[map2atlasPath, ~, ~] = fileparts (which(mfilename));
[CNSPpath, ~, ~] = fileparts (map2atlasPath);
addpath (map2atlasPath, [CNSPpath '/Scripts'], spm12path);

% unzip lesion mask
[DARTEL_lesionMask_path, DARTEL_lesionMask_filename, DARTEL_lesionMask_ext] = fileparts (DARTEL_lesionMask);
if strcmp (DARTEL_lesionMask_ext, '.gz')
    CNSP_gunzipnii (DARTEL_lesionMask);
    DARTEL_lesionMask = [DARTEL_lesionMask_path '/' DARTEL_lesionMask_filename];
end

% map MNI atlas to DARTEL space, and calculate output
switch thrORunthr
    case 'thr'
        DARTELatlas = getThresholdedDARTELatlas (studyFolder, DARtem, ageRange, spm12path, atlasCode, atlasProbThr);
        Nvoxs_Vol_onAtlas = calcOverlapVoxVol_thrAtlas (DARTEL_lesionMask, DARTELatlas, atlasCode, lesionOnAtlasImgOutput);
        
    case 'unthr'
        DARTELatlas = getUnthresholdedDARTELatlas (studyFolder, DARtem, ageRange, spm12path, atlasCode, atlasProbThr);
        Nvoxs_Vol_onAtlas = calcOverlapVoxVol_unthrAtlas (DARTEL_lesionMask, DARTELatlas, atlasCode, lesionOnAtlasImgOutput);
end

% gunzip WMH for storage and future re-processing
system (['${FSLDIR}/bin/fslchfiletype NIFTI_GZ ' DARTEL_lesionMask]);

% write Nvoxs and Vol to csv file
[lesionOnAtlasImgOutput_path, lesionOnAtlasImgOutput_filename, ~] = fileparts (lesionOnAtlasImgOutput);
csvOutput = [lesionOnAtlasImgOutput_path '/' lesionOnAtlasImgOutput_filename '.dat'];

if exist (csvOutput, 'file') == 2
    delete (csvOutput);
end
csvwrite (csvOutput, Nvoxs_Vol_onAtlas);