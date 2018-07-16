% findsaccs.m: Take positional input data and return a list of points indicating% samples where saccades are occuring. ('1' = 'good' data; '0' = saccade.)% Called by 'desacc.m,' although it can be called manually.% foundsaccs = findsaccs(pos, acc_on, vel_on, acc_off, vel_off, ...%                        gap_fp, gap_sp, vel_or_acc, extend, range, direction)% inputs:%    in: position data te be analyzed%    acc_on:  acc threshold for detection%    vel_on:  vel threshold for detection%    acc_off: acc threshold for detection%    vel_off: vel threshold for detection%    gap_fp:  max # allowable sub-threshold pts in a fast-phase segment%    gap_sp:  max # allowable supra-threshold pts in a slow-phase segment%    vel_or_acc: choose velocity or accel criterion for detection%    extend: (((this might get removed)))%    range:     [lo, hi] Include only saccades in this range (dflt [0 40])%    direction: 'l', 'r' or 'b' Include only saccades in this direction.%% output: struct with these fields:%    num    : number of saccades found in given data segment%    ptlist : map of segment: saccade==0, non-saccade==1%    pvel   : list of peak velocities%    pv_ind : sample numbers of peak velocities%    detcrit: criteria (vel and/or acc) used to detect saccade%    v_sacc_beg, v_sacc_end : saccade begin/end (using vel criteria)%    a_sacc_beg, a_sacc_end : saccade begin/end (using acc criteria)%    start, stop            : saccade begin/end (final selection)% written by:  Jonathan Jacobs%              September 2003 - April 2018 (last mod: 04/08/18)% complete overhaul, March 2018function foundsaccs = findsaccs(pos, acc_on, vel_on, acc_off, vel_off, ...   gap_fp, gap_sp, vel_or_acc, extend, range, direction)if nargin==0   findsaccs_gui;   returnend% DEFAULT VALUES (also provided via GUI)if ~exist('acc_on','var'),  acc_on = 800; endif ~exist('acc_off','var'), acc_off = 100; endif ~exist('vel_on','var'),  vel_on = 20; endif ~exist('vel_off','var'), vel_off = 10; endif ~exist('gap_fp','var'),  gap_fp = 10; endif ~exist('gap_sp','var'),  gap_sp = 10; endif ~exist('vel_or_acc','var'), vel_or_acc = 'b'; endif ~exist('extend','var')|| isempty(extend), extend = 0; end %#ok<NASGU>if ~exist('range','var') || isempty(range),  range = [-40 40]; endif ~exist('direction','var') || isempty(direction),direction = 'b'; enddiff_level = 5;vel = d2pt(pos, diff_level);acc = d2pt(vel, diff_level);switch lower(direction(1))   case 'l'      sacc_dir = -1;   case 'r'      sacc_dir = 1;   case 'b'      sacc_dir = 0;   otherwiseend% find the points that exceed either acc or vel thresholdv_or_a = vel_or_acc(1);switch v_or_a   case {'A','a',1}      saccpts = find(abs(acc) >= acc_on);      misspts = find(abs(acc) < acc_on);      use_accel=1;      use_vel = 0;   case {'V','v',2}      saccpts = find(abs(vel) >= vel_on);      misspts = find(abs(vel) < vel_on);      use_vel=1;      use_accel=0;   case {'B','b',3} % BOTH      saccpts = find(abs(acc) >= acc_on | abs(vel) >= vel_on);      misspts = find(abs(acc) < acc_on & abs(vel) < vel_on);      use_accel=1;      use_vel=1;   otherwise      disp(['bad parameter: ''vel_or_acc'': ' vel_or_acc])      foundsaccs.num=0;      returnendif isempty(saccpts)   disp('findsaccs: no points exceed the given thresholds.')   foundsaccs.num=0;   returnend% Work 'inside-out' from the center of sacc vel to find beginning and end points.% Remember that the acceleration of a saccade has TWO humps: do for pos and for neg%%% Blink is even uglier: may have period of zero (eye closed) surrounded by big values%%% (close eye and then open eye). Also use pos record for blink detection% qraw is the list of points in the raw data that meet vel and/or acc crit.q = ones(size(pos));q(saccpts) = 0;qraw = q;% The raw 'hit' and 'miss' lists may have gaps where a few points dropped below% (or rose above) the threshold in an otherwise 'pure' run. We want to plug those% little gaps. Refine by marking intra-saccade (NOT inter-) gaps as bad:% an intra-saccade gap will have ~<10 points?% A gap greater than 20(?) marks beginning of next saccade% first, determine connectedness/locate gaps in the listsaccgaps    = diff(saccpts);saccgaplist = find(saccgaps>1 & saccgaps<=gap_fp);slowgaps    = diff(misspts);slowgaplist = find(slowgaps>1 & slowgaps<=gap_sp);%h1 = [saccpts(1) saccpts'];%h2 = [saccpts'   saccpts(end)];%temp = h2 - h1;%h3 = temp(2:end);%saccgaplist2  = find(h3>1 & h3<=gap_fp);%m1 = [misspts(1) misspts'];%m2 = [misspts'   misspts(end)];%temp = m2 - m1;%m3 = temp(2:end);%slowgaplist  = find(m3>1 & m3<=gap_sp);for i = 1:length(saccgaplist)   startplug = saccpts(saccgaplist(i));   pluglen   = saccgaps(saccgaplist(i));   q(startplug:startplug+pluglen-1) = 0;endfor i = 1:length(slowgaplist)   startplug = misspts(slowgaplist(i));   pluglen   = slowgaps(slowgaplist(i));   q(startplug:startplug+pluglen-1) = 1;end% all plugged and polished.% look for the point when val is back to zero (or just beyond)% q1 = [q' 0];% q2 = [0 q'];% temp = q1-q2;% q3 = temp(2:end-1); % 1st and last peaks are artifacts%if debug_mode, plot(q3*1.1*acc_on,'r'); if kb_on, keyboard; end; end% segstart = find(q3 == -1);% segstop  = find(q3 ==  1);segstart = find(diff(q) == -1); % ALWAYS -1, regardless of dir of saccadesegstop  = find(diff(q) ==  1);if isempty(segstart)   disp('Error! no segstart. Type "continue" to exit.');   keyboard;   foundsaccs.num=0;   returnendif isempty(segstop)   disp('Error! no segstop. Type "continue" to exit.');   keyboard;   foundsaccs.num=0;   returnend% 1) make sure that we are really starting with an ONSET% 2) make sure that we are really ending with an OFFSETif segstart(1)>segstop(1)   % there is NO "1st" saccade. trim the 1st segstop since it is unpaired   segstop = segstop(2:end);   disp('FYI: deleted unpaired initial segstop. No big deal.')endif segstart(end)>segstop(end)   % trim the last segstart since it is unpaired   segstart = segstart(1:end-1);   disp('FYI: deleted unpaired terminal segstart. No big deal.')endif length(segstart) ~= length(segstop)   disp('findsaccs: ERROR! -- length(segstart) ~= length(segstop)')   returnend% Now for a bit of refinement. So far, we've been working with segments% that may contain only part of a saccade. Let's try to identify the ACTUAL% saccadic onsets and offsets by examining points beyond the segment to look% for when the acceleration (and perhaps velocity?) drops below a set thresh.% Where accel falls below a given threshold (e.g. 100deg/s^2) that's (almost)% the end point. "Almost? Why not exactly?" you cry. Because the accel has spread in time% due to differentiation, we need to adjust the crossing points inward slightly.% about five points should do it. should this be hard coded, or left to user's% preference with "extend" field in 'desacc'?% start_pt_acc = start_pt_acc + 2;  %% <---- this is the band-aid line mentioned above% stop_pt_acc  = stop_pt_acc  - 3;  %% <---- this is the band-aid line mentioned abovess=size(segstart);startpt=NaN(ss);a_sacc_beg=NaN(ss); a_sacc_end=NaN(ss);v_sacc_beg=NaN(ss); v_sacc_end=NaN(ss);offset=NaN(ss);n_ind=NaN(ss);  p_ind=NaN(ss);pacc_p=NaN(ss); pacc_n=NaN(ss);pvel = NaN(ss); pv_ind = NaN(ss);ss_pts = NaN(ss(1),2);lookback=20;for j = 1:length(segstart)      % look backwards up to ~20 samples (should be long enough for sacc)   % but don't look beyond the beginning of the data array   startpt(j) = max(segstart(j)-lookback+1,1);   segpts  = startpt(j):segstop(j);   seg_vel = vel(segpts);   seg_acc = acc(segpts);      vbad=1;abad=1;   if use_accel      p_ind(j) = find(seg_acc==max(seg_acc), 1);      pacc_p(j) = seg_acc(p_ind(j));      p_sign = sign(pacc_p(j));            n_ind(j) = find(seg_acc==min(seg_acc), 1);      pacc_n(j) = seg_acc(n_ind(j));      n_sign = sign(pacc_n(j));            if p_ind(j)<n_ind(j)         seg_acc1 = seg_acc(1:p_ind(j));         seg_acc2 = seg_acc(p_ind(j)+1:end);         a1_sign = p_sign;         a2_sign = n_sign;         offset(j)  = p_ind(j);      else         seg_acc1 = seg_acc(1:n_ind(j));         seg_acc2 = seg_acc(n_ind(j)+1:end);         a1_sign = n_sign;         a2_sign = p_sign;         offset(j) = n_ind(j);      end            % first accel hump - only care about data BEFORE peak accel      a1_same = find( sign(seg_acc1)==a1_sign );      a1_diff = find(diff(a1_same)>1);      if ~isempty(a1_diff)         a1_same = a1_same( a1_diff(1)+1 :end );      end      a1_high = find( (a1_sign*seg_acc1)>=acc_on );      if isempty(a1_high)         a_sacc_beg(j) = NaN; % bail         a1_good = [];      else         a1_good = intersect(a1_same,a1_high);         a_sacc_beg(j)=startpt(j)+a1_good(1);      end            % second accel hump - only care about data AFTER peak accel      a2_same = find( sign(seg_acc2)==a2_sign );      a2_diff = find(diff(a2_same)>1);      if ~isempty(a2_diff)         a2_same = a2_same(1:a2_diff(1));      end      a2_high = find( (a2_sign*seg_acc2)>=acc_off );      if isempty(a2_high)         a_sacc_end(j) = NaN; % bail         a2_good=[];      else         a2_good = intersect(a2_same,a2_high);         if isempty(a2_good),a2_good=NaN;end   %%%%%%%%%%% TEMP?         a_sacc_end(j)=startpt(j)+offset(j)+a2_good(end);      end            % only include saccade if in desired direction, and magnitude range      good_dir=0; sacc_mag_a=NaN;      if ~isnan(a_sacc_end(j)) && ~isnan(a_sacc_beg(j))         sacc_mag_a = pos(a_sacc_end(j)) - pos(a_sacc_beg(j));         if sacc_dir==0            good_dir=1;         else            if sign(sacc_mag_a)==sign(sacc_dir) %               good_dir = 1;            end         end      end      good_mag=0;      if abs(sacc_mag_a)>=range(1) && abs(sacc_mag_a)<=(range(2))         good_mag = 1;      end            if isempty(a1_good) || isempty(a2_good) && ~good_mag && ~good_dir         %fprintf('No good acc pts, sacc# %d\r',j)         abad=1;      else         abad=0;      end   end %if use_accel         if use_vel      temp = max(abs(seg_vel));      localpeak = find(abs(seg_vel)==temp,1);      pvel(j) = seg_vel(localpeak);      pv_sign = sign(pvel(j));      pv_ind(j) = localpeak+startpt(j)-1;      % split segments at the peak vel pt.      seg_vel1 = seg_vel(1:localpeak);      seg_vel2 = seg_vel(localpeak+1:end);            v1_same = find( sign(seg_vel1)==pv_sign );      v1_diff = find(diff(v1_same)>1);      if ~isempty(v1_diff)         v1_same = v1_same(v1_diff(end)+1:end);      end      v1_high = find( abs(seg_vel1)>=vel_on );      if isempty(v1_high)         v1_good = []; % bail         v_sacc_beg(j) = NaN;      else         v1_good = intersect(v1_same,v1_high);         if isempty(v1_good), v1_good=0; end   %%%%%%%% IS "0" correct???         v_sacc_beg(j)=startpt(j)+v1_good(1)-1;      end            v2_same = find( sign(seg_vel2)==pv_sign );      v2_diff = find(diff(v2_same)>1);      if ~isempty(v2_diff)         v2_same = v2_same(1:v2_diff(1));      end            v2_high = find( abs(seg_vel2)>=vel_off );      if isempty(v2_high)         v2_good = []; % bail         v_sacc_end(j) = NaN;      else         v2_good = intersect(v2_same,v2_high);         if isempty(v2_good), v2_good=0; end   %%%%%%%% IS "0" correct???         v_sacc_end(j)=startpt(j)+v2_good(end)+localpeak;      end            % only include saccade if in desired direction, and magnitude range      good_mag=0; good_dir=0; sacc_mag_v=NaN;      if ~isnan(v_sacc_end(j)) && ~isnan(v_sacc_beg(j))         sacc_mag_v(j) = pos(v_sacc_end(j)) - pos(v_sacc_beg(j));         if sacc_dir==0            good_dir=1;         else            if sign(sacc_mag_v(j)) == sign(sacc_dir) %               good_dir = 1;            end         end         if abs(sacc_mag_v(j))>=range(1) && abs(sacc_mag_v(j))<=range(2)            good_mag = 1;         end      end            if isempty(v1_good) || isempty(v2_good) || ~good_mag || ~good_dir         %fprintf('No good acc pts, sacc# %d\r',j)         vbad=1;      else         vbad=0;      end   end %if use_vel      % choose to use accel and/or velocity on/off points   % right now, the "Use Both" start/stop pts are average of vel- and acc- pts   % should we simply automatically move in acc (or vel) s/s to compensate   % for spreading out due to d2pt? One pt per diff order?   v_or_a{j} = 'x';   ss_pts(j,:) = [NaN NaN];      if vbad      if use_accel         ss_pts(j,:) = [a_sacc_beg(j) a_sacc_end(j)];         v_or_a{j} = 'a';      else         abad=1;      end   end   if abad      if use_vel         ss_pts(j,:) = [v_sacc_beg(j) v_sacc_end(j)];         v_or_a{j} = 'v';      else         vbad=1;      end   end   if vbad && abad      ss_pts(j,:) = [NaN NaN];      v_or_a{j} = 'x';   end   if ~abad && ~vbad      ss_pts(j,:) = fix( ([v_sacc_beg(j) v_sacc_end(j)] + ...         [a_sacc_beg(j) a_sacc_end(j)] ) ./ 2);      v_or_a{j} = 'av';   end   end % for j% build final "sacc/no-sacc" points listptlist = ones(size(pos));[rows,~]=size(ss_pts);for m=1:rows   if any( isnan(ss_pts(m,:)) )      continue   else      ptlist(ss_pts(m,1):ss_pts(m,2))=0;   endendfoundsaccs.num     = rows;foundsaccs.ptlist  = ptlist;foundsaccs.ptloose = qraw;foundsaccs.pvel    = pvel;foundsaccs.pv_ind  = pv_ind;foundsaccs.detcrit = v_or_a;foundsaccs.start   = ss_pts(:,1);foundsaccs.stop    = ss_pts(:,2);foundsaccs.v_sacc_beg = v_sacc_beg;foundsaccs.v_sacc_end = v_sacc_end;foundsaccs.a_sacc_beg = a_sacc_beg;foundsaccs.a_sacc_end = a_sacc_end;