%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Daten_laden.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion realisiert das Modul "Daten laden". Die Daten werden 
%                     aus einer Datei oder aus Matlab Workspace geladen.
%
%  Datum:             21-01-2003
%
%  Autor:             Jerzy Wykretowicz
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Daten_laden()

global d koordinaten H_mainAxes1

d.t=[];
d.uerr=[];
d.ySystem=[];
d.integral=0;
d.differential=0;

htmp=findobj(0,'Tag','PopupMenu_Laden1');
action=get(htmp,'Value');
set(htmp,'Value',1);
set(gcf,'CurrentAxes',H_mainAxes1);

if(action==3)                                                  % Variablen aus  Datei laden 
   [fname,pname] = uigetfile('*.mat','Data Import');           % 'Datei öffnen' Dialog
   if(fname)                                                   % wenn Dateiname gültig:
      load([pname fname],'t','uerr','ySystem'),                % Variablen laden
      if~(exist('t')& exist('uerr')& exist('ySystem'))         % wenn Variable nicht vorhanden
         id_errordlg=errordlg(['Vektoren: t, uerr, ySystem in Datei ' fname ...
            ' nicht vorhanden!'],'Data Error','on');
         set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');
         return;
      else 
         d.t=t;
         d.uerr=uerr;
         d.ySystem=ySystem;
      end
   else
      return;
   end
elseif(action==1)
   return;
elseif(action==2)
   try
      d.t = evalin('base','t');    
      d.uerr = evalin('base','uerr');    
      d.ySystem = evalin('base','ySystem');
   catch
      id_errordlg=errordlg('Daten im Workspace nicht vorhanden!','Laden Fehler !','on');
      set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');
      return;
   end    
end
 
legend('off');
cla;

[m,n]=size(d.ySystem);        
if(m>n)
   d.t=d.t';
   d.uerr=d.uerr';
   d.ySystem=d.ySystem';
end   
if((length(d.t)~=length(d.uerr)) | (length(d.t)~=length(d.ySystem)))
   id_errordlg=errordlg('Variablen: t, uerr, ySystem haben unterschiedlichen Längen !',...
   'Data Error','on');
   set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');
   return;    
end
t_old=d.t;
uerr_old=d.uerr;
ySystem_old=d.ySystem;
xmin=min(d.t);
xmax=max(d.t);
yaxe(1)=min(d.ySystem)-0.1*abs(min(d.ySystem));
yaxe(2)=min(d.uerr)-0.1*abs(min(d.uerr));
yaxe(3)=max(d.ySystem)+0.1*abs(max(d.ySystem));
yaxe(4)=max(d.uerr)+0.1*abs(max(d.uerr));
ymin=min(yaxe);
ymax=max(yaxe);
koordinaten=[xmin xmax ymin ymax];

set_parameter('Reset',0,0,0);

set(gcf,'CurrentAxes',H_mainAxes1);          
hp1=plot(d.t,d.uerr,d.t,d.ySystem);
axis(koordinaten);
d.XLim = get(H_mainAxes1,'XLim');
d.YLim = get(H_mainAxes1,'YLim');
grid;
set(hp1,'LineWidth',1);
legend('Erregung','Antwort',0);

h_btn = findobj(0,'tag','Pushbutton_setparam');  % Erst wenn zu identifizierendes System
set(h_btn,'enable','on');                        % geladen ist, kann man Modell-Fuktion bilden
h_btn = findobj(0,'tag','Pushbutton_Bearbeiten');% Erst wenn zu identifizierendes System
set(h_btn,'enable','on');                        % geladen ist, kann man es bearbeiten
set(findobj(0,'Tag','PopupMenu_Bearbeiten'),'enable','on');
set(findobj(0,'Tag','Pushbutton_DatenSpeichern'),'enable','on');
