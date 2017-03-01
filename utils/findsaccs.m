% findsaccs.m: Take positional input data and return a list of points indicating% samples where saccades are occuring.  ('1' = 'good' data; '0' = saccade.)% Called by 'desacc.m,' although it can be called manually.% input args  'in': position data te be cleaned%             'thresh_a': acc threshold for detection %             'thresh_v': vel threshold for detection %             'gap_fp': max # allowable sub-threshold pts in a fast-phase segment%             'gap_sp': max # allowable supra-threshold pts in a slow-phase segment%             'vel_or_acc': choose velocity or accel criterion for detection%% Requires 'd2pt.m', 'maket.m' which require the sampling frequency to be stored% in a global variable named 'samp_freq'% written by:  Jonathan Jacobs%              September 2003 - May 2004 (last mod: 05/28/04)function [ptlist, pvlist] = findsaccs(pos, thresh_a, thresh_v, ...                            acc_stop, vel_stop, gap_fp, gap_sp, ...                            vel_or_acc, extend, dataName, strict_strip)global debug_mode kb_ondiff_level = 5;datalen = length(pos);% look for the desaccading windowsacc_cont = -1;wl = get(0,'Children');for i = 1:length(wl)   if strcmp(get(wl(i),'Name'),'Desacc Control'), sacc_cont=wl(i);  endend% usually provided via GUIif ~exist('thresh_a'),     thresh_a = 800; endif ~exist('acc_stop'),     acc_stop = 100; endif ~exist('thresh_v'),     thresh_v = 20; endif ~exist('vel_stop'),     vel_stop = 10; endif ~exist('gap_fp'),       gap_fp = 10; endif ~exist('gap_sh'),       gap_sp = 10; endif ~exist('vel_or_acc'),   vel_or_acc = 1; endif ~exist('extend'),       extend = 5; endif ~exist('dataName'),     dataName = 'unknown'; endif ~exist('strict_strip'), strict_strip = 1; end% convert input array from position to either vel or accel.vel = d2pt(pos, diff_level);acc = d2pt(vel, diff_level);switch vel_or_acc case 1, 	hitlist = find(abs(acc) >= thresh_a);	misslist = find(abs(acc) < thresh_a); case 2, 	hitlist = find(abs(vel) >= thresh_v);	misslist = find(abs(vel) < thresh_v); case 3, 	hitlist = find(abs(acc) >= thresh_a | abs(vel) >= thresh_v);	misslist = find(abs(acc) < thresh_a & abs(vel) < thresh_v); otherwise,  disp(['bad parameter: ''vel_or_acc'': ' vel_or_acc])  returnend% find the points that exceed either acc or vel thresholdif isempty(hitlist)   disp('findsaccs: no points exceed the given thresholds.')   out = ones(datalen,1);   returnend% Now we need to work 'inside-out' from the center of the blink/sacc to find% its beginning and end points.% Remember that the acceleration of a saccade has pos AND neg humps% Blink is even uglier: may have period of zero (eye closed) surrounded by big values% (close eye and then open eye).  Also use pos record for blink detection% first, determine connectedness/locate gaps in the list% h3 values >1 mark gaps.h1 = [hitlist(1) hitlist'];h2 = [hitlist'   hitlist(end)];temp = h2 - h1;h3 = temp(2:end);m1 = [misslist(1) misslist'];m2 = [misslist'   misslist(end)];temp = m2 - m1;m3 = temp(2:end);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 'q' is list of 'good' and 'bad' points in the data.% start with 'good' = sub-thresh, 'bad' = supra-thresh.% initialize 'nulls' array that 'q' will useq = ones(datalen,1);r = ones(datalen,1);   %% don't actually need 'r' array?q(hitlist) = 0;r(misslist) = 0;%diagnosticif debug_mode	figure('Name','findsacc debug')	plot(acc)	hold on	plot(q*1.4*thresh_a,'b')	plot(r*1.3*thresh_a,'r')	if kb_on, keyboard; endend% the 'hit' and 'miss' lists will have little gaps where a few points dropped below% (or rose above) the treshold in an otherwise 'pure' run.  We want to plug those% little gaps.% For saccases: refine by marking intra-saccade (NOT inter-) gaps as bad:% an intra-saccade gap will have ~<10 points?%% gap greater than 20(?) marks beginning of next saccadesaccgaplist  = find(h3>1 & h3<=gap_fp);       % make these tunable argsslowgaplist  = find(m3>1 & m3<=gap_sp);       % make these tunable args% loop through the saccgaplist% h2(saccgaplist(i)) is 1st point of gap, h3(saccgaplist(i)) is the length of the gapfor i = 1:length(saccgaplist)   startpt = h2(saccgaplist(i));   pluglen = h3(saccgaplist(i));   q(startpt:startpt+pluglen-1) = 0;end% do same for slow phase interruptions.for i = 1:length(slowgaplist)   startpt = m2(slowgaplist(i));   pluglen = m3(slowgaplist(i));   q(startpt:startpt+pluglen-1) = 0;   %%% not 'r' array.endif debug_mode, plot(q*1.2*1000,'g'); if kb_on, keyboard; end; end  % diagnostic% next, look for the point when val is back to zero (or just beyond)q1 = [q' 0];q2 = [0 q'];temp = q1-q2;% 1st and last peaks are artifactsq3 = temp(2:end-1);%diagnosticif debug_mode, plot(q3*1.1*thresh_a,'r'); if kb_on, keyboard; end; end% segstart ia ALWAYS -1, regardless of dir of saccadesegstart = find(q3 == -1);segstop  = find(q3 ==  1);% various sanity checks% 1) make sure that we are really starting with an ONSETif segstart(1)>segstop(1)   % there is NO "1st" saccade. trim the 1st segstop since it is unpaired   segstop = segstop(2:end);   disp('warning: deleted unpaired initial segstop.')end% 2) make sure that we are really ending with an OFFSETif segstart(end)>segstop(end)   % trim the last segstart since it is unpaired   segstart = segstart(1:end-1);   disp('warning: deleted unpaired terminal segstart.')endif length(segstart) ~= length(segstop)   disp('findsaccs: ERROR! -- #segstart ~= #segstop')   out = ones(datalen,1);   returnend% Now for a bit of refinement.  So far, we've been working with segments% that contain partial saccades. Let's try to identify the ACTUAL % saccadic onsets and offsets by examining points beyond the segment to look% for when the acceleration (and perhaps velocity?) drops below a set thresh.% for each saccade onsetlookback=100;for i = 1:length(segstart)   %if i==15, keyboard; end   % look backwards up to ~100 samples (should be long enough for sacc)   % but must protect against looking beyond the beginning of the data array   searchstop  = max(segstart(i)-lookback+1,1);   hist_b_acc  = acc(searchstop:segstart(i));   hist_b_vel  = vel(searchstop:segstart(i));   init_sign_a = sign(acc(segstart(i)));   init_sign_v = sign(vel(segstart(i)));   hb_len      = length(hist_b_acc);   % where accel falls below a given threshold (e.g. 100deg/s^2) or accel changes   % sign (to guarantee catching something), that's (almost) the end point.   % "Almost? Why not exactly?" you cry.  Because the accel has spread in time    % due to differentiation, we need to adjust the crossing points inward slightly.   % about five points should do it.  should this be hard coded, or left to user's   % preference with "extend" field in 'desacc'?   a_sign_change_pts = find(sign(hist_b_acc)~=init_sign_a);   if isempty(a_sign_change_pts), a_sign_change_pts = 0; end   pts_below_acc_thresh = find(abs(hist_b_acc)<=acc_stop);   if isempty(pts_below_acc_thresh), pts_below_acc_thresh = 0; end   stop_pt_acc = searchstop + max(a_sign_change_pts(end), pts_below_acc_thresh(end));       if isempty(stop_pt_acc), stop_pt_acc = segstart(i); end   stop_pt_acc = stop_pt_acc + 5;  %% <---- this is the band-aid line mentioned above   v_sign_change_pts = find(sign(hist_b_vel)~=init_sign_v);   if isempty(v_sign_change_pts), v_sign_change_pts = 0; end   pts_below_vel_thresh = find(abs(hist_b_vel)<=vel_stop);   if isempty(pts_below_vel_thresh), pts_below_vel_thresh = 0; end   stop_pt_vel = searchstop + max(v_sign_change_pts(end), pts_below_vel_thresh(end));   if isempty(stop_pt_vel), stop_pt_vel = segstart(i); end   % don't fall off the ends of the earth   cptempacc = max(stop_pt_acc(end), 1);   cptempvel = max(stop_pt_vel(end), 1);   % set the crossing point   switch (vel_or_acc)		case 1, crosspts(i,1) = cptempacc;		case 2, crosspts(i,1) = cptempvel;		case 3, crosspts(i,1) = fix((cptempacc+cptempvel)/2); %% use average?	end	%disp(['  segstart:' num2str(segstart(i))  ...	%		'  searchstop: ' num2str(searchstop)  ...	%		'  onset: ' num2str(crosspts(i,1))  ])     %% DIAGNOSTIC CODE   % plug it up   plugpts = crosspts(i,1):segstart(i);   q(plugpts) = zeros(size(plugpts));   % debug   if length(q) ~= datalen      segstop(i),length(q)      disp('ERROR in segstart.  Type ''break'' to continue')      if kb_on, keyboard; end      %break   endend% for each saccade offsetlookahead = 100;for i = 1:length(segstop)   % look forwards up to ~100 samples (should be long enough for sacc)   % but must protect against looking beyond the end of the data array   searchstop = min(segstop(i)+lookahead-1, datalen);   hist_f_acc = acc(segstop(i):searchstop);   hist_f_vel = vel(segstop(i):searchstop);   init_sign_a = sign(acc(segstop(i)));   init_sign_v = sign(vel(segstop(i)));   hf_len = length(hist_f_acc);   % where accel falls below a given threshold (e.g. 100deg/s^2) or   % accel changes sign, that's the end point   a_sign_change_pts = find(sign(hist_f_acc)~=init_sign_a);   if isempty(a_sign_change_pts), a_sign_change_pts = lookahead; end   pts_below_acc_thresh = find(abs(hist_f_acc)<acc_stop);   if isempty(pts_below_acc_thresh), pts_below_acc_thresh = lookahead; end   stop_pt_acc  = segstop(i) + min(a_sign_change_pts(1), pts_below_acc_thresh(1));   if isempty(stop_pt_acc), stop_pt_acc = segstop(i); end   %stop_pt_acc = stop_pt_acc - 5;  %% <---- this is the band-aid line mentioned above   v_sign_change_pts = find(sign(hist_f_vel)~=init_sign_v);   if isempty(v_sign_change_pts), v_sign_change_pts=lookahead; end   pts_below_vel_thresh = find(abs(hist_f_vel)<=vel_stop);   if isempty(pts_below_vel_thresh), pts_below_vel_thresh=lookahead; end   stop_pt_vel = segstop(i) + min(v_sign_change_pts(1), pts_below_vel_thresh(1));   if isempty(stop_pt_vel), stop_pt_vel = segstop(i); end   % don't fall off the ends of the earth   cptempacc = min(stop_pt_acc(1), datalen);   cptempvel = min(stop_pt_vel(1), datalen);      % set the crossing point   switch (vel_or_acc)		case 1, crosspts(i,2) = cptempacc;		case 2, crosspts(i,2) = cptempvel;		case 3, crosspts(i,2) = fix((cptempacc+cptempvel)/2); %% use average?	end	%disp(['  segstop:' num2str(segstop(i))  ...	%		'  searchstop: ' num2str(searchstop)  ...	%		'  offset: ' num2str(crosspts(i,2)) ])    %% DIAGNOSTIC CODE      % plug it up   plugpts = segstop(i):crosspts(i,2);   q(plugpts) = zeros(size(plugpts));      % debug   if length(q) ~= datalen      segstop(i),length(q)      disp('ERROR in segstop.  Type ''break'' to continue')      if kb_on, keyboard; end      %break   endendif debug_mode, plot(q*thresh_a,'m'); if kb_on, keyboard; end; endif datalen ~= length(q)   disp('findsaccs: ERROR! -- bad ptlist length!')   disp('Type ''break'' to continue')   if kb_on, keyboard; end   q = ones(datalen,1);end% check to see that the segments that we thought contained saccades actually do.% if it's 'really' a saccade, PV must exceed the min threshold set in desacc.numFPs = 0;for i = 1:length(segstart)   seg  = abs(vel(segstart(i):segstop(i)));   peak = find(seg == max(seg));   if max(seg)>thresh_v      numFPs = numFPs + 1;      pv_pt(numFPs) = peak(end) + segstart(i) - 1;      pvel(numFPs)  = max(seg);      saccstart(numFPs) = crosspts(i,1);      saccstop(numFPs)  = crosspts(i,2);   endend% real belt and suspenders stuff here.% we now have our list of saccade starts and stops (given by the crosspoints)% we will ASSUME that all other points than those delimited by these crosspoints% not saccadic.  remove only these points from a list of all points.% is there a down side?  yes.  we could re-include as SPh, points where the accel % and/or vel thresh was exceeded by funky eye mvmts or noise.q2 = ones(datalen,1);for i = 1:numFPs   q2(saccstart(i):saccstop(i)) = 0;end% basically, 'q2' can be considered 'strict' mode: only strictly defined saccades% are to be removed.  Conversely, 'q' is 'relaxed' mode, where any points that % exceed the threshold are used to build knockout.% debugif debug_mode   figure   plot(vel,'r')   hold on   plot(pv_pt,vel(pv_pt),'bo')   if kb_on, keyboard; endend% output argumentsswitch strict_strip  case 1, ptlist = q2;  case 2, ptlist = q;endpvlist=pv_pt;% put all the results into the base workspace.assignin('base','ptlist',    ptlist) assignin('base','pvlist',    pv_pt)assignin('base','saccstart', saccstart)assignin('base','saccstop',  saccstop)assignin('base','pvel',      pvel)assignin('base','extend',    extend)assignin('base','dataName',  dataName)assignin('base','thresh_v',  thresh_v)assignin('base','thresh_a',  thresh_a)assignin('base','vel_stop',  vel_stop)assignin('base','acc_stop',  acc_stop)