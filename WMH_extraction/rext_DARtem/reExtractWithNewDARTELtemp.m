function varargout = reExtractWithNewDARTELtemp(varargin)
% REEXTRACTWITHNEWDARTELTEMP MATLAB code for reExtractWithNewDARTELtemp.fig
%      REEXTRACTWITHNEWDARTELTEMP, by itself, creates a new REEXTRACTWITHNEWDARTELTEMP or raises the existing
%      singleton*.
%
%      H = REEXTRACTWITHNEWDARTELTEMP returns the handle to a new REEXTRACTWITHNEWDARTELTEMP or the handle to
%      the existing singleton*.
%
%      REEXTRACTWITHNEWDARTELTEMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REEXTRACTWITHNEWDARTELTEMP.M with the given input arguments.
%
%      REEXTRACTWITHNEWDARTELTEMP('Property','Value',...) creates a new REEXTRACTWITHNEWDARTELTEMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reExtractWithNewDARTELtemp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reExtractWithNewDARTELtemp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reExtractWithNewDARTELtemp

% Last Modified by GUIDE v2.5 23-May-2017 20:12:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reExtractWithNewDARTELtemp_OpeningFcn, ...
                   'gui_OutputFcn',  @reExtractWithNewDARTELtemp_OutputFcn, ...
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


% --- Executes just before reExtractWithNewDARTELtemp is made visible.
function reExtractWithNewDARTELtemp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reExtractWithNewDARTELtemp (see VARARGIN)

% Choose default command line output for reExtractWithNewDARTELtemp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes reExtractWithNewDARTELtemp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = reExtractWithNewDARTELtemp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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


% --- Executes on selection change in classifier_popupmenu.
function classifier_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to classifier_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns classifier_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from classifier_popupmenu


% --- Executes during object creation, after setting all properties.
function classifier_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to classifier_popupmenu (see GCBO)
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


% --- Executes on button press in reExtract_btn.
function reExtract_btn_Callback(hObject, eventdata, handles)
% hObject    handle to reExtract_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Backup ---
studyFolder = getappdata (0, 'studyFolder');
if get (handles.backup_radiobutton, 'Value')
    fprintf ('Backup. Please wait ...\n');
    system (['cp -r ' studyFolder '/subjects ' studyFolder '/' get(handles.backupName_edit, 'String')]);
else
    fprintf ('No backup will be performed.\n');
end
    

switch get(handles.dartelTemplate_popupmenu,'Value')
    case 1
        DARTELtemplate = 'existing template';
        ageRange = 'lt55';
    case 2
        DARTELtemplate = 'existing template';
        ageRange = '65to75';
    case 3
        DARTELtemplate = 'existing template';
        ageRange = '70to80';
    case 4
        DARTELtemplate = 'creating template';
        ageRange = 'NA';
end

switch get(handles.classifier_popupmenu,'Value')
    case 1
        classifier = 'built-in';
    case 2
        classifier = 'customised';
end
        
setappdata(0,'DARtem',DARTELtemplate);
setappdata(0,'ageRange',ageRange);
setappdata(0,'k',get(handles.k_edit,'String'));
setappdata(0,'classifier',classifier);
setappdata(0,'PVmag',get(handles.PVmag_edit,'String'));
setappdata(0,'probThr',get(handles.probThr_edit,'String'));

close(reExtractWithNewDARTELtemp);



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
set (handles.backupName_radiobutton, 'Enable', 'on');


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
