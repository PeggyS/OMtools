% rd.m:  Opens a variety of eye-movement data file types.% out = rd(filename,[interactive=1]);%% 'filename' is a text string name of a data file in one of the below formats.% If 'interactive' = 0, you will not be prompted for any y/n decisions about% how the data is to be adjusted or processed.% 'out' is a data structure of type 'emData', which includes position data,% saccade, fixation,and blink events, and a variety of other values. % Type 'help emData' to (eventually) get the structure's organization.% % Either argument is optional. Without an input argument, a GUI will% prompt for a data file to open. Without an output argument, the resulting% emData structure will be created in the base workspace.%% Supported formats:% Internal OMlab:  RTRV (.dat)   ASD (.asd)    LabVIEW (.lab)% Universal(ish):  ACSII (.txt, .text .csv)  Ober2 (.obr)  Raw Binary (.bin)%                  EyeLink (.edf) -- may first try to convert using edf2bin% written by  Jonathan Jacobs%             September 1995 - May 2018  (last mod: 05/24/18)%% modified by King Yi, 04/27/11 - Modified code to read in DS and TL%      Digital stimulus output and laser stim on/off times:%      'ds' passive D/A Converter Lookup Table (See Hardware Doc for more details)%      DS Vout (x10)   Deg%         0.4           15%         0.8           10%         1.6            5%         3.2            0%         6.4           -5%        12.8          -10%        25.6          -15%% Jan 2017: Gutted and re-written as a function; to reduce use of global%    variables; to use a new data structure (emData) for all eye data; to%    import saccade, fix and blink info from files converted using 'edf2bin'.% Mar 2017: 'rd' is but a mere shadow of its previous clumsy bulky self.%    Much more compact, modern code. Extraneous code has been ruthlessly pruned.%    These comments now account for about 1/8th of the total line count.% Feb 2018: 'rd' now works with GUI front end 'datstat'.%    Will also call 'edf2bin' to convert EDF file, and then load the resulting%    .bin file.%    Checks to see if selected data file has already been loaded.function data = rd(filename,interactive)global  samp_freq enviroGif nargin<2, interactive = 1; endcurdir=pwd; %newdata=0; %chName='';cd(matlabroot); cd(findomprefs)try   load('enviroG.mat', 'enviroG')catch   beep   %disp('Initializing OMtools environment variables.')   enviroenddoScaling = enviroG(3);   %doRefix = enviroG(4);doFiltering = enviroG(5); %doUnfolding = enviroG(6); doXTalkRmvl = enviroG(7);cd(curdir)extens='*.lab;*.txt;*.text;*.csv;*.bin;*.mat;*.dat;*.obr;*.asd;*.edf;';%descript='lab, txt, text, csv, bin, mat, dat, obr, asd, edf';filefilter=[extens,upper(extens)]; %%%%%;descript};rdpath('r'); % last dir where we TRIED (was: 'successfully') read a fileif nargin==0 || isempty(filename)   % user specifies via dialog box   [filename,pathname]=uigetfile(filefilter, 'Load a data file');   if filename==0      disp( 'Canceled.');      cd(curdir)      if nargout~=0,data=[];end      return;   endelse   seps=strfind(filename,filesep);   if isempty(seps)      pathname=pwd;   else      pathname = filename( 1:seps(end) );      filename = filename(seps(end)+1:end);   endendif ~exist([pathname filename],'file')   disp('Bad file specified. Run "rd" again to load it manually.')   if nargout, data=[]; end   returnendrdpath('w', pathname); % this dir is now last attempted read[shortname,exten] = strtok(filename,'.');exten = exten(2:end);% take from structure already in memoryvarlist = evalin('base','whos');candidate = cell(length(varlist),1);already_loaded=0; x=0;for i=1:length(varlist)   if strcmpi(varlist(i).class, 'emData')      x=x+1;      candidate{x} = varlist(i).name;            if strcmpi( shortname,varlist(i).name )         already_loaded=1;         break      end         endendif already_loaded && interactive   beep   commandwindow   yorn=input('This file may already be loaded. Replace it (y/n)? ','s');   %yorn=input(' --> ','s');   if strcmpi(yorn,'n')      disp('Canceled.')      if nargout, data=[]; end      return   endend   disp( [newline 'Loading ' filename] )try cd(pathname);catch, cd(dataroot); end% To properly scale the data each "rd_xxxx" module calls 'getbias' (which% calls 'readbias'). 'fileformat' is used by 'readbias'foundbiasfile=1;[adj_fname,adjbiasvals] = getbias(filename); %,samp_freq);if strcmpi(adj_fname,'no adjbias file found')   foundbiasfile=0;   if ~strcmpi(exten,'edf')      disp('Would you like to create one (y/n)?')      commandwindow      yorn=input(' --> ','s');      if strcmpi(yorn,'y')         adj_fname = biasgen;         if strcmpi(adj_fname, 'file_not_created')            disp('No bias file was created.')         else            disp('The bias file was created successfully.')            disp('Try reading the data again.')         end         data=[];         return      end   endendif isempty(adjbiasvals) && foundbiasfile   %beep   %disp(['I did not find any bias values in "' adj_fname '"'])   disp('You can run "biasgen" to create a new bias file.')   data=[];   returnendswitch lower(exten)   case {'asd'}      data=rd_asd(pathname,filename,adjbiasvals);     case {'bin'}      data=rd_bin(pathname,filename,adjbiasvals);   case {'dat'}      data=rd_rtrv(pathname,filename,adjbiasvals);   case {'lab'}      data=rd_labv(pathname,filename,adjbiasvals);   case {'obr'}      data=rd_ober2(pathname,filename,adjbiasvals);   case {'txt';'text';'csv'}      data=rd_ascii(pathname,filename,adjbiasvals);   case {'edf'}      disp('This is an EDF file.')      if exist( [pathname shortname '.bin'],'file')         %alreadyconverted=1;         disp('A version of the converted file already exists in this')         disp('directory. I do not know if it is up to date (probably is).')      else         %alreadyconverted=0;      end      disp('You can create a MATLAB-compatible version by running "edf2bin"')      if (1) %interactive         commandwindow         yorn=input('Would you like me to do that now (y/n)? ','s');         if strcmpi('y',yorn)            numfiles=evalin('base',['edf2bin(' '''' filename '''' ', ' ...                '''' pathname '''' ');'] );            if numfiles>=1               disp(' ')               disp('The EDF file has been converted.')               if numfiles==1                  disp('I found a single record file.')                  shortname = strtok(filename,'.');                  disp('I will run "rd" again to load it.')               else                  disp(['I found ' num2str(numfiles) ' record files.'])                  shortname=[strtok(filename,'.') '_1'];                  disp('I will run "rd" again to load the first file.')               end               if nargout==1                  data=rd([pathname shortname '.bin']);               else                  rd([pathname shortname '.bin']);               end            else               disp('There was a problem creating the new .bin file')               if nargout,data=[];end            end         else            if nargout,data=[];end         end         return      else         %if nargout,data=[];end         %return      end   case {'mat'}      disp('Loading a MATLAB saved structure or workspace.');      load([pathname filename],'*')      cd(curdir)      return   case {''}      disp('This file has no extension. Please add the appropriate')      disp('file extension (e.g. .lab, .obr, .txt, etc.)')      return   otherwise      disp('This is NOT an ASCII data file,') % Great Galloping Gonads, Batman!      disp('it is not a RETRIEVE file,')      % There's something TERRIBLY      disp('it is not an ober2 file,')        % wrong here.  Panic.      disp('it is not an LabVIEW file,')      disp('it is not a raw binary file,')      disp('and it is not an ASYST file.')      disp('Quite frankly, I am stumped. Please make sure that the')      disp('data file has a known three-letter extension at its end.')      returnendsamp_freq=data.samp_freq;newdata=data.newdata;comments=data.comments;% ajbiasvals was created in readbiasif isempty(adjbiasvals)   disp('No adjustments found.')   data=[];   returnendrectype = lower(adjbiasvals.rectype);chName  = adjbiasvals.chName(:,1); % convert chName cells to characters.% (NOTE: Only needed for IR data that has saturated, reflecting the data % beyond the saturation limit to appear LESS than the limit.% This should never occur anymore. Maintained for historical reasons.)% First read the the unfolding file, if it exists, and apply the fixes.%if doUnfolding%   unfold  %% deprecating%end% After unfolding, it is now safe to apply the bias adjustments.% if the EM Data Manager window is open, check if adj should be applied.emdm=-1; ch=get(0,'Children');for i=1:length(ch)   if strcmpi(ch(i).Name,'EM Data')      emdm = i;      hgui = ch(emdm).UserData;      break   endendif emdm ~= -1    if hgui.applybias.Value      newdata = applybias(newdata,adjbiasvals);      disp('Bias adjustments applied.') %shall   else      disp('No adjustments applied.') %shan't   endelse   % if EMDM not open, use 'enviroG' setting.   if doScaling      newdata = applybias(newdata,adjbiasvals);   end   disp('Bias adjustments applied.')end% 'rd_xxxx'   places adjusted data into 'newdata'% 'applybias' creates 'chName' as a cell with names of the channelsnum_chans = length(chName);dat_len = length(newdata);% remove any crosstalkif doXTalkRmvl   if exist([shortname '.xt'],'file')      [xtfactors, xt_err_flag] = readxtalk(filename);      if ~xt_err_flag         newdata = removextalk(newdata, xtfactors, chName);      end   endend% 'emData' is the data structure specified in emData.mdata = emData;data.start_times = [];data.filename = filename;data.pathname = pathname;data.recmeth = rectype;data.comments = comments;data.samp_freq = samp_freq;data.numsamps = dat_len;% 10 Sep 18: why did I have to add this?%   "dot name structure assignment is illegal when the structure is empty.%   Use a subscript on the structure."% Never needed it before today!% Is it because I added 'filterparams' field as empty cell?data.rh(1).pos=[]; data.lh(1).pos=[]; data.rv(1).pos=[]; data.lv(1).pos=[];data.rt(1).pos=[]; data.lt(1).pos=[]; data.hh(1).pos=[]; data.hv(1).pos=[];data.st(1).pos=[]; data.sv(1).pos=[];pm  = char(177); % plus/minus symboldeg = char(176); % degree symbol% assuming the data are all calibrated by this point% use [pts,cols]=find(newdata>vel_lim) rather than using a loop?pos_lim = 50; pct_lim = 10;disp(' ')noisystrflag=0;not_all=1;%do_filt=0;for i=1:num_chans   %do_limit = 'y';    is_noisy=0;   bad_samps = find(abs(newdata(:,i)) > pos_lim);   bad_len=max(size(bad_samps));   if bad_len > dat_len*pct_lim/100      is_noisy=1;      if noisystrflag==0         noisystrflag=1;         disp('These channels might be uncalibrated or noisy. ')         disp('(Or if this is an analog recording, very blinky.)')      end             disp(['  ' num2str(100*bad_len/dat_len) '% of the ' ...         char(chName{i}) ' data is over ' num2str(pos_lim) deg '.'])     if interactive && not_all         fprintf('  Shall I limit position to %c%d%c (y/n/(a)ll affected chans)?\r', ...             pm, pos_lim, deg);         commandwindow         do_limit = lower(input(' --> ','s'));         if strcmpi(do_limit,'a'),not_all=0; end      else         do_limit = 'y'; %%%%%%%%%% can change to 'n' if desired      end   end   if noisystrflag && is_noisy      switch do_limit         case {'a','y'}            newdata(bad_samps,i) = NaN;            fprintf('  Changed bad points to NaNs.\r')         case'n'            disp('  Left bad points unmodified.')            %disp([sprintf('\b') '  Left bad points unmodified.'])      end   end   do_limit='n';endannounce_filtdone=0;%is EM Data Manager open?if emdm == -1 %nope   %cutoff = 25;   cutoff = samp_freq/20;   order = 4;   if ~interactive      announce_filtdone=1; %%%%%%%%% can change this default to 0   else      if interactive         disp(' ')         disp('For slow-phase analyses you may need to low-pass filter the data.')         commandwindow         yorn = input('Do you wish to do this (y/n)? ','s');         if strcmpi(yorn,'y'), do_filt=1; end      else         disp('Note: non-interactive mode -- no filtering performed.')         do_filt=0;      end   endelse %yup   order  = hgui.filt_order.Value;   cutoff = hgui.filt_cutoff.Value;   if isempty(cutoff) || cutoff == 0      cutoff = samp_freq/20;      %cutoff = 25;      hgui.filt_cutoff.Value = cutoff;   endenddisp( 'Adding new data: ' )%d_raw    = [0.04 0.08 0.16 0.32 0.64 1.28 2.56] * 10; d_raw    = 2.^(2:8)/10; % just because ^^^ a boring list is boringly boring.d_scaled = [ 15   10   5    0    -5   -10  -15];for ch_ind = 1:num_chans   scaled_data = newdata(:,ch_ind);      chfield = lower(chName{ch_ind});   if strcmpi(chfield,'ds')      scaled_data=interp1(d_raw,d_scaled,scaled_data,'linear','extrap');   end   goodchan = any( strcmp({'rh','lh','rv','lv','rt','lt', ...      'st','sv','ds','tl'},chfield));   if goodchan      data.chan_names{ch_ind} = chfield;   end      filterable = any( strcmp({'rh','lh','rv','lv','rt','lt'},chfield));      if emdm ~= -1 % if EMDM window is open      if filterable         if hgui.auto_filt.Value            hgui.(['do_' chfield]).Enable = 'on';            hgui.(['do_' chfield]).Value = 1;            do_filt=1;         else            hgui.(['do_' chfield]).Enable = 'off';            hgui.(['do_' chfield]).Value = 0;            do_filt=0;         end      end   else % EMDM window is NOT open      if filterable && doFiltering && strcmpi(yorn,'y')         do_filt = 1;      end   end         if goodchan      % retain unfilt data in struct      data.(chfield).unfiltered = scaled_data;      % filter if desired      if do_filt         scaled_data = lpf(scaled_data,order,cutoff,samp_freq);         announce_filtdone=1;         data.(chfield).filt_params.type='butterworth';         data.(chfield).filt_params.order=order;         data.(chfield).filt_params.cutoff=cutoff;         data.(chfield).filt_params.samp_freq=samp_freq;         if filterable            hgui.(['do_' chfield]).Text = ...               [chfield ' - ' num2str(order) ',' num2str(cutoff)];         end      else         data.(chfield).filt_params.type='none';         data.(chfield).filt_params.order=[];         data.(chfield).filt_params.cutoff=[];         data.(chfield).filt_params.samp_freq=[];         if filterable            hgui.(['do_' chfield]).Text = chfield;         end      end            % add data to 'pos' field (can be either filtered or unfiltered)      data.(chfield).pos = scaled_data;      if all(isnan(scaled_data))         disp( [sprintf('\b'), chfield '(empty) '] )      else         disp( [sprintf('\b'), chfield ' '] )      end   endend %for ch_indif announce_filtdone   disp(['Low-pass filtered: Order ' num2str(order), ...      ', Cutoff ' num2str(cutoff) ' Hz'])end%  '_extras.mat' file is created when importing Eyelink data with edf2binif exist([shortname '_extras.mat'],'file')   data = parsesaccfile(data);   data = parsefixfile(data);   data = parseblinkfile(data);   data = parsevffile(data);endrd_dig; % load the digital stimulus file if presentif nargout == 0   sname=shortname;   assignin('base', sname, data)   disp(' ')   disp(['Data added to the base workspace as: ' sname])   disp(['Type "emd_extract(' '''' sname '''' ')" to access the individual channels.'])   if interactive      commandwindow      yorn=input('Would you like me to do that now (y/n)? ','s');      if strcmpi(yorn,'y')         dname=strtok(data.filename,'.');         fprintf('   ');         emd_extract(dname);         %disp('Data saved into base memory.')      else         disp('Data not saved into base memory.')      end   end   clear dataenddisp(' ')%rdpath('w', pwd); % this dir is now last succesful readcd(curdir)return