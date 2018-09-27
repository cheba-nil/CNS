function varargout = reExtractWithNewProbThr(varargin)
% REEXTRACTWITHNEWPROBTHR MATLAB code for reExtractWithNewProbThr.fig
%      REEXTRACTWITHNEWPROBTHR, by itself, creates a new REEXTRACTWITHNEWPROBTHR or raises the existing
%      singleton*.
%
%      H = REEXTRACTWITHNEWPROBTHR returns the handle to a new REEXTRACTWITHNEWPROBTHR or the handle to
%      the existing singleton*.
%
%      REEXTRACTWITHNEWPROBTHR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REEXTRACTWITHNEWPROBTHR.M with the given input arguments.
%
%      REEXTRACTWITHNEWPROBTHR('Property','Value',...) creates a new REEXTRACTWITHNEWPROBTHR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reExtractWithNewProbThr_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reExtractWithNewProbThr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reExtractWithNewProbThr

% Last Modified by GUIDE v2.5 21-May-2017 18:55:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reExtractWithNewProbThr_OpeningFcn, ...
                   'gui_OutputFcn',  @reExtractWithNewProbThr_OutputFcn, ...
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


% --- Executes just before reExtractWithNewProbThr is made visible.
function reExtractWithNewProbThr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reExtractWithNewProbThr (see VARARGIN)

% Choose default command line output for reExtractWithNewProbThr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes reExtractWithNewProbThr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = reExtractWithNewProbThr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in noBackup_checkbox.
function noBackup_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to noBackup_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noBackup_checkbox

set (handles.backup_checkbox, 'Value', 0);
set (handles.backupName_edit, 'Enable', 'off');


% --- Executes on button press in backup_checkbox.
function backup_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to backup_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of backup_checkbox

set (handles.noBackup_checkbox, 'Value', 0);
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


% --- Executes on button press in reExt_btn.
function reExt_btn_Callback(hObject, eventdata, handles)
% hObject    handle to reExt_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata (0, 'probThr', get (handles.probThr_edit, 'String'));
setappdata (0, 'PVmag', get (handles.PVmag_edit, 'String'));
studyFolder = getappdata (0,'studyFolder');
backupName = get (handles.backupName_edit, 'String');

if get (handles.backup_checkbox, 'Value') == 1
    fprintf ('Backup. Please wait ...\n');
    system (['cp -r ' studyFolder '/subjedts ' studyFolder '/' backupName]);
elseif get (handles.noBackup_checkbox, 'Value') == 1
    fprintf ('No backup will be performed.\n');
end

if get (handles.webpage_radiobutton, 'Value')
    outputFormat = 'web';
elseif get (handles.dnld_radiobutton, 'Value')
    outputFormat = 'arch';
elseif get (handles.both_radiobutton, 'Value')
    outputFormat = 'web&arch';
else
    error ('Please specify how you would like to view the results');
end

setappdata (0, 'outputFormat', outputFormat);

close (reExtractWithNewProbThr);


% --- Executes on button press in webpage_radiobutton.
function webpage_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to webpage_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of webpage_radiobutton
set (handles.dnld_radiobutton, 'Value', 0);
set (handles.both_radiobutton, 'Value', 0);


% --- Executes on button press in dnld_radiobutton.
function dnld_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to dnld_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dnld_radiobutton
set (handles.webpath_radiobutton, 'Value', 0);
set (handles.both_ratiobutton, 'Value', 0);


% --- Executes on button press in both_radiobutton.
function both_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to both_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of both_radiobutton
set (handles.webpath_radiobutton, 'Value', 0);
set (handles.dnld_radiobutton, 'Value', 0);
