function construct3Dimg_maxprob_fromUnthrAtlas (fourDatlas, output)

% read image to vols
atlas_vol = spm_vol (fourDatlas);

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
            
            % background = 0, instead of 1
            if maxVal(x,y,z) == 0
            	maxIdx(x,y,z) = 0;
            end
            
            % 100% = 0.999, instead of 1
            if maxVal(x,y,z) == 100
                maxVal(x,y,z) = 99;
            end
        end
    end
end

threeD_maxprob_unthr = maxVal/100 + maxIdx;
atlasMask = atlas_vol(1,1);
atlasMask.fname = output;
atlasMask.dt (1) = 16; % float 32
spm_write_vol(atlasMask, threeD_maxprob_unthr);