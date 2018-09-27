function varargout = segmentation_GUI(varargin)
% SEGMENTATION_GUI MATLAB code for segmentation_GUI.fig
%      SEGMENTATION_GUI, by itself, creates a new SEGMENTATION_GUI or raises the existing
%      singleton*.
%
%      H = SEGMENTATION_GUI returns the handle to a new SEGMENTATION_GUI or the handle to
%      the existing singleton*.
%
%      SEGMENTATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENTATION_GUI.M with the given input arguments.
%
%      SEGMENTATION_GUI('Property','Value',...) creates a new SEGMENTATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segmentation_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segmentation_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segmentation_GUI

% Last Modified by GUIDE v2.5 16-Apr-2017 09:21:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segmentation_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @segmentation_GUI_OutputFcn, ...
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


% --- Executes just before segmentation_GUI is made visible.
function segmentation_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmentation_GUI (see VARARGIN)

% Choose default command line output for segmentation_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segmentation_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = segmentation_GUI_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in startSeg_noQC_btn.
function startSeg_noQC_btn_Callback(hObject, eventdata, handles)
% hObject    handle to startSeg_noQC_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imgFolder = get (handles.imgFolder_edit,'String');
spm12path = get (handles.spm12folder_edit,'String');

if get(handles.YesToDARTEL_radiobutton,'Value') && get(handles.NoToDARTEL_radiobutton,'Value')
    outputText = get(handles.progressOutput_edit,'String');
    outputText{end+1} = 'ERROR: Cannot select both Yes and No.';
    set (handles.progressOutput_edit,'String', outputText);
    error('Cannot select both Yes and No.');
elseif get(handles.YesToDARTEL_radiobutton,'Value') || get(handles.NoToDARTEL_radiobutton,'Value')
    dartelYN = get(handles.YesToDARTEL_radiobutton,'Value');
else
    outputText = get(handles.progressOutput_edit,'String');
    outputText{end+1} = 'ERROR: Please select whether you want to map segmentations to DARTEL.';
    set (handles.progressOutput_edit,'String', outputText);
    error('Please select whether you want to map segmentations to DARTEL.');
end

switch get(handles.dartelTemplate_popupmenu,'Value')
    case 1
        dartelTemplate = 'existing';
        ageRange = '65to75';
    case 2
        dartelTemplate = 'existing';
        ageRange = '70to80';
    case 3
        dartelTemplate = 'creating';
        ageRange = 'NA';
end

segExcldList = ''; % no QC stop

progressOutput = handles.progressOutput_edit;

segmentation_noQC (imgFolder, spm12path, dartelYN, dartelTemplate, ageRange, segExcldList, progressOutput);


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



% --- Executes on selection change in dartelTemplate_popupmenu.
function dartelTemplate_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to dartelTemplate_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dartelTemplate_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dartelTemplate_popupmenu


% --- Executes during object creation, after setting all properties.
function dartelTemplate_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dartelTemplate_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in YesToDARTEL_radiobutton.
function YesToDARTEL_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to YesToDARTEL_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of YesToDARTEL_radiobutton
set(handles.NoToDARTEL_radiobutton,'Value',0);


% --- Executes on button press in NoToDARTEL_radiobutton.
function NoToDARTEL_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to NoToDARTEL_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NoToDARTEL_radiobutton

set(handles.YesToDARTEL_radiobutton,'Value',0);



function segQCfailureIDs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to segQCfailureIDs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segQCfailureIDs_edit as text
%        str2double(get(hObject,'String')) returns contents of segQCfailureIDs_edit as a double


% --- Executes during object creation, after setting all properties.
function segQCfailureIDs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segQCfailureIDs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in finishSegQCfailInput_btn.
function finishSegQCfailInput_btn_Callback(hObject, eventdata, handles)
% hObject    handle to finishSegQCfailInput_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imgFolder = get (handles.imgFolder_edit,'String');
spm12path = get (handles.spm12folder_edit,'String');

if get(handles.YesToDARTEL_radiobutton,'Value') && get(handles.NoToDARTEL_radiobutton,'Value')
    outputText = get(handles.progressOutput_edit,'String');
    outputText{end+1} = 'ERROR: Cannot select both Yes and No.';
    set (handles.progressOutput_edit,'String', outputText);
    error('Cannot select both Yes and No.');
elseif get(handles.YesToDARTEL_radiobutton,'Value') || get(handles.NoToDARTEL_radiobutton,'Value')
    dartelYN = get(handles.YesToDARTEL_radiobutton,'Value');
else
    outputText = get(handles.progressOutput_edit,'String');
    outputText{end+1} = 'ERROR: Please select whether you want to map segmentations to DARTEL.';
    set (handles.progressOutput_edit,'String', outputText);
    error('Please select whether you want to map segmentations to DARTEL.');
end

switch get(handles.dartelTemplate_popupmenu,'Value')
    case 1
        dartelTemplate = 'existing';
        ageRange = '65to75';
    case 2
        dartelTemplate = 'existing';
        ageRange = '70to80';
    case 3
        dartelTemplate = 'creating';
        ageRange = 'NA';
end

segExcldList = get (handles.segQCfailureIDs_edit,'String');

progressOutput = handles.progressOutput_edit;

segmentation_wQC_2 (imgFolder, spm12path, dartelYN, dartelTemplate, ageRange, segExcldList, progressOutput);


% --- Executes on button press in seg_wQC_btn.
function seg_wQC_btn_Callback(hObject, eventdata, handles)
% hObject    handle to seg_wQC_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if get(handles.YesToDARTEL_radiobutton,'Value') && get(handles.NoToDARTEL_radiobutton,'Value')
    outputText = get(handles.progressOutput_edit,'String');
    outputText{end+1} = 'ERROR: Cannot select both Yes and No.';
    set (handles.progressOutput_edit,'String', outputText);
    error('Cannot select both Yes and No.');
elseif get(handles.YesToDARTEL_radiobutton,'Value') || get(handles.NoToDARTEL_radiobutton,'Value')
else
    outputText = get(handles.progressOutput_edit,'String');
    outputText{end+1} = 'ERROR: Please select whether you want to map segmentations to DARTEL.';
    set (handles.progressOutput_edit,'String', outputText);
    error('Please select whether you want to map segmentations to DARTEL.');
end

imgFolder = get (handles.imgFolder_edit,'String');
spm12path = get (handles.spm12folder_edit,'String');
progressOutput = handles.progressOutput_edit;

segmentation_wQC_1 (imgFolder, spm12path, progressOutput);















%% --------------------------------------------------- %%

function segmentation_noQC (imgFolder, spm12path, dartelYN, dartelTemplate, ageRange, segExcldList, progressOutput)

    tic;
    
%     cd(fileparts(which([mfilename '.m'])));
    
    progressOutputCellArray {:} = ''; % reset output
    % updating progress output
    progressOutputCellArray {1} = '*******************************************';
    progressOutputCellArray {end+1} = '        GM/WM/CSF segmentation        ';
    progressOutputCellArray {end+1} = '             No QC stops               ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '           Neuroimaging Lab            ';
    progressOutputCellArray {end+1} = '   Centre for Healthy Brain Ageing   ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '';   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    
    addpath (spm12path);
    CNSP_path = getappdata(0,'CNSP_path');
%     CNSP_path = getappdata (0,'CNSP_path');
%     currDir = fileparts(which([mfilename '.m']));
%     [status,parentDir_char] = system (['echo $(dirname ' currDir ')']);
%     parentDir = cellstr(parentDir_char); % char array to cell array
%     parentFolder = [parentDir{1}];
%     addpath (genpath(parentFolder));
 
    %%%%%%%%%%%%%%%%%%%%%%%%
    %% Organising folders %%
    %%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Organising folders ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    % gunzip niftis
    cmd_gunzip = ['gunzip ' imgFolder '/*'];
    system (cmd_gunzip);

%     % get the IDs
%     imgs = dir (strcat (imgFolder,'/*.nii'));
%     [Nsubj,n] = size (imgs);
    
    
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Run SPM segmentation %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%

    progressOutputCellArray {end+1} = 'Step 1: Running SPM segmentation ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    Seg_1_Segmentation (imgFolder, spm12path);
    
    
    switch dartelYN
        case 1
            progressOutputCellArray {end+1} = 'Step 2: Running DARTEL ...';
            set (progressOutput, 'String', progressOutputCellArray);
            drawnow;
            Seg_2_DARTEL(imgFolder, CNSP_path, dartelTemplate, ageRange, segExcldList);
            
            progressOutputCellArray {end+1} = 'Step 3: Bring segmentation to DARTEL ...';
            set (progressOutput, 'String', progressOutputCellArray);
            drawnow;
            Seg_3_bringToDARTEL (imgFolder, dartelTemplate, segExcldList);
        case 0
    end
    
    
    total_time = toc/60; % in min
    progressOutputCellArray {end+1} = ['Finished in ' num2str(total_time) ' minutes.'];   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    progressOutputCellArray {end+1} = '';
    progressOutputCellArray {end+1} = ['Results in: ' imgFolder '/segmentation'];   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    
    
    
    
    
    
    
    
    
    %% ------------------------
    function segmentation_wQC_1 (imgFolder, spm12path, progressOutput)

    tic;
    
%     cd(fileparts(which([mfilename '.m'])));
    
    progressOutputCellArray {:} = ''; % reset output
    % updating progress output
    progressOutputCellArray {1} = '*******************************************';
    progressOutputCellArray {end+1} = '        GM/WM/CSF segmentation        ';
    progressOutputCellArray {end+1} = '             with QC stops               ';
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
 
    %%%%%%%%%%%%%%%%%%%%%%%%
    %% Organising folders %%
    %%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Organising folders ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    % gunzip niftis
    cmd_gunzip = ['gunzip ' imgFolder '/*'];
    system (cmd_gunzip);

%     % get the IDs
%     imgs = dir (strcat (imgFolder,'/*.nii'));
%     [Nsubj,n] = size (imgs);
    
    
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Run SPM segmentation %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%

    progressOutputCellArray {end+1} = 'Step 1: Running SPM segmentation ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    Seg_1_Segmentation (imgFolder, spm12path);
    
    progressOutputCellArray {end+1} = 'Generating segmentation QC images ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    Seg_segQC (imgFolder, CNSP_path); % segmentation QC
    
    progressOutputCellArray {end+1} = 'Please input the IDs failed segmentation QC.';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    
    
    
    
function segmentation_wQC_2 (imgFolder, spm12path, dartelYN, dartelTemplate, ageRange, segExcldList, progressOutput)
    
    addpath (spm12path);
    CNSP_path = getappdata (0,'CNSP_path');
%     currDir = fileparts(which([mfilename '.m']));
%     [status,parentDir_char] = system (['echo $(dirname ' currDir ')']);
%     parentDir = cellstr(parentDir_char); % char array to cell array
%     parentFolder = [parentDir{1}];
%     addpath (genpath(parentFolder));
    progressOutputCellArray = get (progressOutput,'String');
    
    switch dartelYN
        case 1
            progressOutputCellArray {end+1} = 'Step 2: Running DARTEL ...';
            set (progressOutput, 'String', progressOutputCellArray);
            drawnow;
            Seg_2_DARTEL(imgFolder, CNSP_path, dartelTemplate, ageRange, segExcldList);
            
            progressOutputCellArray {end+1} = 'Step 3: Bring segmentation to DARTEL ...';
            set (progressOutput, 'String', progressOutputCellArray);
            drawnow;
            Seg_3_bringToDARTEL (imgFolder, dartelTemplate, segExcldList);
        case 0
    end
    
    
    total_time = toc/60; % in min
    progressOutputCellArray {end+1} = ['Finished in ' num2str(total_time) ' minutes.'];   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    progressOutputCellArray {end+1} = '';
    progressOutputCellArray {end+1} = ['Results in: ' imgFolder '/segmentation'];   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    
