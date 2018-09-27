% ---------------------
% CNSP_getLatVentricles
% ---------------------

% DESCRIPTION
% -----------
% Get lateral ventricles from low resolution images.
% Used OATS 65to75 template, so may not work well for young brains.
%
%
% USAGE
% -----
% img = any modality MRI
% T1 = T1-weighted image of the same individual
% outputFolder = output path
% spm12path = spm12 directory
% 
%
% OTHER INFO
% ----------
% Use whole head for img and T1, not NBTR
%
%
% Written by Dr. Jiyang Jiang. December 2017.
%

function ventricle_native = CNSP_getLatVentricles (img, T1, outputFolder, spm12path)


scriptFolder = fileparts (mfilename ('fullpath'));
CNSP_path = fileparts (fileparts (mfilename ('fullpath')));
addpath (scriptFolder, spm12path);

% get T1 folder
[T1folder, ~, ~] = fileparts (T1);

% img register to T1
CNSP_registration (img, T1, outputFolder);

% T1 segmentation
[cGM,cWM,cCSF,rcGM,rcWM,rcCSF,mat] = CNSP_segmentation (T1, spm12path);


% T1 to DARTEL
template1 = [CNSP_path '/Templates/DARTEL_0to6_templates/65to75/Template_1.nii'];
template2 = [CNSP_path '/Templates/DARTEL_0to6_templates/65to75/Template_2.nii'];
template3 = [CNSP_path '/Templates/DARTEL_0to6_templates/65to75/Template_3.nii'];
template4 = [CNSP_path '/Templates/DARTEL_0to6_templates/65to75/Template_4.nii'];
template5 = [CNSP_path '/Templates/DARTEL_0to6_templates/65to75/Template_5.nii'];
template6 = [CNSP_path '/Templates/DARTEL_0to6_templates/65to75/Template_6.nii'];

flowMap = CNSP_runDARTELe (rcGM, rcWM, rcCSF, template1, template2, template3, template4, template5, template6);

OATS_ventricle = [CNSP_path '/Templates/DARTEL_ventricle_distance_map/DARTEL_ventricle_65to75.nii.gz'];
system (['if [ -f "' outputFolder '/DARTEL_ventricle_65to75.nii.gz" ];then rm -f ' outputFolder '/DARTEL_ventricle_65to75.nii.gz;fi']);
system (['cp ' OATS_ventricle ' ' outputFolder]);
system (['if [ -f "' outputFolder '/DARTEL_ventricle_65to75.nii" ];then rm -f ' outputFolder '/DARTEL_ventricle_65to75.nii;fi']);
system (['gunzip ' outputFolder '/DARTEL_ventricle_65to75.nii.gz']);


% bring ventricle to T1
T1space_img = CNSP_DARTELtoNative ([outputFolder '/DARTEL_ventricle_65to75.nii'], ...
                                    flowMap, ...
                                    'NN');

% reslice T1space_img to the same dimension as T1
files = {T1;T1space_img};
resliceFlags= struct('interp',1,... % B-spline
					'mask',1,...
					'mean',0,...
					'which',1,...
					'wrap',[0 0 0],...
                    'prefix','T1spaceanddim_');
spm_reslice (files,resliceFlags);

% refine ventricular mask in T1 space
T1spaceanddim_vent_struct = dir ([T1folder '/T1spaceanddim_*.nii']);
T1spaceanddim_vent = [T1folder '/' T1spaceanddim_vent_struct.name];

system ([CNSP_path '/Scripts/CNSP_getLatVentricles_dilationAndMapC3.sh ' ...
                                                                        T1spaceanddim_vent ' ' ...
                                                                        cCSF ' ' ...
                                                                        outputFolder]);
system (['gunzip ' outputFolder '/ventricular_mask.nii.gz']);

CNSP_reverse_registration_wMx (img, T1, [outputFolder '/ventricular_mask.nii']);

system (['mv ' cGM ' ' ...
                cWM ' ' ...
                cCSF ' ' ...
                mat ' ' ...
                T1folder '/r*.nii ' ...
                T1folder '/w*.nii ' ...
                flowMap ' ' ...
                T1folder '/T1spaceanddim_*.nii ' ...
                outputFolder]);

ventricle_native = [outputFolder '/rventricular_mask.nii'];

system (['. ${FSLDIR}/etc/fslconf/fsl.sh;gzip ' ventricle_native ';${FSLDIR}/bin/fslmaths ' ventricle_native '.gz -nan -thr 0 -bin ' ventricle_native '.gz;gunzip ' ventricle_native '.gz']);
