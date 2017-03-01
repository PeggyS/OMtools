% nafloop2.m: iterative solution of tau matrix for NAF/NAFX% Find the tau that results in an NAFx (extended pos,vel limits)% equivalent to the NAF obtained for the default pos,vel limit.% Written by:  Jonathan Jacobs%              March 1998 - July 2000 (last mod: 07/06/00)% algorithm parameterserrlim=0.0005;iterLim=1000;step=0.05;if ~exist('pos')   pos = [];endif isempty(pos)   disp('You must load a data file, select ONE data trace using "PICKDATA",')   disp('and calculate its velocity and count the number of')   disp('foveations (try the automatic counting feature in "NFF")')   disp('before you can use "NAFloop"')   returnend[r,c]=size(pos);if min(r,c)>1   disp('You must pick EXACTLY ONE data set with "PICKDATA"')   returnendif ~exist('samp_freq')   samp_freq = [];endif isempty(samp_freq)   samp_freq = 0;endif samp_freq == 0   samp_freq = input('Enter the sampling frequency (0 to cancel): ');   if samp_freq==0      disp('Cancelling')      return   endendnumfov = [];initPosArray=[0.5 0.75 1.0 1.25 1.5 2.0 2.5 3.0 3.5 4.0 5.0 6.0];initVelArray=[4.0 5.0 6.0 7.0 8.0 9.0 10.0];posArray=[];velArray=[];pmode = lower(input('Start from 0.5 deg? ','s'));if pmode=='y'   posArray = initPosArray;   velArray = initVelArray;   posD=0.5;   velD=4.0;   tauD=33.3;   standardFWIN = 1; else   startPt = 1000;   while (startPt >= initPosArray(length(initPosArray)))      startPt = input('Start from what position limit? ');   end   velArray = initVelArray;   temp = find(initPosArray>=startPt);   startPtIndex = temp(1);   posArray = initPosArray(startPtIndex:length(initPosArray));   posD = startPt;   velD = 4.0;   tauD=33.3;   standardFWIN = 0;end% initialize the results matricestauNAF  = NaN*ones(length(velArray),length(posArray));nafSoln = zeros(length(velArray),length(posArray));numIts  = zeros(length(velArray),length(posArray));% find the number of foveations[null1, null2, null4, numfov(1,1)]= ...        nff(pos,vel,samp_freq,[posD,velD],'showpv');% decide if this is the proper number of foveationsdisp([num2str(numfov(1,1)) ' foveations found by "findfovp"'])temp = input('Press RETURN to accept this, or enter a new value: '); if ~isempty(temp)   numfov(1,1) = temp;end% When we have someone who can't meet normal FWIN criteria, we have to% start from a more extreme lower position limit (e.g. 2.0, rather than 0.5).% Furthermore, we need to find the tau that will make the NAFx match the visual% acuity we have recorded for this case.% get the values we want to match% first case: starting from (0.5,4.0) means that we know the initial Tau% will be 33.3 ms, and we need to calculate the targeted NAF (i.e. the one% we will be trying to match for the rest of the FWIN combinations)% second case: we are starting from a more liberal position limit, and therefore% we do not know our starting tau, but we DO know (we must have measured it previously)% the NAF that the subject has for this FWIN.if (standardFWIN)   [nafTgt,nafpTgt,a,b,c,d] = nff(pos,vel,samp_freq,numfov(1,1),'nafx',[tauD,posD,velD]);   tauNAF(1,1) = 33.3; else   va_or_naf = -1;   disp(' 1) Enter subject''s visual acuity, or')   disp(' 2) subject''s NAF (calculated from VA)')   while(va_or_naf<1) | (va_or_naf>2)      va_or_naf = input(' --> ');   end   if va_or_naf == 1      va = input('Enter this subject''s measured visual acuity: ');      nafTgt = (va+0.065)/1.44;      disp(['  NAF calculated to be ' num2str(nafTgt)])    else      nafTgt = input('Enter this subject''s NAF (based on measured visual acuity): ');   end   % this is just a guess for initial starting tau.  it's probably   % way too low, and we may not get the correct tau quickly.   tauNAF(1,1) = 33.3;end% start the loops to% find the solution for each (pos, vel) combo.tic;for j=1:length(velArray)   velLim=velArray(j);   if j>1      tauInit=tauNAF(j-1,1);    % starting guess: starting posLim, previous velocity    else      tauInit=tauD;   end   for i=1:length(posArray)      posLim=posArray(i);      disp( ['VelLim: ' num2str(velLim) ',   PosLim: ' num2str(posLim)])      naf=0;                     % clear the naf      if i>1         tau=tauNAF(j,i-1);      % start from previous solution for this vel       else         tau=tauInit;      end      count=0;inc=0;dec=0;      % before we can look for the NAFX,we need to determine the number      % of foveations for each (posLim,velLim) combo.  we can either      % use the number calculated before (for baseline pos_lim,vel_lim)      % or calculate them again for this new (pos_lim,vel_lim) combo      if (1)         numfov(j,i) = numfov(1,1);       else         [null1, null2, null4, numfov(j,i), null5, null6]= ...              nff(pos,vel,samp_freq,[posLim,velLim],'showpv');      end            while abs(nafTgt-naf)>errlim & count<iterLim         %disp('trying new tau')         % use six output args to suppress display to screen         [naf,nafp,a,b,c,d]=...                 nff(pos,vel,samp_freq,numfov(j,i),'nafx',[tau,posLim,velLim]);         if (nafTgt-naf)>errlim            %disp('decrementing tau')            tau=tau-step;            dec=dec+1;          elseif (nafTgt-naf)<-errlim            %disp('incrementing tau');            tau=tau+step;            inc=inc+1;          else            %disp('Got it!');         end         count=count+1;         if count>(iterLim-1)            disp('SHIT! couldn''t find the solution!')            % there are many reasons why we don't get a solution            % in this case the step size was just too small            if ~(dec>0 & inc>0)               disp(['Doubling the step size to ' num2str(step*2)])               step=step*2;               count = 0;            end         end      end      % columns: position      % rows: velocity      tauNAF(j,i)  = tau;      nafSoln(j,i) = naf;      numIts(j,i)  = count;      disp(['   Foveations: ' num2str(numfov(j,i))...            '.      solution took ' num2str(count) ' iterations.'])   endendstopTime=toc;disp(['Elapsed time: ' num2str(stopTime)])% draw a pretty picturefiguresurf(posArray, velArray, tauNAF)%mesh(posArray, velArray, tauNAF)title(['Tau for NAF  (file: ' what_f_array ')'])xlabel('Position Limit')ylabel('Velocity Limit')zlabel('Tau (ms)')rotplot