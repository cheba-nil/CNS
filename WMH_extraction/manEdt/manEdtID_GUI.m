function varargout = manEdtID_GUI(varargin)
% MANEDTID_GUI MATLAB code for manEdtID_GUI.fig
%      MANEDTID_GUI, by itself, creates a new MANEDTID_GUI or raises the existing
%      singleton*.
%
%      H = MANEDTID_GUI returns the handle to a new MANEDTID_GUI or the handle to
%      the existing singleton*.
%
%      MANEDTID_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANEDTID_GUI.M with the given input arguments.
%
%      MANEDTID_GUI('Property','Value',...) creates a new MANEDTID_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manEdtID_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manEdtID_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manEdtID_GUI

% Last Modified by GUIDE v2.5 05-Jun-2017 10:28:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manEdtID_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @manEdtID_GUI_OutputFcn, ...
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


% --- Executes just before manEdtID_GUI is made visible.
function manEdtID_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manEdtID_GUI (see VARARGIN)

% Choose default command line output for manEdtID_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manEdtID_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = manEdtID_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function manEdtID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to manEdtID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of manEdtID_edit as text
%        str2double(get(hObject,'String')) returns contents of manEdtID_edit as a double


% --- Executes during object creation, after setting all properties.
function manEdtID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manEdtID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in manEdt_pushbutton.
function manEdt_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to manEdt_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

studyFolder = getappdata (0, 'studyFolder');
ID = get (handles.manEdtID_edit, 'String');

manEdtDir = fileparts(which([mfilename '.m']));

system ([manEdtDir '/displayEditingImg.sh ' studyFolder ' ' ID ' old']);


% --- Executes on button press in reExt_pushbutton.
function reExt_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to reExt_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PVmag = getappdata (0, 'PVmag');
pipelinePath = fileparts(fileparts(which([mfilename '.m'])));
editID = get (handles.manEdtID_edit, 'String');
studyFolder = getappdata (0, 'studyFolder');

% fprintf ('UBO Detector: re-segmenting edited image (ID = %s) ...\n', editID);
system ([pipelinePath '/cmd/manEdt/WMHext_reSegAftEdt.sh ' editID ' ' studyFolder '/subjects ' PVmag]);

fprintf ('UBO Detector: summarising study-wise WMH measures ...\n');

system ([pipelinePath '/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);

T1list = dir ([studyFolder '/originalImg/T1/*.nii']);
[Nsubj,~] = size (T1list);

editID_parts = strsplit (editID, '_');
[~,n] = size(editID_parts);


for i = 1:Nsubj
    T1name_parts = strsplit (T1list(i).name, '_');
    
    if n >= 2
      subjID = T1name_parts{1};
      tpID = T1name_parts{2};
      ID = [subjID '_' tpID];
    else
      ID = T1name_parts{1};
    end
    
    if exist ([studyFolder '/subjects/' ID], 'dir') == 7
        system ([pipelinePath '/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ID ' ' studyFolder '/subjects']);
    end
end

fprintf ('UBO Detector: finished.\n');
close (manEdtID_GUI);
