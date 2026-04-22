 clear;
clc;
close all;

% Load the saved data from computer

% Input Values

% ULD Category 1;
%% Category 1 NP
load 'Results\C1_ThroughputNP.mat';
C3_ThrNP = C3_ThrNP/1e6;
Total_Throughput_NP = sum(C3_ThrNP)
Block_Rate_NP = length(find(C3_ThrNP==0))
% C3_ThrNP(ind)=[];

n = length(C3_ThrNP);
x_min=min(C3_ThrNP);
x_max=max(C3_ThrNP);
X_range=x_min:0.5:x_max;
% X_range = 0:0.5:16;
bin=length(X_range);

NxNP=hist(C3_ThrNP,bin);
PxNP=NxNP/n; % generate pmf
FxNP=cumsum(PxNP); % generate cdf
figure
subplot(211),bar(X_range,PxNP)
str = sprintf('NP Histogram');
title(str);
subplot(212),stairs(X_range,FxNP)
str = sprintf('NP CDF');
title(str);

X_meanNP   = mean(C3_ThrNP);
X_modNP    = mode(C3_ThrNP);
X_medianNP = median(C3_ThrNP);

%% Sultan hoca code
NP00=0;    NP0_5=0;
NP01=0;    NP1_5=0; 
NP02=0;    NP2_5=0;
NP03=0;    NP3_5=0;
NP04=0;    NP4_5=0;
NP05=0;    NP5_5=0;
NP06=0;    NP6_5=0;
NP07=0;    NP7_5=0;
NP08=0;    NP8_5=0;
NP09=0;    NP9_5=0;
NP10=0;    

for ii=1:length(C3_ThrNP)
    if C3_ThrNP(ii) == 0 
        NP00 = NP00+1;
    elseif C3_ThrNP(ii)<= 0.5
        NP0_5 = NP0_5+1;
    elseif C3_ThrNP(ii)<= 1
        NP01 = NP01+1;
    elseif C3_ThrNP(ii)<= 1.5
        NP1_5 = NP1_5+1;
    elseif C3_ThrNP(ii)<= 2
        NP02 = NP02+1;
    elseif C3_ThrNP(ii)<= 2.5
        NP2_5 = NP2_5+1;
    elseif C3_ThrNP(ii)<= 3
        NP03 = NP03+1;
    elseif C3_ThrNP(ii)<= 3.5
        NP3_5 = NP3_5+1;
    elseif C3_ThrNP(ii)<= 4
        NP04 = NP04+1;
    elseif C3_ThrNP(ii)<= 4.5
        NP4_5 = NP4_5+1;
    elseif C3_ThrNP(ii)<= 5
        NP05 = NP05+1;
    elseif C3_ThrNP(ii)<= 5.5
        NP5_5 = NP5_5+1;
    elseif C3_ThrNP(ii)<= 6
        NP06 = NP06+1;
    elseif C3_ThrNP(ii)<= 6.5
        NP6_5 = NP6_5+1;
    elseif C3_ThrNP(ii)<= 7
        NP07 = NP07+1;
    elseif C3_ThrNP(ii)<= 7.5
        NP7_5 = NP7_5+1;
    elseif C3_ThrNP(ii)<= 8
        NP08 = NP08+1;
    elseif C3_ThrNP(ii)<= 8.5
        NP8_5 = NP8_5+1;
    elseif C3_ThrNP(ii)<= 9
        NP09 = NP09+1;
    elseif C3_ThrNP(ii)<= 9.5
        NP9_5 = NP9_5+1;
    elseif C3_ThrNP(ii)<=10 || C3_ThrNP(ii)> 10
        NP10 = NP10+1;
    end
end
counter_NP     = [NP00 NP0_5 NP01 NP1_5 NP02 NP2_5 NP03 NP3_5 NP04 NP4_5 NP05 NP5_5 NP06 NP6_5 NP07 NP7_5 NP08 NP8_5 NP09 NP9_5 NP10];
prob_NP        = counter_NP./n;
cdf_NP         = cumsum(prob_NP); % generate cdf
ccdf_genNP     = 1-cumsum(prob_NP);

%% MyS
load 'Results\C3_ThroughputMyS.mat';
C3_ThrMyS = C3_ThrMyS/1e6;
Total_Throughput_MyS = sum(C3_ThrMyS)
Block_Rate_MyS = length(find(C3_ThrMyS==0))
% C3_ThrMyS(ind)=[];

n = length(C3_ThrMyS);
x_min=min(C3_ThrMyS);
x_max=max(C3_ThrMyS);
X_range=x_min:0.5:x_max;
% X_range = 0:0.5:16;
bin=length(X_range);

NxMyS=hist(C3_ThrMyS,bin);
PxMyS=NxMyS/n; % generate pmf
FxMyS=cumsum(PxMyS); % generate cdf
figure
subplot(211),bar(X_range,PxMyS)
str = sprintf('MyS Histogram');
title(str);
subplot(212),stairs(X_range,FxMyS)
str = sprintf('MyS CDF');
title(str);

X_meanMyS   = mean(C3_ThrMyS);
X_modMyS    = mode(C3_ThrMyS);
X_medianMyS = median(C3_ThrMyS);

%% Sultan hoca code
MyS00=0;    MyS0_5=0;
MyS01=0;    MyS1_5=0; 
MyS02=0;    MyS2_5=0;
MyS03=0;    MyS3_5=0;
MyS04=0;    MyS4_5=0;
MyS05=0;    MyS5_5=0;
MyS06=0;    MyS6_5=0;
MyS07=0;    MyS7_5=0;
MyS08=0;    MyS8_5=0;
MyS09=0;    MyS9_5=0;
MyS10=0;    

for ii=1:length(C3_ThrMyS)
    if C3_ThrMyS(ii) == 0 
        MyS00 = MyS00+1;
    elseif C3_ThrMyS(ii)<= 0.5
        MyS0_5 = MyS0_5+1;
    elseif C3_ThrMyS(ii)<= 1
        MyS01 = MyS01+1;
    elseif C3_ThrMyS(ii)<= 1.5
        MyS1_5 = MyS1_5+1;
    elseif C3_ThrMyS(ii)<= 2
        MyS02 = MyS02+1;
    elseif C3_ThrMyS(ii)<= 2.5
        MyS2_5 = MyS2_5+1;
    elseif C3_ThrMyS(ii)<= 3
        MyS03 = MyS03+1;
    elseif C3_ThrMyS(ii)<= 3.5
        MyS3_5 = MyS3_5+1;
    elseif C3_ThrMyS(ii)<= 4
        MyS04 = MyS04+1;
    elseif C3_ThrMyS(ii)<= 4.5
        MyS4_5 = MyS4_5+1;
    elseif C3_ThrMyS(ii)<= 5
        MyS05 = MyS05+1;
    elseif C3_ThrMyS(ii)<= 5.5
        MyS5_5 = MyS5_5+1;
    elseif C3_ThrMyS(ii)<= 6
        MyS06 = MyS06+1;
    elseif C3_ThrMyS(ii)<= 6.5
        MyS6_5 = MyS6_5+1;
    elseif C3_ThrMyS(ii)<= 7
        MyS07 = MyS07+1;
    elseif C3_ThrMyS(ii)<= 7.5
        MyS7_5 = MyS7_5+1;
    elseif C3_ThrMyS(ii)<= 8
        MyS08 = MyS08+1;
    elseif C3_ThrMyS(ii)<= 8.5
        MyS8_5 = MyS8_5+1;
    elseif C3_ThrMyS(ii)<= 9
        MyS09 = MyS09+1;
    elseif C3_ThrMyS(ii)<= 9.5
        MyS9_5 = MyS9_5+1;
    elseif C3_ThrMyS(ii)<=10 || C3_ThrMyS(ii)> 10
        MyS10 = MyS10+1;
    end
end
counter_MyS     = [MyS00 MyS0_5 MyS01 MyS1_5 MyS02 MyS2_5 MyS03 MyS3_5 MyS04 MyS4_5 MyS05 MyS5_5 MyS06 MyS6_5 MyS07 MyS7_5 MyS08 MyS8_5 MyS09 MyS9_5 MyS10];
prob_MyS        = counter_MyS./n;
cdf_MyS         = cumsum(prob_MyS); % generate cdf
ccdf_genMyS     = 1-cumsum(prob_MyS);

%% FFR3S
load 'Results\C3_ThroughputFFR3S.mat';
C3_ThrFFR3S = C3_ThrFFR3S/1e6;
Total_Throughput_FFR3S = sum(C3_ThrFFR3S)
Block_Rate_FFR3S = length(find(C3_ThrFFR3S==0))
% C3_ThrFFR3S(ind)=[];

n = length(C3_ThrFFR3S);
x_min=min(C3_ThrFFR3S);
x_max=max(C3_ThrFFR3S);
X_range=x_min:0.5:x_max;
% X_range = 0:0.5:16;
bin=length(X_range);

NxFFR3S=hist(C3_ThrFFR3S,bin);
PxFFR3S=NxFFR3S/n; % generate pmf
FxFFR3S=cumsum(PxFFR3S); % generate cdf
figure
subplot(211),bar(X_range,PxFFR3S)
str = sprintf('FFR3S Histogram');
title(str);
subplot(212),stairs(X_range,FxFFR3S)
str = sprintf('FFR3S CDF');
title(str);

X_meanFFR3S   = mean(C3_ThrFFR3S);
X_modFFR3S    = mode(C3_ThrFFR3S);
X_medianFFR3S = median(C3_ThrFFR3S);

%% Sultan hoca code
FFR3S00=0;    FFR3S0_5=0;
FFR3S01=0;    FFR3S1_5=0; 
FFR3S02=0;    FFR3S2_5=0;
FFR3S03=0;    FFR3S3_5=0;
FFR3S04=0;    FFR3S4_5=0;
FFR3S05=0;    FFR3S5_5=0;
FFR3S06=0;    FFR3S6_5=0;
FFR3S07=0;    FFR3S7_5=0;
FFR3S08=0;    FFR3S8_5=0;
FFR3S09=0;    FFR3S9_5=0;
FFR3S10=0;    

for ii=1:length(C3_ThrFFR3S)
    if C3_ThrFFR3S(ii) == 0 
        FFR3S00 = FFR3S00+1;
    elseif C3_ThrFFR3S(ii)<= 0.5
        FFR3S0_5 = FFR3S0_5+1;
    elseif C3_ThrFFR3S(ii)<= 1
        FFR3S01 = FFR3S01+1;
    elseif C3_ThrFFR3S(ii)<= 1.5
        FFR3S1_5 = FFR3S1_5+1;
    elseif C3_ThrFFR3S(ii)<= 2
        FFR3S02 = FFR3S02+1;
    elseif C3_ThrFFR3S(ii)<= 2.5
        FFR3S2_5 = FFR3S2_5+1;
    elseif C3_ThrFFR3S(ii)<= 3
        FFR3S03 = FFR3S03+1;
    elseif C3_ThrFFR3S(ii)<= 3.5
        FFR3S3_5 = FFR3S3_5+1;
    elseif C3_ThrFFR3S(ii)<= 4
        FFR3S04 = FFR3S04+1;
    elseif C3_ThrFFR3S(ii)<= 4.5
        FFR3S4_5 = FFR3S4_5+1;
    elseif C3_ThrFFR3S(ii)<= 5
        FFR3S05 = FFR3S05+1;
    elseif C3_ThrFFR3S(ii)<= 5.5
        FFR3S5_5 = FFR3S5_5+1;
    elseif C3_ThrFFR3S(ii)<= 6
        FFR3S06 = FFR3S06+1;
    elseif C3_ThrFFR3S(ii)<= 6.5
        FFR3S6_5 = FFR3S6_5+1;
    elseif C3_ThrFFR3S(ii)<= 7
        FFR3S07 = FFR3S07+1;
    elseif C3_ThrFFR3S(ii)<= 7.5
        FFR3S7_5 = FFR3S7_5+1;
    elseif C3_ThrFFR3S(ii)<= 8
        FFR3S08 = FFR3S08+1;
    elseif C3_ThrFFR3S(ii)<= 8.5
        FFR3S8_5 = FFR3S8_5+1;
    elseif C3_ThrFFR3S(ii)<= 9
        FFR3S09 = FFR3S09+1;
    elseif C3_ThrFFR3S(ii)<= 9.5
        FFR3S9_5 = FFR3S9_5+1;
    elseif C3_ThrFFR3S(ii)<=10 || C3_ThrFFR3S(ii)> 10
        FFR3S10 = FFR3S10+1;
    end
end
counter_FFR3S     = [FFR3S00 FFR3S0_5 FFR3S01 FFR3S1_5 FFR3S02 FFR3S2_5 FFR3S03 FFR3S3_5 FFR3S04 FFR3S4_5 FFR3S05 FFR3S5_5 FFR3S06 FFR3S6_5 FFR3S07 FFR3S7_5 FFR3S08 FFR3S8_5 FFR3S09 FFR3S9_5 FFR3S10];
prob_FFR3S        = counter_FFR3S./n;
cdf_FFR3S         = cumsum(prob_FFR3S); % generate cdf
ccdf_genFFR3S     = 1-cumsum(prob_FFR3S);

%% Figures
xRanges = 0:0.5:length(counter_NP)/2-0.5;
figure;
hold on
plot(xRanges,cdf_NP,'r-*');
plot(xRanges,cdf_MyS,'g-*');
plot(xRanges,cdf_FFR3S,'b-*');
xlabel('Thr (Mbps)');
ylabel('CDF');
str = sprintf('CDF');
title(str);
legend('New Proposed','FFR3SL','FFR3S');
xlim([0,10]);
ylim([0,1]);
grid on;
hold off
box on

figure;
hold on
plot(xRanges,ccdf_genNP,'r-*');
plot(xRanges,ccdf_genMyS,'g-*');
plot(xRanges,ccdf_genFFR3S,'b-*');
xlabel('Thr(Mbps)');
ylabel('CCDF');
str = sprintf('CCDF');
title(str);
legend('New Proposed','FFR3SL','FFR3S');
xlim([0,10]);
ylim([0,1]);
grid on;
hold off
box on