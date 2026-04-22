%% Category 1 NP
load 'Results\C1_ThroughputNP.mat';
C1_ThrNP = C1_ThrNP/1e6;
C1_Total_Throughput_NP = sum(C1_ThrNP)
C1_Block_Rate_NP = length(find(C1_ThrNP==0))
% C1_ThrNP(ind)=[];

n = length(C1_ThrNP);
x_min=min(C1_ThrNP);
x_max=max(C1_ThrNP);
X_range=x_min:0.5:x_max;
% X_range = 0:0.5:16;
bin=length(X_range);

NxNP=hist(C1_ThrNP,bin);
PxNP=NxNP/n; % generate pmf
FxNP=cumsum(PxNP); % generate cdf
figure
subplot(211),bar(X_range,PxNP)
str = sprintf('C1 NP Histogram');
title(str);
subplot(212),stairs(X_range,FxNP)
str = sprintf('C1 NP CDF');
title(str);

C1_meanNP   = mean(C1_ThrNP);
C1_modNP    = mode(C1_ThrNP);
C1_medianNP = median(C1_ThrNP);

%% Sultan hoca code
C1_NP00=0;    C1_NP0_5=0;
C1_NP01=0;    C1_NP1_5=0; 
C1_NP02=0;    C1_NP2_5=0;
C1_NP03=0;    C1_NP3_5=0;
C1_NP04=0;    C1_NP4_5=0;
C1_NP05=0;    C1_NP5_5=0;
C1_NP06=0;    C1_NP6_5=0;
C1_NP07=0;    C1_NP7_5=0;
C1_NP08=0;    C1_NP8_5=0;
C1_NP09=0;    C1_NP9_5=0;
C1_NP10=0;    

for ii=1:length(C1_ThrNP)
    if C1_ThrNP(ii) == 0 
        C1_NP00 = C1_NP00+1;
    elseif C1_ThrNP(ii)<= 0.5
        C1_NP0_5 = C1_NP0_5+1;
    elseif C1_ThrNP(ii)<= 1
        C1_NP01 = C1_NP01+1;
    elseif C1_ThrNP(ii)<= 1.5
        C1_NP1_5 = C1_NP1_5+1;
    elseif C1_ThrNP(ii)<= 2
        C1_NP02 = C1_NP02+1;
    elseif C1_ThrNP(ii)<= 2.5
        C1_NP2_5 = C1_NP2_5+1;
    elseif C1_ThrNP(ii)<= 3
        C1_NP03 = C1_NP03+1;
    elseif C1_ThrNP(ii)<= 3.5
        C1_NP3_5 = C1_NP3_5+1;
    elseif C1_ThrNP(ii)<= 4
        C1_NP04 = C1_NP04+1;
    elseif C1_ThrNP(ii)<= 4.5
        C1_NP4_5 = C1_NP4_5+1;
    elseif C1_ThrNP(ii)<= 5
        C1_NP05 = C1_NP05+1;
    elseif C1_ThrNP(ii)<= 5.5
        C1_NP5_5 = C1_NP5_5+1;
    elseif C1_ThrNP(ii)<= 6
        C1_NP06 = C1_NP06+1;
    elseif C1_ThrNP(ii)<= 6.5
        C1_NP6_5 = C1_NP6_5+1;
    elseif C1_ThrNP(ii)<= 7
        C1_NP07 = C1_NP07+1;
    elseif C1_ThrNP(ii)<= 7.5
        C1_NP7_5 = C1_NP7_5+1;
    elseif C1_ThrNP(ii)<= 8
        C1_NP08 = C1_NP08+1;
    elseif C1_ThrNP(ii)<= 8.5
        C1_NP8_5 = C1_NP8_5+1;
    elseif C1_ThrNP(ii)<= 9
        C1_NP09 = C1_NP09+1;
    elseif C1_ThrNP(ii)<= 9.5
        C1_NP9_5 = C1_NP9_5+1;
    elseif C1_ThrNP(ii)<=10 || C1_ThrNP(ii)> 10
        C1_NP10 = C1_NP10+1;
    end
end
counter_NP     = [C1_NP00 C1_NP0_5 C1_NP01 C1_NP1_5 C1_NP02 C1_NP2_5 C1_NP03 C1_NP3_5 C1_NP04 C1_NP4_5 C1_NP05 C1_NP5_5 C1_NP06 C1_NP6_5 C1_NP07 C1_NP7_5 C1_NP08 C1_NP8_5 C1_NP09 C1_NP9_5 C1_NP10];
prob_NP        = counter_NP./n;
cdf_NP         = cumsum(prob_NP); % generate cdf
ccdf_genNP     = 1-cumsum(prob_NP);