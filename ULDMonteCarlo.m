clear;
clc;
close all;
%%
M               = input('\nEnter the number of Macrocells:  ');
NumOfFemtoCells = input('\nEnter number of Femtocells:  ');
ULDCategory     = 3;
U               = 100;  % input('\nEnter the number of total Users per Macrocell:  ');
I               = input('\nEnter the number of Iteration:  ');
lambda          = 75;

NumOfMacroCells         = M;
% NumOfUsersPerMacroCell  = U;

% Show Progress
Ctrl.showProcess        = true;
c                       = 0;


C1_numOfUsersPerIteration = zeros(I,M);

% %NP
C1_Throughput_macroNP       =   zeros(U*M,I);
C1_Throughput_femtoNP       =   zeros(U*M,I);
C1_ThroughputNP             =   zeros(U*M,I);
C1_Efficiency_NP            =   zeros(I,1);
C1_SINRdB_NP                =   zeros(U*M,I);
 
%MyS
C1_Throughput_macroMyS     =   zeros(U*M,I);
C1_Throughput_femtoMyS     =   zeros(U*M,I);
C1_ThroughputMyS           =   zeros(U*M,I);
C1_Efficiency_MyS          =   zeros(I,1);
C1_SINRdB_MyS              =   zeros(U*M,I);

%FFR3S
C1_Throughput_macroFFR3S   =   zeros(U*M,I);
C1_Throughput_femtoFFR3S   =   zeros(U*M,I);
C1_ThroughputFFR3S         =   zeros(U*M,I);
C1_Efficiency_FFR3S        =   zeros(I,1);
C1_SINRdB_FFR3S            =   zeros(U*M,I);

%% Radius Size Changing Loop
    
    %% Iterations
for iteration=1:I
        
        NumOfUsersPerMacroCell = poissrnd(lambda);
        C1_numOfUsersPerIteration(iteration) = NumOfUsersPerMacroCell;
        
% Run Main File        
        main_func;
% % Calculate the SINR
% % sinrCalculation;
% % Find the Throughput
% % throughput;

        % NP
        C1_Throughput_femtoNP(1:NumOfUsersPerMacroCell,iteration)     = NP.eachUserThroughput_femto;
        C1_Throughput_macroNP(1:NumOfUsersPerMacroCell,iteration)     = NP.eachUserThroughput_macro;
        C1_ThroughputNP(1:NumOfUsersPerMacroCell,iteration)           = NP.eachUserThroughput;
        C1_Efficiency_NP(iteration,1)                                 = NP.Efficiency;
        C1_SINRdB_NP(1:NumOfUsersPerMacroCell,iteration)              = NP.SINR_dB(:,1);
        
        % MyS
        C1_Throughput_femtoMyS(1:NumOfUsersPerMacroCell,iteration)    = MyS.eachUserThroughput_femto;
        C1_Throughput_macroMyS(1:NumOfUsersPerMacroCell,iteration)    = MyS.eachUserThroughput_macro;
        C1_ThroughputMyS(1:NumOfUsersPerMacroCell,iteration)          = MyS.eachUserThroughput;
        C1_Efficiency_MyS(iteration,1)                                = MyS.Efficiency;
        C1_SINRdB_MyS(1:NumOfUsersPerMacroCell,iteration)             = MyS.SINR_dB(:,1);
                
        % FFR3S
        C1_Throughput_femtoFFR3S(1:NumOfUsersPerMacroCell,iteration)  = FFR3S.eachUserThroughput_femto;
        C1_Throughput_macroFFR3S(1:NumOfUsersPerMacroCell,iteration)  = FFR3S.eachUserThroughput_macro;
        C1_ThroughputFFR3S(1:NumOfUsersPerMacroCell,iteration)        = FFR3S.eachUserThroughput;
        C1_Efficiency_FFR3S(iteration,1)                                = FFR3S.Efficiency;
        C1_SINRdB_FFR3S(1:NumOfUsersPerMacroCell,iteration)           = FFR3S.SINR_dB(:,1);
             
        if Ctrl.showProcess
                c = c + 1;
                fprintf('%3.0f percent is done \n', c*100/I);
        end
end

%% Normalization
Ind0 = 0;
Users = C1_numOfUsersPerIteration;

for k = 1 : I
    Ind = Ind0 + Users(k);
    C1_ThrNP(Ind0+1:Ind,1)      = C1_ThroughputNP(1:Users(k),k);
    C1_ThrMyS(Ind0+1:Ind,1)     = C1_ThroughputMyS(1:Users(k),k);
    C1_ThrFFR3S(Ind0+1:Ind,1)   = C1_ThroughputFFR3S(1:Users(k),k);
    Ind0 = Ind0 + Users(k);
end

%% Taking Averages
C1_Efficiency_NP       = mean(C1_Efficiency_NP);
C1_Efficiency_MyS      = mean(C1_Efficiency_MyS);
C1_Efficiency_FFR3S    = mean(C1_Efficiency_FFR3S);


% Category 1
save 'Results\C1_numOfUsersPerIteration.mat' C1_numOfUsersPerIteration;

%% NP
% save 'Results\C1_femtoThroughputNP.mat' C1_Throughput_femtoNP;
% save 'Results\C1_macroThroughputNP.mat' C1_Throughput_macroNP;
save 'Results\C1_ThroughputNP.mat' C1_ThrNP;
% save 'Results\C1_Efficiency_NP.mat' C1_Efficiency_NP;
% save 'Results\C1_SINRdB_NP.mat' C1_SINRdB_NP

% MyS
% save 'Results\C1_femtoThroughputMyS.mat' C1_Throughput_femtoMyS;
% save 'Results\C1_macroThroughputMyS.mat' C1_Throughput_macroMyS;
save 'Results\C1_ThroughputMyS.mat' C1_ThrMyS;
% save 'Results\C1_Efficiency_MyS.mat' C1_Efficiency_MyS;
% save 'Results\C1_SINRdB_MyS.mat' C1_SINRdB_MyS


% FFR3S
% save 'Results\C1_femtoThroughputFFR3S.mat' C1_Throughput_femtoFFR3S;
% save 'Results\C1_macroThroughputFFR3S.mat' C1_Throughput_macroFFR3S;
save 'Results\C1_ThroughputFFR3S.mat' C1_ThrFFR3S;
% save 'Results\C1_Efficiency_FFR3S.mat' C1_Efficiency_FFR3S;
% save 'Results\C1_SINRdB_FFR3S.mat' C1_SINRdB_FFR3S

% After finishing the simulation, run the 'showResults' file to see the results.