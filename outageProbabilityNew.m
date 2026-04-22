clear
close all;
clc;


load 'Results\C1_SINRdB_NP.mat'
load 'Results\C1_SINRdB_MyS.mat'
load 'Results\C1_SINRdB_FFR3S.mat'

C1_SINRdB_NP = C1_SINRdB_NP(:);
ind = find(C1_SINRdB_NP==0);
C1_SINRdB_NP(ind)=[];

C1_SINRdB_MyS = C1_SINRdB_MyS(:);
ind = find(C1_SINRdB_MyS==0);
C1_SINRdB_MyS(ind)=[];

C1_SINRdB_FFR3S = C1_SINRdB_FFR3S(:);
ind = find(C1_SINRdB_FFR3S==0);
C1_SINRdB_FFR3S(ind)=[];