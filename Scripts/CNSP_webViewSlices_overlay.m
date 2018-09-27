% ------------------
% CNSP_webViewSlices_overlay
% ------------------
%
% DESCRIPTION:
%   Generate a webpage to view the slices of base-overlay image pairs
%
% INPUT:
%   baseImgCellArrVertical = vertical cell array containing path to base
%   images
%   overlayImgCellArrVertical = vertical cell array containing path to
%   overlay images. If more than one overlay images for each base image,
%   put each overlay image horizontally. i.e. number of columns equals to
%   number of overlay images for each base image.
%   outputDir = path to directory containing output
%   outputFormat = 'web', 'arch', 'web&arch'
%
% OUTPUT:
%   A webpage will automatically display on screeen.
%


function CNSP_webViewSlices_overlay (baseImgCellArrVertical, overlayImgCellArrVertical, outputDir, title, outputFormat)

% special characters in title
title = strrep (title, ' ', '_');
title = strrep (title, '.', '_');

if exist ([outputDir '/' title '.html'],'file') == 2
    delete([outputDir '/' title '.html']);
end

[Nsubj, Noverlay] = size (overlayImgCellArrVertical);
fprintf ('CNSP_webViewSlices_overlay: %d overlay image/s.\n', Noverlay);
[Nbaseimgs,~] = size(baseImgCellArrVertical);

if (Nbaseimgs ~= Nsubj)
    error ('CNSP_webViewSlices_overlay: Base and overlay image cell arrays are not of the same size.');
end


%% Slice images
fprintf ('CNSP_webViewSlices_overlay: Slicing images ...\n');
[scriptsFolder,~,~] = fileparts(which([mfilename '.m']));% get scripts folder
% system (['chmod +x ' scriptsFolder '/CNSP_webViewSlices_sliceBaseImg.sh']);
% system (['chmod +x ' scriptsFolder '/CNSP_webViewSlices_sliceOverlayOnBaseImg.sh']);

baseImg_pathNfilename = cell (Nbaseimgs,2);
overlayImg_pathNfilename = cell (Nsubj, (Noverlay*2));

for i = 1:Nbaseimgs
    [baseImgFolder,baseImgFilename,~] = fileparts (baseImgCellArrVertical{i,1});
    baseImg_pathNfilename{i,1} = baseImgFolder;
    baseImgFilename_parts = strsplit(baseImgFilename,'.');
    baseImg_pathNfilename{i,2} = baseImgFilename_parts{1};
    
    for k = 1:Noverlay
        [overlayImgFolder,overlayImgFilename,~] = fileparts (overlayImgCellArrVertical{i,k});
        overlayImgFilename_parts = strsplit(overlayImgFilename,'.');
        overlayImg_pathNfilename {i,(k*2-1)} = overlayImgFolder;
        overlayImg_pathNfilename {i,(k*2)} = overlayImgFilename_parts{1};
    end
end

parfor m = 1:Nbaseimgs
    system ([scriptsFolder '/CNSP_webViewSlices_sliceBaseImg.sh ' baseImg_pathNfilename{m,1} ' ' ...
                                                                  baseImg_pathNfilename{m,2} ' ' ...
                                                                  outputDir ...
                                                                  ]);
                                                              
    for n = 1:Noverlay
        system ([scriptsFolder '/CNSP_webViewSlices_sliceOverlayOnBaseImg.sh ' baseImg_pathNfilename{m,1} ' ' ...
                                                                               baseImg_pathNfilename{m,2} ' ' ...
                                                                               overlayImg_pathNfilename{m,(n*2-1)} ' ' ...
                                                                               overlayImg_pathNfilename{m,(n*2)} ' ' ...
                                                                               outputDir ...
                                                                               ]);
    end
end


%% generate webpage to view
%outputDir '/' title '.html
html_txt = cell ((Nbaseimgs + Noverlay * Nsubj + 2), 1);
html_txt{1} = ['<HTML><TITLE>' title '</TITLE><BODY BGCOLOR="#aaaaff">'];
for p = 1:Nbaseimgs
    html_txt{(2 + (p-1) * (Noverlay+1)), 1} = ['<a><img src="' outputDir '/' baseImg_pathNfilename{p,2} '_Slices_merged.png" WIDTH=1000 > ' baseImg_pathNfilename{p,2} '</a><br>'];
    for q = 1:Noverlay
        html_txt{(2 + (p-1) * (Noverlay+1) + q), 1} = ['<a><img src="' outputDir '/' overlayImg_pathNfilename{p,(q*2)} '_on_' baseImg_pathNfilename{p,2} '_Slices_merged.png" WIDTH=1000 >' overlayImg_pathNfilename{p,(q*2)} '_on_' baseImg_pathNfilename{p,2} '</a><br>'];
    end
end
% 	echo "" >> ${outputDir}/${title}.html
% 	echo "<a><img src=\"${outputDir}/${overlayOnBaseImg}_Slices_merged.png\" WIDTH=1000 > ${overlayOnBaseImg}</a><br>" >> ${outputDir}/${title}.html
html_txt{end,1} =  '</BODY></HTML>';

% write html to text file
fid = fopen ([outputDir '/' title '.html'], 'wt');
fprintf (fid, '%s\n', html_txt{:});
fclose(fid);


%% view
switch outputFormat
    case 'web'
        fprintf ('CNSP_webViewSlices_overlay: Generating webpage ...\n');
        web ([outputDir '/' title '.html'], '-new');
    case 'arch'
        fprintf ('CNSP_webViewSlices_overlay: Archiving for download ...\n');
        archive (outputDir, title);
    case 'web&arch'
        fprintf ('CNSP_webViewSlices_overlay: Generating webpage ...\n');
        web ([outputDir '/' title '.html'], '-new');
        fprintf ('CNSP_webViewSlices_overlay: Archiving for download ...\n');
        archive (outputDir, title);
end


fprintf('CNSP_webViewSlices_overlay: Done.\n');

function archive (outputDir, title)
    if exist ([outputDir '/download'], 'dir') == 7
        rmdir ([outputDir '/download'], 's');
    end
    mkdir (outputDir, 'download');
    system (['cp ' outputDir '/*.png ' outputDir '/download/.']);
    outputDir_shell = strrep (outputDir, '/', '\/');
    system (['cp ' outputDir '/' title '.html ' outputDir '/download/.']);
    system (['sed -i.bak ''s/' outputDir_shell '/\./g'' ' outputDir '/download/' title '.html']);
    
    zip ([outputDir '/' title '.zip'], {'*.png', '*.html'}, [outputDir '/download']);
    
    fprintf (['Download link: ' outputDir '/' title '.zip\n']);
