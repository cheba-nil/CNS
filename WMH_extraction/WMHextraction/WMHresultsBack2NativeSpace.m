%
%   varargin{1} = 'long' for longitudinal analyses
%   varargin{2} = 'creating template'

function WMHresultsBack2NativeSpace (studyFolder, ID, spm12path, varargin)

CNSP_path = fileparts (fileparts (fileparts (which (mfilename))));
addpath ([CNSP_path '/Scripts'], spm12path);


if nargin == 3
    T1name_struct = dir ([studyFolder '/originalImg/T1/' ID '_*.nii']);
    T1name = T1name_struct.name;

elseif (nargin > 3) && strcmp (varargin{1}, 'long')
    IDparts = strsplit (ID, '_');
    baseID = IDparts{1,1};
    T1name_struct = dir ([studyFolder '/originalImg/T1/' baseID '_tp1_*.nii']);
    T1name = T1name_struct.name;

elseif (nargin > 3) && ~ strcmp (varargin{1}, 'long')
    T1name_struct = dir ([studyFolder '/originalImg/T1/' ID '_*.nii']);
    T1name = T1name_struct.name;
end
FLAIRname_struct = dir ([studyFolder '/originalImg/FLAIR/' ID '_*.nii']);
FLAIRname = FLAIRname_struct.name;

% bring DARTEL WMH to T1 native space
copyfile ([studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii.gz'], ...
            [studyFolder '/subjects/' ID '/mri/extractedWMH/temp']);
        
CNSP_gunzipnii ([studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' ID '_WMH.nii.gz']);

if nargin == 3
    T1space_WMH = CNSP_DARTELtoNative ([studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' ID '_WMH.nii'], ... % DARTEL WMH
                                    [studyFolder '/subjects/' ID '/mri/preprocessing/u_rc1' T1name], ... % flow map
                                    'NN'); % nearest neighbours

elseif nargin == 4 && strcmp (varargin{1}, 'long')
    IDparts = strsplit (ID, '_');
    baseID = IDparts{1,1};
    
    tp1_u_rc1_filename = dir ([studyFolder '/subjects/' baseID '_tp1/mri/preprocessing/u_rc1*.nii']);
    
    T1space_WMH = CNSP_DARTELtoNative ([studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' ID '_WMH.nii'], ... % DARTEL WMH
                                    [studyFolder '/subjects/' baseID '_tp1/mri/preprocessing/' tp1_u_rc1_filename(1).name], ... % flow map
                                    'NN'); % nearest neighbours

elseif nargin == 5 && strcmp (varargin{2}, 'creating template')
    T1filename_parts = strsplit (T1name, '.');
    T1filename = T1filename_parts{1,1};

    T1space_WMH = CNSP_DARTELtoNative ([studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' ID '_WMH.nii'], ... % DARTEL WMH
                                [studyFolder '/subjects/' ID '/mri/preprocessing/u_rc1' T1filename '_Template.nii'], ... % flow map
                                'NN'); % nearest neighbours
end
                            
movefile (T1space_WMH, ...
            [studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' ID '_WMH_T1space.nii']); % rename T1 space WMH
        
T1space_WMH = [studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' ID '_WMH_T1space.nii'];

if nargin == 3
    copyfile ([studyFolder '/subjects/' ID '/mri/orig/' T1name], ...
                [studyFolder '/subjects/' ID '/mri/extractedWMH/temp']); % copy original T1

elseif nargin > 3 && strcmp (varargin{1}, 'long')
    IDparts = strsplit (ID, '_');
    baseID = IDparts{1,1};
    copyfile ([studyFolder '/subjects/' baseID '_tp1/mri/orig/' T1name], ...
                [studyFolder '/subjects/' ID '/mri/extractedWMH/temp']); % copy original T1

elseif nargin > 3 && ~ strcmp (varargin{1}, 'long')
    copyfile ([studyFolder '/subjects/' ID '/mri/orig/' T1name], ...
                [studyFolder '/subjects/' ID '/mri/extractedWMH/temp']); % copy original T1
end

copyfile ([studyFolder '/subjects/' ID '/mri/orig/' FLAIRname], ...
            [studyFolder '/subjects/' ID '/mri/extractedWMH/temp']); % copy original FLAIR
        
origT1 = [studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' T1name];
origFLAIR = [studyFolder '/subjects/' ID '/mri/extractedWMH/temp/' FLAIRname];

% reslice to T1 dim. inverse warped generates same dim as flow map
% flags= struct('interp',0,... % nearest neighbour
%                 'mask',1,...
%                 'mean',0,...
%                 'which',1,...
%                 'wrap',[0 0 0]);
% 
% files = {origT1;T1space_WMH};
% 
% spm_reslice(files, flags);
% 
% T1space_WMH = [studyFolder '/subjects/' ID '/mri/extractedWMH/temp/r' ID '_WMH_T1space.nii'];

% CNSP_registration_wMx (origT1, origFLAIR, T1space_WMH);
T1spaceWMH_back2_FLAIRspace = CNSP_reverse_registration_wMx (origFLAIR, origT1, T1space_WMH);

% movefile ([studyFolder '/subjects/' ID '/mri/extractedWMH/temp/r' ID '_WMH_T1space.nii'], ...
%             [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii']);
movefile (T1spaceWMH_back2_FLAIRspace, ...
            [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii']);

system (['if [ -f ' studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii.gz ];then rm -f ' studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii.gz;fi']); 

system (['. ${FSLDIR}/etc/fslconf/fsl.sh; ${FSLDIR}/bin/fslmaths ' studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii -nan ' studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace_temp']);

% otherwise fsl reports warning of duplicate, as it only look at filename
system (['rm -f ' studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii']);
system (['mv ' studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace_temp.nii.gz ' studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii.gz']);

% system (['gzip -f ' studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii']);        
        