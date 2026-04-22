function [users,f] = getRandmolyDistributedUsers(NumOfUsersPerMacroCell,userRBsDemand,cells,ULDCategory,Ctrl)

  users.position                = zeros(NumOfUsersPerMacroCell*cells.NumOfMacroCells,2);
  users.angle                   = zeros(NumOfUsersPerMacroCell*cells.NumOfMacroCells,1);
  users.distanceFromCenter      = zeros(NumOfUsersPerMacroCell*cells.NumOfMacroCells,1);
  users.cellIndex               = zeros(NumOfUsersPerMacroCell*cells.NumOfMacroCells,1);
  users.numPerMacroCells        = NumOfUsersPerMacroCell;
  users.distanceFromEachOther   = 30;
  users.RBsDemand               = zeros(NumOfUsersPerMacroCell*cells.NumOfMacroCells,1);
  
 switch ULDCategory
     case 1 
      usersCentralDensity       = 0.10;
      usersMiddleDensity        = 0.20;

     case 2 
      usersCentralDensity       = 0.60;
      usersMiddleDensity        = 0.20;

     case 3 
      usersCentralDensity       = 0.80;
      usersMiddleDensity        = 0.10;

     case 4 
      usersCentralDensity       = 0.60;
      usersMiddleDensity        = 0.20;

     case 5 
      usersCentralDensity       = 0.10;
      usersMiddleDensity        = 0.20;

 end
        centralDensity     = round(usersCentralDensity*NumOfUsersPerMacroCell);
        middleDensity      = round(usersMiddleDensity*NumOfUsersPerMacroCell);
        boundaryDensity    = NumOfUsersPerMacroCell-(centralDensity+middleDensity);     
 
    Ind0 = 0;
  for n = 1 : cells.NumOfMacroCells
  
   
    Ind = Ind0 + (1:NumOfUsersPerMacroCell);
    
    
    for ii =1:length(Ind)
       
       m = Ind(ii);
      % users demand for resource blocks (RBs)
       d = randi(length(userRBsDemand),1);
       users.RBsDemand(m) = userRBsDemand(d);
       
%   Central Focused

%      if m <= centralDensity+ Ind0
%         while sqrt(sum(randPos.^2,2)) > cells.ZoneRadius(1)*cells.MacroCellRadius 
%             randPos = (cells.MacroCellRadius)*sqrt(3)/2*(2*rand(1,2)-1);
%         end
%      elseif m > centralDensity+ Ind0
%          while sqrt(sum(randPos.^2,2)) < cells.ZoneRadius(1)*cells.MacroCellRadius 
%             randPos = (cells.MacroCellRadius)*sqrt(3)/2*(2*rand(1,2)-1);
%          end
%      end
     
    randPos = (cells.MacroCellRadius)*sqrt(3)/2*(2*rand(1,2)-1);

%   Central Layer
    if m <= centralDensity + Ind0
        while sqrt(sum(randPos.^2,2)) > cells.ZoneRadius(1)*cells.MacroCellRadius 
            randPos = (cells.MacroCellRadius)*sqrt(3)/2*(2*rand(1,2)-1);
        end

%   Middle Layer
    elseif m > centralDensity + Ind0   && m <= (middleDensity + centralDensity) + Ind0
        while sqrt(sum(randPos.^2,2)) < cells.ZoneRadius(1)*cells.MacroCellRadius || sqrt(sum(randPos.^2,2)) > cells.ZoneRadius(2)*cells.MacroCellRadius
            randPos = (cells.MacroCellRadius)*sqrt(3)/2*(2*rand(1,2)-1);
        end
        
%  Boundary Layer
           
    elseif m > (middleDensity + centralDensity) + Ind0 && m <= (boundaryDensity +  middleDensity + centralDensity) + Ind0
         while sqrt(sum(randPos.^2,2)) < cells.ZoneRadius(2)*cells.MacroCellRadius 
            randPos = (cells.MacroCellRadius)*sqrt(3)/2*(2*rand(1,2)-1);
         end
    end
          
      users.distanceFromCenter(m,1) = sqrt(sum(randPos.^2,2));
      users.angle(m,1)              = mod(atan2(randPos(:,2),randPos(:,1)),2*pi);
      users.position(m,:)           = randPos + cells.centerPos(n,:);
      users.cellIndex(m)            = n;
    end
    Ind0 = Ind(end);
  end
  
  % NP
    if Ctrl.ShowCellsDeployment(1)
      f = figure(101);
      plot(users.position(:,1),users.position(:,2),'b.')
      %to draw UE numbers
      for a=1:(NumOfUsersPerMacroCell*cells.NumOfMacroCells)
      text(users.position(a,1)+3,users.position(a,2),sprintf('%d',a),'FontSize', 7.5,'Color','b')
      end
    end
    
    % FFR-3SL
    if Ctrl.ShowCellsDeployment(2)
      f = figure(102);
      plot(users.position(:,1),users.position(:,2),'b.')
      %to draw UE numbers
      for a=1:(NumOfUsersPerMacroCell*cells.NumOfMacroCells)
      text(users.position(a,1)+3,users.position(a,2),sprintf('%d',a),'FontSize', 7.5,'Color','b')
      end
    end
    
    % OSFFR
    if Ctrl.ShowCellsDeployment(3)
      f = figure(103);
      plot(users.position(:,1),users.position(:,2),'b.')
      %to draw UE numbers
      for a=1:(NumOfUsersPerMacroCell*cells.NumOfMacroCells)
      text(users.position(a,1)+3,users.position(a,2),sprintf('%d',a),'FontSize', 7.5,'Color','b')
      end
    end
    
end