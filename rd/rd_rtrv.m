% rd_rtrv.m:  Read in 'RETRIEVE' format files.  Multiple files can% be read in and their data will be stored in their own columns.      % written by:  Jonathan Jacobs (some parts based on code by Vallabh Das)%              July 1995 - October 1999  (last mod: 10/14/99)% open the file and read the header information[comp, maxsize] = computer;if strcmp( comp, 'MAC' )   fid = fopen([pathname filename], 'r', 'l');   % little-endian   readhdrm; else   fid = fopen([pathname filename], 'r');   % big-endian   readhdrd;end% r_files = r_files + 1;% total_files = r_files + a_files + b_files...%                    + o_files + x_files + l_files;% read the data[inp_arr, data_len] = fread(fid,inf,'short');chan_count = channels(length(channels)); arr_len = data_len/chan_count;fclose(fid);getbias% 12-bit data is in offset binary format  (    0 -> xx,   i.e. '0' = xx/2)% 16-bit data is in 2's complement format (-xx/2 -> xx/2, i.e. '0' = 0   )num_levels = 2^ad_bits;if ad_bits == 12   zero_pt = num_levels/2; elseif ad_bits == 16   zero_pt = 0;end% do the scaling% there are two versions of the retrieve format floating around, % and both seem to still be in active service for taking data.  why???if vers < 1.03                        % vers == 1.02  scarr = (inp_arr - zero_pt)/num_levels * degmax*2 ; elseif vers > 1.03                   % vers == 1.04   %scale_factor = 0.00137329082689; (where did you get this, Vallabh?)   fudge = 0.00001724;   scarr = inp_arr/num_levels * degmax*2 ;    scarr = scarr - (inp_arr * fudge); % it works. why? (test: MLCx.DAT)endt = (0:1/samp_freq:(arr_len-1)/samp_freq)'; % create time array% Make the arrays of possible channel names.  These are used if there% is no entry for this data file in the bias adjustment file.% You can modify the following channel strings to meet your needs% if these names are not the ones you want.  Just make sure that the% names you choose are only two letters long.chan8_str = 'rh lh hh rv lv hv rt lt ';chan3_str = 'st rh lh ';chan2_str = 'rh lh ';eight_chan_str = ['rh'; 'lh'; 'hh'; 'rv'; 'lv'; 'hv'; 'rt'; 'lt'];three_chan_str = ['st'; 'rh'; 'lh'];two_chan_str   = ['rh'; 'lh'];if chan_count == 8   disp( ['  ' num2str(chan_count) ' channels.  Assuming: ' chan8_str] )   chanName = eight_chan_str; elseif chan_count == 3   disp( ['  ' num2str(chan_count) ' channels.  Assuming: ' chan3_str] )   chanName = three_chan_str;  elseif chan_count == 2   disp( ['  ' num2str(chan_count) ' channels.  Assuming: ' chan2_str] )   chanName = two_chan_str; end% this loop will divide the n channels of data into separate arrays.% (channels are stored in file consecutively, not interleaved.) newdata=NaN(arr_len,chan_count);for k = 1:chan_count   newdata(:,k) = scarr( (k-1)*arr_len+1:k*arr_len );end [dat_len, dat_cols] = size( newdata );commentstr = comments(end,:);commentstr = nameclean(commentstr);%disp( ['  Channels found:     ' num2str(dat_cols)] );disp( ['  Comments:           ' commentstr] );disp( ['  Samples found:      ' num2str(dat_len)] );disp( ['  Sampling frequency: ' num2str(samp_freq)] );disp( ['  Duration of record: ' num2str(dat_len/samp_freq) ' seconds'] );% return to RD