function varargout = autoModTxt(varargin)
% AUTOMODTXT MATLAB code for autoModTxt.fig
%      AUTOMODTXT, by itself, creates a new AUTOMODTXT or raises the existing
%      singleton*.
%
%      H = AUTOMODTXT returns the handle to a new AUTOMODTXT or the handle to
%      the existing singleton*.
%
%      AUTOMODTXT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOMODTXT.M with the given input arguments.
%
%      AUTOMODTXT('Property','Value',...) creates a new AUTOMODTXT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before autoModTxt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to autoModTxt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help autoModTxt

% Last Modified by GUIDE v2.5 29-Mar-2017 23:00:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @autoModTxt_OpeningFcn, ...
                   'gui_OutputFcn',  @autoModTxt_OutputFcn, ...
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


% --- Executes just before autoModTxt is made visible.
function autoModTxt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to autoModTxt (see VARARGIN)

% Choose default command line output for autoModTxt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes autoModTxt wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = autoModTxt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startModTxt_btn.
function startModTxt_btn_Callback(hObject, eventdata, handles)
% hObject    handle to startModTxt_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

studyFolder = getappdata (0, 'studyFolder');
ID = get (handles.ID_edit, 'String');
VisModImg = get (handles.path2modImg_edit, 'String');
[VisModImgFolder,VisModImgFilename,VisModImgExt] = fileparts(VisModImg);
if strcmp(VisModImgExt,'.img')
    VisModImg = [VisModImgFolder '/' VisModImgFilename '.nii.gz'];
end

switch get(handles.DARTELtemplateUsed_popupmenu,'Value')
    case 1
        dartelTemplate = 'existing';
        ageRange = 'lt55';
    case 2
        dartelTemplate = 'existing';
        ageRange = '65to75';
    case 3
        dartelTemplate = 'existing';
        ageRange = '70to80';
    case 4
        dartelTemplate = 'creating';
        ageRange = 'NA';
end

progressOutput = get (handles.progressOutput_edit, 'String');
progressOutput{end+1} = '';
progressOutput{end+1} = ['Generating feature/decision textfiles for ' ID ' ...'];
set (handles.progressOutput_edit, 'String', progressOutput);
drawnow;

generate_Features_N_Decisions (ID, studyFolder, VisModImg, dartelTemplate, ageRange);



progressOutput = get (handles.progressOutput_edit, 'String');
progressOutput{end+1} = 'Finished. Please go back and edit the next image.';
set (handles.progressOutput_edit, 'String', progressOutput);
drawnow;




function ID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ID_edit as text
%        str2double(get(hObject,'String')) returns contents of ID_edit as a double


% --- Executes during object creation, after setting all properties.
function ID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

currentID_charArray = getappdata (0, 'currentID');
currentID_cellArray = cellstr (currentID_charArray);
currentIDstr = currentID_cellArray{1};
set (hObject, 'String', currentIDstr);



function path2modImg_edit_Callback(hObject, eventdata, handles)
% hObject    handle to path2modImg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path2modImg_edit as text
%        str2double(get(hObject,'String')) returns contents of path2modImg_edit as a double


% --- Executes during object creation, after setting all properties.
function path2modImg_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path2modImg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findPath2modImg_btn.
function findPath2modImg_btn_Callback(hObject, eventdata, handles)
% hObject    handle to findPath2modImg_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[modImg,modImgPath] = uigetfile ({'*.nii';'*.nii.gz';'*.img'}, 'Select the modified image');
set (handles.path2modImg_edit, 'String', [modImgPath modImg]);

% if fslview saved image as hdr/img
[modImgFolder,modImgFilename,modImgExt] = fileparts ([modImgPath modImg]);
if strcmp(modImgExt,'.img')
    system(['${FSLDIR}/bin/fslchfiletype NIFTI_GZ ' modImgFolder '/' modImgFilename]);
end

% check whether image contains only 0 and 1
[status1, modImg_min] = system(['${FSLDIR}/bin/fslstats ' modImgPath modImg ' -R | awk ''{print $1}''']);
[status2, modImg_max] = system(['${FSLDIR}/bin/fslstats ' modImgPath modImg ' -R | awk ''{print $2}''']);

modImg_min_str = cellstr(modImg_min);
modImg_max_str = cellstr(modImg_max);

modImg_min = str2num(modImg_min_str{1});
modImg_max = str2num(modImg_max_str{1});


if (modImg_min ~= 0) | (modImg_max ~= 1)
    progressOutput = get (handles.progressOutput_edit, 'String');
    progressOutput {end+1} = 'Error: not a 0/1 binary image. Automatically binarise using fslmaths -bin.';
    set (handles.progressOutput_edit, 'String', progressOutput);
    drawnow;
    
    system (['${FSLDIR}/bin/fslmaths ' modImgPath modImg ' -bin ' modImgPath modImg]);
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


% --- Executes on selection change in DARTELtemplateUsed_popupmenu.
function DARTELtemplateUsed_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to DARTELtemplateUsed_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DARTELtemplateUsed_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DARTELtemplateUsed_popupmenu


% --- Executes during object creation, after setting all properties.
function DARTELtemplateUsed_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DARTELtemplateUsed_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
