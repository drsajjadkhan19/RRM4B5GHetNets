function Pathloss = indoorPathLossdB(d)

%ITU-R P.1238-9 (06/2017) 
f   =   2000;               %MHz
do  =   1;                  %Reference distance in meter
Ldo =   20*log10(f)-28 ;    
N   =   25.5;               %Distance Power Loss Coefficient
n   =   1;                  %Num. of floors
Lf  =   15+4*(n-1);         %Floor penetration, while n= no. of floors    

Pathloss    =   Ldo+N*log10(d/do)+Lf ;    %dB

end
