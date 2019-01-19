% findsaccs.m: Take positional input data and return a list of points indicating% samples where saccades are occuring. ('1' = 'good' data; '0' = saccade.)% Called by 'desacc.m,' although it can be called manually.% foundsaccs = findsaccs(pos, acc_on, vel_on, acc_off, vel_off, ...%                        gap_fp, gap_sp, vel_or_acc, extend, range, direction)% inputs:%    in: position data to be analyzed%    acc_on:  acc threshold for detection%    vel_on:  vel threshold for detection%    acc_off: acc threshold for detection%    vel_off: vel threshold for detection%    gap_fp:  max # allowable sub-threshold pts in a fast-phase segment%    gap_sp:  max # allowable supra-threshold pts in a slow-phase segment%    vel_or_acc: choose velocity or accel criterion for detection%    extend: (((this might get removed)))%    range:     [lo, hi] Include only saccades in this range (dflt [0 40])%    direction: 'l', 'r' or 'b' Include only saccades in this direction.%% output: struct with these fields:%    num    : number of saccades found in given data segment%    ptlist : map of segment: saccade==0, non-saccade==1%    pvel   : list of peak velocities%    pv_ind : sample numbers of peak velocities%    pacc   : list of peak ONSET accelerations%    pa_ind : sample numbers of peak ONSET accelerations%    detcrit: criteria (vel and/or acc -- or none) used to detect saccade%    v_start, v_stop : saccade begin/end (using vel criteria)%    a_start, a_stop : saccade begin/end (using acc criteria)%    start,   stop   : saccade begin/end (final selection)% written by:  Jonathan Jacobs%              September 2003 - January 2019 (last mod: 01/19/19)% complete overhaul, March 2018% Dec 2018: %   added peak accel values and indices to output structure%   fixed max/min in vel-based calc%   fixed abs problem in acc-based calc%   fixed 'BOTH' to no longer be 'EITHER' pts selection. SHAME!!!%   fixed logic error in abad/vbad selection of final ss points % Jan 2019:%   FINALLY crushed the acceleration detection bugs.%   1) accel is biphasic so we needed to join the two halves!!!%      So: spread the a_saccpts segment endpoints outwards%   2) fixed sacc endpoint selection indexing error.%      redefined acc_seg2 as starting at its PEAK.% Add to output?% An "all detected" in addition to the selected amplitude/directionfunction foundsaccs = findsaccs(pos, acc_on, vel_on, acc_off, vel_off, ...   gap_fp, gap_sp, vel_or_acc, extend, range, direction)if nargin==0   findsaccs_gui;   returnend% DEFAULT VALUES (also provided via GUI)if ~exist('acc_on','var'),  acc_on = 800; endif ~exist('acc_off','var'), acc_off = 600; endif ~exist('vel_on','var'),  vel_on = 40; endif ~exist('vel_off','var'), vel_off = 40; endif ~exist('gap_fp','var'),  gap_fp = 10; endif ~exist('gap_sp','var'),  gap_sp = 10; endif ~exist('vel_or_acc','var'), vel_or_acc = 'b'; endif ~exist('extend','var')|| isempty(extend), extend = 0; end %#ok<NASGU>if ~exist('range','var') || isempty(range),  range = [0 40]; endif ~exist('direction','var') || isempty(direction),direction = 'b'; end% deblink the pos data before we differentiate. diff_level = 3;numpts = length(pos);pos = ao_deblink(pos);vel = d2pt(pos, diff_level);acc = d2pt(vel, diff_level);% Use vel/acc stats to estimate best on/off values?% Use histcounts to determine (say 85%) amplitude of SP band.% Don't think this is that helpful -- see "bfi_distrib" concept test% Would do something like this OUTSIDE of findsaccs, anyway.% Leaving comments here to remind me not to repeat bad idea. Jan 2019switch lower(direction(1))   case 'l'      sacc_dir = -1;   case 'r'      sacc_dir = 1;   case 'b'      sacc_dir = 0;   otherwiseend% find the points that exceed acc and/or vel thresholdv_or_a = vel_or_acc(1);switch v_or_a   case {'A','a',1}      a_saccpts = find(abs(acc) >= abs(acc_on));      % spread detected points to join two detected halves      for ii = 1:10         a_saccpts = union(a_saccpts,a_saccpts+1);         a_saccpts = union(a_saccpts,a_saccpts-1);      end      saccpts=a_saccpts;      use_accel=1;      use_vel = 0;   case {'V','v',2}      v_saccpts = find(abs(vel) >= abs(vel_on));      saccpts=v_saccpts;      use_vel=1;      use_accel=0;   case {'B','b',3} % pts must satisfy BOTH a AND v criteria      a_saccpts = find(abs(acc) >= abs(acc_on));            for ii = 1:10         a_saccpts = union(a_saccpts,a_saccpts+1);         a_saccpts = union(a_saccpts,a_saccpts-1);      end            av_saccpts = intersect( a_saccpts, find(abs(vel)>=abs(vel_on)) );      saccpts=av_saccpts;      use_accel=1;      use_vel=1;   %case {'E','e',4} % pts must satisfy EITHER a OR v criteria (UNUSED)      %av_saccpts = union( a_saccpts, find(abs(vel)>=abs(vel_on)) );      %saccpts=av_saccpts;      %use_accel=1;      %use_vel=1;   %case {'M','m',4} % Mean of independent V and A calcs      %use_accel=1;      %use_vel=1;   otherwise      disp(['bad parameter: ''vel_or_acc'': ' vel_or_acc])      foundsaccs.num=0;      returnendmisspts = setdiff(1:length(pos),saccpts);if isempty(saccpts)   disp('findsaccs: no points exceed the given thresholds.')   foundsaccs.num=0;   returnend% qraw is the list of points in the raw data that meet vel and/or acc crit.q = ones(numpts,1);q(saccpts) = 0;%qraw = q;% The raw 'hit' and 'miss' lists may have gaps where a few points dropped below% (or rose above) the threshold in an otherwise 'pure' run. We want to plug those% little gaps. Refine by marking intra-saccade (NOT inter-) gaps as bad:% an intra-saccade gap will have ~<10 points?% A gap greater than 20(?) marks beginning of next saccade% Determine connectedness/locate gaps in the listsaccgaps    = diff(saccpts);saccgaplist = find(saccgaps>1 & saccgaps<=gap_fp);slowgaps    = diff(misspts);slowgaplist = find(slowgaps>1 & slowgaps<=gap_sp);%{h1 = [saccpts(1) saccpts'];h2 = [saccpts'   saccpts(end)];temp = h2 - h1;h3 = temp(2:end);saccgaplist2  = find(h3>1 & h3<=gap_fp);m1 = [misspts(1) misspts'];m2 = [misspts'   misspts(end)];temp = m2 - m1;m3 = temp(2:end);slowgaplist  = find(m3>1 & m3<=gap_sp);%}for i = 1:length(saccgaplist)   startplug = saccpts(saccgaplist(i));   pluglen   = saccgaps(saccgaplist(i));   q(startplug:startplug+pluglen-1) = 0;endfor i = 1:length(slowgaplist)   startplug = misspts(slowgaplist(i));   pluglen   = slowgaps(slowgaplist(i));   q(startplug:startplug+pluglen-1) = 1;end%{all plugged and polished.look for the point when val is back to zero (or just beyond)q1 = [q' 0];q2 = [0 q'];temp = q1-q2;q3 = temp(2:end-1); % 1st and last peaks are artifactsif debug_mode, plot(q3*1.1*acc_on,'r'); if kb_on, keyboard; end; endsegstart = find(q3 == -1);segstop  = find(q3 ==  1);%}clear segstart segstopsegstart = find(diff(q) == -1); % ALWAYS -1, regardless of dir of saccadesegstop  = find(diff(q) ==  1);if isempty(segstart)   %disp('Error! No segstart.');   foundsaccs.num=0;   returnendif isempty(segstop)   %disp('Error! No segstop.');   foundsaccs.num=0;   returnend% Make sure that we are really starting with an ONSET, ending with an OFFSETif segstart(1)>segstop(1)   % there is NO "1st" saccade. trim the 1st segstop since it is unpaired   if length(segstop)>1       segstop = segstop(2:end);   else      %disp('Error! No saccade found.');      foundsaccs.num=0;      return   end   %disp('FYI: deleted unpaired initial segstop. No big deal.')endif segstart(end)>segstop(end)   % trim the last segstart since it is unpaired   if length(segstart)>1      segstart = segstart(1:end-1);   else      %disp('Error! No saccade found.');      foundsaccs.num=0;      return   end   %disp('FYI: deleted unpaired terminal segstart. No big deal.')endif length(segstart) ~= length(segstop)   disp('findsaccs: WARNING! -- length(segstart) ~= length(segstop)')   returnend% Now for a bit of refinement. So far, we've been working with segments% that may contain only part of a saccade. Let's try to identify the ACTUAL% saccadic onsets and offsets by examining points beyond the segment to look% for when the accel,vel drops below a set thresh.% Work 'inside-out' from the center of sacc vel to find beginning and end points.% Remember that the accel has TWO humps: do for pos and for neg% When accel falls below a given threshold (e.g. 100deg/s^2) that's (almost)% the end point. "Almost? Why not exactly?" you cry. Because accel has spread out% due to differentiation, we must adjust the crossing points inward slightly.% About five points should do it. should this be hard coded, or left to user's% preference with "extend" field in 'desacc'?ss=size(segstart);startpt=NaN(ss);a_sacc_beg=NaN(ss); a_sacc_end=NaN(ss);v_sacc_beg=NaN(ss); v_sacc_end=NaN(ss);offset1=NaN(ss);    offset2=NaN(ss);n_ind=NaN(ss);  p_ind=NaN(ss);pacc_p=NaN(ss); pacc_n=NaN(ss);pk_vel = NaN(ss); pv_ind = NaN(ss);pk_acc = NaN(ss); pa_ind = NaN(ss);ss_pts = NaN(ss(1),2);det_v_or_a = cell(length(segstart),1);lookback=20;sacc_mag_v=NaN(size(segstart));sacc_mag_a=NaN(size(segstart));for j = 1:length(segstart)      % look backwards up to ~20 samples (should be long enough for sacc)   % but don't look beyond the beginning of the data array   startpt(j) = max(segstart(j)-lookback+1,1);   segpts  = startpt(j):segstop(j);   seg_vel = vel(segpts);   seg_acc = acc(segpts);      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   % determine acc-based saccade start/stop/peak accel   % *** acc is DOUBLE-humped (accel/decel) ***   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   temp=find(abs(seg_acc)==max(abs(seg_acc)), 1);   if isempty(temp)      a1_good=[];      a2_good=[];   else      p_ind(j) = temp;      pacc_p(j) = seg_acc(p_ind(j));      p_sign = sign(pacc_p(j));            n_ind(j)=find(seg_acc==min(seg_acc), 1);      pacc_n(j) = seg_acc(n_ind(j));      n_sign = sign(pacc_n(j));            if p_ind(j)<n_ind(j)         seg_acc1 = seg_acc(1:p_ind(j));         seg_acc2 = seg_acc(n_ind(j)+1:end);         a1_sign = p_sign;         a2_sign = n_sign;         offset1(j)  = p_ind(j); %peak of seg1         offset2(j)  = n_ind(j); %peak of seg2      else         seg_acc1 = seg_acc(1:n_ind(j));         seg_acc2 = seg_acc(p_ind(j)+1:end);         a1_sign = n_sign;         a2_sign = p_sign;         offset1(j) = n_ind(j); %peak of seg1         offset2(j) = p_ind(j); %peak of seg2      end            % we use the 1st segment's peak as peak accel (&index).      % (2nd seg peak is maximum DECEL, which is marginally useful)      pk_acc(j)   = seg_acc(offset1(j));      pa_ind(j) = startpt(j)+offset1(j)-1;            % find saccade START, using acceleration peak.      % (only care about data BEFORE peak accel)      a1_same = find( sign(seg_acc1)==a1_sign );      a1_diff = find(diff(a1_same)>1);      if ~isempty(a1_diff)         a1_same = a1_same( a1_diff(1)+1:end );      end      a1_on_pts = find( (a1_sign*seg_acc1)>=acc_on );      if isempty(a1_on_pts)         a_sacc_beg(j) = NaN; % bail         a1_good = [];      else         a1_good = intersect(a1_same,a1_on_pts);         if isempty(a1_good)            a_sacc_beg(j)=NaN;         else            a_sacc_beg(j)=startpt(j)+a1_good(1);            a_sacc_beg(j)=max(a_sacc_beg(j),1);         end      end      % find saccade STOP, using deceleration peak.            % (only care about data AFTER peak decel)      a2_same = find( sign(seg_acc2)==a2_sign );      a2_diff = find(diff(a2_same)>1);      if ~isempty(a2_diff)         a2_same = a2_same(1:a2_diff(1));      end      a2_off_pts = find( (a2_sign*seg_acc2)>=acc_off );      if isempty(a2_off_pts)         a_sacc_end(j) = NaN; % bail         a2_good=[];      else         a2_good = intersect(a2_same,a2_off_pts);         if isempty(a2_good)            a_sacc_end(j)=NaN;         else            a_sacc_end(j)=startpt(j)+offset2(j)+a2_good(end);            a_sacc_end(j)=min(a_sacc_end(j),length(pos) );         end      end            % only include saccade if in desired direction, and magnitude range      % *OR* if it is direction/mag range for dynamic overshoot      % by comparing it to previous GOOD saccade.      good_dir=0; good_mag=0; sacc_mag_a(j)=NaN; nanflag=0;      if isnan(a_sacc_end(j)) || isnan(a_sacc_beg(j))         nanflag=1;      else         sacc_mag_a(j) = pos(a_sacc_end(j)) - pos(a_sacc_beg(j));         if sacc_dir==0            good_dir=1;         else            if sign(sacc_mag_a(j))==sign(sacc_dir) %               good_dir = 1;            end         end      end      if abs(sacc_mag_a(j))>=range(1) && abs(sacc_mag_a(j))<=range(2)         good_mag = 1;      end   end %isempty(temp)      if nanflag==1 || isempty(a1_good) || isempty(a2_good) || ~good_mag || ~good_dir      %fprintf('No good acc pts, sacc# %d\r',j)      agood=0;   else      agood=1;   end            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   % determine vel-based saccade start/stop/peak vel   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   localpeak=find(abs(seg_vel)==max(abs(seg_vel)), 1);   if isempty(localpeak)      v1_good=[];      v2_good=[];   else      pk_vel(j) = seg_vel(localpeak);      pv_sign = sign(pk_vel(j));      pv_ind(j) = localpeak+startpt(j)-1;      % split segments at the peak vel pt.      seg_vel1 = seg_vel(1:localpeak);      seg_vel2 = seg_vel(localpeak+1:end);            v1_same = find( sign(seg_vel1)==pv_sign );      v1_diff = find(diff(v1_same)>1);      if ~isempty(v1_diff)         v1_same = v1_same(v1_diff(end)+1:end);      end      v1_high = find( abs(seg_vel1)>=abs(vel_on) );      if isempty(v1_high)         v1_good = []; % bail         v_sacc_beg(j) = NaN;      else         v1_good = intersect(v1_same,v1_high);         if isempty(v1_good)            v_sacc_beg(j)= NaN;         else            v_sacc_beg(j)=startpt(j)+v1_good(1)-1;            v_sacc_beg(j)=max(v_sacc_beg(j),1);         end      end            v2_same = find( sign(seg_vel2)==pv_sign );      v2_diff = find(diff(v2_same)>1);      if ~isempty(v2_diff)         v2_same = v2_same(1:v2_diff(1));      end            v2_high = find( abs(seg_vel2)>=abs(vel_off) );      if isempty(v2_high)         v2_good = []; % bail         v_sacc_end(j) = NaN;      else         v2_good = intersect(v2_same,v2_high);         if isempty(v2_good)            v_sacc_end(j)=NaN;         else            v_sacc_end(j)=startpt(j)+v2_good(end)+localpeak;            v_sacc_end(j)=min(v_sacc_end(j),length(pos) );         end      end            good_mag=0; good_dir=0; sacc_mag_v(j)=NaN; nanflag=0;      if isnan(v_sacc_end(j)) || isnan(v_sacc_beg(j))         nanflag=1;      else         sacc_mag_v(j) = pos(v_sacc_end(j)) - pos(v_sacc_beg(j));         if sacc_dir==0            good_dir=1;         else            if sign(sacc_mag_v(j)) == sign(sacc_dir) %               good_dir = 1;            end         end         if abs(sacc_mag_v(j))>=range(1) && abs(sacc_mag_v(j))<=range(2)            good_mag = 1;         end      end   end %if isempty(localpeak)      % where does this belong? outside of both acc & vel detection? prob not.   % More likely following acc detect and vel detect? create a_dyno and v_dyno   %   % only include saccade if in desired direction, and magnitude range   % *OR* if it is direction/mag range for dynamic overshoot   % by comparing it to previous GOOD saccade.   %   %if j>1   %   look back to prev sacc, see if it is IMMEDIATELY before this one   %   if so, see if it meets criteria to be dynamic overshoot   %   if approp ampl, opposite dir AND time diff < x msec   %      . . .   %      'v_dyno = 1;'   %   end   %end         if nanflag==1 || isempty(v1_good) || isempty(v2_good) || ~good_mag || ~good_dir      %fprintf('No good acc pts, sacc# %d\r',j)      vgood=0;   else      vgood=1;   end      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   % choose to use accel and/or velocity on/off points.   % right now, "Use Both" start/stop pts are avg of vel- and acc- pts.   % should we simply automatically move in acc (or vel) s/s to compensate   % for spreading out due to d2pt? One pt per diff order?   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   det_v_or_a{j} = 'x';   ss_pts(j,:) = [NaN NaN];      % is it a good vel-derived saccade?   if vgood && use_vel      ss_pts(j,:) = [v_sacc_beg(j) v_sacc_end(j)];      det_v_or_a{j} = 'v';   else      % clear vel pts/values for this unloved saccade      %%%pk_vel(j) = NaN; % keep these as indicators      %%%pv_ind(j) = NaN; % keep these as indicators      %%%v_sacc_end(j) = NaN; % kill these?      %%%v_sacc_beg(j) = NaN; % kill these?   end      % is it a good acc-derived saccade?   if agood && use_accel      ss_pts(j,:) = [a_sacc_beg(j) a_sacc_end(j)];      det_v_or_a{j} = 'a';   else      % clear acc pts/values for this unloved saccade      %%%pacc(j)   = NaN; % keep these as indicators      %%%pa_ind(j) = NaN; % keep these as indicators      %%%a_sacc_end(j) = NaN; % kill these?      %%%a_sacc_beg(j) = NaN; % kill these?   end      % if it is good, and uses BOTH v&a, keep all derivation pts   % and use them to calculate the start/stop pts   % (Overwrites the ss_pts results from the above two cases)   if agood && vgood && use_accel && use_vel      ss_pts(j,:) = fix( ([v_sacc_beg(j) v_sacc_end(j)] + ...         [a_sacc_beg(j) a_sacc_end(j)] ) ./ 2);      det_v_or_a{j} = 'av';   end      % belt and suspenders. shouldn't be necessary.   if ~vgood && ~agood      ss_pts(j,:) = [NaN NaN];      det_v_or_a{j} = 'x';   end   end % for j%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Build final "sacc/no-sacc" points list, build output structure.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ptlist = ones(size(pos));[rows,~]=size(ss_pts);for m=1:rows   if any( isnan(ss_pts(m,:)) )      continue   else      ptlist(ss_pts(m,1):ss_pts(m,2))=0;   endendfoundsaccs.num     = rows;foundsaccs.ptlist  = ptlist;%foundsaccs.ptloose = qraw;foundsaccs.pvel    = pk_vel;foundsaccs.pv_ind  = pv_ind;foundsaccs.pacc    = pk_acc;foundsaccs.pa_ind  = pa_ind;foundsaccs.detcrit = det_v_or_a;foundsaccs.start   = ss_pts(:,1);foundsaccs.stop    = ss_pts(:,2);foundsaccs.v_start = v_sacc_beg;foundsaccs.v_stop  = v_sacc_end;foundsaccs.a_start = a_sacc_beg;foundsaccs.a_stop  = a_sacc_end;