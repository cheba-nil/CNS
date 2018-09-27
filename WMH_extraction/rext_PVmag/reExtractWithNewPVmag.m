function varargout = reExtractWithNewPVmag(varargin)
% REEXTRACTWITHNEWPVMAG MATLAB code for reExtractWithNewPVmag.fig
%      REEXTRACTWITHNEWPVMAG, by itself, creates a new REEXTRACTWITHNEWPVMAG or raises the existing
%      singleton*.
%
%      H = REEXTRACTWITHNEWPVMAG returns the handle to a new REEXTRACTWITHNEWPVMAG or the handle to
%      the existing singleton*.
%
%      REEXTRACTWITHNEWPVMAG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REEXTRACTWITHNEWPVMAG.M with the given input arguments.
%
%      REEXTRACTWITHNEWPVMAG('Property','Value',...) creates a new REEXTRACTWITHNEWPVMAG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reExtractWithNewPVmag_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reExtractWithNewPVmag_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reExtractWithNewPVmag

% Last Modified by GUIDE v2.5 21-May-2017 17:31:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reExtractWithNewPVmag_OpeningFcn, ...
                   'gui_OutputFcn',  @reExtractWithNewPVmag_OutputFcn, ...
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


% --- Executes just before reExtractWithNewPVmag is made visible.
function reExtractWithNewPVmag_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reExtractWithNewPVmag (see VARARGIN)

% Choose default command line output for reExtractWithNewPVmag
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes reExtractWithNewPVmag wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = reExtractWithNewPVmag_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function newPVmag_edit_Callback(hObject, eventdata, handles)
% hObject    handle to newPVmag_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newPVmag_edit as text
%        str2double(get(hObject,'String')) returns contents of newPVmag_edit as a double


% --- Executes during object creation, after setting all properties.
function newPVmag_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newPVmag_edit (see GCBO)
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



% --- Executes on button press in ReextractWithNewPVmag_btn.
function ReextractWithNewPVmag_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ReextractWithNewPVmag_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp ('on', get (handles.backupName_edit, 'Enable'))
    backupName = get (handles.backupName_edit, 'String');
end

studyFolder = getappdata (0, 'studyFolder');

if get (handles.backup_radiobutton, 'Value') == 1
    fprintf ('Backup, please wait ...\n');
    system (['cp -r ' studyFolder '/subjects ' studyFolder '/' backupName]);
else
    fprintf ('No backup will be performed.\n');
end

newPVmag = get(handles.newPVmag_edit,'String');

setappdata(0,'PVmag',newPVmag);

close (reExtractWithNewPVmag);

