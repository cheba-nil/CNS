function varargout = viewKNNfeatureSpace(varargin)
% VIEWKNNFEATURESPACE MATLAB code for viewKNNfeatureSpace.fig
%      VIEWKNNFEATURESPACE, by itself, creates a new VIEWKNNFEATURESPACE or raises the existing
%      singleton*.
%
%      H = VIEWKNNFEATURESPACE returns the handle to a new VIEWKNNFEATURESPACE or the handle to
%      the existing singleton*.
%
%      VIEWKNNFEATURESPACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWKNNFEATURESPACE.M with the given input arguments.
%
%      VIEWKNNFEATURESPACE('Property','Value',...) creates a new VIEWKNNFEATURESPACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewKNNfeatureSpace_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewKNNfeatureSpace_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewKNNfeatureSpace

% Last Modified by GUIDE v2.5 07-Apr-2017 17:18:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewKNNfeatureSpace_OpeningFcn, ...
                   'gui_OutputFcn',  @viewKNNfeatureSpace_OutputFcn, ...
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


% --- Executes just before viewKNNfeatureSpace is made visible.
function viewKNNfeatureSpace_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewKNNfeatureSpace (see VARARGIN)

% Choose default command line output for viewKNNfeatureSpace
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes viewKNNfeatureSpace wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = viewKNNfeatureSpace_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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


% --- Executes on button press in overlay_radiobtn.
function overlay_radiobtn_Callback(hObject, eventdata, handles)
% hObject    handle to overlay_radiobtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overlay_radiobtn

if get(hObject,'Value')
    set(handles.overlayID_edit,'Enable','on');
    set(handles.observID_edit,'Enable','on');
else
    set(handles.overlayID_edit,'Enable','off');
    set(handles.observID_edit,'Enable','off');
end

function overlayID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to overlayID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of overlayID_edit as text
%        str2double(get(hObject,'String')) returns contents of overlayID_edit as a double


% --- Executes during object creation, after setting all properties.
function overlayID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlayID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% set(handles.overlayID,'Enable','off');

function observID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to observID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of observID_edit as text
%        str2double(get(hObject,'String')) returns contents of observID_edit as a double



% --- Executes during object creation, after setting all properties.
function observID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to observID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% set(handles.observID,'Enable','off');

% --- Executes during object creation, after setting all properties.
function overlay_radiobtn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlay_radiobtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on button press in viewFeatureSpace_btn.
function viewFeatureSpace_btn_Callback(hObject, eventdata, handles)
% hObject    handle to viewFeatureSpace_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CNSP_path = getappdata(0,'CNSP_path');
studyFolder = getappdata(0,'studyFolder');
switch get(handles.classifier_popupmenu,'Value')
    case 1
        % built-in
        feature_file = [CNSP_path '/WMH_extraction/4kNN_classifier/feature_forTraining.txt'];
        decision_file = [CNSP_path '/WMH_extraction/4kNN_classifier/decision_forTraining.txt'];
        feature = importdata (feature_file);
        decision = importdata (decision_file);
    case 2
        % customised
        feature_file = [studyFolder '/customiseClassifier/textfiles/feature_forTraining.txt'];
        decision_file = [studyFolder '/customiseClassifier/textfiles/decision_forTraining.txt'];
        feature = importdata (feature_file);
        decision = importdata (decision_file);
end

if get(handles.overlay_radiobtn,'Value') == 0
    % w/o overlay
    figure ('Name','All features');
    gplotmatrix(feature(:,:),feature(:,:),...
                decision(:,1),...
                'rb','+x',[],'on','',...
                {'cluster/GM (T1)' 'cluster/GM (FLAIR)' 'cluster/WM (T1)' 'cluster/WM (FLAIR)' 'cluster size' 'mean WM prob' 'X' 'Y' 'Z'},...
                {'cluster/GM (T1)' 'cluster/GM (FLAIR)' 'cluster/WM (T1)' 'cluster/WM (FLAIR)' 'cluster size' 'mean WM prob' 'X' 'Y' 'Z'});
    figure ('Name','Intensity features');
    gplotmatrix(feature(:,1:4),feature(:,1:4),...
                decision(:,1),...
                'rb','+x',[],'on','',...
                {'cluster/GM (T1)' 'cluster/GM (FLAIR)' 'cluster/WM (T1)' 'cluster/WM (FLAIR)'},...
                {'cluster/GM (T1)' 'cluster/GM (FLAIR)' 'cluster/WM (T1)' 'cluster/WM (FLAIR)'});
else
    % w/ overlay
    subjID = get(handles.overlayID_edit,'String');
    observID = get(handles.observID_edit,'String');
    newSubjFeature_file = [studyFolder '/subjects/' subjID '/mri/extractedWMH/temp/' subjID '_feature_4prediction.txt'];
    newSubjFeature = importdata(newSubjFeature_file,' ');
    [Nrow,Ncol] = size(feature);
    feature(Nrow+1,1:Ncol) = newSubjFeature(str2num(observID),1:Ncol);
    decision(Nrow+1,1) = {'New observ'};
    figure ('Name','All features');
    gplotmatrix(feature(:,:),feature(:,:),...
                decision(:,1),...
                'rbg','+xo',[],'on','',...
                {'cluster/GM (T1)' 'cluster/GM (FLAIR)' 'cluster/WM (T1)' 'cluster/WM (FLAIR)' 'cluster size' 'mean WM prob' 'X' 'Y' 'Z'},...
                {'cluster/GM (T1)' 'cluster/GM (FLAIR)' 'cluster/WM (T1)' 'cluster/WM (FLAIR)' 'cluster size' 'mean WM prob' 'X' 'Y' 'Z'}); 
    figure ('Name','Intensity features');
    gplotmatrix(feature(:,1:4),feature(:,1:4),...
                decision(:,1),...
                'rbg','+xo',[],'on','',...
                {'cluster/GM (T1)' 'cluster/GM (FLAIR)' 'cluster/WM (T1)' 'cluster/WM (FLAIR)'},...
                {'cluster/GM (T1)' 'cluster/GM (FLAIR)' 'cluster/WM (T1)' 'cluster/WM (FLAIR)'}); 
    % reset feature and decision matrices
    feature = feature(1:Nrow,1:Ncol);
    decision = decision(1:Nrow,1);
end
            
