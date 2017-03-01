% detectfovs.m: find foveation periods given a list of points that meet the % foveation criteria.% Usage:   [numfov, fovlist] = detectfovs(in, posIn, suppress)% Where:  'in' is the raw foveation points list%         'posIn' is the position array% Written by:  Jonathan Jacobs%              March 1998 - January 2002 (last mod: 01/14/02)function [numfov,fovlist,DFvers] = detectfovs(in,posIn,suppress,funct,fovstats)global samp_freq what_f_array NAFshowOutput fovStatNAFXHDFvers = '1.0';if nargin == 1   suppress = 0;endcomp = computer;vers = version;if vers(1) >= '6'   degstr = '\circ';   pmstr  = '\pm'; else   if comp(1) == 'M'     degstr = '�';     pmstr = '�';   else     degstr = ' deg';     dpmtr = '+/-';   endend [r,c]=size(in);sacVelVal = 50;       % lower vel. limit for saccade blankingsacAccVal = 2000;     % lower accel. limit for saccade blankingsacJerkVal = 100000;  % lower jerk limit for saccade blankinggapDur = 35;          % a gap is greater than this value (in msec)minFovDur = 7;        % min duration considered to be a fov segment(in msec)% To be correct, we need n+1 sample points to properly represent a segment, i.e., adding% a terminus point.  For example, if the sample rate is 1000 Hz, the ISI is 1 msec, so% if samp_freq >= 250   fencepost = 1;     % for high sample rates we will be more exacting else   fencepost = 0;     % for low sample rates we will be more forgivingend% we use jerk (4th derivative) to determine is a saccade is occurring.velIn  = d2pt(posIn,3,samp_freq);accIn  = d2pt(velIn,3,samp_freq);jerkIn = d2pt(accIn,3,samp_freq);gapSamp    = ceil(samp_freq/1000 * gapDur) + fencepost;	    minFovSamp = ceil(samp_freq/1000 * minFovDur) + fencepost;	% initially hit pts are the raw results from nff (meet pos/vel crit)% using this raw info we will create two arrays:%  -- a "hits" array:   "1" = fov win pt%  -- a "misses" array: "1" = non-fov win ptlastpt = in(length(in));aa = zeros(lastpt,1);bb = ones(lastpt,1);aa(in) = bb(in);hits = aa;% Our approach is pretty simple:% first we FILL in any gaps shorter than the gap duration that appear % between "good" points (points that meet the pos/vel criteria)...% gapArray will contain the starting points of all the gaps% longer than gapSamp samples ( = gapDur msec)a = [in' in(length(in))]';b = [0 in']';diffArray = a-b;gapArray = find( (diffArray<gapSamp) & (diffArray>1) );if isempty(gapArray)   % no little guys to FILL   if ~suppress      disp([' >> There were NO gaps shorter than ' num2str(gapDur) ' msec'])      end else   gapArray = gapArray - 1;   % to mark the BEGINNING of the gap, not the end   if gapArray(1) == 0      gapArray = gapArray(2:length(gapArray)); % strip the leading zero   end      % walk along diffIndex, filling in the gaps   for i = 1:length(gapArray)      % if we have a short enough gap we will fill in the "missing" pts,      % remembering that we can't fill in times during a saccade.      % (and a saccade can't be less than 3 samples +2 for beg&end)      startPt(i) = in(gapArray(i));      endPt(i)   = in(gapArray(i)+1);      lenFill(i) = (endPt(i)-startPt(i))+1;      %isSac=0;      %isSac      = any(accIn(startPt(i):endPt(i))>=sacAccVal);      isSac      = any(abs(jerkIn(startPt(i):endPt(i)))>=sacJerkVal);      if ~isSac | lenFill(i) <= 5         hits(startPt(i):endPt(i))=( ones(lenFill(i),1) );      end   endend% ... and next we KILL all "good" segments that are too short...% segArray will contain the starting points of all the segments% shorter than minFovSamp samples ( = minFovDur msec)misses = find(hits==0);if isempty(misses)   misses=1;endaa2 = zeros(lastpt,1);bb2 = ones(lastpt,1);aa2(misses) = bb(misses);a = [misses' misses(length(misses))]';b = [0 misses']';diffArray2 = a-b;segArray = find( (diffArray2>1) & (diffArray2<=minFovSamp) );if isempty(segArray)   % no little guys to KILL   if ~suppress       disp([' >> There were NO segments shorter than '...                   num2str(minFovDur) ' msec'])   end else      segArray = segArray - 1;          % to mark the BEGINNING of the segment   if segArray(1) == 0      segArray = segArray(2:length(segArray)); % strip the leading zero   end      % walk along diffIndex2, killing the short segments   for i = 1:length(segArray)      % if we have a too-short segment we will kill those pts      startPt2(i) = misses(segArray(i));      endPt2(i)   = misses(segArray(i)+1);      lenKill(i)  = (endPt2(i)-startPt2(i))+1;      hits(startPt2(i):endPt2(i))=zeros(lenKill(i),1);   endend% ... and finally, we count the number of event clusters that are left.% These are (hopefully) our foveation periods.hits(1)=0; hits(2)=0;hits(length(hits))=0;i=2;count=0;for i=2:length(hits)   if hits(i)~=hits(i-1)      if hits(i)==1             % a beginning         count=count+1;         fpStart(count) = i;        else                    % an ending         fpStop(count)  = i-1;      end   endendnumfov=count;fovlist = find(hits==1);% Do you display foveation statistics?  First we look for the GUI's checkbox.% If the GUI isn't open, use the value that was passed from nafx.myn=' ';if strcmp(funct(1), 's')   if ~isempty(fovStatNAFXH)      yn=get(fovStatNAFXH,'value');    else      %yn=lower(input('% Display foveation statistics (y/n)? ','s'));      yn = fovstats;   endendif NAFshowOutput & (yn == 1 | yn == 'y')	figure	subplot(2,1,1)	fpLen = fpStop-fpStart;	fpDur = fpLen/samp_freq(1)*1000; % foveation periods in sec	%make bins that are ''binwid'' ms wide.	binwid=5;	lowend = 5*fix(min(fpDur)/binwid);	hiend  = 5*fix(max(fpDur)/binwid);	binlist = lowend:binwid:hiend;    if length(binlist)>1  	   hist(fpDur,binlist)     else       hist(fpDur)    end	ylabel('Number of foveations')	xlabel('Foveation Duration (msec)')	title(['File: ' nameclean(what_f_array) '  Distribution of Foveation Durations'])	subplot(2,1,2)	for i=1:length(fpLen)	   fpAvg(i) = mean(posIn(fpStart(i):fpStop(i)));	end	%make bins that are ''binwid'' deg wide. 	range=ceil(max(fpAvg)-min(fpAvg))+1;	binwid=0.05*range;	lowend = binwid*fix(min(fpAvg)/binwid);	hiend  = binwid*fix(max(fpAvg)/binwid);	binlist = lowend:binwid:hiend;	if length(binlist)>1       hist(fpAvg,binlist)     else       hist(fpAvg)      end    ylabel('Number of foveations')	xlabel(['Average Foveation Position (' degstr ')'])	title(['File: ' nameclean(what_f_array) '  Distribution of Average Foveation Positions'])	disp(' ')	for i=1:length(fpLen)	   disp(['    Foveation #' num2str(i)...	         ': duration ' num2str(fpDur(i)) ' msec,'...	         '   Avg pos ' num2str(fpAvg(i)) ' deg'])	end	disp(' ')end % (if NAFshowOutput)%keyboardreturn