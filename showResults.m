clear;
clc;
close all;

% Load the saved data from computer

% Input Values

% ULD Category 1;
% NP
load 'Results\00-08 hours\femtoThroughputNP.mat';
load 'Results\00-08 hours\macroThroughputNP.mat';
load 'Results\00-08 hours\totalThroughputNP.mat';

Throughput_femtoNP = Throughput_femtoNP/1e6;
Throughput_macroNP = Throughput_macroNP/1e6;
Throughput_totalNP = Throughput_totalNP/1e6;
% MyS

% FFR3S

% CDF and CCDF
NP50=0;
NP100=0;
NP150=0;
NP200=0;
NP250=0;

for ii=1:length(avgTotalThr_NP)
    if avgTotalThr_NP(ii)<=50
        NP50 =NP50+1;
    elseif avgTotalThr_NP(ii)<=100
        NP100 =NP100+1;
    elseif avgTotalThr_NP(ii)<=150
        NP150 =NP150+1;
    elseif avgTotalThr_NP(ii)<=200
        NP200 =NP200+1;
    elseif avgTotalThr_NP(ii)<=250
        NP200 =NP250+1;
    end
end

S_NP=[NP50 NP100 NP150 NP200 NP250]./length(avgTotalThr_NP);
cdf_NP= cumsum(S_NP); % generate cdf
ccdf_genNP = 1-cumsum(S_NP);


xRanges = [50 100 150 200 250];

figure;
hold on
plot(xRanges,cdf_NP,'r-*');
xlabel('Throughput(Mbps)');
ylabel('CDF');
str = sprintf('CDF');
title(str);
legend('Proposed','FFR-3SL','FFR-3S');
xlim([50,250]);
ylim([0,1]);
grid on;
hold off
box on


figure;
hold on
plot(xRanges,ccdf_genNP,'r-*');
xlabel('Throughput(Mbps)');
ylabel('1-CDF');
str = sprintf('CCDF');
title(str);
legend('Proposed','FFR-3SL','FFR-3S');
xlim([50,250]);
ylim([0,1]);
grid on;
hold off
box on