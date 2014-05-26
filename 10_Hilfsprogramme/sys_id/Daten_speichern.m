%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Daten_speichern.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion realisiert das Modul "Daten speichern". Die Daten  
%                     werden in einer Datei gespeichert.
%
%  Datum:             21-01-2003
%
%  Autor:             Jerzy Wykretowicz
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Daten_speichern()

global d
[newfile,newpath] = uiputfile('new_dat.mat','Daten speichern');

if(newfile)                                        % wenn Dateiname g�ltig:
   t =  d.t;                                       % Z�hler 
   uerr = d.uerr;                                  % und Nenner     
   ySystem = d.ySystem;               
   save ([newpath newfile],'t','uerr','ySystem');  % in *.mat Datei speichern
end

