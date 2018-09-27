function varargout = NBTR_DARTEL_GUI(varargin)
% NBTR_DARTEL_GUI MATLAB code for NBTR_DARTEL_GUI.fig
%      NBTR_DARTEL_GUI, by itself, creates a new NBTR_DARTEL_GUI or raises the existing
%      singleton*.
%
%      H = NBTR_DARTEL_GUI returns the handle to a new NBTR_DARTEL_GUI or the handle to
%      the existing singleton*.
%
%      NBTR_DARTEL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NBTR_DARTEL_GUI.M with the given input arguments.
%
%      NBTR_DARTEL_GUI('Property','Value',...) creates a new NBTR_DARTEL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NBTR_DARTEL_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NBTR_DARTEL_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NBTR_DARTEL_GUI

% Last Modified by GUIDE v2.5 24-Mar-2017 14:44:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NBTR_DARTEL_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @NBTR_DARTEL_GUI_OutputFcn, ...
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

% cd(fileparts(which([mfilename '.m']))); % change dir
% currDir = fileparts(which([mfilename '.m']));
% [status,parentDir_char] = system (['echo $(dirname ' currDir ')']);
% parentDir = cellstr(parentDir_char); % char array to cell array
% 
% addpath(genpath(parentDir{1})); % addpath the parent folder with subfolders
%     

% --- Executes just before NBTR_DARTEL_GUI is made visible.
function NBTR_DARTEL_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NBTR_DARTEL_GUI (see VARARGIN)

% Choose default command line output for NBTR_DARTEL_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NBTR_DARTEL_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NBTR_DARTEL_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




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



function imgFolder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to imgFolder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imgFolder_edit as text
%        str2double(get(hObject,'String')) returns contents of imgFolder_edit as a double


% --- Executes during object creation, after setting all properties.
function imgFolder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgFolder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findImgFolder_btn.
function findImgFolder_btn_Callback(hObject, eventdata, handles)
% hObject    handle to findImgFolder_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imgFolder = uigetdir;
set (handles.imgFolder_edit,'String',imgFolder);


function spm12Folder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to spm12Folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spm12Folder_edit as text
%        str2double(get(hObject,'String')) returns contents of spm12Folder_edit as a double



% --- Executes during object creation, after setting all properties.
function spm12Folder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spm12Folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findSpm12Folder_btn.
function findSpm12Folder_btn_Callback(hObject, eventdata, handles)
% hObject    handle to findSpm12Folder_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


spm12folder = uigetdir;
set (handles.spm12Folder_edit,'String',spm12folder);


% --- Executes on selection change in dartelTemplate_popupmenu.
function dartelTemplate_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to dartelTemplate_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dartelTemplate_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dartelTemplate_popupmenu


% --- Executes during object creation, after setting all properties.
function dartelTemplate_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dartelTemplate_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in rm_noQC_btn.
function rm_noQC_btn_Callback(hObject, eventdata, handles)
% hObject    handle to rm_noQC_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imgFolder = get (handles.imgFolder_edit,'String');
spm12path = get (handles.spm12Folder_edit,'String');

switch get(handles.dartelTemplate_popupmenu,'Value')
    case 1
        dartelTemplate = 'existing';
        ageRange = '65to75';
    case 2
        dartelTemplate = 'existing';
        ageRange = '70to80';
    case 3
        dartelTemplate = 'creating';
        ageRange = 'NA';
end

segExcldList = '';

if exist ([imgFolder '/spmoutput'],'dir') == 7
    rmdir ([imgFolder '/spmoutput'],'s');
end

if exist ([imgFolder '/nonbrainRemoved'],'dir') == 7
    rmdir ([imgFolder '/nonbrainRemoved'],'s');
end

if exist ([imgFolder '/QC'],'dir') == 7
    rmdir ([imgFolder '/QC'],'s');
end


rmNonbrain_noQC (imgFolder, spm12path, dartelTemplate, ageRange, segExcldList, handles.progressOutput_edit);




% --- Executes on button press in rm_wQC_btn.
function rm_wQC_btn_Callback(hObject, eventdata, handles)
% hObject    handle to rm_wQC_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imgFolder = get (handles.imgFolder_edit,'String');
spm12path = get (handles.spm12Folder_edit,'String');

if exist ([imgFolder '/spmoutput'],'dir') == 7
    rmdir ([imgFolder '/spmoutput'],'s');
end

if exist ([imgFolder '/nonbrainRemoved'],'dir') == 7
    rmdir ([imgFolder '/nonbrainRemoved'],'s');
end

if exist ([imgFolder '/QC'],'dir') == 7
    rmdir ([imgFolder '/QC'],'s');
end

rmNonbrain_wQC_1 (imgFolder, spm12path, handles.progressOutput_edit);




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


% --- Executes on button press in finishQCinput_btn.
function finishQCinput_btn_Callback(hObject, eventdata, handles)
% hObject    handle to finishQCinput_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imgFolder = get (handles.imgFolder_edit,'String');
segExcldList = get (handles.segQC_edit,'String');

switch get(handles.dartelTemplate_popupmenu,'Value')
    case 1
        dartelTemplate = 'existing';
        ageRange = '65to75';
    case 2
        dartelTemplate = 'existing OATS template';
        ageRange = '70to80';
    case 3
        dartelTemplate = 'creating template';
        ageRange = 'NA';
end

rmNonbrain_wQC_2 (imgFolder, dartelTemplate, ageRange, segExcldList, handles.progressOutput_edit);


























%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%













function rmNonbrain_noQC (imgFolder, spm12path, dartelTemplate, ageRange, segExcldList, progressOutput)

    tic;
    
%     cd(fileparts(which([mfilename '.m'])));
    
    progressOutputCellArray {:} = ''; % reset output
    % updating progress output
    progressOutputCellArray {1} = '*******************************************';
    progressOutputCellArray {end+1} = '        Non-brain Tissue Removal (DARTEL space)        ';
    progressOutputCellArray {end+1} = '             No QC stops               ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '           Neuroimaging Lab            ';
    progressOutputCellArray {end+1} = '   Centre for Healthy Brain Ageing   ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '';   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
   
    addpath (spm12path);
    CNSP_path = getappdata (0,'CNSP_path');
%     currDir = fileparts(which([mfilename '.m']));
%     [status,parentDir_char] = system (['echo $(dirname ' currDir ')']);
%     parentDir = cellstr(parentDir_char); % char array to cell array
%     parentFolder = [parentDir{1}];
    
    excldIDs = strsplit (segExcldList, ' ');
 
    %%%%%%%%%%%%%%%%%%%%%%%%
    %% Organising folders %%
    %%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Organising folders ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    % gunzip niftis
    cmd_gunzip = ['gunzip ' imgFolder '/*'];
    system (cmd_gunzip);

    % get the IDs
    imgs = dir (strcat (imgFolder,'/*.nii'));
    [Nsubj,n] = size (imgs);
    
    
    % create nonbrainRemoved folder
    mkdir (imgFolder, 'nonbrainRemoved');
    

    %%%%%%%%%%%%%%%%%%%
    %% Run SPM steps %%
    %%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Running SPM steps ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    progressOutputCellArray {end+1} = 'Step 1: segmentation ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    NBTR_1_seg (imgFolder, spm12path);

    progressOutputCellArray = get (progressOutput, 'String');
    progressOutputCellArray {end+1} = 'Step 2: Running DARTEL ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    NBTR_2_dartel (imgFolder, CNSP_path, dartelTemplate, ageRange, segExcldList);  % dartelTemplate specifies which set of templates to be used.

    progressOutputCellArray {end+1} = 'Step 3: Bring images to DARTEL ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    NBTR_3_bringToDARTEL (imgFolder, dartelTemplate, segExcldList);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% non-brain tissue removal %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Removing non-brain tissue ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    cmd_skullStriping_1 = ['chmod +x ' CNSP_path '/NBTR_DARTEL/NBTR_4_nonbrainRm.sh'];
    system (cmd_skullStriping_1);
    
    parfor i = 1:Nsubj   % skip the current and parent folder
        imgNames = strsplit (imgs(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = imgNames{1};   % first section is ID
        imgFilenames = strsplit (imgs(i).name, '.');
        imgFilename_nosuffix = imgFilenames{1};

        if ismember(ID, excldIDs) == 0

            cmd_skullStriping_2 = [CNSP_path '/NBTR_DARTEL/NBTR_4_nonbrainRm.sh ' imgFilename_nosuffix ' ' imgFolder ' ' CNSP_path];
            system (cmd_skullStriping_2);
        end

    end   
    
    cmd_gunzip = ['gunzip ' imgFolder '/nonbrainRemoved/*'];
    system (cmd_gunzip);
    
    progressOutputCellArray {end+1} = 'Back to native space ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    NBTR_5_backToNative (imgFolder, dartelTemplate, segExcldList);
    
    complete_time = toc/60; % in min
    progressOutputCellArray {end+1} = ['Finished in ' num2str(complete_time) ' minutes.'];
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    progressOutputCellArray {end+1} = '';
    progressOutputCellArray {end+1} = ['Results in: ' imgFolder '/nonbrainRemoved'];
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    function rmNonbrain_wQC_1 (imgFolder, spm12path, progressOutput)

    tic;
    
%     cd(fileparts(which([mfilename '.m'])));
    
    progressOutputCellArray {:} = ''; % reset output
    % updating progress output
    progressOutputCellArray {1} = '*******************************************';
    progressOutputCellArray {end+1} = '        Non-brain Tissue Removal (DARTEL space)        ';
    progressOutputCellArray {end+1} = '             With QC stops               ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '           Neuroimaging Lab            ';
    progressOutputCellArray {end+1} = '   Centre for Healthy Brain Ageing   ';
    progressOutputCellArray {end+1} = '*******************************************';
    progressOutputCellArray {end+1} = '';   
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    addpath (spm12path);
    CNSP_path = getappdata (0,'CNSP_path');
%     currDir = fileparts(which([mfilename '.m']));
%     [status,parentDir_char] = system (['echo $(dirname ' currDir ')']);
%     parentDir = cellstr(parentDir_char); % char array to cell array
%     parentFolder = [parentDir{1}];
 
    %%%%%%%%%%%%%%%%%%%%%%%%
    %% Organising folders %%
    %%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Organising folders ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    % gunzip niftis
    cmd_gunzip = ['gunzip ' imgFolder '/*'];
    system (cmd_gunzip);

    % get the IDs
    imgs = dir (strcat (imgFolder,'/*.nii'));
    [Nsubj,n] = size (imgs);
    
    
    % create nonbrainRemoved folder
    mkdir (imgFolder, 'nonbrainRemoved');
    

    %%%%%%%%%%%%%%%%%%%
    %% Run SPM steps %%
    %%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Running SPM steps ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    progressOutputCellArray {end+1} = 'Step 1: segmentation ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    NBTR_1_seg (imgFolder, spm12path);
  
    progressOutputCellArray {end+1} = 'Generating segmentation QC images ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    NBTR_segQC (imgFolder, CNSP_path); % segmentation QC
    
    progressOutputCellArray {end+1} = 'Please input IDs failed segmentation QC.';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    function rmNonbrain_wQC_2 (imgFolder, dartelTemplate, ageRange, segExcldList, progressOutput)
     
    imgs = dir (strcat (imgFolder,'/*.nii'));
    [Nsubj,n] = size (imgs);
    
    excldIDs = strsplit (segExcldList, ' ');
    
    CNSP_path = getappdata(0,'CNSP_path');
    
%     currDir = fileparts(which([mfilename '.m']));
%     [status,parentDir_char] = system (['echo $(dirname ' currDir ')']);
%     parentDir = cellstr(parentDir_char); % char array to cell array
%     parentFolder = [parentDir{1}];
    
    progressOutputCellArray = get (progressOutput, 'String');
    progressOutputCellArray {end+1} = 'Step 2: Running DARTEL ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    NBTR_2_dartel (imgFolder, CNSP_path, dartelTemplate, ageRange, segExcldList);  % dartelTemplate specifies which set of templates to be used.

    progressOutputCellArray {end+1} = 'Step 3: Bring images to DARTEL ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    NBTR_3_bringToDARTEL (imgFolder, dartelTemplate, segExcldList);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% non-brain tissue removal %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    progressOutputCellArray {end+1} = 'Removing non-brain tissue ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    cmd_skullStriping_1 = ['chmod +x ' CNSP_path '/NBTR_DARTEL/NBTR_4_nonbrainRm.sh'];
    system (cmd_skullStriping_1);
    
    parfor i = 1:Nsubj   % skip the current and parent folder
        imgNames = strsplit (imgs(i).name, '_');   % split T1 image name, delimiter is underscore
        ID = imgNames{1};   % first section is ID
        imgFilenames = strsplit (imgs(i).name, '.');
        imgFilename_nosuffix = imgFilenames{1};

        if ismember(ID, excldIDs) == 0

            cmd_skullStriping_2 = [CNSP_path '/NBTR_DARTEL/NBTR_4_nonbrainRm.sh ' imgFilename_nosuffix ' ' imgFolder ' ' CNSP_path];
            system (cmd_skullStriping_2);
        end

    end   
    
    cmd_gunzip = ['gunzip ' imgFolder '/nonbrainRemoved/*'];
    system (cmd_gunzip);
    
    progressOutputCellArray {end+1} = 'Back to native space ...';
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    NBTR_5_backToNative (imgFolder, dartelTemplate, segExcldList);
    
    complete_time = toc/60; % in min
    progressOutputCellArray {end+1} = ['Finished in ' num2str(complete_time) ' minutes.'];
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
    progressOutputCellArray {end+1} = '';
    progressOutputCellArray {end+1} = ['Results in: ' imgFolder '/nonbrainRemoved'];
    set (progressOutput, 'String', progressOutputCellArray);
    drawnow;
    
 
