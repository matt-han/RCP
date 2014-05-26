%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Daten_bearbeiten.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion realisiert das Modul "Daten bearbeiten", hier werden
%                     weitere Funktionen fuer Datenvorverarbeitung aufgerufen.
%
%  Datum:             21-01-2003
%
%  Autor:             Jerzy Wykretowicz
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Daten_bearbeiten()

htmp=findobj(0,'Tag','PopupMenu_Bearbeiten');
action=get(htmp,'Value');
set(htmp,'Value',1);

if(action==2)        
   Daten_bereich    
elseif(action==3)
   Daten_filter
elseif(action==4)        
   Daten_dezimieren    
end