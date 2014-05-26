% Programm "polkomp.m"
%
% Matalb-Programm zur halbautomatischen Regleroptimierung mit der 
% Polkompensations-Methode im Bodediagramm des offenen Regelkreises

clear					% Matlab-Arbeitsspeicher s�ubern.
home 					% Command-Window s�ubern.
close all			% Alles "Figures" schlie�en.

% Kommunikation mit dem Benutzer
%
disp(' ')
disp(' ')
disp('     ------------------------------------------------')
disp('     HALBAUTOMATISCHER REGLERENTWURF NACH DER ')
disp('            POLKOMPENSATIONS-METHODE')
disp('     ----------------------------------------------- ')
disp(' ')
disp('     Geben sie bitte ein: ')
zs=input('       Z�hlerpolynom der Regelstrecke (in [ ]): ');
ns=input('       Nennerpolynom der Regelstrecke (in [ ]): ');
zm=input('       Z�hlerpolynom der Messeinrichtung (in [ ]): ');
nm=input('       Nennerpolynom der Messeinrichtung (in [ ]): ');
						% Abfrage der �bertragungsfunktions-
						% Parameter des offenen Kreises ohne Regler.

[zokor,nokor]=series(zs,ns,zm,nm); 
						% Bildung der �bertragungsfunktion des
						% offenen Kreis ohne Regler.

% Berechnung der V-Normalform der �bertragungsfunktion des offenen Kreises
% ohne Regler. Anschlie�end erfolgt die Reglerauswahl, die manuelle 
% Polkompensation und die Auswahl der Grenzen des Omega-Darstellungs-
% bereichs des Bodediagramms. Das Bodediagramm des offenen Kreises
% ohne Regler wird angezeigt. 
% Der Vorgang kann beliebig lange wiederholt werden.
%
wahl=1;					% wahl ist gleich 1, solange man sich in der
while wahl==1			% Abfrage-Schleife aufh�lt.
	home
	disp(' ')
	disp(' ')
	disp('     V-Normalform des offenen Kreises ohne Regler')
	disp('     --------------------------------------------')
	disp(' ')
	tf2vn (zokor,nokor);	
	disp('   ----------------------------------------------')
   disp(' ')
   disp(' ')
   disp(' ')
	disp('     W�hlen Sie einen Reglertyp')
	disp('     --------------------------')
	disp('      (1):  P-Regler ')
	disp('      (2):  PD-Regler ')
	disp('      (3):  PI-Regler ')
	disp('      (4):  PID-Regler ')
	
	rid=input('     Geben Sie die Kenziffer ein: ');
							% rid = Reglerauswahl-Identifizierung.
	if rid==1			% P-Regler.
		zreg=1;			% Umrechnnung in Polynomschreibweise
		nreg=1;
	elseif rid==2		% PD-Regler.
		T=input('     Z�hlerzeitkonstante T: ');
		TR=input('     Realisierungszeitkonstante TR: ');
		zreg=[T,1];		% Umrechnnung in Polynomschreibweise
		nreg=[TR,1];
	elseif rid==3		% PI-Regler.
		T=input('     Z�hlerzeitkonstante T: ');
		zreg=[T,1];		% Umrechnnung in Polynomschreibweise
		nreg=[1,0];
	elseif rid==4		% PID-Regler.
		T1=input('     Z�hlerzeitkonstante T1: ');
		T2=input('     Z�hlerzeitkonstante T2: ');
		TR=input('     Realisierungszeitkonstante TR: ');
		zreg=[T1*T2,T1+T2,1];% Umrechnnung in Polynomschreibweise
		nreg=[TR,1,0];
	else
		break 			% bei Fehleingabe
	end

	[zo,no]=series(zokor,nokor,zreg,nreg);	
							% �bertragungsfunktion des offenen
							% Kreises mit Reglerverst�rkungsfaktor V=1.

	% Parametrierung des Bodediagramms
	home
	disp(' ')
	disp(' ')
	disp('     Geben sie den Darstellungsbereich f�r das Bodediagramm an')
	u=input('        Untere Kreisfrequenz-Grenze : ');
	unten=log10(u);	% notwendige Umrechnung f�r den Befehl "logspace"
	o=input('        Obere Kreisfrequenz-Grenze : ');
	disp(' ')
	disp(' ')
	oben=log10(o);		% notwendige Umrechnung f�r den Befehl "logspace"	
	omega=logspace(unten, oben,800);
							% Omeage-Darstellungsbereich des Bodediagramms
	[b,p]=bode(zo,no,omega);% siehe "help bode"
	bdB=20*log10(b);	% Betragskennlinie in dB.
	figure(1)
	subplot(2,1,1)
	semilogx(omega,bdB), grid
							% Zeichnung der Betragskennlinie
	title('Bodediagramm des offenen Regelkreises mit kompensierten Polen, Regler-Verst�rkungsfaktor = 1.')
	subplot(2,1,2)
	semilogx(omega,p), grid	
							% Zeichnung der Phasenkennlinie
	home
	disp(' ')
	disp(' ')
	disp('     Anderen Regler, andere Kompensationzeitkontanten, ')
	antwort=input('     oder anderen Darstellungsbreich des Bodediagramms? (j/n) :','s');
	if antwort=='n'
		wahl=0;			% nein, raus aus Schleife,
	end					% weiter im Programm.
end




% Festlegung des Regler-Verst�rkungsfaktors. Die Auswahl des kann 
% beliebig lange wiederholt werden.

Vid=1;					% Vid ist gleich 1 solange der Regler-
while Vid==1			% verst�rkungs-Faktor optimiert wird
	home
	disp(' ')
	disp(' ')
	% Die folgende Programmsequenz in "--------" sucht aus der Phasen-
	% kennlinie solche Phasenwerte heraus, die inder N�he des gew�nschten
	% Phasenrandes liegen. Mittels des Befehls "index" werden die 
	% dazugeh�rigen Werte der Betragskennlinie gesucht und mit den
	% Phasenwerten ausgegeben.
	% ----------------------------------------------------------------------
	phirand=input('     Geben Sie den gew�nschten Phasenrand ein (Grad): ');
	disp(' ')
	phir=(180*ones(size(p))-abs(p));
	phir0=phir-phirand*ones(size(p));
	index=find(phir0<2 & phir0>-2);
	disp('     Laut Bodediagramm ergeben sich in der N�he des')
	disp('     gew�nschten Pasenrands folgende Verstaerkungs-')
	disp('     ma�e des offenen Kreises :')
	disp(' ')
	disp('    Phi_r       Voffen [dB]')
	[phir(index),bdB(index)] 
	% ----------------------------------------------------------------------
	VdB=input('     W�hlen Sie das Verst�rkungsma� f�r den Regler (in dB): ');
	V=10^(VdB/20);

	% Berechnung von Durchtrittsfrequenz und Phasenrand f�r den
	% gew�hlten Regler, zur Entscheidung, ob Reglerwahl und Parametrierung
	% den W�nschen entsprechen.
	disp(' ')
	disp(' ')
	omega=logspace(-2,2,800);	
							% Zur Prametrierung des Befehls "margin".
	zoneu=V*zo;			% Der Zaehler des Offenen Kreises "zo"
							% wird mit dem gew�hlten Regler-Verst�r-
							% kungsfaktor multipliziert.
	[ar,phr,war,wc]=margin(zoneu,no);
							% Berechnungdes Phasenrandes "phr"
							% und der Durchtrittsfrequenz "wc".
	disp('     Mit diesem Verstaerkungsfaktor ergeben sich: ')
	disp(['        Phasenrand         :',num2str(phr),' Grad']);
	disp(['        Durchtrittsfrequenz: ',num2str(wc),' 1/sek.']);
	disp(' ')
	disp(' ')
	antwort=input('     Verst�rkungsfaktor aendern? (j/n) :','s');
	if antwort=='n'
		Vid=0;
	end
end


% Ausgabe der berechneten Reglerparameter
%
home
disp(' ')
disp(' ')
disp('     Der optimierte Regler hat folgende �bertragungsfunktion ')
disp(' ')
disp(' ')
disp('     - Polynomform: ')
printsys(V*zreg,nreg)						% Polynomform des Reglers
disp(' ')
disp('     - V-Normalform: ')
tf2vn (V*zreg,nreg);							% V-Normalform des Reglers

% Berechnung der F�hrungssprungantwort
%
[zrs,nrs]=series(V*zreg,nreg,zs,ns);	
													% Reihenschaltung von Regler
													% Strecke.
[zkf,nkf]=feedback(zrs,nrs,zm,nm,-1);	% Berechnung der F�hrungs-
													% �bertragungsfunktion.
figure(2)
subplot(2,1,1)
step(zkf,nkf);									% F�hrungs-Sprungantwort
grid on
title('F�hrungssprungantwort')


% Berechnung der dazugeh�rigen Stellamplitude
%
[zsm,nsm]=series(zs,ns,zm,nm);			% Reiehnschaltung von Strecke
													% und Messeinrichtung.
[zku,nku]=feedback(V*zreg,nreg,zsm,nsm,-1);
													% Berechnung der Stellgr�ssen-
													% �bertragungsfunktion.
subplot(2,1,2)
step(zku,nku);									% Stell-Sprungantort bei
													% F�hrungssprung
grid on
title('dazugehoerige Stellgr�sse')



