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

% Last Modified by GUIDE v2.5 12-Nov-2015 14:55:54

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



function fourier_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fourier (see VARARGIN)

% Choose default command line output for fourier
handles.output = hObject;
panel = handles.panel_coeficientes;
handles.laxis = axes('parent',panel,'units','normalized','position',[0 0 1 1],'visible','off');
lbls = findobj(panel,'-regexp','tag','latex_*');
for i=1:length(lbls)
      l = lbls(i);
      % Get current text, position and tag
      set(l,'units','normalized');
      s = get(l,'string');
      p = get(l,'position');
      t = get(l,'tag');
      % Remove the UICONTROL
      delete(l);
      % Replace it with a TEXT object 
      handles.(t) = text(p(1),p(2),s,'interpreter','latex');
end
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = fourier_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function updateInformationText(Ao,An,Bn,Fs,handles)

P = strcat('$$', 'A_0 = ', char(latex(Ao)),'$$');
set(handles.latex_a_cero,'String',P);
P = strcat('$$', 'A_n = ', char(latex(An)),'$$');
set(handles.latex_a_ns,'String',P);
P = strcat('$$', 'B_n = ', char(latex(Bn)),'$$');
set(handles.latex_b_ns,'String',P);
P = strcat('$$', 'Serie = ', char(latex(Fs)),'$$');
set(handles.latex_fourier_sum_text,'String',P);

function clear_graph(axes)
hold(axes,'on')
delete(allchild(axes));
hold(axes,'off')

function An = a_n(f,t,i,A)
    T = max(A) - min(A);
    L = T/2;
    An = simplify(int(f*cos(i*pi*t/L)/L,t,min(A),max(A)));
    
function Bn = b_n(f,t,i,A)
    T = max(A) - min(A);
    L = T/2;
    Bn = simplify(int(f*sin(i*pi*t/L)/L,t,min(A),max(A)));
   
   % donde n = numero de armonicas 
function sum = fourier_sum(f,t,n,A)
    syms q
    assume(q,'integer');
    L = (max(A) - min(A))/2;
    sum = a_n(f,t,0,A)/2 + symsum(a_n(f,t,q,A)*cos(q*pi*t/L) + b_n(f,t,q,A)*sin(q*pi*t/L),q,1,n);
        
% A = intervalo, f = funcion
function graficar(A,f,handles)
syms x
axes(handles.function_graph)
clear_graph(handles.function_graph)
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
    
    
function CALCULAR_Callback(hObject, eventdata, handles)
clc
syms n t fs
assume(n,'integer');
A = str2num(get(handles.INTERVALOS, 'String'));
f = evalin(symengine,get(handles.ECUACION, 'String'));
graficar(A,f,handles)
armonicas = str2num(get(handles.ARMONICOS, 'String'));

Ao = a_n(f,t,0,A);
An = a_n(f,t,n,A);
Bn = b_n(f,t,n,A);
Fs = fourier_sum(f,t,armonicas,A);
updateInformationText(Ao,An,Bn,Fs,handles);

axes(handles.sumas_fourier)
ezplot(Fs)

axes(handles.coeficientes_axis)
ns = 1:armonicas;
stem(ns,subs(Bn,ns),'filled'); hold on;
stem(ns,subs(An,ns),'filled'); hold off





function ECUACION_Callback(hObject, eventdata, handles)


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



function INTERVALOS_Callback(hObject, eventdata, handles)

function INTERVALOS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ARMONICOS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function function_graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to function_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
axes(hObject)
set(hObject, 'visible', 'on')
grid on
xlabel('\bfTIEMPO');
ylabel('\bfAMPLITUD');
title('\bfFuncion');


% --- Executes during object creation, after setting all properties.
function sumas_fourier_CreateFcn(hObject, eventdata, handles)
   axes(hObject)
   set(hObject, 'visible', 'on')
   grid on
   title('\bfSumas de Fourier')  
   xlabel('\bf TIEMPO');
   ylabel('\bf AMPLITUD');

% --- Executes on button press in boton_armonicos.
function boton_armonicos_Callback(hObject, eventdata, handles)
% hObject    handle to boton_armonicos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
syms f fn t n
f = evalin(symengine,get(handles.ECUACION, 'String'));
A = str2num(get(handles.INTERVALOS, 'String'));

for n=1:50;
    fn = fourier_sum(f,t,n,A);
    Error = int(abs(subs(f) - subs(fn)), t, min(A), max(A))/int(abs(subs(f)), t, min(A), max(A));
    ErrorRelativo = subs(vpa(Error,5),'n',n);
    if lt(ErrorRelativo,0.05499)
        CantidadDeArmonicos = n;
        break;
    end
end
P = strcat('Arm�nicos=', num2str(CantidadDeArmonicos));
set(handles.error_text,'String', P);


function ARMONICOS_Callback(hObject, eventdata, handles)
% hObject    handle to ARMONICOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ARMONICOS as text
%        str2double(get(hObject,'String')) returns contents of ARMONICOS as a double
