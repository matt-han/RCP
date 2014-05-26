%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Daten_dezimieren.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion realisiert das Untermodul "Daten_dezimieren". In einem
%                     GUI wird der Dezimierungsfaktor eingestellt.
%
%  Datum:             21-01-2003
%
%  Autor:             Jerzy Wykretowicz
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Daten_dezimieren(arg)

global d hp1 h0 H_mainAxes1 
persistent ok f4 e1 

tmp = length(d.t);
if(tmp < 10)
   id_msgdlg=warndlg('Minimale Anzahl von Abtastwerten.Dezimierung nicht möglich!','INFO');
   set(id_msgdlg,'WindowStyle','modal');
   return;
end
max = fix(tmp/10);   
if(nargin==0)
   BR=15;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%        Figure                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   f4 = figure('Units','Pixels', ...
      'Color',get(0,'defaultUicontrolBackgroundColor'), ...
      'Position',[500 400 320 100], ...
      'DoubleBuffer','on',...
      'Resize','off',...
      'WindowStyle','modal',...
      'CurrentObject',gcf,...
      'MenuBar','none',...
      'NumberTitle','off',...
      'Name',' Abtastwerte Dezimierung',...
      'Tag','Fig3', ...
      'ToolBar','none');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%        Edit                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   t1 = uicontrol('Parent',f4, ...
      'Units','Pixels', ...
      'Position',[2*BR 4*BR 200 20], ...
      'String',['Dezimierungsfaktor (max ',num2str(max),') :'],...
      'HorizontalAlignment','left',...
      'Style','text', ...
      'Tag','text1');
   e1 = uicontrol('Parent',f4, ...
      'Units','Pixels', ...
      'BackgroundColor',[1 1 1], ...
      'Position',[2*BR+200 4*BR+2 60 23], ...
      'HorizontalAlignment','right',...
      'String','1',...
      'Style','edit', ...
      'Tag','EditText1');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%        Buttons                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   h1 = uicontrol('Parent',f4, ...
      'Units','Pixels', ...
      'Position',[2*BR+140 BR 120 25], ...
      'String','Ok', ...
      'Callback','Daten_dezimieren ok',...
      'Tag','Pushbutton1');
   h1 = uicontrol('Parent',f4, ...
      'Units','Pixels', ...
      'Position',[2*BR BR 120 25], ...
      'Callback','h = findobj( 0, ''Tag'',''Fig3'');close (h);',...
      'String','Abbrechen', ...
      'Tag','Pushbutton2');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%        Ok                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'ok')
   num  = str2num(get(e1,'String'));
   if(num > max)
      num = max;
      set(e1,'String',num2str(num));
      return;
   end
   if (isreal(num) & isnumeric(num) & (length(num)==1) & (num >= 1))
      num = round(num);
      ende = length(d.t);
      t_tmp = d.t(1);
      u_tmp = d.uerr(1);
      y_tmp = d.ySystem(1);
      for i=1:num:ende;
         t_tmp = [t_tmp,d.t(i)];
         u_tmp = [u_tmp,d.uerr(i)];
         y_tmp = [y_tmp,d.ySystem(i)];
      end
      d.t = t_tmp;
      d.uerr = u_tmp;
      d.ySystem = y_tmp;
      d.t(1) = [];
      d.uerr(1) = [];
      d.ySystem(1) = [];
      close(f4);
      figure(h0);
      set(gcf,'CurrentAxes',H_mainAxes1);          
      hp1=plot(d.t,d.uerr,d.t,d.ySystem);
      datalaenge = length(d.t);
      d.XLim = [0 d.t(datalaenge)];
      set(H_mainAxes1,'XLim',d.XLim,'YLim',d.YLim);
      grid;
      set(hp1,'LineWidth',1);
      legend('Erregung','Antwort',0);
      a1=size(d.t);
      a2=size(d.uerr);
      a3=size(d.ySystem);
 
   end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
