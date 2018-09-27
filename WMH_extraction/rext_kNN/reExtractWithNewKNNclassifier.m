function varargout = reExtractWithNewKNNclassifier(varargin)
% REEXTRACTWITHNEWKNNCLASSIFIER MATLAB code for reExtractWithNewKNNclassifier.fig
%      REEXTRACTWITHNEWKNNCLASSIFIER, by itself, creates a new REEXTRACTWITHNEWKNNCLASSIFIER or raises the existing
%      singleton*.
%
%      H = REEXTRACTWITHNEWKNNCLASSIFIER returns the handle to a new REEXTRACTWITHNEWKNNCLASSIFIER or the handle to
%      the existing singleton*.
%
%      REEXTRACTWITHNEWKNNCLASSIFIER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REEXTRACTWITHNEWKNNCLASSIFIER.M with the given input arguments.
%
%      REEXTRACTWITHNEWKNNCLASSIFIER('Property','Value',...) creates a new REEXTRACTWITHNEWKNNCLASSIFIER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reExtractWithNewKNNclassifier_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reExtractWithNewKNNclassifier_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reExtractWithNewKNNclassifier

% Last Modified by GUIDE v2.5 22-May-2017 08:40:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reExtractWithNewKNNclassifier_OpeningFcn, ...
                   'gui_OutputFcn',  @reExtractWithNewKNNclassifier_OutputFcn, ...
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


% --- Executes just before reExtractWithNewKNNclassifier is made visible.
function reExtractWithNewKNNclassifier_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reExtractWithNewKNNclassifier (see VARARGIN)

% Choose default command line output for reExtractWithNewKNNclassifier
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes reExtractWithNewKNNclassifier wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = reExtractWithNewKNNclassifier_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function k_edit_Callback(hObject, eventdata, handles)
% hObject    handle to k_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k_edit as text
%        str2double(get(hObject,'String')) returns contents of k_edit as a double


% --- Executes during object creation, after setting all properties.
function k_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in trainingSet_popupmenu.
function trainingSet_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to trainingSet_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns trainingSet_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trainingSet_popupmenu


% --- Executes during object creation, after setting all properties.
function trainingSet_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainingSet_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PVmag_edit_Callback(hObject, eventdata, handles)
% hObject    handle to PVmag_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PVmag_edit as text
%        str2double(get(hObject,'String')) returns contents of PVmag_edit as a double


% --- Executes during object creation, after setting all properties.
function PVmag_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PVmag_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% PVmag = getappdata(0,'PVmag');
% set(hObject,'String',PVmag);

% --- Executes on button press in Re_extract_btn.
function Re_extract_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Re_extract_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = getappdata (0, 'studyFolder');
backupName = get (handles.backupName_edit, 'String');
if get (handles.backup_radiobutton, 'Value') && ...
        ~strcmp (backupName, '')
    fprintf ('Backup. Please wait ...\n');
    system (['cp -r ' studyFolder '/subjects ' studyFolder '/' backupName]);
elseif get (handles.backup_radiobutton, 'Value') && ...
        strcmp (backupName, '')
    error ('Please specify the filename you want to backup the current "subjects" directory to\n');
elseif get(handles.noBackup_radiobutton, 'Value')
    fprintf ('No backup will be performed.\n');
else
    error ('Please specify whether you want to backup the current "subjects" directory');
end

PVmag = get(handles.PVmag_edit,'String');
k = get(handles.k_edit,'String');
switch get(handles.trainingSet_popupmenu,'Value')
    case 1
        classifier = 'built-in';
    case 2
        classifier = 'customised';
end

switch get (handles.darTem_popupmenu, 'Value')
    case 1
        ageRange = 'lt55';
        DARTELtemplate = 'existing template';
    case 2
        ageRange = '65to75';
        DARTELtemplate = 'existing template';
    case 3
        ageRange = '70to80';
        DARTELtemplate = 'existing template';
    case 4
        ageRange = 'NA';
        DARTELtemplate = 'creating template';
end

setappdata(0,'PVmag',PVmag);
setappdata(0,'k',k);
setappdata(0,'classifier',classifier);
setappdata(0,'DARtem',DARTELtemplate);
setappdata(0,'ageRange',ageRange);
setappdata(0,'probThr',get(handles.probThr_edit,'String'));

close(reExtractWithNewKNNclassifier);



function probThr_edit_Callback(hObject, eventdata, handles)
% hObject    handle to probThr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of probThr_edit as text
%        str2double(get(hObject,'String')) returns contents of probThr_edit as a double


% --- Executes during object creation, after setting all properties.
function probThr_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to probThr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in darTem_popupmenu.
function darTem_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to darTem_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns darTem_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from darTem_popupmenu


% --- Executes during object creation, after setting all properties.
function darTem_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to darTem_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in noBackup_radiobutton.
function noBackup_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to noBackup_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noBackup_radiobutton
set (handles.backup_radiobutton, 'Value', 0);
set (handles.backupName_edit, 'Enable', 'off');


% --- Executes on button press in backup_radiobutton.
function backup_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to backup_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of backup_radiobutton
set (handles.noBackup_radiobutton, 'Value', 0);
set (handles.backupName_edit, 'Enable', 'on');



function backupName_edit_Callback(hObject, eventdata, handles)
% hObject    handle to backupName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of backupName_edit as text
%        str2double(get(hObject,'String')) returns contents of backupName_edit as a double


% --- Executes during object creation, after setting all properties.
function backupName_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backupName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
