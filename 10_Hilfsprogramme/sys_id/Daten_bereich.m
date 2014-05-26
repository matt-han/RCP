%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Daten_bereich.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion realisiert das Untermodul "Daten Bereich". In einem GUI
%                     werden Auswertbereich und Offsets der Eingangsdaten eingestellt.
%
%  Datum:             21-01-2003
%
%  Autor:             Jerzy Wykretowicz
%
%	Überarbeitung:		 René Nörenberg 29-03-2004 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = Daten_bereich(arg)

global d hp1 h0 H_mainAxes1 koordinaten
global optan defoptan

global xy cp  a1 a2 f2 l1 l2 l3 l4 l5 l6 e1 e2 e5 e6 s1 s2 s5 s6 pos1 pos2 tol stack sc
persistent ax2faktor

if(nargin==0)
   BA = 0.06;
   ax2faktor = 1.2;                     % Multiplikator für Axes2 'YLim' berechnung
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%        Figure                       %%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   f2 = figure('Units','Pixels', ...
      'Color',get(0,'defaultUicontrolBackgroundColor'), ...
      'Position',[80 100 900 510], ...
      'WindowButtonMotionFcn','',...
      'DoubleBuffer','on',...
      'CurrentObject',gcf,...
      'MenuBar','none',...
      'NumberTitle','off',...
      'Name',' Datenvorverarbeitung  - Auswertbereich',...
      'Tag','Fig2', ...
      'ToolBar','none');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%         Axes                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   a1 = axes('Parent',f2, ...
      'Units','normalized', ...
      'Color',[1 1 1], ...
      'Position',[0.05 0.5 0.7 0.45], ...
      'ButtonDownFcn','',...
      'Tag','Axes1');
   a2 = axes('Parent',f2, ...
      'Units','normalized', ...
      'Color',[1 1 1], ...
      'Position',[0.05 0.05 0.7 0.35], ...
      'Tag','Axes2');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%        Buttons                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   h1 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.83 .05 0.14 0.05], ...
      'String','Ok', ...
      'Callback','Daten_bereich ok',...
      'Tag','Pushbutton1');
   h1 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.83 .05+BA 0.14 0.05], ...
      'Callback','h = findobj( 0, ''Tag'',''Fig2'');close (h);',...
      'String','Abbrechen', ...
      'Tag','Pushbutton2');
   h1 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.83 .05+2*BA 0.14 0.05], ...
      'String','Zurück', ...
      'Callback','Daten_bereich zurueck',...
      'Tag','Pushbutton3');
   h1 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.83 .05+3*BA 0.14 0.05], ...
      'String','Übernehmen', ...
      'Callback','Daten_bereich uebernehmen',...
      'Tag','Pushbutton4');
   h1 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.83 .05+14*BA 0.14 0.05], ...
      'String','Auto-Null', ...
      'Callback','Autonullparameter',...
      'Tag','Pushbutton5');
  

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%        Edits & Sliders           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   e1 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'BackgroundColor',[1 1 1], ...
      'Position',[0.83 .05+10*BA 0.105 0.05], ...
      'Callback','Daten_bereich edit1',...
      'Style','edit', ...
      'Tag','EditText1');
   s1 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.83+0.11 0.05+10*BA 0.03 0.05], ...
      'Style','slider', ...
      'Callback','Daten_bereich slider1',...
      'Tag','Slider1');
   t1 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.77 0.04+10*BA 0.05 0.05], ...
      'String','    L :',...
      'HorizontalAlignment','right',...
      'Style','text', ...
      'Tag','text1');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   e2 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'BackgroundColor',[1 1 1], ...
      'Position',[0.83 .05+9*BA 0.105 0.05], ...
      'Callback','Daten_bereich edit2',...
      'Style','edit', ...
      'Tag','EditText1');
   s2 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.83+0.11 0.05+9*BA 0.03 0.05], ...
      'Style','slider', ...
      'Callback','Daten_bereich slider2',...
      'Tag','Slider1');
   t2 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.77 0.04+9*BA 0.05 0.05], ...
      'String','    R :',...
      'HorizontalAlignment','right',...
      'Style','text', ...
      'Tag','text2');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   e5 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'BackgroundColor',[1 1 1], ...
      'Position',[0.83 .05+12*BA 0.105 0.05], ...
      'Callback','Daten_bereich edit5',...
      'Style','edit', ...
      'Tag','EditText5');
   s5 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.83+0.11 0.05+12*BA 0.03 0.05], ...
      'Style','slider', ...
      'Callback','Daten_bereich slider5',...
      'Tag','Slider5');
   t5 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.76 0.04+12*BA 0.06 0.05], ...
      'HorizontalAlignment','right',...
      'String','Offset :',...
      'Style','text', ...
      'Tag','text5');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   e6 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'BackgroundColor',[1 1 1], ...
      'Position',[0.83 .05+5*BA 0.105 0.05], ...
      'Callback','Daten_bereich edit6',...
      'Style','edit', ...
      'Tag','EditText6');
   s6 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.83+0.11 0.05+5*BA 0.03 0.05], ...
      'Style','slider', ...
      'Callback','Daten_bereich slider6',...
      'Tag','Slider6');
   t6 = uicontrol('Parent',f2, ...
      'Units','normalized', ...
      'Position',[0.76 0.04+5*BA 0.06 0.05], ...
      'HorizontalAlignment','right',...
      'String','Offset :',...
      'Style','text', ...
      'Tag','text6');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   sc=1;
   stack(sc).t = d.t;
   stack(sc).u = d.uerr;
   stack(sc).y = d.ySystem;

   datalaenge = length(stack(sc).t);
   stack(sc).XLim = [0 stack(sc).t(datalaenge)];

   set(gcf,'CurrentAxes',a1 );          
   plot(stack(sc).t,stack(sc).y,'color',[0 0.5 0]);grid;
   set(a1,'XLim',stack(sc).XLim,'YLim',[-ax2faktor*abs(min(stack(sc).y)), ...
         										  ax2faktor*abs(max(stack(sc).y))]);
   title('Systemantwort','VerticalAlignment','baseline');
   stack(sc).YLim_y=get(a1,'YLim');

   set(gcf,'CurrentAxes',a2 );          
   plot(stack(sc).t,stack(sc).u,'color',[0 0.5 0]);grid;
   set(a2,'XLim',stack(sc).XLim,'YLim',[-ax2faktor*abs(min(stack(sc).u)), ...
         										  ax2faktor*abs(max(stack(sc).u))]);
   title('Erregung','VerticalAlignment','baseline');
   stack(sc).YLim_u=get(a2,'YLim');
   
   defoptan.tmin  = min(stack(sc).t);
	defoptan.tmax  = max(stack(sc).t);
	optan=defoptan; 

   Daten_bereich draw-lines;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%       Draw Range lines          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'draw-lines')
   tol = (stack(sc).XLim(2)-stack(sc).XLim(1))/100;        % Toleranz, verhindert Überlappung
                                                         % von Range-Linien 
   set(s1,'Max',stack(sc).XLim(2)-tol,'min',stack(sc).XLim(1),'Value',stack(sc).XLim(1));
   set(s2,'Max',stack(sc).XLim(2),'min',stack(sc).XLim(1)+tol,'Value',stack(sc).XLim(2));
   set(s5,'Max',stack(sc).YLim_y(2),'min',stack(sc).YLim_y(1),'Value',0);
   set(s6,'Max',stack(sc).YLim_u(2),'min',stack(sc).YLim_u(1),'Value',0);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   l1=line('parent',a1,...
      'XData',[stack(sc).XLim(1) stack(sc).XLim(1)],...
      'YData',stack(sc).YLim_y,...
      'Color','r',...
      'Tag','line1');
   val1 = get(l1,'XData');
   set(e1,'String',num2str(val1(1)));
   pos1 = val1(1); 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   l2=line('parent',a1,...
      'XData',[stack(sc).XLim(2) stack(sc).XLim(2)],...
      'YData',stack(sc).YLim_y,...
      'Color','r',...
      'Tag','line2');
   val2=get(l2,'XData');
   set(e2,'String',num2str(val2(1)));
   pos2 = val2(1); 

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   l3=line('parent',a2,...
      'XData',[stack(sc).XLim(1) stack(sc).XLim(1)],...
      'YData',stack(sc).YLim_u,...
      'Color','r',...
      'Tag','line3');
   val3 = get(l3,'XData');
   set(e1,'String',num2str(val3(1)));
   pos1 = val3(1); 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   l4=line('parent',a2,...
      'XData',[stack(sc).XLim(2) stack(sc).XLim(2)],...
      'YData',stack(sc).YLim_u,...
      'Color','r',...
      'Tag','line4');
   val4=get(l4,'XData');
   set(e2,'String',num2str(val4(1)));
   pos2 = val4(1); 

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   l5=line('parent',a1,...
      'XData',stack(sc).XLim,...
      'YData',[0 0],...
      'Color','b',...
      'Tag','line5');
   set(e5,'String',num2str(0));
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   l6=line('parent',a2,...
      'XData',stack(sc).XLim,...
      'YData',[0 0],...
      'Color','b',...
      'Tag','line6');
   set(e6,'String',num2str(0));

   set(f2,'WindowButtonMotionFcn','',...
      'WindowButtonDownFcn','Daten_bereich down')
   figure(f2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%        MouseButtonDown          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'down')
   if((strcmp(get(gco,'Tag'),'line1')) | (strcmp(get(gco,'Tag'),'line3')))
      set(f2,'Pointer','Crossh',...
         'DoubleBuffer','on',...
         'WindowButtonMotionFcn','Daten_bereich move1',...
         'WindowButtonUpFcn','Daten_bereich done1')
   elseif((strcmp(get(gco,'Tag'),'line2')) | (strcmp(get(gco,'Tag'),'line4')))
      set(f2,'Pointer','Crossh',...
         'DoubleBuffer','on',...
         'WindowButtonMotionFcn','Daten_bereich move2',...
         'WindowButtonUpFcn','Daten_bereich done2')
   elseif(strcmp(get(gco,'Tag'),'line5'))
      set(f2,'Pointer','Crossh',...
         'DoubleBuffer','on',...
         'WindowButtonMotionFcn','Daten_bereich move5',...
         'WindowButtonUpFcn','Daten_bereich done5')
   elseif(strcmp(get(gco,'Tag'),'line6'))
      set(f2,'Pointer','Crossh',...
         'DoubleBuffer','on',...
         'WindowButtonMotionFcn','Daten_bereich move6',...
         'WindowButtonUpFcn','Daten_bereich done6')
   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%        Mouse Move               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'move1')
   cp=get(gca,'CurrentPoint');
   if(cp(1,1) <= stack(sc).XLim(1))
      set(l1,'XData',[stack(sc).XLim(1) stack(sc).XLim(1)]);
      set(l3,'XData',[stack(sc).XLim(1) stack(sc).XLim(1)]);
      set(e1,'String',num2str(stack(sc).XLim(1)));
   elseif(cp(1,1) >= pos2-tol)
      set(l1,'XData',[pos2-tol pos2-tol]);
      set(l3,'XData',[pos2-tol pos2-tol]);
      set(e1,'String',num2str(pos2-tol));
   else
      set(l1,'XData',[cp(1,1) cp(1,1)]);
      set(l3,'XData',[cp(1,1) cp(1,1)]);
      set(e1,'String',num2str(cp(1,1)));
   end
elseif strcmp(arg,'move2')
   cp=get(gca,'CurrentPoint');
   if(cp(1,1) <= pos1+tol)
      set(l2,'XData',[pos1+tol pos1+tol]);
      set(l4,'XData',[pos1+tol pos1+tol]);
      set(e2,'String',num2str(pos1+tol));
   elseif(cp(1,1) >= stack(sc).XLim(2))
      set(l2,'XData',[stack(sc).XLim(2) stack(sc).XLim(2)]);
      set(l4,'XData',[stack(sc).XLim(2) stack(sc).XLim(2)]);
      set(e2,'String',num2str(stack(sc).XLim(2)));
   else
      set(l2,'XData',[cp(1,1) cp(1,1)]);
      set(l4,'XData',[cp(1,1) cp(1,1)]);
      set(e2,'String',num2str(cp(1,1)));
   end
elseif strcmp(arg,'move5')
   cp=get(gca,'CurrentPoint');
   if(cp(1,2) <= stack(sc).YLim_y(1))
      set(l5,'YData',[stack(sc).YLim_y(1) stack(sc).YLim_y(1)]);
      set(e5,'String',num2str(stack(sc).YLim_y(1)));
   elseif(cp(1,2) >= stack(sc).YLim_y(2))
      set(l5,'YData',[stack(sc).YLim_y(2) stack(sc).YLim_y(2)]);
      set(e5,'String',num2str(stack(sc).YLim_y(2)));
   else
      set(l5,'YData',[cp(1,2) cp(1,2)]);
      set(e5,'String',num2str(cp(1,2)));
   end
elseif strcmp(arg,'move6')
   cp=get(gca,'CurrentPoint');
   if(cp(1,2) <= stack(sc).YLim_u(1))
      set(l6,'YData',[stack(sc).YLim_u(1) stack(sc).YLim_u(1)]);
      set(e6,'String',num2str(stack(sc).YLim_u(1)));
   elseif(cp(1,2) >= stack(sc).YLim_u(2))
      set(l6,'YData',[stack(sc).YLim_u(2) stack(sc).YLim_u(2)]);
      set(e6,'String',num2str(stack(sc).YLim_u(2)));
   else
      set(l6,'YData',[cp(1,2) cp(1,2)]);
      set(e6,'String',num2str(cp(1,2)));
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%        MouseButtonUp            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'done1')
   if(cp(1,1) <= stack(sc).XLim(1))
      set(s1,'Value',stack(sc).XLim(1));    
      pos1=stack(sc).XLim(1);    
      set(s2,'Min',pos1+tol);
   elseif(cp(1,1) >= pos2-tol)
      set(s1,'Value',pos2-tol);    
      pos1= pos2-tol;    
     if((pos1+tol) == (get(s2,'Max')))
         set(s2,'Min',pos1+tol-0.01);
     else
         set(s2,'Min',pos1+tol);
     end
   else
      set(s1,'Value',cp(1,1));
      pos1= cp(1,1);   
      set(s2,'Min',pos1+tol);
   end
   set(gcf,'Pointer','arrow',...
      'WindowButtonMotionFcn','',...
      'WindowButtonDownFcn','Daten_bereich down',...
      'WindowButtonUpFcn','')
elseif strcmp(arg,'done2')
   if(cp(1,1) <= pos1+tol)
      set(s2,'Value',pos1+tol);    
      pos2= pos1+tol;
      if((pos2-tol) == (get(s1,'Min')))
         set(s1,'Max',pos2-tol+0.01);
      else
         set(s1,'Max',pos2-tol);
      end
   elseif(cp(1,1) >= stack(sc).XLim(2))
      set(s2,'Value',stack(sc).XLim(2));    
      pos2=stack(sc).XLim(2);    
      set(s1,'Max',pos2-tol);
   else
      set(s2,'Value',cp(1,1));    
      pos2= cp(1,1);   
      set(s1,'Max',pos2-tol);
   end
   set(gcf,'Pointer','arrow',...
      'WindowButtonMotionFcn','',...
      'WindowButtonDownFcn','Daten_bereich down',...
      'WindowButtonUpFcn','')
elseif strcmp(arg,'done5')
   if(cp(1,2) <= stack(sc).YLim_y(1))
      set(s5,'Value',stack(sc).YLim_y(1));    
   elseif(cp(1,2) >= stack(sc).YLim_y(2))
      set(s5,'Value',stack(sc).YLim_y(2));    
   else
      set(s5,'Value',cp(1,2));
   end
   set(gcf,'Pointer','arrow',...
      'WindowButtonMotionFcn','',...
      'WindowButtonDownFcn','Daten_bereich down',...
      'WindowButtonUpFcn','')
elseif strcmp(arg,'done6')
   if(cp(1,2) <= stack(sc).YLim_u(1))
      set(s6,'Value',stack(sc).YLim_u(1));    
   elseif(cp(1,2) >= stack(sc).YLim_u(2))
      set(s6,'Value',stack(sc).YLim_u(2));    
   else
      set(s6,'Value',cp(1,2));
   end
   set(gcf,'Pointer','arrow',...
      'WindowButtonMotionFcn','',...
      'WindowButtonDownFcn','Daten_bereich down',...
      'WindowButtonUpFcn','')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%        SlidersDown              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'slider1')
   tmp=get(s1,'Value');
   set(e1,'String',num2str(tmp));
   set(l1,'XData',[tmp tmp]);
   set(l3,'XData',[tmp tmp]);
   pos1=tmp;
   if((pos1+tol) == get(s2,'Max'))
      set(s2,'Min',pos1+tol*0.99);
   else    
      set(s2,'Min',pos1+tol);
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'slider2')
   tmp=get(s2,'Value');
   set(e2,'String',num2str(tmp));
   set(l2,'XData',[tmp tmp]);
   set(l4,'XData',[tmp tmp]);
   pos2=tmp;
   if((pos2-tol) == get(s1,'Min'))
      set(s1,'Max',pos2-tol*0.99);
   else    
      set(s1,'Max',pos2-tol);
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'slider5')
   tmp=get(s5,'Value');
   set(e5,'String',num2str(tmp));
   set(l5,'YData',[tmp tmp]);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'slider6')
   tmp=get(s6,'Value');
   set(e6,'String',num2str(tmp));
   set(l6,'YData',[tmp tmp]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%        GetEdit                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'edit1')
   tmp = str2num(get(e1,'String'));
   if(isreal(tmp)& isnumeric(tmp)& (length(tmp)==1)& (tmp>=stack(sc).XLim(1))&(tmp<=pos2-tol))
      set(s1,'Value',tmp);
      set(l1,'XData',[tmp tmp]);
      set(l3,'XData',[tmp tmp]);
      pos1=tmp;
      if((pos1+tol) == get(s2,'Max'))
         set(s2,'Min',pos1+tol*0.99);
      else    
         set(s2,'Min',pos1+tol);
      end
   else 
      set(e1,'String',num2str(get(s1,'Value')));
   end    
elseif strcmp(arg,'edit2')
   tmp = str2num(get(e2,'String'));
   if(isreal(tmp)& isnumeric(tmp)& (length(tmp)==1)& (tmp>=pos1+tol)&(tmp<=stack(sc).XLim(2)))
      set(s2,'Value',tmp);
      set(l2,'XData',[tmp tmp]);
      set(l4,'XData',[tmp tmp]);
      pos2=tmp;
      if((pos2-tol) == get(s1,'Min'))
         set(s1,'Max',pos2-tol*0.99);
      else    
         set(s1,'Max',pos2-tol);
      end
   else 
      set(e2,'String',num2str(get(s2,'Value')));
   end    
elseif strcmp(arg,'edit5')
   tmp = str2num(get(e5,'String'));
   if(isreal(tmp)& isnumeric(tmp)& (length(tmp)==1))
      set(s5,'Value',tmp);
      set(l5,'YData',[tmp tmp]);
   else 
      set(e5,'String',num2str(get(s5,'Value')));
   end    
elseif strcmp(arg,'edit6')
   tmp = str2num(get(e6,'String'));
   if(isreal(tmp)& isnumeric(tmp)& (length(tmp)==1))
      set(s6,'Value',tmp);
      set(l6,'YData',[tmp tmp]);
   else 
      set(e6,'String',num2str(get(s6,'Value')));
   end    

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%        Übernehmen               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'uebernehmen')
   datalaenge = length(stack(sc).t);                                   
   lindex = round(pos1/(stack(sc).t(datalaenge)/(datalaenge-1))+1);     %Indizies von neuen
   rindex = round(pos2/(stack(sc).t(datalaenge)/(datalaenge-1))+1);     % Koordinaten
   if((rindex-lindex) <= 1)
      id_warndlg=warndlg('Der ausgewählte databereich ist zu klein !',...
          'Datenvorverarbeitung Info !','on');
      set(id_warndlg,'Tag','warn_dlg','WindowStyle','modal');
      return;
   end
   stack(sc+1).t = stack(sc).t(lindex:rindex);            % neue Data arrays
   stack(sc+1).t = stack(sc+1).t-stack(sc+1).t(1);        % Startpunkt nach Null verschieben
   stack(sc+1).u = stack(sc).u(lindex:rindex);
   stack(sc+1).y = stack(sc).y(lindex:rindex);                          
   sc=sc+1;
   datalaenge = length(stack(sc).t);
   stack(sc).XLim = [0 stack(sc).t(datalaenge)];
   tmp=get(l5,'YData');
   if(tmp(1) ~= 0)                                         % Nullpunktverschiebung Axes1
      stack(sc).y = stack(sc).y - tmp(1);
   end
   tmp=get(l6,'YData');
   if(tmp(1) ~= 0)                                         % Nullpunktverschiebung Axes2
      stack(sc).u = stack(sc).u - tmp(1);
   end

   set(gcf,'CurrentAxes',a1);          
   plot(stack(sc).t,stack(sc).y,'color',[0 0.5 0]);grid;
   tmp=get(a1,'YLim');
   if(min(stack(sc).y) > 0)
      tmp(1)=0;
   end
   set(a1,'XLim',stack(sc).XLim,'YLim',tmp);
   title('Systemantwort','VerticalAlignment','baseline');

   set(gcf,'CurrentAxes',a2);          
   plot(stack(sc).t,stack(sc).u,'color',[0 0.5 0]);grid;
   tmp=abs(max(stack(sc).u));
   set(a2,'XLim',stack(sc).XLim,'YLim',[-ax2faktor*tmp ax2faktor*tmp]);
   title('Erregung','VerticalAlignment','baseline');
   stack(sc).YLim_y=get(a1,'YLim');
   stack(sc).YLim_u=get(a2,'YLim');
   
   
   Daten_bereich draw-lines;                                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%        Zurück                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'zurueck')
   if(sc > 1)
      sc = sc-1;
      set(gcf,'CurrentAxes',a1);          
      plot(stack(sc).t,stack(sc).y,'color',[0 0.5 0]);grid;
      set(a1,'XLim',stack(sc).XLim,'YLim',stack(sc).YLim_y);
      title('Systemantwort','VerticalAlignment','baseline');
      set(gcf,'CurrentAxes',a2);          
      plot(stack(sc).t,stack(sc).u,'color',[0 0.5 0]);grid;
      set(a2,'XLim',stack(sc).XLim,'YLim',stack(sc).YLim_u);
      title('Erregung','VerticalAlignment','baseline');
      

      Daten_bereich draw-lines;
   end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%        Ok                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(arg,'ok')
   if(sc==1)
      close(f2);
      return;
   end
   d.t = stack(sc).t;
   d.uerr = stack(sc).u;
   d.ySystem = stack(sc).y;
   d.XLim = stack(sc).XLim;
   d.YLim = [min(stack(sc).YLim_y(1) , min(stack(sc).u))  max(stack(sc).YLim_y(2) ,...
      max(stack(sc).u))];

   d.YLim(1) = d.YLim(1)-0.1*d.YLim(2);
   d.YLim(2) = 1.1*d.YLim(2);
   close(f2);
   figure(h0);
   set(gcf,'CurrentAxes',H_mainAxes1);          
   hp1=plot(d.t,d.uerr,d.t,d.ySystem);
   set(H_mainAxes1,'XLim',d.XLim,'YLim',d.YLim),grid;
   set(hp1,'LineWidth',1);
   legend('Erregung','Antwort',0);
   h_btn = findobj(0,'tag','Pushbutton_setparam');  % Erst wenn zu identifizierendes System
   set(h_btn,'enable','on');                        % geladen ist, kann man Modell-Fuktion
                                                    % bilden
   h_btn = findobj(0,'tag','Pushbutton_Bearbeiten');% Erst wenn zu identifizierendes System
   set(h_btn,'enable','on');                        % geladen ist, kann man es bearbeiten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

