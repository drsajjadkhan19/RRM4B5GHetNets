% % clear
%   clear
%   clc
%   close all
% 
% % controlling parameters
%   
% % parameters
% % Variable Parameters
%   NumOfMacroCells           = 1;
%   NumOfFemtoCells           = 20;
%   NumOfUsersPerMacroCell    = 53;
%   ULDCategory               = 1;
  
  % Fixed Parameters
  Ctrl.ShowCellsDeployment  = [false, false, false];
  
  TargetBitErrorRate        = 1e-6;
  NoisePowerDensitydBm      = -174;
  NumOfUsersPerFemtoCell    = 1;
  MacroCellRadius           = 500;      % radius in meters
  
%   usersCentralDensity       = 0.50;     % percent of total users
  FemtoCellRadius           = 30;       % radius in meters
  TotalBandwidth            = 18e6;
  NumOfSubcarriersPerRB     = 12;
  MacroCellTxPower          = [1 16 22];      %Watt
  FemtoCellTxPower          = 20e-2;          %Watt=23dBm
  
%   OutdoorPathLossdB       = @(d) 28+35*log10(d);
%   IndoorPathLossdB        = @(d) indoorPathLossdB(d);
  Shadow_std_dB             = 6;
 %% constants
  DeltaF                    = 15e3;      % subcarrier bandwidth
  Alpha                     = -1.5/log(5*TargetBitErrorRate);
  NoisePowerDensity         = 10^(0.1*(NoisePowerDensitydBm-30));
    
% dependent parameters    
  TotalNumOfRBs         = TotalBandwidth/(NumOfSubcarriersPerRB*DeltaF);
  typeOfUEs             = [1 2 3];  % 2 --> Basic User, 5 ---> Moderate User, and 10 --> Heavy User 
  chooseInd             = randi(length(typeOfUEs),1,TotalNumOfRBs);
  userRBsDemand         = typeOfUEs(chooseInd);
  maxRBs                = 10;
  RSRQ_Threshold        = -80;
  
%  d = randi(length(userRBsDemand),1);
%  RBsDemand = userRBsDemand(d);
% get cells/ users / femto cells
  cells  = getCells(NumOfMacroCells,MacroCellRadius,Ctrl);