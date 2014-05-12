home
clear
close All

%%Variable laden
load('ScopeIn');

%Y-Werte von 0 bis 10 V in 0.5 Schritte
kennlinieY = [0.5:0.5:10];
kennlinieX = zeros(1,20)
%Offset zum eingeschwungener Zustand
offset = 940;

for j = 0:19
    wert = 0;
    k = (j * 1000) + offset;
    
    %berechnung des Mittelwerts von X.94 - X.96
    for i = 0:19
        k = k + 1;
        wert = wert + ScopeIn(k,2);
    end
        
    %Mittelwert berechnen
    kennlinieX(j+1) = wert / 20;
end

plot(kennlinieX)
grid on
title('Statische Kennlinie')
xlabel('Ausgang')
ylabel('Eingang')