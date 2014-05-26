%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         tf2vn1.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion berechnet aus einer in Polynomform (tf) gegebenen 
%                     Uebertragungsfunktion die faktorisierte V-Normalform (vn) der 
%                     Uebertragungsfunktion. Funktion "tf2vn" wird hier überarbeitet und 
%                     erweitert.
%
%  Datum:             
%
%  Autor:             M.Ottens
%
%  Überarbeitet:      21-01-2003, J.Wykretowicz
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function[V,k,Tdz,Tdn]=tf2vn1(zaehler,nenner)

% Die Funktion
%
%     tf2vn (zaehler,nenner)
%
% berechnet aus einer in Polynomform (tf) gegebenen Uebertragungsfunktion
% die faktorisierte V-Normalform (vn) der Uebertragungsfunktion.
%
% Eingabeparameter sind der Zaehler (zaehler) und der Nenner (nenner) der 
% Uebertragungsfunktion, geordnet nach fallenden Potenzen von s.
%
% Ausgabeparameter sind:
%      * der Verstärkungsfaktor V,
%      * die Potenz k des Faktors 1/s^k,
%      * und die Dynamikkomponenten von Zähler und Nenner
%        in Form von Vorhalten und Verzögerungsgliedern
%        1. und 2. Ordnung. Sie geben Auskunft über die
%        Größe der vorkommenden Zeitkonstanten (T) und
%        Dämpfungsfaktoren (d)

% (Im folgenden Programm-Kommentar bedeutet das Zeichen /= ungleich)  

global param2  n_counter d_counter  p_anf2 order
global ySystem t uerr H_mainAxes1 H_mainAxes2 h_tp h_dp h_vp n_anfang2 d_anfang2
global t_index d_index mainData  koordinaten ok p n_end2 d_end2
global d h0
NUM    = 1;                                 % Indizies von 'mainData' cell array
NUM_VN = 2;                                 %
DEN    = 3;                                 %
DEN_VN = 4;                                 %
start_poly(1) = {[1 0]};                    % Anfangswerte 's'- oder '1/s'-Parametern
start_poly(2) = {[1 0 0]};
start_poly(3) = {[1 0 0 0]};
start_poly(4) = {[1 0 0 0 0]};
start_poly(5) = {[1 0 0 0 0 0]};
start_poly(6) = {[1 0 0 0 0 0 0]};

format short e
[nl,pol,kf]=tf2zp(zaehler,nenner);      % Berechnung der Produktform. 

Vzg=1;            % Gesamtverstaerkungsfaktor Zaehler.
Vng=1;            % Gesamtverstaerkungsfaktor Nenner.
k=0;               % k-Faktor der Linenearfaktoren ohne  Absolutglied.
m=length(nl);                   % Zaehlergrad.
n=length(pol);                  % Nennergrad.
Tdz=zeros(m,2);                 % siehe help-Text
Tdn=zeros(n,2);                 % siehe help-Text
x=0;                            % Merker zur Berechnung von V, 
% da die Funktion tf2zp komplexe Nullstellen
% doppelt darstellt, muß eine zur Berechnung
% von V eliminiert werden.

for i=1:m                         % Der Algorithmus tf2zp arbeitet ungenau.
   if abs(imag(nl(i))) <= 1.e-4, % In der if-Schleife werden daher
      nl(i)=real(nl(i));            % Imaginärteile der Zaehlernullstellen,
   end                           % die kleiner als 1.e-4 sind, reel gemacht.
end

for i=1:n
   if abs(imag(pol(i))) <= 1.e-4, % Der Algorithmus tf2zp arbeitet ungenau.
      pol(i)=real(pol(i));           % In der if-Schleife werden daher
   end                            % Imaginärteile der Nennernullstellen,
end                                % die kleiner als 1.e-4 sind, reel gemacht.

% Berechnung des Zählers
merk=0;                            % Initialisierung eines Merkers:
% 0: Zähler ist rein proportional,
% 1: Zähler enthält Dynamikanteile
Vn=1;                              % Initialisierungfür den (seltenen)
% rein proportionalen Fall.
no_d=1;                            % Merker für "es exisitiert kein
                                   % Dämpfungsfaktor";
for i=1:1:m,
   a=real(nl(i));
   b=imag(nl(i));
   if a==0,
      if b==0, 
         % Realteil=0, Imaginärteil=0
         k=k-1;                        % k-Faktor im Zähler
         Vz(i)=1;                      % Zählerverstärkungsfaktor
         Tdz(i,2)=no_d;                % kein Dämpfungsfaktor definiert
      else
         % Realteil=0, Imaginärteil/=0
         if x==1,
            Vz(i)=1;                   % Zählerverstärkungsfaktor
            x=0;                       % nicht doppelt berechnen
         else
            Vz(i)=b^2;                 % Zählerverstärkungsfaktor
            x=1;
         end
         Tdz(i,1)=sqrt(1/b^2);         % Vorhaltzeitkonstante
      end
   else
      if b==0,
         % Realteil/=0, Imaginärteil=0
         %       Vz(i)=abs(a);                 % Zählerverstärkungsfaktor
         Vz(i)=-a;                     % Zählerverstärkungsfaktor
         Tdz(i,1)=-1/a;                % Vorhaltzeitkonstante 
         Tdz(i,2)=no_d;                % kein Dämpfungsfaktor definiert             
      else
         % Realteil/=0, Imaginärteil/=0
         if x==1,
            Vz(i)=1;                   % Zählerverstärkungsfaktor
            x=0;                       % nicht doppelt berechnen
         else
            Vz(i)=a^2+b^2;             % Zählerverstärkungsfaktor
            x=1;
         end
         Tdz(i,1)=sqrt(1/(a^2+b^2));   % Vorhaltzeitkonstante
         Tdz(i,2)=-a/sqrt(a^2+b^2);    % Dämpfungsfaktor
      end
   end
   merk=1;                          % Zähler enthält Dynamikanteile
end

% Berechnung des Nenners

for i=1:1:n,
   a=real(pol(i));
   b=imag(pol(i));
   if a==0,
      if b==0, 
         % Realteil=0, Imaginärteil=0
         k=k+1;                        % k-Faktor des Nenners
         Vn(i)=1;                      % Nennerverstärkungsfaktor
         Tdn(i,2)=no_d;                % kein Dämpfungsfaktor definiert
      else
         % Realteil=0, Imaginärteil/=0
         if x==1,
            Vn(i)=1;                   % Nennerverstärkungsfaktor
            x=0;                       % nicht doppelt berechnen
         else
            Vn(i)=b^2;                 % Nennerverstärkungsfaktor
            x=1;
         end
         Tdn(i,1)=sqrt(1/b^2);         % Verzögerungszeitkonstante
      end
   else
      if b==0,
         % Realteil/=0, Imaginärteil=0 
%        Vn(i)=abs(a);                 % Nennerverstärkungsfaktor
         Vn(i)=-a;                     % Nennerverstärkungsfaktor
         Tdn(i,1)=-1/a;                % Verzögerungszeitkonstante
         Tdn(i,2)=no_d;                % kein Dämpfungsfaktor definiert
      else
         % Realteil/=0, Imaginärteil/=0 
         if x==1,
            Vn(i)=1;                   % Nennerverstärkungsfaktor
            x=0;                       % nicht doppelt berechnen
         else
            Vn(i)=a^2+b^2;             % Nennerverstärkungsfaktor
            x=1;
         end
         Tdn(i,1)=sqrt(1/(a^2+b^2));   % Verzögerungszeitkonstante
         Tdn(i,2)=-a/sqrt(a^2+b^2);    % Dämpfungsfaktor
      end
   end
end
% Schlussberechnungen
if merk==0                       % Prüfung, ob Dynamikanteile im
   Vz=1;                         % Zähler vorhanden sind.
end
Vzg=prod(Vz);                    % Gesamtverstärkung desZaehlers
Vng=prod(Vn);                    % Gesamtverstärkung des Nenners
%V=abs(kf*Vzg/Vng);               % Gesamtverstärkungsfaktor   ????????????????????
V=(kf*Vzg/Vng);                 % Gesamtverstärkungsfaktor

mainData = cell(4,9);
mainData(1,:)={[1]};
mainData(3,:)={[1]};

mainData{1,1}=V;
order=zeros(1,7);
order(1)=1;         % Verstärkung

% Ergebnisausgabe
s=0;ord1=3;ord2=8;
merk=[0,0];             % Merker verhindert, daß Vorhalte 2. Ordnung doppelt ausgegeben werden.
for i=1:m                    % m Zählernullstellen durchlaufen.
   if Tdz(i,1)~=0            % Auschluß von reinen Differenzierer-Nullstellen.
      if (Tdz(i,2)~=no_d)    % Prüfung , ob nicht Vorhalt 1.Ordnung.
         if Tdz(i,:)~=merk
            merk=Tdz(i,:);      % Ausgabe Vorhalt 2. Ordnung.
            mainData{2,ord2}(1)=Tdz(i,1);
            mainData{2,ord2}(2)=Tdz(i,2);
            ord2=ord2+1;
         end
      else
         mainData(1,ord1)={[Tdz(i,1),1]};
         ord1=ord1+1;
      end                    % Ausgabe Vorhalt 1. Ordnung.
   else
      s=s+1;
   end
end
order(2)=s;        % 's' parameter
if s>0
   mainData(1,2)=start_poly(s);  
end
s=0;
ord1=3;
ord2=8;
merk=[0,0];   % Merker verhindert, daß Verzögerungsglider 2. Ordnung doppelt ausgegeben werden.
for i=1:n                     % n Nennernullstellen durchlaufen
   if Tdn(i,1)~=0             % Ausschluß von reinen Integrator-Nullstellen
      if (Tdn(i,2)~=no_d)     % Prüfung, ob nicht Verzögerungsglied 1. Ordnung
         if Tdn(i,:)~=merk
            merk=Tdn(i,:); % Ausgabe Verzögerungsglied 2. Ordnung
            mainData{4,ord2}(1)=Tdn(i,1);
            mainData{4,ord2}(2)=Tdn(i,2);
            ord2=ord2+1;
         end
      else
         mainData(3,ord1)={[Tdn(i,1),1]};
         ord1=ord1+1;
      end                    % Ausgabe Verzögerungsglied 1. Ordnung
   else
      s=s+1;
   end
end
order(3)=s;        % '1/s' parameter
if s>0
   mainData(3,2)=start_poly(s);  
end
if(~isempty(mainData{2,8}))
   mainData(1,8) = {[mainData{2,8}(1)^2,mainData{2,8}(1)*mainData{2,8}(2)*2,1]};
   order(5)=1;
end
if(~isempty(mainData{2,9}))
   mainData(1,9) = {[mainData{2,9}(1)^2,mainData{2,9}(1)*mainData{2,9}(2)*2,1]};
   order(5)=2;
end
if(~isempty(mainData{4,8}))
   mainData(3,8) = {[mainData{4,8}(1)^2,mainData{4,8}(1)*mainData{4,8}(2)*2,1]};
   order(7)=1;
end
if(~isempty(mainData{4,9}))
   mainData(3,9) = {[mainData{4,9}(1)^2,mainData{4,9}(1)*mainData{4,9}(2)*2,1]};
   order(7)=2;
end

tmp1=0;tmp2=0;
for i=3:7
   if(length(mainData{1,i})==2)
       tmp1=tmp1+1;
   end
   if(length(mainData{3,i})==2)
      tmp2=tmp2+1;
   end
end
order(4)=tmp1;
order(6)=tmp2;
param2=order+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter und Grafik aktualisieren %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(0,'ShowHiddenHandles','on');             %  Option "off" verhindert zoomen von 'mainAxes3'
H_mainAxes2 = findobj( 0, 'Tag' , 'mainAxes2');
set(h0,'CurrentAxes',H_mainAxes2 );          

t_index = 1;                                        % Indizies von 'T'-Parametern
d_index = 1;                                        % Indizies von 'd'-Parametern
n_counter = 1;                                      % Zähler der Zählerelementen
d_counter = 1;                                      % Zähler der Nennerelementen
shorttext = 70;                                   % Länge von kürzem Text
longtext  = 140;                                   % Länge von langem Text
startpoint = 64;                                  % X Koordinate des Bruchstriches
num_sp = 106;                                      % Y Koordinate des Zählers
breakLineY = 50;                                    % Y Koordinate des Bruchstriches

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
   set(h_vp(1),'enable','on','String',num2str(mainData{1,1}),'BackgroundColor','w');      
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
   text(startpoint,breakLineY+15,'\bf\fontsize{10} 1 ',...
      'EraseMode','background',...
      'HorizontalAlignment','center');            
   startpoint = startpoint + 35;        
   startpoint = startpoint + 0.05;        
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
      sn_string = {['\fontsize{10}(\bf1+sT_{\fontsize{7}',num2str(t_index),'}\rm)']};
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
         '}T_{\fontsize{7}',num2str(t_index),....
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
      sd_string = {['\fontsize{10}  (\bf1+sT_{\fontsize{7}',num2str(t_index),'}\rm)']};
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
      sd_string = {['\fontsize{10} (\bf1+2d_{\fontsize{7}',num2str(d_index),...
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
      set(h_dp(d_index,1),'enable','on','String',num2str(mainData{DEN_VN,7+i}(2)),...
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
tmpline=line([startpoint, startpoint+linelength*(shorttext)],...
   [breakLineY, breakLineY],[0 0],'Color','k');
set(0,'ShowHiddenHandles','off'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end akktualiesieren  %%%%%%%%%%%%%%%%%%%%%%

