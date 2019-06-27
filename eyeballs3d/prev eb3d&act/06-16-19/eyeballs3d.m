% eyeballs3D: draws a pair of eyeballs and animates them using% eye movement data in memory. The data must be composed of up% to six equal-length vectors (lh, lv, lt, rh, rv, rt) that must% be declared as global variables before they are read in. Additionally,% the sampling frequency, 'samp_freq' must also be a global variable.% Optionally, if there are horizontal and vertical stimuli data,% they can be displayed in their respective planes by making 'st' and 'sv'% global variables, too.% Written by: Jonathan Jacobs%             March 2002 - May 2005 (last mod: 05/13/05)% Files necessary for proper operation:%   'eyeballs3d', 'ebAct3D.m', 'datscale.m', 'd2pt.m',%   'axispad.m', 'xyplotsettings.m', 'ebdatacheck.m'%%% Major updates and fixes:% 27 Nov 02: Added alignment crosshairs. May eventually make them%  2 Dec 02: Added 'h.crossH' variable; allow turning crosshairs on/off%            The wform, monitor and control windows created at proper size,%              rather than resizing them after creation.% 29 May 03: Massive redesign of GUI, relocation of many controls%            Added user-customizable XY plot settings.%            'play' reads settings from XY plot's axis and applies values%              to XY plot playback%  2 Jun 03: Major revision now allows loading of new data w/o having to%              close and re-run 'eyeballs3d'%  5 Jun 03: User can now select arrays from the base workspace for XY plot% 16 Jul 03: Added optional display of stimulus data% 14 Oct 03: Added rubberband zoom% 12 Jan 05: Rewrote movie making code, prefs. reorganized movie prefs.%            Render animation using 'zbuffer' workaround for 'OpenGL' bug.%            User can now specify QT (if available), AVI, or series of JPEGs% 21 Jan 05: Eyeball and waveform windows are now easily resizable via%              slider/text box controls% 28 Jan 05: Thanks to effing Microsoft's crap handling of non-native graphics%					and movie formats, eyeballs now can be rendered w/o grid lines%              so the drastically reduced quality in PowerPoint is not as easily%              noticable.% 09 May 05: Zillions of little fixes. changed wf window axes positions and%					sizes for appearance improvement at smaller window sizes.%              see ebact3d and xyplotsettings for more extensive improvements%% June 2019: Updated for HG2. Cleaned and optimized. Added live scrolling%              to the sliders.function eyeballs3d(~)%%global samp_freqf_size=11;bgcol=[0.75 0.75 0.75];buttcol=[0.85 0.85 0.85];g=grapconsts;% look for the open windowscfig=findwind('Eye Monitor Control');efig=findwind('Eye Monitor');wfig=findwind('Waveform Monitor');%pfig=findwind('Preferences');%sfig=findwind('Data Scaling & Offset');%xyfig=findwind('XY Plot settings');if ishandle(efig) && ishandle(cfig) && ishandle(wfig)   figure(cfig);   returnend% center the three windows we are about to create (if not using saved pos)scrsize=get(0,'ScreenSize');initpos=[fix((scrsize(3)-914)/2), fix((scrsize(4)-535)/2)]; % centered% look for a preference file.% if there is no 'omPrefs' folder in the MATLAB root, we will% create one and also create a prefs file.cur_dir = pwd;gp_err=0;try    cd(pathsafe(findomprefs))catch, gp_err=1;endif gp_err % must make a omprefs directory   mkdir('omprefs')   cd('omprefs')end% default pref valuesefigpos=[initpos+[0 244] 570 264];cfigpos=[initpos+[44 -50] 540 230];wfigpos=[initpos+[600 0] 300 507];wf_center=[initpos/2+450,initpos/2+253];eb_size=1;wf_size=1;eyeliner=0;eyelight=1;% default prefspr.btxtstr   = 'Click "ID text" to customize';pr.btxtsize  = 10;pr.btxtcolor = [0 0 1];pr.movieformat  = 1;  % 1=MPEG4, 2=AVIpr.moviequality = 0.75;pr.movie_fps    = 30;pr.movie_speed  = 1;pr.wfigBG   = 0; % 0=g.rgb(g.OFFWHITE); 1='black'pr.eyeColor = g.rgb{g.CORNFLOWER};pr.rhColor = [0 0 1];pr.rvColor = [0 0 1];pr.rtColor = [0 0 1];pr.lhColor = [0 1 0];pr.lvColor = [0 1 0];pr.ltColor = [0 1 0];pr.stColor = [1 0 0];pr.svColor = [1 0 0];% if there is not a good pref file, create one w/the default valuestry    load ebPrefs.mat efigpos cfigpos wfigpos wf_center ...      pr eb_size wf_size eyeliner eyelightcatch   disp('Pref file goof! No worries -- I shall fix')   save ebPrefs.mat efigpos cfigpos wfigpos wf_center ...      pr eb_size wf_size eyeliner eyelightendif exist(cur_dir,'dir'),cd(cur_dir);end%%%%%  really should do this in ebAct3d load data% is there good data loaded into memory?[status,datlen,noHOR,noVRT,noTOR,noSTM]=ebdatacheck;if status==0   disp('Reading in valid data...')   emdm=findwind('EM Data');   if ishandle(emdm)      emdm.RunningAppInstance.outside_call_to_add_data;   else      rd   end   [status,datlen,noHOR,noVRT,noTOR,noSTM]=ebdatacheck;   if status==0, disp('not valid data. RTFM.'); return; endendif noHOR, plotHorEnab='off'; else, plotHorEnab='on'; endif noVRT, plotVrtEnab='off'; else, plotVrtEnab='on'; endif noTOR, plotTorEnab='off'; else, plotTorEnab='on'; endif noSTM, plotStmEnab='off'; else, plotStmEnab='on'; end% *********************************% *********************************% **       open your eyes!       **% *********************************% *********************************%%      Make Eyeballs window% 01/14/05: changed 'renderer' to 'zbuffer' because 'opengl' is broken.efig = figure('Position',efigpos,'Color',bgcol, ...   'Name','Eye Monitor','NumberTitle','off', ...   'DeleteFcn',@(src,eventdata) ebAct3D('done!'), ...   'Renderer','zbuffer','Resize','off',...   'Menubar','none','Tag','Eyeballs3D: uneditable');%set(efig,'backingstore','off')% easier and more reliable than using 'subplot' command% which causes all sorts of hilarity: axes disappear. Really!eh.odSocket = axes('Position',[0.025 0.05 0.45 0.87],'Visible','off');eh.osSocket = axes('Position',[0.536 0.05 0.45 0.87],'Visible','off');eh.badge    = axes('Position',[0.0 0.95 0.1 0.05],'Visible','off');eh.overlay  = axes('Position',[0.025 0.05 0.95 0.87],'Visible','off');% pr.eyeColor was loaded earlier, or was set to default color%mrkrFClr = min([1 1 1], 1.25*pr.eyeColor);%mrkrEClr = max([0 0 0], 0.8*pr.eyeColor);mrkrEClr = [1 0 0];mrkrFClr = [1 0 0];visStr = {'off','on'};%v_viewoff = 10;hor=0; vrt=0; %tor=0;% plot the text ID badgeaxes(eh.badge)axis off%if ~exist('btxtstr','var') || isempty(btxtstr)%   btxtstr='(c) DD\_OMLAB';%endeh.btxt=text(0.05,0.2,pr.btxtstr);eh.btxt.FontSize=pr.btxtsize;eh.btxt.Color=pr.btxtcolor;ebmap = ones(128,3);if eb_size >= 0.8   % bigger eyeball and its torsion triangle vertices   [z,y,x]=sphere(40);   a=[x(32,31) x(32,21) x(32,11) x(32,1)];   b=[y(32,31) y(32,21) y(32,11) y(32,1)];   c=[z(32,31) z(32,21) z(32,11) z(32,1)];   ebmap(127:128,:)=zeros(2,3);   ebmap(119:126,1)=pr.eyeColor(1);   ebmap(119:126,2)=pr.eyeColor(2);   ebmap(119:126,3)=pr.eyeColor(3);elseif eb_size >= 0.5   % medium eyeball and its torsion triangle vertices   [z,y,x]=sphere(24);   a=[x(20,19) x(20,13) x(20,7) x(20,1)];   b=[y(20,19) y(20,13) y(20,7) y(20,1)];   c=[z(20,19) z(20,13) z(20,7) z(20,1)];   ebmap(126:128,:)=zeros(3,3);   ebmap(117:125,1)=pr.eyeColor(1);   ebmap(117:125,2)=pr.eyeColor(2);   ebmap(117:125,3)=pr.eyeColor(3);endebmap(ebmap>1)=1;ebmap(ebmap<0)=0;efig.Colormap=ebmap;% put the right eye in its socketaxes(eh.odSocket)eh.od=surf(x,y,z,x);if eyeliner==0   eh.od.LineStyle='none';else   eh.od.LineStyle='-';endeh.od.UserData=pr.eyeColor;eh.odSocket.View=[hor+90 vrt];eh.odSocket.UserData=0;axis equal; axis offaxis vis3dhold oneh.odMrkr=plot3(a,b,c,'Markersize',10,'Marker','diamond','MarkerSize',6,...   'LineStyle','none','Visible',visStr{~noTOR+1},...   'MarkerFaceColor',mrkrFClr,'MarkerEdgeColor',mrkrEClr);odLightH=0;if eyelight==1   odLightH=camlight(0, 10);   %odLight2 = camlight(0, 20);endmaterial('dull')lighting('gouraud')% put the left eye in its socketaxes(eh.osSocket)eh.os=surf(x,y,z,x);if eyeliner==0   eh.os.LineStyle='none';else   eh.os.LineStyle='-';end%set(os,'CData',cdata);eh.os.UserData=pr.eyeColor;eh.osSocket.View=[hor+90 vrt];eh.osSocket.UserData=0;axis equal; axis offaxis vis3dhold oneh.osMrkr=plot3(a,b,c,'MarkerSize',10,...   'LineStyle','none','Visible',visStr{~noTOR+1},...   'Marker','diamond','MarkerSize',6,...   'MarkerFaceColor',mrkrFClr,'MarkerEdgeColor',mrkrEClr);osLightH=0;if eyelight==1   osLightH=camlight(0, 10);endmaterial dulllighting('gouraud')% draw alignment crosshairs (added 11/27/02)axes(eh.overlay)hold onaxis offaxis([0 1  0 1])% the middle of each pupil. (majick numbers)ODctr = [0.2375, 0.5];OSctr = [0.776 , 0.5];hLen = 0.035;vLen = 0.085;% draw the horizontals...chLineH(1) = line([ODctr(1)-hLen ODctr(1)+hLen], [ODctr(2) ODctr(2)],'Color','y');chLineH(2) = line([OSctr(1)-hLen OSctr(1)+hLen], [OSctr(2) OSctr(2)],'Color','y');% ...and the verticalschLineH(3) = line([ODctr(1) ODctr(1)], [ODctr(2)-vLen ODctr(2)+vLen],'Color','y');chLineH(4) = line([OSctr(1) OSctr(1)], [OSctr(2)-vLen OSctr(2)+vLen],'Color','y');efig.UserData=eh;% ********************************************% ********************************************% **       create the controls window       **% ********************************************% ********************************************%%      Make Controls windowcfig = figure('Resize','off','Position',cfigpos, ...   'Name','Eye Monitor Control','NumberTitle','off', ...   'Menubar','none','Tag','Eyeballs3D control',...   'DeleteFcn',@(src,eventdata) ebAct3D('done!'));% framescfig_height = cfigpos(4);uicontrol(cfig,'Style','Frame','Units','pixels',...   'BackgroundColor',bgcol,'Position',[4 cfig_height-110 370 107])uicontrol(cfig,'Style','Frame','Units','pixels',...   'BackgroundColor',bgcol,'Position',[377 cfig_height-110 159 107])uicontrol(cfig,'Style','Frame','Units','pixels',...   'BackgroundColor',bgcol,'Position',[4 cfig_height-175 310 58])uicontrol(cfig,'Style','Frame','Units','pixels',...   'BackgroundColor',bgcol,'Position',[318 cfig_height-200 218 83])% Zoomy_pos=cfig_height-25;ch.aboutBH = uicontrol(cfig,'Style','Pushbutton',...   'Position',[10 y_pos-1 50 17],'UserData',0,...   'BackGroundColor',buttcol,'Fontsize',f_size,...   'Tooltip','Who did this?','String','About...',...   'Callback',@(src,eventdata) ebAct3D('about'));ch.rbzoomH = uicontrol(cfig,'Style','checkbox',...   'Position',[100 y_pos-4 140 20],'UserData',0,...   'BackGroundColor',bgcol,...   'Value',0,'Tooltip','Activate "Rubber Band" zooming',...   'String','WF zoom is OFF','Callback',@(src,eventdata) ebAct3D('rbzoom'));%%%%%   time/sample controls   %%%%%y_pos=y_pos-5;uicontrol(cfig,'Style','text','Fontsize',f_size, ...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[315 y_pos 50 20],'String','Time');uicontrol(cfig,'Style','text','Fontsize',f_size, ...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[260 y_pos 50 20],'String','Sample');y_pos=y_pos-25;uicontrol(cfig,'Style','text','Fontsize',f_size, ...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[10 y_pos 45 20],'String','Start');ch.start_sli = uicontrol(cfig,'Style','slider',...   'Position',[ 57 y_pos 200 20],...   'Min',1,'Max',datlen,'Value',1,'Visible','on',...   'Tooltip','Set the start time',...   'Callback',@(src,eventdata) ebAct3D('start_sli'));addlistener(ch.start_sli,'ContinuousValueChange',...   @(hObject,event) ebAct3D('start_sli'));ch.start_txt = uicontrol(cfig,'Style','edit',...   'Position',[260 y_pos 50 20],'Fontsize',f_size, ...   'String',num2str(ch.start_sli.Value),...   'BackGroundColor','cyan','ForeGroundColor','black',...   'Tooltip','Set the start time (samples)',...   'Callback',@(src,eventdata) ebAct3D('start_txt'));ch.start_txt2 = uicontrol(cfig,'Style','edit',...   'Position',[315 y_pos 50 20],'Fontsize',f_size, ...   'String',num2str(ch.start_sli.Value/samp_freq,3),...   'BackGroundColor','cyan','ForeGroundColor','black',...   'Tooltip','Set the start time (seconds)',...   'Callback',@(src,eventdata) ebAct3D('f_h.start_txt'));y_pos=y_pos-25;uicontrol(cfig,'Style','text','Fontsize',f_size, ...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[10 y_pos 45 20],'String','Stop');ch.stop_sli = uicontrol(cfig,'Style','slider',...   'Position',[ 57 y_pos 200 20],...   'Min',1,'Max',datlen,'Value',datlen,...   'Visible','on','Tooltip','Set the stop time',...   'Callback',@(src,eventdata) ebAct3D('stop_sli'));addlistener(ch.stop_sli,'ContinuousValueChange',...   @(hObject,event) ebAct3D('stop_sli'));ch.stop_txt = uicontrol(cfig,'Style','edit',...   'Position',[260 y_pos 50 20],'Fontsize',f_size, ...   'String',num2str(ch.stop_sli.Value),...   'BackGroundColor','cyan','ForeGroundColor','black',...   'Tooltip','Set the stop time (samples)',...   'Callback',@(src,eventdata) ebAct3D('stop_txt'));ch.stop_txt2 = uicontrol(cfig,'Style','edit',...   'Position',[315 y_pos 50 20],'Fontsize',f_size, ...   'String',num2str(ch.stop_sli.Value/samp_freq,3),...   'BackGroundColor','cyan','ForeGroundColor','black',...   'Tooltip','Set the stop time (seconds)',...   'Callback',@(src,eventdata) ebAct3D('f_h.stop_txt'));y_pos=y_pos-25;uicontrol(cfig,'Style','text','Fontsize',f_size, ...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[10 y_pos 45 20],'Fontsize',f_size,'String','Current');ch.cur_sli = uicontrol(cfig,'Style','slider',...   'Position',[ 57 y_pos 200 20],...   'Min',1,'Max',datlen,'Value',1,'Visible','on',...   'Tooltip','Shows the current point in the animation',...   'Callback',@(src,eventdata) ebAct3D('cur_sli'));addlistener(ch.cur_sli,'ContinuousValueChange',...   @(hObject,event) ebAct3D('cur_sli'));ch.cur_txt = uicontrol(cfig,'Style','edit',...   'Position',[260 y_pos 50 20],'Fontsize',f_size, ...   'String',num2str(ch.cur_sli.Value),...   'BackGroundColor','c','ForeGroundColor','k',...   'Tooltip','Shows the current point in the animation (samples)',...   'Callback',@(src,eventdata) ebAct3D('cur_txt'));ch.cur_txt2 = uicontrol(cfig,'Style','edit',...   'Position',[315 y_pos 50 20],'Fontsize',f_size, ...   'String',num2str(ch.cur_sli.Value/samp_freq,3),...   'BackGroundColor','c','ForeGroundColor','k',...   'Tooltip','Shows the current point in the animation (seconds)',...   'Callback',@(src,eventdata) ebAct3D('cur_txt'));%%%%%   play/movie/misc controls   %%%%%y_pos=cfig_height-30;ch.livemonBH = uicontrol(cfig,'Style','checkbox',...   'Position',[430 y_pos 100 20],'Value',1,...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Tooltip','Update the waveform window during play',...   'Fontsize',f_size,'String','Live Waveform','Callback',[]);y_pos=y_pos-25;uicontrol(cfig,'Style','text','Fontsize',f_size, ...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[385 y_pos 110 20],'String','Play each nth frame:');ch.decimateH = uicontrol(cfig,'Style','edit','Position',[500 y_pos 30 20],...   'BackGroundColor','cyan','ForeGroundColor','k',...   'Tooltip','Play every nth point','Fontsize',f_size, ...   'String',num2str(fix(samp_freq/25)),...   'Callback',@(src,eventdata) ebAct3D('speed_d'));y_pos=y_pos-25;uicontrol(cfig,'Style','text','Fontsize',f_size, ...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[380 y_pos 115 20],'String','Playback Speed (fps):');ch.fpsH = uicontrol(cfig,'Style','edit','Position',[500 y_pos 30 20],...   'BackGroundColor','cyan','ForeGroundColor','k',...   'Tooltip','Set the frames/second','Fontsize',f_size, ...   'String',num2str(fix(25)),'Callback',@(src,eventdata) ebAct3D('speed_f'));%%% Movie checkboxesy_pos=y_pos-25;uicontrol(cfig,'Style','text','Fontsize',f_size, ...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[385 y_pos 40 20],'String','Movie:');ch.eb_movieBH = uicontrol(cfig,'Style','checkbox',...   'Position',[428 y_pos 50 20],'Value',0,...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Tooltip','Save the eyeball animation as a movie',...   'Fontsize',f_size,'String','Eyes','Callback',[]);ch.wf_movieBH = uicontrol(cfig,'Style','checkbox',...   'Position',[480 y_pos 50 20],'Value',0,...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Tooltip','Save the waveform animation as a movie',...   'Fontsize',f_size,'String','Data','Callback',[]);y_pos=cfig_height-143; x_pos=325;buttWid=65; buttSep1=69; buttSep2=138;ch.plotXYh = uicontrol(cfig,'Style','CheckBox','Units','pixels',...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[x_pos y_pos-25 buttWid 20],'Value',0,...   'Fontsize',f_size,'String','XY Plot','UserData','control',...   'Tooltip','Plot phase plane data in the waveform monitor',...   'Callback',@(src,eventdata) ebAct3D('wf_draw'));plotXY=ch.plotXYh.Value;ch.xysetBH = uicontrol(cfig,'Style','Pushbutton',...   'Position',[x_pos+buttSep1 y_pos-25 buttWid 20],'UserData',0,...   'ForeGroundColor','k','BackGroundColor',buttcol,...   'Tooltip','XY plot settings','Fontsize',f_size,'String','XY Setup',...   'Callback',@(src,eventdata) ebAct3D('xy_setup'));ch.plotSTMh = uicontrol(cfig,'Style','Checkbox','String','Plot Stm',...   'Position',[x_pos y_pos-50 buttWid 20],'UserData',chLineH,...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Value',~noSTM, 'Enable', plotStmEnab,'Fontsize',f_size, ...   'Tooltip','Plot stimulus data in the waveform monitor',...   'Callback',@(src,eventdata) ebAct3D('wf_draw'));ch.crossH = uicontrol(cfig,'Style','Checkbox','String','C Hairs',...   'Position',[x_pos+buttSep1 y_pos-50 buttWid 20],'UserData',chLineH,...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Value',1,'Tooltip','Show/Hide crosshairs','Fontsize',f_size, ...   'Callback',@(src,eventdata) ebAct3D('crosshairs'));ch.torMrkrBH = uicontrol(cfig,'Style','Checkbox',...   'Position',[x_pos+buttSep2 y_pos-50 buttWid 20],'UserData',0,...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Tooltip','Display the torsion markers on the eyes',...   'Fontsize',f_size,'Value',~noTOR,'String','T Marks',...   'Callback',@(src,eventdata) ebAct3D('tormrkr'));ch.plotHORh = uicontrol(cfig,'Style','CheckBox','Units','pixels',...   'Position',[x_pos y_pos buttWid 20],'Value',~noHOR,'Enable',plotHorEnab,...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Fontsize',f_size,'String','Plot Hor','UserData','control',...   'Tooltip','Plot horizontal data in the waveform monitor',...   'Callback',@(src,eventdata) ebAct3D('wf_draw'));ch.plotVRTh = uicontrol(cfig,'Style','CheckBox','Units','pixels',...   'Position',[x_pos+buttSep1 y_pos buttWid 20],'Value',~noVRT,'Enable',plotVrtEnab,...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Fontsize',f_size,'String','Plot Vrt','UserData','control',...   'Tooltip','Plot vertical data in the waveform monitor',...   'Callback',@(src,eventdata) ebAct3D('wf_draw'));ch.plotTORh = uicontrol(cfig,'Style','CheckBox','Units','pixels',...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[x_pos+buttSep2 y_pos buttWid 20],'Value', ~noTOR,'Enable',plotTorEnab,...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Fontsize',f_size,'String','Plot Tor','UserData','control',...   'Tooltip','Plot torsional data in the waveform monitor',...   'Callback',@(src,eventdata) ebAct3D('wf_draw'));y_pos=cfig_height-200;ch.eyelinerBH = uicontrol(cfig,'Style','checkbox',...   'Position',[10 y_pos 70 20],'UserData',0,...   'Tooltip','Toggle the grid lines in the eyeballs... )',...   'Value',eyeliner,'Fontsize',f_size,'String','Eye grid',...   'Callback',@(src,eventdata) ebAct3D('eyeliner'));ch.eyelightBH = uicontrol(cfig,'Style','checkbox',...   'Position',[85 y_pos 70 20],'UserData',[2,3],...   'Tooltip','Turn on/off lighting of the eye',...   'Visible','on','Value',eyelight,...   'UserData',[odLightH osLightH], ...   'Fontsize',f_size,'String','Eye light',...   'Callback',@(src,eventdata) ebAct3D('eyelight'));ch.loadBH = uicontrol(cfig,'Style','Pushbutton',...   'Position',[250 y_pos 60 20],'UserData',0,...   'Tooltip','Load new data',...   'Fontsize',f_size,'String','Load Data',...   'Callback',@(src,eventdata) ebAct3D('load_data'));y_pos=cfig_height-224;%ch.eyeColorBH = uicontrol(cfig,'Style','Pushbutton',...%   'Position',[10 y_pos 70 20],'UserData',0,...%   'Tooltip','Don''t it make my brown eyes blue (or green or whatever... )',...%   'Fontsize',f_size,'String','Eye Color',...%   'Callback',@(src,eventdata) ebAct3D('eb3dprefs'));ch.eb3dPrefsBH = uicontrol(cfig,'Style','Pushbutton',...   'Position',[85 y_pos 70 20],'UserData',[2,3],...   'Tooltip','View/Modify the QuickTime settings',...   'Visible','on','Fontsize',f_size, ...   'UserData',pr,'String','Prefs',...   'Callback',@(src,eventdata) ebAct3D('setprefs'));ch.scaleBH = uicontrol(cfig,'Style','Pushbutton',...   'Position',[250 y_pos 60 20],'UserData',0,...   'Tooltip','Offset & scale the data','Fontsize',f_size,...   'String','Scale Data','Callback',@(src,eventdata) datscale );ch.pauseBH = uicontrol(cfig,'Style','Pushbutton',...   'Position',[325 y_pos 50 20],'UserData',0,...   'String','Pause','Fontsize',f_size,'UserData', ch.stop_sli, ...   'Tooltip','Pause the animation (press any key to resume)',...   'Callback','disp(''playback paused: press any key to continue'');pause');ch.playBH = uicontrol(cfig,'Style','Pushbutton',...   'Position',[378 y_pos 50 20],'UserData',0,'Fontsize',f_size, ...   'Tooltip','Make the eyeballs animate the data','String','Play',...   'ForeGroundColor','blue','BackGroundColor',bgcol,...   'Callback',@(src,eventdata) ebAct3D('play!'));ch.stopBH = uicontrol(cfig,'Style','Pushbutton',...   'Position',[430 y_pos 46 20],'UserData',0,...   'Fontsize',f_size,'String','Stop','UserData',ch.stop_sli, ...   'ForeGroundColor','red','BackGroundColor',bgcol,...   'Tooltip','Stop the playback animation',...   'Callback','set(get(gco,''Userdata''),''Value'',1)');   % 'UserData' contains the handle of the 'stop' slider.   % Pressing 'Stop' sets the stop slider to 1, which will cause   % the playback loop to exitch.doneBH = uicontrol(cfig,'Style','Pushbutton',...   'Position',[485 y_pos 45 20],'UserData',0,'Fontsize',f_size, ...   'Tooltip','Th-th-th-that''s all, folks!',...   'String','Done','Callback',@(src,eventdata) ebAct3D('done!'));%%%  create the efig,wfig sliders & edit boxesy_pos=cfig_height-145;uicontrol(cfig,'Style','text','Fontsize',f_size, ...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[10 y_pos 100 20],'String','Eyeballs size');ch.eb_size_sli = uicontrol(cfig,'Style','slider',...   'Position',[ 112 y_pos 150 20],'Visible','on',...   'Min',0.5,'Max', 1.0,'Value',eb_size,...   'Tooltip','Scale the eyeballs window',...   'Callback',@(src,eventdata) ebAct3D('resize_eb_sli'));ch.eb_size_txt = uicontrol(cfig,'Style','edit',...   'Position',[265 y_pos 40 20],'Fontsize',f_size, ...   'String',num2str(ch.eb_size_sli.Value,2),...   'BackGroundColor','cyan','ForeGroundColor','black',...   'Tooltip','Scale the eyeballs window',...   'Callback',@(src,eventdata) ebAct3D('resize_eb_txt'));y_pos=y_pos-25; %% y_pos=35uicontrol(cfig,'Style','text','Fontsize',f_size, ...   'ForeGroundColor','k','BackGroundColor',bgcol,...   'Position',[10 y_pos 100 20],'String','Data window size');ch.wf_size_sli = uicontrol(cfig,'Style','slider',...   'Position',[112 y_pos 150 20],'Visible','on',...   'Min',0.5,'Max',1.0,'Value',wf_size,...   'Tooltip','Scale the waveform window',...   'Callback',@(src,eventdata) ebAct3D('resize_wf_sli'));   %'Callback','ebAct3D(''resize_wf_sli'');');ch.wf_size_txt = uicontrol(cfig,'Style','edit',...   'Position',[265 y_pos 40 20],'Fontsize',f_size, ...   'String',num2str(ch.wf_size_sli.Value,2),...   'BackGroundColor','cyan','ForeGroundColor','black',...   'Tooltip','Scale the waveform window',...   'Callback',@(src,eventdata) ebAct3D('resize_wf_txt'));cfig.UserData=ch;% ********************************************% ********************************************% **       create the waveform window       **% ********************************************%% *******************************************planes = [];if ~noHOR,  planes=[planes 'h']; endif ~noVRT,  planes=[planes 'v']; endif ~noTOR,  planes=[planes 't']; endif plotXY,  planes=[planes 'x']; end %%%%%%numplanes=length(planes);if numplanes==1,     wfigmax=[300 280];  %% 255elseif numplanes==2, wfigmax=[300 540];  %% 507elseif numplanes==3, wfigmax=[300 670];  %% 640elseif numplanes==4, wfigmax=[300 810];  %% 780else   disp('No hor, vrt, or tor data loaded. Aborting!')   ebAct3D('done!')endwf_scale=ch.wf_size_sli.Value;x0=wf_center(1)-(wfigmax(1)/2)*wf_scale;y0=wf_center(2)-(wfigmax(2)/2)*wf_scale;wfigpos(1:2)=[x0 y0];wfigpos(3:4)=wfigmax*wf_scale;%%      Make Waveforms window% Initialize the window objects handle list as empty until they can% be properly initialized in the call to 'ebact('wf_draw')'.% Need to pay attention to window scale size here.wh=struct();wfig = figure('Resize','off','Position',wfigpos, ...   'Name','Waveform Monitor','NumberTitle','off', ...   'UserData',{planes,wh,0,0},'renderer','zbuffer',...   'Tag','Waveform Monitor','Menubar','none',...   'DeleteFcn',@(src,eventdata) ebAct3D('done!'));   % 01/14/05: changed 'renderer' to 'zbuffer' because 'opengl' is broken.%set(wfig,'backingstore','off')%colordef(wfig,'none')% OK, this is weird, but seems to be needed, or else the wform window will% slowly (1 pixel at a time) crawl rightwards.wfig.Position=wfigpos;ebAct3D('wf_draw')figure(cfig)