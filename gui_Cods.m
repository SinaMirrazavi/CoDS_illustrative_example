function varargout = gui_Cods(varargin)
% GUI_CODS MATLAB code for gui_Cods.fig
%      GUI_CODS, by itself, creates a new GUI_CODS or raises the existing
%      singleton*.
%
%      H = GUI_CODS returns the handle to a new GUI_CODS or the handle to
%      the existing singleton*.
%
%      GUI_CODS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CODS.M with the given input arguments.
%
%      GUI_CODS('Property','Value',...) creates a new GUI_CODS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_Cods_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_Cods_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_Cods

% Last Modified by GUIDE v2.5 25-May-2018 17:07:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_Cods_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_Cods_OutputFcn, ...
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


% --- Executes just before gui_Cods is made visible.
function gui_Cods_OpeningFcn(hObject, eventdata, handles, varargin)
 addpath(genpath('CoDS'))
 setup_CoDs;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_Cods (see VARARGIN)

% Choose default command line output for gui_Cods
handles.output = hObject;
handles.Deltat=0.001;
handles.check=0;
handles.check_rho=0;
handles.delta_dx=-0.2;
handles.Tfinal=10;
handles.animation=0;
handles.Onsurface=0;
handles.rho=get(handles.Rho_slider,'Value');
handles.axes1.XLim=[-5 5];
handles.axes1.YLim=[-5 5];
% Update handles structure

guidata(hObject, handles);

% UIWAIT makes gui_Cods wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.Rho_value,'String',get(handles.Rho_slider,'Value'));
grid on
box on



% --- Outputs from this function are returned to the command line.
function varargout = gui_Cods_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function Rho_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Rho_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Rho_value,'String',get(handles.Rho_slider,'Value'));
handles.rho=get(handles.Rho_slider,'Value');
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Rho_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rho_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function X_axis_Callback(hObject, eventdata, handles)
% hObject    handle to X_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.axes1.XLim=[-get(handles.X_axis,'Value') get(handles.X_axis,'Value')];

% --- Executes during object creation, after setting all properties.
function X_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Y_axis_Callback(hObject, eventdata, handles)
% hObject    handle to Y_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.axes1.YLim=[-get(handles.Y_axis,'Value') get(handles.Y_axis,'Value')];

% --- Executes during object creation, after setting all properties.
function Y_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Animation.
function Animation_Callback(hObject, eventdata, handles)
% hObject    handle to Animation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.animation=get(hObject,'Value');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of Animation



function velocity_Callback(hObject, eventdata, handles)
% hObject    handle to velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.delta_dx=str2double(get(hObject,'String'));
if handles.delta_dx<-10
    handles.delta_dx=-10;
    set(hObject,'String','-10');
end
if handles.delta_dx>-0.001
    handles.delta_dx=-0.001;
    set(hObject,'String','-0.001');
end
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of velocity as text
%        str2double(get(hObject,'String')) returns contents of velocity as a double


% --- Executes during object creation, after setting all properties.
function velocity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function step_time_Callback(hObject, eventdata, handles)
% hObject    handle to step_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Deltat=str2double(get(hObject,'String'));
if handles.Deltat<0.00001
    handles.Deltat=0.00001;
    set(hObject,'String','0.00001');
end
if handles.Deltat>0.01
    handles.Deltat=0.01;
    set(hObject,'String','0.01');
end
guidata(hObject, handles);
% handles
% Hints: get(hObject,'String') returns contents of step_time as text
%        str2double(get(hObject,'String')) returns contents of step_time as a double


% --- Executes during object creation, after setting all properties.
function step_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Tfinal=str2double(get(hObject,'String'));
if handles.Tfinal<1
    handles.Tfinal=1;
    set(hObject,'String','1');
end
if handles.Tfinal>100
    handles.Tfinal=100;
    set(hObject,'String','100');
end
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double


% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in Off_surface.
function Off_surface_Callback(hObject, eventdata, handles)
% hObject    handle to Off_surface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
handles.limits= [ handles.axes1.XAxis.Limits handles.axes1.YAxis.Limits];
handles.F_d=-5;
handles.Onsurface=0;
disp('Draw the contact surface')
[handles.N_x,handles.Poly,handles.X_target,handles.check]=Construct_the_surface(handles);
if handles.check==0
    error('Program exit')
end
disp('Draw some motions, make sure that it ends up at the target point and it goes through the contact surface !')
[handles.A,handles.X_initial,handles.check]=Construct_the_dynamcial_system(handles.Poly,handles.X_target,handles.X_target,handles);
if handles.check==0
    error('Program exit')
end
[handles.X_C,handles.X_L]=Select_the_contact_point(handles.Poly,handles.X_target,handles.X_initial,handles);
handles.uipanel2.Visible='on';
handles.simulate.Visible='on';










% --- Executes on button press in On_surface.
function On_surface_Callback(hObject, eventdata, handles)
% hObject    handle to On_surface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.uipanel2.Visible='on';
handles.simulate.Visible='on';

% --- Executes on button press in simulate.
function simulate_Callback(hObject, eventdata, handles)
% hObject    handle to simulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stop_record.
function stop_record_Callback(hObject, eventdata, handles)
% hObject    handle to stop_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stop_record.Value=1;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function uipanel2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
