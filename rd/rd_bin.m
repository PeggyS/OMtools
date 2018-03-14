% rd_bin.m:    called by RD to handle .bin data files that have%              NO header information% written by:  Jonathan Jacobs%              March 1997 - February 2004 (last mod: 02/25/04)% 01/30/03: added line "clear newdata" to guarantee ability to load%           multiple datasets%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function newdata = rd_bin( [pathname filename] )% open the bin filecomp=computer;if comp(1) == 'M'   fidBIN = fopen( [pathname filename], 'r', 'n');else   fidBIN = fopen( [pathname filename], 'r' );endcomments=''; % read in the datafseek(fidBIN, 0, 'bof');[tempdata, numsamps] = fread(fidBIN,inf,'float');fclose(fidBIN);% Get number of channels from bias file% use the info to separate the raw binary stream into calibrated channelsgetbias % calls readbias', which returns "adjbiasvals" structure: offset and scale values.         % will also include chan_count and samp_freq for binary/asyst/ASCIIif adjbiasvals.samp_freq ~= 0, samp_freq = adjbiasvals.samp_freq; endchan_count = length(adjbiasvals.chName);organization=adjbiasvals.organization;chanlist='';for i=1:length(adjbiasvals.chName)   chanlist = [chanlist adjbiasvals.chName{i} ' '];enddat_len = numsamps/chan_count;disp( ['Channels found: ' chanlist])disp( ['Samples found: ' num2str(dat_len)])disp( ['Sampling frequency: ' num2str(samp_freq)] );disp( ['Record duration:    ' num2str(dat_len/samp_freq) ' seconds.'] );% Is the data stored contiguously or is it interleaved% c: {ch1samp1...ch1sampN, ch2samp1...ch2sampN, ... , chMsamp1...chMsampN}% i: {ch1samp1 ch2samp1...chMsampN, ... , ch1sampN ch2sampN...chMsampN}newdata=NaN(dat_len,chan_count);switch organization(1)   case 'u'      % do something clever here to let the user see the results of      % each options and choose which one is better?   case 'c'      % data stored as contiguous blocks      for i = 1:chan_count         newdata(:,i) = tempdata( (i-1)*dat_len+1: dat_len*i);      end   case 'i'      % data stored interleaved      for i = 1:chan_count         ind = (0:dat_len-1)*chan_count + i;         newdata(:,i) = tempdata(ind);      endend% back to RD