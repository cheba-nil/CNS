function varargout = noCustomisedClassifierError(varargin)
% NOCUSTOMISEDCLASSIFIERERROR MATLAB code for noCustomisedClassifierError.fig
%      NOCUSTOMISEDCLASSIFIERERROR, by itself, creates a new NOCUSTOMISEDCLASSIFIERERROR or raises the existing
%      singleton*.
%
%      H = NOCUSTOMISEDCLASSIFIERERROR returns the handle to a new NOCUSTOMISEDCLASSIFIERERROR or the handle to
%      the existing singleton*.
%
%      NOCUSTOMISEDCLASSIFIERERROR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NOCUSTOMISEDCLASSIFIERERROR.M with the given input arguments.
%
%      NOCUSTOMISEDCLASSIFIERERROR('Property','Value',...) creates a new NOCUSTOMISEDCLASSIFIERERROR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before noCustomisedClassifierError_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to noCustomisedClassifierError_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help noCustomisedClassifierError

% Last Modified by GUIDE v2.5 10-Mar-2017 17:50:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @noCustomisedClassifierError_OpeningFcn, ...
                   'gui_OutputFcn',  @noCustomisedClassifierError_OutputFcn, ...
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


% --- Executes just before noCustomisedClassifierError is made visible.
function noCustomisedClassifierError_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to noCustomisedClassifierError (see VARARGIN)

% Choose default command line output for noCustomisedClassifierError
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes noCustomisedClassifierError wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = noCustomisedClassifierError_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in goToTrainingCustomisedClassifier.
function goToTrainingCustomisedClassifier_Callback(hObject, eventdata, handles)
% hObject    handle to goToTrainingCustomisedClassifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    CustomiseKNNclassifier_GUI;
    close (noCustomisedClassifierError);
    close (WMHextraction_GUI);
