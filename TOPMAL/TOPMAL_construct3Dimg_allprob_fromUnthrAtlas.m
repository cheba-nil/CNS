function [Nvols, threeD_dischargedAtlases] = TOPMAL_construct3Dimg_allprob_fromUnthrAtlas (fourDatlas)

fprintf ('TOPMAL_construct3Dimg_allprob_fromUnthrAtlas: Building 3D atlasese.\n');

[fourDatlas_path, fourDatlas_filename, fourDatlas_ext] = fileparts (fourDatlas);

% if fourDatlas is in .nii.gz
if strcmp (fourDatlas_ext, '.gz')
	tmpCellArr = strsplit (fourDatlas_filename, '.');
	fourDatlas_filename = tmpCellArr{1};
	fourDatlas_ext = '.nii.gz';
end


% read image to vols
% atlas_vol = spm_vol (fourDatlas);

% load data
% atlas_vol_fourDdata = spm_read_vols (atlas_vol);

% add path
% CNSPpath = fileparts (fileparts (which (mfilename)));
% addpath (genpath ([CNSPpath '/downloaded_scipts']));
% 
% % read four D atlas
% fourDatlas_struct = load_nii (fourDatlas);
% 
% % size of image
% [~, ~, ~, Nvols] = size (fourDatlas_struct.img);
% 
% threeD_dischargedAtlases = cell (Nvols,1);
% 
% for i = 1:Nvols
%     save_nii (make_nii (fourDatlas_struct.img(:,:,:,i)), ...
%                 [fourDatlas_path '/' fourDatlas_filename '_' num2str(i) fourDatlas_ext]);
% %     atlasVol.dt (1) = 16; % float 32
% %     spm_write_vol(atlasVol, atlas_vol_fourDdata(:,:,:,i));
% %     
%     threeD_dischargedAtlases{i,1} = [fourDatlas_path '/' fourDatlas_filename '_' num2str(i) fourDatlas_ext];
% end



% ----------------------------------------------
% Use fslsplit -- fslsplit output in working dir
% ----------------------------------------------
system (['. ${FSLDIR}/etc/fslconf/fsl.sh;' ...
		 'cd ' fourDatlas_path ';' ...
		 '${FSLDIR}/bin/fslsplit ' fourDatlas ';' ...
		 'cd -']);

splitted_3Dimg_list = dir ([fourDatlas_path '/vol00*.nii.gz']);
[N_3Dimg, ~] = size (splitted_3Dimg_list);

threeD_dischargedAtlases = cell (N_3Dimg,1);

parfor i = 1:N_3Dimg
    system (['mv ' fourDatlas_path '/' splitted_3Dimg_list(i).name ' ' ...
    				fourDatlas_path '/' fourDatlas_filename '_' num2str(i) '.nii.gz']);
    % system (['. ${FSLDIR}/etc/fslconf/fsl.sh; ${FSLDIR}/bin/fslchfiletype NIFTI ' fourDatlas_path '/' fourDatlas_filename '_' num2str(i) '.nii.gz']);
    system (['gunzip -f ' fourDatlas_path '/' fourDatlas_filename '_' num2str(i) '.nii.gz']);
    
    threeD_dischargedAtlases{i,1} = [fourDatlas_path '/' fourDatlas_filename '_' num2str(i) '.nii'];
end

Nvols = N_3Dimg;

fprintf ('TOPMAL_construct3Dimg_allprob_fromUnthrAtlas: Done.\n');

