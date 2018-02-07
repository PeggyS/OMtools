% rd.m:  Opens a variety of eye-movement data file types.% [out] = rd(in);% 'in' is a data file of one of the formats listed below.% 'out' is a data structure of type 'emData', which can include position data,% saccade,fixation and blink events, and a variety of other values. Type% 'help emData' to (eventually) get the structure's current contents and% organization.%   Either argument is optional. Without an input argument, a GUI will% prompt for a data file to open. Without an output argument, the resulting% emData structure will be created in the base workspace.%% Supported formats:% Internal OMlab:  RTRV (.dat)   ASD (.asd)    LabVIEW (.lab)% Universal(ish):  ACSII (.txt)  Ober2 (.obr)  Raw Binary (.bin)%                  EyeLink (.edf) -- first convert using edf2bin% written by  Jonathan Jacobs%             September 1995 - November 2017  (last mod: 11/22/17)%% modified by King Yi, 04/27/11 - Modified code to read in DS and TL%                  (digital stimulus output and laser stim on/off times).%% January 2017: Gutted and re-written as a function; to reduce use of global% variables; to use a new data structure (emData) for all eye data; to% import saccade, fix and blink info from EDF2bin files.% March 2017: it is now a former shadow of its previous clumsy bulky self.% Much more compact, modern code. Extraneous code has been ruthlessly pruned.% These comments now account for about 1/7th of the total line count.function out = rd(filename)global  samp_freq enviroGcurdir=pwd; newdata=0; chName='';cd(matlabroot); cd(findomprefs)try   load enviroG.matcatch   beep   disp('Initializing OMtools environment variables.')   enviroenddoRefix = enviroG(4); doFiltering = enviroG(5);cd(curdir)filefilter={'*.lab;*.txt;*.bin;*.mat;*.dat;*.obr;*.asd;*.edf;',...   'lab, txt, bin, mat, dat, obr, asd, edf' };rdpath('r'); % last dir where we successfully read a fileif nargin==0   % user specifies via dialog box   [filename,pathname]=uigetfile(filefilter, 'Load a data file');   if filename==0      disp( 'Canceled.');      cd(curdir)      out=[];      return;   endelse   seps=strfind(filename,filesep);   if isempty(seps)      pathname=pwd;   else      pathname = filename( 1:seps(end) );      filename = filename(seps(end)+1:end);   endendif ~exist([pathname filename],'file')   disp('Bad file specified')   out=[];   returnend[shortname,exten] = strtok(filename,'.');exten = exten(2:end);disp( [char(13) 'Loading ' filename] )try cd(pathname);catch, cd(dataroot); end% To properly scale the data each "rd_" module calls 'getbias' and% 'applybias' before 'unfold'ing if needed (obsolete? -- used for old ASL IR glasses)% 'fileformat' is used by 'readbias'switch lower(exten)   case {'asd'}      fileformat = 'asyst';  rd_asd;   case {'bin'}      fileformat = 'binary'; rd_bin;   case {'dat'}      fileformat = 'retrieve'; rd_rtrv;   case {'lab'}      fileformat = 'labview'; rd_labv;   case {'obr'}      fileformat = 'ober2'; rd_ober2;   case {'txt'}      fileformat = 'ascii'; rd_ascii;   case {'edf'}      disp('This is an EDF file.')      if exist( [pathname shortname '.bin'],'file')         disp('A version of the converted file already exists in this')         disp('directory. I do not know if it is up to date (probably is).')      end      disp('You can create a MATLAB-compatible version by running "edf2bin"')      disp('Would you like me to do that now (y/n)? ')      yorn=input('  --> ','s');      if strcmpi('y',yorn)         succ=evalin('base',['edf2bin(' '''' filename '''' ', ' '''' pathname '''' ');'] );         if succ==1            disp(' ')            disp(['The EDF file has been converted to ' shortname '.bin.'])            disp('I will now try to run rd again to load it. Wish me luck.')            out = rd([pathname strtok(filename,'.') '.bin']);         else            disp('There was a problem creating the new .bin file')            out=[];         end      else         out=[];      end      return   case {'mat'}      disp('Loading a MATLAB saved structure or workspace.');      load([pathname filename])      cd(curdir)      return   case {''}      disp('this file has no extension. Please add the appropriate')      disp('file extension (e.g. .lab, .obr, .txt, etc.)')      return   otherwise      disp('This is NOT an ASCII data file,') % Great Galloping Gonads, Batman!      disp('it is not a RETRIEVE file,')      % There's something TERRIBLY      disp('it is not an ober2 file,')        % wrong here.  Panic.      disp('it is not an LabVIEW file,')      disp('it is not a raw binary file,')      disp('and it is not an ASYST file.')      disp('Quite frankly, I am stumped. Please make sure that the')      disp('file has a known three-letter extension at its end.')      returnenddisp([fileformat ' file successfully read.']);% 'rd_xxxx' returns adjusted data in 'newdata', channel names in 'chName'% chName is cell with names of the channels read from bias file.num_chans = length(chName);dat_len = length(newdata);% remove any crosstalkif exist([shortname '.xt'],'file')   [xtfactors, xt_err_flag] = readxtalk(filename);   if ~xt_err_flag      newdata = removextalk(newdata, xtfactors, chName);   endend% 'emData' is the data structure specified in emData.mdata = emData;data.start_times = [];data.filename = filename;data.pathname = pathname;data.recmeth = rectype;data.comments = comments;data.samp_freq = samp_freq;data.numsamps = dat_len;%  '__extras.mat' file is created when importing Eyelink data with edf2binif exist([shortname '_extras.mat'],'file')   data = parsesaccfile(data);   data = parsefixfile(data);   data = parseblinkfile(data);   data = parsevffile(data);end% do any further post-processingif exist([shortname '.z'],'file') && doRefix,     refix(filename); endif exist([shortname '.f'],'file') && doFiltering, dofilt; end% assuming the data are all calibrated by this point% use [pts,cols]=find(newdata>vel_lim) rather than using a loop?pos_lim = 50; pct_lim = 10;for i=1:num_chans   do_limit = 'y';   bad_samps = find(abs(newdata(:,i)) > pos_lim);   if size(bad_samps) > dat_len * pct_lim/100      disp([num2str(pct_lim) '% of the data is over ' num2str(pos_lim) ' deg.'])      disp('It might be raw/uncalibrated or very noisy.')      disp(['Shall I truncate the maximum pos to +/-' num2str(pos_lim) ' deg (y/n)? '])      do_limit = lower(input('--> ','s'));   end   if strcmpi(do_limit,'y')      newdata(bad_samps,:) = NaN; %#ok<AGROW>   endenddisp( [char(13) 'Adding new data: '] )%d_raw    = [0.04 0.08 0.16 0.32 0.64 1.28 2.56] * 10; d_raw    = 2.^(2:8)/10; % just because ^^^ a boring list is boringly boring.d_scaled = [ 15   10   5    0    -5   -10  -15];emdm=-1; do_proc=0;ch=get(0,'Children');for i=1:length(ch)   if strcmpi(ch(i).Name,'EM Data Manager')      emdm = i;      break   endendif emdm == -1   cutoff = samp_freq/20;   order = 4;   if nargout==0      disp('For slow-phase analysis, you should low-pass filter the data.')      yorn = input('Do you wish to do this (y/n)? ','s');      if strcmpi(yorn,'y'), do_proc=1; end   end   else   hgui   = ch(emdm).UserData;   order  = hgui.filt_order.Value;   cutoff = hgui.filt_cutoff.Value;   if isempty(cutoff) || cutoff == 0      cutoff = samp_freq/20;      hgui.filt_cutoff.Value = cutoff;   endendchName=char(chName); % convert chName cells to characters.for ch_ind = 1:num_chans   scaled_data = newdata(:,ch_ind);   chfield = lower(chName(ch_ind,:));   disp( [sprintf('\b'), chfield ' '] )   if strcmpi(chfield,'ds')      scaled_data=interp1(d_raw,d_scaled,scaled_data,'linear','extrap');   end   if emdm ~= -1      if any( strcmp({'rh','lh','rv','lv','rt','lt'},chfield) )         do_proc = hgui.(chfield).Value;      end   end   if do_proc       data.(chfield).unfilt = scaled_data;      if any( strcmp({'rh','lh','rv','lv','rt','lt'},chfield) )         scaled_data = lpf(scaled_data,order,cutoff,samp_freq);      end   end   data.(chfield).data = scaled_data;   if any( strcmp({'rh','lh','rv','lv','rt','lt'},chfield) )      data.(chfield).vel = d2pt(scaled_data,3);   endend %for ch_indrd_dig; % load the digital stimulus file if presentif nargout == 0   sname=lower(shortname);   assignin('base', sname, data)   disp(['Data added to the base workspace as the emData structure variable ' sname])   disp(['You can type "emd_extract(' sname ')" to access the individual channels.'])   yorn=input('Would you like me to do that now (y/n)? ','s');   if strcmpi(yorn,'y')      emd_extract(data);      disp('Data saved into base memory.')   else      disp('Data not saved into base memory.')   endelse   out = data;enddisp(' ')rdpath('w', pwd); % this dir is now last succesful readcd(curdir)return%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% put the scaled data into EM Data structure ("data.____")% 'ds' passive D/A Converter Lookup Table (See Hardware Doc for more details)%  DS Vout (x10)   Deg%     0.4           15%     0.8           10%     1.6            5%     3.2            0%     6.4           -5%    12.8          -10%    25.6          -15