%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Autonullparameter.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion stellt ein GUI zur Parametereingabe f�r die Berechnung 
%							 der neuen Nullpunkte des zu identifizierenden Systems da. 
%
%  Datum:             21-01-2003
%
%  Autor:             Ren� N�renberg
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fig = Autonullparameter()

global optan defoptan h_opt s5 l5 e5 s6 e6 l6 stack sc
BR      = 15;              
EW      = 70;              
POSITION    = [550 450 360 150];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        FIGURE               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h0 = figure('Units','pixels', ...
   'Color',get(0,'defaultUicontrolBackgroundColor'),...
   'Position',POSITION, ...
   'MenuBar','none',...
   'NumberTitle','off',...
   'WindowStyle','modal',...
   'Resize','off',...
   'Tag','options_fig', ...
   'Name',' Autonullparameter',...
   'ToolBar','none');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        FRAME                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h1 = uicontrol('Parent',h0, ...
   'Units','pixels', ...
   'Position',[BR BR+30 POSITION(3)-2*BR 100], ...
   'Style','frame', ...
   'Tag','Frame1');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        TEXT                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h1 = uicontrol('Parent',h0, ...
   'Units','pixels', ...
   'HorizontalAlignment','left', ...
   'Position',[2*BR 60 120 23], ...
   'String','t_min:', ...
   'Style','text', ...
   'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
   'Units','pixels', ...
   'HorizontalAlignment','left', ...
   'Position',[2*BR+160 60 120 23], ...
   'String',' t_max:', ...
   'Style','text', ...
   'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
   'Units','pixels', ...
   'HorizontalAlignment','left', ...
   'Position',[2*BR 60+40 240 25], ...
   'String',['Geben Sie einen Zeitbereich ein aus dem der Nullpunkt '...
   			'der Messdaten berechnet werden soll.'], ...
   'Style','text', ...
   'Tag','StaticText1');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        EDIT                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h_opt(1) = uicontrol('Parent',h0, ...
   'Units','pixels', ...
   'BackgroundColor',[1 1 1], ...
   'Position',[POSITION(3)-2*BR-260 60 100 23], ...
   'Style','edit', ...
   'HorizontalAlignment','right', ...
   'String',num2str(optan.tmin),...
   'Tag','Edit_iter');
h_opt(2) = uicontrol('Parent',h0, ...
   'Units','pixels', ...
   'BackgroundColor',[1 1 1], ...
   'Position',[POSITION(3)-2*BR-100 60 100 23], ...
   'Style','edit', ...
   'HorizontalAlignment','right', ...
   'String',num2str(optan.tmax),...
   'Tag','Edit_refresh');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        BUTTONS               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h1 = uicontrol('Parent',h0, ...
   'Units','pixels', ...
   'ListboxTop',0, ...
   'Position',[POSITION(3)-100-BR 10 100 25], ...
   'Callback','Autonull_check', ...
   'String','Ok', ...
   'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
   'Units','pixels', ...
   'Position',[BR 10 100 25], ...
   'Callback','close', ...
   'String','Abbrechen', ...
   'Tag','Pushbutton1');

if nargout > 0, fig = h0; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        ENDE                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
