function varargout = TOPMAL_GUI(varargin)
% TOPMAL_GUI MATLAB code for TOPMAL_GUI.fig
%      TOPMAL_GUI, by itself, creates a new TOPMAL_GUI or raises the existing
%      singleton*.
%
%      H = TOPMAL_GUI returns the handle to a new TOPMAL_GUI or the handle to
%      the existing singleton*.
%
%      TOPMAL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOPMAL_GUI.M with the given input arguments.
%
%      TOPMAL_GUI('Property','Value',...) creates a new TOPMAL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TOPMAL_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TOPMAL_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TOPMAL_GUI

% Last Modified by GUIDE v2.5 05-Apr-2018 10:24:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TOPMAL_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TOPMAL_GUI_OutputFcn, ...
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


% --- Executes just before TOPMAL_GUI is made visible.
function TOPMAL_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TOPMAL_GUI (see VARARGIN)

% Choose default command line output for TOPMAL_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TOPMAL_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = TOPMAL_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in UDmode_radiobutton.
function UDmode_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to UDmode_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UDmode_radiobutton
set (handles.nonUDmode_radiobutton, 'Value', 0);
set (handles.studyFolder_edit, 'Enable', 'on');
set (handles.DARlesFolder_edit, 'Enable', 'off');
set (handles.excldIDs_edit, 'Enable', 'on');

% --- Executes on button press in nonUDmode_radiobutton.
function nonUDmode_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to nonUDmode_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nonUDmode_radiobutton
set (handles.UDmode_radiobutton, 'Value', 0);
set (handles.studyFolder_edit, 'Enable', 'on');
set (handles.DARlesFolder_edit, 'Enable', 'on');
set (handles.excldIDs_edit, 'Enable', 'off');
% set (handles.DARTELtemplate_popupmenu, 'Value', 1);
% set (handles.DARTELtemplate_popupmenu, 'Enable', 'off');


function studyFolder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to studyFolder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of studyFolder_edit as text
%        str2double(get(hObject,'String')) returns contents of studyFolder_edit as a double


% --- Executes during object creation, after setting all properties.
function studyFolder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to studyFolder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findStudyFolder_pushbutton.
function findStudyFolder_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to findStudyFolder_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

studyFolder = uigetdir;
set (handles.studyFolder_edit, 'String', studyFolder);

% --- Executes on selection change in DARTELtemplate_popupmenu.
function DARTELtemplate_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to DARTELtemplate_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DARTELtemplate_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DARTELtemplate_popupmenu


% --- Executes during object creation, after setting all properties.
function DARTELtemplate_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DARTELtemplate_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spm12path_edit_Callback(hObject, eventdata, handles)
% hObject    handle to spm12path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spm12path_edit as text
%        str2double(get(hObject,'String')) returns contents of spm12path_edit as a double


% --- Executes during object creation, after setting all properties.
function spm12path_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spm12path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findSPM12path_pushbutton.
function findSPM12path_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to findSPM12path_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

spm12path = uigetdir;
set (handles.spm12path_edit, 'String', spm12path);



% --- Executes on selection change in atlas_popupmenu.
function atlas_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to atlas_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns atlas_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from atlas_popupmenu


% --- Executes during object creation, after setting all properties.
function atlas_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to atlas_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runTOPMAL_pushbutton.
function runTOPMAL_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to runTOPMAL_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TOPMAL_directory = fileparts (mfilename ('fullpath'));
addpath (TOPMAL_directory);

fprintf ('\n----------========== TOPMAL ==========----------\n\n')

studyFolder = get (handles.studyFolder_edit, 'String');
fprintf ('Study folder = %s\n', studyFolder);

spm12path = get (handles.spm12path_edit, 'String');
fprintf ('SPM12 path = %s\n', spm12path);

switch get (handles.DARTELtemplate_popupmenu, 'Value')
    case 1
        DARtem = 'creating template';
        ageRange = 'NA';
        fprintf ('''creating DARTEL template'' selected.\n');
    case 2
        DARtem = 'existing template';
        ageRange = 'lt55';
        fprintf ('''existing DARTEL template for less than 55 yo'' selected');
    case 3
        DARtem = 'existing template';
        ageRange = '65to75';
        fprintf ('''existing DARTEL template for 65 to 75 yo'' selected.\n');
    case 4
        DARtem = 'existing template';
        ageRange = '70to80';
        fprintf ('''existing DARTEL template for 70 to 80 yo'' selected.\n');
end


switch get (handles.atlas_popupmenu, 'Value')
    case 1
        atlas = 'JHU-ICBM_WM_tract_prob_1mm';
        fprintf ('''JHU-ICBM_WM_tract_prob_1mm'' atlas selected.\n');
    case 2
        atlas = 'HO_subcortical_1mm';
        fprintf ('''HO_subcortical_1mm'' atlas selected.\n');
end


% Run TOPMAL
if get (handles.UDmode_radiobutton, 'Value') && ...
        ~get (handles.nonUDmode_radiobutton, 'Value')
    
    excldList = get (handles.excldIDs_edit, 'String');
    if strcmp (excldList, '')
        fprintf ('excluding IDs: None.\n');
    else
        fprintf ('excluding IDs: %s\n', excldList);
    end
    fprintf ('UD mode selected.\n\n\n');
    TOPMAL_UDver (studyFolder, ...
                  DARtem, ...
                  ageRange, ...
                  spm12path, ...
                  atlas, ...
                  excldList);
              
elseif ~get (handles.UDmode_radiobutton, 'Value') && ...
        get (handles.nonUDmode_radiobutton, 'Value')

    DARles_folder = get (handles.DARlesFolder_edit, 'String');
    fprintf ('DARTEL lesion mask folder: %s\n', DARles_folder);
    fprintf ('Generic mode selected.\n\n\n');
    TOPMAL_generic (DARles_folder, ...
                    studyFolder, ...
                    DARtem, ...
                    ageRange, ...
                    spm12path, ...
                    atlas);
end



function DARlesFolder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to DARlesFolder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DARlesFolder_edit as text
%        str2double(get(hObject,'String')) returns contents of DARlesFolder_edit as a double


% --- Executes during object creation, after setting all properties.
function DARlesFolder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DARlesFolder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DARlesFolder_pushbutton.
function DARlesFolder_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DARlesFolder_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DARles_folder = uigetdir;
set (handles.DARlesFolder_edit, 'String', DARles_folder);


function excldIDs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to excldIDs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excldIDs_edit as text
%        str2double(get(hObject,'String')) returns contents of excldIDs_edit as a double


% --- Executes during object creation, after setting all properties.
function excldIDs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excldIDs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function TOPMAL_manual_menu_Callback(hObject, eventdata, handles)
% hObject    handle to TOPMAL_manual_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openTOPMALmanual_menu_Callback(hObject, eventdata, handles)
% hObject    handle to openTOPMALmanual_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CNSP_path = fileparts (fileparts (mfilename ('fullpath')));

web ([CNSP_path '/Manual/TOPMAL_main.html'], '-new');
