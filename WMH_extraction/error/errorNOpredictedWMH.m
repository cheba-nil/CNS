function varargout = errorNOpredictedWMH(varargin)
% ERRORNOPREDICTEDWMH MATLAB code for errorNOpredictedWMH.fig
%      ERRORNOPREDICTEDWMH, by itself, creates a new ERRORNOPREDICTEDWMH or raises the existing
%      singleton*.
%
%      H = ERRORNOPREDICTEDWMH returns the handle to a new ERRORNOPREDICTEDWMH or the handle to
%      the existing singleton*.
%
%      ERRORNOPREDICTEDWMH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERRORNOPREDICTEDWMH.M with the given input arguments.
%
%      ERRORNOPREDICTEDWMH('Property','Value',...) creates a new ERRORNOPREDICTEDWMH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before errorNOpredictedWMH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to errorNOpredictedWMH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help errorNOpredictedWMH

% Last Modified by GUIDE v2.5 05-Apr-2017 15:16:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @errorNOpredictedWMH_OpeningFcn, ...
                   'gui_OutputFcn',  @errorNOpredictedWMH_OutputFcn, ...
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


% --- Executes just before errorNOpredictedWMH is made visible.
function errorNOpredictedWMH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to errorNOpredictedWMH (see VARARGIN)

% Choose default command line output for errorNOpredictedWMH
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes errorNOpredictedWMH wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = errorNOpredictedWMH_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
