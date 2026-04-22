%% Main Function
  constantValues

  femtos    = getRandmolyDistributedFemtoCells(NumOfFemtoCells,FemtoCellRadius,cells,Ctrl);              
%   
  users     = getRandmolyDistributedUsers(NumOfUsersPerMacroCell,userRBsDemand,cells,ULDCategory,Ctrl);

  NP        = getCellsNP(NumOfMacroCells,NumOfFemtoCells,NumOfUsersPerMacroCell,MacroCellRadius,cells,femtos,users,Ctrl);
  MyS       = getCellsMyS(NumOfMacroCells,NumOfFemtoCells,NumOfUsersPerMacroCell,MacroCellRadius,cells,femtos,users,Ctrl);
  FFR3S     = getCellsFFR3S(NumOfMacroCells,NumOfFemtoCells,NumOfUsersPerMacroCell,MacroCellRadius,cells,femtos,users,Ctrl);

%% get channel gain from each cell to each user at each RB
  [channelGain_macro,channelGain_femto] = ...
   getChannelCoeff(NumOfMacroCells,NumOfFemtoCells,NumOfUsersPerMacroCell,...
                   TotalNumOfRBs,Shadow_std_dB,users,cells,femtos);
%
%% resource allocation
NP = resourceAllocationNP(TotalNumOfRBs,NumOfFemtoCells,NumOfMacroCells,NumOfUsersPerMacroCell, ...
                                    channelGain_macro,channelGain_femto,MacroCellTxPower,FemtoCellTxPower,...
                                    cells,users,femtos,maxRBs,RSRQ_Threshold,ULDCategory,NP);
                                
MyS = resourceAllocationMyS(TotalNumOfRBs,NumOfFemtoCells,NumOfMacroCells,NumOfUsersPerMacroCell, ...
                                    channelGain_macro,channelGain_femto,MacroCellTxPower,FemtoCellTxPower,...
                                    cells,users,femtos,maxRBs,RSRQ_Threshold,MyS);
                                
FFR3S = resourceAllocationFFR3S(TotalNumOfRBs,NumOfFemtoCells,NumOfMacroCells,NumOfUsersPerMacroCell, ...
                                    channelGain_macro,channelGain_femto,MacroCellTxPower,FemtoCellTxPower,...
                                    cells,users,femtos,maxRBs,RSRQ_Threshold,FFR3S);

% %% SINR calculation
  
sinrCalculationNP;
sinrCalculationMyS;
sinrCalculationFFR3S;

%% Throughtput
throughputNP;
throughputMyS;
throughputFFR3S;

 %% Figures

%   figure;
%   x=1:NumOfMacroCells*NumOfUsersPerMacroCell;
%   plot(x,SINR_dB);
%   xlabel('Number of Users');
%   ylabel('SINR (dB)');
%   title('SINR')

%   figure;
%   plot(x,Capacity);
%   xlabel('Number of Users');
%   ylabel('Capacity (bps)');
%   title('Capacity');