function varargout = Client(varargin)
% CLIENT MATLAB code for Client.fig
%      CLIENT, by itself, creates a new CLIENT or raises the existing
%      singleton*.
%
%      H = CLIENT returns the handle to a new CLIENT or the handle to
%      the existing singleton*.
%
%      CLIENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLIENT.M with the given input arguments.
%
%      CLIENT('Property','Value',...) creates a new CLIENT or raises the
%      existing singleton*.  Starting from the left, property value pairs a5re
%      applied to the GUI before Client_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Client_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Client

% Last Modified by GUIDE v2.5 13-Aug-2018 16:48:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Client_OpeningFcn, ...
                   'gui_OutputFcn',  @Client_OutputFcn, ...
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


% --- Executes just before Client is made visible.
function Client_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Client (see VARARGIN)

% Choose default command line output for Client
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Client wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Client_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function status_indicator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to status_indicator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'string','idle');


% --- Executes during object creation, after setting all properties.
function data_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
result = cell(20,4);
setappdata(hObject,'result',result);
index = 0;
setappdata(hObject,'index',index);


% --- Executes during object creation, after setting all properties.
function measurement_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measurement_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','5');


% --- Executes on button press in start_measurement_button.
function start_measurement_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_measurement_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    measurement_time = str2double(get(handles.measurement_time,'String'));
if isnan(measurement_time)
    set(handles.status_indicator,'string','Please specify the time.');
    drawnow;
    return
end
t = tcpip('192.168.137.32', 80, 'NetworkRole','Client');
if strcmp(t.Status,'open')
    fclose(t);
end
while ~strcmp(t.Status,'open')
    try
       fopen(t);
    catch ME
        set(handles.status_indicator,'string','Trying to connect...');
        drawnow;
    end  
end
t.Status
set(handles.status_indicator,'string','measuring');
drawnow;
flushinput(t);
fwrite(t, 0);
brea = zeros(1,measurement_time*1000);
time = zeros(1,measurement_time*1000);
buffer_size = 1;
i = 1;
%trying to implement a non-existing do while loop
brea(i:i+buffer_size-1) = typecast(uint8(fread(t,[1,buffer_size*2],'uint8')),'uint16');
time(i:i+buffer_size-1) = typecast(uint8(fread(t,[1,buffer_size*4],'uint8')),'uint32');
while time(i)< measurement_time*1000
    if t.BytesAvailable
        i = i+1;
        brea(i:i+buffer_size-1) = typecast(uint8(fread(t,[1,buffer_size*2],'uint8')),'uint16');
        time(i:i+buffer_size-1) = typecast(uint8(fread(t,[1,buffer_size*4],'uint8')),'uint32');  
    end
end
fclose(t);
set(handles.status_indicator,'string','idle');
drawnow;
brea = brea(brea~=0)
time = time(1:length(brea))/1000.0;
cutoff_h = 7;
cutoff_window = cutoff_h+0.001;
MinPeakProminence = 0.5;
%Parameter section
fs = 1/(-mean(time(1:end-1)-time(2:end)));
l=length(brea);                      % series length
f_pos = fs*(0:(l/2))/l;              % single-sided positive frequency
brea_fft = fft(brea)/l;              % normalized fft
f_neg = fs*(-(l/2):0)/l;             % single-sided negative frequency
f = [f_neg(1:end-2+mod(l,2)),f_pos];
% constructing the filter
lowpass = zeros(1,l);
for n = 1:10
    lowpass = lowpass+(4/pi^2)*(((1-(-1)^n))/n^2)*ones(1,l).*(abs(f)>(n*cutoff_h-cutoff_window)&abs(f)<(n*cutoff_h));
end
brea_fft_filted = fftshift(brea_fft).*lowpass;
brea_filted = 1.5*real(ifft(ifftshift(brea_fft_filted*l)));
[pks, locs] = findpeaks(brea_filted./100, fs, 'MinPeakProminence',MinPeakProminence);
figure
hold on
plot(time,brea);
%plot(time,brea_filted);
%plot(locs,pks*100, 'bv');
findpeaks(brea_filted, fs, 'MinPeakProminence',MinPeakProminence*100);
xlabel('time(s)');
ylabel('ADC readings');
legend('orignal signal','filtered signal','peaks');
hold off
Breath_rate = numel(pks)/time(end)*60;
set(handles.status_indicator,'string',sprintf('the breath rate is: %f',Breath_rate));

t = tcpip('192.168.137.32', 80);
while ~strcmp(t.Status,'open')
    try
       fopen(t);
    catch ME
       set(handles.status_indicator,'string','Trying to connect...');
       drawnow;
    end  
end
t.Status;
set(handles.status_indicator,'string','measuring');
drawnow;
fwrite(t, 1);
temperature = str2double(fgetl(t));
while temperature == 85
    temperature = str2double(fgetl(t));
end
fclose(t);
set(handles.status_indicator,'string','idle');
drawnow;
c = fix(clock);
Date = strsplit(datestr(c),' ');
signal = sprintf('signal-%d-%d-%d-%d-%d-%d',c(1),c(2),c(3),c(4),c(5),c(6));
save(signal,'brea','time');
result = getappdata(handles.data_table,'result');
index = getappdata(handles.data_table,'index');
result(mod(index,20)+1,:) = [Date, num2cell(Breath_rate),num2cell(temperature)];
index = index + 1;
set(handles.data_table,'data',result);
setappdata(handles.data_table,'result',result);
setappdata(handles.data_table,'index',index);


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile({'.csv','CSV files';});
save_info = strcat(path,file);
result = getappdata(handles.data_table,'result');
try
    records = fopen(save_info,'wt');
    for i = 1:20
        fprintf(records, '%s,%s,%f,%f\n',result{i,1},result{i,2},result{i,3},result{i,4});
    end
catch ME
    set(handles.status_indicator,'string','Save failed');
end
fclose(records);