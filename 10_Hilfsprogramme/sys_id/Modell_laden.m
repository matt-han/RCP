%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Modell_laden.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion realisiert das Modul "Modell laden".Das Modell wird 
%                     aus einer Datei geladen.
%
%  Datum:             21-01-2003
%
%  Autor:             Jerzy Wykretowicz
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Modell_laden()

global mainData ySystem uerr t H_mainAxes1 koordinaten n_anfang2 d_anfang2 p_anf2
global d
MAXORDER=5;                                                 % maximale Modellordnung

[fname,pname] = uigetfile('*.mat','Modell import');         % 'Datei öffnen' Dialog
if(fname)                                                   % wenn Dateiname gültig:
   load([pname fname],'num','den'),                         % Variablen laden
   if(exist('num')& exist('den'))                           % wenn Variable  vorhanden
      [m1,n1]=size(num);                                    % Dimensionen von Variablen prüfen
      [m2,n2]=size(den);
      if((m1==1) & (m2==1) & (n2 >= n1) & (n2 <= MAXORDER))
         close(findobj(0,'Tag','setorder_fig'));
         tf2vn1(num,den);
         set(findobj(0,'Tag','Pushbutton_Start'),'enable','on');                      
         set(findobj(0,'Tag','Pushbutton_Stop'),'enable','on');                      
         set(findobj(0,'Tag','Pushbutton_Übernehmen'),'enable','on');
         set(findobj(0,'Tag','Pushbutton_Vorherige'),'enable','on');
         set(findobj(0,'Tag','Pushbutton_Default'),'enable','on');
         set(findobj(0,'Tag','Pushbutton_setparam'),'enable','on');
         set(findobj(0,'Tag','PopupMenu_Bearbeiten'),'enable','off');
         set(findobj(0,'Tag','Pushbutton_DatenSpeichern'),'enable','off');
         set(findobj(0,'Tag','Pushbutton_Simulation'),'enable','on');
         set(findobj(0,'Tag','Pushb_Mod_Speichern'),'enable','on');
         set(findobj(0,'Tag','Pushbutton_Bearbeiten'),'enable','off');
         n_anfang2 =[1];
         d_anfang2 =[1];
         for i=1:9
            n_anfang2 = conv(n_anfang2,mainData{1,i}); 
            d_anfang2 = conv(d_anfang2,mainData{3,i}); 
         end
         p_anf2=[n_anfang2,d_anfang2];
         newSystem2=lsim(n_anfang2,d_anfang2,d.uerr,d.t);
         set(gcf,'CurrentAxes',H_mainAxes1 );          
         cla
         hp1=plot(d.t,d.ySystem,'b',d.t,newSystem2,'r');grid,legend('Systen-Antwort',...
            'Modell-Antwort',0);
         set(H_mainAxes1,'XLim',d.XLim,'YLim',d.YLim);
      else
         id_errordlg=errordlg(['Ungültige Daten in 'fname '!'],'Laden Fehler','on');
         set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');
      end
   else
      id_errordlg=errordlg(['Modelldaten in Datei 'fname ' nicht vorhanden!'],...
         'Laden Fehler','on');
      set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');
   end
end

