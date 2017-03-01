% wheresac.m:  Given a vector of saccades, tell what files % they come from% written by:  Jonathan Jacobs%              May 1996 (last mod: 05/16/96)function wheresac( sac_vect )global namearray global what_f_array sacv_on_matif ~exist('what_f_array')   disp( ' ' )   disp( 'numsacs: You must run "pickdata" before you can use this routine.' )   pickdata   returnendsac_vect = sort(sac_vect);[r, c] = size(sac_vect);        % make it a row vectorif c == 1   sac_vect = sac_vect';endsac_vect = [sac_vect 10000];    % so we don't go past the end with a 'j=j+1'[numFiles, dummy] = size(what_f_array);runningT = 0; nSacs = []; j=1;disp( ' ' )for i = 1:numFiles   nSacs(i) = length(find(sacv_on_mat(:,i)<100000));   runningT = runningT + nSacs(i);   inThisFile = []; where = [];   while (sac_vect(j) <= runningT)      inThisFile = [inThisFile sac_vect(j)];      where = [where, sac_vect(j)-(runningT-nSacs(i))];      j = j + 1;   end   if inThisFile ~= []      if length( inThisFile ) == 1         disp( ['Saccade ' mat2str(inThisFile) ' is saccade '...                 mat2str(where) ' in ' namearray(i,:)] )       elseif length( inThisFile ) <= 8         disp( ['Saccades ' mat2str(inThisFile) ' are saccades '...                 mat2str(where) ' in ' namearray(i,:)] )       else         disp( ['Saccades ' mat2str(inThisFile) ] )         disp( [ '  are saccades ' mat2str(where) ' in ' namearray(i,:)] )      end   endenddisp( ' ' )