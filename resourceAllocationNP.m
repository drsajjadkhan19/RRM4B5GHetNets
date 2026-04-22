function [NP] = resourceAllocationNP(TotalNumOfRBs,NumOfFemtoCells,NumOfMacroCells,NumOfUsersPerMacroCell, ...
                                    channelGain_macro,channelGain_femto,MacroCellTxPower,FemtoCellTxPower,...
                                    cells,users,femtos,maxRBs,RSRQ_Threshold,ULDCategory,NP)
% Initialization
NumOfLayers                 =   3;
NumOfSectors                =   3;

 NP.AssignedSB              =   zeros(1,NumOfFemtoCells);
 SB_macro                   =   zeros(NumOfLayers,NumOfSectors);
 RBs_macro                  =   zeros(TotalNumOfRBs,NumOfLayers,NumOfSectors);
 availableRBs_femto         =   zeros(TotalNumOfRBs,NumOfFemtoCells);
    
% Subbands for sectors {alpha, beta, gamma} in a Macro-BS
% SBs=7; %{A,B,C,D,E,F,G}
 SB = [1,2,3,4,5,6,7];
 macrosSBsSector(1,[1,4,7])=   true;
 macrosSBsSector(2,[2,5,7])=   true;
 macrosSBsSector(3,[3,6,7])=   true;
 
 for i=1:NumOfSectors
     SB_macro(i,1)= SB(end);
     SB_macro(i,2)= SB(i);
     SB_macro(i,3)= SB(i+3);
 end
 
 switch ULDCategory
     case 1
         NumOfRbPerSubBands = [07,07,07,23,23,23,10]; 
     case 2
         NumOfRbPerSubBands = [07,07,07,07,07,07,58];
     case 3
         NumOfRbPerSubBands = [04,04,04,04,04,04,76];
     case 4
         NumOfRbPerSubBands = [07,07,07,07,07,07,58];
     case 5
         NumOfRbPerSubBands = [07,07,07,23,23,23,10];
 end
 
 K_band    = sum(NumOfRbPerSubBands); 
 subbands = false(K_band,length(NumOfRbPerSubBands));
  
 Ind0 = 0;
  for k = 1 : length(NumOfRbPerSubBands)
    Ind = Ind0 + (1:NumOfRbPerSubBands(k));
    subbands(Ind,k) = true;
    
    Ind0 = Ind(end);
  end
    
% Find available resource blocks in each sector of Macrocell  
 for k = 1 : NumOfSectors   
    RBs_macro(:,1,k)  =   subbands(:, end);                                         %Center              
    RBs_macro(:,2,k)  =   subbands(:,1+mod(k+0-1,length(NumOfRbPerSubBands)-1));    %Middle
    RBs_macro(:,3,k)  =   subbands(:,1+mod(k+3-1,length(NumOfRbPerSubBands)-1));    %Outer
 end
 
Ind0 = 0;
for n = 1 : cells.NumOfMacroCells
    SB1         = ~macrosSBsSector(1,:);
    SB2         = ~macrosSBsSector(2,:);
    SB3         = ~macrosSBsSector(3,:);
    sector1     = 0;
    sector2     = 0;
    sector3     = 0;
    femtoCount  = 0;
        
    perCellFemtos = Ind0 + (1:femtos.numPerMacroCells(n));      
    
for f=1:length(perCellFemtos)
       
 %Checking for the received signals
     c =  femtos.cellIndex(perCellFemtos(f));
     s = NP.femto_sector(perCellFemtos(f));
     l = NP.femto_layer(perCellFemtos(f));
     
    %Implementation of SBi\Fk
    if l==3
    SB1(1,end)=true;
    SB2(1,end)=true;
    SB3(1,end)=true;
    else
    SB1(1,end)=false;
    SB2(1,end)=false;
    SB3(1,end)=false;
    end
      
    if s==1 && sector1<5 && (any(SB1) > 0)
        [~,Ind]=find(SB1 == 1);
        if ~isempty(Ind)
            NP.AssignedSB(perCellFemtos(f))=Ind(1);
            SB1(NP.AssignedSB(perCellFemtos(f)))=false;
            sector1=sector1+1;
        end
    elseif s==2 && sector2<5 && (any(SB2) > 0)
        [~,Ind]=find(SB2 == 1);
        if ~isempty(Ind)
            NP.AssignedSB(perCellFemtos(f))=Ind(1);
            SB2(NP.AssignedSB(perCellFemtos(f)))=false;
            sector2=sector2+1;
        end
    elseif s==3 && sector3<4 && (any(SB3) > 0)
        [~,Ind]=find(SB3 == 1);
        if ~isempty(Ind)
            NP.AssignedSB(perCellFemtos(f))=Ind(1);
            SB3(NP.AssignedSB(perCellFemtos(f)))=false;
            sector3=sector3+1;
        end
    else
        fInd = find((femtos.cellIndex == c) & (NP.femto_sector == s));
        if ~isempty(fInd)
        DistfromNearbyFemtos=zeros(length(fInd),1);
        for k=1:length(fInd)
        DistfromNearbyFemtos(k,1) = norm(femtos.centerPosition(perCellFemtos(f),:) - femtos.centerPosition(fInd(k),:));
        end
        RSRQ_femtos  =  RSRQ(DistfromNearbyFemtos,FemtoCellTxPower);
        Checked=0;
        while Checked==0
        RSRQfemtoMin =  min(RSRQ_femtos);
        RSRQfemtoMax =  max(RSRQ_femtos);
        fSell=find(RSRQ_femtos == RSRQfemtoMin);
        check=fInd(fSell);
        fSell2=RSRQ_femtos == RSRQfemtoMax;
        check2=fInd(fSell2);
        if NP.AssignedSB(check)==NP.AssignedSB(check2)
            RSRQ_femtos(fSell)=NaN;
        else
            NP.AssignedSB(perCellFemtos(f))=NP.AssignedSB(check);
            Checked=true;
        end
        end
        end
    end
  availableRBs_femto(:,perCellFemtos(f))=subbands(:,NP.AssignedSB(perCellFemtos(f)));
  femtoCount    = femtoCount + 1;
end
    % updated Ind
    Ind0 = perCellFemtos(end);
    NP.femtosPerCell(1,n)=femtoCount;
end

%% Allocate Resource Blocks (RBs) to Users
 availableRBs_macro = repmat(RBs_macro,1,1,1,NumOfMacroCells);
 NP.alloc_mtx_macro    = zeros(NumOfUsersPerMacroCell*NumOfMacroCells, ...
                            maxRBs,NumOfMacroCells);
 NP.alloc_mtx_femto    = zeros(NumOfUsersPerMacroCell*NumOfMacroCells, ...
                            maxRBs,NumOfFemtoCells);
 NP.Demand          = zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
 NP.macro_Users     = zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
 NP.femto_Users     = zeros(NumOfUsersPerMacroCell*NumOfMacroCells,1);
 available_femto     = true(NumOfFemtoCells,1);
 NP.macro           = 0;
 NP.femto           = 0;
 
  for u = 1 : NumOfUsersPerMacroCell*NumOfMacroCells
        c = users.cellIndex(u);     % Macrocell_Index of the user
        s = NP.user_sector(u);     % sector of a user
        l = NP.user_layer(u);      % layer of the user
        NP.Demand(u,1) = users.RBsDemand(u); %User demand for RBs (Randomly Generated) randi(10,1)
        
  % Macrocell Transmit Power for each layer (Center, Middle and Outer)
  if l==1
      MacroTxPower = MacroCellTxPower(1);     % 01 watt = 30.00 dBm
  elseif l==2
      MacroTxPower = MacroCellTxPower(2);     % 10 watt = 40.00 dBm
  else
      MacroTxPower = MacroCellTxPower(3);     % 22 watt = 43.42 dBm
  end         
        
   %% Find the best available femtocell and RB in this sector and layer
    fInd =  find((NP.femto_sector == s) & ...
                   (femtos.cellIndex == c) & (available_femto > 0));
     
    gfSel   = [];
    
    if ~isempty(fInd)
        userDistfromFemto=zeros(length(fInd),1);
        for i=1:length(fInd)
            userDistfromFemto(i,1) = norm(users.position(u,:) - femtos.centerPosition(fInd(i),:));
        end
        RSRQ_femtos =  RSRQ(userDistfromFemto,FemtoCellTxPower);
        [RSRQ_femto,fID] =  maxk(RSRQ_femtos,length(RSRQ_femtos));
        Sorted_femtos = fInd(fID);
        fID = RSRQ_femto > RSRQ_Threshold;
        fSel = Sorted_femtos(fID > 0);        
        if ~isempty(fSel)           
            for a=1:length(fSel)                
                fRBs = find(availableRBs_femto(:,fSel(a)) > 0);
                num_of_availableRBs = length(fRBs);
                if num_of_availableRBs >= NP.Demand(u)
                    rInd       =   fRBs;
  
                    % Find Maximum Channel Gain on specific Resource Blocks (RBs)                                        
                    gf = channelGain_femto(u,fSel(a),rInd); %We can select RBs the maximum Channel Gain
                    [gfMax,id_f] = maxk(gf,NP.Demand(u,1));  %check for gf array     
                    fI  = a;
                    rfI = id_f(1,1:NP.Demand(u,1));
                    gfSel = max(gfMax);
                    break
                end
            end
        end
    end
    
    %% Find the best available macrocell and RBs
    gmSel = [];
    userDistfromMacro = norm(users.position(u,:) - cells.centerPos(c,:));
    RSRQ_macro =  RSRQ(userDistfromMacro,MacroTxPower);
    RSRQ_macro =  max(RSRQ_macro);
    
    if RSRQ_macro > RSRQ_Threshold
        length_availableRBs = length(find(availableRBs_macro(:,l,s,c) > 0));
        if length_availableRBs >= NP.Demand(u)           
            rmI = find(availableRBs_macro(:,l,s,c));
            gm  = channelGain_macro(u,c,rmI);
            if ~isempty(gm)
                [gmMax,id_m]  = maxk(gm,NP.Demand(u,1));
                rmI    = rmI(id_m(1,1:NP.Demand(u,1)));
                gmSel  = max(gmMax);
            end
        end
    end
            
    %% Compare the select the best available macrocell and femtocell
     % 0 means femto, 1 means macro, [] mean non
    femtoMacroSelections = [];
    
    if ~isempty(gfSel) && ~isempty(gmSel)
               
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
    %% Rules    
    if ~isempty(femtoMacroSelections)
     if femtoMacroSelections == 0
     % Femto Rules
        NP.alloc_mtx_femto(u,1:NP.Demand(u,1),fSel(fI)) = rInd(rfI);
        availableRBs_femto(rInd(rfI),fSel(fI)) = false;
%         available_femto(fSel(fI))=false;
        NP.femto_Users(u,1)= fSel(fI);
        NP.femto=NP.femto+1;
     else
     % Macro Rules
        availableRBs_macro(rmI(1:NP.Demand(u,1)),l,s,c) = false;
        if l==1
        availableRBs_macro(l,rmI(1:NP.Demand(u,1)),l,:,c) = false;               %Use once at a time in center zone;
        else
        availableRBs_macro(rmI(1:NP.Demand(u,1)),:,s,c) = false;
        end
        NP.alloc_mtx_macro(u,1:NP.Demand(u,1),c) = rmI;
        NP.macro_Users(u,1) = c;
        NP.macro = NP.macro+1;
     end
    end
  end
end