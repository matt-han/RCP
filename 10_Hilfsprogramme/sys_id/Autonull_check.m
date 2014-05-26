%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Dateiname:         Autonull_check.m
%
%  Projekt:           Identifikationssystem
%
%  Kurzbeschreibung:  Diese Funktion überprüft die eingegebenen Parameter und berechnet 
%							 die neuen Nullpunkte des zu identifizierenden Systems.
%
%  Datum:             21-01-2003
%
%  Autor:             René Nörenberg
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Autonull_check()

global h_opt optan defoptan s5 l5 e5 s6 e6 l6 stack sc
err = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%								Überprüfung der Parameter  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   temp  = str2num(get(h_opt(1),'String'));
   if (isreal(temp) & isnumeric(temp) & (length(temp)==1)& (temp >= min(stack(sc).t))& (temp <= max(stack(sc).t)))
      optan.tmin = temp;
   else
      err = 1;    
   end    
   temp  = str2num(get(h_opt(2),'String'));
   if (isreal(temp) & isnumeric(temp) & (length(temp)==1) & (temp > optan.tmin)& (temp <= max(stack(sc).t)))
      optan.tmax = temp;
   else
      err = 1;    
   end    
  
   set(h_opt(1),'String',num2str(optan.tmin));
   set(h_opt(2),'String',num2str(optan.tmax));
   if (err == 1)
      id_errordlg=errordlg('Ungültiger Eingabewert!','Optionen Fehler','on');
      set(id_errordlg,'Tag','error_dlg','WindowStyle','modal');
   else
      close(findobj(0,'Tag','options_fig'));
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%					Berechnung der neuen Nullpunkte und anzeige in Daten_bereich.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if (err ~= 1)
   indexmin=1;
   while stack(sc).t(indexmin) ~= optan.tmin+1
      indexmin=indexmin+1;
   end
   indexmax=1;
	while stack(sc).t(indexmax) ~= optan.tmax
      indexmax=indexmax+1;
   end
   yary = stack(sc).y(indexmin:indexmax);
   tmp=mean(yary);
   set(s5,'Value',tmp);
   set(l5,'YData',[tmp tmp]);
   set(e5,'String',num2str(get(s5,'Value')));
   uary = stack(sc).u(indexmin:indexmax);
   tmp=mean(uary);
   set(s6,'Value',tmp);
   set(l6,'YData',[tmp tmp]);
   set(e6,'String',num2str(get(s6,'Value')));
end
