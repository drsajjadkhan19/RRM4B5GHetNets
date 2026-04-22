% function [Throughput_f, Throughput_m, Throughput_tot] = throughput();
NP.macro_RBs           =   0;
NP.femto_RBs           =   0;
NP.Throughput_m        =   0;
NP.Throughput_f        =   0;
NP.Throughput_tot      =   0;
NP.eachUserThroughput           =   zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
NP.eachUserThroughput_macro     =   zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
NP.eachUserThroughput_femto     =   zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);

for mu = 1 : NumOfUsersPerMacroCell*NumOfMacroCells
    % find the throughput for Macro User
    mRBs = 1:users.RBsDemand(mu);
    if any(NP.alloc_mtx_macro(mu,1,:) > 0 )
        NP.macro_RBs = NP.macro_RBs + length(mRBs);
       % Each User Throughput
        NP.eachUserThroughput_macro(mu) = sum(NP.Capacity(mu,mRBs));
        NP.eachUserThroughput(mu)       = sum(NP.Capacity(mu,mRBs));
    end
    
end

for fu = 1 : NumOfUsersPerMacroCell*NumOfMacroCells
    % find the throughput for Femto User
    fRBs = 1:users.RBsDemand(fu);
    if any(NP.alloc_mtx_femto(fu,1,:) > 0 )
        Beta_f    =   1;
        NP.femto_RBs =   NP.femto_RBs + length(fRBs);
        % Each User throughput
        NP.eachUserThroughput_femto(fu) = sum(NP.Capacity(fu,fRBs));
        NP.eachUserThroughput(fu)       = sum(NP.Capacity(fu,fRBs));      
    end
end

NP.Throughput_m = sum(NP.eachUserThroughput_macro);
NP.Throughput_f = sum(NP.eachUserThroughput_femto);
NP.Throughput_tot = sum(NP.eachUserThroughput);

%% Efficiency
NP.total_rqt       = sum(users.RBsDemand);
NP.total_srvd      = NP.femto_RBs + NP.macro_RBs;
NP.Efficiency      = (NP.total_srvd/NP.total_rqt)*100;