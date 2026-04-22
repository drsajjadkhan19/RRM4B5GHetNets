clear
close all;
clc;

c=0;

SINR_range = 1:1.5:25;

N=100;
constantValues
S1outageProb = zeros(N,length(SINR_range));
S2outageProb = zeros(N,length(SINR_range));
MySoutageProb = zeros(N,length(SINR_range));

for g = 1 : N

main_func;   
    


for i = 1 : length(SINR_range)
    %Find Outage probability for S2
    dBValuesS1 = nnz(S1.SINR_dB(:,1));
    SINR_S1 = length(find(S1.SINR_dB(:,1) >= SINR_range(i))); 
    S1outageProb(g,i) = SINR_S1/dBValuesS1;
    
    %Find Outage probability for S2
    dBValuesS2 = nnz(S2.SINR_dB(:,1));
    SINR_S2 = length(find(S2.SINR_dB(:,1) >= SINR_range(i)));
    S2outageProb(g,i) = SINR_S2/dBValuesS2;
    
    %Find Outage probability for S2
    dBValuesMyS = nnz(MyS.SINR_dB(:,1));
    SINR_MyS = length(find(MyS.SINR_dB(:,1) >= SINR_range(i)));
    MySoutageProb(g,i) = SINR_MyS/dBValuesMyS;
    
    
    
end

%Process Completion
    c = c + 1;
    fprintf('%3.0f percent is done \n',c/N*100);

end

    avgOutageProbS1 = mean(S1outageProb);
    avgOutageProbS2 = mean(S2outageProb);
    avgOutageProbMyS = mean(MySoutageProb);



figure;
hold on;
plot(SINR_range,avgOutageProbS1,'r-d','LineWidth',1.5);
plot(SINR_range,avgOutageProbS2,'b-*','LineWidth',1.5);
plot(SINR_range,avgOutageProbMyS,'g-p','LineWidth',1.5);
xlabel('SINR (dB)');
ylabel('Outage Probability');
str = sprintf('Outage Probablity Comparison');
title(str);
legend('OSFFR','FFR-3','FFR-3SL');
xlim([SINR_range(1),SINR_range(end)]);
ylim([0,1]);
grid on;
hold off;