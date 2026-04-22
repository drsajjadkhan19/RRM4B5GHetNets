function [FFR3S,f] = getCellsFFR3S(NumOfMacroCells,NumOfFemtoCells,NumOfUsersPerMacroCell,MacroCellRadius,cells,femtos,users,Ctrl)
  
  % parameters
  if nargin < 1
    NumOfMacroCells     = 7;          % number of cells
  end
  if nargin < 4
    MacroCellRadius     = 500;        % cell radius
  end
 
    NumOfSectors        = 3;               % number of sectors
 

    ZoneRadius          = cells.ZoneRadius;       % radius of central and intermediate zones

  
  % control parameters
  if nargin < 8
    Ctrl.ShowCellsDeployment(2) = true;
  end
  
% %  check parameters
%     NumOfZones = length(ZoneRadius) + 1;          % number of zones
%     layers_outer = zeros(NumOfMacroCells,2);
%     layers_inner = zeros(NumOfMacroCells,2);
%     centerPosDist = zeros(NumOfMacroCells,1);
    
% %  constant parameters  
%     NumOfEdges = 6; 
   
% 
%   angles     =  (pi/6:-pi/3:-2*pi).';
%   centerPos  =  [[0;cos(angles(:))], ...
%                  [0;sin(angles(:))]] * MacroCellRadius * sqrt(3);
%  
%  
%   angles     = (0:pi/3:2*pi).';                 %find angles for hexagon
%   boundaries = [cos(angles(:)),sin(angles(:))] * MacroCellRadius;
  
  angles     = linspace(0,2*pi,100);
  layers     = [cos(angles(:)),sin(angles(:))] * 1;
  
 
  if Ctrl.ShowCellsDeployment(3)
    f = figure(103);
  
    for n = 1 : NumOfMacroCells  
   
    for l=1:length(ZoneRadius)
%         layers_inner = [MacroCellRadius.*ZoneRadius(1).*cos(45)+centerPos(n,1), ... 
%                            MacroCellRadius.*ZoneRadius(1).*sin(45)+ centerPos(n,2)];
%         layers_outer =  [MacroCellRadius.*ZoneRadius(2).*cos(45)+centerPos(n,1), ... 
%                             MacroCellRadius.*ZoneRadius(2).*sin(45)+ centerPos(n,2)];
%                           
%         cells.innerDist(n,1)  = calcDist(centerPos(n,1),centerPos(n,2),layers_inner(1),layers_inner(2));
%         cells.outerDist(n,1)  = calcDist(centerPos(n,1),centerPos(n,2),layers_outer(1),layers_outer(2));
                           
        plot(layers(:,1)*ZoneRadius(l).*MacroCellRadius + cells.centerPos(n,1), ...
             layers(:,2)*ZoneRadius(l).*MacroCellRadius + cells.centerPos(n,2), ...
               'r--')
    end
        for s = 1 : NumOfSectors         
        % plot sectors
         angles     = [0 2*pi/NumOfSectors] + 2*pi/NumOfSectors*(s-1);
         sectors    = [ [0;cos(angles(1));NaN;0;cos(angles(2))], ...
                        [0;sin(angles(1));NaN;0;sin(angles(2))] ] * MacroCellRadius;
         plot(sectors(:,1) + cells.centerPos(n,1), ...
              sectors(:,2) + cells.centerPos(n,2), ...
              'k--')         
        end
    end
      axis equal
     else
      f = NaN;
  end
  
  if nargout > 0
    FFR3S.NumOfSectors    = NumOfSectors;
    FFR3S.sectorInitAngle = 2*pi/NumOfSectors*(0:(NumOfSectors+1));
    FFR3S.layersDist      = [0,MacroCellRadius*ZoneRadius(1:end)];

% find femtos sectors and layers
    for f=1:NumOfFemtoCells
        FFR3S.femto_sector(f,1)    = find(FFR3S.sectorInitAngle < femtos.centerAngle(f,1) &  femtos.centerAngle(f,1) < [FFR3S.sectorInitAngle(2:end),Inf]);
        FFR3S.femto_layer(f,1)     = find(FFR3S.layersDist < femtos.centerDist(f) & femtos.centerDist(f) < [FFR3S.layersDist(2:end),Inf]);
    end

% find users sectors and layers
    for u=1:NumOfUsersPerMacroCell*NumOfMacroCells
        FFR3S.user_sector(u,1)   = find(FFR3S.sectorInitAngle < users.angle(u,1) &  users.angle(u,1) < [FFR3S.sectorInitAngle(2:end),Inf]);
        FFR3S.user_layer(u,1)    = find(FFR3S.layersDist < users.distanceFromCenter(u) & users.distanceFromCenter(u) < [FFR3S.layersDist(2:end),Inf]);
    end

  end
  end
