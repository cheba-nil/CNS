function varargout = viewKNNsearch(varargin)
% VIEWKNNSEARCH MATLAB code for viewKNNsearch.fig
%      VIEWKNNSEARCH, by itself, creates a new VIEWKNNSEARCH or raises the existing
%      singleton*.
%
%      H = VIEWKNNSEARCH returns the handle to a new VIEWKNNSEARCH or the handle to
%      the existing singleton*.
%
%      VIEWKNNSEARCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWKNNSEARCH.M with the given input arguments.
%
%      VIEWKNNSEARCH('Property','Value',...) creates a new VIEWKNNSEARCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewKNNsearch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewKNNsearch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewKNNsearch

% Last Modified by GUIDE v2.5 08-May-2017 16:44:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewKNNsearch_OpeningFcn, ...
                   'gui_OutputFcn',  @viewKNNsearch_OutputFcn, ...
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


% --- Executes just before viewKNNsearch is made visible.
function viewKNNsearch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewKNNsearch (see VARARGIN)

% Choose default command line output for viewKNNsearch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes viewKNNsearch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = viewKNNsearch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in viewKNNsearch_btn.
function viewKNNsearch_btn_Callback(hObject, eventdata, handles)
% hObject    handle to viewKNNsearch_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CNSP_path = getappdata(0,'CNSP_path');
studyFolder = getappdata(0,'studyFolder');
subjID = get(handles.subjID_edit,'String');
segID = get(handles.segID_edit,'String');
clusterID = get(handles.clusterID_edit, 'String');
[Nseg0, Nseg1] = clusterN (studyFolder, subjID);

switch segID
    case "0"
        observID = get(handles.clusterID_edit,'String');
    case "1"
        observID = num2str(str2num(clusterID) + Nseg0);
    case "2"
        observID = num2str(str2num(clusterID) + Nseg0 + Nseg1);
end

k = get(handles.k_edit,'String');

switch get(handles.incldTie_popupmenu,'Value')
    case 1
        incldTie = false;
    case 2
        incldTie = true;
end

switch get(handles.searchMthd_popupmenu,'Value')
    case 1
        nsMthd = 'kdtree';
    case 2
        nsMthd = 'exhaustive';
end
        
switch get(handles.distanceMetric_popupmenu,'Value')
    case 1
        Distance = 'euclidean';
    case 2
        Distance = 'seuclidean';
    case 3
        Distance = 'cityblock';
    case 4
        Distance = 'chebychev';
    case 5
        Distance = 'minkowski';
    case 6
        Distance = 'mahalanobis';
    case 7
        Distance = 'cosine';
    case 8
        Distance = 'correlation';
    case 9
        Distance = 'spearman';
    case 10
        Distance = 'hamming';
    case 11
        Distance = 'jaccard';
    case 12
        Distance = 'custom distance function';
end

% Feature 1-9 used in the 1st kNN, Feature 10-12 used in the 2nd
trainingFeature1 = 1:9;
trainingFeature2 = 10:12;

switch get(handles.classifier_popupmenu,'Value')
    case 1
        trainingFeature_file = [CNSP_path '/WMH_extraction/4kNN_classifier/feature_forTraining.txt'];
        trainingDecision_file = [CNSP_path '/WMH_extraction/4kNN_classifier/decision_forTraining.txt'];
        trainingLookup_file = [CNSP_path '/WMH_extraction/4kNN_classifier/lookup_forTraining.txt'];
    case 2
        trainingFeature_file = [studyFolder '/customiseClassifier/textfiles/feature_forTraining.txt'];
        trainingDecision_file = [studyFolder '/customiseClassifier/textfiles/decision_forTraining.txt'];
        trainingLookup_file = [CNSP_path '/customiseClassifier/textfiles/lookup_forTraining.txt'];
end

trainingFeature = importdata(trainingFeature_file);
trainingDecision = importdata(trainingDecision_file);

trainingLookup_fileID = fopen(trainingLookup_file);
trainingLookup = textscan (trainingLookup_fileID, '%s %d %d', 'Delimiter',' ');
fclose (trainingLookup_fileID);

newSubjFeature_file = [studyFolder '/subjects/' subjID '/mri/extractedWMH/temp/' subjID '_feature_4prediction.txt'];
newSubjFeature = importdata(newSubjFeature_file,' ');
[Nrow,Ncol] = size(newSubjFeature);
queryPointFeature (1,1:Ncol) = newSubjFeature(str2num(observID),1:Ncol);

% ------- test fitcknn and predict ------- %
first_model = fitcknn (trainingFeature(:,trainingFeature1), trainingDecision, ...
                    'NumNeighbors', str2num(k), ...
                    'IncludeTies',incldTie,...
                    'NSMethod',nsMthd,...
                    'Distance',Distance...
                    );
[first_label,first_score,~] = predict (first_model,queryPointFeature (1,trainingFeature1));

second_model = fitcknn (trainingFeature(:,trainingFeature2), trainingDecision, ...
                    'NumNeighbors', str2num(k), ...
                    'IncludeTies',incldTie,...
                    'NSMethod',nsMthd,...
                    'Distance',Distance...
                    );
[second_label,second_score,~] = predict (second_model,queryPointFeature (1,trainingFeature2));

% ------ knnsearch ------ %
[IDX1,D1] = knnsearch (trainingFeature(:,trainingFeature1),queryPointFeature(:,trainingFeature1),...
                        'K',str2num(k),...
                        'IncludeTies',incldTie,...
                        'NSMethod',nsMthd,...
                        'Distance',Distance...
                        );
%                         'P',str2num(get(handles.P_edit,'String')),...
%                         'Cov',cov,...
%                         'Scale',scale,...
%                         'BucketSize',bucketSize...
%                         );

if incldTie
    IDX1 = cell2mat(IDX1);
    D1 = cell2mat(D1);
end
[Nidx1Rows,Nidx1Cols] = size(IDX1);
[~,NtrainingFeature1] = size(trainingFeature1);

fprintf ('++++++++++++++++++++++++++++++++++++++++++++++++++\n');
fprintf (['== Subject ID: ' subjID '\n']);
fprintf (['== Observation Index: ' observID ' (i.e. Seg' segID ', cluster No. ' clusterID ')\n']);
observFeatures1 = sprintf ('%5.5f ', queryPointFeature(1,trainingFeature1));
fprintf ('== Enquiry observation''s features: %s \n',observFeatures1);
% observFeatures2 = sprintf ('%5.5f ', queryPointFeature(1,trainingFeature2));
% fprintf ('== Observation features 2: %s \n',observFeatures2);
fprintf (['== NSMethod: ' nsMthd '\n']);
fprintf (['== Distance metric: ' Distance '\n']);
fprintf ('==================================================\n');
fprintf (['== kNN predicted class: ' first_label{1} '\n']);
fprintf (['== kNN prediction probability: ' num2str(first_score(2)) '\n']);
% fprintf (['== 2nd kNN predicted class: ' second_label{1} '\n']);
% fprintf (['== 2nd kNN prediction probability: ' num2str(second_score(2)) '\n']);
fprintf ('==================================================\n');
fprintf ('\n');
fprintf ('1st KNN SEARCH: \n');
fprintf ('\n');


for i = 1:Nidx1Cols
    switch trainingLookup{2}(IDX1(i))
        case 0
            img1 = 'manually extracted WMH regions';
        case 1
            img1 = 'non-WMH regions in seg0';
        case 2
            img1 = 'non-WMH regions in seg1';
        case 3
            img1 = 'non-WMH regions in seg2';
    end

    fprintf ('Nearest neighbor %d, corresponding to %s, cluster ID %d of subject ID %s \n',i,...
                                                                                    img1,...
                                                                                    trainingLookup{3}(IDX1(i)),...
                                                                                    trainingLookup{1}{IDX1(i)}...
                                                                                    );
    fprintf ('Nearest neighbor %d index: %d \n',i,IDX1(i));
    featuresFound1 = sprintf ('%5.5f ', trainingFeature(IDX1(i),trainingFeature1));
    fprintf ('Nearest neighbor %d features: %s \n',i,featuresFound1);
    fprintf ('Nearest neighbor %d distance: %5.5f \n',i,D1(i));
    fprintf ('Nearest neighbor %d Decision: %s \n',i,trainingDecision{IDX1(i),1});
    fprintf ('-----------------------------------------------\n');
end

[IDX2,D2] = knnsearch (trainingFeature(:,trainingFeature2),queryPointFeature(:,trainingFeature2),...
                        'K',str2num(k),...
                        'IncludeTies',incldTie,...
                        'NSMethod',nsMthd,...
                        'Distance',Distance...
                        );
%                         'P',str2num(get(handles.P_edit,'String')),...
%                         'Cov',cov,...
%                         'Scale',scale,...
%                         'BucketSize',bucketSize...
%                         );
if incldTie
    IDX2 = cell2mat(IDX2);
    D2 = cell2mat(D2);
end
[Nidx2Rows,Nidx2Cols] = size(IDX2);
fprintf ('==================================================\n');
% fprintf ('\n');
% fprintf ('2nd KNN SEARCH: \n');
% fprintf ('\n');

% for j = 1:Nidx2Cols
%     switch trainingLookup{2}(IDX2(j))
%         case 0
%             img2 = 'manually extracted WMH regions';
%         case 1
%             img2 = 'non-WMH regions in seg0';
%         case 2
%             img2 = 'non-WMH regions in seg1';
%         case 3
%             img2 = 'non-WMH regions in seg2';
%     end
%     fprintf ('Nearest neighbor %d, corresponding to %s, cluster ID %d of subject ID %s \n',j,...
%                                                                                     img2,...
%                                                                                     trainingLookup{3}(IDX2(j)),...
%                                                                                     trainingLookup{1}{IDX2(j)}...
%                                                                                     );
%     fprintf ('Nearest neighbor %d index: %d \n',j,IDX2(j));
%     featuresFound2 = sprintf ('%5.5f ', trainingFeature(IDX2(j),trainingFeature2));
%     fprintf ('Nearest neighbor %d features: %s \n',j,featuresFound2);
%     fprintf ('Nearest neighbor %d distance: %5.5f \n',j,D2(i));
    
%     fprintf ('Nearest neighbor %d Decision: %s \n',j,trainingDecision{IDX2(j),1});
%     fprintf ('-----------------------------------------------\n');
% end

% fprintf ('==================================================\n\n');












function subjID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to subjID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjID_edit as text
%        str2double(get(hObject,'String')) returns contents of subjID_edit as a double


% --- Executes during object creation, after setting all properties.
function subjID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function clusterID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to clusterID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clusterID_edit as text
%        str2double(get(hObject,'String')) returns contents of clusterID_edit as a double


% --- Executes during object creation, after setting all properties.
function clusterID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clusterID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function P_edit_Callback(hObject, eventdata, handles)
% hObject    handle to P_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P_edit as text
%        str2double(get(hObject,'String')) returns contents of P_edit as a double


% --- Executes during object creation, after setting all properties.
function P_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in incldTie_popupmenu.
function incldTie_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to incldTie_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns incldTie_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from incldTie_popupmenu


% --- Executes during object creation, after setting all properties.
function incldTie_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to incldTie_popupmenu (see GCBO)
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


% --- Executes on selection change in distanceMetric_popupmenu.
function distanceMetric_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to distanceMetric_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns distanceMetric_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from distanceMetric_popupmenu


% --- Executes during object creation, after setting all properties.
function distanceMetric_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceMetric_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in searchMthd_popupmenu.
function searchMthd_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to searchMthd_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns searchMthd_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from searchMthd_popupmenu


% --- Executes during object creation, after setting all properties.
function searchMthd_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to searchMthd_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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



function customiseFunction_edit_Callback(hObject, eventdata, handles)
% hObject    handle to customiseFunction_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of customiseFunction_edit as text
%        str2double(get(hObject,'String')) returns contents of customiseFunction_edit as a double


% --- Executes during object creation, after setting all properties.
function customiseFunction_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to customiseFunction_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function segID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to segID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segID_edit as text
%        str2double(get(hObject,'String')) returns contents of segID_edit as a double


% --- Executes during object creation, after setting all properties.
function segID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
