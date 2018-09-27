function varargout = UBO_Detector(varargin)
% UBO_DETECTOR MATLAB code for UBO_Detector.fig
%      UBO_DETECTOR, by itself, creates a new UBO_DETECTOR or raises the existing
%      singleton*.
%
%      H = UBO_DETECTOR returns the handle to a new UBO_DETECTOR or the handle to
%      the existing singleton*.
%
%      UBO_DETECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UBO_DETECTOR.M with the given input arguments.
%
%      UBO_DETECTOR('Property','Value',...) creates a new UBO_DETECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UBO_Detector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UBO_Detector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UBO_Detector

% Last Modified by GUIDE v2.5 05-Apr-2018 10:23:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UBO_Detector_OpeningFcn, ...
                   'gui_OutputFcn',  @UBO_Detector_OutputFcn, ...
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


% --- Executes just before UBO_Detector is made visible.
function UBO_Detector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UBO_Detector (see VARARGIN)

% Choose default command line output for UBO_Detector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UBO_Detector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UBO_Detector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Study_Dir_btn.
function Study_Dir_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Study_Dir_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    studyDir = uigetdir;
    studyDirEdit = findobj ('Tag', 'StudyDir_Edit');
    set (studyDirEdit, 'String', studyDir);



function StudyDir_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to StudyDir_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StudyDir_Edit as text
%        str2double(get(hObject,'String')) returns contents of StudyDir_Edit as a double
    
    
    


% --- Executes during object creation, after setting all properties.
function StudyDir_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StudyDir_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
   




function SPMDir_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to SPMDir_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SPMDir_Edit as text
%        str2double(get(hObject,'String')) returns contents of SPMDir_Edit as a double


% --- Executes during object creation, after setting all properties.
function SPMDir_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SPMDir_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SPM_Dir_btn.
function SPM_Dir_btn_Callback(hObject, eventdata, handles)
% hObject    handle to SPM_Dir_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    spmDir = uigetdir;
    spmDirEdit = findobj ('Tag', 'SPMDir_Edit');
    set (spmDirEdit, 'String', spmDir);



% --- Executes on selection change in DARTELtemplate_popupmenu.
function DARTELtemplate_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to DARTELtemplate_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DARTELtemplate_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DARTELtemplate_popupmenu


% --- Executes during object creation, after setting all properties.
function DARTELtemplate_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DARTELtemplate_popupmenu (see GCBO)
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
 
if isnan(str2double(get(hObject,'string'))) 
    set(hObject,'string','5'); 
end 


function PVWMH_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to PVWMH_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PVWMH_Edit as text
%        str2double(get(hObject,'String')) returns contents of PVWMH_Edit as a double


% --- Executes during object creation, after setting all properties.
function PVWMH_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PVWMH_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if isnan(str2double(get(hObject,'string')))
    set(hObject,'string','15'); 
end



function progressOutput_Callback(hObject, eventdata, handles)
% hObject    handle to progressOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of progressOutput as text
%        str2double(get(hObject,'String')) returns contents of progressOutput as a double


% --- Executes during object creation, after setting all properties.
function progressOutput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to progressOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function coregQC_edit_Callback(hObject, eventdata, handles)
% hObject    handle to coregQC_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of coregQC_edit as text
%        str2double(get(hObject,'String')) returns contents of coregQC_edit as a double


% --- Executes during object creation, after setting all properties.
function coregQC_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to coregQC_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function segQC_edit_Callback(hObject, eventdata, handles)
% hObject    handle to segQC_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segQC_edit as text
%        str2double(get(hObject,'String')) returns contents of segQC_edit as a double


% --- Executes during object creation, after setting all properties.
function segQC_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segQC_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in finishCoregQCinputBtn.
function finishCoregQCinputBtn_Callback(hObject, eventdata, handles)
% hObject    handle to finishCoregQCinputBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    studyFolder = get (handles.StudyDir_Edit, 'String');
    spm12path = get (handles.SPMDir_Edit, 'String');
    
    if get (handles.disp_radiobutton, 'Value')
        outputFormat = 'web';
    elseif get (handles.download_radiobutton, 'Value')
        outputFormat = 'arch';
    elseif get (handles.both_radiobutton, 'Value')
        outputFormat = 'web&arch';
    else
        error ('Please specify how you want to perform the QC steps.');
    end
    
    WMHextraction_main_inGUI_Stage2 (studyFolder, ...
                                    spm12path, ...
                                    handles.progressOutput, ...
                                    get(handles.coregQC_edit, 'String'), ...
                                    outputFormat);





% --- Executes on button press in finishSegQCinputBtn.
function finishSegQCinputBtn_Callback(hObject, eventdata, handles)
% hObject    handle to finishSegQCinputBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    studyFolder = get (handles.StudyDir_Edit, 'String');
    spm12path = get (handles.SPMDir_Edit, 'String');
    
    DARTELtemplate123 = get (handles.DARTELtemplate_popupmenu, 'Value');
    switch DARTELtemplate123
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
    
    classifier_popup = get(handles.kNNclassifier_popupmenu,'Value');
    switch classifier_popup
        case 1
            classifier = 'built-in';
        case 2
            classifier = 'customised';
    end
    
    k = uint16 (str2num (get (handles.k_edit, 'String')));
    PVWMH_magnitude = get (handles.PVWMH_Edit, 'String');
    probThr = str2num (get (handles.probThr_edit, 'String'));
    
    if get (handles.disp_radiobutton, 'Value')
        outputFormat = 'web';
    elseif get (handles.download_radiobutton, 'Value')
        outputFormat = 'arch';
    elseif get (handles.both_radiobutton, 'Value')
        outputFormat = 'web&arch';
    else
        error ('Please specify how you want to perform the QC steps.');
    end
    
    
    trainingFeatures1 = 1:9;
    trainingFeatures2 = 10:12;
    
    WMHextraction_main_inGUI_Stage3 (studyFolder, ...
                                        spm12path, ...
                                        DARTELtemplate, ...
                                        k, ...
                                        PVWMH_magnitude, ...
                                        handles.progressOutput, ...
                                        get(handles.coregQC_edit, 'String'), ...
                                        get(handles.segQC_edit,'String'), ...
                                        classifier, ...
                                        ageRange, ...
                                        probThr, ...
                                        trainingFeatures1, ...
                                        trainingFeatures2, ...
                                        outputFormat ...
                                        );




% --- Executes on selection change in kNNclassifier_popupmenu.
function kNNclassifier_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to kNNclassifier_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns kNNclassifier_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from kNNclassifier_popupmenu
        
    classifier_popup = get(hObject,'Value');
    studyFolder = get (handles.StudyDir_Edit,'String');
    
    switch classifier_popup
        case 1
            % classifier = 'built-in classifier';
        case 2
            % classifier = 'customised classifier';
            
            if exist ([studyFolder '/customiseClassifier/textfiles/feature_forTraining.txt'],'file')...
                    && exist ([studyFolder '/customiseClassifier/textfiles/decision_forTraining.txt'],'file')
            else
                noCustomisedClassifierError;
            end
            
    end


% --- Executes during object creation, after setting all properties.
function kNNclassifier_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kNNclassifier_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on button press in disp_radiobutton.
function disp_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to disp_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_radiobutton
set (handles.download_radiobutton, 'Value', 0);
set (handles.both_radiobutton, 'Value', 0);


% --- Executes on button press in download_radiobutton.
function download_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to download_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of download_radiobutton
set (handles.disp_radiobutton, 'Value', 0);
set (handles.both_radiobutton, 'Value', 0);

% --- Executes on button press in both_radiobutton.
function both_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to both_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of both_radiobutton
set (handles.disp_radiobutton, 'Value', 0);
set (handles.download_radiobutton, 'Value', 0);


% --- Executes on button press in recommended_radiobutton.
function recommended_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to recommended_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of recommended_radiobutton
set (handles.advanced_radiobutton, 'Value', 0);
set (handles.DARTELtemplate_popupmenu, 'Enable', 'off');
set (handles.k_edit, 'Enable', 'off');
set (handles.kNNclassifier_popupmenu, 'Enable', 'off');
set (handles.probThr_edit, 'Enable', 'off');
set (handles.PVWMH_Edit, 'Enable', 'off');


% --- Executes on button press in advanced_radiobutton.
function advanced_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to advanced_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of advanced_radiobutton
set (handles.recommended_radiobutton, 'Value', 0);
set (handles.DARTELtemplate_popupmenu, 'Enable', 'on');
set (handles.k_edit, 'Enable', 'on');
set (handles.kNNclassifier_popupmenu, 'Enable', 'on');
set (handles.probThr_edit, 'Enable', 'on');
set (handles.PVWMH_Edit, 'Enable', 'on');



% --------------------------------------------------------------------

% --- Executes on button press in extractWithStop_btn.
function extractWithStop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to extractWithStop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clc;
    fprintf ('UBO Detector: Starting WMH extraction pipeline (with QC stops) ...\n');
    
    set(handles.coregQC_edit,'Enable','on');
    set(handles.segQC_edit,'Enable','on');
    set(handles.finishCoregQCinputBtn,'Enable','on');
    set(handles.finishSegQCinputBtn,'Enable','on');

    % Way 1 to retrieve a value
%     studyDirEdit_obj = findobj ('Tag', 'StudyDir_Edit');
%     studyDir = get (studyDirEdit_obj, 'String');

    studyDir = get (handles.StudyDir_Edit, 'String');
    
%     spmDirEdit_obj = findobj ('Tag', 'SPMDir_Edit');
%     spm12path = get (spmDirEdit_obj, 'String');
    % Way 2 to retrieve a value
    spm12path = get (handles.SPMDir_Edit, 'String');
    
    if get (handles.disp_radiobutton, 'Value')
        outputFormat = 'web';
    elseif get (handles.download_radiobutton, 'Value')
        outputFormat = 'arch';
    elseif get (handles.both_radiobutton, 'Value')
        outputFormat = 'web&arch';
    else
        error ('Please specify how you want to perform the QC steps.');
    end

    % if previously processed, copy T1 and FLAIR folders to studyFolder,
    % delete subjects dir
    if exist([studyDir '/originalImg'],'dir') == 7
        movefile ([studyDir '/originalImg/T1'], [studyDir '/T1']);
        movefile ([studyDir '/originalImg/FLAIR'], [studyDir '/FLAIR']);
        rmdir ([studyDir '/originalImg'],'s');
    end
    
    if exist ([studyDir '/subjects'],'dir') == 7
        rmdir ([studyDir '/subjects'],'s');
    end
        
    % run the Stage 1 main script
    WMHextraction_main_inGUI_Stage1 (studyDir, spm12path, handles.progressOutput, outputFormat);
    
    

% --- Executes on button press in extractWithoutStops.
function extractWithoutStops_Callback(hObject, eventdata, handles)
% hObject    handle to extractWithoutStops (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clc;
    fprintf ('UBO Detector: Starting WMH extraction pipeline (no QC stops) ...\n');
    
    set(handles.coregQC_edit,'Enable','off');
    set(handles.segQC_edit,'Enable','off');
    set(handles.finishCoregQCinputBtn,'Enable','off');
    set(handles.finishSegQCinputBtn,'Enable','off');
    
    DARTELtemplate123 = get (handles.DARTELtemplate_popupmenu, 'Value');
    switch DARTELtemplate123
        case 1
            DARTELtemplate = 'existing template';
            ageRange = 'lt55';
        case 2
            DARTELtemplate = 'existing template';
            ageRange = '65to75';  
            % setappdata(0,'DARtem','65to75');
        case 3
            DARTELtemplate = 'existing template';
            ageRange = '70to80';
            % setappdata(0,'DARtem','70to80');
        case 4
            DARTELtemplate = 'creating template';
            ageRange = 'NA';
            % setappdata(0,'DARtem','crt');
    end
    
    classifier_popup = get(handles.kNNclassifier_popupmenu,'Value');
    switch classifier_popup
        case 1
            classifier = 'built-in';
            % setappdata(0,'classifier','BI');
        case 2
            classifier = 'customised';
            % setappdata(0,'classifier','cust');
    end

    studyDir = get(handles.StudyDir_Edit, 'String');
    PVmag = get(handles.PVWMH_Edit, 'String');
    k = uint16(str2num (get (handles.k_edit, 'String')));
    probThr = str2num (get (handles.probThr_edit, 'String'));

    if get (handles.disp_radiobutton, 'Value')
        outputFormat = 'web';
    elseif get (handles.download_radiobutton, 'Value')
        outputFormat = 'arch';
    elseif get (handles.both_radiobutton, 'Value')
        outputFormat = 'web&arch';
    else
        error ('Please specify how you want to perform the QC steps.');
    end
    
    
    % set global parameters
    % setappdata(0,'PVmag',PVmag);
    % setappdata(0,'studyFolder',studyDir);
    % setappdata(0,'k',k);
    
    % if previously processed, copy T1 and FLAIR folders to studyFolder,
    % delete subjects dir
    if exist ([studyDir '/originalImg'],'dir') == 7
        movefile ([studyDir '/originalImg/T1'], [studyDir '/T1']);
        movefile ([studyDir '/originalImg/FLAIR'], [studyDir '/FLAIR']);
        rmdir ([studyDir '/originalImg'],'s');
    end
    
    if exist ([studyDir '/subjects'],'dir') == 7
        rmdir ([studyDir '/subjects'],'s');
    end

    % user definable in future
    trainingFeatures1 = 1:9;
    trainingFeatures2 = 10:12;
    
    WMHextraction_main_noQCstops (studyDir, ...
                                  get(handles.SPMDir_Edit, 'String'), ...
                                  DARTELtemplate, ...
                                  k, ...
                                  PVmag, ...
                                  '', ... % coregExcldList = empty
                                  '', ... % segExcldList = empty
                                  handles.progressOutput, ... % progress output in the GUI
                                  classifier, ...
                                  ageRange, ...
                                  probThr, ...
                                  trainingFeatures1, ...
                                  trainingFeatures2, ...
                                  outputFormat ...
                                 );




 
% --- Executes on button press in halt_btn.
function halt_btn_Callback(hObject, eventdata, handles)
% hObject    handle to halt_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
outputTxt = get (handles.progressOutput,'String');
outputTxt{end+1} = '';
outputTxt{end+1} = '--== HALTED ! ==--';
set(handles.progressOutput,'String',outputTxt);
drawnow;

error('User halted execution!');



                             
                             
                             
                             
 %-----------------
 %     OPTIONS
 %-----------------

 

% --------------------------------------------------------------------
function extractAgain_menu_Callback(hObject, eventdata, handles)
% hObject    handle to extractAgain_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

studyFolder = get(handles.StudyDir_Edit, 'String');
coregExcldList = get(handles.coregQC_edit,'String');
segExcldList = get(handles.segQC_edit,'String');
excldIDs = strsplit([coregExcldList ' ' segExcldList], ' ');
T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
[Nsubj,~] = size (T1folder);

% ------ if not existing extractedWMH/ID_predicted_WMH_clusters.nii*, grey
% out "extract again with a different PVWMH magnitude" -------------------
set (handles.diffPVmagRun_menu,'Enable','on'); % default on
for i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID
    if ismember(ID, excldIDs) == 0
        predictedWMHpath = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH.nii*'];
        if isempty(dir(predictedWMHpath))
            set (handles.diffPVmagRun_menu,'Enable','off');
            break
        end
    end
end

% ------ if not existing
% kNN_intermediateOutput/ID_accurateCSFmasked_seg?.nii*, grey out "extract again with a different kNN classifier"
% --------------------------------------------
set (handles.diffKNNrun_menu,'Enable','on');
for j = 1:Nsubj
    T1imgNames = strsplit (T1folder(j).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID   
    if ismember(ID, excldIDs) == 0
        seg0Path = [studyFolder '/subjects/' ID '/mri/kNN_intermediateOutput/' ID '_accurateCSFmasked_seg0.nii*'];
        seg1Path = [studyFolder '/subjects/' ID '/mri/kNN_intermediateOutput/' ID '_accurateCSFmasked_seg1.nii*'];
        seg2Path = [studyFolder '/subjects/' ID '/mri/kNN_intermediateOutput/' ID '_accurateCSFmasked_seg2.nii*'];
        if isempty(dir(seg0Path)) || isempty(dir(seg1Path)) || isempty(dir(seg2Path))
            set (handles.diffKNNrun_menu,'Enable','off');
            break
        end
    end
end

% --- if not existing ID_WMH_Prob0_*, grey out "re-extract with a different
% prob threhold ---
set(handles.diffProbThrRun_menu,'Enable','on');
for h = 1:Nsubj
    T1imgNames = strsplit (T1folder(h).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID   

    if ismember(ID, excldIDs) == 0
        probMap = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_Prob0_*.nii*'];
        if isempty(dir(probMap))
            set (handles.diffProbThrRun_menu,'Enable','off');
            break
        end
    end
end


% --- if not existing rc1 rc2 rc3, grey out "re-extract with a different
% DARTEL template ---
set(handles.diffDARTELrun_menu,'Enable','on');
for k = 1:Nsubj
    T1imgNames = strsplit (T1folder(k).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID   
    T1imgFilename_parts = strsplit (T1folder(k).name, '.');   % split T1 image name, delimiter is underscore
    T1imgFilename = T1imgFilename_parts{1};   % first section is ID 
    if ~ismember(ID, excldIDs)
        rcGMpath = [studyFolder '/subjects/' ID '/mri/preprocessing/rc1' T1imgFilename '.nii*'];
        rcWMpath = [studyFolder '/subjects/' ID '/mri/preprocessing/rc2' T1imgFilename '.nii*'];
        rcCSFpath = [studyFolder '/subjects/' ID '/mri/preprocessing/rc3' T1imgFilename '.nii*'];
        
        if isempty(dir(rcGMpath)) || isempty(dir(rcWMpath)) || isempty(dir(rcCSFpath))
            fprintf ('here');
            set (handles.diffDARTELrun_menu,'Enable','off');
            break
        end
    end
end




function view_menu_Callback(hObject, eventdata, handles)
% hObject    handle to view_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ------ if not existing subjects/QC/QC_final.html, grey out view by study
studyFolder = get(handles.StudyDir_Edit, 'String');
coregExcldList = get(handles.coregQC_edit,'String');
segExcldList = get(handles.segQC_edit,'String');
excldIDs = strsplit([coregExcldList ' ' segExcldList], ' ');
T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
[Nsubj,~] = size (T1folder);

% ------ determine whether QC html file exist (for view by study)
if exist ([studyFolder '/subjects/QC/QC_final/QC_final.html'],'file') ~= 2
    set (handles.viewWmhByStudy_menu,'Enable','off');
elseif exist ([studyFolder '/subjects/QC/QC_final/QC_final.html'],'file') == 2
    set (handles.viewWmhByStudy_menu,'Enable','on');
end

if exist ([studyFolder '/subjects/QC/QC_coreg/QC_coreg.html'],'file') ~= 2
    set (handles.viewCoregByStudy_menu,'Enable','off');
elseif exist ([studyFolder '/subjects/QC/QC_coreg/QC_coreg.html'],'file') == 2
    set (handles.viewCoregByStudy_menu,'Enable','on');
end

if exist ([studyFolder '/subjects/QC/QC_seg/QC_Segmentation.html'],'file') ~= 2
    set (handles.viewSegByStudy_menu,'Enable','off');
elseif exist ([studyFolder '/subjects/QC/QC_seg/QC_Segmentation.html'],'file') == 2
    set (handles.viewSegByStudy_menu,'Enable','on');
end








% --------------------------------------------------------------------
function diffDARTELrun_menu_Callback(hObject, eventdata, handles)
% hObject    handle to diffDARTELrun_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic;

SPMpath = get(handles.SPMDir_Edit,'String');
addpath(SPMpath);
studyFolder = get(handles.StudyDir_Edit, 'String');
setappdata (0, 'studyFolder', studyFolder);
CNSP_path = getappdata(0,'CNSP_path');
coregExcldList = get(handles.coregQC_edit,'String');
segExcldList = get(handles.segQC_edit,'String');
excldIDs = strsplit([coregExcldList ' ' segExcldList], ' ');
DARTELtemplate123 = get (handles.DARTELtemplate_popupmenu, 'Value');

if get (handles.disp_radiobutton, 'Value')
    outputFormat = 'web';
elseif get (handles.download_radiobutton, 'Value')
    outputFormat = 'arch';
elseif get (handles.both_radiobutton, 'Value')
    outputFormat = 'web&arch';
end

switch DARTELtemplate123
    case 1
        prevAgeRange = '65to75';  
        prevDARTELtemplate = 'existing template';
    case 2
        prevAgeRange = '70to80';
        prevDARTELtemplate = 'existing template';
    case 3
        prevAgeRange = 'NA';
        prevDARTELtemplate = 'creating template';
end
prevk = get(handles.k_edit,'String');
classifier_popup = get(handles.kNNclassifier_popupmenu,'Value');
switch classifier_popup
    case 1
        prevclassifier = 'built-in';
    case 2
        prevclassifier = 'custmosed';
end
prevProbThr = get(handles.probThr_edit,'String');
prevPVmag = get(handles.PVWMH_Edit, 'String');

% setappdata(0,'PVmag', prevPVmag);


if isempty(getappdata(0,'PVmag'))
    PVmag = prevPVmag;
else
    PVmag = getappdata(0,'PVmag');
end

if isempty(getappdata(0,'probThr'))
    probThr = prevProbThr;
else
    probThr = getappdata(0,'probThr');
end

% probThr_str = num2str (probThr, '%1.2f');

if isempty(getappdata(0,'classifier'))
    classifier = prevclassifier;
else
    classifier = getappdata(0,'classifier');
end

if isempty(getappdata(0,'k'))
    k = prevk;
else
    k = getappdata(0,'k');
end

if isempty(getappdata(0,'DARtem'))
    DARTELtemplate = prevDARTELtemplate;
else
    DARTELtemplate = getappdata(0,'DARtem');
end

if isempty(getappdata(0,'ageRange'))
    ageRange = prevAgeRange;
else
    ageRange = getappdata(0,'ageRange');
end

outputTxt{1} = '---=== Re-extract with a different DARTEL template ===---';
outputTxt{end+1} = '';
outputTxt{end+1} = ['current DARTEL template = ' DARTELtemplate];
outputTxt{end+1} = ['current age range = ' ageRange];
outputTxt{end+1} = ['current k = ' k];
outputTxt{end+1} = ['current classifier = ' classifier];
outputTxt{end+1} = ['current probability threshold = ' probThr];
outputTxt{end+1} = ['current PVWMH magnitude = ' PVmag];
outputTxt{end+1} = '';
outputTxt{end+1} = 'Please wait ...';
set(handles.progressOutput,'String',outputTxt);
drawnow;

% enable loop through all subjects
% T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
% FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
% [Nsubj,n] = size (T1folder);


if exist ([studyFolder '/subjects'],'dir') ~= 7
    % --- original PVmag folder ---
%     if exist ([studyFolder '/subjects_' ageRange '_k' k '_' classifier '_probThr_' probThr '_PV' PVmag],'dir') ~= 7
%         copyfile ([studyFolder '/subjects'],[studyFolder '/subjects_' ageRange '_k' k '_' classifier '_probThr_' probThr '_PV' PVmag]);
%     end
% else
    outputTxt{end+1} = 'Error: it seems you have not processed the data with WMH extraction pipeline.';
    set (handles.progressOutput,'String',outputTxt);
    drawnow;
    error('it seems you have not processed the data with WMH extraction pipeline');
end

% input new kNN classifier parameters
waitfor(reExtractWithNewDARTELtemp);


% retrieve any newly set parameters
if isempty(getappdata(0,'PVmag'))
    PVmag = prevPVmag;
else
    PVmag = getappdata(0,'PVmag');
end

if isempty(getappdata(0,'probThr'))
    probThr = prevProbThr;
else
    probThr = getappdata(0,'probThr');
end

probThr_str = num2str (str2num (probThr), '%1.2f');

if isempty(getappdata(0,'classifier'))
    classifier = prevclassifier;
else
    classifier = getappdata(0,'classifier');
end

if isempty(getappdata(0,'k'))
    k = prevk;
else
    k = getappdata(0,'k');
end

if isempty(getappdata(0,'DARtem'))
    DARTELtemplate = prevDARTELtemplate;
else
    DARTELtemplate = getappdata(0,'DARtem');
end

if isempty(getappdata(0,'ageRange'))
    ageRange = prevAgeRange;
else
    ageRange = getappdata(0,'ageRange');
end

outputTxt{end+1} = '';
outputTxt{end+1} = ['new DARTEL template = ' DARTELtemplate];
outputTxt{end+1} = ['new age range = ' ageRange];
outputTxt{end+1} = ['new k = ' k];
outputTxt{end+1} = ['new classifier = ' classifier];
outputTxt{end+1} = ['new probability threshold = ' probThr];
outputTxt{end+1} = ['new PVWMH magnitude = ' PVmag];
outputTxt{end+1} = '';
outputTxt{end+1} = 'Re-extracting ...';
set(handles.progressOutput,'String',outputTxt);
drawnow;

% enable loop through all subjects
T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
[Nsubj,~] = size (T1folder);


% Re-extract

% cmd_skullStriping_FAST_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_SkullStriping_and_FAST.sh'];
% system (cmd_skullStriping_FAST_1);
    
% cmd_kNN_step1_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step1.sh'];
% system (cmd_kNN_step1_1);

% cmd_kNN_step3_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh'];
% system (cmd_kNN_step3_1);

% cmd_merge_WMHresults_1 = ['if [ -f ' studyFolder '/subjects/WMH_spreadsheet.txt ];then rm -f ' studyFolder '/subjects/WMH_spreadsheet.txt;fi'];
% system (cmd_merge_WMHresults_1);

% cmd_merge_WMHresults_2 = ['echo "ID,wholeBrainWMHvol_mm3,PVWMHvol_mm3,DWMHvol_mm3,Lfrontal_WMHvol_mm3,Rfrontal_WMHvol_mm3,Ltemporal_WMHvol_mm3,Rtemporal_WMHvol_mm3,Lparietal_WMHvol_mm3,Rparietal_WMHvol_mm3,Loccipital_WMHvol_mm3,Roccipital_WMHvol_mm3,Lcerebellum_WMHvol_mm3,Rcerebellum_WMHvol_mm3,Brainstem_WMHvol_mm3" >> ' ...
%                                 studyFolder '/subjects/WMH_spreadsheet.txt'];
% system (cmd_merge_WMHresults_2);

% cmd_merge_WMHresults_3 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh'];
% system (cmd_merge_WMHresults_3);

system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);

WMHextraction_preprocessing_Step3 (studyFolder, ...
                                        CNSP_path, ...
                                        DARTELtemplate, ...
                                        coregExcldList, ...
                                        segExcldList, ...
                                        ageRange...
                                        );  % dartelTemplate specifies which set of templates to be used.

WMHextraction_preprocessing_Step4 (studyFolder, DARTELtemplate, coregExcldList, segExcldList, CNSP_path); % Step 4: bring to DARTEL

% user definable in future
trainingFeatures1 = 1:9;
trainingFeatures2 = 10:12;
            
parfor i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    
    if ismember(ID, excldIDs) == 0
        cmd_skullStriping_FAST_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_SkullStriping_and_FAST.sh ' ...
                                                                                                            T1folder(i).name ' ' ...
                                                                                                            FLAIRfolder(i).name ' ' ...
                                                                                                            studyFolder '/subjects ' ...
                                                                                                            ID ' ' ...
                                                                                                            CNSP_path ' ' ...
                                                                                                            strrep(DARTELtemplate, ' ', '_') ' ' ...
                                                                                                            ageRange];
        system (cmd_skullStriping_FAST_2);
        
        cmd_kNN_step1_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step1.sh ' ...
                                                                                                ID ' ' ...
                                                                                                studyFolder '/subjects ' ...
                                                                                                CNSP_path ' ' ...
                                                                                                strrep(DARTELtemplate, ' ', '_') ' ' ...
                                                                                                ageRange];
        system (cmd_kNN_step1_2);
        
        WMHextraction_kNNdiscovery_Step2 (str2num(k), ...
                                              ID, ...
                                              CNSP_path, ...
                                              studyFolder, ...
                                              classifier, ...
                                              DARTELtemplate, ...
                                              ageRange, ...
                                              str2num(probThr), ...
                                              trainingFeatures1, ...
                                              trainingFeatures2 ...
                                              );
                                          
        cmd_kNN_step3_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh ' ...
                                                                                            ID ' ' ...
                                                                                            studyFolder '/subjects ' ...
                                                                                            CNSP_path '/WMH_extraction ' ...
                                                                                            PVmag ' ' ...
                                                                                            probThr_str];
                                                                                        
        % cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ...
        %                                                                                     ID ' ' ...
        %                                                                                     studyFolder '/subjects'];
             
        system (cmd_kNN_step3_2);
        % system (cmd_merge_WMHresults_4);
    end
end



for i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    
    if ismember(ID, excldIDs) == 0
        cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ...
                                                                                            ID ' ' ...
                                                                                            studyFolder '/subjects'];
        system (cmd_merge_WMHresults_4);
    end
end








WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, outputFormat);

switch outputFormat
    case 'web'
        % display on screen
    case 'arch'
        outputTxt {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_final/QC_final.zip'];
    case 'web&arch'
        outputTxt {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_final/QC_final.zip'];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bring back to native space %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('UBO Detector: Bringing DARTEL space WMH mask to native space ...');

parfor i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID
    
    if ismember(ID, excldIDs) == 0
        switch DARTELtemplate
        case 'existing template'
            WMHresultsBack2NativeSpace (studyFolder, ID, SPMpath);
        case 'creating template'
            WMHresultsBack2NativeSpace (studyFolder, ID, SPMpath, '', 'creating template');
        end
    end
end

% webpage display
% [~, NexcldIDs] = size (excldIDs);
% indFLAIR_cellArr = cell ((Nsubj - NexcldIDs), 1);
% indWMH_FLAIRspace_cellArr = cell ((Nsubj - NexcldIDs), 1);
indFLAIR_cellArr = cell (Nsubj, 1);
indWMH_FLAIRspace_cellArr = cell (Nsubj, 1);

for i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID
    
    if ismember (ID, excldIDs) == 0
        indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
        
        indWMH_FLAIRspace_cellArr{i,1} = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii.gz'];
        
    else % if ID is excluded, display the FLAIR image twice
        indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
        
        indWMH_FLAIRspace_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
    end
end

if exist ([studyFolder '/subjects/QC/QC_final_native'], 'dir') ~= 7
    mkdir ([studyFolder '/subjects/QC'], 'QC_final_native');
end

CNSP_webViewSlices_overlay (indFLAIR_cellArr, ...
                            indWMH_FLAIRspace_cellArr, ...
                            [studyFolder '/subjects/QC/QC_final_native'], ...
                            'QC_final_native', ...
                            'web');


%%%%%%%%%%%%%%%%%%%%%%
%% "finish" message %%
%%%%%%%%%%%%%%%%%%%%%%

outputTxt{end+1} = 'Finished !';
set(handles.progressOutput,'String',outputTxt);
drawnow; 

total_time = toc/3600; % in hrs
fprintf ('');
fprintf ('%.2f hours elapsed to finish the whole extraction procedure.\n', total_time);
fprintf ('');


outputTxt {end+1} = [num2str(total_time) ' hrs eclapsed to finish.'];
set(handles.progressOutput,'String',outputTxt);
drawnow;




% --------------------------------------------------------------------
function diffKNNrun_menu_Callback(hObject, eventdata, handles)
% hObject    handle to diffKNNrun_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% retrieve parameters

% outputTxt = get(handles.progressOutput,'String');
tic;

SPMpath = get(handles.SPMDir_Edit,'String');
studyFolder = get(handles.StudyDir_Edit, 'String');
setappdata (0, 'studyFolder', studyFolder);
CNSP_path = getappdata(0,'CNSP_path');
coregExcldList = get(handles.coregQC_edit,'String');
segExcldList = get(handles.segQC_edit,'String');
excldIDs = strsplit([coregExcldList ' ' segExcldList], ' ');
DARTELtemplate123 = get (handles.DARTELtemplate_popupmenu, 'Value');

switch DARTELtemplate123
    case 1
        prevAgeRange = '65to75';  
        prevDARTELtemplate = 'existing template';
    case 2
        prevAgeRange = '70to80';
        prevDARTELtemplate = 'existing template';
    case 3
        prevAgeRange = 'NA';
        prevDARTELtemplate = 'creating template';
end

prevk = get(handles.k_edit,'String');
classifier_popup = get(handles.kNNclassifier_popupmenu,'Value');
switch classifier_popup
    case 1
        prevclassifier = 'built-in';
    case 2
        prevclassifier = 'custmosed';
end
prevProbThr = get (handles.probThr_edit, 'String');
prevPVmag = get(handles.PVWMH_Edit, 'String');

% setappdata(0,'PVmag', prevPVmag);


if isempty(getappdata(0,'PVmag'))
    PVmag = prevPVmag;
else
    PVmag = getappdata(0,'PVmag');
end

if isempty (getappdata (0, 'probThr'))
    probThr = prevProbThr;
else
    probThr = getappdata (0, 'probThr');
end

if isempty(getappdata(0,'classifier'))
    classifier = prevclassifier;
else
    classifier = getappdata(0,'classifier');
end

if isempty(getappdata(0,'k'))
    k = prevk;
else
    k = getappdata(0,'k');
end

if isempty(getappdata(0,'DARtem'))
    DARTELtemplate = prevDARTELtemplate;
else
    DARTELtemplate = getappdata(0,'DARtem');
end

if isempty(getappdata(0,'ageRange'))
    ageRange = prevAgeRange;
else
    ageRange = getappdata(0,'ageRange');
end

outputTxt{1} = '---=== Re-extract with a different kNN classifier ===---';
outputTxt{end+1} = '';
outputTxt{end+1} = ['current DARTEL template = ' DARTELtemplate];
outputTxt{end+1} = ['current age range = ' ageRange];
outputTxt{end+1} = ['current k = ' k];
outputTxt{end+1} = ['current classifier = ' classifier];
outputTxt{end+1} = ['current probability threshold = ' probThr];
outputTxt{end+1} = ['current PVWMH magnitude = ' PVmag];
outputTxt{end+1} = '';
outputTxt{end+1} = 'Please wait ...';
set(handles.progressOutput,'String',outputTxt);
drawnow;

% enable loop through all subjects
% T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
% FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
% [Nsubj,n] = size (T1folder);


if exist ([studyFolder '/subjects'],'dir') ~= 7
%     % --- original PVmag folder ---
%     if exist ([studyFolder '/subjects_' ageRange '_k' k '_' classifier '_probThr_' probThr '_PV' PVmag],'dir') ~= 7
% %         if isempty(getappdata(0,'PVmag')) && isempty(getappdata(0,'classifier')) && isempty(getappdata(0,'k')) && isempty(getappdata(0,'DARtem'))
%             copyfile ([studyFolder '/subjects'],[studyFolder '/subjects_' ageRange '_k' k '_' classifier '_probThr_' probThr '_PV' PVmag]);
%     end
    outputTxt{end+1} = 'Error: it seems you have not processed the data with WMH extraction pipeline.';
    set (handles.progressOutput,'String',outputTxt);
    drawnow;
    error('it seems you have not processed the data with WMH extraction pipeline');
end

% input new kNN classifier parameters
waitfor(reExtractWithNewKNNclassifier);


% retrieve any newly set parameters
if isempty(getappdata(0,'PVmag'))
    PVmag = prevPVmag;
else
    PVmag = getappdata(0,'PVmag');
end

if isempty (getappdata (0, 'probThr'))
    probThr = prevProbThr;
else
    probThr = getappdata (0, 'probThr');
end

probThr_str = num2str (str2num (probThr), '%1.2f');

if isempty(getappdata(0,'classifier'))
    classifier = prevclassifier;
else
    classifier = getappdata(0,'classifier');
end

if isempty(getappdata(0,'k'))
    k = prevk;
else
    k = getappdata(0,'k');
end

if isempty(getappdata(0,'DARtem'))
    DARTELtemplate = prevDARTELtemplate;
else
    DARTELtemplate = getappdata(0,'DARtem');
end

if isempty(getappdata(0,'ageRange'))
    ageRange = prevAgeRange;
else
    ageRange = getappdata(0,'ageRange');
end

outputTxt{end+1} = '';
outputTxt{end+1} = ['new DARTEL template = ' DARTELtemplate];
outputTxt{end+1} = ['new age range = ' ageRange];
outputTxt{end+1} = ['new k = ' k];
outputTxt{end+1} = ['new classifier = ' classifier];
outputTxt{end+1} = ['new probability threshold = ' probThr];
outputTxt{end+1} = ['new PVWMH magnitude = ' PVmag];
outputTxt{end+1} = '';
outputTxt{end+1} = 'Re-extracting ...';
set(handles.progressOutput,'String',outputTxt);
drawnow;

% enable loop through all subjects
T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
[Nsubj,n] = size (T1folder);


% Re-extract

% cmd_kNN_step3_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh'];
% system (cmd_kNN_step3_1);

% cmd_merge_WMHresults_1 = ['if [ -f ' studyFolder '/subjects/WMH_spreadsheet.txt ];then rm -f ' studyFolder '/subjects/WMH_spreadsheet.txt;fi'];
% system (cmd_merge_WMHresults_1);

% cmd_merge_WMHresults_2 = ['echo "ID,wholeBrainWMHvol_mm3,PVWMHvol_mm3,DWMHvol_mm3,Lfrontal_WMHvol_mm3,Rfrontal_WMHvol_mm3,Ltemporal_WMHvol_mm3,Rtemporal_WMHvol_mm3,Lparietal_WMHvol_mm3,Rparietal_WMHvol_mm3,Loccipital_WMHvol_mm3,Roccipital_WMHvol_mm3,Lcerebellum_WMHvol_mm3,Rcerebellum_WMHvol_mm3,Brainstem_WMHvol_mm3" >> ' ...
%                                 studyFolder '/subjects/WMH_spreadsheet.txt'];
% system (cmd_merge_WMHresults_2);

% cmd_merge_WMHresults_3 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh'];
% system (cmd_merge_WMHresults_3);

system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);

% user definable in future
trainingFeatures1 = 1:9;
trainingFeatures2 = 10:12;
            
parfor i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    
    if ismember(ID, excldIDs) == 0
        WMHextraction_kNNdiscovery_Step2 (str2num(k), ...
                                              ID, ...
                                              CNSP_path, ...
                                              studyFolder, ...
                                              classifier, ...
                                              DARTELtemplate, ...
                                              ageRange, ...
                                              str2num(probThr), ...
                                              trainingFeatures1, ...
                                              trainingFeatures2, ...
                                              'noGenF'); % no need to generate feature again
        cmd_kNN_step3_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh ' ...
                                                                                            ID ' ' ...
                                                                                            studyFolder '/subjects ' ...
                                                                                            CNSP_path '/WMH_extraction ' ...
                                                                                            PVmag ' ' ...
                                                                                            probThr_str];
                                                                                        
        % cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ...
                                                                                                    % ID ' ' ...
                                                                                                    % studyFolder '/subjects'];
             
        system (cmd_kNN_step3_2);
        % system (cmd_merge_WMHresults_4);
    end
end



for i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    
    if ismember(ID, excldIDs) == 0
        cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ...
                                                                                            ID ' ' ...
                                                                                            studyFolder '/subjects'];
        system (cmd_merge_WMHresults_4);
    end
end


% WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, outputFormat);
WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, 'web');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bring back to native space %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('UBO Detector: Bringing DARTEL space WMH mask to native space ...');

parfor i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID
    
    if ismember(ID, excldIDs) == 0
        switch DARTELtemplate
        case 'existing template'
            WMHresultsBack2NativeSpace (studyFolder, ID, SPMpath);
        case 'creating template'
            WMHresultsBack2NativeSpace (studyFolder, ID, SPMpath, '', 'creating template');
        end
    end
end

% webpage display
% [~, NexcldIDs] = size (excldIDs);
% indFLAIR_cellArr = cell ((Nsubj - NexcldIDs), 1);
% indWMH_FLAIRspace_cellArr = cell ((Nsubj - NexcldIDs), 1);
indFLAIR_cellArr = cell (Nsubj, 1);
indWMH_FLAIRspace_cellArr = cell (Nsubj, 1);

for i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID
    
    if ismember (ID, excldIDs) == 0
        indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
        
        indWMH_FLAIRspace_cellArr{i,1} = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii.gz'];
        
    else % if ID is excluded, display the FLAIR image twice
        indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
        
        indWMH_FLAIRspace_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
    end
end

if exist ([studyFolder '/subjects/QC/QC_final_native'], 'dir') ~= 7
    mkdir ([studyFolder '/subjects/QC'], 'QC_final_native');
end

CNSP_webViewSlices_overlay (indFLAIR_cellArr, ...
                            indWMH_FLAIRspace_cellArr, ...
                            [studyFolder '/subjects/QC/QC_final_native'], ...
                            'QC_final_native', ...
                            'web');


%%%%%%%%%%%%%%%%%%%%%%
%% "finish" message %%
%%%%%%%%%%%%%%%%%%%%%%

outputTxt{end+1} = 'Finished !';
set(handles.progressOutput,'String',outputTxt);
drawnow; 

total_time = toc/3600; % in hrs
fprintf ('');
fprintf ('%.2f hours elapsed to finish the whole extraction procedure.\n', total_time);
fprintf ('');


outputTxt {end+1} = [num2str(total_time) ' hrs eclapsed to finish.'];
set(handles.progressOutput,'String',outputTxt);
drawnow;





% --------------------------------------------------------------------
function diffKNNrun_Advanced_menu_Callback(hObject, eventdata, handles)
% hObject    handle to diffKNNrun_Advanced_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = get(handles.StudyDir_Edit, 'String');
CNSP_path = getappdata(0,'CNSP_path');
coregExcldList = get(handles.coregQC_edit,'String');
segExcldList = get(handles.segQC_edit,'String');
excldIDs = strsplit([coregExcldList ' ' segExcldList], ' ');
DARTELtemplate123 = get (handles.DARTELtemplate_popupmenu, 'Value');
switch DARTELtemplate123
    case 1
        prevAgeRange = 'lt55';
        prevDARTELtemplate = 'existing template';
        ageRange = 'lt55';
    case 2
        prevAgeRange = '65to75';  
        prevDARTELtemplate = 'existing template';
        ageRange = '65to75';
    case 3
        prevAgeRange = '70to80';
        prevDARTELtemplate = 'existing template';
        ageRange = '70-80';
    case 4
        prevAgeRange = 'NA';
        prevDARTELtemplate = 'creating template';
        ageRange = 'NA';
end
prevk = get(handles.k_edit,'String');
classifier_popup = get(handles.kNNclassifier_popupmenu,'Value');
switch classifier_popup
    case 1
        prevclassifier = 'built-in';
    case 2
        prevclassifier = 'custmosed';
end
prevProbThr = get(handles.probThr_edit, 'String');
prevPVmag = get(handles.PVWMH_Edit, 'String');

% setappdata(0,'PVmag', prevPVmag);


if isempty(getappdata(0,'PVmag'))
    PVmag = prevPVmag;
else
    PVmag = getappdata(0,'PVmag');
end

if isempty (getappdata (0, 'probThr'))
    probThr = prevProbThr;
else
    probThr = getappdata (0, 'probThr');
end    

if isempty(getappdata(0,'classifier'))
    classifier = prevclassifier;
else
    classifier = getappdata(0,'classifier');
end

if isempty(getappdata(0,'k'))
    k = prevk;
else
    k = getappdata(0,'k');
end

if isempty(getappdata(0,'DARtem'))
    DARTELtemplate = prevDARTELtemplate;
else
    DARTELtemplate = getappdata(0,'DARtem');
end

if isempty(getappdata(0,'ageRange'))
    ageRange = prevAgeRange;
else
    ageRange = getappdata(0,'ageRange');
end

outputTxt{1} = '---=== Re-extract with a different kNN classifier ===---';
outputTxt{end+1} = '';
outputTxt{end+1} = ['current DARTEL template = ' DARTELtemplate];
outputTxt{end+1} = ['current age range = ' ageRange];
outputTxt{end+1} = ['current k = ' k];
outputTxt{end+1} = ['current classifier = ' classifier];
outputTxt{end+1} = ['current probability threshold = ' probThr];
outputTxt{end+1} = ['current PVWMH magnitude = ' PVmag];
outputTxt{end+1} = '';
outputTxt{end+1} = 'Please wait ...';
set(handles.progressOutput,'String',outputTxt);
drawnow;

% enable loop through all subjects
% T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
% FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
% [Nsubj,n] = size (T1folder);


if exist ([studyFolder '/subjects'],'dir') == 7
    % --- original PVmag folder ---
    if exist ([studyFolder '/subjects_' ageRange '_k' k '_' classifier '_probThr_' probThr '_PV' PVmag],'dir') ~= 7
%         if isempty(getappdata(0,'PVmag')) && isempty(getappdata(0,'classifier')) && isempty(getappdata(0,'k')) && isempty(getappdata(0,'DARtem'))
            copyfile ([studyFolder '/subjects'],[studyFolder '/subjects_' ageRange '_k' k '_' classifier '_probThr_' probThr '_PV' PVmag]);
    end
else
    outputTxt{end+1} = 'Error: it seems you have not processed the data with WMH extraction pipeline.';
    set (handles.progressOutput,'String',outputTxt);
    drawnow;
    error('it seems you have not processed the data with WMH extraction pipeline');
end

% input new kNN classifier parameters
waitfor(reExtractWithNewKNNclassifier_ADV);


% retrieve any newly set parameters
if isempty(getappdata(0,'PVmag'))
    PVmag = prevPVmag;
else
    PVmag = getappdata(0,'PVmag');
end

if isempty (getappdata (0, 'probThr'))
    probThr = prevProbThr;
else
    probThr = getappdata (0, 'probThr');
end    

if isempty(getappdata(0,'classifier'))
    classifier = prevclassifier;
else
    classifier = getappdata(0,'classifier');
end

if isempty(getappdata(0,'k'))
    k = prevk;
else
    k = getappdata(0,'k');
end

if isempty(getappdata(0,'DARtem'))
    DARTELtemplate = prevDARTELtemplate;
else
    DARTELtemplate = getappdata(0,'DARtem');
end

if isempty(getappdata(0,'ageRange'))
    ageRange = prevAgeRange;
else
    ageRange = getappdata(0,'ageRange');
end

% advanced kNN options
NSMethod = getappdata(0,'NSMethod');
Distance = getappdata(0,'Distance');
Standardize = getappdata(0,'Standardize');

outputTxt{end+1} = '';
outputTxt{end+1} = ['new DARTEL template = ' DARTELtemplate];
outputTxt{end+1} = ['new age range = ' ageRange];
outputTxt{end+1} = ['new k = ' k];
outputTxt{end+1} = ['new classifier = ' classifier];
outputTxt{end+1} = ['new probability threshold = ' probThr];
outputTxt{end+1} = ['new PVWMH magnitude = ' PVmag];
outputTxt{end+1} = ['new NSMethod = ' NSMethod];
outputTxt{end+1} = ['new Distance metric = ' Distance];
outputTxt{end+1} = '';
outputTxt{end+1} = 'Re-extracting ...';
set(handles.progressOutput,'String',outputTxt);
drawnow;

% enable loop through all subjects
T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
[Nsubj,n] = size (T1folder);


% Re-extract

% cmd_kNN_step3_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh'];
% system (cmd_kNN_step3_1);

% cmd_merge_WMHresults_1 = ['if [ -f ' studyFolder '/subjects/WMH_spreadsheet.txt ];then rm -f ' studyFolder '/subjects/WMH_spreadsheet.txt;fi'];
% system (cmd_merge_WMHresults_1);

% cmd_merge_WMHresults_2 = ['echo "ID,wholeBrainWMHvol_mm3,PVWMHvol_mm3,DWMHvol_mm3,Lfrontal_WMHvol_mm3,Rfrontal_WMHvol_mm3,Ltemporal_WMHvol_mm3,Rtemporal_WMHvol_mm3,Lparietal_WMHvol_mm3,Rparietal_WMHvol_mm3,Loccipital_WMHvol_mm3,Roccipital_WMHvol_mm3,Lcerebellum_WMHvol_mm3,Rcerebellum_WMHvol_mm3,Brainstem_WMHvol_mm3" >> ' ...
%                                 studyFolder '/subjects/WMH_spreadsheet.txt'];
% system (cmd_merge_WMHresults_2);

% cmd_merge_WMHresults_3 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh'];
% system (cmd_merge_WMHresults_3);

system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);

% user definable in future
trainingFeatures1 = 1:9;
trainingFeatures2 = 10:12;
            
parfor i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    
    if ismember(ID, excldIDs) == 0
        WMHextraction_kNNdiscovery_Step2 (str2num(k), ...
                                              ID, ...
                                              CNSP_path, ...
                                              studyFolder, ...
                                              classifier, ...
                                              DARTELtemplate, ...
                                              ageRange, ...
                                              str2num(probThr), ...
                                              trainingFeatures1, ...
                                              trainingFeatures2, ...
                                              'noGenF', ... % no need to generate feature again
                                              'NSMethod',NSMethod, ...
                                              'Distance',Distance, ...
                                              'Standardize',Standardize ...
                                              );
        cmd_kNN_step3_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh ' ...
                                                                                            ID ' ' ...
                                                                                            studyFolder '/subjects ' ...
                                                                                            CNSP_path '/WMH_extraction ' ...
                                                                                            PVmag ' ' ...
                                                                                            probThr];
                                                                                        
        % cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ...
                                                                                            % ID ' ' ...
                                                                                            % studyFolder '/subjects'];
             
        system (cmd_kNN_step3_2);
        % system (cmd_merge_WMHresults_4);
    end
end



for i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    
    if ismember(ID, excldIDs) == 0
        cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ...
                                                                                            ID ' ' ...
                                                                                            studyFolder '/subjects'];
        system (cmd_merge_WMHresults_4);
    end
end






WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, outputFormat);

% backup the re-extracted WMH
% Note: studyFolder/subjects is now with new PVmag
% copyfile ([studyFolder '/subjects'],[studyFolder '/subjects_' ageRange '_k' k '_' classifier '_PV' PVmag '_' NSMethod '_' Distance]);

outputTxt{end+1} = 'Done';
set(handles.progressOutput,'String',outputTxt);
drawnow;



% --------------------------------------------------------------------
function diffProbThrRun_menu_Callback(hObject, eventdata, handles)
% hObject    handle to diffProbThrRun_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic;

SPMpath = get(handles.SPMDir_Edit,'String');
studyFolder = get(handles.StudyDir_Edit, 'String');
setappdata (0, 'studyFolder', studyFolder);
CNSP_path = getappdata(0,'CNSP_path');
coregExcldList = get(handles.coregQC_edit,'String');
segExcldList = get(handles.segQC_edit,'String');
excldIDs = strsplit([coregExcldList ' ' segExcldList], ' ');
DARTELtemplate123 = get (handles.DARTELtemplate_popupmenu, 'Value');
switch DARTELtemplate123
    case 1
        prevAgeRange = '65to75';  
        prevDARTELtemplate = 'existing template';
    case 2
        prevAgeRange = '70to80';
        prevDARTELtemplate = 'existing template';
    case 3
        prevAgeRange = 'NA';
        prevDARTELtemplate = 'creating template';
end
prevk = get(handles.k_edit,'String');
classifier_popup = get(handles.kNNclassifier_popupmenu,'Value');
switch classifier_popup
    case 1
        prevclassifier = 'built-in';
    case 2
        prevclassifier = 'custmosed';
end
prevProbThr = get (handles.probThr_edit, 'String');
prevPVmag = get(handles.PVWMH_Edit, 'String');

setappdata(0,'PVmag', prevPVmag);


if isempty(getappdata(0,'PVmag'))
    PVmag = prevPVmag;
else
    PVmag = getappdata(0,'PVmag');
end

if isempty (getappdata (0, 'probThr'))
    probThr = prevProbThr;
else
    probThr = getappdata (0, 'probThr');
end

if isempty(getappdata(0,'classifier'))
    classifier = prevclassifier;
else
    classifier = getappdata(0,'classifier');
end

if isempty(getappdata(0,'k'))
    k = prevk;
else
    k = getappdata(0,'k');
end

if isempty(getappdata(0,'DARtem'))
    DARTELtemplate = prevDARTELtemplate;
else
    DARTELtemplate = getappdata(0,'DARtem');
end

if isempty(getappdata(0,'ageRange'))
    ageRange = prevAgeRange;
else
    ageRange = getappdata(0,'ageRange');
end

outputTxt{1} = '---=== Re-extract with a different probability threshold ===---';
outputTxt{end+1} = '';
outputTxt{end+1} = ['current DARTEL template = ' DARTELtemplate];
outputTxt{end+1} = ['current age range = ' ageRange];
outputTxt{end+1} = ['current k = ' k];
outputTxt{end+1} = ['current classifier = ' classifier];
outputTxt{end+1} = ['current probability threshold = ' probThr];
outputTxt{end+1} = ['current PVWMH magnitude = ' PVmag];
outputTxt{end+1} = '';
outputTxt{end+1} = 'Please wait ...';
set(handles.progressOutput,'String',outputTxt);
drawnow;
% 
% % enable loop through all subjects
% % T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
% % FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
% % [Nsubj,n] = size (T1folder);
% 
% 
if exist ([studyFolder '/subjects'],'dir') ~= 7
    outputTxt{end+1} = 'Error: it seems you have not processed the data with WMH extraction pipeline.';
    set (handles.progressOutput,'String',outputTxt);
    drawnow;
    error('it seems you have not processed the data with WMH extraction pipeline');
end

% input new probability threshold
waitfor(reExtractWithNewProbThr);


% retrieve any newly set parameters
if isempty(getappdata(0,'PVmag'))
    PVmag = prevPVmag;
else
    PVmag = getappdata(0,'PVmag');
end

if isempty (getappdata (0, 'probThr'))
    probThr = prevProbThr;
else
    probThr = getappdata (0, 'probThr');
end
probThr = sprintf ('%1.2f',str2num(probThr));

if get (handles.disp_radiobutton, 'Value')
    prevOutputFormat = 'web';
elseif get (handles.download_radiobutton, 'Value')
    prevOutputFormat = 'arch';
elseif get (handles.both_radiobutton, 'Value')
    prevOutputFormat = 'web&arch';
end

if ~isempty (getappdata (0, 'outputFormat'))
    outputFormat = getappdata (0, 'outputFormat');
elseif ~isempth (prevOutputFormat)
    outputFormat = prevOutputFormat;
else
    error ('Please specify how you would like to view the results.');
end

% if isempty(getappdata(0,'classifier'))
%     classifier = prevclassifier;
% else
%     classifier = getappdata(0,'classifier');
% end
% 
% if isempty(getappdata(0,'k'))
%     k = prevk;
% else
%     k = getappdata(0,'k');
% end
% 
% if isempty(getappdata(0,'DARtem'))
%     DARTELtemplate = prevDARTELtemplate;
% else
%     DARTELtemplate = getappdata(0,'DARtem');
% end
% 
% if isempty(getappdata(0,'ageRange'))
%     ageRange = prevAgeRange;
% else
%     ageRange = getappdata(0,'ageRange');
% end

outputTxt{1} = '';
outputTxt{end+1} = ['new probability threshold = ' probThr];
outputTxt{end+1} = ['new PVWMH magnitude = ' PVmag];
outputTxt{end+1} = '';
outputTxt{end+1} = 'Re-extracting ...';
set(handles.progressOutput,'String',outputTxt);
drawnow;

% enable loop through all subjects
T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
[Nsubj,n] = size (T1folder);


% Re-extract

% cmd_rethr_chmod = ['chmod +x ' CNSP_path '/WMH_extraction/rext_probThr/rethresholdProbMap.sh'];
% system(cmd_rethr_chmod);
% 
% cmd_rethr2_chmod = ['chmod +x ' CNSP_path '/WMH_extraction/rext_probThr/rethresholdProbMap2.sh'];
% system (cmd_rethr2_chmod);

system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);

% cmd_merge_WMHresults_1 = ['if [ -f ' studyFolder '/subjects/WMH_spreadsheet.txt ];then rm -f ' studyFolder '/subjects/WMH_spreadsheet.txt;fi'];
% system (cmd_merge_WMHresults_1);

% cmd_merge_WMHresults_2 = ['echo "ID,wholeBrainWMHvol_mm3,PVWMHvol_mm3,DWMHvol_mm3,Lfrontal_WMHvol_mm3,Rfrontal_WMHvol_mm3,Ltemporal_WMHvol_mm3,Rtemporal_WMHvol_mm3,Lparietal_WMHvol_mm3,Rparietal_WMHvol_mm3,Loccipital_WMHvol_mm3,Roccipital_WMHvol_mm3,Lcerebellum_WMHvol_mm3,Rcerebellum_WMHvol_mm3,Brainstem_WMHvol_mm3" >> ' ...
%                                 studyFolder '/subjects/WMH_spreadsheet.txt'];
% system (cmd_merge_WMHresults_2);

% cmd_merge_WMHresults_3 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh'];
% system (cmd_merge_WMHresults_3);


% --- user definable in future
% trainingFeatures1 = 1:9;
% trainingFeatures2 = 10:12;

system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);


parfor i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    
    if ismember(ID, excldIDs) == 0
%         WMHextraction_kNNdiscovery_Step2 (str2num(k), ...
%                                               ID, ...
%                                               CNSP_path, ...
%                                               studyFolder, ...
%                                               classifier, ...
%                                               DARTELtemplate, ...
%                                               ageRange, ...
%                                               str2num(probThr), ...
%                                               trainingFeatures1, ...
%                                               trainingFeatures2, ...
%                                               'noGenF'); % no need to generate feature again


        % re-threshold probability
        
        cmd_rethr = [CNSP_path '/WMH_extraction/rext_probThr/rethresholdProbMap.sh ' ...
                                                                        ID ' ' ...
                                                                        studyFolder ' ' ...
                                                                        probThr];
        
        
        cmd_rethr2 = [CNSP_path '/WMH_extraction/rext_probThr/reSeg_reCal.sh ' ...
                                                                                ID ' ' ...
                                                                                studyFolder '/subjects ' ...
                                                                                PVmag ' ' ...
                                                                                ];
                                                                                        

        system (cmd_rethr);     
        system (cmd_rethr2);
    end
end

for i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    
    if ismember(ID, excldIDs) == 0
        cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ...
                                                                                            ID ' ' ...
                                                                                            studyFolder '/subjects'];
        system (cmd_merge_WMHresults_4);
    end
end





WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, outputFormat);

% backup the re-extracted WMH
% Note: studyFolder/subjects is now with new PVmag
% copyfile ([studyFolder '/subjects'],[studyFolder '/subjects_' ageRange '_k' k '_' classifier '_PV' PVmag]);

switch outputFormat
    case 'web'
        % display on screen
    case 'arch'
        outputTxt {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_final/QC_final.zip'];
    case 'web&arch'
        outputTxt {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_final/QC_final.zip'];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bring back to native space %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('UBO Detector: Bringing DARTEL space WMH mask to native space ...');

parfor i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID
    
    if ismember(ID, excldIDs) == 0
        switch DARTELtemplate
        case 'existing template'
            WMHresultsBack2NativeSpace (studyFolder, ID, SPMpath);
        case 'creating template'
            WMHresultsBack2NativeSpace (studyFolder, ID, SPMpath, '', 'creating template');
        end
    end
end

% webpage display
% [~, NexcldIDs] = size (excldIDs);
% indFLAIR_cellArr = cell ((Nsubj - NexcldIDs), 1);
% indWMH_FLAIRspace_cellArr = cell ((Nsubj - NexcldIDs), 1);
indFLAIR_cellArr = cell (Nsubj, 1);
indWMH_FLAIRspace_cellArr = cell (Nsubj, 1);

for i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID
    
    if ismember (ID, excldIDs) == 0
        indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
        
        indWMH_FLAIRspace_cellArr{i,1} = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii.gz'];
        
    else % if ID is excluded, display the FLAIR image twice
        indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
        
        indWMH_FLAIRspace_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
    end
end

if exist ([studyFolder '/subjects/QC/QC_final_native'], 'dir') ~= 7
    mkdir ([studyFolder '/subjects/QC'], 'QC_final_native');
end

CNSP_webViewSlices_overlay (indFLAIR_cellArr, ...
                            indWMH_FLAIRspace_cellArr, ...
                            [studyFolder '/subjects/QC/QC_final_native'], ...
                            'QC_final_native', ...
                            'web');


%%%%%%%%%%%%%%%%%%%%%%
%% "finish" message %%
%%%%%%%%%%%%%%%%%%%%%%

outputTxt{end+1} = 'Finished !';
set(handles.progressOutput,'String',outputTxt);
drawnow; 

total_time = toc/3600; % in hrs
fprintf ('');
fprintf ('%.2f hours elapsed to finish the whole extraction procedure.\n', total_time);
fprintf ('');


outputTxt {end+1} = [num2str(total_time) ' hrs eclapsed to finish.'];
set(handles.progressOutput,'String',outputTxt);
drawnow;




% --------------------------------------------------------------------
function diffPVmagRun_menu_Callback(hObject, eventdata, handles)
% hObject    handle to diffPVmagRun_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% outputTxt = get(handles.progressOutput,'String');
outputTxt{1} = '';
outputTxt{end+1} = '---=== Re-extract with a different PVWMH magnitude ===---';
outputTxt{end+1} = '';
set (handles.progressOutput,'String',outputTxt);
drawnow;

fprintf ('CNSP: WMH extraction - Re-extract with a different PVWMH magnitude ...\n');

% retrieve parameters
studyFolder = get(handles.StudyDir_Edit, 'String');
setappdata (0, 'studyFolder', studyFolder);
CNSP_path = getappdata(0,'CNSP_path');
coregExcldList = get(handles.coregQC_edit,'String');
segExcldList = get(handles.segQC_edit,'String');
excldIDs = strsplit([coregExcldList ' ' segExcldList], ' ');
DARTELtemplate123 = get (handles.DARTELtemplate_popupmenu, 'Value');
switch DARTELtemplate123
    case 1
        prevDARtem = 'existing template';
        prevAgeRange = '65to75';
    case 2
        prevDARtem = 'existing template';
        prevAgeRange = '70to80';
    case 3
        prevDARtem = 'creating template';
        prevAgeRange = 'NA';
end
prevk = get(handles.k_edit,'String');
classifier_popup = get(handles.kNNclassifier_popupmenu,'Value');
switch classifier_popup
    case 1
        % prevClassifier = 'BI';
        prevclassifier = 'built-in';
    case 2
        % prevClassifier = 'cust';
        prevclassifier = 'customised';
end
prevProbThr = get(handles.probThr_edit, 'String');
prevPVmag = get(handles.PVWMH_Edit, 'String');

if isempty(getappdata(0,'PVmag'))
    PVmag = prevPVmag;
else
    PVmag = getappdata(0,'PVmag');
end

if isempty (getappdata (0, 'probThr'))
    probThr = prevProbThr;
else
    probThr = getappdata (0, 'probThr');
end

if isempty(getappdata(0,'classifier'))
    classifier = prevclassifier;
else
    classifier = getappdata(0,'classifier');
end

if isempty(getappdata(0,'k'))
    k = prevk;
else
    k = getappdata(0,'k');
end

if isempty(getappdata(0,'DARtem'))
    DARTELtemplate = prevDARtem;
else
    DARTELtemplate = getappdata(0,'DARtem');
end

if isempty(getappdata(0,'ageRange'))
    ageRange = prevAgeRange;
else
    ageRange = getappdata(0,'ageRange');
end

outputTxt{end+1} = '';
outputTxt{end+1} = ['current DARTEL template = ' DARTELtemplate];
outputTxt{end+1} = ['current age range = ' ageRange];
outputTxt{end+1} = ['current k = ' k];
outputTxt{end+1} = ['current classifier = ' classifier];
outputTxt{end+1} = ['current probability threshold = ' probThr];
outputTxt{end+1} = ['current PVWMH magnitude = ' PVmag];
outputTxt{end+1} = '';
outputTxt{end+1} = 'Please wait ...';
set(handles.progressOutput,'String',outputTxt);
drawnow;


% enable loop through all subjects
% T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
% FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
% [Nsubj,n] = size (T1folder);


if exist ([studyFolder '/subjects'],'dir') ~= 7
    outputTxt{end+1} = 'Error: it seems you have not processed the data with WMH extraction pipeline.';
    set (handles.progressOutput,'String',outputTxt);
    drawnow;
    error('it seems you have not processed the data with WMH extraction pipeline');
end

% input new PVWMH magnitude
waitfor(reExtractWithNewPVmag);

% refresh parameters
if isempty(getappdata(0,'PVmag'))
    PVmag = prevPVmag;
else
    PVmag = getappdata(0,'PVmag');
end

% if isempty (getappdata (0, 'probThr'))
%     probThr = prevProbThr;
% else
%     probThr = getappdata (0, 'probThr');
% end
% 
% if isempty(getappdata(0,'classifier'))
%     classifier = prevclassifier;
% else
%     classifier = getappdata(0,'classifier');
% end
% 
% if isempty(getappdata(0,'k'))
%     k = prevk;
% else
%     k = getappdata(0,'k');
% end
% 
% if isempty(getappdata(0,'DARtem'))
%     DARTELtemplate = prevDARtem;
% else
%     DARTELtemplate = getappdata(0,'DARtem');
% end
% 
% if isempty(getappdata(0,'ageRange'))
%     ageRange = prevAgeRange;
% else
%     ageRange = getappdata(0,'ageRange');
% end

outputTxt{end+1} = '';
% outputTxt{end+1} = ['new DARTEL template = ' DARTELtemplate];
% outputTxt{end+1} = ['new age range = ' ageRange];
% outputTxt{end+1} = ['new k = ' k];
% outputTxt{end+1} = ['new classifier = ' classifier];
% outputTxt{end+1} = ['new probability threshold = ' probThr];
outputTxt{end+1} = ['new PVWMH magnitude = ' PVmag];
outputTxt{end+1} = '';
outputTxt{end+1} = 'Re-extracting ...';
set(handles.progressOutput,'String',outputTxt);
drawnow;

% enable loop through all subjects
T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
[Nsubj,n] = size (T1folder);


% Re-extract

% cmd_1 = ['chmod +x ' CNSP_path '/WMH_extraction/rext_PVmag/reSegNewPVmag.sh'];
% system (cmd_1);

% cmd_merge_WMHresults_1 = ['if [ -f ' studyFolder '/subjects/WMH_spreadsheet.txt ];then rm -f ' studyFolder '/subjects/WMH_spreadsheet.txt;fi'];
% system (cmd_merge_WMHresults_1);

% cmd_merge_WMHresults_2 = ['echo "ID,wholeBrainWMHvol_mm3,PVWMHvol_mm3,DWMHvol_mm3,Lfrontal_WMHvol_mm3,Rfrontal_WMHvol_mm3,Ltemporal_WMHvol_mm3,Rtemporal_WMHvol_mm3,Lparietal_WMHvol_mm3,Rparietal_WMHvol_mm3,Loccipital_WMHvol_mm3,Roccipital_WMHvol_mm3,Lcerebellum_WMHvol_mm3,Rcerebellum_WMHvol_mm3,Brainstem_WMHvol_mm3" >> ' ...
%                                 studyFolder '/subjects/WMH_spreadsheet.txt'];
% system (cmd_merge_WMHresults_2);

% cmd_merge_WMHresults_3 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction_kNNdiscovery_Step4.sh'];
% system (cmd_merge_WMHresults_3);

system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);
            
parfor i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    
    if ismember(ID, excldIDs) == 0
        cmd_reSegNewPVmag = [CNSP_path '/WMH_extraction/rext_PVmag/reSegNewPVmag.sh ' ...
                                                                                    ID ' ' ...
                                                                                    studyFolder '/subjects ' ...
                                                                                    CNSP_path '/WMH_extraction ' ...
                                                                                    PVmag ' ' ...
                                                                                    probThr];
                                                                                        
        % cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ...
                                                                                            % ID ' ' ...
                                                                                            % studyFolder '/subjects'];
             
        system (cmd_reSegNewPVmag);
        % system (cmd_merge_WMHresults_4);
    end
end


for i = 1:Nsubj
    T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
    ID = T1imgNames{1};   % first section is ID

    
    if ismember(ID, excldIDs) == 0
        cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ...
                                                                                            ID ' ' ...
                                                                                            studyFolder '/subjects'];
        system (cmd_merge_WMHresults_4);
    end
end
 
% --------------------------------------------------------------------
% function WMHextraction_fc_menu_Callback(hObject, eventdata, handles)
% % hObject    handle to WMHextraction_fc_menu (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% studyFolder = get(handles.StudyDir_Edit,'String');
% spmPath = get(handles.SPMDir_Edit, 'String');
% 
% setappdata(0,'studyFolder',studyFolder);
% setappdata(0,'spmFolder',spmPath);
% 
% WMHextraction_fc_GUI;





% --------------------------------------------------------------------





% -----------------------   View by ID   -----------------------------

function viewWmhByID_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewWmhByID_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = get(handles.StudyDir_Edit,'String');
setappdata(0,'studyFolder',studyFolder);
viewWMHbyID;
% --------------------------------------------------------------------
function viewCoregByID_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewCoregByID_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = get(handles.StudyDir_Edit,'String');
setappdata(0,'studyFolder',studyFolder);
viewCoregByID;

% --------------------------------------------------------------------
function viewSegByID_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewSegByID_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function viewGMbyID_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewGMbyID_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = get(handles.StudyDir_Edit,'String');
setappdata(0,'studyFolder',studyFolder);
viewGMbyID;


% --------------------------------------------------------------------
function viewWMbyID_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewWMbyID_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = get(handles.StudyDir_Edit,'String');
setappdata(0,'studyFolder',studyFolder);
viewWMbyID;

% --------------------------------------------------------------------
function viewCSFbyID_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewCSFbyID_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = get(handles.StudyDir_Edit,'String');
setappdata(0,'studyFolder',studyFolder);
viewCSFbyID;






% ---------------------  View by Study   ---------------------------

function viewWmhByStudy_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewWmhByStudy_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = get(handles.StudyDir_Edit, 'String');
web(['file://' studyFolder '/subjects/QC/QC_final/QC_final.html'],'-new')

% --------------------------------------------------------------------
function viewCoregByStudy_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewCoregByStudy_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = get(handles.StudyDir_Edit, 'String');
web(['file://' studyFolder '/subjects/QC/QC_coreg/QC_coreg.html'],'-new')

% --------------------------------------------------------------------
function viewSegByStudy_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewSegByStudy_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
studyFolder = get(handles.StudyDir_Edit, 'String');
web(['file://' studyFolder '/subjects/QC/QC_seg/QC_Segmentation.html'],'-new')





% --------------------------------------------------------------------
function viewID_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewID_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function vewStudy_menu_Callback(hObject, eventdata, handles)
% hObject    handle to vewStudy_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% ---------------------- view kNN feature space ----------------------------------
function viewKNNfeatureSpace_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewKNNfeatureSpace_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'studyFolder',get(handles.StudyDir_Edit,'String'));
viewKNNfeatureSpace;





% --------------------------------------------------------------------
function viewKNNsearch_menu_Callback(hObject, eventdata, handles)
% hObject    handle to viewKNNsearch_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'studyFolder',get(handles.StudyDir_Edit,'String'));
viewKNNsearch;




% ------------------   Manual editing   ----------------------

% --------------------------------------------------------------------
function manEdt_menu_Callback(hObject, eventdata, handles)
% hObject    handle to manEdt_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function manEdtID_menu_Callback(hObject, eventdata, handles)
% hObject    handle to manEdtID_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

studyFolder = get (handles.StudyDir_Edit, 'String');
setappdata (0, 'studyFolder', studyFolder);

if ~isempty (getappdata (0, 'PVmag'))
    PVmag = getappdata (0, 'PVmag');
else
    PVmag = get (handles.PVWMH_Edit, 'String');
end
setappdata (0, 'PVmag', PVmag);

manEdtID_GUI;





















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    
    
%% with QC stops

%% Stage 1

function WMHextraction_main_inGUI_Stage1 (studyFolder, spm12path, progressOutput, outputFormat)

    tic;
    addpath (spm12path);
    
    CNSP_path = getappdata(0,'CNSP_path');
   
    progressOutputCellArray_Stage1 {:} = ''; % reset output
    progressOutputCellArray_Stage1 {1} = '*******************************************';
    progressOutputCellArray_Stage1 {end+1} = '        WMH extraction pipeline        ';
    progressOutputCellArray_Stage1 {end+1} = '*******************************************';
    progressOutputCellArray_Stage1 {end+1} = '           Neuroimaging Lab            ';
    progressOutputCellArray_Stage1 {end+1} = '   Centre for Healthy Brain Ageing   ';
    progressOutputCellArray_Stage1 {end+1} = '*******************************************';
    progressOutputCellArray_Stage1 {end+1} = '';
    
    set (progressOutput, 'String', progressOutputCellArray_Stage1);
    drawnow;
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    %% Organising folders %%
    %%%%%%%%%%%%%%%%%%%%%%%%

    progressOutputCellArray_Stage1 {end+1} = 'Organising folders ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage1);
    drawnow;

    % create originalImg folder, and move T1 and FLAIR to originalImg
    mkdir (studyFolder, 'originalImg');
    movefile (strcat (studyFolder,'/T1'), strcat (studyFolder,'/originalImg'), 'f'); % move T1 folder to originalImg folder
    movefile (strcat (studyFolder,'/FLAIR'), strcat (studyFolder,'/originalImg'), 'f'); % move FLAIR folder to originalImg folder
   
    % create subjects folder, 
    mkdir (studyFolder, 'subjects');
    
    % gunzip niftis
%     cmd_gunzip_T1 = ['gunzip ' studyFolder '/originalImg/T1/*'];
%     cmd_gunzip_FLAIR = ['gunzip ' studyFolder '/originalImg/FLAIR/*'];
%     system (cmd_gunzip_T1);
%     system (cmd_gunzip_FLAIR);


    % list all T1 and FLAIR (may be .nii.gz)
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii*'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii*'));
    [Nsubj,n] = size (T1folder);
    
    % gunzip niftis
    parfor i = 1:Nsubj
        CNSP_gunzipnii ([studyFolder '/originalImg/T1/' T1folder(i).name]);
        CNSP_gunzipnii ([studyFolder '/originalImg/FLAIR/' FLAIRfolder(i).name]);
    end



    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
    [Nsubj,n] = size (T1folder);


    % create a folder for each subject under subjects
    % folder, using ID as folder name. Copy corresponding T1 and FLAIR to the
    % orig folder of each subject
    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        mkdir (strcat(studyFolder,'/subjects/',ID,'/mri'),'orig');  % create orig folder under each subject folder
        copyfile (strcat (studyFolder,'/originalImg/T1/', T1folder(i).name), strcat(studyFolder,'/subjects/',ID,'/mri/orig/'));        % copy T1 to each subject folder
        copyfile (strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name), strcat(studyFolder,'/subjects/',ID,'/mri/orig/'));  % copy FLAIR to each subject folder
    end



    %%%%%%%%%%%%%%%%%%%
    %% Run SPM steps %%
    %%%%%%%%%%%%%%%%%%%

    progressOutputCellArray_Stage1 {end+1} = 'Running SPM steps ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage1);
    drawnow;
    
    progressOutputCellArray_Stage1 {end+1} = 'Step 1: T1 & FLAIR coregistration ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage1);
    drawnow;
    WMHextraction_preprocessing_Step1 (studyFolder);
    
    progressOutputCellArray_Stage1 {end+1} = 'Generating coregistration QC images ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage1);
    drawnow;   
    WMHextraction_QC_1 (studyFolder, outputFormat); % coregistration QC
    
    switch outputFormat
        case 'web'
            % display on screen
        case 'arch'
            progressOutputCellArray_Stage1 {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_coreg/QC_coregistration.zip'];
        case 'web&arch'
            progressOutputCellArray_Stage1 {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_coreg/QC_coregistration.zip'];
    end
    
    progressOutputCellArray_Stage1 {end+1} = 'Please type in the IDs did not pass coregistration QC below ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage1);
    drawnow;
    
    stage1_time = toc/60; % in min
    fprintf ('');
    fprintf ('%.2f minutes elapsed so far.\n', stage1_time);
    fprintf ('');
    
    progressOutputCellArray_Stage1 {end+1} = [num2str(stage1_time) ' mins eclapsed so far.'];
    set (progressOutput, 'String', progressOutputCellArray_Stage1);
    drawnow;
    

    
%% Stage 2
    
 function WMHextraction_main_inGUI_Stage2 (studyFolder, spm12path, progressOutput, coregExcldList, outputFormat)
     
    addpath (spm12path);
    CNSP_path = getappdata(0,'CNSP_path');
    
    progressOutputCellArray_Stage2 = get (progressOutput, 'String');
    
    progressOutputCellArray_Stage2 {end+1} = 'Step 2: T1 segmentation ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage2);
    drawnow;
    WMHextraction_preprocessing_Step2 (studyFolder, spm12path, coregExcldList);
    
    progressOutputCellArray_Stage2 {end+1} = 'Generating segmentation QC images ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage2);
    drawnow;
    WMHextraction_QC_2 (studyFolder, coregExcldList, outputFormat); % segmentation QC
    
    switch outputFormat
        case 'web'
            % display on screen
        case 'arch'
            progressOutputCellArray_Stage2 {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_seg/QC_segmentation.zip'];
        case 'web&arch'
            progressOutputCellArray_Stage2 {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_seg/QC_segmentation.zip'];
    end
    
    progressOutputCellArray_Stage2 {end+1} = 'Please type in the IDs did not pass segmentation QC below ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage2);
    drawnow;
    
    stage2_time = toc/60; % in min
    fprintf ('');
    fprintf ('%.2f minutes elapsed so far.\n', stage2_time);
    fprintf ('');
    
    progressOutputCellArray_Stage2 {end+1} = [num2str(stage2_time) ' mins eclapsed so far.'];
    set (progressOutput, 'String', progressOutputCellArray_Stage2);
    drawnow;


%% Stage 3

function WMHextraction_main_inGUI_Stage3 (studyFolder, ...
                                            spm12path, ...
                                            dartelTemplate, ...
                                            k, ...
                                            PVWMH_magnitude, ...
                                            progressOutput, ...
                                            coregExcldList, ...
                                            segExcldList, ...
                                            classifier, ...
                                            ageRange, ...
                                            probThr, ...
                                            trainingFeatures1, ...
                                            trainingFeatures2, ...
                                            outputFormat ...
                                            )

    tic;
    
    addpath (spm12path);
    CNSP_path = getappdata (0,'CNSP_path');

    excldList = [coregExcldList ' ' segExcldList];
    excldIDs = strsplit (excldList, ' ');
    
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
    [Nsubj,n] = size (T1folder);
    
    
    progressOutputCellArray_Stage3 = get (progressOutput, 'String');
    progressOutputCellArray_Stage3 {end+1} = 'Step 3: Running DARTEL ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage3);
    drawnow;
    WMHextraction_preprocessing_Step3 (studyFolder, ...
                                        CNSP_path, ...
                                        dartelTemplate, ...
                                        coregExcldList, ...
                                        segExcldList, ...
                                        ageRange...
                                        );  % dartelTemplate specifies which set of templates to be used.

    progressOutputCellArray_Stage3 {end+1} = 'Step 4: Bring T1, FLAIR, as well as GM, WM and CSF segmentations to DARTEL ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage3);
    drawnow;
    WMHextraction_preprocessing_Step4 (studyFolder, dartelTemplate, coregExcldList, segExcldList, CNSP_path);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% non-brain tissue removal & FSL FAST %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    progressOutputCellArray_Stage3 {end+1} = 'Running non-brain tissue removal, and FSL FAST ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage3);
    drawnow;
    
%     cmd_skullStriping_FAST_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_SkullStriping_and_FAST.sh'];
%     system (cmd_skullStriping_FAST_1);


    
    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0

            cmd_skullStriping_FAST_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_SkullStriping_and_FAST.sh ' ...
                                                                                                            T1folder(i).name ' ' ...
                                                                                                            FLAIRfolder(i).name ' ' ...
                                                                                                            studyFolder '/subjects ' ...
                                                                                                            ID ' ' ...
                                                                                                            CNSP_path ' ' ...
                                                                                                            strrep(dartelTemplate, ' ', '_') ' ' ...
                                                                                                            ageRange];
            system (cmd_skullStriping_FAST_2);
        end

    end




    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kNN WMH discovery Step 1: Preprocessing %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    progressOutputCellArray_Stage3 {end+1} = 'Preprocessing for kNN ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage3);
    drawnow;
    
%     cmd_kNN_step1_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step1.sh'];
%     system (cmd_kNN_step1_1);


    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            cmd_kNN_step1_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step1.sh ' ID ' ' ...
                                                                                                studyFolder '/subjects ' ...
                                                                                                CNSP_path ' ' ...
                                                                                                strrep(dartelTemplate, ' ', '_') ' ' ...
                                                                                                ageRange];
            system (cmd_kNN_step1_2);
        end
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kNN WMH discovery Step 2: kNN calculation %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    progressOutputCellArray_Stage3 {end+1} = 'kNN calculation ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage3);
    drawnow;
    
    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        
        if ismember(ID, excldIDs) == 0
            WMHextraction_kNNdiscovery_Step2 (k, ...
                                              ID, ...
                                              CNSP_path, ...
                                              studyFolder, ...
                                              classifier, ...
                                              dartelTemplate, ...
                                              ageRange, ...
                                              probThr, ...
                                              trainingFeatures1, ...
                                              trainingFeatures2 ...
                                              );
        end
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kNN WMH discovery Step 3: Postprocessing and cleanup %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    probThr_str = num2str (probThr, '%1.2f');
    progressOutputCellArray_Stage3 {end+1} = 'Generating image and text output, and cleanup ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage3);
    drawnow;
    
%     cmd_kNN_step3_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh'];
%     system (cmd_kNN_step3_1);

    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            cmd_kNN_step3_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh ' ...
                                                                                                ID ' ' ...
                                                                                                studyFolder '/subjects ' ...
                                                                                                CNSP_path '/WMH_extraction ' ...
                                                                                                PVWMH_magnitude ' ' ...
                                                                                                probThr_str ...
                                                                                                ];
            system (cmd_kNN_step3_2);
        end
    end


    % merge WMH results into one spreadsheet.
    % cmd_merge_WMHresults_1 = ['if [ -f ' studyFolder '/subjects/WMH_spreadsheet.txt ];then rm -f ' studyFolder '/subjects/WMH_spreadsheet.txt;fi'];
    % system (cmd_merge_WMHresults_1);

    % cmd_merge_WMHresults_2 = ['echo "ID,wholeBrainWMHvol_mm3,PVWMHvol_mm3,DWMHvol_mm3,Lfrontal_WMHvol_mm3,Rfrontal_WMHvol_mm3,Ltemporal_WMHvol_mm3,Rtemporal_WMHvol_mm3,Lparietal_WMHvol_mm3,Rparietal_WMHvol_mm3,Loccipital_WMHvol_mm3,Roccipital_WMHvol_mm3,Lcerebellum_WMHvol_mm3,Rcerebellum_WMHvol_mm3,Brainstem_WMHvol_mm3" >> ' ...
    %                                 studyFolder '/subjects/WMH_spreadsheet.txt'];
    % system (cmd_merge_WMHresults_2);

%     cmd_merge_WMHresults_3 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh'];
%     system (cmd_merge_WMHresults_3);


    system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);


    for i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ID ' ' studyFolder '/subjects'];
            system (cmd_merge_WMHresults_4);
        end
    end                                



    %%%%%%%%%%%%%%%%%%%%%%%%
    %% QC_3: final output %%
    %%%%%%%%%%%%%%%%%%%%%%%%


    progressOutputCellArray_Stage3 {end+1} = 'Generating images for quality assurance of the final output ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage3);
    drawnow;
    
    WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, outputFormat);
    
    switch outputFormat
        case 'web'
            % display on screen
        case 'arch'
            progressOutputCellArray_Stage3 {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_final/QC_final.zip'];
        case 'web&arch'
            progressOutputCellArray_Stage3 {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_final/QC_final.zip'];
    end




    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Bring back to native space %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray_Stage3 {end+1} = 'Bringing DARTEL space WMH mask to native space ...';
    set (progressOutput, 'String', progressOutputCellArray_Stage3);
    drawnow;

    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        
        if ismember(ID, excldIDs) == 0

            switch dartelTemplate
            case 'existing template'
                WMHresultsBack2NativeSpace (studyFolder, ID, spm12path);
            case 'creating template'
                WMHresultsBack2NativeSpace (studyFolder, ID, spm12path, '', 'creating template');
            end

        end
    end

    % webpage display
    % [~, NexcldIDs] = size (excldIDs);
    % indFLAIR_cellArr = cell ((Nsubj - NexcldIDs), 1);
    % indWMH_FLAIRspace_cellArr = cell ((Nsubj - NexcldIDs), 1);
    indFLAIR_cellArr = cell (Nsubj, 1);
    indWMH_FLAIRspace_cellArr = cell (Nsubj, 1);

    for i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        
        if ismember (ID, excldIDs) == 0
            indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
            
            indWMH_FLAIRspace_cellArr{i,1} = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii.gz'];
            
        else % if ID is excluded, display the FLAIR image twice
            indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
            
            indWMH_FLAIRspace_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
        end
    end

    if exist ([studyFolder '/subjects/QC/QC_final_native'], 'dir') ~= 7
        mkdir ([studyFolder '/subjects/QC'], 'QC_final_native');
    end

    CNSP_webViewSlices_overlay (indFLAIR_cellArr, ...
                                indWMH_FLAIRspace_cellArr, ...
                                [studyFolder '/subjects/QC/QC_final_native'], ...
                                'QC_final_native', ...
                                'web');





    %%%%%%%%%%%%%%%%%%%%%%
    %% "finish" message %%
    %%%%%%%%%%%%%%%%%%%%%%

    progressOutputCellArray_Stage3 {end+1} = '*** FINISHED ! ***';
    set (progressOutput, 'String', progressOutputCellArray_Stage3);
    drawnow;
    
    stage3_time = toc/3600; % in hrs
    fprintf ('');
    fprintf ('%.2f hours elapsed to finish the extraction procedures.\n', stage3_time);
    fprintf ('');
    
    
    progressOutputCellArray_Stage3 {end+1} = [num2str(stage3_time) ' hrs eclapsed to finish.'];
    set (progressOutput, 'String', progressOutputCellArray_Stage3);
    drawnow;
    
    

    
    









    
%% Without QC stops
    
function WMHextraction_main_noQCstops (studyFolder, ...
                                        spm12path, ...
                                        dartelTemplate, ...
                                        k, ...
                                        PVWMH_magnitude, ...
                                        coregExcldList, ...
                                        segExcldList, ...
                                        progressOutput, ...
                                        classifier, ...
                                        ageRange, ...
                                        probThr, ...
                                        trainingFeatures1, ...
                                        trainingFeatures2, ...
                                        outputFormat ...
                                        )


    tic;
    
    addpath (spm12path);
    CNSP_path = getappdata (0,'CNSP_path');
    
    progressOutputCellArray {:} = ''; % reset output
    progressOutputCellArray {1} = '*******************************************';
    progressOutputCellArray {end+1} = '        WMH extraction pipeline        ';
    progressOutputCellArray {end+1} = '             No QC stops               ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '           Neuroimaging Lab            ';
    progressOutputCellArray {end+1} = '   Centre for Healthy Brain Ageing   ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '';   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    excldList = [coregExcldList ' ' segExcldList];
    excldIDs = strsplit (excldList, ' ');
 
    %%%%%%%%%%%%%%%%%%%%%%%%
    %% Organising folders %%
    %%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Organising folders ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    % create originalImg folder, and move T1 and FLAIR to originalImg
    mkdir (studyFolder, 'originalImg');
    movefile (strcat (studyFolder,'/T1'), strcat (studyFolder,'/originalImg'), 'f'); % move T1 folder to originalImg folder
    movefile (strcat (studyFolder,'/FLAIR'), strcat (studyFolder,'/originalImg'), 'f'); % move FLAIR folder to originalImg folder

    % create subjects folder, 
    mkdir (studyFolder, 'subjects');
    
    % list all T1 and FLAIR (may be .nii.gz)
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii*'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii*'));
    [Nsubj,n] = size (T1folder);
    
    % gunzip niftis
    parfor i = 1:Nsubj
        CNSP_gunzipnii ([studyFolder '/originalImg/T1/' T1folder(i).name]);
        CNSP_gunzipnii ([studyFolder '/originalImg/FLAIR/' FLAIRfolder(i).name]);
    end

    % re-list all T1 and FLAIR (all .nii)
    T1folder = dir (strcat (studyFolder,'/originalImg/T1/*.nii'));
    FLAIRfolder = dir (strcat (studyFolder,'/originalImg/FLAIR/*.nii'));
    [Nsubj,n] = size (T1folder);
    
    % create a folder for each subject under subjects
    % folder, using ID as folder name. Copy corresponding T1 and FLAIR to the
    % orig folder of each subject
    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        mkdir (strcat(studyFolder,'/subjects/',ID,'/mri'),'orig');  % create orig folder under each subject folder
        copyfile (strcat (studyFolder,'/originalImg/T1/', T1folder(i).name), strcat(studyFolder,'/subjects/',ID,'/mri/orig/'));        % copy T1 to each subject folder
        copyfile (strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name), strcat(studyFolder,'/subjects/',ID,'/mri/orig/'));  % copy FLAIR to each subject folder
    end



    %%%%%%%%%%%%%%%%%%%
    %% Run SPM steps %%
    %%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Running SPM steps ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    progressOutputCellArray {end+1} = 'Step 1: T1 & FLAIR coregistration ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    WMHextraction_preprocessing_Step1 (studyFolder); % Step 1: coregistration
    
    progressOutputCellArray {end+1} = 'Generating coregistration QC images ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow; 
    WMHextraction_QC_1 (studyFolder, outputFormat); % coregistration QC
    
    switch outputFormat
        case 'web'
            % display on screen
        case 'arch'
            progressOutputCellArray {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_coreg/QC_coregistration.zip'];
        case 'web&arch'
            progressOutputCellArray {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_coreg/QC_coregistration.zip'];
    end

    progressOutputCellArray {end+1} = 'Step 2: T1 segmentation ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    WMHextraction_preprocessing_Step2 (studyFolder, spm12path, coregExcldList); % Step 2: segmentation
    
    progressOutputCellArray {end+1} = 'Generating segmentation QC images ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    WMHextraction_QC_2 (studyFolder, coregExcldList, outputFormat); % segmentation QC
    
    switch outputFormat
        case 'web'
            % display on screen
        case 'arch'
            progressOutputCellArray {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_seg/QC_segmentation.zip'];
        case 'web&arch'
            progressOutputCellArray {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_seg/QC_segmentation.zip'];
    end
   
    progressOutputCellArray {end+1} = 'Step 3: Running DARTEL ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    WMHextraction_preprocessing_Step3 (studyFolder, ...
                                        CNSP_path, ...
                                        dartelTemplate, ...
                                        coregExcldList, ...
                                        segExcldList, ...
                                        ageRange...
                                        );  % dartelTemplate specifies which set of templates to be used.
    progressOutputCellArray {end+1} = 'Step 4: Bring T1, FLAIR, as well as GM, WM and CSF segmentations to DARTEL ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    WMHextraction_preprocessing_Step4 (studyFolder, dartelTemplate, coregExcldList, segExcldList, CNSP_path); % Step 4: bring to DARTEL

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% non-brain tissue removal & FSL FAST %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Running non-brain tissue removal, and FSL FAST ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
%     cmd_skullStriping_FAST_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_SkullStriping_and_FAST.sh'];
%     system (cmd_skullStriping_FAST_1);
    
    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0

            cmd_skullStriping_FAST_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_SkullStriping_and_FAST.sh ' ...
                                                                                                                            T1folder(i).name ' ' ...
                                                                                                                            FLAIRfolder(i).name ' ' ...
                                                                                                                            studyFolder '/subjects ' ...
                                                                                                                            ID ' ' ...
                                                                                                                            CNSP_path ' ' ...
                                                                                                                            strrep(dartelTemplate, ' ', '_') ' ' ...
                                                                                                                            ageRange];
            system (cmd_skullStriping_FAST_2);
        end

    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kNN WMH discovery Step 1: Preprocessing %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Preprocessing for kNN ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
 
%     cmd_kNN_step1_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step1.sh'];
%     system (cmd_kNN_step1_1);


    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            cmd_kNN_step1_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step1.sh ' ...
                                                                                                            ID ' ' ...
                                                                                                            studyFolder '/subjects ' ...
                                                                                                            CNSP_path ' ' ...
                                                                                                            strrep(dartelTemplate, ' ', '_') ' ' ...
                                                                                                            ageRange];
            system (cmd_kNN_step1_2);
        end
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kNN WMH discovery Step 2: kNN calculation %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'kNN calculation ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        
        if ismember(ID, excldIDs) == 0
            WMHextraction_kNNdiscovery_Step2 (k, ...
                                              ID, ...
                                              CNSP_path, ...
                                              studyFolder, ...
                                              classifier, ...
                                              dartelTemplate, ...
                                              ageRange, ...
                                              probThr, ...
                                              trainingFeatures1, ...
                                              trainingFeatures2 ...
                                              );
        end
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kNN WMH discovery Step 3: Postprocessing and cleanup %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Generating image and text output, and cleanup ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    probThr_str = num2str (probThr, '%1.2f');
    
%     cmd_kNN_step3_1 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh'];
%     system (cmd_kNN_step3_1);

    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            cmd_kNN_step3_2 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step3.sh ' ...
                                                                                                                ID ' ' ...
                                                                                                                studyFolder '/subjects ' ...
                                                                                                                CNSP_path '/WMH_extraction ' ...
                                                                                                                PVWMH_magnitude ' ' ...
                                                                                                                probThr_str ...
                                                                                                                ];
            system (cmd_kNN_step3_2);
        end
    end

    % merge WMH results into one spreadsheet.
    % cmd_merge_WMHresults_1 = ['if [ -f ' studyFolder '/subjects/WMH_spreadsheet.txt ];then rm -f ' studyFolder '/subjects/WMH_spreadsheet.txt;fi'];
    % system (cmd_merge_WMHresults_1);

    % cmd_merge_WMHresults_2 = ['echo "ID,wholeBrainWMHvol_mm3,PVWMHvol_mm3,DWMHvol_mm3,Lfrontal_WMHvol_mm3,Rfrontal_WMHvol_mm3,Ltemporal_WMHvol_mm3,Rtemporal_WMHvol_mm3,Lparietal_WMHvol_mm3,Rparietal_WMHvol_mm3,Loccipital_WMHvol_mm3,Roccipital_WMHvol_mm3,Lcerebellum_WMHvol_mm3,Rcerebellum_WMHvol_mm3,Brainstem_WMHvol_mm3" >> ' ...
    %                                 studyFolder '/subjects/WMH_spreadsheet.txt'];
    % system (cmd_merge_WMHresults_2);

%     cmd_merge_WMHresults_3 = ['chmod +x ' CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh'];
%     system (cmd_merge_WMHresults_3);


    system ([CNSP_path '/WMH_extraction/WMHextraction/WMHspreadsheetTitle.sh ' studyFolder '/subjects']);

    for i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID

        if ismember(ID, excldIDs) == 0
            cmd_merge_WMHresults_4 = [CNSP_path '/WMH_extraction/WMHextraction/WMHextraction_kNNdiscovery_Step4.sh ' ID ' ' studyFolder '/subjects'];
            system (cmd_merge_WMHresults_4);
        end
    end                                



    %%%%%%%%%%%%%%%%%%%%%%%%
    %% QC_3: final output %%
    %%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Generating images for quality assurance of the final output ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    WMHextraction_QC_3 (studyFolder, coregExcldList, segExcldList, outputFormat);
    
    switch outputFormat
        case 'web'
            % display on screen
        case 'arch'
            progressOutputCellArray {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_final/QC_final.zip'];
        case 'web&arch'
            progressOutputCellArray {end+1} = ['Download link: ' studyFolder '/subjects/QC/QC_final/QC_final.zip'];
    end
    


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Bring back to native space %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Bringing DARTEL space WMH mask to native space ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    parfor i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        
        if ismember(ID, excldIDs) == 0
            switch dartelTemplate
            case 'existing template'
                WMHresultsBack2NativeSpace (studyFolder, ID, spm12path);
            case 'creating template'
                WMHresultsBack2NativeSpace (studyFolder, ID, spm12path, '', 'creating template');
            end
        end
    end

    % webpage display
    % [~, NexcldIDs] = size (excldIDs);
    % indFLAIR_cellArr = cell ((Nsubj - NexcldIDs), 1);
    % indWMH_FLAIRspace_cellArr = cell ((Nsubj - NexcldIDs), 1);
    indFLAIR_cellArr = cell (Nsubj, 1);
    indWMH_FLAIRspace_cellArr = cell (Nsubj, 1);

    for i = 1:Nsubj
        T1imgNames = strsplit (T1folder(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = T1imgNames{1};   % first section is ID
        
        if ismember (ID, excldIDs) == 0
            indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
            
            indWMH_FLAIRspace_cellArr{i,1} = [studyFolder '/subjects/' ID '/mri/extractedWMH/' ID '_WMH_FLAIRspace.nii.gz'];
            
        else % if ID is excluded, display the FLAIR image twice
            indFLAIR_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
            
            indWMH_FLAIRspace_cellArr{i,1} = strcat (studyFolder,'/originalImg/FLAIR/', FLAIRfolder(i).name);
        end
    end

    if exist ([studyFolder '/subjects/QC/QC_final_native'], 'dir') ~= 7
        mkdir ([studyFolder '/subjects/QC'], 'QC_final_native');
    end

    CNSP_webViewSlices_overlay (indFLAIR_cellArr, ...
                                indWMH_FLAIRspace_cellArr, ...
                                [studyFolder '/subjects/QC/QC_final_native'], ...
                                'QC_final_native', ...
                                'web');


    %%%%%%%%%%%%%%%%%%%%%%
    %% "finish" message %%
    %%%%%%%%%%%%%%%%%%%%%%

    progressOutputCellArray {end+1} = '*** FINISHED ! ***';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow; 
    
    total_time = toc/3600; % in hrs
    fprintf ('');
    fprintf ('%.2f hours elapsed to finish the whole extraction procedure.\n', total_time);
    fprintf ('');
    
    
    progressOutputCellArray {end+1} = [num2str(total_time) ' hrs eclapsed to finish.'];
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openUDmanual_menu_Callback(hObject, eventdata, handles)
% hObject    handle to openUDmanual_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CNSP_path = fileparts (fileparts (fileparts (mfilename ('fullpath'))));

web ([CNSP_path '/Manual/UBO_Detector_main.html'], '-new');