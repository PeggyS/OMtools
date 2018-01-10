% readbias.m:% Read in the necessary adjustments for the data.% For coil data this is just one number, a bias shift.% For IR data there is a bias shift and max, min scale values.% ASCII, ASD & Raw Binary adjust files also contain the sampling frequency.% RTRV, LabVIEW & Ober2 data files already have this info in their header.% If there is a problem, an error flag, biasadj_err_flag is set to 1.% written by: Jonathan Jacobs%             November 1995 - August 2006  (last mod: 08/16/06)% 01/15/04 -- can now properly handle adjbias files with comments inside%  the adjustments block.function adjbiasvals = readbias(adj_fname,filename)adjbias_err_flag = 1;verbose=0;samp_freq = 0;doScaling = 1; %enviroG(3);disp( ['Loading adjustments from ' adj_fname] )if ~doScaling   disp('*** Scaling will NOT be applied ***')end% 'adj_fname' was determined in getbias.m.fid = fopen(adj_fname,'r');adjbiastext = fread(fid);adjbiastext = char(adjbiastext');fclose(fid);% find the filename we are looking for in the adjbias filewhereIsIt = strfind(lower(adjbiastext), deblank(lower(filename)));if isempty(whereIsIt)   disp( 'Couldn''t find this file in my list.' )   disp(['Open the bias file ' adj_fname])   disp(['and make sure that ' filename ' appears as one of the entries.'])   adjbias_err_flag = 1;   returnend% get the text FOLLOWING the desired filenameadjbiastext = adjbiastext(whereIsIt:length(adjbiastext));[topline, adjbiastext, isEmptyLine, isEOF] = getnextl(adjbiastext);[wordlist,numwords] = proclinec(topline);organization = '';chan_count = str2double( wordlist{2} );rectype    = lower( wordlist{3} );fileformat = lower( wordlist{4} );chName = []; adjbias = [];z_adj = []; max_adj = []; min_adj = []; max_cal_pt = []; min_cal_pt = [];% make sure that the adjbias file has the same number% of channels as we found when we read in the data file% this test is not valid for rawbin, so we cheatif strcmpi(fileformat,'rawbin') ||  strcmpi(fileformat,'binary')   dat_cols = chan_count;   %dat_len = numsamps/chan_count;endif exist('dat_cols','var')   if chan_count ~= dat_cols      disp(['Panic! The number of channels listed in bias file (' num2str(chan_count) ')' ])      disp(['does not match the number of channels read from the data (' num2str(dat_cols) ')!'])      disp('Aborting RD.')      return   endend% OK, I originally screwed up a bit when I wrote 'biasgen', and did not% put the sampling frequency in the best place.  I originally put it at% the end of EACH channel entry, rather than on the main line, along with% the number of channels, and recording type, etc.% Now 'biasgen' has been modified to do it right, and 'readbias' has been% modified to read either type of bias file.  (03/12/02)samp_flag = 0;switch (fileformat)   case {'rawbin','ascii','asyst','binary'}      if numwords >= 5         samp_freq = str2double(wordlist{5});         samp_flag = 1;         %disp( ['  Sampling frequency: ' num2str(samp_freq)] );         %disp( ['  Duration of record: ' num2str(dat_len/samp_freq) ' seconds'] );         adjbiasvals.samp_freq = samp_freq;      end      if numwords >= 6         organization = lower( wordlist{6} );      endend% initialize min_adj and max_adj arrays to NaNmincalpt = NaN(chan_count,10);maxcalpt = NaN(chan_count,10);min_adj =  NaN(chan_count,10);max_adj =  NaN(chan_count,10);maxnumcalpts = 0;% clear the arrays% c_scale= NaN(1,20); z_adj = NaN(1,20);% r_offset = NaN(1,20); r_scale = NaN(1,20); r_calpt = NaN(1,20);rectype = lower(rectype);for i = 1:chan_count   robflag = 0;   % ignore comment lines   goodline = 0;   while ~goodline      [topline, adjbiastext, ~, ~] = getnextl(adjbiastext);      temp=stripcom(topline);      if ~isempty(temp), goodline=1; end   end   [wordlist,numwords] = proclinec(topline);   chName{i} =  wordlist{1};      switch rectype(1)      case {'c', 's'} % coil (or 'scleral')         z_adj(i) = str2double( wordlist{2} );         disp( ['  Channel: ' chName{i} '     Bias: ' wordlist{2} ] )         c_scale(i) = 1;         if numwords >= 3  %% add check here for samp_flag in case of bad (old) adj hdr            c_scale(i) = str2double(wordlist{3});            disp( ['                  Scale: ' wordlist{3} ] )         end               case 'r' % robinson coil         disp( ['  Channel: ' biases.chName{i} '     Offset: ' wordlist{2} ] )         disp( ['                  Scale: '  wordlist{3}] )         disp( ['                  Cal Pt: ' wordlist{4}] )         robflag = 1;         r_offset(i) = str2double(wordlist{2});         r_scale(i)  = str2double(wordlist{3});         r_calpt(i)  = str2double(wordlist{4});               case {'i', 'v'}         % this applies to any method that needs asymmetric calibration         z_adj(i) = str2double(wordlist{2});         if verbose            disp( ['  Channel: ' chName{i} '     Offset: ' wordlist{2}] )         end         % how many calibration point pairs are there?         if numwords>5            % assuming equal number of leftward and rightward calibration pts.            % now that 'cal' has been modified, might not be valid assumption            % for time being, 'cal' will pad w/dummy entries if needed. (7/18/02)            numcalpts = fix((numwords-2)/4);            if numcalpts> maxnumcalpts, maxnumcalpts=numcalpts; end            for j = 1:numcalpts               maxcalptstr   = wordlist{2+j};               maxcalptstr   = maxcalptstr(find(isnumber(maxcalptstr)));               maxcalpt(i,j) = str2double(maxcalptstr);               maxadjstr     = wordlist{2+j+numcalpts};               max_adj(i,j)  = str2double(maxadjstr(find(isnumber(maxadjstr))));               if verbose                  disp( ['    Cal pt: ' maxcalptstr  ', scale value: ' maxadjstr])               end               mincalptstr   = wordlist{2+(2*numcalpts)+j};               mincalptstr   = mincalptstr(find(isnumber(mincalptstr)));               mincalpt(i,j) = str2double(mincalptstr);               minadjstr     = wordlist{2+(3*numcalpts)+j};               min_adj(i,j)  = str2double(minadjstr(find(isnumber(minadjstr))));               if verbose                  disp( ['    Cal pt: ' mincalptstr  ', scale value: ' minadjstr])               end            end         else            %numcalpts = 1;            %maxnumcalpts = 1;            maxadjstr    = wordlist{3};            max_adj(i,1) = str2double(maxadjstr);            maxcalpt(i,1) = 10;            minadjstr    = wordlist{4};            min_adj(i,1) = str2double(minadjstr);            mincalpt(i,1) = -10;            %disp( ['    Rightward scale value: ' maxadjstr])            %disp( ['    Leftward scale value: ' minadjstr])         end %%if numword   end  % switch rectype      % If this is an ASCII or binary file then we might need   % to read in the sampling freq (if it was not in the 'right' place.)   % (Retrieve, LabVIEW & Ober2 files store this info in their header.)   if ~samp_flag      switch lower(fileformat)         case {'ascii','asyst'}            sampfstr = wordlist(numwords,:);            samp_freq = str2double(sampfstr);            disp( ['  Sampling frequency: ' num2str(samp_freq)] );            %disp( ['  Duration of record: ' num2str(dat_len/samp_freq) ' seconds'] );         case {'rawbin','binary'}            % Not needed, since no RAWBIN files were created            % using the 'wrong' bias file format.      end   end %~if samp_flag   end % for imaxcalpt = maxcalpt(1:chan_count,1:maxnumcalpts);mincalpt = mincalpt(1:chan_count,1:maxnumcalpts);max_adj = max_adj(1:chan_count,1:maxnumcalpts);min_adj = min_adj(1:chan_count,1:maxnumcalpts);z_adj = z_adj';         % make into (numcalpt cols) x (chan_count rows)%max_adj = max_adj;%min_adj = min_adj;adjbias_err_flag = 0;% crufty hack time: if we want to disable scaling (i.e. 'doScaling')% has been disabled in 'enviro', simply make the adjust values 0 & 1if ~doScaling || robflag   z_adj   = zeros(size(z_adj));   max_adj = ones(size(max_adj));   min_adj = ones(size(min_adj));endadjbiasvals.samp_freq = samp_freq;adjbiasvals.chName = chName;adjbiasvals.rectype=rectype;adjbiasvals.organization=organization;adjbiasvals.z_adj = z_adj;adjbiasvals.max_adj = max_adj;adjbiasvals.min_adj = min_adj;adjbiasvals.maxcalpt = maxcalpt;adjbiasvals.mincalpt = mincalpt;return