% To solve problem where masks include voxels with intensity = 0, and want
% to include these voxels in calculating mean

% varargin{1} = 'write' if want to save meanInt.txt in img_nii_gz folder

function meanInt = CNSP_getMeanIntensityWithinMask (img_nii_gz, mask_nii_gz, varargin)

% mask img with mask
[img_nii_gz_folder, img_nii_gz_filename, ~] = fileparts (img_nii_gz);
img_nii_gz_filename_partsCelllArr = strsplit (img_nii_gz_filename);
img_nii_gz_filename = img_nii_gz_filename_partsCelllArr{1};

system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
            'fslmaths ' img_nii_gz ' -mas ' mask_nii_gz ' ' img_nii_gz_folder '/' img_nii_gz_filename '_masked']);
        
masked_img_nii_gz = [img_nii_gz_folder '/' img_nii_gz_filename '_masked.nii.gz'];
        
% get sum of intensities in masked img
[~, non0meanInt] = system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
                                'fslstats ' masked_img_nii_gz ' -M']);
                    
[~, non0Nvox_char] = system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
                                'fslstats ' masked_img_nii_gz ' -V']);
                            
non0Nvox_parts = strsplit (non0Nvox_char, ' ');

non0Nvox = non0Nvox_parts{1};

sumInt = str2num (non0meanInt) * str2num (non0Nvox);


% get Num of non-zero voxels in mask
[~, Nnon0voxInMask_char] = system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
                                'fslstats ' mask_nii_gz ' -V']);
                            
Nnon0voxInMask_parts = strsplit (Nnon0voxInMask_char, ' ');

Nnon0voxInMask = Nnon0voxInMask_parts{1};


% mean intensity in mask
meanInt = sumInt / str2num (Nnon0voxInMask);
                            
% write to text
if (nargin == 3) && strcmp (varargin{1}, 'write')
    meanIntTxt = [img_nii_gz_folder '/meanInt.txt'];
    if exist (meanIntTxt, 'file') == 2
        system (['rm -f ' meanIntTxt]);
    end
    
    fid = fopen (meanIntTxt, 'w');
    fprintf (fid, '%.5f\n', meanInt);
    fclose (fid);
end