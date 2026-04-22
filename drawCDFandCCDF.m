clear;
clc;
close all;

% Load the saved data from computer

% Input Values

% ULD Category 1;

%% NP
load 'Results\C1\totalThroughputNP.mat';

Total_NP = ThroughputNP(:)/1e6;
ind = find(Total_NP==0);
Total_NP(ind)=[];

n = length(Total_NP);
% x_min=min(Total_NP);
% x_max=max(Total_NP);
% X_range=x_min:x_max;
X_range = 0:1:14;
bin=length(X_range);

Nx=hist(Total_NP,bin);
Px=Nx/n; % generate pmf
Fx=cumsum(Px); % generate cdf
subplot(211),bar(X_range,Px)
subplot(212),stairs(X_range,Fx)

X_mean=mean(Total_NP);
X_mod=mode(Total_NP);
X_median=median(Total_NP);

%% Sultan hoca code
NP0=0;
NP1=0; NP2=0; NP3=0;
NP4=0; NP5=0; NP6=0; NP7=0;
NP8=0; NP9=0; NP10=0;

for ii=1:length(Total_NP)
    if Total_NP(ii) <= 0 
        NP0 =NP0+1;
    elseif Total_NP(ii)<=1
        NP1 =NP1+1;
    elseif Total_NP(ii)<=2
        NP2 =NP2+1;
    elseif Total_NP(ii)<=3
        NP3 =NP3+1;
    elseif Total_NP(ii)<=4
        NP4 =NP4+1;
    elseif Total_NP(ii)<=5
        NP5 =NP5+1;
    elseif Total_NP(ii)<=6
        NP6 =NP6+1;
    elseif Total_NP(ii)<=7
        NP7 =NP7+1;
    elseif Total_NP(ii)<=8
        NP8 =NP8+1;
    elseif Total_NP(ii)<=9
        NP9 =NP9+1;
    elseif Total_NP(ii)<=10 || Total_NP(ii)> 10
        NP10 =NP10+1;
    end
end
counter =  [NP0 NP1 NP2 NP3 NP4 NP5 NP6 NP7 NP8 NP9 NP10];
prob = counter./n;
cdf_NP= cumsum(prob); % generate cdf
ccdf_genNP = 1-cumsum(prob);


%% MyS

%% FFR3S
xRanges = 1:length(counter);
figure;
hold on
plot(xRanges,cdf_NP,'r-*');
xlabel('Throughput(Mbps)');
ylabel('CDF');
str = sprintf('CDF');
title(str);
legend('Proposed');
xlim([0,length(counter)]);
ylim([0,1]);
grid on;
hold off
box on


figure;
hold on
plot(xRanges,ccdf_genNP,'r-*');
xlabel('Throughput(Mbps)');
ylabel('CCDF');
str = sprintf('CCDF');
title(str);
legend('Proposed');
xlim([0,length(counter)]);
ylim([0,1]);
grid on;
hold off
box on