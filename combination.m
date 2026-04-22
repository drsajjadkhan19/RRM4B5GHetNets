
ind0 = 0;

for ii = 1:I

    ind = ind0 + C1_numOfUsersPerIteration(ii);
    users = C1_numOfUsersPerIteration(ii);
    
        Ind0 = 0;
  for n = 1 : cells.NumOfMacroCells
  
   
    Ind = Ind0 + (1:NumOfUsersPerMacroCell);
    
    
    
    newThroughput_NP(:,ii) =    C1_ThroughputNP(users,1); 
    
end