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

% Last Modified by GUIDE v2.5 09-Nov-2015 20:00:51

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

function updateCoeficientText(Ao,An,Bn,handles)
P = strcat('$$', 'A_0 = ', char(latex(Ao)),'$$');
set(handles.latex_a_cero,'String',P);
P = strcat('$$', 'A_n = ', char(latex(An)),'$$');
set(handles.latex_a_ns,'String',P);
P = strcat('$$', 'B_n = ', char(latex(Bn)),'$$');
set(handles.latex_b_ns,'String',P);

function clear_graph(axes)
hold(axes,'on')
delete(allchild(axes));
hold(axes,'off')

function An = a_n(f,t,i,L)
    An = int(f*cos(i*pi*t/L)/L,t,-L,L);
    
function Bn = b_n(f,t,i,L)
    Bn = int(f*sin(i*pi*t/L)/L,t,-L,L);
    
    
function sum = fourier_sum(f,t,n,L)
    %%no me deja usar i para subindices <.< asi que uso k
    sum = a(f,t,0,L)/2 + symsum(a(f,t,k,L)*cos(k*pi*t/L) + b(f,t,k,L)*sin(k*pi*t/L),k,1,n);
        
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
    
    
function CALCULAR_Callback(hObject, eventdata, handles)
clc
syms n wt t 
A = str2num(get(handles.INTERVALOS, 'String'));
f = eval(get(handles.ECUACION, 'String'));
graficar(A,f,handles)

f = sym(f);
T = max(A)-min(A);


wo = 2*pi/(T);
Ao = 0;
for i=1:length(f)
   Ao = Ao +int(f(i),'t', A(i), A(i+1));
end
Ao = simplify(Ao/T);


An = 0;
wo = 2*pi/T;
evalin(symengine,'assume(k,Type::Integer)');
for i=1:length(f)
   An = An +int(f(i)*cos(n*wo*t), A(i), A(i+1));
end
An = simplify(2*An/T);

Bn = 0;
for i=1:length(f)
   Bn = Bn +int(f(i)*sin(n*wo*t), A(i), A(i+1));
end
Bn = simplify(2*Bn/T);

updateCoeficientText(Ao,An,Bn,handles);

syms n 
a = str2num(get(handles.ARMONICOS, 'String'));
t = linspace(min(A)-T, max(A)+T,1000);
ft = zeros(a, 1000); 
for i=1:a
   ft(i,:) = (subs(Bn, 'n', i).*sin(i*wo*t))+(subs(An, 'n', i).*cos(i*wo*t));
   %%Plot fourier sums
   axes(handles.sumas_fourier)  
   clear_graph(handles.sumas_fourier);
   xlim([min(t) max(t)])
    plot(t, Ao+sum(ft),'Color', 'b', 'Linewidth', 1.3); 

   
   hold on
   %%%Espectro de amplitud
   Cn(i) = sqrt(subs(Bn, 'n', i)^2+subs(An, 'n', i)^2);
   axes(handles.axes3)
   clear_graph(handles.axes3);
   set(handles.axes3, 'visible', 'on')
    stem(Cn,'fill','r', 'Linewidth', 2)
   hold on; grid on
    title('\bfEspectro de Amplitud')
   xlim([1 a])
   
   pause(0.001) 
end
axes(handles.sumas_fourier)
   plot(t, Ao+sum(ft), 'r','Linewidth', 2); 





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



function ARMONICOS_Callback(hObject, eventdata, handles)

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
   set(handles.sumas_fourier, 'visible', 'on')
   grid on
   title('\bfSumas de Fourier')  
   xlabel('\bf TIEMPO');
   ylabel('\bf AMPLITUD');
