function varargout = shareTextfileDialog(varargin)
% SHARETEXTFILEDIALOG MATLAB code for shareTextfileDialog.fig
%      SHARETEXTFILEDIALOG, by itself, creates a new SHARETEXTFILEDIALOG or raises the existing
%      singleton*.
%
%      H = SHARETEXTFILEDIALOG returns the handle to a new SHARETEXTFILEDIALOG or the handle to
%      the existing singleton*.
%
%      SHARETEXTFILEDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHARETEXTFILEDIALOG.M with the given input arguments.
%
%      SHARETEXTFILEDIALOG('Property','Value',...) creates a new SHARETEXTFILEDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before shareTextfileDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to shareTextfileDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help shareTextfileDialog

% Last Modified by GUIDE v2.5 01-Apr-2017 11:06:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @shareTextfileDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @shareTextfileDialog_OutputFcn, ...
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

cd(fileparts(which([mfilename '.m']))); % change dir



% --- Executes just before shareTextfileDialog is made visible.
function shareTextfileDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to shareTextfileDialog (see VARARGIN)

% Choose default command line output for shareTextfileDialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes shareTextfileDialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = shareTextfileDialog_OutputFcn(hObject, eventdata, handles) 
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


text {1,1} = 'Would you like to help improve WMH extraction accuracy?';
text {end+1,1} = '';
text {end+1,1} = 'All you need to do is to send two text files to jiyang.jiang@unsw.edu.au';
text {end+1,1} = '';
text {end+1,1} = 'These two files only contain info about the six features of each cluster ';
text {end+1,1} = '(i.e. six numbers describing the intensity and location of each cluster), '; 
text {end+1,1} = 'and whether the cluster is a WMH region.';
text {end+1,1} = '';
text {end+1,1} = 'The two files are located at:';
text {end+1,1} = 'yourStudyFolder/customiseClassifier/textfiles/decision_forTraining.txt';
text {end+1,1} = 'yourStudyFolder/customiseClassifier/textfiles/feature_forTraining.txt';
text {end+1,1} = '';
text {end+1,1} = 'Your contribution will greatly improve our WMH extraction accuracy!';
text {end+1,1} = 'To enquire about contributing, please contact jiyang.jiang@unsw.edu.au';
text {end+1,1} = '';
text {end+1,1} = 'If you couldn''t send the email using the section below, please use your local email client.';
set(hObject,'String',text);


% --- Executes on button press in sendEmail_btn.
function sendEmail_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sendEmail_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mail = get (handles.mail_edit,'String');    % email address
password = get (handles.password_edit,'String');          % email password
server = get (handles.server_edit,'String');     % SMTP server
port = get (handles.port_edit,'String'); % SMTP port

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.port',port);
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.starttls.enable', 'true' );
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');

% Apply prefs and props
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server',server);
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

sendmail('jiyang.jiang@unsw.edu.au',...
         'Contributing feature/decision for training',...
         'Pls see the two text files in the attachment.',...
         {'../WMH_extraction/4kNN_classifier/customised_classifier/decision_forTraining.txt',...
         '../WMH_extraction/4kNN_classifier/customised_classifier/feature_forTraining.txt'});
     
     
     



function mail_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mail_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mail_edit as text
%        str2double(get(hObject,'String')) returns contents of mail_edit as a double


% --- Executes during object creation, after setting all properties.
function mail_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mail_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function server_edit_Callback(hObject, eventdata, handles)
% hObject    handle to server_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of server_edit as text
%        str2double(get(hObject,'String')) returns contents of server_edit as a double


% --- Executes during object creation, after setting all properties.
function server_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to server_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function password_edit_Callback(hObject, eventdata, handles)
% hObject    handle to password_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of password_edit as text
%        str2double(get(hObject,'String')) returns contents of password_edit as a double


% --- Executes during object creation, after setting all properties.
function password_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to password_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function port_edit_Callback(hObject, eventdata, handles)
% hObject    handle to port_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of port_edit as text
%        str2double(get(hObject,'String')) returns contents of port_edit as a double


% --- Executes during object creation, after setting all properties.
function port_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to port_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in defaultEmailApp_btn.
function defaultEmailApp_btn_Callback(hObject, eventdata, handles)
% hObject    handle to defaultEmailApp_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
email = 'jiyang.jiang@unsw.edu.au';
url = ['mailto:',email];
web(url)