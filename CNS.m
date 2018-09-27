function varargout = CNS(varargin)
%CNS MATLAB code file for CNS.fig
%      CNS, by itself, creates a new CNS or raises the existing
%      singleton*.
%
%      H = CNS returns the handle to a new CNS or the handle to
%      the existing singleton*.
%
%      CNS('Property','Value',...) creates a new CNS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to CNS_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CNS('CALLBACK') and CNS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CNS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CNS

% Last Modified by GUIDE v2.5 05-Apr-2018 10:15:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CNS_OpeningFcn, ...
                   'gui_OutputFcn',  @CNS_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before CNS is made visible.
function CNS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for CNS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%% --- CNS initialisation steps
clc;
fprintf ('\n---=== Welcome to CNS packages ! ===---\n');
fprintf ('\nCNS: Setting paths ...\n');
addpath(genpath(fileparts(which([mfilename '.m'])))); % addpath with subfolders
setappdata(0,'CNSP_path',fileparts(which([mfilename '.m'])));
setappdata (0, 'old_LD_LIBRARY_PATH', CNSP_resetLib); % reset LD_LIBRARY_PATH
fprintf ('CNS: Done.\n');
% --- End CNS init.


% UIWAIT makes CNS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CNS_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function WMH_menu_Callback(hObject, eventdata, handles)
% hObject    handle to WMH_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function extract_WMH_menu_Callback(hObject, eventdata, handles)
% hObject    handle to extract_WMH_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

text = 'Starting WMH extraction pipeline - UBO Detector ...';
set (handles.output_edit,'String',text);
drawnow;

fprintf ('CNS: Starting UBO Detector ...\n');

UBO_Detector;


% --------------------------------------------------------------------
function train_Classifier_menu_Callback(hObject, eventdata, handles)
% hObject    handle to train_Classifier_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = 'Customise kNN classifier ...';
set (handles.output_edit,'String',text);
drawnow;

fprintf ('CNS: Starting customising classifier GUI ...\n');

CustomiseKNNclassifier_GUI;


% --------------------------------------------------------------------
function About_menu_Callback(hObject, eventdata, handles)
% hObject    handle to About_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function aboutSoftware_menu_Callback(hObject, eventdata, handles)
% hObject    handle to aboutSoftware_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = 'About CNS packages';
set (handles.output_edit,'String',text);
drawnow;

AboutSoftware;



function output_edit_Callback(hObject, eventdata, handles)
% hObject    handle to output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_edit as text
%        str2double(get(hObject,'String')) returns contents of output_edit as a double


% --- Executes during object creation, after setting all properties.
function output_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ini_btn.
function ini_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ini_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


delete(gcp('nocreate')); % delete existing parallel pool

progress {1} = 'Initialising ...';
set (handles.output_edit, 'String', progress);
drawnow;

p = parpool;

while p.Connected
    progress {end+1} = 'Done !';
    set (handles.output_edit, 'String', progress);
    drawnow;
    break;
end


% --------------------------------------------------------------------
function help_improve_menu_Callback(hObject, eventdata, handles)
% hObject    handle to help_improve_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function share_kNNclassifier_menu_Callback(hObject, eventdata, handles)
% hObject    handle to share_kNNclassifier_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = 'Share kNN classifier ...';
set (handles.output_edit,'String',text);
drawnow;

shareTextfileDialog;


% --------------------------------------------------------------------
function tools_menu_Callback(hObject, eventdata, handles)
% hObject    handle to tools_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function nonBrainRm_menu_Callback(hObject, eventdata, handles)
% hObject    handle to nonBrainRm_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function seg_menu_Callback(hObject, eventdata, handles)
% hObject    handle to seg_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = 'GM/WM/CSF segmentation ...';
set (handles.output_edit,'String',text);
drawnow;

segmentation_GUI;


% --------------------------------------------------------------------
function NBTR_native_menu_Callback(hObject, eventdata, handles)
% hObject    handle to NBTR_native_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = 'non-brain tissue removal in native space ...';
set (handles.output_edit,'String',text);
drawnow;

NBTR_Native_GUI;


% --------------------------------------------------------------------
function NBTR_dartel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to NBTR_dartel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = 'non-brain tissue removal in DARTEL space ...';
set (handles.output_edit,'String',text);
drawnow;

NBTR_DARTEL_GUI;



% ----------------------------------------- %
% -------------- Scripts ------------------ %
% ----------------------------------------- %

% --------------------------------------------------------------------
function scripts_menu_Callback(hObject, eventdata, handles)
% hObject    handle to scripts_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function gunzip_menu_Callback(hObject, eventdata, handles)
% hObject    handle to gunzip_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help CNSP_gunzip;

text = help('CNSP_gunzip');
set (handles.output_edit,'String',text);
drawnow;

% --------------------------------------------------------------------
function segscript_menu_Callback(hObject, eventdata, handles)
% hObject    handle to segscript_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

help CNSP_segmentation;

text = help('CNSP_segmentation');
set (handles.output_edit,'String',text);
drawnow;

% --------------------------------------------------------------------
function reg_menu_Callback(hObject, eventdata, handles)
% hObject    handle to reg_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help CNSP_registration;

text = help('CNSP_registration');
set (handles.output_edit,'String',text);
drawnow;

% --------------------------------------------------------------------
function runDARTELe_menu_Callback(hObject, eventdata, handles)
% hObject    handle to runDARTELe_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help CNSP_runDARTELe;

text = help('CNSP_runDARTELe');
set (handles.output_edit,'String',text);
drawnow;



% --------------------------------------------------------------------
function rundarteleall_menu_Callback(hObject, eventdata, handles)
% hObject    handle to rundarteleall_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

help CNSP_runDARTELe_all;

text = help('CNSP_runDARTELe_all');
set (handles.output_edit,'String',text);
drawnow;


% --------------------------------------------------------------------
function runDARTELc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to runDARTELc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help CNSP_runDARTELc;

text = help('CNSP_runDARTELc');
set (handles.output_edit,'String',text);
drawnow;

% --------------------------------------------------------------------
function NBTRn_menu_Callback(hObject, eventdata, handles)
% hObject    handle to NBTRn_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help CNSP_NBTRn;

text = help('CNSP_NBTRn');
set (handles.output_edit,'String',text);
drawnow;

% --------------------------------------------------------------------
function nativeToDARTEL_menu_Callback(hObject, eventdata, handles)
% hObject    handle to nativeToDARTEL_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help CNSP_nativeToDARTEL;

text = help('CNSP_nativeToDARTEL');
set (handles.output_edit,'String',text);
drawnow;

% --------------------------------------------------------------------
function DARTELtoNative_menu_Callback(hObject, eventdata, handles)
% hObject    handle to DARTELtoNative_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help CNSP_DARTELtoNative;

text = help('CNSP_DARTELtoNative');
set (handles.output_edit,'String',text);
drawnow;

% --------------------------------------------------------------------
function fslFASTforWMH_menu_Callback(hObject, eventdata, handles)
% hObject    handle to fslFASTforWMH_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help CNSP_fslFASTforWMH;

text = help('CNSP_fslFASTforWMH');
set (handles.output_edit,'String',text);
drawnow;


% --------------------------------------------------------------------
function imgCal_menu_Callback(hObject, eventdata, handles)
% hObject    handle to imgCal_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

help CNSP_imgCal;

text = help('CNSP_imgCal');
set (handles.output_edit,'String',text);
drawnow;

% --------------------------------------------------------------------
function webViewSlices_menu_Callback(hObject, eventdata, handles)
% hObject    handle to webViewSlices_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help CNSP_webViewSlices;

text = help('CNSP_webViewSlices');
set (handles.output_edit,'String',text);
drawnow;



% ------------------ END Scripts ------------------- %
% -------------------------------------------------- %






% --------------------------------------------------------------------
function DTI_menu_Callback(hObject, eventdata, handles)
% hObject    handle to DTI_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function dtiPreproc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to dtiPreproc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DTIpreprocessing_GUI;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
CNSP_restoreLib (getappdata (0, 'old_LD_LIBRARY_PATH'));

clc;
fprintf ('CNS: Bye for now ...\n');

delete(hObject);


% --------------------------------------------------------------------
function map2atlas_mainMenu_Callback(hObject, eventdata, handles)
% hObject    handle to map2atlas_mainMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TOPMAL_menu_Callback(hObject, eventdata, handles)
% hObject    handle to TOPMAL_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CNSP_path = fileparts (mfilename ('fullpath'));
addpath ([CNSP_path '/TOPMAL']);

% clc;
text = 'Starting TOolbox for Probablistic MApping of Lesions (TOPMAL) ...';
set (handles.output_edit,'String',text);
drawnow;

fprintf ('CNS: Starting TOPMAL (TOolbox for Probablistic MApping of Lesions) ...\n');

TOPMAL_GUI;

% --- Executes during object creation, after setting all properties.
function logoImg_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logoImg_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate logoImg_axes
CNSP_path = fileparts (mfilename ('fullpath'));

CHeBA_logo = [CNSP_path '/Logos/CHeBA logo.gif'];
% img = imread (CHeBA_logo);
% axes (handles);
imshow (CHeBA_logo);


% --------------------------------------------------------------------
function manual_menu_Callback(hObject, eventdata, handles)
% hObject    handle to manual_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CNS_User_Manual_menu_Callback(hObject, eventdata, handles)
% hObject    handle to CNS_User_Manual_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CNSP_path = fileparts (mfilename ('fullpath'));
web ([CNSP_path '/Manual/CNS_main.html'], '-new');


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
