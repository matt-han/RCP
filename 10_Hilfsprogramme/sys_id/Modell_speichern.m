%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Modell_speichern.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion realisiert das Modul "Modell speichern". Das Modell 
%                     wird in einer Datei gespeichert.
%
%  Datum:             21-01-2003
%
%  Autor:             Jerzy Wykretowicz
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Modell_speichern()

global n_anfang2 d_anfang2 mainData

[newfile,newpath] = uiputfile('modell_tf.mat','Modell-Übertragungsfunktion speichern');

if(newfile)                                        % wenn Dateiname gültig:
   num = n_anfang2;                                % Zähler 
   den = d_anfang2;                                % und Nenner     
   save ([newpath newfile],'num','den');           % in *.mat Datei speichern
end

