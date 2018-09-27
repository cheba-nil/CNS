function varargout = AboutSoftware(varargin)
% ABOUTSOFTWARE MATLAB code for AboutSoftware.fig
%      ABOUTSOFTWARE, by itself, creates a new ABOUTSOFTWARE or raises the existing
%      singleton*.
%
%      H = ABOUTSOFTWARE returns the handle to a new ABOUTSOFTWARE or the handle to
%      the existing singleton*.
%
%      ABOUTSOFTWARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABOUTSOFTWARE.M with the given input arguments.
%
%      ABOUTSOFTWARE('Property','Value',...) creates a new ABOUTSOFTWARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AboutSoftware_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AboutSoftware_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AboutSoftware

% Last Modified by GUIDE v2.5 14-Mar-2017 22:20:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AboutSoftware_OpeningFcn, ...
                   'gui_OutputFcn',  @AboutSoftware_OutputFcn, ...
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


% --- Executes just before AboutSoftware is made visible.
function AboutSoftware_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AboutSoftware (see VARARGIN)

% Choose default command line output for AboutSoftware
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AboutSoftware wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AboutSoftware_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function text_edit_Callback(hObject, eventdata, handles)
% hObject    handle to text_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_edit as text
%        str2double(get(hObject,'String')) returns contents of text_edit as a double


% --- Executes during object creation, after setting all properties.
function text_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% read current CNS version
CNSP_path = fileparts (fileparts (mfilename ('fullpath')));
[~, currCNSver] = system (['cat ' CNSP_path '/version_log.txt | awk -F''='' ''{print $2}'' | tr -d ''\n''']);

text {1,1} = ['CHeBA NiL Software Packages (Ver ' currCNSver ')'];
text {end+1,1} = '';
text {end+1,1} = '-----------------------------------------';
text {end+1,1} = 'Contact:';
text {end+1,1} = '             cns.cheba@unsw.edu.au';
text {end+1,1} = '';
text {end+1,1} = '-----------------------------------------';
text {end+1,1} = 'Authors:';
text {end+1,1} = '             Dr. Jiyang Jiang';
text {end+1,1} = '             A/Prof. Wei Wen';
text {end+1,1} = '';
text {end+1,1} = '-----------------------------------------';
text {end+1,1} = 'Citation:';
text {end+1,1} = 'UBO Detector:10.1016/j.neuroimage.2018.03.050';
text {end+1,1} = 'TOPMAL: 10.1016/j.nicl.2018.03.035';
text {end+1,1} = '';
text {end+1,1} = '-----------------------------------------';
text {end+1,1} = 'Acknowledgments:';
text {end+1,1} = '           - Dr Jiang is supported by ';
text {end+1,1} = '             John Holden Family Foundation.';
text {end+1,1} = '';
text {end+1,1} = '           - We greatly appreciate ';
text {end+1,1} = '             the participants of ';
text {end+1,1} = '             Sydney Memory and Ageing';
text {end+1,1} = '             Study (MAS) and Older ';
text {end+1,1} = '             Australian Twins Study (OATS).';
text {end+1,1} = '';
text {end+1,1} = '-----------------------------------------';
text {end+1,1} = 'Copyright reserved.';
text {end+1,1} = 'April 2018';

set (hObject, 'String', text);
