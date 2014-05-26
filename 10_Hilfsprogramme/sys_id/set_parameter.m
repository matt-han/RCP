%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         set_parameter.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion wird als sog. "Switchyard function" realisiert. Hier 
%                     werden die meisten Variablen und Graphiken initialisiert und 
%                     aktualisiert. 
%
%  Datum:             21-01-2003
%
%  Autor:             Jerzy Wykretowicz
%
%  Überarbeitet:      09-04-2004, René Nörenberg
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_parameter(action,nr,tx,dx)

global h0 param2 n_counter d_counter n_anfang2 d_anfang2 p_anf2 p_anf3
global ySystem t uerr H_mainAxes1 H_mainAxes2 h_tp h_dp h_vp h_ic order
global t_index d_index mainData  koordinaten ok p n_end2 d_end2
global iterator faktor counter h_patch h_iterEdit  oldX oldValue
global  opt d iz bildzahl bildzaehler h_histView; % Übergabeparameter an das Programm "zielfkt"

persistent psc paramstack  breakLineY num_sp  longtext shorttext
                                                                    %bildzahl=1;
bildzaehler=0;
ok=0;                      % globale Variable um 'fminsearch'-funktion zu unterbrechen
integrator=0;
n_end2=1;
d_end2=1;
NUM    = 1;                                 % Indizies von 'mainData' cell array
NUM_VN = 2;                                 %
DEN    = 3;                                 %
DEN_VN = 4;                                 %
if strcmp(action,'initialize')
   set(0,'ShowHiddenHandles','on');         %  Option "off" verhindert zoomen von 'mainAxes3'
   H_mainAxes2 = findobj( 0, 'Tag' , 'mainAxes2');
   set(gcf,'CurrentAxes',H_mainAxes2 );          

   counter=1;

   mainData = cell(4,9);
   mainData(1,:)={[1]};
   mainData(3,:)={[1]};

   t_index = 1;                                        % Indizies von 'T'-Parametern
   d_index = 1;                                        % Indizies von 'd'-Parametern
   n_counter = 1;                                      % Zähler der Zählerelementen
   d_counter = 1;                                      % Zähler der Nennerelementen
   shorttext = 70;                                   % Länge von kürzem Text
   longtext  = 140;                                   % Länge von langem Text
   startpoint = 60;                                  % X Koordinate des Bruchstriches
   num_sp = 106;                                      % Y Koordinate des Zählers
   breakLineY = 50;                                    % Y Koordinate des Bruchstriches

   start_poly(1) = {[1 0]};                      % Anfangswerte 's'- oder '1/s'-Parametern
   start_poly(2) = {[1 0 0]};
   start_poly(3) = {[1 0 0 0]};
   start_poly(4) = {[1 0 0 0 0]};
   start_poly(5) = {[1 0 0 0 0 0]};

   cla

   %%%%% 's'-Elemente im Zähler und Nenner kürzen
   order = param2-1;
   tmp = min(order(2),order(3));
   order(2) = order(2) - tmp;
   order(3) = order(3) - tmp;

   %%%%% Bruchstrichlänge berechnen
   linelength = max(order(6)+(order(7)*2),(order(2)>0)+order(4)+(order(5)*2));
   if linelength > 5
      linelength = 5;
   end
   %%%%% Zähler-, Nennerposition berechnen
   num_sp = ((linelength-((order(2)>0)+order(4)+(order(5)*2)))/2)*shorttext;
   den_sp = ((linelength-(order(6)+(order(7)*2)))/2)*shorttext;

   %%%%% V %%%%%
   if order(1) > 0                                                 
      id_text2 = text(startpoint,breakLineY,'\bf\fontsize{12}V','EraseMode','background');
      startpoint = startpoint + 35;
      set(h_vp(1),'enable','on',...
         'String','1',...
         'BackgroundColor','w');
      set(h_vp(2),'enable','on'); 
   else
      set(h_vp(1),'enable','off',...
         'String','','BackgroundColor',...
         get(0,'defaultUicontrolBackgroundColor'));                                          
     
      set(h_vp(2),'enable','off');                                          
   end
   %%%%% 1/s %%%%%         vertauschte Reihenfolge wegen Koordinatenberechnung von Textstrings
   if order(3) > 0
      mainData(DEN,2)= start_poly(order(3));

      sd_string = {['\bf\fontsize{10}s^{\fontsize{6}',num2str(order(3)),'}']};
      if order(3)==1
         sd_string = {'\bf\fontsize{10}s'};
      end
      text(startpoint,breakLineY-18, sd_string,...
         'EraseMode','background',...
         'HorizontalAlignment','center');
         
      tmpline=line([startpoint-10, startpoint+10],[breakLineY, breakLineY],[0 0],'Color','k');
      text(startpoint,breakLineY+15,'\bf\fontsize{10}  1  ',...
         'EraseMode','background',...
         'HorizontalAlignment','center');            
      startpoint = startpoint + 35;        
      set(h_ic,'enable','on');    
   end
   num_sp = num_sp + startpoint;
   den_sp = den_sp + startpoint;

   %%%%% s %%%%%
   if order(2) > 0
      mainData(NUM,2)= start_poly(order(2));
      sn_string = {['\bf\fontsize{10}     s^{\fontsize{6}',num2str(order(2)),'}']};
      if order(2)==1
         sn_string = {'\bf\fontsize{10}     s'};
      end
      id_text3 = text(num_sp+35,breakLineY+15, sn_string,...
         'EraseMode','background',...
         'HorizontalAlignment','center');
      num_sp = num_sp + shorttext;
   end

   %%%%% (1+sT) %%%%%    
   if order(4) > 0
      for i=1:order(4)
         mainData(NUM,2+i)= { [1 1] };
         sn_string = {['\fontsize{10}(\bf1+sT_{\fontsize{7}',num2str(t_index),'}\rm)']};
         id_text4(i) = text(num_sp+35,breakLineY+15, sn_string,...
            'EraseMode','background',...
            'HorizontalAlignment','center');
         set(h_tp(t_index,1),'enable','on',...
            'String','1',...
            'UserData',struct('line',1,'row',2+i,'oldval','1'),...
            'BackgroundColor','w');                                          
         set(h_tp(t_index,2),'enable','on');          
         t_index = t_index + 1;
         num_sp = num_sp + shorttext;
      end
   end

   %%%%% (1+2dTs+(Ts)^2) %%%%%    
   if order(5) > 0
      for i=1:order(5)
         mainData(NUM,7+i)= { [1 2 1] };
         mainData(NUM_VN,7+i)= { [1 1] };
         sn_string = {['\fontsize{10}(\bf1+2d_{\fontsize{7}',num2str(d_index),...
            '}T_{\fontsize{7}',num2str(t_index),...
            '}s+(T_{\fontsize{7}',num2str(t_index),...
            '}s)^{\bf\fontsize{7}2}\rm)']};
         id_text5(i) = text(num_sp+70,breakLineY+15, sn_string,...
            'EraseMode','background',...
            'HorizontalAlignment','center');
         set(h_tp(t_index,1),'enable','on',...
            'String','1',...
            'UserData',struct('line',1,'row',7+i,'oldval','1'),...
            'BackgroundColor','w');                                          
         set(h_tp(t_index,2),'enable','on');          
         set(h_dp(d_index,1),'enable','on',...
            'String','1',...
            'UserData',struct('line',1,'row',7+i,'oldval','1'),...
            'BackgroundColor','w');                                          
         set(h_dp(d_index,2),'enable','on');          
         t_index = t_index + 1;
         d_index = d_index + 1;
         num_sp = num_sp + longtext;
      end
   end

   %%%%% 1/(1+sT) %%%%%    
   if order(6) > 0
      for i=1:order(6)
         mainData(DEN,2+i)= { [1 1] };
         sd_string = {['\fontsize{10}(\bf1+sT_{\fontsize{7}',num2str(t_index),'}\rm)']};
         id_text6(i) = text(den_sp+35,breakLineY-22, sd_string,...
            'EraseMode','background',...
            'HorizontalAlignment','center');
         set(h_tp(t_index,1),'enable','on',...
            'String','1',...
            'UserData',struct('line',3,'row',2+i,'oldval','1'),...
            'BackgroundColor','w');                                          
         set(h_tp(t_index,2),'enable','on');          
         t_index = t_index + 1;
         den_sp = den_sp + shorttext;
      end
   end

   %%%%% 1/(1+2dTs+(Ts)^2) %%%%%    
   if order(7) > 0
      for i=1:order(7)
         mainData(DEN,7+i)= { [1 2 1] };
         mainData(DEN_VN,7+i)= { [1 1] };
         sd_string = {['\fontsize{10} (\bf1+2d_{\fontsize{7}',num2str(d_index),...
            '}T_{\fontsize{7}',num2str(t_index),...
            '}s+(T_{\fontsize{7}',num2str(t_index),...
            '}s)^{\bf\fontsize{7}2}\rm)']};
         id_text6(i) = text(den_sp+70,breakLineY-22, sd_string,...
            'EraseMode','background',...
            'HorizontalAlignment','center');
         set(h_tp(t_index,1),'enable','on',...
            'String','1',...
            'UserData',struct('line',3,'row',7+i,'oldval','1'),...
            'BackgroundColor','w');                                          
         set(h_tp(t_index,2),'enable','on');          
         set(h_dp(d_index,1),'enable','on',...
            'String','1',...
            'UserData',struct('line',3,'row',7+i,'oldval','1'),...
            'BackgroundColor','w');                                          
         set(h_dp(d_index,2),'enable','on');          
         t_index = t_index + 1;
         d_index = d_index + 1;
         den_sp = den_sp + longtext;
     end
   end
   %%%%% Übrige Textobjekte disablen %%%%%

   for i=t_index:10
      set(h_tp(i,1),'enable','off',...
         'String','',...
         'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));               
      set(h_tp(i,2),'enable','off');
   end
   for i=d_index:4
      set(h_dp(i,1),'enable','off',...
         'String','',...
         'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));       
      set(h_dp(i,2),'enable','off');          
   end
   %%%%% Sonderfall: 1 im Zähler %%%%%
   if (order(2)+order(4)+order(5) == 0) & (order(6)+order(7) > 0)
      text(num_sp-5,breakLineY+15,'\bf\fontsize{10}1',...
         'HorizontalAlignment','center');
   end

   %%%%% Sonderfall: 1 im Nenner %%%%%
   if (order(4)+order(5) > 0) & (order(6)+order(7) == 0)
      text(den_sp-5,breakLineY-15,'\bf\fontsize{10}1',...
         'HorizontalAlignment','center');
   end

   tmpline=line([startpoint, startpoint+linelength*(shorttext)],...
      [breakLineY, breakLineY],[0 0],...
      'Color','k');
   drawnow;
   set(findobj(0,'Tag','IterText2'),'String','0 %');
   set(h_iterEdit,'String','');
   set(findobj(0,'Tag','IterPatch'),'XData',[0 0 0 0 0]);
   set(gcf,'CurrentAxes',h_histView );          
   cla;
   set(0,'ShowHiddenHandles','off'); 

   psc=1;
   paramstack(psc).order=order;
   paramstack(psc).mainData=mainData;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          'Übernehmen'                %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(action,'Übernehmen')   
   if (strcmp(get(h_vp(1),'Enable'),'on'))
      temp_t  = str2num(get(h_vp(1),'String'));
      if (isreal(temp_t) & isnumeric(temp_t) & (length(temp_t)==1))
         mainData(1,1)= { temp_t };
      end    
      set(h_vp(1),'String',num2str(mainData{1,1}));
   end
   for i=1:t_index-1
      temp_t = str2num(get(h_tp(i,1),'String'));
      data=get(h_tp(i,1),'UserData');
      if (isreal(temp_t) & isnumeric(temp_t) & (length(temp_t)==1))
         data.oldval=get(h_tp(i,1),'String');
         if (data.row > 7)
            mainData{data.line+1,data.row}(1)=  temp_t ;
         else
            mainData(data.line,data.row)= { [temp_t 1] };
         end
      end
      set(h_tp(i,1),'String',data.oldval);
      set(h_tp(i,1),'UserData',data);
   end
   for i=1:d_index-1
      temp_t = str2num(get(h_dp(i,1),'String'));
      data=get(h_dp(i,1),'UserData');
      if (isreal(temp_t) & isnumeric(temp_t) & (length(temp_t)==1))
         data.oldval=get(h_dp(i,1),'String');
         mainData{data.line+1,data.row}(2)= temp_t;
      end
      set(h_dp(i,1),'String',data.oldval);
      set(h_dp(i,1),'UserData',data);
   end
   if(~isempty(mainData{2,8}))
      mainData(1,8) = {[mainData{2,8}(1)^2,mainData{2,8}(1)*mainData{2,8}(2)*2,1]};
   end
   if(~isempty(mainData{2,9}))
      mainData(1,9) = {[mainData{2,9}(1)^2,mainData{2,9}(1)*mainData{2,9}(2)*2,1]};
   end
   if(~isempty(mainData{4,8}))
      mainData(3,8) = {[mainData{4,8}(1)^2,mainData{4,8}(1)*mainData{4,8}(2)*2,1]};
   end
   if(~isempty(mainData{4,9}))
      mainData(3,9) = {[mainData{4,9}(1)^2,mainData{4,9}(1)*mainData{4,9}(2)*2,1]};
   end
   set(findobj(0,'Tag','IterPatch'),'XData',[0 0 0 0 0]);
   set(findobj(0,'Tag','IterText2'),'String','0 %');
   set(h_iterEdit,'String','');
   set(gcf,'CurrentAxes',h_histView );          
   cla;
   counter=1;
   psc=psc+1;
   paramstack(psc).order=order;
   paramstack(psc).mainData=mainData;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Default Funktionsparameter        %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(action,'Default')   
   if (strcmp(get(h_vp(1),'Enable'),'on'))
      mainData(1,1)= { 1 };
      set(h_vp(1),'String','1');
   end
   for i=1:t_index-1
      data=get(h_tp(i,1),'UserData');
         data.oldval='1';
         if (data.row > 7)
            mainData{data.line+1,data.row}(1)= 1 ;
         else
            mainData(data.line,data.row)= { [1 1] };
         end
      set(h_tp(i,1),'String','1');
      set(h_tp(i,1),'UserData',data);
   end
   for i=1:d_index-1
      data=get(h_dp(i,1),'UserData');
      data.oldval='1';
      mainData{data.line+1,data.row}(2)= 1;
      set(h_dp(i,1),'String','1');
      set(h_dp(i,1),'UserData',data);
   end
   if(~isempty(mainData{2,8}))
      mainData(1,8) = {[mainData{2,8}(1)^2,mainData{2,8}(1)*mainData{2,8}(2)*2,1]};
   end
   if(~isempty(mainData{2,9}))
      mainData(1,9) = {[mainData{2,9}(1)^2,mainData{2,9}(1)*mainData{2,9}(2)*2,1]};
   end
   if(~isempty(mainData{4,8}))
      mainData(3,8) = {[mainData{4,8}(1)^2,mainData{4,8}(1)*mainData{4,8}(2)*2,1]};
   end
   if(~isempty(mainData{4,9}))
      mainData(3,9) = {[mainData{4,9}(1)^2,mainData{4,9}(1)*mainData{4,9}(2)*2,1]};
   end
   set(findobj(0,'Tag','IterPatch'),'XData',[0 0 0 0 0]);
   set(findobj(0,'Tag','IterText2'),'String','0 %');
   set(h_iterEdit,'String','');
   set(gcf,'CurrentAxes',h_histView );  
   cla;
   counter=1;
   psc=psc+1;
   paramstack(psc).order=order;
   paramstack(psc).mainData=mainData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          'Start'                     %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(action,'Start')   

   oldX=0;
   oldValue=0;
   m=length(n_anfang2)-1;
   n=length(d_anfang2)-1;
   faktor = 100/opt.maxfuneval;        % Multiplikator für die Iterationsausgabe in Prozent
   options=optimset('TolFun',opt.tolfun,...
      'MaxIter',1.e6,...
      'MaxFunEvals',opt.maxfuneval,...
      'TolX',opt.tolx,...
      'Display','off');
   bildzahl=opt.refresh;
   iz=0;             % Initialisierung des Iterationszählers für die numerische Ausgabe.
   bildzaehler=0;    % Initialisierung des Zählers für die intermittierende 
                     % Bildausgabe des Suchfortschritts:
   set(gcf,'CurrentAxes',h_histView );          
   cla;
   set(gcf,'CurrentAxes',H_mainAxes1 );          
%   if((get(h_ic,'Value') == 1) & (order(3) > 0))
   if(order(3) > 0)
      d.integral=order(3);
      p_anf2 = p_anf2(1:length(p_anf2)-d.integral);
   else
      d.integral=0;
   end 
   
   if(order(2) > 0)										% Festhalten des differentialen Anteils 
      d.differential=order(2);						% durch einfügen von Nullen in das Modellpolynom
      tmp=zeros(1,d.differential);
      p_anf2_temp1 = p_anf2(1:m+1-d.differential);
      p_anf2_temp2 = p_anf2(m+2:m+2+n);
		p_anf2 = [p_anf2_temp1,tmp,p_anf2_temp2];
   else
      d.differential=0;
   end 

   counter=1;

   set(findobj(0,'Tag','IterText2'),'String','0 %');                      
   set(findobj(0,'Tag','IterEdit'),'String','');                      
   set(findobj(0,'Tag','Pushbutton_Start'),'enable','off');                      
   set(findobj(0,'Tag','Pushbutton_Optionen'),'enable','off');                      
   set(findobj(0,'Tag','Pushbutton_Übernehmen'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_Default'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_Vorherige'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_setparam'),'enable','off');
   set(findobj(0,'Tag','PopupMenu_Laden1'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_Simulation'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_Bearbeiten'),'enable','off');
   set(findobj(0,'Tag','Pushb_Mod_Speichern'),'enable','off');
   
   yaxe(1)=min(d.ySystem)-0.1*abs(min(d.ySystem));
	yaxe(2)=max(d.ySystem)+0.1*abs(max(d.ySystem));
	ymin=min(yaxe);
	ymax=max(yaxe);
	d.YLim = [ymin ymax];
   
   [p,fval,exitflag,output]=fminsearch1('zielfkt1',p_anf2,options,m,n,koordinaten,d);
   % in p befinden sich anschließend die optimierten Parameter, angeordnet wie in p_anf.

   set(findobj(0,'Tag','Pushbutton_Start'),'enable','on');                      
   set(findobj(0,'Tag','Pushbutton_Optionen'),'enable','on');                      
   set(findobj(0,'Tag','Pushbutton_Übernehmen'),'enable','on');
   set(findobj(0,'Tag','Pushbutton_Default'),'enable','on');
   set(findobj(0,'Tag','Pushbutton_Vorherige'),'enable','on');
   set(findobj(0,'Tag','Pushbutton_setparam'),'enable','on');
   set(findobj(0,'Tag','PopupMenu_Laden1'),'enable','on');
   set(findobj(0,'Tag','Pushbutton_Simulation'),'enable','on');
   set(findobj(0,'Tag','Pushb_Mod_Speichern'),'enable','on');
   set(findobj(0,'Tag','Pushbutton_Bearbeiten'),'enable','off');

   if(d.integral > 0)
      tmp=zeros(1,d.integral);
      p=[p,tmp];
   end
   
   if(d.differential > 0)							% Rückführung des differentialen Anteils
      tmp=zeros(1,d.differential);				% durch einfügen von Nullen in das Modellpolynom
      p_temp1 = p(1:m+1-d.differential);		% Zur Eliminierung des letzten Iterationsschrittes
      p_temp2 = p(m+2:m+2+n);
		p = [p_temp1,tmp,p_temp2];
   end 

   n_end2=p(1:m+1);                                                 % berechnete Zähler
   d_end2=p(m+2:m+2+n);                                             % berechnete Nenner
   p_anf=[n_end2,d_end2];
   Tf2vn1(n_end2,d_end2);
   if((exitflag >  0) & (ok==0))
   id_msgdlg=warndlg(['Aktuelle  Optioneneinstellung  erfüllt  die  Abschlußkriterien '...
      'der  Suchfunktion. Verkleinern  Sie  ggf.  Zielfunktionsfehler  oder '...
      'Parameterfehler.'],'INFO');
   %        set(id_msgdlg,'Tag','msg_dlg','WindowStyle','modal','Position',[400 500 300 100]);
   set(id_msgdlg,'WindowStyle','modal');
   end
   psc=psc+1;
   paramstack(psc).order=order;
   paramstack(psc).mainData=mainData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          'Stop'                      %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(action,'Stop')   
   ok=1;
   return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          'Integrator'                %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(action,'Integrator')   
   integrator=get(h_ic,'Value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          'Vorherige'                 %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(action,'Vorherige')   
   if(psc==1)
      return;
   end
   psc=psc-1;
   order=paramstack(psc).order;
   mainData=paramstack(psc).mainData;
   set(0,'ShowHiddenHandles','on');        %  Option "off" verhindert zoomen von 'mainAxes3'
   H_mainAxes2 = findobj( 0, 'Tag' , 'mainAxes2');
   set(h0,'CurrentAxes',H_mainAxes2 );          
   start_poly(1) = {[1 0]};                    % Anfangswerte 's'- oder '1/s'-Parametern
   start_poly(2) = {[1 0 0]};
   start_poly(3) = {[1 0 0 0]};
   start_poly(4) = {[1 0 0 0 0]};
   start_poly(5) = {[1 0 0 0 0 0]};
   t_index = 1;                                        % Indizies von 'T'-Parametern
   d_index = 1;                                        % Indizies von 'd'-Parametern
   startpoint = 60;                                  % X Koordinate des Bruchstriches
   cla
   %%%%% Bruchstrichlänge berechnen
   linelength = max(order(6)+(order(7)*2),(order(2)>0)+order(4)+(order(5)*2));
   if linelength > 5
      linelength = 5;
   end
   
   %%%%% Zähler-, Nennerposition berechnen
   num_sp = ((linelength-((order(2)>0)+order(4)+(order(5)*2)))/2)*shorttext;
   den_sp = ((linelength-(order(6)+(order(7)*2)))/2)*shorttext;
   
   %%%%% V %%%%%
   if order(1) > 0                                                 
      id_text2 = text(startpoint,breakLineY,'\bf\fontsize{12}V','EraseMode','background');
      startpoint = startpoint + 35;
      set(h_vp(1),'enable','on',...
         'String',num2str(mainData{1,1}),...
         'BackgroundColor','w');                                          
      set(h_vp(2),'enable','on');                                          
   else
     set(h_vp(1),'enable','off',...
      'String','',...
      'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));              
     set(h_vp(2),'enable','off');                                          
   end
   
   %%%%% 1/s %%%%%         vertauschte Reihenfolge wegen Koordinatenberechnung von Textstrings
   if order(3) > 0
      sd_string = {['\bf\fontsize{10}s^{\fontsize{6}',num2str(order(3)),'}']};
      if order(3)==1
         sd_string = {'\bf\fontsize{10}s'};
      end
      text(startpoint,breakLineY-18, sd_string,...
         'EraseMode','background',...
         'HorizontalAlignment','center');            
      tmpline=line([startpoint-10, startpoint+10],[breakLineY, breakLineY],[0 0],'Color','k');
      text(startpoint,breakLineY+15,'\bf\fontsize{10}  1  ',...
         'EraseMode','background',...
         'HorizontalAlignment','center');   
      startpoint = startpoint + 35;        
   end
   num_sp = num_sp + startpoint;
   den_sp = den_sp + startpoint;
  
   %%%%% s %%%%%
   if order(2) > 0
      sn_string = {['\bf\fontsize{10}     s^{\fontsize{6}',num2str(order(2)),'}']};
      if order(2)==1
         sn_string = {'\bf\fontsize{10}     s'};
      end
      id_text3 = text(num_sp+35,breakLineY+15, sn_string,...
         'EraseMode','background',...
         'HorizontalAlignment','center');
      num_sp = num_sp + shorttext;
   end

   %%%%% (1+sT) %%%%%    
   if order(4) > 0
      for i=1:order(4)
         sn_string = {['\fontsize{10} (\bf1+sT_{\fontsize{7}',num2str(t_index),'}\rm)']};
         id_text4(i) = text(num_sp+35,breakLineY+15, sn_string,...
            'EraseMode','background',...
            'HorizontalAlignment','center');
         set(h_tp(t_index,1),'enable','on',...
            'String',num2str(mainData{NUM,2+i}(1)),...
            'UserData',struct('line',1,'row',2+i,'oldval',num2str(mainData{NUM,2+i}(1))),...
            'BackgroundColor','w');                                          
         set(h_tp(t_index,2),'enable','on');          
         t_index = t_index + 1;
         num_sp = num_sp + shorttext;
      end
   end

   %%%%% (1+2dTs+(Ts)^2) %%%%%    
   if order(5) > 0
      for i=1:order(5)
         sn_string = {['\fontsize{10} (\bf1+2d_{\fontsize{7}',num2str(d_index),...
            '}T_{\fontsize{7}',num2str(t_index),...
            '}s+(T_{\fontsize{7}',num2str(t_index),...
            '}s)^{\bf\fontsize{7}2}\rm)']};
         id_text5(i) = text(num_sp+70,breakLineY+15, sn_string,...
            'EraseMode','background',...
            'HorizontalAlignment','center');
         set(h_tp(t_index,1),'enable','on',...
            'String',num2str(mainData{NUM_VN,7+i}(1)),...
            'UserData',struct('line',1,'row',7+i,'oldval',num2str(mainData{NUM_VN,7+i}(1))),...
            'BackgroundColor','w');                                          
         set(h_tp(t_index,2),'enable','on');          
         set(h_dp(d_index,1),'enable','on',...
            'String',num2str(mainData{NUM_VN,7+i}(2)),...
            'UserData',struct('line',1,'row',7+i,'oldval',num2str(mainData{NUM_VN,7+i}(2))),...
            'BackgroundColor','w');                                          
         set(h_dp(d_index,2),'enable','on');          
         t_index = t_index + 1;
         d_index = d_index + 1;
         num_sp = num_sp + longtext;
      end
   end

   %%%%% 1/(1+sT) %%%%%    
   if order(6) > 0
      for i=1:order(6)
         sd_string = {['\fontsize{10}(\bf1+sT_{\fontsize{7}',num2str(t_index),'}\rm)']};
         id_text6(i) = text(den_sp+35,breakLineY-22, sd_string,...
            'EraseMode','background',...
            'HorizontalAlignment','center');
         set(h_tp(t_index,1),'enable','on',...
            'String',num2str(mainData{DEN,2+i}(1)),...
             'UserData',struct('line',3,'row',2+i,'oldval',num2str(mainData{DEN,2+i}(1))),...
             'BackgroundColor','w');                                          
         set(h_tp(t_index,2),'enable','on');          
         t_index = t_index + 1;
         den_sp = den_sp + shorttext;
      end
   end

   %%%%% 1/(1+2dTs+(Ts)^2) %%%%%    
   if order(7) > 0
     for i=1:order(7)
         sd_string = {['\fontsize{10}(\bf1+2d_{\fontsize{7}',num2str(d_index),...
            '}T_{\fontsize{7}',num2str(t_index),...
            '}s+(T_{\fontsize{7}',num2str(t_index),...
            '}s)^{\bf\fontsize{7}2}\rm)']};
         id_text6(i) = text(den_sp+70,breakLineY-22, sd_string,...
            'EraseMode','background',...
            'HorizontalAlignment','center');
         set(h_tp(t_index,1),'enable','on',...
            'String',num2str(mainData{DEN_VN,7+i}(1)),...
            'UserData',struct('line',3,'row',7+i,'oldval',num2str(mainData{DEN_VN,7+i}(1))),...
            'BackgroundColor','w');                                          
         set(h_tp(t_index,2),'enable','on');          
         set(h_dp(d_index,1),'enable','on',...
            'String',num2str(mainData{DEN_VN,7+i}(2)),...
            'UserData',struct('line',3,'row',7+i,'oldval',num2str(mainData{DEN_VN,7+i}(2))),...
            'BackgroundColor','w');                                          
         set(h_dp(d_index,2),'enable','on');          
         t_index = t_index + 1;
         d_index = d_index + 1;
         den_sp = den_sp + longtext;
      end
   end
   %%%%% Übrige Textobjekte disablen %%%%%

   for i=t_index:10
      set(h_tp(i,1),'enable','off',...
         'String','',...
         'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));                
     set(h_tp(i,2),'enable','off');
   end
   for i=d_index:4
      set(h_dp(i,1),'enable','off',...
         'String','',...
          'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));                  
     set(h_dp(i,2),'enable','off');          
   end
   
   %%%%% Sonderfall_1 1 im Zähler %%%%%
   if (order(2)+order(4)+order(5) == 0) & (order(6)+order(7) > 0)
      text(num_sp-5,breakLineY+15,'\bf\fontsize{10}1','HorizontalAlignment','center');
   end

   %%%%% Sonderfall_2 1 im Nenner %%%%%
   if (order(4)+order(5) > 0) & (order(6)+order(7) == 0)
      text(den_sp-5,breakLineY-15,'\bf\fontsize{10}1','HorizontalAlignment','center');
   end
   tmpline=line([startpoint, startpoint+linelength*(shorttext)],[breakLineY, breakLineY],...
      [0 0],'Color','k');
   set(0,'ShowHiddenHandles','off'); 
   set(findobj(0,'Tag','IterPatch'),'XData',[0 0 0 0 0]);
   set(findobj(0,'Tag','IterText2'),'String','0 %');
   set(h_iterEdit,'String','');
   set(gcf,'CurrentAxes',h_histView );          
   cla;
   counter=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          'Reset'                     %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(action,'Reset')   
   param2=ones(1,7);
   set(0,'ShowHiddenHandles','on');     %  Option "off" verhindert zoomen von 'mainAxes3'
   H_mainAxes2 = findobj( 0, 'Tag' , 'mainAxes2');
   set(gcf,'CurrentAxes',H_mainAxes2 );
   cla;
   set(0,'ShowHiddenHandles','off');
   set(gcf,'CurrentAxes',H_mainAxes1 );
   
   %%%%% Übrige Textobjekte disablen %%%%%
   for i=1:10
      set(h_tp(i,1),'enable','off',...
         'String','',...
         'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));     
      set(h_tp(i,2),'enable','off');
   end
   for i=1:2
      set(h_dp(i,1),'enable','off',...
         'String','',...
         'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));      
      set(h_dp(i,2),'enable','off');          
   end
   set(h_vp(1),'enable','off',...
      'String','',...
      'BackgroundColor',get(0,'defaultUicontrolBackgroundColor')); 
   set(h_vp(2),'enable','off');
   set(findobj(0,'Tag','Pushbutton_Start'),'enable','off');                      
   set(findobj(0,'Tag','Pushbutton_Übernehmen'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_Default'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_Vorherige'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_Stop'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_Bearbeiten'),'enable','off');
   set(findobj(0,'Tag','Pushb_Mod_Speichern'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_Simulation'),'enable','off');
   set(findobj(0,'Tag','IterText2'),'String','0 %');
   set(findobj(0,'Tag','IterEdit'),'String','');
   set(findobj(0,'Tag','IterPatch'),'XData',[0 0 0 0 0]);
   set(gcf,'CurrentAxes',h_histView );          
   cla;
   counter = 1;
   return
end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          Ausgabe                      %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_anfang2 =[1];
d_anfang2 =[1];
for i=1:9
   n_anfang2 = conv(n_anfang2,mainData{1,i}); 
   d_anfang2 = conv(d_anfang2,mainData{3,i}); 
end
newSystem2=lsim(n_anfang2,d_anfang2,d.uerr,d.t);

yaxe(1)=min(d.ySystem)-0.1*abs(min(d.ySystem));
yaxe(2)=min(newSystem2)-0.1*abs(min(newSystem2));
yaxe(3)=max(d.ySystem)+0.1*abs(max(d.ySystem));
yaxe(4)=max(newSystem2)+0.1*abs(max(newSystem2));
ymin=min(yaxe);
ymax=max(yaxe);
d.YLim = [ymin ymax];

p_anf2=[n_anfang2,d_anfang2];
figure(h0);
set(gcf,'CurrentAxes',H_mainAxes1 );          
cla
hp1=plot(d.t,d.ySystem,'b',d.t,newSystem2,'r');grid,
set(H_mainAxes1,'XLim',d.XLim,'YLim',d.YLim);
legend('Systen-Antwort','Modell-Antwort',0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          Ende                         %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%