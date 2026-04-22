function [FFR3S] = resourceAllocationFFR3S(TotalNumOfRBs,NumOfFemtoCells,NumOfMacroCells,NumOfUsersPerMacroCell, ...
                                    channelGain_macro,channelGain_femto,MacroCellTxPower,FemtoCellTxPower,...
                                    cells,users,femtos,maxRBs,RSRQ_Threshold,FFR3S)

% Dependent Parameters
 NumOfSectors   = 3;                        % number of sectors
 ZoneRadius     = [0.34 0.67];                % radius of central and intermediate zones
 NumOfLayers    = length(ZoneRadius) + 1;   % number of sectors

% Algorithm
NumOfSubBands           = 4;
NumOfRbInCenter         = round(TotalNumOfRBs*(ZoneRadius(1)/1));
NumOfRbPerSubBands      = [NumOfRbInCenter,((TotalNumOfRBs-NumOfRbInCenter)/(NumOfSubBands-1))*...
                           ones(1,NumOfSubBands-1)];
% find bandwidth 

    subbands = false(TotalNumOfRBs,length(NumOfRbPerSubBands));
  
    Ind0 = 0;
  for i = 1 : length(NumOfRbPerSubBands)
    Ind = Ind0 + (1:NumOfRbPerSubBands(i));
    subbands(Ind,i) = true;
    
    Ind0 = Ind(end);
  end
  center_subband = subbands(:,1);
  outer_subbands = subbands(:,2:length(NumOfRbPerSubBands));
%   SBs=7; %{A,B,C,D,E,F,G}
 
 % find available resources in each sector of a cell  
    resources_macro     =   zeros(TotalNumOfRBs,NumOfSectors,NumOfLayers);
    resources_femto     =   zeros(TotalNumOfRBs,NumOfSectors,NumOfLayers);

 for i = 1 : NumOfSectors   
    resources_macro(:,i,1)  =   center_subband;                                                 %Center              
    resources_macro(:,i,2)  =   outer_subbands(:,1+mod(i+0-1,length(NumOfRbPerSubBands)-1));    %Intermediate
    resources_macro(:,i,3)  =   outer_subbands(:,1+mod(i+1-1,length(NumOfRbPerSubBands)-1));    %Outer
 end               

%%% Resource allocation for femtocells%%%
% Centeral Layer
    resources_femto(:,1,1)  =   outer_subbands(:,1+mod(1+0-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+1-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+2-1,length(NumOfRbPerSubBands)-1));
                          
    resources_femto(:,2,1)  =   outer_subbands(:,1+mod(1+0-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+1-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+2-1,length(NumOfRbPerSubBands)-1)); 
                          
    resources_femto(:,3,1)  =   outer_subbands(:,1+mod(1+0-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+1-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+2-1,length(NumOfRbPerSubBands)-1)); 
 
  % Middle Layer
    resources_femto(:,1,2)  =  center_subband ... 
                              | outer_subbands(:,1+mod(1+1-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+2-1,length(NumOfRbPerSubBands)-1));
                          
    resources_femto(:,2,2)  =  center_subband ... 
                              | outer_subbands(:,1+mod(1+0-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+2-1,length(NumOfRbPerSubBands)-1));
    
    resources_femto(:,3,2)  =  center_subband ... 
                              | outer_subbands(:,1+mod(1+0-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+1-1,length(NumOfRbPerSubBands)-1));
                          
                       
   % Outer Layer
    resources_femto(:,1,3)  =  center_subband ... 
                              | outer_subbands(:,1+mod(1+0-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+2-1,length(NumOfRbPerSubBands)-1));
                          
    resources_femto(:,2,3)  =  center_subband ... 
                              | outer_subbands(:,1+mod(1+0-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+1-1,length(NumOfRbPerSubBands)-1));
    
    resources_femto(:,3,3)  =  center_subband ... 
                              | outer_subbands(:,1+mod(1+1-1,length(NumOfRbPerSubBands)-1)) ...
                              | outer_subbands(:,1+mod(1+2-1,length(NumOfRbPerSubBands)-1));   
             
  %% Allocate Resource Blocks (RBs) to Users
 available_resources_macro  = repmat(resources_macro,1,1,1,NumOfMacroCells);
 available_resources_femto  = repmat(resources_femto,1,1,1,NumOfMacroCells);
 FFR3S.alloc_mtx_macro            = zeros(NumOfUsersPerMacroCell*NumOfMacroCells, ...
                                    maxRBs, NumOfMacroCells);
 FFR3S.alloc_mtx_femto            = zeros(NumOfUsersPerMacroCell*NumOfMacroCells, ...
                                    maxRBs, NumOfFemtoCells);
 FFR3S.Demand                  = zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
 FFR3S.macro_Users             = zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
 FFR3S.femto_Users             = zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
 available_femto             = true(NumOfFemtoCells,1);
 FFR3S.macro                   = 0;
 FFR3S.femto                   = 0;
 
 for u = 1 : NumOfUsersPerMacroCell*NumOfMacroCells
   c = users.cellIndex(u);  % Macrocell_Index of the user
   s = FFR3S.user_sector(u);     % sector of a user
   l = FFR3S.user_layer(u);      % layer of the user
   FFR3S.Demand(u,1) = users.RBsDemand(u); %User demand for RBs (Randomly Generated) randi(10,1)  
  
  % Macrocell Transmit Power for each layer (Center, Middle and Outer)
  if l==1
      MacroTxPower = MacroCellTxPower(1);     % 01 watt = 30.00 dBm
  elseif l==2
      MacroTxPower = MacroCellTxPower(2);     % 10 watt = 40.00 dBm
  else
      MacroTxPower = MacroCellTxPower(3);     % 22 watt = 43.42 dBm
  end  
  
   % Find best available femto cell in this sector and layer
   fInd    =   find((FFR3S.femto_sector == s) & (FFR3S.femto_layer == l) & ...
                (femtos.cellIndex == c) & (available_femto > 0));
    
            gfSel   = [];
            fSel    = [];            
            if ~isempty(fInd)
                userDistFromFemto=zeros(length(fInd),1);
                for i=1:length(fInd)
                    userDistFromFemto(i,1) = norm(users.position(u,:) - femtos.centerPosition(fInd(i),:));
                end
                
                RSRQ_femtos =  RSRQ(userDistFromFemto,FemtoCellTxPower);
                [RSRQ_femto,fID] =  maxk(RSRQ_femtos,length(RSRQ_femtos));
                Sorted_femtos = fInd(fID);
                fID = RSRQ_femto > RSRQ_Threshold;
                fSel = Sorted_femtos(fID > 0); 
                if ~isempty(fSel)
                    for a=1:length(fSel)
                        fRBs = find(available_resources_femto(:,s,l,c) > 0);
                        num_of_availableRBs = length(fRBs);
                        if num_of_availableRBs >= FFR3S.Demand(u)
                            rInd       =   fRBs;
                            
                            % Find Maximum Channel Gain on specific Resource Blocks (RBs)
                            gf = channelGain_femto(u,fSel(a),rInd); %We can select RBs the maximum Channel Gain of
                            [gfMax,id_f] = maxk(gf,FFR3S.Demand(u)); %check for gf array (?)
                            fI  = a;
                            rfI = id_f(1,1:FFR3S.Demand(u));
                            gfSel = max(gfMax);
                            break                    
                        end
                    end
                end
            end
    
    
    % find best available macro-cell RB
    gmSel = [];
    userDistfromMacro = norm(users.position(u,:) - cells.centerPos(c,:));
    RSRQ_macro =  RSRQ(userDistfromMacro,MacroTxPower);
    RSRQ_macro =  max(RSRQ_macro);
    
    if RSRQ_macro > RSRQ_Threshold
        length_availableRBs = length(find(available_resources_macro(:,s,l,c) > 0));    
        if length_availableRBs >= FFR3S.Demand(u)    
            rImd = find(available_resources_macro(:,s,l,c));
            gm  = channelGain_macro(u,c,rImd);    
            if ~isempty(gm)
                [gmMax, id_m]  = maxk(gm,FFR3S.Demand(u));
                rmI   = id_m(1,1:FFR3S.Demand(u));
                gmSel = max(gmMax);
            end
        end
    end

    femtoMacroSelections = []; %0 means femto, 1 means macro, [] mean non
      
    if ~isempty(gfSel) && ~isempty(gmSel)
      % select best between macro and femto
            
      if MacroTxPower*gmSel > FemtoCellTxPower*gfSel
        femtoMacroSelections = 1;
      else
        femtoMacroSelections = 0;
      end
      
    elseif ~isempty(gfSel)
      femtoMacroSelections = 0;
    elseif ~isempty(gmSel)
      femtoMacroSelections = 1;
    end
       
% % % % % % % % % % % % % % % % % % % % % % % % % % % %     
      
%    Rules
   if ~isempty(femtoMacroSelections)
     if femtoMacroSelections == 0 
         
       % Femto Rules
       FFR3S.alloc_mtx_femto(u,1:FFR3S.Demand(u),fSel(fI)) = rInd(rfI);
       available_resources_femto(rInd(rfI),s,l,c) = false;           % Become Unavailable
       FFR3S.femto_Users(u,1)= fSel(fI);
       FFR3S.femto=FFR3S.femto+1;
       available_femto(fSel(fI))=false;                                  % Entertain only one user at a time          
     else
        % Macro Rules
        available_resources_macro(rImd(rmI),s,l,c) = false;
        if l==1
        available_resources_macro(rImd(rmI),:,l,c) = false;               %Use once at a time in center zone;
        else
        available_resources_macro(rImd(rmI),s,:,c) = false;
        end
        FFR3S.alloc_mtx_macro(u,1:FFR3S.Demand(u),c) = rImd(rmI);
        FFR3S.macro_Users(u,1) = c;
        FFR3S.macro = FFR3S.macro+1;
     end
   end
 end
end