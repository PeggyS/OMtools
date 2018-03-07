% edf2bin.m: convert an EDF file to a MATLAB-readable binary formatted file.
% As a default, data is arranged in the following column order: [lh rh lv rv],
% but other configurations (including pupil data) are possible.
%
% Exporting data from EDF format requires the 'edf2asc' program from SR Research.
% It is freely available to registered users from their support website at:
% https://www.sr-support.com/forums/index.php
% Select the 'EyeLink Display Software' topic and from there download the version
% for your computer's operating system. Place a copy of the 'edf2asc' executable in
% your OMtools/rd directory to enable this program (edf2bin) to perform the conversion.
%
% This program directly commands edf2asc to export the data to a '.bin' file that has
% the same name as the original .EDF file, and in the same directory.  It is done using
% the following command: edf2asc xxxx.edf -s -y -miss NaN
% Dropped sample points are saved as 'NaN' (the IEEE representation for 'Not a Number').
% Eye-movement events (saccades, fixations and blinks), and other useful EyeLink
% configuration (e.g., screen size and pixels/deg) are saved into a MATLAB
% file with the same name as the EDF plus '_extras.mat'.

% Written by:  Jonathan Jacobs
%              August 2000 - February 2017 (last mod: 02/01/17)

% 05 Apr 12 -- edf files containing multiple trials will now be properly saved
%              in .bin format
%              Can now deal with channels in different order than default
% 09 Apr 12 -- Now can directly read .EDF files without requiring user intervention
%              and modifications of intermediate .ASC file.
% 15 Apr 13 -- Fixed for case when EDF time index (column 1) changes from 6 digits to 7
% 31 Jan 17 -- Oh so many new things!
% 03 Jul 17 -- Fixed for when there is more than 1 record - there is a h_pix_deg & v_pix_deg for each record
%              There is a h_pix_deg & v_pix_deg for each record.
%			   Saccades, fixations, blinks, and video frams are also now separated by
%			   record and saved in the proper _extras.mat file

function success = edf2bin(fn,pn)

curdir = pwd;
cd(findomtools); cd('rd')

if (exist('edf2asc','file') ~= 2)
   disp('To use this version of edf2bin, you need to have a copy of the SR Research')
   disp('executable EyeLink file "edf2asc" installed in the OMtools "rd" directory.')
   disp('If you have registered an account with SR, go to their support website at')
   disp('https://www.sr-support.com/forums/index.php and download the EyeLink Display Software')
   disp('for your platform (Mac, Mac OS X, Windows or Linux.  This will contain the needed file.')
   return
end

try cd(curdir); catch, cd(matlabroot); end

if nargin<2
   [fn, pn]=uigetfile({'*.edf'}, 'Select an EDF file to load');
   if fn == 0, disp('Aborted.'); return, end
end

fname = lower(strtok(fn,'.'));

% stripped_uscore = 0;
subjstr=fname;
% if subjstr(end)=='_'
%     subjstr = subjstr(1:end-1);
%     stripped_uscore = 1;
% end

inputfile = ['''' pn fn ''''];
msgsfile =  ['''' pn fname '_msgs' ''''];
datafile =  ['''' pn fname '_data' ''''];
eventfile = ['''' pn fname '_events' ''''];

% for scenelink info edf2asc must be called in the same folder that also
% has the *.ett file. That's just edf2asc.
cd(findomtools); cd('rd')
rd_path_str = pwd;  % the path to rd so we know how to call edf2asc
cd(pn)

% disp('')
% disp('Export samples as [G]aze (eye in space) or [H]REF (eye in head)?')
% horg = input('-> ','s');
% if strcmpi(horg,'h')
%    disp('Exporting HREF data')
%    exp = ' -sh ';
%    samptype = 'HREF';
% elseif strcmpi(horg,'g')
%    disp('Exporting Gaze data')
%    exp = ' -sg ';
%    samptype = 'GAZE';
% end

% HREF is not supported yet, so I'm commenting the option to ask for it out for now
exp = ' -sg ';
samptype = 'GAZE';

sc_flag = '';
ett_file = strrep(fn,'.EDF', '0.ett');
if exist(ett_file, 'file') % matching the file name is case sensitive!
   sc_flag = ' -scenecam';
end

% search the EDF file for sampling frequency and recorded eye channel(s)
% This is what an entry looks like:  MSG	3964147 RECCFG CR 1000 2 1 LR
% eval( [ '! ./edf2asc ' inputfile ' ' msgsfile '  -neye -ns -y ' ] )
% eval( [ '! ./edf2asc ' inputfile ' ' eventfile '  -nmsg -ns -y ' ] )
eval( [ '! ' rd_path_str '/edf2asc ' inputfile ' ' msgsfile exp sc_flag ' -neye -ns -y ' ] );
eval( [ '! ' rd_path_str '/edf2asc ' inputfile ' ' eventfile exp ' -nmsg -ns -y ' ] );
disp('EDF messages exported.')
disp('Searching for channel and frequency information.')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Search the MESSAGES file for important keywords
%  "START", "RECCFG", "END", "DISPLAY", "RES", "VFRAME"
% Use carriage return as delimiter. Each line of msgs is a single MSG.
ind = 0; ind2 = 1; sfpos=NaN(); sf=NaN();
msgs = importdata([pn fname '_msgs.asc'],char(13)); % '13' is CR char.
eyes=cell(1); chname=cell(1);
v_found=1; %gaze = 0; href = 0;
vf = struct;
fix = struct;
sacc = struct;
blink = struct;
v_pix_deg = zeros(); h_pix_deg = zeros();
start_time = zeros(); end_time = zeros();
%filestops = zeros(); filestarts = zeros();

for ii = 1:length(msgs)

   str_temp = strfind( msgs{ii}, 'START');
   if str_temp == 1
      [~, temp] = strtok(msgs{ii});
      [temp,~] = strtok(temp);
      start_time(ind2) = str2double( temp );
   end

   % e.g. DISPLAY_COORDS 0 0 1279 1023
   disp_coords = strfind( msgs{ii}, 'DISPLAY_COORDS');
   if disp_coords
      %get last two entries in line
      [disp_words,~] = proclinec( msgs{ii} );
      h_pix_z = (str2double( disp_words{end-1})+1)/2;
      v_pix_z = (str2double( disp_words{end} )+1)/2;
   end

   k=strfind( msgs{ii},'RECCFG' );
   if k~=0
      ind=ind+1;
      %cfglines(ind) = ii; cfgpos(ind)=k;
      p = strfind( msgs{ii}, '2000');
      if p, sf(ind) = 2000; sfpos(ind)= p; end
      p = strfind( msgs{ii}, '1000');
      if p, sf(ind) = 1000; sfpos(ind)= p; end
      p = strfind( msgs{ii},  '500');
      if p, sf(ind) =  500; sfpos(ind)= p; end
      p = strfind( msgs{ii},  '250');
      if p, sf(ind) =  250; sfpos(ind)= p; end

      temp = msgs{ii}(sfpos(ind):end);
      [~, pos_type] = strtok( temp );
      [~, eye_code] = strtok( pos_type );

      eyes{ind} = 'none';
      % eyes can be encoded either by l,r, or 1,2,3.
      if contains(eye_code,'1'), eyes{ind} = 'l'; end
      if contains(eye_code,'2'), eyes{ind} = 'r'; end
      if contains(eye_code,'3'), eyes{ind} = 'lr'; end

      if contains(eye_code,'L') && ~contains(eye_code,'R'),eyes{ind} = 'l'; end
      if contains(eye_code,'R') && ~contains(eye_code,'L'),eyes{ind} = 'r'; end
      if contains(eye_code,'LR'), eyes{ind} = 'lr'; end      
   end % if k

   pixres = ~isempty(strfind( msgs{ii},'RES')) && strcmp( msgs{ii}(1:3), 'END' );
   if pixres
      %get last two entries in line
      [pix_words,~] = proclinec( msgs{ii} );
      disp(['Vertical pixels/deg: ' pix_words{end}])
      disp(['Horizontal pixels/deg: ' pix_words{end-1}])
      v_pix_deg(ind2) = str2double( pix_words{end-1} );
      h_pix_deg(ind2) = str2double( pix_words{end} );
   end
   vframe = ~isempty(strfind( msgs{ii},'VFRAME'));
   if vframe
      [vframe_words,~] = proclinec( msgs{ii} );
      vf(ind2).framenum(v_found)  = str2double(vframe_words{4});
      vf(ind2).frametime(v_found) = str2double(vframe_words{2});
      v_found=v_found+1;
   end
   str_temp = strfind( msgs{ii}, 'END');
   if str_temp == 1
      [~, temp] = strtok(msgs{ii});
      [temp,~] = strtok(temp);
      end_time(ind2) = str2double( temp );
      ind2 = ind2 + 1;
   end

end % for ii


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now parse the EVENTS file for saccades, fixations, blinks, GAZE and/or HREF
events = importdata([pn fname '_events.asc'],char(13)); % '13' is CR char.
% f_found=1; s_found=1; b_found=1;
f_found=0; s_found=0; b_found=0;
%out_found=0;
out_type = 'not found';
recnum = 0; % no records yet, 'START' will indicate a new record
for jj = 1:length(events)
   %disp(events{jj})
   if length(events{jj})>=17
      split_line = proclinec(events{jj});

	  switch split_line{1}	% examine the 1st word in the line
		  case 'START'
			  recnum = find(start_time <= str2double(split_line{2}), 1, 'last');
			  f_found=0; s_found=0; b_found=0;
		  case 'EVENTS'
			  out_type = lower(split_line{2});
		  case 'EFIX'
			  f_found = f_found+1;
			  fix(recnum).eye{f_found}=split_line{2};
			  fix(recnum).start(f_found) = str2double(split_line{3});
			  fix(recnum).end(f_found) = str2double(split_line{4});
			  fix(recnum).dur(f_found) = str2double(split_line{5});
			  fix(recnum).xpos(f_found) = str2double(split_line{6});
			  fix(recnum).ypos(f_found) = str2double(split_line{7});
			  fix(recnum).pupi(f_found) = str2double(split_line{8});
			  if length(split_line) > 8
				  fix(recnum).xres(f_found) = str2double(split_line{9});
				  fix(recnum).yres(f_found) = str2double(split_line{10});
			  end

		  case 'ESACC'
			  s_found=s_found+1;
			  sacc(recnum).eye{s_found}=split_line{2};
			  sacc(recnum).start(s_found) = str2double(split_line{3});
			  sacc(recnum).end(s_found) = str2double(split_line{4});
			  sacc(recnum).dur(s_found) = str2double(split_line{5});
			  sacc(recnum).xpos(s_found) = str2double(split_line{6});
			  sacc(recnum).ypos(s_found) = str2double(split_line{7});
			  sacc(recnum).xposend(s_found) = str2double(split_line{8});
			  sacc(recnum).yposend(s_found) = str2double(split_line{9});
			  sacc(recnum).ampl(s_found) = str2double(split_line{10});
			  sacc(recnum).pvel(s_found) = str2double(split_line{11});
			  if length(split_line) > 11
				  sacc(recnum).xres(s_found) = str2double(split_line{12});
				  sacc(recnum).yres(s_found) = str2double(split_line{13});
			  end

		  case 'EBLINK'
			  b_found=b_found+1;
			  blink(recnum).eye{b_found} = split_line{2};
			  blink(recnum).start(b_found) = str2double(split_line{3});
			  blink(recnum).end(b_found) = str2double(split_line{4});
			  blink(recnum).dur(b_found) = str2double(split_line{5});

	  end % switch case first word of the line
   end % if length of line is long enough to bother looking at
end %jj EVENTS scan loop


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% now we'll export the samples.
disp('')
eval([ '! '  rd_path_str '/edf2asc ' inputfile ' ' datafile exp ' -s -t -y -miss NaN' ] )
disp('EDF to ASCII conversion completed.')
disp('Importing converted data into MATLAB.  Patience is a virtue.')
raw = importdata([pn fname '_data.asc']);
if isempty(raw)
   disp('No eye movement data found. Aborting')
   return
end

%assignin('base','raw', raw)
cd(curdir)

% chop off everything after the final tab.  This will remove the non-numeric last coluumn.
disp('Data successfully loaded.  Converting to numeric values.  Tick tock, tick tock.')
rawlen = length(raw);
timecol = cell(rawlen,1);
numcols = zeros(rawlen,1);
out = cell(rawlen,1);

delete([pn fname '_data.asc'])

for i = 1:rawlen
   temp = raw{i};
   tabs = find(temp == 9);
   numcols(i) = length(tabs);
   timecol{i} = raw{i}(1:tabs(1)-1);
   out{i,:} = pad( raw{i}(tabs(1): tabs(end)-1), 100 );
end

% check num of entries in each line, because number of channels
% can change between subtrials.
temp = numcols(1:end-1)-numcols(2:end);
chan_chg = find(temp~=0) + 1;
if chan_chg
   disp(['The number of channels changed following trial(s): ' num2str(chan_chg)])
   blockstarts = [1 chan_chg];
   blockstops  = [chan_chg-1 rawlen];
   block=cell(length(blockstarts));
   for j = 1:length(blockstarts)
      block{j} = cell2mat(out( blockstarts(j):blockstops(j) ,:));
   end
else
   block{1} = cell2mat(out);
   blockstarts = 1;
   blockstops = rawlen;
end
numblocks=length(block);
disp('')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(pn)
files = 0;
%filestarts = NaN(1,length(block));
%filestops = NaN(1,length(block));
for z = 1:length(block)
   temp = block{z};
   out  = str2num(temp); %#ok<ST2NM> % because str2double gives 'NaN' for array

   % display the number of channels, ask whether user wants to view them
   % or simply enter/verify channel order.
   [numsamps,numcols] = size(out);
   disp(' ')
   disp(['Block ' num2str(z) ' of ' num2str(numblocks) ])
   disp([ '  ' num2str(numcols) ' channels detected.'])
   disp([ '  ' num2str(numsamps) ' samples detected.'])

   % use slower str2double because cell2mat chokes when
   % 6-digit time becomes 7-digit time during recording session.
   times_str = timecol(blockstarts(z):blockstops(z),1);
   %t=zeros(size(times_str,1),size(times_str,2));
   t_el=str2double(times_str);
   % For multiple records in a single EDF file, there will be gaps in time between
   % each experiment. Use them to separate the experiments.
   tdiff=t_el(2:end) - t_el(1:end-1);
   filestops = find(tdiff > 30 );	% changed 100 to 30
   filestops =  cat(1, filestops,numsamps);
   %filestarts = cat(1, 1,filestops(1:end-1)+1);
   numfilestops = length(filestops);

   if isempty(filestops) || length(filestops)==1
      % if there are no record separator lines, just
      % use the last row of the data as the end point
      disp( '  Only 1 trial detected.' )
      % no need for '_x' in file name
      singleton = 1;
      filestarts = 1;
      filestops = numsamps;
   else
      disp([ '  ' num2str(numfilestops) ' trials detected.'])
      disp([ '  Separations at lines: ' mat2str(filestops)] )
      septrials = 'y';
      %septrials = input('  Treat as individual trials? (y/n) ','s');
      if  contains( septrials, 'y' )
         filestarts = [1; (filestops+1)];
      else
         filestarts = 1;
         filestops = numsamps;
      end
      singleton = 0;
   end

   % default chan vals coming FROM edf2asc
   %lh_chan=1; lv_chan=2; rh_chan=4; rv_chan=5;
   numfilestops = length(filestops);
   for x = 1:numfilestops
      clear rh_chan rv_chan lh_chan lv_chan
      disp(' ')
      disp( [' Record ' num2str(files+x)] )
      disp( ['  Starting time: ' num2str(start_time(x)) ])
      disp( ['  Sampling frequency: ' num2str( sf(files+1) ) ])
      switch numcols
         case 7
            disp( 'Default EDF->ASC export assumption: ' )
            disp( '   1) time, 2) lh, 3) lv, 4) lp (pupil), 5) rh, 6) rv, 7) rp' )
            disp( '   Will save in this order: [lh rh lv rv]' )
            ch_err_flag=1;
            yorn = input('Is this correct? (y/n) ','s');
            if strcmpi(yorn,'y')
               lh_chan=2; lv_chan=3; rh_chan=5; rv_chan=6;
               ch_err_flag = 0;
            end

         case 6
            %disp( 'Default EDF->ASC export assumption: ' )
            %disp( '   1) lh, 2) lv, 3) lp (pupil), 4) rh, 5) rv, 6) rp' )
            disp( '  Will save in this order: [lh rh lv rv]' )
            ch_err_flag=1;
            %yorn = input('Is this correct? (y/n) ','s');
            yorn='y';
            if strcmpi(yorn,'y')
               lh_chan=1; lv_chan=2; rh_chan=4; rv_chan=5;
               ch_err_flag = 0;
            end

         case 5
            disp( 'Default EDF->ASC export assumption: ' )
            disp( '   1) lh, 2) lv, 3) lp (pupil), 4) rh, 5) rv' )
            disp( '   Will save in this order: [lh rh lv rv]' )
            ch_err_flag=1;
            yorn = input('Is this correct? (y/n) ','s' );
            if strcmpi(yorn,'y')
               lh_chan=1; lv_chan=2; rh_chan=4; rv_chan=5;
               ch_err_flag = 0;
            end

         case 3
            %ch_err_flag = 1;
            if strcmpi( eyes{files+1}, 'l' )
               lh_chan=1; lv_chan=2;
               disp( '  Left eye only.' )
               disp( '  Will save in this order: [ lh lv ]')
            elseif strcmpi( eyes{files+1}, 'r')
               rh_chan=1; rv_chan=2;
               disp( '  Right eye only.' )
               disp( '  Will save in this order: [ rh rv ]')
            end
            ch_err_flag = 0;

         otherwise
            disp( 'I do not know the order of the channels here.' )
            ch_err_flag = 1;
            clear rh_chan rv_chan lh_chan lv_chan
      end %switch numcols

      % If none of the known cases exist, prompt the user for the channel names.
      % might need this if the data were taken in an unusual form, e.g., monocularly.
      strarray = [ {'lh'},{'rh'},{'lv'},{'rv'},{'lp'},{'rp'} ];
      % name the channels
      if ch_err_flag
         sampfreq = sf(files+1);
         for i=1:numcols
            chtemp = out(:,i); t=maket(chtemp,sampfreq);
            figure; plot(t,chtemp)
            commandwindow
            chname{i} = input(['Enter a name for channel ' num2str(i) '.  Enter "-" to ignore it: '],'s');
            chpos = strcmp(chname{i}, strarray);
            if chpos
               eval( [strarray{chpos} '_chan = i;'])
               %disp(['   Assigning channel ' str2num(i) ' as ' chname{i} '.'] )
            end
         end
      end

      clear temp
      if singleton, temp{x} = subjstr;
      else,         temp{x} = [subjstr '_' num2str(files+x)]; end

      % save all the accessory data
      % h_pix_deg, v_pix_deg, start_timess sacc, fix, blink
      if exist('fix','var'),   extras.fix   = fix(x);   end
      if exist('sacc','var'),  extras.sacc  = sacc(x);  end
      if exist('blink','var') && x <= length(blink)  % if there is more than 1 record, and no blinks in any of the records, then blink is an empty struc and accessing blink(2) causes an error
		  extras.blink = blink(x);
      end
      if exist('vf','var') && x <= length(vf) % ~isempty(vf)
         extras.vf = vf(x);
      else
         extras.vf = [];
      end
      extras.start_times = start_time(x);
      extras.end_times   = end_time(x); % actually 1ms AFTER final sample!!!!!
      extras.out_type = out_type;

      extras.numsamps = filestops(x)-filestarts(x)+1; % samples in this trial/record
      extras.samptype = samptype;
      extras.sampfreq = sf(x);
      extras.h_pix_z = h_pix_z;
      extras.v_pix_z = v_pix_z;
      extras.h_pix_deg = h_pix_deg(x);	% each trial has its resolution in the msg.asc file
      extras.v_pix_deg = v_pix_deg(x);
      extras.t_el.first = t_el(1);
      extras.t_el.last  = t_el(end);
      %extras.vf = vf;
      eval( [temp{x} '_extras = extras;'] )
      save([temp{x} '_extras.mat'],[temp{x} '_extras'] )

      % Conversion from EL GAZE values to degrees:
      dat = NaN();
      seg = filestarts(x):filestops(x);
      if exist('lh_chan','var')
         dat = ( out(seg,lh_chan)-h_pix_z )/h_pix_deg(x);
      end
      if exist('rh_chan','var')
         dat = cat(1,dat,( out(seg,rh_chan)-h_pix_z )/h_pix_deg(x));
      end
      if exist('lv_chan','var')
         dat = cat(1,dat, -( out(seg,lv_chan)-v_pix_z )/v_pix_deg(x));
      end
      if exist('rv_chan','var')
         dat = cat(1,dat, -( out(seg,rv_chan)-v_pix_z )/v_pix_deg(x));
      end

      % look for st,sv data?
      stsv=0;
      disp(' ')
      yorn=input('Do you want to try to add target data (y/n)? ','s');
      if strcmpi(yorn,'y')
         [st,sv] = tgt_recon([pn fname]);
         if ~isempty(st),dat=cat(1,dat,st);stsv=1;disp('   st data added');end
         if ~isempty(sv),dat=cat(1,dat,sv);stsv=1;disp('   sv data added');end
      end
      % Conversion from EL HREF values to degrees:
      %%%%% someday maybe?

      % write the EM data to file
      fid = fopen([temp{x} '.bin'], 'w', 'n');
      fwrite(fid, dat, 'float');
      fclose(fid);
      disp(['  Saved as ' pn temp{x} '.bin' ])
   end
   files = files + length(filestops);
end % for z

try cd(curdir); catch, cd(matlabroot); end

disp(' ')
%disp(['Horizontal pixels/deg: ' num2str(v_pix_deg)])
%disp(['Vertical pixels/deg: '   num2str(h_pix_deg)])
%disp(' ')

% because why would you record several records, each w/separate sampfreq?
edfbiasgen(fname,pn,sf(1),files,stsv);
if nargout==1, success=1; end

disp('If you don''t like the bias file, delete it and recreate it by running')
disp('"biasgen" yourself. You will need to know the sampling frequency')
disp('used to take the data, as well as which channels were recorded.')
disp('Biasgen should offer a simple choice "Imported from EDF (binocular)". If not,')
disp('use the following parameters: Method is (V)ideo, Format is (B)inary,')
disp('Calibration is (N)ormal, and Channel Structure is (C)ontiguous.')
