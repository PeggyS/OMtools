% xyplotsettings.m: Called by 'ebAct3D' to provide window with controls% to set XY plot parameters.%% Written by: Jonathan Jacobs%             April 2003 - May 2005 (last mod: 05/11/05)% Files necessary for proper operation:%   'eyeballs3d','ebAct3D.m','datscale.m','d2pt.m','axispad.m',%   'xyplotsettings.m','ebdatacheck.m','ebdataload.m'% 02 Feb 05: added extra cells to wh.wf_axXY 'UserData' field as placeholders%            for the phase plane data arrays to enable stepping through%            the data ONLY AFTER it has been played at least once.% 09 May 05: zillions of little fixes.  added settings for fovea/fov window size.%            'lock'/'free' now properly implemented to prevent constant overwriting%            of user-set titles, x- & y-labels.%            x-, y-limits calculated automatically% 20 Aug 05: Added calculation of axis limits.%            Added automatic recalculation of titles/labels when changing data%            sources.%            (pending) User control over color of foveation limits linefunction xyplotsettings(xy_button)%global rh rv rt lh lv lt st sv samp_freq  %#ok<NUSED>global ebtempresultpersistent xlowtemp xhightemp ylowtemp yhightempgo=gco;% look for the open windowscfig=findwind('Eye Monitor Control');efig=findwind('Eye Monitor');wfig=findwind('Waveform Monitor');xyfig=findwind('XY Plot settings');if ~(ishandle(efig) && ishandle(cfig) && ishandle(wfig))   disp('Missing control window(s).')   returnenddat=ch.availDataH.UserData;rh=dat.rh.pos; rv=dat.rv.pos; rt=dat.rt.pos;%%%lh=dat.lh.pos; lv=dat.lv.pos; lt=dat.lt.pos;g=grapconsts;dkgray=whatcolor(g.DKGRAY);medgray=whatcolor(g.MEDGRAY);orange=whatcolor(g.ORANGE);degstr=char(176);bgcol=[0.75 0.75 0.75];cfig_ht  = 400;cfigpos  = cfig.Position;cfigxctr = cfigpos(1)+cfigpos(3)/2;cfigyctr = cfigpos(2)+cfigpos(4)/2;xyfigpos = [cfigxctr-150 cfigyctr-cfig_ht/2 300 cfig_ht];wh=wfig.UserData{2};% if the XY plot axis (wh.wf_axXY) already has values loaded% use them to set the control values in the XY setting window.% otherwise, start w/default values for XY setting window.ud=wh.wf_axXY.UserData;if isstruct(ud)   xyv=ud{1};   xyh=ud{2};else   xyv.windowtitle = '';   xyv.xdata1  = 1;   xyv.xdata1vel = 0;      xyv.xdata1acc  = 0;   xyv.xdata1label = '';   xyv.xdata1other  = '';   xyv.ydata1 = 2;         xyv.ydata1vel  = 0;   xyv.ydata1acc = 0;      xyv.ydata1label = '';   xyv.ydata1other = '';   xyv.xlowlim = -5;   xyv.xhighlim = 5;       xyv.ylowlim = -5;   xyv.yhighlim = 5;       xyv.line1color = 3;   xyv.line1style = 1;     xyv.head1color = 4;   xyv.head1symbol = 1;    xyv.history = '0.50';   xyv.fplimh = '0.5';     xyv.fplimv = '0.5';   xyv.fvlim = '4.0';      xyv.samp_or_sec = 1;   xyv.wt_locked = 'free';	xyv.xl_locked = 'free';   xyv.yl_locked = 'free';   xyv.x_dat_str = '';   xyv.y_dat_str = '';   xyh=struct();end% 'availchan' based on data loaded in memory% assumption that empty right<->empty left (see eyeballs3d setup)h_str=''; v_str=''; t_str='';if ~all(rh==0), h_str='rh|lh|'; endif ~all(rv==0), v_str='rv|lv|'; endif ~all(rt==0), t_str='rt|lt|'; endtemp=[h_str v_str t_str];availchan=temp(1:end-1);ypos=cfig_ht; xorig=10;if strcmp(xy_button,'initialize')      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   %%%%%%                 set up the controls                %%%%%%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   if ishandle(xyfig)      figure(xyfig)   else      xyfig = figure('Position',xyfigpos, ...         'Name','XY Plot settings','NumberTitle','off', ...         'Resize','off','Menubar','none','Tag','Editing: XY setting');   end      ypos=ypos-30;   uicontrol(xyfig,'Style','Frame','Units','Pixels',...      'BackgroundColor',bgcol,'Position',[5 ypos-8 290 36])   uicontrol(xyfig,'Style','Frame','Units','Pixels',...      'BackgroundColor',bgcol,'Position',[5 ypos-125 290 110])   uicontrol(xyfig,'Style','Frame','Units','Pixels',...      'BackgroundColor',bgcol,'Position',[5 ypos-243 290 115])   uicontrol(xyfig,'Style','Frame','Units','Pixels',...      'BackgroundColor',bgcol,'Position',[5 ypos-332 290 85])      uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','l',...      'Position',[xorig ypos 45 20],'String','Title:');   xyh.windowtitleH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+50 ypos 230 20],'String',xyv.windowtitle,...      'Tag',xyv.wt_locked,...      'Tooltip','Set automatically, unless you manually enter text',...      'Callback',@(hObject,event) lockcheck);      %'Callback',['if(isempty(get(gco,''String''))),'...   %   'set(gco,''Tag'',''free'');'...   %   'else set(gco,''Tag'',''locked''); end']);      % use 'locked/unlocked' tag entry to help determine if text in the   % field was set manually (by the user == 'locked') or automatically   % (by the title calculation code == 'unlocked').   % Clearing the text field will unlock it.   % 'Locked' shouldn't get overwritten by a new calculation, but 'unlocked'   % is fair game. This rule applies to the X and Y label text, too.      % set up the X data controls   ypos=ypos-40;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left',...      'Position',[xorig ypos 45 20],'String','X Data');   xyh.xdata1H = uicontrol('Style','popup','Units','pixels',...      'Position',[xorig+50 ypos 75 20],'String',availchan,...      'Tooltip','Select the X data for XY plot 1',...      'HorizontalAlignment','center','Value',xyv.xdata1,...      'UserData',xyv.xdata1,'Tag','',...      'Callback',@(hObject,event) xyplotsettings('datachange'));   %'Callback','xyplotsettings(''datachange'')');      xyh.xdata1velH = uicontrol(xyfig,'Style','Checkbox',...      'BackgroundColor',bgcol,...      'Position',[xorig+130 ypos 45 20],'UserData',0,...      'Value',xyv.xdata1vel,'Tooltip','Make Xdata1 a velocity',...      'UserData',xyv.xdata1vel,'Tag','','String','Vel.',...      'Callback',@(hObject,event) xyplotsettings('datachange'));      xyh.xdata1accH = uicontrol(xyfig,'Style','Checkbox',...      'BackgroundColor',bgcol,...      'Position',[xorig+180 ypos 45 20],'UserData',0,...      'Value',xyv.xdata1acc,'Tooltip','Make Xdata1 an acceleration',...      'UserData',xyv.xdata1acc,'Tag','','String','Acc.',...      'Callback',@(hObject,event) xyplotsettings('datachange'));      xyh.xdata1otherH = uicontrol('Style','pushbutton','Units','pixels',...      'Position',[xorig+230 ypos 50 20],'String','Other...',...      'Tooltip','Select X data from base workspace.',...      'HorizontalAlignment','center',...      'UserData','','Tag','',...      'Callback',@(hObject,event) xyplotsettings('x_other'));   %'Callback','xyplotsettings(''x_other'')');      ypos=ypos-25;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left',...      'Position',[xorig ypos 45 20],'String','X Label');   xyh.xdata1labelH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+50 ypos 230 20],'String',xyv.xdata1label,...      'Tooltip','Is set automatically, unless you manually enter text',...      'Tag',xyv.xl_locked,...      'Callback',@(hObject,event) lockcheck);   %'Callback',['if(isempty(get(gco,''String''))),'...   %'set(gco,''Tag'',''free'');'...   %'else set(gco,''Tag'',''locked''); end']);   % see note following xyh.windowtitleH.         % set up the Y data controls   ypos=ypos-30;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left',...      'Position',[xorig ypos 45 20],'String','Y Data');   xyh.ydata1H = uicontrol('Style','popup','Units','pixels',...      'Position',[xorig+50 ypos 75 20],...      'String',availchan,...      'Tooltip','Select the Y data for XY plot 1',...      'HorizontalAlignment','right','Value',xyv.ydata1,...      'UserData',xyv.ydata1,'Tag','',...      'Callback',@(hObject,event) xyplotsettings('datachange'));   %'Callback','xyplotsettings(''datachange'')');      xyh.ydata1velH = uicontrol(xyfig,'Style','Checkbox',...      'BackgroundColor',bgcol,...      'Position',[xorig+130 ypos 45 20],'UserData',0,...      'Value',xyv.ydata1vel,'Tooltip','Make Ydata1 a velocity',...      'UserData',xyv.ydata1vel,'Tag','','String','Vel.',...      'Callback',@(hObject,event) xyplotsettings('datachange'));      xyh.ydata1accH = uicontrol(xyfig,'Style','Checkbox',...      'BackgroundColor',bgcol,...      'Position',[xorig+180 ypos 45 20],'UserData',0,...      'Value',xyv.ydata1acc,'Tooltip','Make Ydata1 an acceleration',...      'UserData',xyv.ydata1acc,'Tag','','String','Acc.',...      'Callback',@(hObject,event) xyplotsettings('datachange'));      xyh.ydata1otherH = uicontrol('Style','pushbutton','Units','pixels',...      'Position',[xorig+230 ypos 50 20],'String','Other...',...      'Tooltip','Select Y data from base workspace.',...      'HorizontalAlignment','center',...      'UserData','','Tag','',...      'Callback',@(hObject,event) xyplotsettings('y_other'));   %'Callback','xyplotsettings(''y_other'')');      ypos=ypos-25;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left',...      'Position',[xorig ypos 45 20],'String','Y Label');   xyh.ydata1labelH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+50 ypos 230 20],'String',xyv.ydata1label,...      'Tooltip','Set automatically, unless you manually enter text',...      'Tag',xyv.yl_locked,...      'Callback',@(hObject,event) lockcheck);         % axis limit controls   ypos=ypos-34;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'Position',[xorig ypos 80 20],...      'HorizontalAlignment','left','String','Fov. Pos Lims');      uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'Position',[xorig+65 ypos 30 20],...      'HorizontalAlignment','right','String','hor');   xyh.fplimhH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+100 ypos 40 20],...      'String',xyv.fplimh,'Tooltip','','Callback',[]);      uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'Position',[xorig+140 ypos 30 20],...      'HorizontalAlignment','right','String','vrt');      xyh.fplimvH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+175 ypos 40 20],'String',xyv.fplimv,...      'Tooltip','','Callback',[]);      ypos=ypos-25;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left','String','Fov. Vel Lim',...      'Position',[xorig ypos 80 20]);   xyh.fvlimH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+100 ypos 40 20],'String',xyv.fvlim,...      'Tooltip','','Callback',[]);         ypos=ypos-30;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left','String','X-axis Limits',...      'Position',[xorig ypos 65 20]);      uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','right','String','low',...      'Position',[xorig+70 ypos 27 20]);   xyh.xloH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+100 ypos 40 20],'String',xyv.xlowlim,...      'Tooltip','Calculated automatically, unless you manually enter limit',...      'Callback',@(hObject,event) lockcheck);      uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','right','String','high',...      'Position',[xorig+145 ypos 27 20]);   xyh.xhiH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+175 ypos 40 20],'String',xyv.xhighlim,...      'Tooltip','Calculated automatically, unless you manually enter limit',...      'Callback',@(hObject,event) lockcheck);         ypos=ypos-26;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left','String','Y-axis Limits',...      'Position',[xorig ypos 65 20]);      uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','right','String','low',...      'Position',[xorig+70 ypos 27 20]);   xyh.yloH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+100 ypos 40 20],'String',xyv.ylowlim,...      'Tooltip','Calculated automatically, unless you manually enter limit',...      'Callback',@(hObject,event) lockcheck);      uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','right','String','high',...      'Position',[xorig+145 ypos 27 20]);   xyh.yhiH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+175 ypos 40 20],'String',xyv.yhighlim,...      'Tooltip','Calculated automatically, unless you manually enter limit',...      'Callback',@(hObject,event) lockcheck);   %'Callback',['if(isempty(get(gco,''String''))),'...   %'set(gco,''Tag'',''free'');'...   %'else set(gco,''Tag'',''locked''); end']);   % see note following xyh.windowtitleH.      xyh.autocalcH = uicontrol('Style','pushbutton','Units','pixels',...      'Position',[xorig+220 ypos+6 50 30],'String','Calc',...      'Tooltip','Calculate best axis fit for data',...      'UserData',[xyh.xhiH xyh.xloH xyh.yhiH xyh.yloH],...      'Callback',@(hObject,event) xyplotsettings('calclims'));         % line details (color, style, history)   ypos=ypos-37;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left','String','Line Color',...      'Position',[xorig ypos 50 20]);   xyh.line1colorH = uicontrol('Style','popup','Units','pixels',...      'Position',[xorig+50 ypos 100 20],...      'String',g.geColorStr,...      'Tooltip','Select the color for line 1',...      'HorizontalAlignment','center','Value',xyv.line1color,...      'Callback',[]);      uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left','String','Style',...      'Position',[xorig+155 ypos 30 20]);   xyh.line1styleH = uicontrol('Style','popup','Units','pixels',...      'Position',[xorig+180 ypos 100 20],...      'String',g.geStyleStr,'HorizontalAlignment','center',...      'Tooltip','Select the style for line 1',...      'Value',xyv.line1style,'Callback',[]);      ypos=ypos-25;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left','String','Symbol',...      'Position',[xorig ypos 55 20]);   xyh.head1colorH = uicontrol('Style','popup','Units','pixels',...      'Position',[xorig+50 ypos 100 20],...      'String',g.geColorStr,'HorizontalAlignment','center',...      'Tooltip','Select the color for line 1''s head',...      'Value',xyv.head1color,'Callback',[]);      uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'Position',[xorig+155 ypos 30 20],'String','Type');   xyh.head1symbolH = uicontrol('Style','popup','Units','pixels',...      'Position',[xorig+180 ypos 100 20],...      'String',g.geSymbStr,'HorizontalAlignment','center',...      'Tooltip','Select the symbol for line 1''s head',...      'Value',xyv.head1symbol,'Callback',[]);      ypos=ypos-30;   uicontrol(xyfig,'Style','text','BackgroundColor',bgcol,...      'HorizontalAlignment','left','String','History',...      'Position',[xorig ypos 45 20]);   xyh.historyH = uicontrol('Style','edit','Units','pixels',...      'BackgroundColor','cyan','ForeGroundColor','black',...      'Position',[xorig+50 ypos 75 20],'String',xyv.history,...      'Tooltip','Enter the length of the ''tail''',...      'Callback',[]);   xyh.samp_or_secH = uicontrol('Style','popup','Units','pixels',...      'Position',[xorig+130 ypos 100 20],...      'String','seconds|samples','HorizontalAlignment','center',...      'Tooltip','History in seconds or in samples',...      'Value',xyv.samp_or_sec,'Callback',[]);         % cancel, apply, done   ypos=ypos-30;   xyh.cancelH = uicontrol('Style','pushbutton','Units','pixels',...      'Position',[xorig+10 ypos 75 20],...      'Tooltip','Close and do not apply the settings.',...      'String','Cancel','HorizontalAlignment','center',...      'Callback','close(gcf)');      xyh.applylH = uicontrol('Style','pushbutton','Units','pixels',...      'Position',[xorig+100 ypos 75 20],...      'String','Apply',...      'Tooltip','Apply the settings and leave window open.',...      'HorizontalAlignment','center',...      'Callback',@(hObject,event) xyplotsettings('setvalues'));   %'Callback','xyplotsettings(''setvalues'');');      xyh.doneH = uicontrol('Style','pushbutton','Units','pixels',...      'Position',[xorig+190 ypos 75 20],'String','Done',...      'Tooltip','Apply the settings and close the window.',...      'HorizontalAlignment','center',...      'Callback',@(hObject,event) xyplotsettings('setvalues'));      % embed the handles + 'availchan' in the xywindow's user data.   % so we can access them in the 'setvalues' section   xyfig.UserData={xyv, availchan, xyh};%end      % if contains(xy_button,'other')   % can match 'x_other' or 'y_other'%   get handleselseif contains(xy_button,'other')   % can match 'x_other' or 'y_other'   % use 'gco' to get handle of calling 'other' button.   % open a inputdlg box to get the name of the variable   % store the string result in the 'Tag' of the 'other' button   caller_str=xy_button(1);   callerH=go;      dlg_title='Select from the base workspace';   prompt=['The name of the variable you wish to use as the ',...      upper(caller_str) ' data:'];   tempdlg=inputdlg(prompt,dlg_title);   if isempty(tempdlg), return; end   other_str=tempdlg{1};      % wow is this convoluted!  Create a global variable (ebtempresult) that   % can be accessed in both the function and the base workspace.   % Then see if the name of the variable (e.g. 'lhvf') exists in the base   % workspace.  If it does,'ebtempresult' is set to 1, which can also be   % seen here in 'xyplotsettings'.   evalin('base','global ebtempresult')   ebtempresult=0;   evalin('base',['ebtempresult = exist(' '''' other_str '''' ',''var'');'],...      'disp(''error'')')      if ebtempresult>0      % good variable      % find its max and min.  store the values in 'UserData' of the button      maxval = max(eval(other_str));      minval = min(eval(other_str));      callerH.Tag=other_str;      callerH.String=['"' other_str '"']; %%%???%%%???%%%      callerH.UserData=[minval maxval];   else      % failed      callerH.Tag='';      callerH.String='Other...';   end   clear global ebtempresult      elseif strcmp(xy_button,'datachange')   % called any time the data selection controls are activated.  Check to   % see if the data being represented has changed.  If so, set a flag(?)   % and/or rerun 'calclims'?  Set xlabel, ylabel , title edit fields to 'free'.   % Set new value for the control in the 'UserData' field for next comparison.   % Rerun 'setvalues'?   xyh = xyfig.UserData{3};   lastval=go.UserData;   curval=go.Value;   if curval==lastval, return; end   go.UserData=curval;   %%%datachangeflag=1;   xyh.windowtitleH.Tag='free';   xyh.xdata1labelH.Tag='free';   xyh.ydata1labelH.Tag='free';   xyplotsettings('setvalues')   xyplotsettings('calclims')      elseif strcmp(xy_button,'calclims')   xyh = xyfig.UserData{3};      if isempty(xlowtemp) || isnan(xlowtemp),  xlowtemp=-5; end   if isempty(xhightemp)|| isnan(xhightemp), xhightemp=5; end   if isempty(ylowtemp) || isnan(ylowtemp),  ylowtemp=-5; end   if isempty(yhightemp)|| isnan(yhightemp), yhightemp=5; end      xlowlim = xlowtemp; xhighlim = xhightemp;   ylowlim = ylowtemp; yhighlim = yhightemp;   [xmincalc, xmaxcalc] = axispad(xlowlim, xhighlim);   [ymincalc, ymaxcalc] = axispad(ylowlim, yhighlim);      xyv.autocalc = xyh.autocalcH;   temp = xyh.autocalcH.UserData;   xyh.xhiH=temp(1); xyh.xloH=temp(2);   xyh.yhiH=temp(3); xyh.yloH=temp(4);      xyh.xloH.String=num2str(xmincalc,'%5.1f');   xyh.xhiH.String=num2str(xmaxcalc,'%5.1f');   xyh.yloH.String=num2str(ymincalc,'%5.1f');   xyh.yhiH.String=num2str(ymaxcalc,'%5.1f');   wh.wf_axXY.XLim=[xmincalc xmaxcalc];   wh.wf_axXY.YLim=[ymincalc ymaxcalc];   xyfig.UserData{3}=xyh;      elseif strcmp(xy_button,'setvalues')   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   %%%%%%           read the controls & store                %%%%%%   %%%%%%           their values in the XY axis              %%%%%%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   xyv=xyfig.UserData{1};   availchan=xyfig.UserData{2};   xyh=xyfig.UserData{3};      chan_list=textscan(availchan,'%s','delimiter','|');      windowtitle = xyh.windowtitleH.String;      xyv.wt_locked = xyh.windowtitleH.Tag;   xyv.xl_locked = xyh.xdata1labelH.Tag;   xyv.yl_locked = xyh.ydata1labelH.Tag;      xyv.xdata1    = xyh.xdata1H.Value;   xyv.xdata1vel = xyh.xdata1velH.Value;   xyv.xdata1acc   = xyh.xdata1accH.Value;   xyv.xdata1label = xyh.xdata1labelH.String;   xyv.xdata1other = xyh.xdata1otherH.Tag;      xyv.ydata1      = xyh.ydata1H.Value;   xyv.ydata1vel   = xyh.ydata1velH.Value;   xyv.ydata1acc   = xyh.ydata1accH.Value;   xyv.ydata1label = xyh.ydata1labelH.String;   xyv.ydata1other = xyh.ydata1otherH.Tag;      fplimh = str2double(xyh.fplimhH.String);   fplimv = str2double(xyh.fplimvH.String);   fvlim  = str2double(xyh.fvlimH.String);      xyv.line1color  = xyh.line1colorH.Value;   xyv.line1style  = xyh.line1styleH.Value;   xyv.head1color  = xyh.head1colorH.Value;   xyv.head1symbol = xyh.head1symbolH.Value;      xyv.history     = xyh.historyH.String;   xyv.samp_or_sec = xyh.samp_or_secH.Value;      % Dynamically place the string results into   % the XY plot's title, x- and y-label strings.   titleH = wh.wf_axXY.Title;   yLabH  = wh.wf_axXY.YLabel;   xLabH  = wh.wf_axXY.XLabel;      % Normally, we just get the channel name from the 'xdata1' popup menu, and   % read the 'xyv.xdata1vel' and 'xyv.xdata1acc' checkboxes to determine pos/vel/acc.   % We pass this info along in x/y_dat_str and also use to calc title, x,y labels.   % However, if the 'other' button (x/xyv.ydata1other) has an string (name of a   % variable), pass it along to 'ebAct3D' in x/y_dat_str, e.g. 'lhvf_other'.   % Make an attempt to parse it for eye/plane/deriv so we can set   % the title and x,y labels of the XY plot. If we can't, well too bad.   if isempty(xyv.xdata1other)      x_eye = chan_list{1}{xyv.xdata1}(1);      x_dir = chan_list{1}{xyv.xdata1}(2);      if strcmp(x_eye,'l'), x_eye='Left Eye'; else, x_eye='Right Eye'; end      switch x_dir         case 'h', x_dir='Horizontal';         case 'v', x_dir='Vertical';         case 't', x_dir='Torsional';      end      % do we want its velocity, or its accel?      x_unit_str = ['Pos (' degstr ')'];      if xyv.xdata1vel, x_unit_str = ['Vel (' degstr '/sec)'];   end      if xyv.xdata1acc, x_unit_str = ['Accel (' degstr '/sec^2)']; end      xyv.x_dat_str = lower([x_eye(1) x_dir(1) ',' x_unit_str(1:3)]);  % e.g. 'lh,pos'            % finally, find the max and min values for the selected data      % x_chan{1} contains the name of the selected data.      temp = eval(chan_list{1}{xyv.xdata1});      if xyv.xdata1vel, temp=d2pt(temp,2); end      if xyv.xdata1acc, temp=d2pt(temp,2); temp=d2pt(temp,2); end      xhightemp=max(temp); xlowtemp=min(temp);               else      % we're just guessing here.  Hoping that the user has made an attempt      % to name the 'other' data in a reasonable way.  By 'reasonable' we      % assume that 1st letter is eye, 2nd letter is plane.  For 3rd letter it      % gets a little tricky, as it could be a vel (or acc), if the user wanted      % to differentiate with a value other than the default of '2', but it could      % instead be something else, like 'f' for filtered data, or what-have-you.      % Basically, if it's not 'v' or 'a' there's not much to do.      x_eye = xyv.xdata1other(1);      if length(xyv.xdata1other)>=2, x_dir=xyv.xdata1other(2); else, x_dir=''; end      if length(xyv.xdata1other)>=3, x_3rd=xyv.xdata1other(3); else, x_3rd=''; end            xlowtemp = xyh.xdata1otherH.UserData(1);      xhightemp = xyh.xdata1otherH.UserData(1);            switch lower(x_eye)         case  'l', x_eye='Left Eye';         case  'r', x_eye='Right Eye';         otherwise, x_dir='???';      end      switch lower(x_dir)         case  'h', x_dir='Horizontal';         case  'v', x_dir='Vertical';         case  't', x_dir='Torsional';         otherwise, x_dir='???';      end      switch lower(x_3rd)         case   'v', x_unit_str = ['Vel (' degstr '/sec)'];         case   'a', x_unit_str = ['Accel (' degstr '/sec^2)'];         otherwise , x_unit_str = ['Pos (' degstr ')'];      end      xyv.x_dat_str = lower([xyv.xdata1other ',other']);   end      % do the y axis data now   if isempty(xyv.ydata1other)      y_eye = chan_list{1}{xyv.ydata1}(1);      y_dir = chan_list{1}{xyv.ydata1}(2);      if strcmp(y_eye,'l'), y_eye='Left Eye'; else, y_eye='Right Eye'; end      switch y_dir         case 'h', y_dir='Horizontal';         case 'v', y_dir='Vertical';         case 't', y_dir='Torsional';      end            % do we want its velocity, or its accel?      y_unit_str=['Pos (' degstr ')'];      if xyv.ydata1vel, y_unit_str=[  'Vel (' degstr '/sec)'  ]; end      if xyv.ydata1acc, y_unit_str=['Accel (' degstr '/sec^2)']; end            if isempty(xyv.ydata1other)         xyv.y_dat_str=lower([y_eye(1) y_dir(1) ',' y_unit_str(1:3)]);  % e.g. 'rv,vel'      else         xyv.y_dat_str=lower([xyv.ydata1other ',other']);      end            temp = eval(chan_list{1}{xyv.ydata1});      if xyv.ydata1vel, temp=d2pt(temp,2); end      if xyv.ydata1acc, temp=d2pt(temp,2); temp=d2pt(temp,2); end      yhightemp = max(temp); ylowtemp = min(temp);               else      y_eye = xyv.ydata1other(1);      if length(xyv.ydata1other)>=2, y_dir=xyv.ydata1other(2); else, y_dir=''; end      if length(xyv.ydata1other)>=3, y_3rd=xyv.ydata1other(3); else, y_3rd=''; end            temp = xyh.ydata1otherH.UserData;      ylowtemp = temp(1); yhightemp = temp(2);            switch lower(y_eye)         case  'l', y_eye='Left Eye';         case  'r', y_eye='Right Eye';         otherwise, y_dir='???';      end      switch lower(y_dir)         case  'h', y_dir='Horizontal';         case  'v', y_dir='Vertical';         case  't', y_dir='Torsional';         otherwise, y_dir='???';      end      switch lower(y_3rd)         case   'v', y_unit_str=['Vel (' degstr '/sec)'];         case   'a', y_unit_str=['Accel (' degstr '/sec^2)'];         otherwise , y_unit_str=['Pos (' degstr ')'];      end      xyv.y_dat_str=lower([xyv.ydata1other ',other']);   end         %%%%%   Calculate the title string, x- and y-label strings  %%%%   plot_type='unknown';   if strcmp(x_eye,y_eye)   % same eye for x,y could be SP or PP      which_eye=x_eye;      % could have said 'y_eye'            if strcmp(x_dir,y_dir)  % do a phase plane         which_dir=x_dir;     % could have said 'y_dir'                  % only makes sense if different units         if strcmp(x_unit_str,y_unit_str)            windowstr=['???: ' which_eye ',' which_dir];         else            windowstr=['Phase Plane: ' which_eye ',' which_dir];            plot_type='phaseplane';         end         xlabelstr=x_unit_str;         ylabelstr=y_unit_str;               else                   % do a scanpath         % only makes sense if SAME units         which_dir='';         if strcmp(x_unit_str,y_unit_str)            windowstr=['Nystagmus Scanpath: ' which_eye];            plot_type='scanpath';         else            windowstr=['???: ' which_eye];         end         xlabelstr=[x_dir ' ' x_unit_str];         ylabelstr=[y_dir ' ' y_unit_str];      end         else                	   % must be a conjugacy plot      which_dir=x_dir;      % could have said 'y_dir'      % only makes sense if SAME units      if strcmp(x_unit_str,y_unit_str) && strcmp(x_dir,y_dir)         windowstr=['Conjugacy Plot: ' which_dir];         plot_type='conjugacy';      else         windowstr='????: ';      end      xlabelstr=[x_eye ' ' x_unit_str];      ylabelstr=[y_eye ' ' y_unit_str];         end      % if we still don't have x,y limits set, use default +/-5 values.   xlowNum  = str2double(xyh.xloH.String);   if isempty(xlowNum)||isnan(xlowNum), xlowNum=-5; end   xhighNum = str2double(xyh.xhiH.String);   if isempty(xhighNum)||isnan(xhighNum), xhighNum=5; end   ylowNum  = str2double(xyh.yloH.String);   if isempty(ylowNum)||isnan(ylowNum), ylowNum=-5; end   yhighNum = str2double(xyh.yhiH.String);   if isempty(yhighNum)||isnan(yhighNum), yhighNum=5; end      % make axes pretty...   xyh.xloH.String=num2str(xlowNum,'%5.1f');   xyh.xhiH.String=num2str(xhighNum,'%5.1f');   xyh.yloH.String=num2str(ylowNum,'%5.1f');   xyh.yhiH.String=num2str(yhighNum,'%5.1f');   wh.wf_axXY.XLim=[xlowNum xhighNum];   wh.wf_axXY.YLim=[ylowNum yhighNum];      figure(wfig); subplot(wh.wf_axXY)   % clear out the previous (if any) fov extent, conjugacy lines, or fov window   % NaN out the wf_dataXY and wf_overXY lines   xyplot_tempH=findobj('Tag','xyplot_temp');   delete(xyplot_tempH)   datalinesH=wh.wf_axXY.Children;   datalinesH.XData=NaN;   datalinesH.YData=NaN;        % lines for the X and Y axes -- color will be a saved pref?   line([-9999 9999 NaN 0 0],[0 0 NaN -9999 9999],...      'Color',dkgray.rgb,'Tag','xyplot_temp');      % pick the correct limits for fovea   if strcmp(which_dir,'Horizontal')      fplim=fplimh;   elseif strcmp(which_dir,'Vertical')      fplim=fplimv;   elseif strcmp(which_dir,'Torsional')      fplim=sqrt(fplimh^2 + fplimv^2);   else         end      % add the fovea/foveation window appropriate to the xy plot being made   if strcmp(plot_type,'phaseplane')      % draw foveation window      line(...         [-fplim    fplim   fplim   -fplim   -fplim], ...         [-fvlim   -fvlim   fvlim    fvlim   -fvlim],...         'Color',medgray.rgb,'LineStyle','--','Tag','xyplot_temp');         elseif strcmp(plot_type,'scanpath')      % draw a foveal extent      x=fplimh*cos(-0.1:0.1:2*pi);      y=fplimv*sin(-0.1:0.1:2*pi);      line(x,y,'Color',dkgray.rgb,'LineStyle','-.','Tag','xyplot_temp');               elseif strcmp(plot_type,'conjugacy')      x=fplimh*cos(-0.1:0.1:2*pi);      y=fplimv*sin(-0.1:0.1:2*pi);      line(x,y,'Color',orange.rgb,'LineStyle','-.','Tag','xyplot_temp');      % draw 45, 135 degree lines (x=y)      line([-9999 9999 NaN -9999 9999],[-9999 9999 NaN 9999 -9999],...         'Color',medgray.rgb,'LineStyle','--','Tag','xyplot_temp');   end   figure(xyfig)         % set the axis title and the x,y labels   % if we set the xyplotsetting title,x,y fields here, set the tag to 'free'   % so that we know it was NOT the user who entered the text, but the auto   % calculation that did.   if isempty(windowtitle) || strcmp(xyh.windowtitleH.Tag,'free')      titleH.String=windowstr;      xyh.windowtitleH.String=windowstr;      xyh.windowtitleH.Tag='free';   else      titleH.String=windowtitle;   end      if isempty(xyv.xdata1label) || strcmp(xyh.xdata1labelH.Tag,'free')      xLabH.String=xlabelstr;      xyh.xdata1labelH.String = xlabelstr;      xyh.xdata1labelH.Tag='free';   else      xLabH.String=xyv.xdata1label;   end      if isempty(xyv.ydata1label) || strcmp(xyh.ydata1labelH.Tag,'free')      yLabH.String=ylabelstr;      xyh.ydata1labelH.String=ylabelstr;   else      yLabH.String=xyv.ydata1label;      yLabH.Tag='free';   end      % store the control values + x,y selections in the XY axis user data.   xyv.xlowlim=xyh.xloH.String;  xyv.xhighlim=xyh.xhiH.String;   xyv.ylowlim=xyh.yloH.String;  xyv.yhighlim=xyh.yhiH.String;   xyv.playedyet=1;endif strcmpi(go.String,'Done')   %pause(0.5)   close(xyfig)   returnend%update the axis XY buttonwh.wf_axXY.UserData={xyv,xyh};end %function xyplotsettings%%%%%%%%%%function lockcheckgo=gco;if isempty(go.String)   go.Tag='free';else   go.Tag='locked';endend %function lockcheck