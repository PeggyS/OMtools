% stimgen1.m: A primitive CLI program to generate stimuli used by the LabVIEW% acquisition/analog outpt VI.   STIMGEN1 prompts the user for the duration of% stimulus, and for breakpoint/amplitude values.% The sampling frequency is 100 Hz, a value that was set by acq_disp_AO.vi% therefore times can be specified only within 0.01 seconds.% Usage: stim = stimgen;  (use of an output variable is optional)%% NOTE: stimgen1 creates LINEAR segments.  Higher order fits%       (polynomial/exponential) might be considered at a later date.% Written by:  Jonathan Jacobs%              August 1998 - January 2009 (last mod: 01/30/09)% Modified by: King Yi%              4/25/2011 - Minor bug fixes in saving datafunction out = stimgen1()maxampl =  35;cycledur = 5;samptemp = input('What is the sampling frequency for the stimulus? <default=100 Hz> ');if isempty(samptemp), samptemp = 100; endt_or_s = ' ';while t_or_s(1) ~= 't' && t_or_s(1) ~= 's'	t_or_s = lower(input('Use (T)ime or (S)ample number? ','s'));	if t_or_s ~= 's'		tstr = 'seconds';		sampf = samptemp;	 else		tstr = 'samples';		sampf = 1;	endendbs = ' ';while bs(1) ~= 't' && bs(1) ~= 'd'	bs = lower(input('Define by Segment (D)uration or Breakpoint (T)ime? ','s'));enddisp(' ')amplvect = [];%figH = figure('pos', [800   500   560   420]); figure;box; grid; hold onplot([0 cycledur],[NaN NaN]);xlabel('Time (sec)')ylabel('Stimulus Amplitude (deg)')title('STIMGEN output')ampl = -10000;if( bs(1)=='d' )	disp(' ')	disp('You will be prompted to enter durations and amplitudes')	disp('for each segment of the stimulus.  The program will keep')	disp('accepting inputs until you enter a ''0'' to end.')	disp(' ')   segnum=1; running_dur=0; segbeg(1) = 1/sampf; 	%% 1st breakpoint is always 1/sampf      %% enter segment durations.  the breakpoint times will be calculated    temp_seg_dur = 1;   while (1)      temp_seg_dur = input(['Enter the duration of segment ' num2str(segnum) ' in ' tstr ': ']);      if temp_seg_dur <= 0      	cycledur = running_dur;      	amplvect = amplvect(1:cycledur*sampf);      	break      end	  running_dur = temp_seg_dur+running_dur;	  if running_dur > cycledur	  	cycledur = running_dur;	  	set(gca, 'xlim', [0 cycledur]);	  end      segend(segnum)   = segbeg(segnum)+temp_seg_dur - 1/sampf;      segbeg(segnum+1) = segbeg(segnum)+temp_seg_dur;      % segment start amplitude      ampl_beg(segnum) = -10000;      while abs(ampl_beg(segnum))>maxampl	      ampl_beg(segnum) = input(['Enter the amplitude for the start of the segment.'...	                ' (time T = ' num2str(segbeg(segnum)) ' ' tstr '): ']);      end      % segment end amplitude	   ampl_end(segnum) = -10000;	   while abs(ampl_end(segnum))>maxampl   	      ampl_end(segnum) = input(['Enter the amplitude for the end of the segment.'...	      			' (time T = ' num2str(segend(segnum)) ' ' tstr '): ']);	   end	   disp(' ')	   	   	   % make the segment.		ampldelta = ampl_end(segnum) - ampl_beg(segnum);        seglen = round(temp_seg_dur * sampf);		timevect = (1:seglen);		%generate a new segment if there is more than one point		if length(timevect)>1 			if ampldelta				%calculated segment				temp_amplvect = (ampl_beg(segnum):ampldelta/(length(timevect)-1):ampl_end(segnum));			  else				%constant segment				temp_amplvect = ampl_beg(segnum)*ones(size(timevect));			end			%% make sure the new segment is the right length			if length(temp_amplvect) ~= seglen				error('Error!!!!  Segment length error!!!')			end		 else			disp('seglen == 1');			keyboard			return			%amplvect(timevect)=ampl(ind+1);		end   		amplvect = [amplvect temp_amplvect];		% plot the segment        t=maket(amplvect,sampf);		plot(t,amplvect);				segnum=segnum+1;	end %%%% warning : this was not ever used regularly and was not updated to work %%%% like the segment duration code.  It will most likely break badly. elseif( bs(1)=='b' || bs(1)=='t')   disp('feature currently not implemented.')  %%%%%   return	disp(' ')	disp('You will be prompted to enter breakpoints and amplitudes')	disp('for each segment of the stimulus.  The program will keep')	disp('accepting inputs until you enter the breakpoint equal to')	disp('the duration of the stimulus.')	disp(' ')   ind = 1;   while abs(ampl(1))>maxampl      ampl(1) = input(['Enter the amplitude at time T = 0 ' tstr ': ']);   end   disp(' ')      bp = 0;   %% enter breakpoint times directly 	while (bp(ind) < cycledur)	   ind=ind+1;	   bp(ind)=-100000;	   while bp(ind) < bp(ind-1)	      temp = input(['Enter the time of breakpoint ' num2str(ind)...	                  ' in ' tstr ': ']);	      bp(ind) = fix(temp*sampf)/sampf; 	      if bp(ind) == bp(ind-1)	         disp('*** Same as previous breakpoint -- adjusting by one timestep. ***')	         bp(ind) = bp(ind)+ 1/sampf;	      end	   end	   ampl(ind) = -1000;	   while abs(ampl(ind))>maxampl   	      ampl(ind) = input(['Enter the amplitude at time T = '...	                        num2str(bp(ind)) ' ' tstr ': ']);	   end	   disp(' ')		ampldelta = ampl(ind) - ampl(ind-1);		timevect = (fix(bp(ind-1)*sampf)+1 : fix(bp(ind)*sampf));		%generate a new segment if there is more than one point		if length(timevect)>1 			if ampldelta				%calculated segment				amplvect(timevect) = ...						  (ampl(ind-1) : ampldelta/(length(timevect)-1) : ampl(ind) );			  else				%constant segment				amplvect(timevect) = ampl(ind-1)*ones(size(timevect));			end		 else			%disp('seglen == 1');			amplvect(timevect)=ampl(ind);		end   		tempLin1H = plot(timevect/sampf,amplvect(timevect))		if ind>2		   tempLin2H = line([bp(ind-2) bp(ind-1)], [ampl(ind-2) ampl(ind-1)])		end	end	[ampl; bp];end%% is this a 1-D or a 2-D stimulus?  If 2-D we need to specify which plane and the contents%% (if any) of the other plane.disp(' ')multidim = lower(input('Will this be part of a biplanar stimulus (y/n)? ', 's'));if strcmp(multidim,'y')   amplvect = loadcomponent(amplvect,samptemp);	    else  %% single dimension    ;end  % create and show multi-cycle stimulus% amplvect is a temp = [];numcycles = input('Enter the number of cycles for the TOTAL stimulus: ');if numcycles > 1	for k=1:numcycles	  temp  = [temp amplvect];	end	amplvect = temp;      	figure	t=maket(amplvect,sampf);	plot(t,amplvect)	xlabel(['Time (' tstr ')'])	ylabel('Stimulus Amplitude (deg)')	title('STIMGEN output')enddisp(' ')disp('If you are happy with this result, you can save it as an ASCII file.')disp('Otherwise, run "STIMGEN" again.')yorn=lower(input('Write this to file (y/n)? ','s'));initialpath = pwd;file = 0;if yorn=='y'   [file, path] = uiputfile('*.stm', 'Save As');endif file == 0   %disp('No file written.')   eval(['cd ' '''' initialpath ''''])   returnendif isempty(findstr(file, '.stm'))   file = [file '.stm'];endamplvect = amplvect';eval(['cd ' '''' path ''''])dlmwrite(file, amplvect, 'delimiter', '\t')%save( file,  'amplvect', '-ascii', '-tabs')%eval(['save ' file ' amplvect  -ascii -tabs'])disp(['"' file '" written to "' path '"'])eval(['cd ' '''' initialpath ''''])% if 'filetype.m' and 'filetype.mex' are present we will use 'emcomp=computer;if strcmp(comp,'MAC2') & exist('filetype.m') == 2 & exist('filetype.mex') == 3   [oldtype,oldcreator]=filetype(file,'TEXT','R*ch');endif nargout == 0   return else   out = amplvect;end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function  amplvect = loadcomponent(firstcomponent,samptemp)if ~exist('samptemp'), samptemp=100; end%% get the other component -- embedded in while loop -- keep trying until happy with selection%% main loop is terminated by a successful selection (one that meets all the criteria that%% are being tested by the inner loops).  inner loops are terminated by a break when successfulisSelected = 0;while ~isSelected 	isAscii = 0; 	while (~isAscii)	  [filename pathname] = uigetfile('*.*','Select a ''.stm'' file');	  if filename == 0		  secondcomponent = [];		  break;		else		  try			 secondcomponent = load(['' pathname filename '']);			 isAscii = 1;			catch			 display('You did not select an ASCII stimulus file. Try again.')		  end		end  	end  %%while isAscii					%% check dimensions of the loaded second component.  Must be only one dimensional.	%% it is easier to work with row-oriented data for now (1 sample/column) 	[r1,c1]=size(firstcomponent);	if c1<r1, firstcomponent=firstcomponent'; end	[r2,c2]=size(secondcomponent);	if c2<r2, secondcomponent=secondcomponent'; end	isOneDim = 0;	numchans = min(r2,c2);	if numchans <= 1, isOneDim = 1; end		while (isAscii & ~isOneDim)		t=maket(secondcomponent,samptemp);		colorlist = ['b', 'r', 'g', 'm', 'c'];		colorstrings = [{'(b)lue'}, {' (r)ed'}, {' (g)reen'}, {' (m)agenta'}, {' (c)yan'}];		colordef white		colorselectstr = '';		componentfigure = figure; hold on		for i = 1:numchans			plot(t,secondcomponent(i,:),colorlist(i) )			colorselectstr = [colorselectstr colorstrings{i}];		end		if min(r2,c2) > 1			%% if it is a multi-channel stim let user select one of the channels.			display(['This file has ' num2str(numchans) ' channels.'])			whichchan = lower(input(['Which channel do you want [' colorselectstr ']? '],'s'));			switch whichchan				case {'b','blue'}					chanindex=1;				case {'r','red'}					chanindex=2;				case {'g','green'}					chanindex=3;				case {'m','magenta'}					chanindex=4;				case {'c','cyan'}					chanindex=5;				otherwise					isOneDim=0;					break			end			isOneDim=1;			secondcomponent = secondcomponent(chanindex,:);		end			end %% while (isAscii & ~isOneDim)			%% is the loaded component the same length as the generated component?  if not, 	%% offer to trim/padone or the other, then display the two components together.	if length(firstcomponent) > length(secondcomponent)		display(['The loaded stimulus is shorter than the just-created one.'])		display(['I will pad it to the same length.'])		padlen = length(firstcomponent)-length(secondcomponent);		secondcomponent = [secondcomponent zeros(1,padlen)];	  elseif  length(firstcomponent) < length(secondcomponent)		display(['The loaded stimulus is longer than the just-created one.'])		display(['I will truncate it to the same length.'])		secondcomponent = secondcomponent(1:length(firstcomponent));	end	h_or_v = lower(input('Will the loaded stimulus be the (h)orizontal or the (v)ertical component? ' ,'s'));	if strcmp(h_or_v,'v')		amplvect = [firstcomponent' secondcomponent']';	  else		amplvect = [secondcomponent' firstcomponent']';	end   	%% amplvect is still samples along columns, one channel per row		%% is this what you wanted?	t=maket(secondcomponent,samptemp);	newfig=figure;	%figure(componentfigure)	subplot(2,1,1)	plot(t,amplvect(1,:))	ylabel('Hor. Stim.')	subplot(2,1,2)	plot(t,amplvect(2,:))	ylabel('Vrt. Stim.')	xlabel('Time')		happy = lower(input('Are you happy with this result (y/n)? ','s'));	if strcmp(happy, 'y')		;	 else		isAscii = 0;	end 	close(newfig)      	%close(componentfigure)      		%% reasons to exit the loop:  1) we've canceled file selection 	%% 								or 2) we've satisfied all requirements	if isempty(secondcomponent), break; end	isSelected = isAscii & isOneDim;end