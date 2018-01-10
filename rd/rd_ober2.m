% rd_ober2.m:  called by RD to handle ober2 data files% written by:  Jonathan Jacobs%              September 1995 - March 2000  (last mod: 03/15/00)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%getbias% open the ober fileif comp(1) == 'M'   fid = fopen( filename, 'r', 'l'); else   fid = fopen( filename, 'r' );end% figure out what version of ober file formatfseek(fid, 0, 'bof');fileverstr = char(fread(fid, 16, 'char')');if strfind(fileverstr, 'ober2 1.2')   %read the # of channels   fseek(fid, 370, 'bof');   [chan_count, ~] = fread(fid, 1, 'int8');   %get the channel names.  They are 20-char ASCII strings located at    %offsets 436, 456, 476 and 496, as "XL XR YL YR" for "lh rh lv rv"   chanName = char(chan_count,2);   for i = 1:chan_count      fseek(fid, 436+((i-1)*20), 'bof');      [temp, ~] = fread(fid, 1, 'uchar');      if char(temp) == 'X'         chanName(i,2) = 'h';        elseif char(temp) == 'Y'         chanName(i,2) = 'v';      end      [temp, ~] = fread(fid, 1, 'uchar');      chanName(i,1) = lower(char(temp));      end      % load the sampling frequency   % the high four bits of this number are '1001', indicating that   % this is the sampling frequency.  We must mask them out.   fseek(fid, 5200, 'bof');   [codedSampFreq, ~] = fread(fid, 1, 'ushort');   samp_freq = codedSampFreq - (4096*9);   %load the data   fseek(fid, 5210, 'bof');   [tempdata, count] = fread(fid, inf, 'short');   fclose(fid);else   %read the # of channels   fseek(fid, 54, 'bof');   [chan_count, ~] = fread(fid, 1, 'int8');   %chan_count = 4;   %get the channel names.  They are 25-char ASCII strings located at    %offsets 60, 85, 110 and 135, as "XL XR YL YR" for "lh rh lv rv"   chanName = char(chan_count,2);   for i = 1:chan_count      fseek(fid, 60+((i-1)*25), 'bof');      [temp, ~] = fread(fid, 1, 'uchar');      if char(temp) == 'X'         chanName(i,2) = 'h';        elseif char(temp) == 'Y'         chanName(i,2) = 'v';      end      [temp, ~] = fread(fid, 1, 'uchar');      chanName(i,1) = lower(char(temp));      end      % load the sampling frequency   % the high four bits of this number are '1001', indicating that   % this is the sampling frequency.  We must mask them out.   %fseek(fid, 5200, 'bof');   %[codedSampFreq, count] = fread(fid, 1, 'ushort');   %samp_freq = codedSampFreq - (4096*9);   samp_freq = 300;   %load the data   fseek(fid, 840, 'bof');   [tempdata, count] = fread(fid, inf, 'short');   tempdata = tempdata(1:end-735);   fclose(fid);end% filter out the marker (?) crap (high four bits not all zero)% and then convert the data vector of size (count) x (1)% into array of size (numSamples) x (chan_count)areDataPts = find( (tempdata >= 0) & (tempdata <= 4095) );data = tempdata(areDataPts);numSamples = length(data)/chan_count;newdata = NaN(numSamples, chan_count);for k = 1:chan_count   newdata(:,k) = data((0:numSamples-1)*chan_count + k);end[dat_len, dat_cols] = size( newdata );disp( ['  Channels found:     ' num2str(dat_cols)] );disp( ['  Samples found:      ' num2str(dat_len)] );disp( ['  Sampling frequency: ' num2str(samp_freq)] );disp( ['  Duration of record: ' num2str(dat_len/samp_freq) ' seconds'] );applybias%return to RD