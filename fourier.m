function varargout = fourier(varargin)
% FOURIER MATLAB code for fourier.fig
%      FOURIER, by itself, creates a new FOURIER or raises the existing
%      singleton*.
%
%      H = FOURIER returns the handle to a new FOURIER or the handle to
%      the existing singleton*.
%
%      FOURIER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOURIER.M with the given input arguments.
%
%      FOURIER('Property','Value',...) creates a new FOURIER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fourier_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fourier_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fourier

% Last Modified by GUIDE v2.5 11-Mar-2013 19:31:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fourier_OpeningFcn, ...
                   'gui_OutputFcn',  @fourier_OutputFcn, ...
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


% --- Executes just before fourier is made visible.
function fourier_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fourier (see VARARGIN)

% Choose default command line output for fourier
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% set(handles.axes1,'Visible','off');
% set(handles.axes2,'Visible','off');


% UIWAIT makes fourier wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fourier_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CALCULAR.
function CALCULAR_Callback(hObject, eventdata, handles)
% hObject    handle to CALCULAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
syms n wt t 
set(handles.axes2, 'Visible', 'off')
% set(handles.axes3, 'visible', 'on')
% set(handles.axes4, 'visible', 'on')
% set(handles.axes5, 'visible', 'on')
global A f
f = sym(f);
T = max(A)-min(A);
wo = 2*pi/(T);
Ao = 0;
for i=1:length(f)
   Ao = Ao +int(f(i),'t', A(i), A(i+1));
end
Ao = simplify(Ao/T)


An = 0;
wo = 2*pi/T;
for i=1:length(f)
   An = An +int(f(i)*cos(n*wo*t), A(i), A(i+1));
end
An = simplify(2*An/T)

Bn = 0;
for i=1:length(f)
   Bn = Bn +int(f(i)*sin(n*wo*t), A(i), A(i+1));
end
Bn = simplify(2*Bn/T);
% % 
%An = char(An);
%Bn = char(Bn);
%An = simplifyfraction(sym(strrep(char(An), 'sin(pi*n)', '0')));
%Bn = simplifyfraction(sym(strrep(char(Bn), 'sin(pi*n)', '0')));

%An = simplifyfraction(sym(strrep(char(An), 'cos(pi*n)', '(-1)^n')));
%Bn = simplifyfraction(sym(strrep(char(Bn), 'cos(pi*n)', '(-1)^n')));

%An = simplifyfraction(sym(strrep(char(An), 'sin(2*pi*n)', '0')));
%Bn = simplifyfraction(sym(strrep(char(Bn), 'sin(2*pi*n)', '0')));

%An = simplifyfraction(sym(strrep(char(An), 'cos(2*pi*n)', '1')));
%Bn = simplifyfraction(sym(strrep(char(Bn), 'cos(2*pi*n)', '1')));



axes(handles.axes2);
cla
P = strcat('$$', 'A_0 = ', char(latex(Ao)),'$$');
text('Interpreter','latex',...
	'String',P,...
	'Position',[0 .9],...
	'FontSize',14);
P = strcat('$$', 'A_n = ', char(latex(An)),'$$');
text('Interpreter','latex',...
	'String',P,...
	'Position',[0 .6],...
	'FontSize',14);

P = strcat('$$', 'B_n = ', char(latex(Bn)),'$$');
text('Interpreter','latex',...
	'String',P,...
	'Position',[0 .3],...
	'FontSize',14);
syms n 
a = str2num(get(handles.ARMONICOS, 'String'));
t = linspace(min(A)-T, max(A)+T,1000);
ft = zeros(a, 1000);
% set(handles.axes3, 'visible', 'on')
% set(handles.axes4, 'visible', 'on')
% set(handles.axes5, 'visible', 'on')
for i=1:a
%     axes(handles.axes3);
%     title('\bfAMPLITUD ARMONICOS')
%    xlim([1 a])
   ft(i,:) = (subs(Bn, 'n', i).*sin(i*wo*t))+(subs(An, 'n', i).*cos(i*wo*t));
   axes(handles.axes4)
   set(handles.axes4, 'visible', 'on')
    plot(t, Ao+sum(ft),'Color', 'b', 'Linewidth', 1.3); 
   title('\bfSEÑALES SINUSOIDALES SUMADAS')
  
   xlim([min(t) max(t)])
   xlabel('\bfARMONICO');
   ylabel('\bftiempo');
   zlabel('\bfAMPLITUD')
   hold on
%    box on
%    grid on
   axes(handles.axes5)
   set(handles.axes5, 'visible', 'on')
   plot(t, ft(i,:),'Color','b', 'Linewidth', 1.3)
   title('\bfSEÑALES SINUSOIDALES SIMPLES')
   
   xlim([min(t) max(t)])
   hold on
%    box on
%    grid on
   xlabel('\bfARMONICO');
   ylabel('\bftiempo');
   zlabel('\bfAMPLITUD');
   Cn(i) = sqrt(subs(Bn, 'n', i)^2+subs(An, 'n', i)^2);
   axes(handles.axes3)
   set(handles.axes3, 'visible', 'on')
    stem(Cn,'fill','r', 'Linewidth', 2)
   hold on; grid on
    title('\bfAMPLITUD ARMONICOS')
   xlim([1 a])
   
   pause(0.001)
end
axes(handles.axes4)
   plot(t, Ao+sum(ft), 'r','Linewidth', 2);

  



function ECUACION_Callback(hObject, eventdata, handles)
% hObject    handle to ECUACION (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ECUACION as text
%        str2double(get(hObject,'String')) returns contents of ECUACION as a double


% --- Executes during object creation, after setting all properties.
function ECUACION_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ECUACION (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GRAFICAR.
function GRAFICAR_Callback(hObject, eventdata, handles)
% hObject    handle to GRAFICAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A f ctrl
syms x t

clc
axes(handles.axes1)
set(handles.axes1, 'visible', 'on')
cla
A = str2num(get(handles.INTERVALOS, 'String'));
f = eval(get(handles.ECUACION, 'String'));
x = linspace(min(A), max(A), 1000);
fx = 0;
for i=1:length(A)-1
    if mod(i, 2) == 1
    fx = fx+((x>=A(i))&(x<=A(i+1))).*subs(f(i),x);
    else
    fx = fx+((x>A(i))&(x<A(i+1))).*subs(f(i),x);
    end
end
plot(x, fx, 'Linewidth', 2); hold on
plot(x+max(x)-min(x), fx, 'Linewidth', 2) 
plot(x-max(x)+min(x), fx, 'Linewidth', 2)
plot([max(x) max(x)],[fx(1) fx(end)], 'linewidth', 2)
plot([min(x) min(x)],[fx(end) fx(1)], 'linewidth', 2)
grid on
xlabel('\bfTIEMPO');
ylabel('\bfAMPLITUD');
title('\bfGRAFICA DE LA FUNCION');
T = max(x)-min(x);




function INTERVALOS_Callback(hObject, eventdata, handles)
% hObject    handle to INTERVALOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INTERVALOS as text
%        str2double(get(hObject,'String')) returns contents of INTERVALOS as a double


% --- Executes during object creation, after setting all properties.
function INTERVALOS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INTERVALOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ARMONICOS_Callback(hObject, eventdata, handles)
% hObject    handle to ARMONICOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ARMONICOS as text
%        str2double(get(hObject,'String')) returns contents of ARMONICOS as a double


% --- Executes during object creation, after setting all properties.
function ARMONICOS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ARMONICOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3
