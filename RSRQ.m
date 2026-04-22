function RxPwr = RSRQ(Dist,FemtoCellTxPower)

PL                  =   indoorPathLossdB(Dist);

% NumOfLayers = 3;
% RxPwr = zeros(NumOfLayers);

% for i=1:NumOfLayers
% FemtoCellTxPower    =   20e-2;                                 %Watt

TxPower             = 	10*log10(FemtoCellTxPower)+30;       %dBm

RxPwr                =   TxPower-PL;
% end
end