function [channelGain_macro,channelGain_femto] = getChannelCoeff(NumOfMacroCells,NumOfFemtoCells,NumOfUsersPerMacroCell,TotalNumOfRBs,Shadow_std_dB,users,cells,femtos)
% get users distance from cellslices
    userDistFromMacro = zeros(NumOfMacroCells*NumOfUsersPerMacroCell,NumOfMacroCells);
    userDistFromFemto = zeros(NumOfMacroCells*NumOfUsersPerMacroCell,NumOfFemtoCells);
for u = 1 : NumOfMacroCells*NumOfUsersPerMacroCell
  for m = 1 : NumOfMacroCells
    userDistFromMacro(u,m) = norm(users.position(u,:) - cells.centerPos(m,:));
  end
end

for u = 1 : NumOfMacroCells*NumOfUsersPerMacroCell
  for m = 1 : NumOfFemtoCells
      userDistFromFemto(u,m) = norm(users.position(u,:) - femtos.centerPosition(m,:));
  end
end

% calculate channel gain for each link
channelGain_macro = complex(zeros(NumOfMacroCells*NumOfUsersPerMacroCell,NumOfMacroCells,TotalNumOfRBs));
channelGain_femto = complex(zeros(NumOfMacroCells*NumOfUsersPerMacroCell,NumOfFemtoCells,TotalNumOfRBs));

channelGain_macro = repmat(10.^(-0.1*indoorPathLossdB(userDistFromMacro)+0.1*randn(size(userDistFromMacro))*Shadow_std_dB),1,1,TotalNumOfRBs).* ...
abs(1/sqrt(2)*(randn(size(channelGain_macro)) + 1i*randn(size(channelGain_macro)))).^2;

channelGain_femto = repmat(10.^(-0.1*indoorPathLossdB(userDistFromFemto)+0.1*randn(size(userDistFromFemto))*Shadow_std_dB),1,1,TotalNumOfRBs).* ...
abs(1/sqrt(2)*(randn(size(channelGain_femto)) + 1i*randn(size(channelGain_femto)))).^2;
end