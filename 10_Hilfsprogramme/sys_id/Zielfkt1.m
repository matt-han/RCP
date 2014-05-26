%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         zielfkt1.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion ist ein Teil des Moduls "Identifikation". Die orginale 
%                     Funktion "zielfkt" wird hier �berarbeitet und erweitert.
%
%  Datum:             
%
%  Autor:             M.Ottens
%
%  �berarbeitet:      21-01-2003, J.Wykretowicz
%
%  �berarbeitet:      09-04-2004, Ren� N�renberg
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function[g]=zielfkt1(x,m,n,koordinaten,d)

% Detalierte Beschreibung:
% In diesem Programm wird die Zielfunktion f�r den Matlab-Suchalgorithmus 
% "fmins" berechnet.Eingabeparameter "x" ist der Vektor der
% aktuellen Z�hler- und Nennerparameter der Modell�bertragungsfunktion
% die von "fmins" berechnet wurden. Ausgabeparameter ist der dazugeh�rige
% Wert der Zielfunktion "g".
% Die Zielfunktion ist die Differenz der Fl�chen zwischen den System-
% antworten des zu identifizierende System (ySystem)und des Modells 
% (yModell), welche in diesem Programm berechnet wird.
%
% Die Systemantwort des zu identifizierenden Systems "ySystem"
% wird im Modul "Daten bearbeiten" bereitgestellt. Auch die Form der Eingangs-
% erregung "uerr" wird dort vorgegeben.Der Zeitvektor "t", der Erregungsvektor 
% "uerr" und die Sprungantwort "ySystem" befinden sich dann im Matlab-Arbeitsspeicher.
% Da sie hier in der "function" gebraucht werden, sind sie in der obigen Parameterliste
% aufgef�hrt. Auch die Anzeigekoordinaten "koordinanten" werden so dieser 
% function bekannt gemacht.
% "n", die zu sch�tzende Systemordnung und "m" die Z�hlerpolynomordnung des
% zu sch�tzenden Modells werden auf dem gleichen Wege von der "set_parameter" Funktion
% aus �bergeben.
% Ein Iterationsz�hler "iz" der die Iterationen hochz�hlt und ein "bildzaehler",
% der daf�r sorgt, da� nur jedes k-te Bild des Ann�herungsfortschrtittes 
% grafisch dargestellt wird, werden �ber eine Gobal-Deklarierung �bergeben.


global   iz bildzahl bildzaehler ok  counter faktor h_iterNr h_patch h_iterEdit 
global   H_mainAxes1 h_histView
global   oldX newX oldValue oldCoor

if(d.integral > 0)
   tmp=zeros(1,d.integral);
   x=[x,tmp];
end

if(d.differential > 0)						% St�ndiges Festhalten des differentialen Anteils 
   tmp=zeros(1,d.differential);			% durch einf�gen von Nullen in die entsprechenden
   x_temp1 = x(1:m+1-d.differential);	% Parameter des Modellpolynom
   x_temp2 = x(m+2:m+2+n);
   x = [x_temp1,tmp,x_temp2];
else
   d.differential=0;
end 

zModell=[x(1:m+1)];                    % zu optimierendes Modell-Zaehlerpolynom.
nModell=[x(m+2:m+2+n)]  ;              % zu optimierendes Modell-Nennerpolynom.
sys=tf(zModell,nModell);
try
   [yModell,tm]=lsim(sys,d.uerr,d.t);  % Sprungantwort des gesch�tzten Modells,
catch
   return;    
end                                    % erregt mit dem gleichen Eingangssignal
sizeModell=size(yModell);                                       
sizetm=size(tm);                       % "uerr", wie das zu identifizierende System.
sizedt=size(d.t);

tempo=round(length(tm)/length(d.t)) ;       % Bei ung�nstiger Wahl der Rechenschrittweite 
yModell=(yModell(1:tempo:length(tm),:))';   % berechnet "lsim" mehr Werte (tm St�ck)als 
                                       % die urspr�ngliche Zeitachse (t) lang ist.           
                                       % Das wird hier r�ckg�ngig gemacht. Siehe auch
                                       % "help lsim".
% Berechnung der Zielfunktion
%
sizeModell=size(yModell);              % "uerr", wie das zu identifizierende System.
sizeySystem=size(d.ySystem);

g=sum(abs(yModell-d.ySystem));   % Berechnung der Zielfunktion des Suchalgorithmus (siehe oben)
%g=sum(abs(yModell'-d.ySystem)); % Berechnung der Zielfunktion des 

iz=iz+1;                      % Iterationsz�hler
format short e
IterationNr=iz;                     % Ausgabe der aktuellen Iteration
Zielfunktionswert=g;                % Ausgabe des aktuellen Zielfunktionswertes
counter=round(iz*faktor);
if(counter>100)
   counter=100;
end
set(h_iterNr,'String',[num2str(counter) ' %']);
set(h_patch,'XData',[0 0 counter counter 0]);
set(h_iterEdit,'String',num2str(g));

% Grafik zum Vergleich der Systemantworten von zu identifizierendem
% Systems und aktuell gesch�tzten Modell. 

if bildzaehler==bildzahl         % Nur jedes 10. Bild wird ausgegeben.
                                  % Dient zur Erh�hung des Durchsatzes,
                                  % kann belieig ge�nder werden.
   set(gcf,'DoubleBuffer','on');  % Sorgt f�r flickerfreien Plot
   set(gcf,'CurrentAxes',H_mainAxes1 );          
   plot(d.t,yModell,'r',d.t,d.ySystem,'b'),grid on;
   set(H_mainAxes1,'XLim',d.XLim,'YLim',d.YLim);
    if ~(isnan(g))    
       set(gcf,'CurrentAxes',h_histView );          
       plot([oldX counter],[oldCoor g/oldValue],'color',[0 0.6 0]);
       oldX=counter;
       oldCoor=g/oldValue;
       oldValue=g;
    end
    drawnow;
end
bildzaehler=bildzaehler+1;
if bildzaehler==bildzahl+1
   bildzaehler=0;                  % Zur�cksetzen des Bildz�hlers.
end

