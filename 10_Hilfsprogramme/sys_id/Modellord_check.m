%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Modellord_check.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion realisiert das Untermodul "Modellord_check". Die Ordnung
%                     des Modells wird geprüft und evtl. Fehlermeldung ausgegeben.
%
%  Datum:             21-01-2003
%
%  Autor:             Jerzy Wykretowicz
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Modellord_check()

global param2 

temp(1)=2;
temp(2)=get(findobj( 0, 'Tag' , 'PopupMenu2'),'Value');
temp(3)=get(findobj( 0, 'Tag' , 'PopupMenu3'),'Value');
temp(4)=get(findobj( 0, 'Tag' , 'PopupMenu4'),'Value');
temp(5)=get(findobj( 0, 'Tag' , 'PopupMenu5'),'Value');
temp(6)=get(findobj( 0, 'Tag' , 'PopupMenu6'),'Value');
temp(7)=get(findobj( 0, 'Tag' , 'PopupMenu7'),'Value');

if (temp(2)+temp(4)+2*temp(5))>(temp(3)+temp(6)+2*temp(7))
   id_errordlg=errordlg(['Die Ordnung des Nenners muss größer '...
      'oder gleich der Ordnung des Zählers sein !'],'Modellordnung Fehler','on');
   set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');
    
elseif ( (temp(3)+temp(6)+temp(7)) <= 3 )
   id_errordlg=errordlg('Die Ordnung der Modell-Übertragungsfunktion ist 0 !',...
      'Modellordnung Fehler','on');
   set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');%,'DeleteFcn','close(gcf);');
    
elseif ( (temp(2) == temp(3) ) & ( temp(6)+temp(7)) <= 2 )
   id_errordlg=errordlg(['Nach der Reduktion ist die Ordnung '...
      'der Modell-Übertragungsfunktion 0 !'],'Modellordnung Fehler','on');
   set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');

elseif ( temp(3)-min(temp(3),temp(2))+(temp(6)-1)+2*(temp(7)-1)) > 5
   id_errordlg=errordlg(['Die Ordnung der Modell-Übertragungsfunktion '...
      'kann nicht größer als 5 sein !'],'Modellordnung Fehler','on');
   set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');

else
   param2 = temp;
   close(gcf);
   set_parameter('initialize',0,0,0);

   h_btn = findobj(0,'tag','Pushbutton_Übernehmen');   % Erst wenn zu identifizierendes System
   set(h_btn,'enable','on');                      % geladen ist, kann man Modell-Fuktion bilden
   h_btn = findobj(0,'tag','Pushbutton_Vorherige');   % Erst wenn zu identifizierendes System
   set(h_btn,'enable','on');                      % geladen ist, kann man Modell-Fuktion bilden
   h_btn = findobj(0,'tag','Pushbutton_Default'); % Erst wenn zu identifizierendes System
   set(h_btn,'enable','on');                      % geladen ist, kann man Modell-Fuktion bilden
   h_btn = findobj(0,'tag','Pushb_Mod_Speichern');    % Erst wenn zu identifizierendes System
   set(h_btn,'enable','on');                          % geladen ist, kann man Modell speichern
   h_btn = findobj(0,'tag','Pushbutton_Simulation');  % Erst wenn zu identifizierendes System
   set(h_btn,'enable','on');                          % geladen ist, kann man Modell simulieren
   h_btn = findobj(0,'tag','Pushbutton_Start');  % Erst wenn zu identifizierendes System
   set(h_btn,'enable','on');                     % geladen ist, kann man Modell-Fuktion bilden
   h_btn = findobj(0,'tag','Pushbutton_Stop');   % Erst wenn zu identifizierendes System
   set(h_btn,'enable','on');                     % geladen ist, kann man Modell-Fuktion bilden
   set(findobj(0,'Tag','PopupMenu_Bearbeiten'),'enable','off');
   set(findobj(0,'Tag','Pushbutton_DatenSpeichern'),'enable','off');
end


