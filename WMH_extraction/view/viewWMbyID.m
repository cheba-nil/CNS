function varargout = viewWMbyID(varargin)
% VIEWWMBYID MATLAB code for viewWMbyID.fig
%      VIEWWMBYID, by itself, creates a new VIEWWMBYID or raises the existing
%      singleton*.
%
%      H = VIEWWMBYID returns the handle to a new VIEWWMBYID or the handle to
%      the existing singleton*.
%
%      VIEWWMBYID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWWMBYID.M with the given input arguments.
%
%      VIEWWMBYID('Property','Value',...) creates a new VIEWWMBYID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewWMbyID_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewWMbyID_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewWMbyID

% Last Modified by GUIDE v2.5 05-Apr-2017 16:39:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewWMbyID_OpeningFcn, ...
                   'gui_OutputFcn',  @viewWMbyID_OutputFcn, ...
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


% --- Executes just before viewWMbyID is made visible.
function viewWMbyID_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewWMbyID (see VARARGIN)

% Choose default command line output for viewWMbyID
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes viewWMbyID wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = viewWMbyID_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function IDtoView_edit_Callback(hObject, eventdata, handles)
% hObject    handle to IDtoView_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IDtoView_edit as text
%        str2double(get(hObject,'String')) returns contents of IDtoView_edit as a double


% --- Executes during object creation, after setting all properties.
function IDtoView_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IDtoView_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in viewWM_btn.
function viewWM_btn_Callback(hObject, eventdata, handles)
% hObject    handle to viewWM_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = getappdata(0,'studyFolder');
CNSP_path = getappdata(0,'CNSP_path');
ID= get(handles.IDtoView_edit,'String');

WM = dir([studyFolder '/subjects/' ID '/mri/preprocessing/c2' ID '_*.nii*']);

if ~isempty(WM)
    system (['chmod +x ' CNSP_path '/WMH_extraction/viewWM_ID.sh']);
    system ([CNSP_path '/WMH_extraction/viewWM_ID.sh ' studyFolder ' ' ID]);
else
    errorNOwm;
end

close(viewWMbyID);
