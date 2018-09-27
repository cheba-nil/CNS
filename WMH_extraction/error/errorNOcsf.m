function varargout = errorNOcsf(varargin)
% ERRORNOCSF MATLAB code for errorNOcsf.fig
%      ERRORNOCSF, by itself, creates a new ERRORNOCSF or raises the existing
%      singleton*.
%
%      H = ERRORNOCSF returns the handle to a new ERRORNOCSF or the handle to
%      the existing singleton*.
%
%      ERRORNOCSF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERRORNOCSF.M with the given input arguments.
%
%      ERRORNOCSF('Property','Value',...) creates a new ERRORNOCSF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before errorNOcsf_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to errorNOcsf_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help errorNOcsf

% Last Modified by GUIDE v2.5 05-Apr-2017 16:12:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @errorNOcsf_OpeningFcn, ...
                   'gui_OutputFcn',  @errorNOcsf_OutputFcn, ...
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


% --- Executes just before errorNOcsf is made visible.
function errorNOcsf_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to errorNOcsf (see VARARGIN)

% Choose default command line output for errorNOcsf
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes errorNOcsf wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = errorNOcsf_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
