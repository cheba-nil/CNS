function BIANCA_displayResults (output_folder, predictingIDstart_num, N_predictingIDs_num, thr_str)

CNS_scripts_folder = fileparts (fileparts (mfilename ('fullpath')));
addpath (CNS_scripts_folder);

if exist ([output_folder '/displayBIANCAresults'], 'dir') == 7
	system (['rm -fr ' output_folder '/displayBIANCAresults']);
end
system (['mkdir ' output_folder '/displayBIANCAresults']);
webView_folder = [output_folder '/displayBIANCAresults'];

BIANCA_result_folder = [output_folder '/BIANCA_result'];
IDlist = [output_folder '/IDlist.txt'];

fid = fopen (IDlist);
IDs_inOne = textscan (fid, '%s', 'Delimiter', '\n');
IDs_cellArr = IDs_inOne{1};
fclose (fid);

baseimg_folder = [output_folder '/rawFLAIR'];
overlay_folder = BIANCA_result_folder;

baseimg_cellArr = cell (N_predictingIDs_num, 1);
overlay_cellArr = cell (N_predictingIDs_num, 2);

for i = predictingIDstart_num : (predictingIDstart_num + N_predictingIDs_num - 1)
	baseimg_struct = dir ([baseimg_folder '/' IDs_cellArr{i} '_*.nii.gz']);
	baseimg_filename = baseimg_struct(1).name;
	baseimg_cellArr{(i-predictingIDstart_num+1),1} = [baseimg_folder '/' baseimg_filename];

	% before masking
	overlay_cellArr{(i-predictingIDstart_num+1),1} = [overlay_folder '/' IDs_cellArr{i} '_BIANCA_output_thr0_' thr_str '.nii.gz'];

	% after masking
	overlay_cellArr{(i-predictingIDstart_num+1),2} = [overlay_folder '/' IDs_cellArr{i} '_BIANCA_output_thr0_' thr_str '_masked.nii.gz'];

end

befMask_overlay_cellArr = cell (N_predictingIDs_num, 1);
aftMask_overlay_cellArr = cell (N_predictingIDs_num, 1);

for j = 1:N_predictingIDs_num
	befMask_overlay_cellArr{j,1} = overlay_cellArr{j,1};
	aftMask_overlay_cellArr{j,1} = overlay_cellArr{j,2};
end

CNSP_webViewSlices_overlay (baseimg_cellArr, befMask_overlay_cellArr, webView_folder, 'BIANCA_before_masking', 'web');
CNSP_webViewSlices_overlay (baseimg_cellArr, aftMask_overlay_cellArr, webView_folder, 'BIANCA_after_masking', 'web');