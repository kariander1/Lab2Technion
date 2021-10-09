function varargout = MagLev(varargin)
% MAGLEV MATLAB code for MagLev.fig
%      MAGLEV, by itself, creates a new MAGLEV or raises the existing
%      singleton*.
%
%      H = MAGLEV returns the handle to a new MAGLEV or the handle to
%      the existing singleton*.
%
%      MAGLEV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAGLEV.M with the given input arguments.
%
%      MAGLEV('Property','Value',...) creates a new MAGLEV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MagLev_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MagLev_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MagLev

% Last Modified by GUIDE v2.5 19-Sep-2016 06:42:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MagLev_OpeningFcn, ...
                   'gui_OutputFcn',  @MagLev_OutputFcn, ...
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


% --- Executes just before MagLev is made visible.
function MagLev_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MagLev (see VARARGIN)

% Choose default command line output for MagLev
handles.output = hObject;
% Load in a background image and display it using the correct colors
% The image used below, is in the Image Processing Toolbox.  If you do not have %access to this toolbox, you can use another image file instead.
I=imread('ecp-730.bmp');
axes(handles.axes2)
imagesc(I);
colormap gray

I=imread('axis.png');
axes(handles.axes4)
imagesc(I);
colormap gray
set(handles.axes4,'handlevisibility','off', ...
            'visible','off')
% Turn the handlevisibility off so that we don't inadvertently plot into the axes again
% Also, make the axes invisible
set(handles.axes2,'handlevisibility','off', ...
            'visible','off')
axes(handles.axes3)
I=imread('disc.bmp'); handles.disc = imagesc(I);
colormap gray
set(handles.axes3,'handlevisibility','off', ...
            'visible','off')

% Now we can use the figure, as required.
% For example, we can put a plot in an axes

% Consts
handles.id_num  = 1; %1 user
% PID consts
handles.K       = 1;
handles.Kd      = 0;
handles.Ki      = 0;
% By default the loop is open
handles.OC_loop = 0;
handles.Fs      = 1;
handles.T        = 10;
% Model types
handles.model_list  = {'FullModel_with_friction.slx','FullModel_without_friction.slx'};
handles.simmodel    = 'FullModel_with_friction';
for ii=1:2
    if ~exist(handles.model_list{ii},'file')
        msgbox('Simulink files missing');
        close(handles.figure1);
        return;
    else
        load_system(handles.model_list{ii});
    end
end

javaFrame = get(hObject,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('emda.png'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MagLev wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MagLev_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in animate.
function animate_Callback(hObject, eventdata, handles)
% hObject    handle to animate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y_max = 0.8012;
y_min = 0.3012;
% t = 0:1e-2:5;
% y = 0.5+0.6*sin(2*pi*1*t).*exp(-t);
% pos = get(handles.axes3,'pos');
% for ii=1:length(t)
% %     pos = get(handles.axes3,'pos');
%     posY = y(ii)*(y_max-y_min)+y_min;
%     pos(2) = posY;
%     set(handles.axes3,'pos',pos);
%     pause(delta_t);
% end
% pos(2) = y_min;
% set(handles.axes3,'pos',pos);
id1 = handles.id1;
if isfield(handles, 'id2')
    id2 = handles.id2;
else
    id2 = id1;
end
id = num2digits(id1+id2);
id(~id) = 9;

options = simset('SrcWorkspace','current');

K       = handles.K;
Kd      = handles.Kd;
Ki      = handles.Ki;
CO_loop = handles.OC_loop;
k       = min(0.1*id(end),0.3);
Fs      = handles.Fs;
m       = 0.121+0.05*id(end-2);
% a       = 1.65+id(4)/10;
a       = 1.65;
g       = 9.8;
b_system= 6.2+id(5)/10;
temp    = get(handles.b_choser,'SelectedObject');
b_user  = str2double(temp.String);
% b       = 6.2;
r       = str2double(get(handles.stepsize,'string'));
mag     = str2double(get(handles.sinuscmd,'string'));
choice  = get(handles.uipanel5,'SelectedObject');
if isstruct(choice)
    String  = choice.String;
else
    String  = get(choice,'String');
end
if strcmp(String,'Step Response')
    mag =   0;
end
freq    = str2double(get(handles.sinusfreq,'string'));
ku      = 1e-4;
Ts      = 1/343;
T       = handles.T;
compens = get(handles.compens,'value');

t       = sim(handles.simmodel,[],options);
pos     = get(handles.axes3,'pos');
YMAX        = 12;
YMIN        = 0;
handles.y   = max(min(y, YMAX),YMIN);
handles.cmd = cmd;
posY        = handles.y/YMAX*(y_max-y_min)+y_min;
poyS        = handles.y*1e4;
set(handles.animate,'String','Animating','enable','off');
delta_t = t(2)-t(1);
enableDisableFig(handles.figure1, 0);
for ii=1:5:length(t)    
    pos(2) = posY(ii);
    set(handles.axes3,'pos',pos);
    set(handles.animate,'String',[num2str(poyS(ii)) ' [counts]']);
    drawnow;
%     pause(delta_t/2);
end
set(handles.animate,'String','Animate','enable','on');
enableDisableFig(handles.figure1, 1);

handles.t   = t;
set(handles.save,'enable','on');
guidata(hObject, handles);

figure;
subplot(311);
plot(t(1:min(length(t),length(cmd))), cmd(1:min(length(t),length(cmd))), 'b');hold on;
plot(t(1:min(length(t),length(cmd))), poyS(1:min(length(t),length(cmd))),'r');
xlabel('t [sec]'); ylabel('Counts'); legend('Command','Position'); title('Position');  

v_y = diff(poyS)/Ts; a_y = diff(v_y)/Ts;
t_v = t(2:length(v_y)+1); t_a = t(3:length(a_y)+2);

subplot(312);
plot(t_v, v_y,'r');
xlabel('t [sec]'); ylabel('Velocity [counts/sec]'); title('Velocity');  

subplot(313);
plot(t_a, a_y,'r');
xlabel('t [sec]'); ylabel('Aceelaration [counts/sec^2]'); title('Acceleration');  


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn, pn] = uiputfile('*.xlsx','Data save','data.xlsx');
if isnumeric(fn)
    return;
end
xlswrite([pn fn],[handles.t(:) handles.cmd(:) handles.y(:)]);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
contents = cellstr(get(hObject,'String'));
choice   = contents{get(hObject,'Value')};
if choice == '1'
    set(handles.text2,'visible','off');
    set(handles.edit2,'visible','off');
else
    set(handles.text2,'visible','on');
    set(handles.edit2,'visible','on');
end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
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
str = get(hObject,'String');
if all(isstrprop(str,'digit') | str=='.')
    handles.Kd = str2double(str);
    if handles.Kd>2
        set(hObject,'String','2');
        handles.Kd = 2;
        beep;
    end
else
    msgbox('Not a number');
    set(hObject, 'string', num2str(handles.Kd));    
end
guidata(hObject, handles);


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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
str = get(hObject,'String');
if all(isstrprop(str,'digit') | str=='.')
    handles.K = str2double(str);
    if handles.K>2
        set(hObject,'String','2');
        handles.K = 2;
        beep;
    end
else
    msgbox('Not a number');
    set(hObject, 'string', num2str(handles.K));    
end
guidata(hObject, handles);

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
str = get(hObject,'String');
if all(isstrprop(str,'digit') | str=='.')
    handles.Ki = str2double(str);
    if handles.Ki>2
        set(hObject,'String','2');
        handles.Ki = 2;
        beep;
    end
else
    msgbox('Not a number');
    set(hObject, 'string', num2str(handles.Kd));    
end
guidata(hObject, handles);


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


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in model.
function model_Callback(hObject, eventdata, handles)
% hObject    handle to model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns model contents as cell array
%        contents{get(hObject,'Value')} returns selected item from model
handles.simmodel = handles.model_list{get(hObject,'Value')};
if isempty(strfind(handles.simmodel,'FullModel_with_friction'))
    set(handles.edit13, 'enable','off');
else
    set(handles.edit13, 'enable','on');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in loop.
function loop_Callback(hObject, eventdata, handles)
% hObject    handle to loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns loop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from loop
opt = {'Command','Step size'};
handles.OC_loop = get(hObject,'Value')-1;
set(handles.text15,'String',opt{get(hObject,'Value')});
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function loop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in partners.
function partners_Callback(hObject, eventdata, handles)
% hObject    handle to partners (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns partners contents as cell array
%        contents{get(hObject,'Value')} returns selected item from partners
contents    = cellstr(get(hObject,'String'));
choice      = contents{get(hObject,'Value')};
switch choice
    case '1' 
        set(handles.text2, 'visible', 'off');
        set(handles.edit2, 'visible', 'off');
        handles.id_num = 1;
    case '2' 
        set(handles.text2, 'visible', 'on');
        set(handles.edit2, 'visible', 'on');
        handles.id_num = 2;
    otherwise
end
guidata(hObject,handles);
        
% --- Executes during object creation, after setting all properties.
function partners_CreateFcn(hObject, eventdata, handles)
% hObject    handle to partners (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveid.
function saveid_Callback(hObject, eventdata, handles)
% hObject    handle to saveid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
id1 = get(handles.edit1,'string');
if all(isstrprop(id1,'digit')) && (length(id1)== 8 || length(id1)== 9)
    handles.id1 = str2double(id1);
else
    msgbox('Incorect ID');
    return;
end
if handles.id_num == 2
    id2 = get(handles.edit2,'string');
    if all(isstrprop(id2,'digit')) && (length(id2)== 8 || length(id2)== 9)
        handles.id2 = str2double(id2);
    else
        msgbox('Incorect ID');
        return;
    end
end
set(handles.saveid,'enable','off');
set(handles.edit1,'enable','off');
set(handles.edit2,'enable','off');
set(handles.partners,'enable','off');

set(handles.edit3,'enable','on');
set(handles.edit4,'enable','on');
set(handles.edit5,'enable','on');

set(handles.loop,'enable','on');
set(handles.model,'enable','on');
set(handles.animate,'enable','on');
set(handles.stepsize,'enable','on');
set(handles.sinuscmd,'enable','on');
set(handles.sinusfreq,'enable','on');
set(handles.compens,'enable','on');
set(handles.edit13,'enable','on');
set(handles.SimT,'enable','on');

set(handles.radiobutton5,'enable','on');
set(handles.radiobutton6,'enable','on');
set(handles.slider_b,'enable','on');

set(handles.radiobutton7,'enable','on');
set(handles.radiobutton8,'enable','on');
set(handles.radiobutton9,'enable','on');


id1 = handles.id1;
if isfield(handles, 'id2')
    id2 = handles.id2;
else
    id2 = id1;
end
id = num2digits(id1+id2);
id(~id) = 9;
b_system = 6.2+id(5)/10;
ind_rand = randperm(3);
b_opt = zeros(1,3);
while numel(unique(b_opt))<3
    b_opt(ind_rand) = b_system - [0 0.1*round(rand(1)*10) -0.1*round(rand(1)*10)];
end
set(handles.radiobutton7,'string',num2str(b_opt(1)));
set(handles.radiobutton8,'string',num2str(b_opt(2)));
set(handles.radiobutton9,'string',num2str(b_opt(3)));

guidata(hObject,handles);



function stepsize_Callback(hObject, eventdata, handles)
% hObject    handle to stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepsize as text
%        str2double(get(hObject,'String')) returns contents of stepsize as a double


% --- Executes during object creation, after setting all properties.
function stepsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sinuscmd_Callback(hObject, eventdata, handles)
% hObject    handle to sinuscmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sinuscmd as text
%        str2double(get(hObject,'String')) returns contents of sinuscmd as a double
str = get(hObject,'String');
if all(isstrprop(str,'digit') | str=='.')
    handles.temp = str2double(str);
    if handles.temp<0
        set(hObject,'String','0');
        handles.Fs = 1;
        beep;
    end
else
    msgbox('Not a number');
    set(hObject, 'string', num2str(0));    
end

% --- Executes during object creation, after setting all properties.
function sinuscmd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sinuscmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sinusfreq_Callback(hObject, eventdata, handles)
% hObject    handle to sinusfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sinusfreq as text
%        str2double(get(hObject,'String')) returns contents of sinusfreq as a double
str = get(hObject,'String');
if all(isstrprop(str,'digit') | str=='.')
    handles.temp = str2double(str);
    if handles.temp<0.1
        set(hObject,'String','0.1');
        handles.Fs = 1;
        beep;
    end
else
    msgbox('Not a number');
    set(hObject, 'string', num2str(1));    
end

% --- Executes during object creation, after setting all properties.
function sinusfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sinusfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
str = get(hObject,'String');
if all(isstrprop(str,'digit') | str=='.')
    handles.Fs = str2double(str);
    if handles.Fs>1
        set(hObject,'String','1');
        handles.Fs = 1;
        beep;
    end
else
    msgbox('Not a number');
    set(hObject, 'string', num2str(handles.Fs));    
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SimT_Callback(hObject, eventdata, handles)
% hObject    handle to SimT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SimT as text
%        str2double(get(hObject,'String')) returns contents of SimT as a double
str = get(hObject,'String');
if all(isstrprop(str,'digit') | str=='.')
    handles.T = str2double(str);
    if handles.T<10
        set(hObject,'String','5');
        handles.Fs = 5;
        beep;
    end
else
    msgbox('Not a number');
    set(hObject, 'string', num2str(handles.T));    
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function SimT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SimT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel5.
function uipanel5_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel5 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'String')
    case 'Step Response'
         set(handles.sinuscmd,'visible','off');   
         set(handles.sinusfreq,'visible','off');   
         set(handles.text16,'visible','off');   
         set(handles.text17,'visible','off');   
         set(handles.text15,'String','Step Size');   
    case 'Sinus Command'
         set(handles.sinuscmd,'visible','on');   
         set(handles.sinusfreq,'visible','on');   
         set(handles.text16,'visible','on');   
         set(handles.text17,'visible','on');   
         set(handles.text15,'String','Offset');           
    otherwise 
        msgbox('What????!!!');
end


% --- Executes on button press in compens.
function compens_Callback(hObject, eventdata, handles)
% hObject    handle to compens (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of compens


% --- Executes on slider movement.
function slider_b_Callback(hObject, eventdata, handles)
% hObject    handle to slider_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.b_disp,'String', get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function slider_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
