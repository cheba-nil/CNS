function varargout = DTIpreprocessing_GUI(varargin)
% DTIPREPROCESSING_GUI MATLAB code for DTIpreprocessing_GUI.fig
%      DTIPREPROCESSING_GUI, by itself, creates a new DTIPREPROCESSING_GUI or raises the existing
%      singleton*.
%
%      H = DTIPREPROCESSING_GUI returns the handle to a new DTIPREPROCESSING_GUI or the handle to
%      the existing singleton*.
%
%      DTIPREPROCESSING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DTIPREPROCESSING_GUI.M with the given input arguments.
%
%      DTIPREPROCESSING_GUI('Property','Value',...) creates a new DTIPREPROCESSING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DTIpreprocessing_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DTIpreprocessing_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DTIpreprocessing_GUI

% Last Modified by GUIDE v2.5 05-Apr-2017 13:20:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DTIpreprocessing_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DTIpreprocessing_GUI_OutputFcn, ...
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


% --- Executes just before DTIpreprocessing_GUI is made visible.
function DTIpreprocessing_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DTIpreprocessing_GUI (see VARARGIN)

% Choose default command line output for DTIpreprocessing_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DTIpreprocessing_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DTIpreprocessing_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startProcessing_btn.
function startProcessing_btn_Callback(hObject, eventdata, handles)
% hObject    handle to startProcessing_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic;
studyFolder = get(handles.studyFolder_edit,'String');
fthr = get(handles.fthr_edit,'String');
gthr = get (handles.gthr_edit,'String');

outputTxt{1} = ['Study Folder = ' studyFolder];
outputTxt{end+1} = ['Fractinal Intensity Threshold = ' fthr];
outputTxt{end+1} = ['Vertical Gradient in Fractional Intensity Threshold = ' gthr];
outputTxt{end+1} = 'Start processing ...';
set(handles.progressOutput_edit,'String',outputTxt);
drawnow;

dti_preprocessing(studyFolder,fthr,gthr);

time = toc/60; % in min
outputTxt{end+1} = ['Finished in ' num2str(time) ' minutes. Please see ' studyFolder '/output for results.'];
set(handles.progressOutput_edit,'String',outputTxt);
drawnow;

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


% --- Executes on button press in findStudyFolder_btn.
function findStudyFolder_btn_Callback(hObject, eventdata, handles)
% hObject    handle to findStudyFolder_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = uigetdir;
set(handles.studyFolder_edit,'String',studyFolder);



function fthr_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fthr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fthr_edit as text
%        str2double(get(hObject,'String')) returns contents of fthr_edit as a double


% --- Executes during object creation, after setting all properties.
function fthr_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fthr_edit (see GCBO)
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
