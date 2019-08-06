% rd.m:  Opens a variety of eye-movement data file types.% out = rd(filename,['filter', 'nofilter', 'deblink', 'nobias', 'batch']);%% 'filename' is the text string name of a data file, e.g. 'jbj1.lab'.% 'filter', 'deblink', 'nobias', and 'batch' are optional arguments. Filtering% will be applied (default LPF 4th order butterworth, with cutoff 1/20 of% sampling frequency) if requested, or if the "datstat" GUI is open and% filtering is checked. 'nofilt' will override the datstat window.% Deblinking is performed by "ao_deblink", which was originally developed for% data acquired using analog channels, but is still useful for digital sources.% If 'nobias' is specified, the adjustbias file info will NOT be applied.% If 'batch' is specified, you will not be prompted for any y/n decisions about% how the data is to be adjusted or processed.% 'out' is a data structure of type 'emData', which includes position data,% saccade, fixation,and blink events, and a variety of other values.% Type 'help emData' to see the structure's organization.%% Input and output arguments are optional. Without an input file name,% the GUI will prompt for a data file to open. Without an output argument,% the resulting emData structure will be created in the base workspace.%% NOTE: Consider using "datstat", which is a graphical front end for rd. It% gives you more intuitive control over how the data is loaded and% processed, and lets you select between multiple emData structures% residing in memory. You can also clear and reapply filtering with% different parameters.%% Supported formats:% Internal OMlab:  RTRV (.dat)   ASD (.asd)   LabVIEW (.lab)% Universal(ish):  ACSII (.txt, .text, .csv)  Ober2 (.obr)    Raw Binary (.bin)%                  EyeLink (.edf) -- will first try to convert using edf2bin% written by  Jonathan Jacobs%             September 1995 - January 2019  (last mod: 01/10/19)%% modified by King Yi, 04/27/11 - Modified code to read in DS and TL%      Digital stimulus output and laser stim on/off times:%      'ds' passive D/A Converter Lookup Table (See Hardware Doc for details)%      DS Vout (x10)   Deg%         0.4           15%         0.8           10%         1.6            5%         3.2            0%         6.4           -5%        12.8          -10%        25.6          -15%% Jan 2017: Gutted and re-written as a function: to reduce use of global%    variables; to use a new data structure (emData) for all eye data; to%    import saccade, fix and blink info from files converted using 'edf2bin'.% Mar 2017: 'rd' is but a mere shadow of its previous clumsy bulky self.%    Much more compact, modern code. Extraneous code has been ruthlessly pruned.%    These comments now account for about 1/10th of the total line count.% Feb 2018: 'rd' now works with GUI front end 'datstat'.%    Will also call 'edf2bin' to convert EDF file, and then load the resulting%    .bin file.%    Checks to see if selected data file has already been loaded.% Jan 2019: added input arguments for 'batch', 'filter' and 'xax_min'.%    Fixed minor logic errors for when filtering is to be applied.function data = rd(filename, varargin)global  samp_freq %enviroG% switches in varargin: filtering, deblinking, bias, batch % filtering can be called here, or in GUI. So if we really DON'T want to% apply any filtering, we need to specifically call 'nofilt' to override% the GUI if filtering is checked.ff=find(contains(lower(varargin),'filt'));if ff, do_filt = 1;else,  do_filt = 0;endnf=find(contains(lower(varargin),'nofilt')); no_filt=0;if nf, do_filt = 0; no_filt=1;elseenddb=find(contains(lower(varargin),'deblink'));if db, do_deblink = 1;else,  do_deblink = 0;endbb=find(contains(lower(varargin),'batch'));if bb, interactive = 0;else,  interactive = 1;endnb=find(contains(lower(varargin),'nobias'));if nb, do_bias = 0;else,  do_bias = 1;endif nargin<2, interactive = 1; endcurdir=pwd; %newdata=0; %chName='';extens='*.lab;*.txt;*.text;*.csv;*.bin;*.mat;*.dat;*.obr;*.asd;*.edf;';%descript='lab, txt, text, csv, bin, mat, dat, obr, asd, edf';filefilter=[extens,upper(extens)]; %%%%%;descript};rdpath('r'); % last dir where we TRIED (was: 'successfully') read a fileif nargin==0 || isempty(filename)   [filename,pathname]=uigetfile(filefilter, 'Load a data file');   if filename==0      disp( 'Canceled.');      cd(curdir)      if nargout~=0,data=[];end      return;   endelse   seps=strfind(filename,filesep);   if isempty(seps)      pathname=[pwd filesep];   else      pathname = filename( 1:seps(end) );      filename = filename(seps(end)+1:end);   endendif ~exist([pathname filename],'file')   disp('Bad file specified. Run "rd" again to load it manually.')   if nargout, data=[]; end   returnendrdpath('w', pathname); % this dir is now last attempted read[shortname,exten] = strtok(filename,'.');exten = exten(2:end);% take from structure already in memoryvarlist = evalin('base','whos');candidate = cell(length(varlist),1);already_loaded=0; x=0;for ii=1:length(varlist)   if strcmpi(varlist(ii).class, 'emData')      x=x+1;      candidate{x} = varlist(ii).name;      if strcmpi( shortname,varlist(ii).name )         already_loaded=1;         break      end   endendif already_loaded && interactive   beep   commandwindow   yorn=input('This file may already be loaded. Replace it (y/n)? ','s');   if strcmpi(yorn,'n')      disp('Canceled.')      if nargout, data=[]; end      return   endenddisp( [newline 'Loading ' filename] )try cd(pathname);catch, cd(dataroot); end% is EM data manager (datstat) window open?emdm=findwind('EM Data');if ishandle(emdm)   hgui = emdm.UserData;elseend% To properly load the data, each "rd_xxxx" module calls 'getbias', % which then calls 'readbias'. ('fileformat' is used by 'readbias'.)% Even if there is no scaling, there may be other necessary info in the file, % such as channel names or sampling frequency.% Scaling will be applied by 'applybias' after the data have been loaded.foundbiasfile=1;[adj_fname,adjbiasvals] = getbias(filename); %,samp_freq);if strcmpi(adj_fname,'no adjbias file found')   foundbiasfile=0;   if ~strcmpi(exten,'edf')      disp('Would you like to create one (y/n)?')      commandwindow      yorn=input(' --> ','s');      if strcmpi(yorn,'y')         adj_fname = biasgen;         if strcmpi(adj_fname, 'file_not_created')            disp('No bias file was created.')         else            disp('The bias file was created successfully.')            disp('Try reading the data again.')         end         data=[];         return      end   endendif isempty(adjbiasvals) && foundbiasfile   disp('Run "biasgen" to create a new bias file.')   data=[];   returnendswitch lower(exten)   case {'asd'}      data=rd_asd(pathname,filename,adjbiasvals);   case {'bin'}      data=rd_bin(pathname,filename,adjbiasvals);   case {'dat'}      data=rd_rtrv(pathname,filename,adjbiasvals);   case {'lab'}      data=rd_labv(pathname,filename,adjbiasvals);   case {'obr'}      data=rd_ober2(pathname,filename,adjbiasvals);   case {'txt';'text';'csv'}      data=rd_ascii(pathname,filename,adjbiasvals);   case {'edf'}      disp('This is an EDF file.')      if exist( [pathname shortname '.bin'],'file')         %alreadyconverted=1;         disp('A version of the converted file already exists in this')         disp('directory. I do not know if it is up to date (probably is).')      else         %alreadyconverted=0;      end      disp('You can create a MATLAB-compatible version by running "edf2bin"')      commandwindow      yorn=input('Would you like me to do that now (y/n)? ','s');      if strcmpi('y',yorn)         numfiles=evalin('base',['edf2bin(' '''' filename '''' ', ' ...            '''' pathname '''' ');'] );         if numfiles>=1            disp(' ')            disp('The EDF file has been converted.')            if numfiles==1               disp('I found a single record file.')               shortname = strtok(filename,'.');               disp('I will run "rd" again to load it.')            else               disp(['I found ' num2str(numfiles) ' record files.'])               shortname=[strtok(filename,'.') '_1'];               disp('I will run "rd" again to load its first subfile.')            end            if nargout==1               data=rd([pathname shortname '.bin']);            else               rd([pathname shortname '.bin']);            end         else            disp('There was a problem creating the new .bin file')            if nargout,data=[];end         end      else         if nargout,data=[];end      end      return   case {'mat'}      disp('Loading a MATLAB saved structure or workspace.');      load([pathname filename],'*')      cd(curdir)      return   case {''}      disp('This file has no extension. Please add the appropriate')      disp('file extension (e.g. .lab, .obr, .txt, etc.)')      return   otherwise      disp('This is NOT an ASCII data file,') % Great Galloping Gonads, Batman!      disp('it is not a RETRIEVE file,')      % There's something TERRIBLY      disp('it is not an ober2 file,')        % wrong here. Panic.      disp('it is not an LabVIEW file,')      disp('it is not a raw binary file,')      disp('and it is not an ASYST file.')      disp('Quite frankly, I am stumped. Please make sure that the')      disp('data file has a known three-letter extension at its end.')      returnend% raw data successfully loaded. Time for massage!samp_freq=data.samp_freq;newdata=data.newdata;comments=data.comments;% 'rd_xxxx'   placed adjusted data into 'newdata'% 'applybias' creates 'chName' as a cell with names of the channelsrectype = lower(adjbiasvals.rectype);chName  = adjbiasvals.chName(:,1); % convert chName cells to characters.% (NOTE: Only needed for IR data that has saturated, reflecting the data% beyond the saturation limit to appear LESS than the limit.% This should never occur anymore. Maintained for historical reasons.)%if doUnfolding%   unfold  %% deprecated%end% if the EM Data Manager window is open, check if scaling should be applied.if ishandle(emdm)   if hgui.auto_bias.Value      newdata = applybias(newdata,adjbiasvals);      disp('Bias adjustments applied.') %shall   else      disp('No adjustments applied.') %shan't   endelse   % if EMDM not open, use input argument.   if do_bias      newdata = applybias(newdata,adjbiasvals);   end   disp('Bias adjustments applied.')endnum_chans = length(chName);dat_len = length(newdata);% remove any crosstalk%{if doXTalkRmvl   if exist([shortname '.xt'],'file')      [xtfactors, xt_err_flag] = readxtalk(filename);      if ~xt_err_flag         newdata = removextalk(newdata, xtfactors, chName);      end   endend%}% 'emData' is the data structure specified in emData.mdata = emData;data.start_times = [];data.filename = filename;data.pathname = pathname;data.recmeth = rectype;data.comments = comments;data.samp_freq = samp_freq;data.numsamps = dat_len;% 10 Sep 18: why did I have to add this?%   "dot name structure assignment is illegal when the structure is empty.%   Use a subscript on the structure."% Never needed it before today!% Is it because I added 'filterparams' field as empty cell?data.rh(1).pos=[]; data.lh(1).pos=[]; data.rv(1).pos=[]; data.lv(1).pos=[];data.rt(1).pos=[]; data.lt(1).pos=[]; data.hh(1).pos=[]; data.hv(1).pos=[];data.st(1).pos=[]; data.sv(1).pos=[];pm  = char(177); % plus/minus symboldeg = char(176); % degree symbolannounce_filtdone=0;%is EM Data Manager open?if ~ishandle(emdm)  %%% nope %%%   cutoff = samp_freq/20;   order = 4;      if  ~do_filt && ~no_filt % filtering desire unclear            if ~interactive         %announce_filtdone=1; %%% can change this default to 0         disp('Note: non-interactive "batch" mode -- no filtering performed.')      else                           disp(' ')         disp('For slow-phase analyses you may need to low-pass filter the data.')         commandwindow         yorn = input('Do you wish to do this (y/n)? ','s');         if strcmpi(yorn,'y'), do_filt=1; announce_filtdone=1;         else,                 do_filt=0;         end      end %if ~interactive         end   else  %%% yup %%%   order  = hgui.filt_order.Value;   cutoff = hgui.filt_cutoff.Value;   if isempty(cutoff) || cutoff == 0      cutoff = samp_freq/20;      hgui.filt_cutoff.Value = cutoff;   endenddisp( 'Adding new data: ' )%d_raw    = [0.04 0.08 0.16 0.32 0.64 1.28 2.56] * 10;d_raw    = 2.^(2:8)/10; % just because ^^^ a boring list is boringly boring.d_scaled = [ 15   10   5    0    -5   -10  -15];% noisy limitspos_lim = 50; pct_lim = 10;not_all = 1; %noisystrflag = 0; % walk the channels, check to see that there is a valid channel name,% if is eligible for de-noising and filtering.for ch_ind = 1:num_chans   scaled_data = newdata(:,ch_ind);   chfield = lower(chName{ch_ind});   if strcmpi(chfield,'ds')      scaled_data=interp1(d_raw,d_scaled,scaled_data,'linear','extrap');   end   goodchan = any( strcmp({'rh','lh','rv','lv','rt','lt', ...      'st','sv','ds','tl'},chfield));   if goodchan      data.chan_names{ch_ind} = chfield;   end      filterable = any( strcmp({'rh','lh','rv','lv','rt','lt'},chfield));      if ishandle(emdm) % if EMDM window is open      if filterable         if hgui.auto_filt.Value            hgui.(['do_' chfield]).Enable = 'on';            hgui.(['do_' chfield]).Value = 1;            do_filt=1;         else            hgui.(['do_' chfield]).Enable = 'off';            hgui.(['do_' chfield]).Value = 0;            do_filt=0;         end      else         do_filt=0;      end   end      if goodchan      % check to see if data is noisy/blinky/otherwise over-value      is_noisy=0; noisystrflag=0;      if do_deblink && filterable         scaled_data = ao_deblink(scaled_data);      end      bad_samps = find(abs(scaled_data) > pos_lim);      bad_len=max(size(bad_samps));            if (bad_len>dat_len*pct_lim/100) && interactive         is_noisy=1;         %if noisystrflag==0            noisystrflag=1;            disp('These channels might be uncalibrated or noisy. ')            disp('(Or if this is an analog recording, very blinky.)')         %end         disp(['  ' num2str(100*bad_len/dat_len) '% of the ' ...            char(chName{ch_ind}) ' data is over ' num2str(pos_lim) deg '.'])         if not_all            fprintf('  Shall I limit position to %c%d%c (y/n/(a)ll affected chans)?\r', ...               pm, pos_lim, deg);            commandwindow            do_limit = lower(input(' --> ','s'));            if strcmpi(do_limit,'a'),not_all=0; end         else            do_limit = 'y'; %%%%%%%%%% can change to 'n' if desired         end      end % if bad_len            if noisystrflag && is_noisy         switch do_limit            case {'a','y'}               newdata(bad_samps,ii) = NaN;               fprintf('  Changed bad points to NaNs.\r')            case'n'               disp('  Left bad points unmodified.')         end      end      do_limit='n';           % To filter, or not to filter (retain unfilt data in struct, just in case)      data.(chfield).unfiltered = scaled_data;      if do_filt && filterable         scaled_data = lpf(scaled_data,order,cutoff,samp_freq);         announce_filtdone=1;         data.(chfield).filt_params.type='butterworth';         data.(chfield).filt_params.order=order;         data.(chfield).filt_params.cutoff=cutoff;         data.(chfield).filt_params.samp_freq=samp_freq;         if filterable            hgui.(['do_' chfield]).Text = ...               [chfield ' - ' num2str(order) ',' num2str(cutoff)];         end      else         data.(chfield).filt_params.type='none';         data.(chfield).filt_params.order=[];         data.(chfield).filt_params.cutoff=[];         data.(chfield).filt_params.samp_freq=[];         if filterable            hgui.(['do_' chfield]).Text = chfield;         end      end      % add data to 'pos' field (can be either filtered or unfiltered)            if all(isnan(scaled_data))         disp( [sprintf('\b'), chfield '(empty) '] )      else         disp( [sprintf('\b'), chfield ' '] )      end      data.(chfield).pos = scaled_data;   end %if is goodchanend %for ch_indif announce_filtdone   disp(['Low-pass filtered: Order ' num2str(order), ...      ', Cutoff ' num2str(cutoff) ' Hz'])end%  '_extras.mat' file is created when importing Eyelink data with edf2binif exist([shortname '_extras.mat'],'file')   data = parsesaccfile(data);   data = parsefixfile(data);   data = parseblinkfile(data);   data = parsevffile(data);enddigdata = rd_dig(filename); % load the digital stimulus file if presentdata.digdata  = digdata;data.digdata2 = led_recon(digdata,0); %contains x_pos,laser,time fields;if nargout==0   sname=shortname;   assignin('base', sname, data)   disp(' ')   disp(['Data added to the base workspace as: ' sname])   disp(['Type "emd_extract(' '''' sname '''' ')" to access the individual channels.'])   if interactive      commandwindow      yorn=input('Would you like me to do that now (y/n)? ','s');      if strcmpi(yorn,'y')         dname=strtok(data.filename,'.');         fprintf('   ');         emd_extract(dname);      else         disp('Data not saved into base memory.')      end   end   clear dataenddisp(' ')if ishandle(emdm)   emdm.RunningAppInstance.update_datalist; %add to datstat windowendcd(curdir)return