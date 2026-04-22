NP.SINR_dB     = zeros(NumOfUsersPerMacroCell*NumOfMacroCells,maxRBs,1);
NP.Capacity    = zeros(NumOfUsersPerMacroCell*NumOfMacroCells,maxRBs,1);

noisePower  = NoisePowerDensity*DeltaF*12;              % 12 sub-carriers = 1 RB 

for u = 1 : NumOfUsersPerMacroCell*NumOfMacroCells
% Set the macrocell tranmisting power
        l = NP.user_layer(u);
        if l==1
            MacroTxPower = MacroCellTxPower(2);     % 1 watt = 30.00 dBm
        elseif l==2
            MacroTxPower = MacroCellTxPower(3);     % 10 watt = 40 dBm
        else
             MacroTxPower = MacroCellTxPower(3);     % 20 watt = 44 dBm
        end
    % find the serving cell of this user
    for k=1:users.RBsDemand(u)
    if any(NP.alloc_mtx_macro(u,k,:) > 0 )
        servingCell = find(NP.alloc_mtx_macro(u,k,:) > 0);
        servingRb   = NP.alloc_mtx_macro(u,k,servingCell);
        
        % find all macrocells which transmit at this RB        
        [~,~,MacroCells] = ind2sub(size(NP.alloc_mtx_macro),find(NP.alloc_mtx_macro(:) == servingRb));
        % remove serving cell from the list of interefere cells
        MacroCells = setdiff(MacroCells,servingCell);
        
        % find all femto cells which transmit at this RB   
        [~,~,FemtoCells] = ind2sub(size(NP.alloc_mtx_femto),find(NP.alloc_mtx_femto(:) == servingRb));
        
        % calculate SINR
               
        desiredPower      = channelGain_macro(u,servingCell,servingRb)*MacroTxPower;
        macroInterference = sum(channelGain_macro(u,MacroCells,servingRb)*MacroTxPower);
        femtoInterference = sum(channelGain_femto(u,FemtoCells,servingRb)*FemtoCellTxPower);
        
        SINR = desiredPower./(noisePower + macroInterference + femtoInterference);
        NP.SINR_dB(u,k)=10*log10(SINR);
        NP.Capacity(u,k) =12*DeltaF*log2(1+Alpha * SINR);
    elseif any(NP.alloc_mtx_femto(u,k,:) > 0 )
        servingCell = find(NP.alloc_mtx_femto(u,1,:) > 0);
        servingRb   = NP.alloc_mtx_femto(u,k,servingCell);
        
        % find all macrocells which transmit at this RB        
        [~,~,MacroCells] = ind2sub(size(NP.alloc_mtx_macro),find(NP.alloc_mtx_macro(:) == servingRb));
        
        % find all femto cells which transmit at this RB   
        [~,~,FemtoCells] = ind2sub(size(NP.alloc_mtx_femto),find(NP.alloc_mtx_femto(:) == servingRb));
        % remove serving cell from the list of interefere cells
        FemtoCells = setdiff(FemtoCells,servingCell);
        
        % calculate SINR
        desiredPower      = channelGain_femto(u,servingCell,servingRb)*FemtoCellTxPower;
        macroInterference = sum(channelGain_macro(u,MacroCells,servingRb)*MacroTxPower);
        femtoInterference = sum(channelGain_femto(u,FemtoCells,servingRb)*FemtoCellTxPower);
        
        SINR = desiredPower./(noisePower + macroInterference + femtoInterference);
        NP.SINR_dB(u,k)=10*log10(SINR);
        NP.Capacity(u,k) =12*DeltaF*log2(1+Alpha * SINR);
    else
        % do nothing as SINR is already zero
    end
    end
    
end
% Capacity =12*DeltaF*log2(1+Alpha * SINR);
% Capacity=0;
% for k=1:100
% 
%     Capacity = Capacity + 12*DeltaF*log2(1+SINR(k));
%     
% end
% Capacity =12*DeltaF*log2(1+Alpha * SINR);