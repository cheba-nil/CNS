function varargout = NBTR_Native_GUI(varargin)
% NBTR_NATIVE_GUI MATLAB code for NBTR_Native_GUI.fig
%      NBTR_NATIVE_GUI, by itself, creates a new NBTR_NATIVE_GUI or raises the existing
%      singleton*.
%
%      H = NBTR_NATIVE_GUI returns the handle to a new NBTR_NATIVE_GUI or the handle to
%      the existing singleton*.
%
%      NBTR_NATIVE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NBTR_NATIVE_GUI.M with the given input arguments.
%
%      NBTR_NATIVE_GUI('Property','Value',...) creates a new NBTR_NATIVE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NBTR_Native_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NBTR_Native_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NBTR_Native_GUI

% Last Modified by GUIDE v2.5 24-Mar-2017 15:47:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NBTR_Native_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @NBTR_Native_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% cd(fileparts(which([mfilename '.m']))); % change dir
% currDir = fileparts(which([mfilename '.m']));
% [status,parentDir_char] = system (['echo $(dirname ' currDir ')']);
% parentDir = cellstr(parentDir_char); % char array to cell array
% 
% addpath(genpath(parentDir{1})); % addpath the parent folder with subfolders


% --- Executes just before NBTR_Native_GUI is made visible.
function NBTR_Native_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NBTR_Native_GUI (see VARARGIN)

% Choose default command line output for NBTR_Native_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NBTR_Native_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NBTR_Native_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function imgFolder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to imgFolder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imgFolder_edit as text
%        str2double(get(hObject,'String')) returns contents of imgFolder_edit as a double


% --- Executes during object creation, after setting all properties.
function imgFolder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgFolder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findImgFolder_btn.
function findImgFolder_btn_Callback(hObject, eventdata, handles)
% hObject    handle to findImgFolder_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imgFolder = uigetdir;
set (handles.imgFolder_edit,'String',imgFolder);



function spm12folder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to spm12folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spm12folder_edit as text
%        str2double(get(hObject,'String')) returns contents of spm12folder_edit as a double


% --- Executes during object creation, after setting all properties.
function spm12folder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spm12folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findSPM12folder_edit.
function findSPM12folder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to findSPM12folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spmFolder = uigetdir;
set (handles.spm12folder_edit,'String',spmFolder);


 



function thr_edit_Callback(hObject, eventdata, handles)
% hObject    handle to thr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thr_edit as text
%        str2double(get(hObject,'String')) returns contents of thr_edit as a double


% --- Executes during object creation, after setting all properties.
function thr_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function progressOutput_edit_Callback(hObject, eventdata, handles)
% hObject    handle to progressOutput_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of progressOutput_edit as text
%        str2double(get(hObject,'String')) returns contents of progressOutput_edit as a double


% --- Executes during object creation, after setting all properties.
function progressOutput_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to progressOutput_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in runNBTR_btn.
function runNBTR_btn_Callback(hObject, eventdata, handles)
% hObject    handle to runNBTR_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imgFolder = get (handles.imgFolder_edit,'String');
spm12path = get (handles.spm12folder_edit,'String');

progressOutput = handles.progressOutput_edit;
threshold = get (handles.thr_edit,'String');
nonbraintissueremoval_native (imgFolder, spm12path, threshold, progressOutput);




















%% --------------------------------------------------- %%

function nonbraintissueremoval_native (imgFolder, spm12path, threshold, progressOutput)

    tic;
    
%     cd(fileparts(which([mfilename '.m'])));
    
    progressOutputCellArray {:} = ''; % reset output
    % updating progress output
    progressOutputCellArray {1} = '*******************************************';
    progressOutputCellArray {end+1} = '        non-brain tissue removal (Native space)        ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '           Neuroimaging Lab            ';
    progressOutputCellArray {end+1} = '   Centre for Healthy Brain Ageing   ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '';   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    
    addpath (spm12path);
    CNSP_path = getappdata (0,'CNSP_path');
%     currDir = fileparts(which([mfilename '.m']));
%     [status,parentDir_char] = system (['echo $(dirname ' currDir ')']);
%     parentDir = cellstr(parentDir_char); % char array to cell array
%     parentFolder = [parentDir{1}];
%     addpath (genpath(parentFolder));
%  
    %%%%%%%%%%%%%%%%%%%%%%%%
    %% Organising folders %%
    %%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Organising folders ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    % gunzip niftis
    cmd_gunzip = ['gunzip ' imgFolder '/*'];
    system (cmd_gunzip);  
    
    % create folders
    if exist ([imgFolder '/segmentation'],'dir') == 7
        rmdir ([imgFolder '/segmentation'],'s');
        mkdir (imgFolder, 'segmentation');
    else
        mkdir (imgFolder, 'segmentation');
    end
    
    mkdir ([imgFolder '/segmentation'], 'GM');
    mkdir ([imgFolder '/segmentation'], 'WM');
    mkdir ([imgFolder '/segmentation'], 'CSF');

    if exist ([imgFolder '/spmoutput'],'dir') == 7
        rmdir ([imgFolder '/spmoutput'],'s');
        mkdir (imgFolder,'spmoutput');
    else
        mkdir (imgFolder,'spmoutput');
    end
    
    if exist ([imgFolder '/nonbrainRemoved'],'dir') == 7
        rmdir ([imgFolder '/nonbrainRemoved'],'s');
        mkdir ([imgFolder '/nonbrainRemoved']);
    else
        mkdir ([imgFolder '/nonbrainRemoved']);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Run SPM segmentation %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%

    progressOutputCellArray {end+1} = 'Step 1: Running SPM segmentation ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    Seg_1_Segmentation (imgFolder, spm12path);
    
    
    progressOutputCellArray {end+1} = 'Step 2: Generate mask and apply to image ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    imgs = dir (strcat (imgFolder,'/*.nii'));
    [Nsubj,n] = size (imgs);
    
    system (['chmod +x ' CNSP_path '/NBTR_Native/NBTR_Native_combNthrNbin.sh']);
    
    parfor i = 1:Nsubj
        imgNames = strsplit (imgs(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = imgNames{1};   % first section is ID
        imgFilenames = strsplit (imgs(i).name, '.');
        imgFilename = imgFilenames{1};
        
        system ([CNSP_path '/NBTR_Native/NBTR_Native_combNthrNbin.sh ' imgFolder ' ' ID ' ' threshold ' ' imgs(i).name ' ' imgFilename]);
    end

    
    
    total_time = toc/60; % in min
    progressOutputCellArray {end+1} = ['Finished in ' num2str(total_time) ' minutes.'];   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    progressOutputCellArray {end+1} = '';
    progressOutputCellArray {end+1} = ['Results in: ' imgFolder '/nonbrainRemoved'];   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    
    
    
