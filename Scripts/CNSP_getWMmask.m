% --------------
% CNSP_getWMmask
% --------------
%
%
% DESCRIPTION
% -----------
% Get the WM mask for low resolution image. Requires T1 image.
%
%
% Written by Dr. Jiyang Jiang on March 2018

function CNSP_getWMmask (lowResImg, T1, outputFolder, spm12path)

	CNSscriptFolder = fileparts (mfilename ('fullpath'));

	addpath (CNSscriptFolder, spm12path);

	% T1 segmentation to get WM mask in T1 space
	[cGM,cWM,cCSF,rcGM,rcWM,rcCSF,seg8mtx] = CNSP_segmentation (T1, spm12path);

	if exist ([outputFolder '/temp_CNSPgetWMmask'], 'dir') == 7
		system (['rm -fr ' outputFolder '/temp_CNSPgetWMmask']);
	end

	system (['mkdir ' outputFolder '/temp_CNSPgetWMmask']);

	system (['cp ' cWM ' ' outputFolder '/WMmask_T1space.nii']);

	% NBTR T1
	CNSP_NBTRn (T1, cGM, cWM, cCSF, [outputFolder '/temp_CNSPgetWMmask/T1brain']);

	system (['mv ' cGM ' ' cWM ' ' cCSF ' ' rcGM ' ' rcWM ' ' rcCSF ' ' ...
										outputFolder '/temp_CNSPgetWMmask']);


	% bring WM mask in T1 space to lowResImg space
	WMmask_T1space = [outputFolder '/WMmask_T1space.nii'];
	system (['gzip ' WMmask_T1space]);
	WMmask_T1space = [outputFolder '/WMmask_T1space.nii.gz'];

	system ([CNSscriptFolder '/CNSP_reverse_registration_wMx_FSLflirt.sh ' [outputFolder '/temp_CNSPgetWMmask/T1brain'] ' ' ...
																		   lowResImg ' ' ...
																		   WMmask_T1space ' ' ...
																		   outputFolder]);

	system (['mv ' outputFolder '/otherImg_in_srcImgSpace.nii.gz ' outputFolder '/WMprobmask.nii.gz']);