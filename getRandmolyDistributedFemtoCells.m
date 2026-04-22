function [femtos,f] = getRandmolyDistributedFemtoCells(NumOffemtosCells,femtosCellRadius,cells,Ctrl)
  
  femtos.numPerMacroCells = zeros(cells.NumOfMacroCells,1);
  femtos.NumOffemtosCelss = NumOffemtosCells;
  femtos.femtosCellRadius = femtosCellRadius;
  femtos.centerPosition   = zeros(NumOffemtosCells,2);
  femtos.cellIndex        = zeros(NumOffemtosCells,1);
  femtos.centerAngle      = zeros(NumOffemtosCells,1);
  femtos.centerDist       = zeros(NumOffemtosCells,1);

  for n = 0 : NumOffemtosCells-1
    femtos.numPerMacroCells (mod(n,cells.NumOfMacroCells) + 1) = ...
    femtos.numPerMacroCells (mod(n,cells.NumOfMacroCells) + 1) + 1;
  end

  Ind0 = 0;
  for n = 1 : cells.NumOfMacroCells
      
      Ind = Ind0 + (1:femtos.numPerMacroCells(n));      
      femtos.cellIndex (Ind) = n;
      
      for m = Ind
        randPos = cells.MacroCellRadius*sqrt(3)/2*(2*rand(1,2)-1);
        % in this part we make sure that femtocells are at least 2*femtosCellRadius away from each other
        if m > 1
          while any(sqrt(sum((femtos.centerPosition(1:m-1,:) - repmat(randPos+cells.centerPos(n,:),m-1,1)).'.^2)) < 2*femtosCellRadius)
            randPos = cells.MacroCellRadius*sqrt(3)/2*(2*rand(1,2)-1);
          end
        end
        femtos.centerAngle(m,1)    = mod(atan2(randPos(:,2),randPos(:,1)),2*pi);
        femtos.centerDist(m,1)     = sqrt(sum(randPos.^2,2));
        femtos.centerPosition(m,:) = randPos + cells.centerPos(n,:);
      end
      
      % updated Ind
      Ind0 = Ind(end);
  end

  % NP
  if Ctrl.ShowCellsDeployment(1)
      f = figure(101);

      angles     = linspace(0,2*pi,100);
      boundaries = [cos(angles(:)),sin(angles(:))] * femtosCellRadius;
      for n = 1 : NumOffemtosCells
%           plot(femtos.centerPosition(n,1),femtos.centerPosition(n,2),'m.')
          text(femtos.centerPosition(n,1),femtos.centerPosition(n,2),sprintf('%d',n),'FontSize', 7.5,'Color','m')
          plot(femtos.centerPosition(n,1)+boundaries(:,1),femtos.centerPosition(n,2)+boundaries(:,2),'m:')
      end
  end
  
  % FFR-3SL
   if Ctrl.ShowCellsDeployment(2)
      f = figure(102);

      angles     = linspace(0,2*pi,100);
      boundaries = [cos(angles(:)),sin(angles(:))] * femtosCellRadius;
      for n = 1 : NumOffemtosCells
%           plot(femtos.centerPosition(n,1),femtos.centerPosition(n,2),'m.')
          text(femtos.centerPosition(n,1),femtos.centerPosition(n,2),sprintf('%d',n),'FontSize', 7.5,'Color','m')
          plot(femtos.centerPosition(n,1)+boundaries(:,1),femtos.centerPosition(n,2)+boundaries(:,2),'m:')
      end
   end
  
   % OSFFR
   
  if Ctrl.ShowCellsDeployment(3)
      f = figure(103);

      angles     = linspace(0,2*pi,100);
      boundaries = [cos(angles(:)),sin(angles(:))] * femtosCellRadius;
      
      for n = 1 : NumOffemtosCells
%           plot(femtos.centerPosition(n,1),femtos.centerPosition(n,2),'m.')
          text(femtos.centerPosition(n,1),femtos.centerPosition(n,2),sprintf('%d',n),'FontSize', 7.5,'Color','m')
          plot(femtos.centerPosition(n,1)+boundaries(:,1),femtos.centerPosition(n,2)+boundaries(:,2),'m:')
      end
  end
  
end