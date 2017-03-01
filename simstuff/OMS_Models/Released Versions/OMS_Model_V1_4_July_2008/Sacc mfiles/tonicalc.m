% tonicalc.m: iterative calculate the best tonic gain (tgain) so that % the steady-state eye position (measured at 0.75 sec?) is spot-on.%% Usage: set up "pwtstbed" with the PG width function you wish to use.% Settings: PWtstbed:Double Pulse:Pulse 1 Mag: "goal" (w/o quotes)%           PWtstbed:Double Pulse:Pulse 1 Dur: "stoptime" (w/o quotes)%% Usage: set up "pwtstbed" with the PG width function you wish to use.% Put the "tonic test" block in testbed.% Settings: Testbed:Double Pulse:Pulse 1 Mag: "stimhgt" (w/o quotes)%           Testbed:Double Pulse:Pulse 1 Dur: "stimdur" (w/o quotes)%% "delay" is the value of the delay block (if one is used)% in the plant model in seconds.% Written by:  Jonathan Jacobs%              October 1998 (last mod:  10/22/98)% set 'whatfunc' to the name of the pulse height function we want% to calculate the tonic gain for.  (e.g. whatfunc = 'PHfn_pk';)whatfunc = 'PHfn_pk';extra = 0.02;    % we run the sim xx ms beyond pulse termination.%pdelay = input('Enter the delay for the test plant (in seconds): ');pdelay = 0.001;disp(['Calculating tonic gains to match pulses generateb by ' whatfunc])tic;disp(['  goal      peak        SS       PH       tgain      iter    %error'])disp(['  -----------------------------------------------------------------'])iterLim = 100;   % How many times will we try before raising the error limit.index=0;pcterror=[]; errlist=[]; finalstim=[];stimdurlist=[]; stimlist=[]; finaltgain=[];ss=[]; eyepos=[]; pts=[]; peak=[];whenpeak=[];%% use these two lines (one at a time) to create the data to put into%% "PHfnxxx" type functions.  (Use PHprint to format it nicely.)%stimlist = [0.05:0.01:0.09];%stimlist = [(0.1:0.1:50.0)];%% Use this line to get a rougher overviewstimlist = [(0.05), (0.1:0.1:0.9), (1:50)];%% whatever...%stimlist = [(1:50)];for goal = stimlist   index=index+1;      % calc the pulse amplitude.  Change the PH function name as needed   % to make sure that it is appropriate for the PW function in PWtstbed!!!   % (i.e. this PH function should have been generated using that PW function   % using PGcalc.)   eval(['stimhgt = ' whatfunc '(goal);']);   PHlist(index) = stimhgt;   % find the pulse width   stoptime=0.25; % run 'pwtstbed' this long (seconds)   [a,b,c]=rk45('pwtstbed', stoptime, [], [1e-3, 0.001, 0.001, 0,0,2]);   pts = find(pwout==0);   stimdur = twClock(pts(2)-1) - twClock(pts(1));   stimdurlist(index) = stimdur;   stoptime = stimdur + 0.6;  % run 'testbed' 600 ms beyond pulse termination   %plot(t,pwout)   %pause   % define starting points for the iterations   if index == 1      tgain = 3.5;    else      tgain = finaltgain(index-1);   end   count=0;   error = 100;    fiddle = 1.0;    starterrlim = min(0.0075*goal,0.05);   errlim = starterrlim;   resets = 0;   lasterror = 0;   while (abs(error)>errlim) & (count<iterLim);      count=count+1;      [a,b,c]=rk45('testbed', stoptime, [], [1e-3, 0.001, 0.001, 0,0,2]);            peak(index) = max(out);      temp = find(out==max(out));      whenpeak(index) = temp(1);      delaytopeak(index) = whenpeak(index)-(stimdur*1000);      %ss(index) = NaN;      ss(index) = out(length(out));      error = (ss(index) - goal);      errlist(count,index) = error;      if sign(error) == sign(lasterror)         ;       else         fiddle = 0.5*fiddle;      end      lasterror = error;      pcterror(index) = error/goal;      tgain = tgain - sign(error)*0.05*fiddle;      finaltgain(index) = tgain;      % If we've made it to the end of 'iterLim' trials without having found      % a good solution, there's the possibility that we can't get that      % close.  Perhaps we're oscillating, so let's try with a larger limit.      % In these cases we will probably end up searching for the best solution      % manually, but maybe we'll get lucky here, first...      if (count == iterLim-1)         %elist2 = errlist(:,index);         %elist3 = elist2(find(elist2 ~= 0));          %minerror = min(abs(elist3));         %errlim = 1.1*minerror;         count = 1;         resets = resets + 1;         if resets > 0  %3            errlim = errlim*1.5;              resets = 0;                  end         disp([' *****  New errlim: ' num2str(errlim) '  *****'])         %screwed this next line up when we reset 'resets'         %priorerrlists(:,resets) = errlist(:,index);       end   end      s = sprintf('%6.2f   %8.4f   %8.4f   %8.4f   %8.4f   %6.0f   %8.4f',...          stimlist(index),  peak(index), ss(index), PHlist(index),...          finaltgain(index), count, pcterror(index)*100  );   disp(s)enddisp(['Elapsed time: ' num2str(toc)])figureplot(stimlist,finaltgain)xlabel('Saccade Magnitude')ylabel('Tonic Gain')