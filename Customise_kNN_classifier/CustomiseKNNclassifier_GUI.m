function varargout = CustomiseKNNclassifier_GUI(varargin)
% CUSTOMISEKNNCLASSIFIER_GUI MATLAB code for CustomiseKNNclassifier_GUI.fig
%      CUSTOMISEKNNCLASSIFIER_GUI, by itself, creates a new CUSTOMISEKNNCLASSIFIER_GUI or raises the existing
%      singleton*.
%
%      H = CUSTOMISEKNNCLASSIFIER_GUI returns the handle to a new CUSTOMISEKNNCLASSIFIER_GUI or the handle to
%      the existing singleton*.
%
%      CUSTOMISEKNNCLASSIFIER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CUSTOMISEKNNCLASSIFIER_GUI.M with the given input arguments.
%
%      CUSTOMISEKNNCLASSIFIER_GUI('Property','Value',...) creates a new CUSTOMISEKNNCLASSIFIER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CustomiseKNNclassifier_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CustomiseKNNclassifier_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CustomiseKNNclassifier_GUI

% Last Modified by GUIDE v2.5 17-Mar-2017 14:28:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CustomiseKNNclassifier_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CustomiseKNNclassifier_GUI_OutputFcn, ...
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



% --- Executes just before CustomiseKNNclassifier_GUI is made visible.
function CustomiseKNNclassifier_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CustomiseKNNclassifier_GUI (see VARARGIN)

% Choose default command line output for CustomiseKNNclassifier_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% CNSP_path = getappdata (0,'CNSP_path');

% if exist ([CNSP_path '/WMH_extraction/4kNN_classifier/customised_classifier'],'dir') ~= 7
%     mkdir ([CNSP_path '/WMH_extraction/4kNN_classifier/customised_classifier']);
% end



% UIWAIT makes CustomiseKNNclassifier_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = CustomiseKNNclassifier_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function trainingSize_edit_Callback(hObject, eventdata, handles)
% hObject    handle to trainingSize_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trainingSize_edit as text
%        str2double(get(hObject,'String')) returns contents of trainingSize_edit as a double

    rudeTrainTbl_Nrows = str2num(get(handles.trainingSize_edit, 'String'));
    
    defaultData = cell(rudeTrainTbl_Nrows,4);
    for i = 1:rudeTrainTbl_Nrows
        defaultData {i,1} = '';
        defaultData {i,2} = 'Yes';
        defaultData {i,3} = 'No';
        defaultData {i,4} = 'No';
    end
    
    set (handles.rudeTrainTbl, 'Data', defaultData);
    set (handles.rudeTrainTbl,'ColumnEditable',logical([1 1 1 1])); % make all four columns editable


% --- Executes during object creation, after setting all properties.
function trainingSize_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainingSize_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function rudeTrainTbl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rudeTrainTbl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function studyDir_edit_Callback(hObject, eventdata, handles)
% hObject    handle to studyDir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of studyDir_edit as text
%        str2double(get(hObject,'String')) returns contents of studyDir_edit as a double


% --- Executes during object creation, after setting all properties.
function studyDir_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to studyDir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findStudyDirBtn.
function findStudyDirBtn_Callback(hObject, eventdata, handles)
% hObject    handle to findStudyDirBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    studyDir = uigetdir;
    set (handles.studyDir_edit, 'String', studyDir);


% --- Executes on selection change in equalYN_popupmenu.
function equalYN_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to equalYN_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns equalYN_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from equalYN_popupmenu


% --- Executes during object creation, after setting all properties.
function equalYN_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to equalYN_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






%%%%%%%%%%%%%  Rude Training Buttons %%%%%%%%%%%%%%%%%%%%%




% --- Executes on button press in startRudeTrainingBtn_processed.
function startRudeTrainingBtn_processed_Callback(hObject, eventdata, handles)
% hObject    handle to startRudeTrainingBtn_processed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    trainingSize = str2double(get(handles.trainingSize_edit, 'String'));
    studyFolder = get (handles.studyDir_edit, 'String');
    rudeTrainingTbl = get (handles.rudeTrainTbl,'Data');
    CNSP_path = getappdata(0,'CNSP_path');
    
    switch get(handles.equalYN_popupmenu, 'Value')
        case 1
            equalYN = '0';
        case 2
            equalYN = '1';
    end
    
    
    progressOutputCellArray {:} = ''; % reset output
    progressOutputCellArray {1} = '*******************************************';
    progressOutputCellArray {end+1} = '        Customise kNN classifier        ';
    progressOutputCellArray {end+1} = '           With Processed Data          ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '           Neuroimaging Lab            ';
    progressOutputCellArray {end+1} = '   Centre for Healthy Brain Ageing   ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '';
    progressOutputCellArray {end+1} = 'Please wait ...';
    progressOutputCellArray {end+1} = '';
    set (handles.progressOutput_edit, 'String', progressOutputCellArray);
    drawnow;
    
    % whether has been processed
    for p = 1:trainingSize
        if exist ([studyFolder '/subjects/' rudeTrainingTbl{p,1}],'dir') ~= 7
            progressOutputCellArray = get (handles.progressOutput_edit, 'String');
            progressOutputCellArray {end+1} = ['Error: it seems ' rudeTrainingTbl{p,1} ' has not gone through WMH extraction pipeline.' ...
                                                ' Please go through the WMH extraction pipeline first.'];
            set (handles.progressOutput_edit, 'String', progressOutputCellArray);
            drawnow;
            error ([rudeTrainingTbl{p,1} ' not processed !']);
        end
    end
    

    % create studyFolder/customiseClassifier
    trainingStudyFolder = [studyFolder '/customiseClassifier'];
    
    if exist (trainingStudyFolder, 'dir') == 7
        rmdir (trainingStudyFolder, 's');
    end
    
    mkdir (trainingStudyFolder);
    mkdir ([trainingStudyFolder '/T1']);
    mkdir ([trainingStudyFolder '/FLAIR']);
    mkdir ([trainingStudyFolder '/subjects']);
    mkdir ([trainingStudyFolder '/textfiles']);


    % copy training subjects to studyFolder/customiseClassifier for visual inspection                        
    parfor i = 1:trainingSize
        [lsT1_status, T1] = system (['ls ' studyFolder '/originalImg/T1/' rudeTrainingTbl{i,1} '_*']);
        [lsFLAIR_status, FLAIR] = system (['ls ' studyFolder '/originalImg/FLAIR/' rudeTrainingTbl{i,1} '_*']);
        copyfile (T1, [trainingStudyFolder '/T1'], 'f');
        copyfile (FLAIR, [trainingStudyFolder '/FLAIR'], 'f');
        copyfile ([studyFolder '/subjects/' rudeTrainingTbl{i,1}], [trainingStudyFolder '/subjects/' rudeTrainingTbl{i,1}]); % copy subjects/ID folder
    end

    % generate training file
    createTrainingTblFile_processed (trainingSize,...
                            studyFolder,...
                            'equalizeYN',equalYN,...              %%% equale YN is likely to cause false positive of large clusters
                            rudeTrainingTbl,...
                            handles.progressOutput_edit...
                            );
    
 
    
    % pass trainingSize, equalYN,and rudeTrainingTbl to
    % root dir
    setappdata(0,'trainingSize',trainingSize);
    setappdata(0,'equalYN',equalYN);
    setappdata(0,'rudeTrainingTbl',rudeTrainingTbl);
    
    
    IDs = cell (trainingSize,1);
    IDs(:) = {[]}; % reset
    
    for j = 1:trainingSize
        IDs {j,1} = rudeTrainingTbl {j,1};
    end
    set (handles.visualAdj_listbox, 'String', IDs);



    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    

% --- Executes on button press in basedOnRudeTraingSelected_checkbox.
function basedOnRudeTraingSelected_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to basedOnRudeTraingSelected_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of basedOnRudeTraingSelected_checkbox
set(handles.basedOnBuiltinResults_checkbox,'Value',0);


% --- Executes on button press in basedOnBuiltinResults_checkbox.
function basedOnBuiltinResults_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to basedOnBuiltinResults_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of basedOnBuiltinResults_checkbox
set(handles.basedOnRudeTraingSelected_checkbox,'Value',0);
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






 
% --- Executes on button press in goToWMHextraction_btn.
function goToWMHextraction_btn_Callback(hObject, eventdata, handles)
% hObject    handle to goToWMHextraction_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

shareTextfileDialog;
WMHextraction_GUI;
close (CustomiseKNNclassifier_GUI);



% --- Executes on selection change in visualAdj_listbox.
function visualAdj_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to visualAdj_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns visualAdj_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from visualAdj_listbox


% --- Executes during object creation, after setting all properties.
function visualAdj_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to visualAdj_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startVisualAdjustment_btn.
function startVisualAdjustment_btn_Callback(hObject, eventdata, handles)
% hObject    handle to startVisualAdjustment_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    CNSP_path = getappdata(0,'CNSP_path');

    index_selected = get(handles.visualAdj_listbox,'Value');
    ID_list = get(handles.visualAdj_listbox,'String');
    ID_selected = ID_list{index_selected};
    
    studyFolder = get (handles.studyDir_edit, 'String'); 
    rudeTrainingTbl = get (handles.rudeTrainTbl,'Data');
    
    basedOnRudeTraingSelected = get (handles.basedOnRudeTraingSelected_checkbox, 'Value');
    basedOnBuiltinResultsSelected = get (handles.basedOnBuiltinResults_checkbox, 'Value');
    
    rudeTrainingTbl_YesArray = strfind(rudeTrainingTbl,'Yes');
    rudeTrainingTbl_NumYes = sum([rudeTrainingTbl_YesArray{index_selected,:}]);
    rudeTrainingTbl_YesIndArray = find (strcmp({rudeTrainingTbl{index_selected,:}},'Yes'));
   
    
    if (basedOnRudeTraingSelected == 1) && (basedOnBuiltinResultsSelected == 1)
        progressText = get (handles.progressOutput_edit, 'String');
        progressText {end+1} = 'Error: Cannot proceed based on both rude training and built-in classifier results.';
        set (handles.progressOutput_edit, 'String', progressText);
        drawnow; 
    elseif basedOnRudeTraingSelected
        system (['chmod +x ' CNSP_path '/Customise_kNN_classifier/visualAdjustment_1Yes.sh']);
        system (['chmod +x ' CNSP_path '/Customise_kNN_classifier/visualAdjustment_2Yes.sh']);
        if rudeTrainingTbl_NumYes == 1
            cmd_visualAdjBasedOnRudeTraing_1 = [CNSP_path '/Customise_kNN_classifier/visualAdjustment_1Yes.sh ' ...
                                                                                                                studyFolder ' ' ...
                                                                                                                ID_selected ' ' ...
                                                                                                                'rudeTraining ' ...
                                                                                                                num2str(rudeTrainingTbl_YesIndArray(1)-2)];
            system (cmd_visualAdjBasedOnRudeTraing_1);
        elseif rudeTrainingTbl_NumYes == 2
            cmd_visualAdjBasedOnRudeTraing_1 = [CNSP_path '/Customise_kNN_classifier/visualAdjustment_2Yes.sh ' ...
                                                                                                                studyFolder ' ' ...
                                                                                                                ID_selected ' ' ...
                                                                                                                'rudeTraining ' ...
                                                                                                                num2str(rudeTrainingTbl_YesIndArray(1)-2) ' ' ...
                                                                                                                num2str(rudeTrainingTbl_YesIndArray(2)-2)];
            system (cmd_visualAdjBasedOnRudeTraing_1);
        else
            progressText = get (handles.progressOutput_edit, 'String');
            progressText {end+1} = 'Error: Are you sure the entire brain is hyperintense?';
            set (handles.progressOutput_edit, 'String', progressText);
            drawnow;      
        end
    elseif basedOnBuiltinResultsSelected
        system (['chmod +x ' CNSP_path '/Customise_kNN_classifier/visualAdjustment_1Yes.sh']);
        system (['chmod +x ' CNSP_path '/Customise_kNN_classifier/visualAdjustment_2Yes.sh']);
        if rudeTrainingTbl_NumYes == 1
            cmd_visualAdjBasedOnRudeTraing_2 = [CNSP_path '/Customise_kNN_classifier/visualAdjustment_1Yes.sh ' ...
                                                                                                                studyFolder ' ' ...
                                                                                                                ID_selected ' ' ...
                                                                                                                'built-in ' ...
                                                                                                                num2str(rudeTrainingTbl_YesIndArray(1)-2)];
            system (cmd_visualAdjBasedOnRudeTraing_2);
        elseif rudeTrainingTbl_NumYes == 2
            cmd_visualAdjBasedOnRudeTraing_1 = [CNSP_path '/Customise_kNN_classifier/visualAdjustment_2Yes.sh ' ...
                                                                                                                studyFolder ' ' ...
                                                                                                                ID_selected ' ' ...
                                                                                                                'built-in ' ...
                                                                                                                num2str(rudeTrainingTbl_YesIndArray(1)-2) ' ' ...
                                                                                                                num2str(rudeTrainingTbl_YesIndArray(2)-2)];
            system (cmd_visualAdjBasedOnRudeTraing_1);
        else
            progressText = get (handles.progressOutput_edit, 'String');
            progressText {end+1} = 'Error: Are you sure the entire brain is hyperintense?';
            set (handles.progressOutput_edit, 'String', progressText);
            drawnow;      
        end

    else
        progressText = get (handles.progressOutput_edit, 'String');
        progressText {end+1} = 'Error: Haven''t select whether based on rude training or built-in classifier results.';
        set (handles.progressOutput_edit, 'String', progressText);
        drawnow;
    end
        


% --- Executes on button press in modifyTextfile_btn.
function modifyTextfile_btn_Callback(hObject, eventdata, handles)
% hObject    handle to modifyTextfile_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    index_selected = get(handles.visualAdj_listbox,'Value');
    ID_list = get(handles.visualAdj_listbox,'String');
    ID_selected = ID_list{index_selected}; 
    
    studyFolder = get (handles.studyDir_edit, 'String');
    
    progressText = get (handles.progressOutput_edit, 'String');
    progressText {end+1} = ['Modifying ' ID_selected ' training textfile ...'];
    set (handles.progressOutput_edit, 'String', progressText);
    drawnow;
    
    setappdata(0,'currentID', ID_selected);
    setappdata(0,'studyFolder', studyFolder);

    global CNSP_path
    CNSP_path = getappdata(0,'CNSP_path');    
    
    autoModTxt;


% --- Executes on button press in finishVisualAdjustment_btn.
function finishVisualAdjustment_btn_Callback(hObject, eventdata, handles)
% hObject    handle to finishVisualAdjustment_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CNSP_path = getappdata(0,'CNSP_path');
    
rudeTrainingTbl = get (handles.rudeTrainTbl,'Data');
trainingSize = str2double(get(handles.trainingSize_edit, 'String'));
studyFolder = get (handles.studyDir_edit, 'String');

final_feature = [studyFolder '/customiseClassifier/textfiles/feature_forTraining.txt'];
final_decision = [studyFolder '/customiseClassifier/textfiles/decision_forTraining.txt'];
final_lookup = [studyFolder '/customiseClassifier/textfiles/lookup_forTraining.txt'];

if exist (final_feature, 'file') == 2
    delete (final_feature);
end

if exist (final_decision, 'file') == 2
    delete (final_decision);
end

if exist (final_lookup, 'file') == 2
    delete (final_lookup);
end


progressText = get (handles.progressOutput_edit, 'String');
progressText {end+1} = 'Combining individual feature/decision textfiles ...';
set (handles.progressOutput_edit, 'String', progressText);
drawnow;

system (['chmod +x ' CNSP_path '/Customise_kNN_classifier/combineTrainingTextfiles.sh']);

for i = 1:trainingSize
    system ([CNSP_path '/Customise_kNN_classifier/combineTrainingTextfiles.sh ' rudeTrainingTbl{i,1} ' ' studyFolder]);
end


progressText = get (handles.progressOutput_edit, 'String');
progressText {end+1} = 'Customising kNN classifier completed !';
progressText {end+1} = 'Please proceed to Step 3.';
set (handles.progressOutput_edit, 'String', progressText);
drawnow;
   
    
    
    
    
    
    
    
    
    
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










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







function createTrainingTblFile_processed (NumofTrainingSubj, studyFolder, equalYN, equalYNdecision, rudeTrainingTbl, progressOutput)

progressOutputCellArray {:} = ''; % reset output
progressOutputCellArray {1} = '*******************************************';
progressOutputCellArray {end+1} = '        Customise kNN classifier        ';
progressOutputCellArray {end+1} = '           With Processed Data          ';
progressOutputCellArray {end+1} = '*******************************************';
progressOutputCellArray {end+1} = '           Neuroimaging Lab            ';
progressOutputCellArray {end+1} = '   Centre for Healthy Brain Ageing   ';
progressOutputCellArray {end+1} = '*******************************************';
progressOutputCellArray {end+1} = '';
set (progressOutput, 'String', progressOutputCellArray);
drawnow;

progressOutputCellArray {end+1} = 'Creating training table file ...';
set (progressOutput, 'String', progressOutputCellArray);
drawnow;

decision_forTraining_unequalYN = [studyFolder '/customiseClassifier/textfiles/decision_forTraining_unequalYN_rudeTraining.txt'];
feature_forTraining_unequalYN = [studyFolder '/customiseClassifier/textfiles/feature_forTraining_unequalYN_rudeTraining.txt'];
decision_forTraining = [studyFolder '/customiseClassifier/textfiles/decision_forTraining_rudeTraining.txt'];
feature_forTraining = [studyFolder '/customiseClassifier/textfiles/feature_forTraining_rudeTraining.txt'];

if exist (decision_forTraining, 'file')==2
  delete(decision_forTraining);
end

if exist(feature_forTraining, 'file')==2
  delete(feature_forTraining);
end

if exist (decision_forTraining_unequalYN, 'file')==2
  delete(decision_forTraining_unequalYN);
end

if exist(feature_forTraining_unequalYN, 'file')==2
  delete(feature_forTraining_unequalYN);
end

% generate feature & decision for each ID
parfor i = 1:NumofTrainingSubj
    fprintf ('processing %s ...\n', rudeTrainingTbl{i,1});
    if exist([studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_feature_forTraining_rudeTraining.txt'], 'file')==2
      delete([studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_feature_forTraining_rudeTraining.txt']);
    end

    if exist([studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_decision_forTraining_rudeTraining.txt'], 'file')==2
      delete([studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_decision_forTraining_rudeTraining.txt']);
    end
    
    if exist([studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_lookUp_forTraining_rudeTraining.txt'], 'file')==2
      delete([studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_lookUp_forTraining_rudeTraining.txt']);
    end
    
    copyfile ([studyFolder '/subjects/' rudeTrainingTbl{i,1} '/mri/extractedWMH/temp/' rudeTrainingTbl{i,1} '_feature_4prediction.txt'], ...
                [studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_feature_forTraining_rudeTraining.txt'], ...
                'f');
    copyfile ([studyFolder '/subjects/' rudeTrainingTbl{i,1} '/mri/extractedWMH/temp/' rudeTrainingTbl{i,1} '_clusterLookUp_4prediction.txt'],...
                [studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_lookUp_forTraining_rudeTraining.txt'], ...
                'f');
    lookUp = importdata ([studyFolder '/subjects/' rudeTrainingTbl{i,1} '/mri/extractedWMH/temp/' rudeTrainingTbl{i,1} '_clusterLookUp_4prediction.txt'], ' ');
    [m,n] = size(lookUp);

    % assign Yes/No according to rudeTrainingTbl
    YNdecisionCellArray = cell (m,1);
    for k = 1:m
        if lookUp(k,1) == 0
            YNdecisionCellArray {k,1} = rudeTrainingTbl {i,2};
        elseif lookUp(k,1) == 1
            YNdecisionCellArray {k,1} = rudeTrainingTbl {i,3};
        elseif lookUp(k,1) == 2
            YNdecisionCellArray {k,1} = rudeTrainingTbl {i,4};
        end
    end
    
    % write rude training table
    decisionTBL = cell2table (YNdecisionCellArray);
    writetable (decisionTBL, [studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_decision_forTraining_rudeTraining.txt'], ...
                'WriteVariableNames', false);
end



for i = 1:NumofTrainingSubj
    output_decision = ['cat ' studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_decision_forTraining_rudeTraining.txt >> ' decision_forTraining_unequalYN];
    output_feature = ['cat ' studyFolder '/customiseClassifier/textfiles/' rudeTrainingTbl{i,1} '_feature_forTraining_rudeTraining.txt >> ' feature_forTraining_unequalYN];
    system (output_decision);
    system (output_feature);
    fprintf ('%s done\n', rudeTrainingTbl{i,1});
end


% whether to equlize the number of Yes/No
if strcmp(equalYN, 'equalizeYN') && strcmp(equalYNdecision, '1')
    progressOutputCellArray {end+1} = 'Equalize Yes/No decisions, and write to textfile ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    TrainingDecisionUnequal = importdata (decision_forTraining_unequalYN);
    TrainingFeatureUnequal = importdata (feature_forTraining_unequalYN);
    
    TrainingDecisionUnequal_No_idx = find (strcmp (TrainingDecisionUnequal (:), 'No'));
    TrainingDecisionUnequal_Yes_idx = find (strcmp (TrainingDecisionUnequal (:), 'Yes'));
    
    TrainingFeatureUnequal_No_entries = TrainingFeatureUnequal (TrainingDecisionUnequal_No_idx,:);
    TrainingFeatureUnequal_Yes_entries = TrainingFeatureUnequal (TrainingDecisionUnequal_Yes_idx,:);
    TrainingDecisionUnequal_No_decisions = TrainingDecisionUnequal(TrainingDecisionUnequal_No_idx);
    TrainingDecisionUnequal_Yes_decisions = TrainingDecisionUnequal(TrainingDecisionUnequal_Yes_idx);
    
    
    [Y_Nrow, Y_Ncol] = size (TrainingDecisionUnequal_Yes_idx);
    [N_Nrow, N_Ncol] = size (TrainingDecisionUnequal_No_idx);
    
    if N_Nrow >= Y_Nrow % more NO than YES
        rand_N_idx = reshape(randperm (N_Nrow,Y_Nrow), [Y_Nrow,1]); % random "YES" number of "NO", and convert to verticle array
        TrainingFeatureUnequal_No_randomlyPicked = TrainingFeatureUnequal_No_entries (rand_N_idx,:);
        TrainingDecisionUnequal_No_randomlyPicked = TrainingDecisionUnequal_No_decisions (rand_N_idx,:);
        % write to file
        progressOutputCellArray {end+1} = 'Write to text output ...';
        set (progressOutput, 'String', progressOutputCellArray);
        drawnow;
        decision = vertcat (TrainingDecisionUnequal_Yes_decisions, TrainingDecisionUnequal_No_randomlyPicked);
        feature = vertcat (TrainingFeatureUnequal_Yes_entries, TrainingFeatureUnequal_No_randomlyPicked);
        writetable (cell2table (decision), decision_forTraining, 'WriteVariableNames', 0);
        dlmwrite (feature_forTraining, feature);
    else  % more YES than NO
        % In most of the cases NO is much more than YES. If YES is
        % more than NO, and equalYN is true, we keep the original number of
        % YES's and NO's, as we do not want to lose positives.
        progressOutputCellArray {end+1} = 'Write to text output ...';
        set (progressOutput, 'String', progressOutputCellArray);
        drawnow;
        copyfile (decision_forTraining_unequalYN, decision_forTraining);
        copyfile (feature_forTraining_unequalYN, feature_forTraining);
    end

else
    progressOutputCellArray {end+1} = 'Write to text output ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    copyfile (decision_forTraining_unequalYN, decision_forTraining);
    copyfile (feature_forTraining_unequalYN, feature_forTraining);
end


progressOutputCellArray {end+1} = 'FINISHED !';
set (progressOutput, 'String', progressOutputCellArray);
drawnow;
