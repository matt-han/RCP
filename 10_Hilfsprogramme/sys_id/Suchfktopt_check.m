%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Suchfktopt_check.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion prüft die Gültigkeit der Umgebungsparametern und
%                     gibt evtl. Fehlermeldung aus.
%
%  Datum:             21-01-2003
%
%  Autor:             Jerzy Wykretowicz
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Suchfktopt_check(action)

global h_opt opt defopt

err = 0;
if strcmp(action,'default')
   opt=defopt;
   set(h_opt(1),'String',num2str(opt.tolfun));
   set(h_opt(2),'String',num2str(opt.tolx));
   set(h_opt(3),'String',num2str(opt.maxfuneval));
   set(h_opt(4),'String',num2str(opt.refresh));
elseif strcmp(action,'change')
   temp  = str2num(get(h_opt(1),'String'));
   if (isreal(temp) & isnumeric(temp) & (length(temp)==1) & (temp > 0))
      opt.tolfun = temp;
   else
      err = 1;    
   end    
   temp  = str2num(get(h_opt(2),'String'));
   if (isreal(temp) & isnumeric(temp) & (length(temp)==1) & (temp > 0))
      opt.tolx = temp;
   else
      err = 1;    
   end    
   temp  = round(str2num(get(h_opt(3),'String')));
   if (isreal(temp) & isnumeric(temp) & (length(temp)==1) & (temp > 0))
      opt.maxfuneval = temp;
   else
      err = 1;    
   end    
   temp  = round(str2num(get(h_opt(4),'String')));
   if (isreal(temp) & isnumeric(temp) & (length(temp)==1) & (temp > 0))
      opt.refresh = temp;
   else
      err = 1;    
   end    
   set(h_opt(1),'String',num2str(opt.tolfun));
   set(h_opt(2),'String',num2str(opt.tolx));
   set(h_opt(3),'String',num2str(opt.maxfuneval));
   set(h_opt(4),'String',num2str(opt.refresh));
   if (err == 1)
      id_errordlg=errordlg('Ungültiger Eingabewert!','Optionen Fehler','on');
      set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');
   else
      close(findobj(0,'Tag','options_fig'));
   end
end
            
            
