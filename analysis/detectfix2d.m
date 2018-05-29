% detectfix2d.m: find fixation periods for 2D eye data.% Usage: fixations = detectfix(emData,whicheye)% Where 'emData' is the OMtools eye-movement data structure.% 'fixation' is a structure with fields: numfix, fixpts, misspts, fixdur%   velLim is the max allowed retinal slip velocity (default 4�/sec,for stable percept%   fixpts is the set of all sample indices that meet the velocity criterion%   misspts are the indices that DON'T meet the velocity criterion%% For 2-D data, calculations will be performed using the radial value of% the horizontal and vertical data: sqrt(hor^2 + vert^2)% This will be a lot more flexible with a GUI to allow selection of% eye(s)/plane(s), slip velocity limit.% Written by:  Jonathan Jacobs%              January 2017 (last mod: 01/25/17)function fixations = detectfix2d(emData,whicheye,velLim)%function [numfix,fixptslist, missptslist, fpLen] = detectfix2d(emData,whicheye,velLim)whicheye = lower(whicheye);if isempty(whicheye)   whicheye = 'rl';endif isempty(velLim), velLim=4; endnumsamps = emData.numsamps;if numsamps==0, disp('No data found in this record!');return;endsamp_freq = emData.samp_freq;if samp_freq==0, disp('No sampling rate found in this record!');return;endrh = emData..pos; if isempty(rh), rh=NaN(numsamps,1); endrv = emData.rv.pos; if isempty(rv), rv=NaN(numsamps,1); endrh_good = length(find(~isnan(rh)))/numsamps;rv_good = length(find(~isnan(rv)))/numsamps;re_good = length( find(~isnan(rh) & ~isnan(rv)) )/numsamps;lh = emData.lh.pos; if isempty(lh), lh=NaN(numsamps,1); endlv = emData.lv.pos; if isempty(lv), lv=NaN(numsamps,1); endlh_good = length(find(~isnan(lh)))/datalen;lv_good = length(find(~isnan(lv)))/datalen;le_good = length( find(~isnan(lh) & ~isnan(lv)) )/datalen;if strfind(whicheye,'r')   if re_good < 0.75      disp(['WARNING: only' num2str(100*re_good) '% of rh and rv combined are non-NaN data.'])      disp([' rh: ' num2str(100*rh_good) '%, rv: ' num2str(100*rv_good) '%.'])      disp('(P)roceed anyway, use (H)or data only, use (V)ert data only, or (C)ancel?')      choice = '';      while ~strfind('phvc',choice)         choice = lower(input('-->','s'));      end      switch choice         case 'c'            re = [];         case 'h'            re = rh;         case 'v'            re = rv;         otherwise            re = sqrt(rh.^2 + rv.^2);      end %switch   else      re = sqrt(rh.^2 + rv.^2);   end %if re_goodendif strfind(whicheye,'l')   if le_good < 0.75      disp(['WARNING: only' num2str(100*le_good) '% of lh and lv combined are non-NaN data.'])      disp([' lh: ' num2str(100*lh_good) '%, lv: ' num2str(100*lv_good) '%.'])      disp('(P)roceed anyway, use (H)or data only, use (V)ert data only, or (C)ancel?')      choice = '';      while ~strfind('phvc',choice)         choice = lower(input('-->','s'));      end      switch choice         case 'c'            le = [];         case 'h'            le = lh;         case 'v'            le = lv;         otherwise            le = sqrt(lh.^2 + lv.^2);      end %switch   else      le = sqrt(lh.^2 + lv.^2);   end %if le_goodendif isempty(re)   % do nothingelse   fixations{1} = detectfixcalc(re,samp_freq,velLim);endif isempty(le)   % do nothingelse   fixations{2} = detectfixcalc(le,samp_freq,velLim);endreturn%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function [fixations] = detectfixcalc(posdata,velLim)%function [numfix,fixptslist, missptslist, fpLen] = detectfixcalc(posdata,velLim)% heavily borrowed from detectfovs.m% sacVelVal = 50;       % lower vel. limit for saccade blanking% sacAccVal = 2000;     % lower accel. limit for saccade blankingsacJerkVal = 100000;    % lower jerk limit for saccade blankinggapDur = 35;            % it's a gap if greater than this duration (in msec)minFovDur = 7;          % it's a fix if greater than this duration (in msec)if isempty(velLim), velLim = 4; endvelLim = abs(velLim);% To be correct, we need n+1 sample points to properly represent a segment, i.e., adding% a terminus point.  For example, if the sample rate is 1000 Hz, the ISI is 1 msec, sofencepost = 0;                          % for low sample rates we will be more forgivingif samp_freq >= 250, fencepost = 1; end % for high sample rates we will be more exacting% we use jerk (4th derivative) to determine is a saccade is occurring.veldata  = d2pt(posdata,3,samp_freq);accdata  = d2pt(veldata,3,samp_freq);jerkdata = d2pt(accdata,3,samp_freq);gapSamp    = ceil(samp_freq/1000 * gapDur) + fencepost;minFovSamp = ceil(samp_freq/1000 * minFovDur) + fencepost;% we do not have a priori knowledge of where the subject's eyes are aimed% so we will only use velocity slip (4 deg/sec) to decide when gaze is held.rawfix = find( abs(veldata) <= velLim );% initially hit pts are the raw results (meet vel crit)% using this raw info we will create two arrays:%  -- "hits" array:   "1" = fov win pt%  -- "misses" array: "1" = non-fov win ptlastpt = rawfix(end);aa = zeros(lastpt,1);aa(rawfix) = 1;%bb = ones(lastpt,1);%aa(rawfix) = bb(rawfix);hits = aa;% Our approach is pretty simple:% first we FILL in any gaps shorter than the gap duration that appear% between "good" points (points that meet the pos/vel criteria)...% gapArray will contain the starting points of all the gaps% longer than gapSamp samples ( = gapDur msec)a = [rawfix' rawfix(end)]';b = [0 rawfix']';diffArray = a-b;gapArray = find( (diffArray<gapSamp) & (diffArray>1) );if isempty(gapArray) % no little guys to FILL   disp([' No gaps needed to be filled (' num2str(gapDur) ' msec)'])else   gapArray = gapArray - 1;   % to mark the BEGINNING of the gap, not the end   if gapArray(1) == 0      gapArray = gapArray(2:end); % strip the leading zero   end   % walk along diffIndex, filling in the gaps   startPt = NaN*ones(size(gapArray));   endPt   = NaN*ones(size(gapArray));   lenFill = NaN*ones(size(gapArray));   for i = 1:length(gapArray)      % if we have a short enough gap we will fill in the "missing" pts,      % remembering that we can't fill in times during a saccade.      % (and a saccade can't be less than 3 samples +2 for beg&end)      startPt(i) = rawfix(gapArray(i));      endPt(i)   = rawfix(gapArray(i)+1);      lenFill(i) = endPt(i)-startPt(i)+1;      %isSac=0;      %isSac     = any(accIn(startPt(i):endPt(i))>=sacAccVal);      isSac      = any( abs(jerkdata(startPt(i):endPt(i)))>=sacJerkVal );      if ~isSac || lenFill(i) <= 5         hits(startPt(i):endPt(i)) = ones(lenFill(i),1);      end   endend% KILL all "good" segments that are too short.% segArray will contain the starting points of all the segments% shorter than minFixSamp samples (i.e. minFixDur msec)misses = find(hits==0);if isempty(misses), misses=1; enda = [misses' misses(end)]';b = [0 misses']';diffArray2 = a-b;segArray   = find( diffArray2>1 & diffArray2<=minFovSamp );if isempty(segArray)   % no little guys to KILL   disp([' No segments need to be removed (under ' num2str(minFovDur) ' msec)'])else   segArray = segArray - 1;          % to mark the BEGINNING of the segment   if segArray(1) == 0      segArray = segArray(2:end); % strip the leading zero   end   % walk along diffIndex2, killing the short segments   startPt2 = NaN*ones(size(segArray));   endPt2 = NaN*ones(size(segArray));   lenKill = NaN*ones(size(segArray));   for i = 1:length(segArray)      % if we have a too-short segment we will kill those pts      startPt2(i) = misses(segArray(i));      endPt2(i)   = misses(segArray(i)+1);      lenKill(i)  = endPt2(i)-startPt2(i)+1;      hits( startPt2(i):endPt2(i) ) = zeros(lenKill(i),1);   endend% Finally, we count the number of event clusters that are left.% These are (hopefully) our fixation periods.hits(1)=0; hits(2)=0;hits(length(hits))=0;fpStart=NaN(); fpStop=NaN();count=0;for i=2:length(hits)   if hits(i)~=hits(i-1)      if hits(i)==1             % found a beginning         count=count+1;         fpStart(count) = i;      else                      % found an ending         fpStop(count)  = i-1;      end   endendfixations.numfix=count;fixations.fixpts  = find(hits==1);fixations.misspts = find(hits==0);fixations.fixdur = fpStop-fpStart;fixations.help = 'I will become an explanation string some day!';return