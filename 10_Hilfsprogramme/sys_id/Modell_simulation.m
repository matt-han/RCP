%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Modell_simulation.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion realisiert das Modul "Modell Simulation". Hier werden
%                     4 Figurenfenster mit Modellantworten und Bodediagramm ausgegeben.
%
%  Datum:             21-01-2003
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Modell_simulation()


global d ySystem t uerr n_anfang2 d_anfang2 koordinaten

close(findobj(0,'Tag','SimFig2'));                      
close(findobj(0,'Tag','SimFig3'));                      
close(findobj(0,'Tag','SimFig4'));                      
close(findobj(0,'Tag','SimFig5'));                      
close(findobj(0,'Tag','SimFig6'));                      
    
xmin=min(d.t);
xmax=max(d.t);
System2=lsim(n_anfang2,d_anfang2,d.uerr,d.t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%              Figure (6)  Fehlerbetrachtung     %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hf(6) = figure('Position',[100 80 600 550], ...
   'Color',get(0,'defaultUicontrolBackgroundColor'),...
   'NumberTitle','off',...
   'Tag','SimFig6', ...
   'Name','Fehlerbetrachtung',...
   'ToolBar','none');

resid=d.ySystem-System2';
% Berechnung des residualen Fehler
%
subplot(3,1,1)
plot(d.t,resid)
grid on
title('Residualer Fehler der Identifikation')
%legend('Residualer Fehler der identifikation',0);
% Autokorrelationsfunktion des residualen Fehlers
%
subplot(3,1,2)
y=xcorr(resid,'unbiased');
y(1)=[];
% tmax=d.t(length(d.t));
t_max=d.t(length(d.t));
dt1=d.t(2)-d.t(1);
t1=-t_max:dt1:t_max; 
% Vektorenanpassung
if length(t1) > length(y)
   t1(length(t1))=[];
end
plot(t1,y)
grid on
title('AKF des residualen Fehlers')
%legend('AKF des residualen Fehlers',0);

subplot(3,1,3)

% Kreuzkorrelationsfunktion zwischen Eingangssignal und residualem Fehler
%
uvresid=xcorr(resid,d.uerr,'unbiased');
% t2=0:dt1:2*tmax;
t2=0:dt1:2*t_max;
% Vektorenanpassung
if length(t2) < length(uvresid)
   uvresid(1)=[];
end
plot(t2,uvresid)
grid on
title('KKF zwischen dem Eingangssignal und dem residualen Fehler')
%legend('KKF zwischen dem Eingangssignal und dem residualen Fehler',0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Figure (2)  Systemantwort und Modellantwort   %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


hf(2) = figure('Position',[120 200 600 400], ...
   'Color',get(0,'defaultUicontrolBackgroundColor'),...
   'NumberTitle','off',...
   'Tag','SimFig2', ...
   'Name','Modellsimulation',...
   'ToolBar','none');
axes('Parent',hf(2), ...
   'Color',[1 1 1], ...
   'Position',[0.1 0.4 0.8 0.5]);   

hp1=plot(d.t,d.ySystem,'b',d.t,System2,'g');grid,   
set(gca,'XLim',d.XLim,'YLim',d.YLim);
set(hp1(2),'color',[0 0.6 0]);
ht=title('Systemantwort und Modellantwort');
set(ht,'FontSize',[12]);
legend('Systemantwort','Modellantwort',0);
axes('Parent',hf(2), ...
   'Color',[1 1 1], ...
   'Position',[0.1 0.1 0.8 0.2]);

ymin=min(d.uerr)-abs(0.1*max(d.uerr));
ymax=max(d.uerr)+abs(0.1*max(d.uerr));
koordinaten2=[xmin xmax ymin ymax];

plot(d.t,d.uerr,'color','r'),axis(koordinaten2),grid,legend('Erregung',0);
set(gca,'XLim',d.XLim);
ht=title('Erregung');
set(ht,'FontSize',[12]);
zoom on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%              Figure (3)  Impulsantwort         %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
System3=impulse(n_anfang2,d_anfang2,d.t);
uerr3=zeros(size(d.t));

ymin=min(System3)-0.1*max(System3);
ymax=max(System3)+0.1*max(System3);
koordinaten3=[xmin xmax ymin ymax];

hf(3) = figure('Position',[140 170 600 400], ...
   'Color',get(0,'defaultUicontrolBackgroundColor'),...
   'NumberTitle','off',...
   'Tag','SimFig3', ...
   'Name','Impulsantwort',...
   'ToolBar','none');
hp3=plot(d.t,uerr3,'r',d.t,System3,'b');axis(koordinaten3),grid,

high=get(gca,'YLim');
hold on
hp3=plot([0 0],[0 high(2)],'r');
hold off
set(gca,'XLim',d.XLim);
ht=title('Impulsantwort');
set(ht,'FontSize',[12]);
legend('Erregung','System-Antwort',0);
zoom on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%              Figure (4)  Einheitssprungantwort %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
System4=step(n_anfang2,d_anfang2,d.t);
uerr4=ones(size(d.t));

ymin=min(System4)-0.1*max(System4);
ymax=max(System4)+0.1*max(System4);
if(ymax<=1)
   ymax=1.1;
end
if(ymin>=1)
   ymin=0;
end

koordinaten4=[xmin xmax ymin ymax];

hf(4) = figure('Position',[160 140 600 400], ...
   'Color',get(0,'defaultUicontrolBackgroundColor'),...
   'NumberTitle','off',...
   'Tag','SimFig4', ...
   'Name','Einheitssprungantwort',...
   'ToolBar','none');
   
hp4=plot(d.t,uerr4,'r',d.t,System4,'b');axis(koordinaten4),grid,
set(gca,'XLim',d.XLim);
ht=title('Einheitssprungantwort');
set(ht,'FontSize',[12]);
   legend('Erregung','System-Antwort',0);
   zoom on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%              Figure (5)  Bodediagramm          %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w=logspace(-2,2,600);      % Omega-Achse
[betr,phase]=bode(n_anfang2,d_anfang2,w);
bdB=20*log10(betr);        % dB-Berechnung
hf(5) = figure('Position',[180 110 600 400], ...
   'Color',get(0,'defaultUicontrolBackgroundColor'),...
   'NumberTitle','off',...
   'Tag','SimFig5', ...
   'Name','Bodediagramm',...
   'ToolBar','none');

subplot(2,1,1)             
hp5=semilogx(w,bdB);    
grid;
title('Bodediagramm: Betragskennlinie des geschätzten Modells');
ylabel('dB');     
subplot(2,1,2);      
hp5=semilogx(w,phase);     
grid;
title('Phasenkennlinie');
xlabel('\fontsize{12}\omega \fontsize{8}[1/sek]');
ylabel ('Grad');
zoom on
