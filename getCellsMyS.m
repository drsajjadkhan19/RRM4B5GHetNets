function [MyS,f] = getCellsMyS(NumOfMacroCells,NumOfFemtoCells,NumOfUsersPerMacroCell,MacroCellRadius,cells,femtos,users,Ctrl)
  
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
  
 
  if Ctrl.ShowCellsDeployment(2)
    f = figure(102);
  
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
    MyS.NumOfSectors    = NumOfSectors;
    MyS.sectorInitAngle = 2*pi/NumOfSectors*(0:(NumOfSectors+1));
    MyS.layersDist      = [0,MacroCellRadius*ZoneRadius(1:end)];

% find femtos sectors and layers
    for f=1:NumOfFemtoCells
        MyS.femto_sector(f,1)    = find(MyS.sectorInitAngle < femtos.centerAngle(f,1) &  femtos.centerAngle(f,1) < [MyS.sectorInitAngle(2:end),Inf]);
        MyS.femto_layer(f,1)     = find(MyS.layersDist < femtos.centerDist(f) & femtos.centerDist(f) < [MyS.layersDist(2:end),Inf]);
    end

% find users sectors and layers
    for u=1:NumOfUsersPerMacroCell*NumOfMacroCells
        MyS.user_sector(u,1)   = find(MyS.sectorInitAngle < users.angle(u,1) &  users.angle(u,1) < [MyS.sectorInitAngle(2:end),Inf]);
        MyS.user_layer(u,1)    = find(MyS.layersDist < users.distanceFromCenter(u) & users.distanceFromCenter(u) < [MyS.layersDist(2:end),Inf]);
    end

  end
  end
