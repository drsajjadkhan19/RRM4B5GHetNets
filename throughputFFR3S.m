% function [Throughput_f, Throughput_m, Throughput_tot] = throughput();
FFR3S.macro_RBs           =   0;
FFR3S.femto_RBs           =   0;
FFR3S.Throughput_m        =   0;
FFR3S.Throughput_f        =   0;
FFR3S.Throughput_tot      =   0; 
FFR3S.eachUserThroughput           =   zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
FFR3S.eachUserThroughput_macro     =   zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
FFR3S.eachUserThroughput_femto     =   zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);

for mu = 1 : NumOfUsersPerMacroCell*NumOfMacroCells
    % find the throughput for Macro User
    mRBs = 1:users.RBsDemand(mu);
    if any(FFR3S.alloc_mtx_macro(mu,1,:) > 0 )
        FFR3S.macro_RBs = FFR3S.macro_RBs + length(mRBs);
       % Each User Throughput
        FFR3S.eachUserThroughput_macro(mu) = sum(FFR3S.Capacity(mu,mRBs));
        FFR3S.eachUserThroughput(mu)       = sum(FFR3S.Capacity(mu,mRBs));
    end
    
end

for fu = 1 : NumOfUsersPerMacroCell*NumOfMacroCells
    % find the throughput for Femto User
    fRBs = 1:users.RBsDemand(fu);
    if any(FFR3S.alloc_mtx_femto(fu,1,:) > 0 )
        Beta_f    =   1;
        FFR3S.femto_RBs =   FFR3S.femto_RBs + length(fRBs);
        % Each User throughput
        FFR3S.eachUserThroughput_femto(fu) = sum(FFR3S.Capacity(fu,fRBs));
        FFR3S.eachUserThroughput(fu)       = sum(FFR3S.Capacity(fu,fRBs));      
    end
end

FFR3S.Throughput_m = sum(FFR3S.eachUserThroughput_macro);
FFR3S.Throughput_f = sum(FFR3S.eachUserThroughput_femto);
FFR3S.Throughput_tot = sum(FFR3S.eachUserThroughput);

%% Efficiency
FFR3S.total_rqt       = sum(users.RBsDemand);
FFR3S.total_srvd      = FFR3S.femto_RBs + FFR3S.macro_RBs;
FFR3S.Efficiency      = (FFR3S.total_srvd/FFR3S.total_rqt)*100;