

function d = PLcalculation(Pt, Rx)

PL = Pt-Rx;             %PL in dB

x=(PL-38.5-15)/20;     %if PL = 38.5 + 20*log10(d) + 15; 38.5 + 20*log10(d) + 15

d=10^x;

end