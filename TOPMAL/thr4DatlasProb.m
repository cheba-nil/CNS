%- Threshold 4D prob atlas, for only max prob

function thr4DatlasProb (atlas, atlasProbThr, output)

% read image to vols
atlas_vol = spm_vol (atlas);

% load data
atlas_vol_fourDdata = spm_read_vols (atlas_vol);

% size of image
[xdim, ydim, zdim, Nvols] = size (atlas_vol_fourDdata);

maxVal = zeros (xdim, ydim, zdim);
maxIdx = zeros (xdim, ydim, zdim);

for x = 1:xdim
    for y = 1:ydim
        for z = 1:zdim
            [maxVal(x,y,z), maxIdx(x,y,z)] = max (atlas_vol_fourDdata (x, y, z, :));
            
            % if less than threshold, assign 0 to index (eliminate after thresholding)
            if maxVal(x,y,z) < atlasProbThr
                maxIdx(x,y,z) = 0;
            % if max val is 0, assign 0 to index (background)
            elseif maxVal(x,y,z) == 0
                maxIdx(x,y,z) = 0;
            end
        end
    end
end

atlasMask = atlas_vol(1,1);
atlasMask.fname = output;
spm_write_vol(atlasMask, maxIdx);