% nafxprep.m: does the scut work for preparing data segments for% analysis using the NAFX.%% Use 'zoomtool' to select the segment to be analyzed by using the cursors% to mark at least the beginning and end of the segment, and optionally,% the maximum and minimum extremes of foveation.  Use the C1(x,y) and C2(x,y)% buttons to store the foveation points.  (It is not necessary to store the% beginning and end points, but you may do so if you wish.)%% 'nafxprep' extracts the segment using the 'sub' function, names it% appropriately, shifts it in the same manner as 'calcshift' (also% producing an appropriately named variable), and then calculates the% velocity array (again appropriately named).%% The command line statements that would have been necessary to do this% work by hand are printed out, and the shifted position and velocity% segments are automatically placed into their fields in the NAFX GUI% (if it is currently open).% Written by: Jonathan Jacobs% April 2005 - October 2009  (last mod: 10/14/09)%%%%%%%% change controlhandles to h.controlhandlesfunction nafxprepglobal samp_freq xyCur1Mat xyCur2Mat xyCur1Ctr xyCur2Ctrdegstr=char(176); pmstr=char(177);temp=ver('MATLAB');ML_VER = str2double(temp.Version);% find zoomtool windowzoomwindow = findme('zoomed window');if zoomwindow<=0    disp('"Zoomtool" needs to be running for "nafxprep" to work.')    returnendfigure(zoomwindow)% grab the cursor handles from the zoomed axis.temp=get(gca,'UserData');hlist=temp{2};cur1horH=hlist{1};   cur2horH=hlist{7};cur1vertH=hlist{4};  cur2vertH=hlist{10};% linelist is the list of existing lines; it is stored in NAFX gui UserData% it whould initially be empty.nafxFig = findme('NAFXwindow');if nafxFig<=0   disp('The NAFX GUI needs to be running for "nafxprep" to work.')   returnendtemp = get(nafxFig,'UserData');nafxhandles = temp{1};linelist = temp{2};%%%%%%%%%% is this a bright idea? incorporate this prepwork INTO the NAFX GUI% (or at least its own GUI).% this solves several potential problems, especially w/ambiguity of intent% of the user.% But adds extra complexity -- having to switch back and forth w/zoomtool.% other alternative: prompt user for specific inputs.  not so wild about% this, but may help reduce ambiguous point selection%%%%%%%%% we need at least start and stop values.  we may also need ymax and ymin.% check to see if any values are in xyCur matrices.%% cases:%  NO entries in xyCur matrices: use cur1x, cur2x as start/stop, and%    the min/max of the segment for calculating shift.%  TWO entries (1 ea. c1 & c2) in xyCur: compare against cur pos.%    sort for min&max x and use them as start/stop.  similarly,%    min/max y are used for shift%  FOUR entries (2 ea/ c1 & c2): sort them for min/max x, y. ignore cursors.temp = size(xyCur1Mat); cur1pts = temp(1);temp = size(xyCur2Mat); cur2pts = temp(1);ch = get(gca,'Children');zoomedline = findobj(ch,'UserData','zoomed');if (cur1pts==0) || (cur2pts==0)   disp(' ')   disp('%%   You will need to use the cursors to select segment start and stop points and')   disp('%%   also the positions of the minimum and maximum foveation periods.')   disp('%%   Place Cursor 1 on the beginning of the desired segment and click the')   disp('%%   "C1 get" button to store its value. Place Cursor 2 on the endpoint of the segment')   disp('%%   and click the "C2 get" button.  Next, locate the maximal foveation position and ')   disp('%%   select it with Cursor 1 and store its value.  Finally, locate the minimal foveation')   disp('%%   position, select it with Cursor 2 and store its value.  The "get" buttons should')   disp('%%   look like this: "C1 get (2)" and "C2 get(2)", showing that you have stored two')   disp('%%   locations for each cursor.  These will be used to calculate the NAFX.')   disp(' ')   returnend% build the line list only as needed, i.e., whenever a line is selected see% if it is in the list.  If it is, get the channel name.  If not prompt user% to enter the name.isInList = 0;linelistlen = length(linelist);for j = 1:linelistlen   if ML_VER >= 8.4      % matlab 2014b and later      lineID = get(zoomedline,'tag');      [lineID,~] = strtok(lineID, '.');   else       % matlab 2014a and earlier       lineID = get(zoomedline);   end   if strcmp(linelist{j,1}, lineID)      isInList = 1;      break   endendif ~isInList   % add an entry (handle, name)   linelist{linelistlen+1, 1} = lineID;   chStr = input('Enter the name of this data channel: ','s');   linelist{linelistlen+1, 2} = chStr; else   % get existing name   chStr = linelist{j,2};end% save the linelist back into the nafx controls windowset(nafxFig,'UserData',{nafxhandles,linelist});if (cur1pts==0) || (cur2pts==0)   return   mode = 'cursors';   disp('% interval set by current cursor positions alone %')   c1x = get(cur1horH, 'XData'); c1x = c1x(1);   c2x = get(cur2horH, 'XData'); c2x = c2x(2);   times = [c1x c2x]; elseif (cur1pts==1 && cur2pts>=1) || (cur1pts>=1 && cur2pts==1)   mode = 'mixed';   % get x,y values for cur1 and cur2   disp('% interval set by current AND stored cursor positions %')   c1x = crsrloc(gca,1001); c1x = c1x(1);   c2x = crsrloc(gca,2001); c2x = c2x(1);   c1y = crsrloc(gca,1002); c1x = c1x(1);   c2y = crsrloc(gca,2002); c2x = c2x(1);   %c1x = get(cur1horH, 'XData'); c1x = c1x(1); % broken as of HG2, ML2014b   %c2x = get(cur2horH, 'XData'); c2x = c2x(1);   %c1y = get(cur1vertH,'YData'); c1y = c1y(1);   %c2y = get(cur2vertH,'YData'); c2y = c2y(1);   % get LAST stored positions from xyCur matrices   m1x = xyCur1Mat(end,1)/samp_freq;  m1y = xyCur1Mat(end,2);   m2x = xyCur2Mat(end,1)/samp_freq;  m2y = xyCur2Mat(end,2);   times = [c1x c2x m1x m2x];   ylist = [c1y c2y m1y m2y]; elseif (cur1pts>=2) && (cur2pts>=2)   mode = 'storedpts';   % get LAST TWO stored positions from xyCur matrices   disp('% interval set by stored cursor positions alone %')   m1x1 = xyCur1Mat(end-1,1)/samp_freq;  m1y1 = xyCur1Mat(end-1,2);   m2x1 = xyCur2Mat(end-1,1)/samp_freq;  m2y1 = xyCur2Mat(end-1,2);   m1x2 = xyCur1Mat(end,1)/samp_freq;    m1y2 = xyCur1Mat(end,2);   m2x2 = xyCur2Mat(end,1)/samp_freq;    m2y2 = xyCur2Mat(end,2);   times = [m1x1 m1x2 m2x1 m2x2];   ylist = [m1y1 m1y2 m2y1 m2y2];endswitch mode case 'cursors'   tstart = min(times);   xstart = fix(samp_freq * tstart);   tstop = max(times);   xstop = fix(samp_freq * tstop);   ydata  = get(zoomedline,'YData');   ysub = ydata( xstart:xstop );   ymax = max(ysub);  ymin = min(ysub); case {'mixed', 'storedpts'}   % sort: xstart,xstop will be min,max x values   tstart = min(times);   xstart = fix(samp_freq * tstart);   startobjtemp = find(times==min(times));   startobj=startobjtemp(1);   tstop  = max(times);   xstop  = fix(samp_freq * tstop);   stopobjtemp = find(times==max(times));   stopobj = stopobjtemp(1);   times(startobj) = NaN;   times(stopobj)  = NaN;   % should be two non-NaN entries left in times list.   minmaxtimes = stripnan(times);   if length(minmaxtimes) ~= 2       disp('Error! too many entries in cursor array')       return   end   mm1str=num2str(minmaxtimes(1));   mm2str=num2str(minmaxtimes(2));   % ymin,ymax will be y-values of NON start/stop objects   ylistmin = ylist;   ylistmin(startobj) = NaN;   ylistmin(stopobj)  = NaN;   ylistmax = ylist;   ylistmax(startobj) = NaN;   ylistmax(stopobj)  = NaN;   ymin = min(ylistmin);   ymax = max(ylistmax);end%%% from here on want to be independent of how x,y min&max are chosen.%%% adjust for possible non-zero initial time%%% (will have to subtract off one sample...)%% need to fix this for case where no cursor values chosen%startStr = num2str( fix(tstart+xyCur1Mat(1,4)) );%stopStr  = num2str( fix(tstop+xyCur1Mat(1,4)) );startStr = num2str( fix(tstart + 1/samp_freq(1)) );stopStr  = num2str( fix(tstop  + 1/samp_freq(1)) );% header formatted for pasting into log filehStr = [upper(chStr) ':  ('];hdrStr = ['% ' hStr num2str(tstart) ' - ' num2str(tstop) ' -- ' ...               num2str(tstop - tstart) ' sec)'];disp(hdrStr)%disp('cycles by manual count: ')%disp(' ')% calc and eval the position variablevarPosStr = [chStr startStr '_' stopStr];evalStr1 = [varPosStr ' = sub(' chStr ', ' num2str(tstart) ', ' ...                         num2str(tstop-tstart) ');' ];evalin('base',evalStr1)disp(evalStr1)assignin('base','nafx_start',tstart)% calc and eval the SHIFTED position variableydiff = abs(ymax - ymin);yshift = (ymax + ymin)/2;if yshift < 0, shiftStr = ' + '; else shiftStr = ' - '; endevalStr2 = [varPosStr 's = ' varPosStr shiftStr num2str(abs(yshift))  ';' ];evalin('base',evalStr2)disp(evalStr2)assignin('base','nafx_shift',yshift)% calc and eval the velocity variablevarVelStr = [chStr 'v' startStr '_' stopStr];evalStr3 = [varVelStr ' = d2pt(' varPosStr ', 3);'];evalin('base', evalStr3)disp(evalStr3)% plug the shifted pos and vel strings into NAFX_gui window, if available% and set the position window popup menu to the next value larger than ydiff.nafxFig = findme('NAFXwindow');if get(nafxFig,'number')   global posArrayNAFXH velArrayNAFXH posLimNAFXH velLimNAFXH   set(posArrayNAFXH, 'string', [varPosStr 's'])   set(velArrayNAFXH, 'string', varVelStr)   xpos = [0.5 0.75 1.0 1.25 1.5 2.0 2.5 3.0 3.5 4.0 5.0 6.0];   temp = find((ydiff/2)<xpos);   % Fixed 7/8/14 to protect against overly large separations in foveation position selected   if isempty(temp)      pos_menu_val = length(xpos);      disp(' ')      disp('            ****** WARNING ******')      disp('Difference in foveation positions will require a window')      disp('greater than 6 deg. Window has been set to 6, but you should')      disp('consider reselecting your max and min foveation points to fit.')      disp(' ')    else      pos_menu_val = temp(1);   end   if ~isempty(pos_menu_val)      set(posLimNAFXH,'value', pos_menu_val)      disp(['% Min/max foveations occurred at: ' mm1str ' and ' mm2str ' seconds'])	   disp(['% Min/max foveation separation: ' num2str(ydiff) degstr])      disp(['% Setting pos lim to ' pmstr num2str(xpos(pos_menu_val)) degstr])      set(velLimNAFXH,'value', 1)      disp('% Resetting vel lim to 4 deg/sec')   endend% empty the xy cursor matrices in anticipation of next useif ~strcmp(mode,'cursors')   zoomed_axes = get(zoomwindow,'CurrentAxes');   usr_dat = get(zoomed_axes,'UserData');   my_hand = usr_dat{2};   clr1 = my_hand{15};   clr2 = my_hand{16};   xyCur1Mat = [];  xyCur2Mat = [];   xyCur1Ctr = 0;   xyCur2Ctr = 0;   cursmatr('cur1_clr')   cursmatr('cur2_clr')   %disp(' ');   %disp('% Stored cursor positions have been cleared %');end