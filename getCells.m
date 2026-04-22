function [cells,f] = getCells(NumOfMacroCells,MacroCellRadius,Ctrl)
  
  % parameters
  if nargin < 1
    NumOfMacroCells     = 7;          % number of cells
  end
  if nargin < 2
    MacroCellRadius     = 500;        % cell radius
  end
%   if nargin < 3
%     NumOfSectors        = 3;               % number of sectors
%   end
%   if nargin < 4
    cells.ZoneRadius     = ([0.34, 0.67]);      % radius of central and intermediate zones
%   end
  
  % control parameters
  if nargin < 3
    Ctrl.ShowCellsDeployment = true;
  end
  
% %  check parameters
%     NumOfZones = length(ZoneRadius) + 1;          % number of zones
%     layers_outer = zeros(NumOfMacroCells,2);
%     layers_inner = zeros(NumOfMacroCells,2);
%     centerPosDist = zeros(NumOfMacroCells,1);
    
% %  constant parameters  
%     NumOfEdges = 6; 
   

  angles     =  (pi/6:-pi/3:-2*pi).';
  centerPos  =  [[0;cos(angles(:))], ...
                 [0;sin(angles(:))]] * MacroCellRadius * sqrt(3);
 
 
  angles     = (0:pi/3:2*pi).';                 %find angles for hexagon
  boundaries = [cos(angles(:)),sin(angles(:))] * MacroCellRadius;
  
%   angles     = linspace(0,2*pi,100);
%   layers     = [cos(angles(:)),sin(angles(:))] * 1;
  
 
  % NP
  if Ctrl.ShowCellsDeployment(1)
    f = figure(101);
    clf
    hold on
      for n = 1 : NumOfMacroCells  
      plot(centerPos(n,1),centerPos(n,2),'kh')
      plot(boundaries(:,1) + centerPos(n,1), ...
      boundaries(:,2) + centerPos(n,2), ...
      'r-','LineWidth',1.5)
        text(centerPos(n,1)+.1*MacroCellRadius,centerPos(n,2)+.1*MacroCellRadius,num2str(n))
    end
      axis equal
     else
      f = NaN;
  end
  
  % FFR-3SL  
  if Ctrl.ShowCellsDeployment(2)
    f = figure(102);
    clf
    hold on
    
    for n = 1 : NumOfMacroCells  
      plot(centerPos(n,1),centerPos(n,2),'kh')
      plot(boundaries(:,1) + centerPos(n,1), ...
      boundaries(:,2) + centerPos(n,2), ...
      'g-','LineWidth',1.5)
        text(centerPos(n,1)+.1*MacroCellRadius,centerPos(n,2)+.1*MacroCellRadius,num2str(n))
    end
      axis equal
     else
      f = NaN;
  end
  
  % OSFFR
  if Ctrl.ShowCellsDeployment(3)
    f = figure(103);
    clf
    hold on
    
    for n = 1 : NumOfMacroCells  
      plot(centerPos(n,1),centerPos(n,2),'kh')
      plot(boundaries(:,1) + centerPos(n,1), ...
      boundaries(:,2) + centerPos(n,2), ...
      'b-','LineWidth',1.5)
        text(centerPos(n,1)+.1*MacroCellRadius,centerPos(n,2)+.1*MacroCellRadius,num2str(n))
    end
      axis equal
     else
      f = NaN;
  end
   
  if nargout > 0
    cells.NumOfMacroCells       = NumOfMacroCells;
    cells.MacroCellRadius       = MacroCellRadius;
%     cells.Macro_CenterRadius    = Macro_CenterRadius;
    cells.centerPos             = centerPos;
    cells.boundaries            = boundaries;
  end
  
end
