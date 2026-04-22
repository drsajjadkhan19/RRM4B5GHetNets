% function [Throughput_f, Throughput_m, Throughput_tot] = throughput();
MyS.macro_RBs           =   0;
MyS.femto_RBs           =   0;
MyS.Throughput_m        =   0;
MyS.Throughput_f        =   0;
MyS.Throughput_tot      =   0; 
MyS.eachUserThroughput           =   zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
MyS.eachUserThroughput_macro     =   zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
MyS.eachUserThroughput_femto     =   zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);

for mu = 1 : NumOfUsersPerMacroCell*NumOfMacroCells
    % find the throughput for Macro User
    mRBs = 1:users.RBsDemand(mu);
    if any(MyS.alloc_mtx_macro(mu,1,:) > 0 )
        MyS.macro_RBs = MyS.macro_RBs + length(mRBs);
       % Each User Throughput
        MyS.eachUserThroughput_macro(mu) = sum(MyS.Capacity(mu,mRBs));
        MyS.eachUserThroughput(mu)       = sum(MyS.Capacity(mu,mRBs));
    end
    
end

for fu = 1 : NumOfUsersPerMacroCell*NumOfMacroCells
    % find the throughput for Femto User
    fRBs = 1:users.RBsDemand(fu);
    if any(MyS.alloc_mtx_femto(fu,1,:) > 0 )
        Beta_f    =   1;
        MyS.femto_RBs =   MyS.femto_RBs + length(fRBs);
        % Each User throughput
        MyS.eachUserThroughput_femto(fu) = sum(MyS.Capacity(fu,fRBs));
        MyS.eachUserThroughput(fu)       = sum(MyS.Capacity(fu,fRBs));      
    end
end

MyS.Throughput_m = sum(MyS.eachUserThroughput_macro);
MyS.Throughput_f = sum(MyS.eachUserThroughput_femto);
MyS.Throughput_tot = sum(MyS.eachUserThroughput);

%% Efficiency
MyS.total_rqt       = sum(users.RBsDemand);
MyS.total_srvd      = MyS.femto_RBs + MyS.macro_RBs;
MyS.Efficiency      = (MyS.total_srvd/MyS.total_rqt)*100;