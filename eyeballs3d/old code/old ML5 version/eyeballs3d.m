% eyeballs3D: draws a pair of eyeballs and animates them using% eye movement data in memory.  The data must be composed of up% to six equal-length vectors (lh, lv, lt, rh, rv, rt) that must% be declared as global variables before they are read in.  Additionally,% the sampling frequency, 'samp_freq' must also be a global variable.% Optionally, if there are horizontal and vertical stimuli data,% they can be displayed in their respective planes by making 'st' and 'sv'% global variables, too. % Written by: Jonathan Jacobs%             March 2002 - October 2003 (last mod: 10/14/03)% Files necessary for proper operation:%   'eyeballs3d', 'ebAct3D.m', 'datscale.m', 'd2pt.m'%   'xyplotsettings.m', 'ebdatacheck.m', 'ebdataload.m'% If you have received this as a '.p' (pseudocode) file, all the% above-mentioned functions will also be '.p' files.  (And you shouldn't% even be reading this?)% 27 Nov 02: added alignment crosshairs.  May eventually make them%            customizable/switchable%  2 Dec 02: crosshairs can be switched on/off%  2 Dec 02: wform, monitor and control windows created at proper size,%            rather than resizing them after creation.% 29 May 03: massive redesign of GUI, relocation of many controls%            added user-customizable XY plot settings.%  2 Jun 03: major revision now allows loading of new data w/o having to %            close and re-run 'eyeballs3d'%  5 Jun 03: the user can now select arrays from the base workspace for XY plot% 16 Jul 03: added optional display of stimulus data% 14 Oct 02: added rubberband zoomfunction eyeballs3D(null)global rh lh rv lv rt lt st sv samp_freq% look for the open windowsefig = -1; cfig = -1; wfig = -1; sfig = -1; xyfig=-1;wl = get(0,'Children');for i = 1:length(wl)   if strcmp(get(wl(i),'Name'),'Eye Monitor'),           efig=wl(i); end   if strcmp(get(wl(i),'Name'),'Eye Monitor Control'),   cfig=wl(i); end   if strcmp(get(wl(i),'Name'),'Waveform Monitor'),      wfig=wl(i); end   if strcmp(get(wl(i),'Name'),'Data Scaling & Offset'), sfig=wl(i); end   if strcmp(get(wl(i),'Name'),'XY Plot settings'),   	xyfig=wl(i); endendif efig>0 & cfig>0 & wfig>0   figure(cfig);   return;end% center the three windows we are about to create (if not using saved pos)screensize=get(0,'ScreenSize');initpos = [fix((screensize(3)-914)/2) fix((screensize(4)-535)/2)]; % center it% look for a preference file.% if there is no 'omprefs' folder in the MATLAB root, we will% create one and also create a prefs file.cur_dir = pwd;cd(matlabroot)gp_err=0;eval('cd(''omprefs'')','gp_err=1;')if gp_err % must make a omprefs directory   mkdir('omprefs')   cd('omprefs')end% default pref valueseyeColor = [0.4431 0.5961 0.3686];efigpos  = [initpos+[0 243]  570 264];cfigpos  = [initpos+[44 -50]   540 230];wfigpos  = [initpos+[600 0]  300 507];dfigpos  = [initpos+[115 -90]  400 90];xyfigpos = [initpos+[115 -300]  300 200];efigpopup = 1;% if there is not a good pref file, create one w/the default valuespref_err=0;eval('load(''ebPrefs.mat'')','pref_err=1;')   if pref_err   disp('pref_err!')   save ebPrefs.mat eyeColor efigpos cfigpos wfigpos dfigpos xyfigpos efigpopupendif exist(cur_dir,'dir'), cd(cur_dir); end% is there good data loaded into memory?[status, datlen, noHOR, noVRT, noTOR, noSTM] = ebdatacheck;if status==0   disp('calling ''ebdataload'' to read in valid data.')    ebdataload   [status, datlen, noHOR, noVRT, noTOR, noSTM] = ebdatacheck;   if status==0, disp('not valid data. RTFM.'); return; endendif noHOR, plotHorEnab = 'off'; else plotHorEnab = 'on'; endif noVRT, plotVrtEnab = 'off'; else plotVrtEnab = 'on'; endif noTOR, plotTorEnab = 'off'; else plotTorEnab = 'on'; endif noSTM, plotStmEnab = 'off'; else plotStmEnab = 'on'; end% ***************************************************************% ***************************************************************% **                    open your eyes!                        **% ***************************************************************% ***************************************************************efig = figure('Position',efigpos, ...              'Name',['Eye Monitor'],'NumberTitle','off', ...              'DeleteFcn','ebAct3D(''done!'')', ...              'Menubar','none','Tag','Eyeballs3D: uneditable',...              'color',[0.75 0.75 0.75] );%set(efig,'backingstore','off')% easier and more reliable than using 'subplot' command% which causes all sorts of hilarity: axes disappear.  Really!odSocket = axes('position', [0.025 0.05 0.45 0.87]);osSocket = axes('position', [0.55 0.05 0.45 0.87] );badge    = axes('position', [0.0 0.95 0.1 0.05]   );overlay  = axes('position', [0.025 0.05 0.95 0.87]);% eyeColor was loaded earlier, or was set to default colormap = ones(64,3);map(64,:) = [0 0 0];map(63,:) = eyeColor;map(62,:) = eyeColor;map(61,:) = eyeColor;map(60,:) = eyeColor;%mrkrFClr = min([1 1 1], 1.25*eyeColor);%mrkrEClr = max([0 0 0], 0.8*eyeColor);mrkrEClr = [1 0 0];mrkrFClr = [1 0 0];visStr = {'off','on'};v_viewoff = 10;hor = 0; vrt = 0; tor=0;% plot the text ID badgeaxes(badge)axis offbtxt=text(0.05,0.2,'�OMLAB');set(btxt,'FontSize',10,'Color',[0 0 1]);% the torsion triangle vertices[z,y,x]=sphere(30);a=[x(25,16) x(25,1)];b=[y(25,16) y(25,1)];c=[z(25,16) z(25,1)];% mini eyeball with screwed-up torsion triangle vertices%[z,y,x]=sphere(18);%a=[x(15,16) x(15,1)];%b=[y(15,16) y(15,1)];%c=[z(15,16) z(15,1)];% put the right eye in its socketaxes(odSocket)od=surf(x,y,z,x);%cdata=get(od,'CData'); cdata(26,16)=0.6;%set(od,'CData',cdata);set(odSocket,'view',[hor+90 vrt]);set(odSocket,'UserData',0);axis equal; axis off axis vis3dhold on%odMrkr=patch(a,b,c,mrkrClr);odMrkr=plot3(a,b,c,'Markersize',10,...          'LineStyle','none','visible',visStr{~noTOR+1},...          'MarkerFaceColor',mrkrFClr,'MarkerEdgeColor',mrkrEClr);set(odMrkr,'Marker','diamond')% weird-assed ML6.5/X11 bug? The 'marker' setting will cause entire window% contents to be invisible!!!%odMrkr=plot3(a,b,c,'Marker','Diamond','MarkerSize',10,...%          'LineStyle','none','visible',visStr{~noTOR+1},...%          'MarkerFaceColor',mrkrFClr,'MarkerEdgeColor',mrkrEClr);% put the left eye in its socketaxes(osSocket)os=surf(x,y,z,x);%set(os,'CData',cdata);set(osSocket,'view',[hor+90 vrt]);set(osSocket,'UserData',0);axis equal; axis off axis vis3dhold on%osMrkr=patch(a,b,c,mrkrClr);osMrkr=plot3(a,b,c,'MarkerSize',10,...          'LineStyle','none','visible',visStr{~noTOR+1},...          'MarkerFaceColor',mrkrFClr,'MarkerEdgeColor',mrkrEClr);set(osMrkr,'Marker','diamond')colormap(map)% draw alignment crosshairs (added 11/27/02)axes(overlay)hold onaxis offaxis([0 1  0 1])% the middle of each pupil.  (majick numbers)ODctr = [0.2375, 0.5];OSctr = [0.79  , 0.5];hLen = 0.035;vLen = 0.085;% draw the horizontals...chLineH(1) = line([ODctr(1)-hLen ODctr(1)+hLen], [ODctr(2) ODctr(2)], 'color','y');chLineH(2) = line([OSctr(1)-hLen OSctr(1)+hLen], [OSctr(2) OSctr(2)], 'color','y');% ...and the verticalschLineH(3) = line([ODctr(1) ODctr(1)], [ODctr(2)-vLen ODctr(2)+vLen], 'color','y');chLineH(4) = line([OSctr(1) OSctr(1)], [OSctr(2)-vLen OSctr(2)+vLen], 'color','y');% ***************************************************************% ***************************************************************% **               create the controls window                  **% ***************************************************************% ***************************************************************cfig = figure('Resize','off','Position', cfigpos, ...              'Name',['Eye Monitor Control'],'NumberTitle','off', ...              'Menubar','none','Tag','Eyeballs3D control',...              'DeleteFcn','ebAct3D(''done!'')' );cfig_height = cfigpos(4);uicontrol(cfig,'Style','Frame','Units', 'pixels',...   'BackgroundColor',[0.25 0.25 0.25],'Position',[4 cfig_height-110 532 107])uicontrol(cfig,'Style','Frame','Units', 'pixels',...   'BackgroundColor',[0.25 0.25 0.25],'Position',[4 cfig_height-200 323 83])uicontrol(cfig,'Style','Frame','Units', 'pixels',...   'BackgroundColor',[0.25 0.25 0.25],'Position',[331 cfig_height-200 205 83])   y_pos=cfig_height-25;aboutBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [10 y_pos 50 15],'UserData',0,...   'BackGroundColor',[0.6 0.6 0.6],...   'Tooltip','Who did this?',...   'String', 'About...','Callback', ['ebAct3D(''about'');'] );uicontrol(cfig, 'Style', 'text',...     'Position', [80 y_pos 50 20], 'String', 'Zoom is:');rbzoomBH = uicontrol(cfig, 'Style', 'Toggle',...   'Position', [135 y_pos 50 20],'UserData',0,...   'BackGroundColor',[0.75 0.75 0.75],...   'Value',0,'Tooltip','Activate ''Rubber Band'' zooming',...   'String', 'Off','Callback', ['ebAct3D(''rbzoom'');'] );% ***************************************************************% **                   time/sample controls                    **y_pos=y_pos-5;uicontrol(cfig, 'Style', 'text',...     'Position', [320 y_pos 50 20], 'String', 'Time');uicontrol(cfig, 'Style', 'text',...     'Position', [260 y_pos 50 20], 'String', 'Sample');y_pos=y_pos-25;uicontrol(cfig, 'Style', 'text',...   'Position', [10 y_pos 40 20], 'String', 'Start');start_sli = uicontrol(cfig, 'Style', 'slider',...   'Position', [ 55 y_pos 200 20],...   'Min', 1, 'Max', datlen, 'Value', 1,...   'Visible','on',...   'Tooltip','Set the start time',...   'Callback',['ebAct3D(''start_sli'');']);start_txt = uicontrol(cfig, 'Style', 'edit',...   'Position', [260 y_pos 50 20],...   'String', num2str(get(start_sli, 'Value')),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','Set the start time (samples)',...   'Callback', ['ebAct3D(''start_txt'');'] );start_txt2 = uicontrol(cfig, 'Style', 'edit',...   'Position', [320 y_pos 50 20],...   'String', num2str(get(start_sli, 'Value')/samp_freq),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','Set the start time (seconds)',...   'Callback', ['ebAct3D(''f_start_txt'');'] );y_pos=y_pos-25;uicontrol(cfig, 'Style', 'text',...     'Position', [10 y_pos 40 20], 'String', 'Stop');stop_sli = uicontrol(cfig, 'Style', 'slider',...   'Position', [ 55 y_pos 200 20],...   'Min', 1, 'Max', datlen, 'Value', datlen,...   'Visible','on',...    'Tooltip','Set the stop time',...   'Callback',['ebAct3D(''stop_sli'');']);stop_txt = uicontrol(cfig, 'Style', 'edit',...   'Position', [260 y_pos 50 20],...   'String', num2str(get(stop_sli, 'Value')),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','Set the stop time (samples)',...   'Callback', ['ebAct3D(''stop_txt'');'] );stop_txt2 = uicontrol(cfig, 'Style', 'edit',...   'Position', [320 y_pos 50 20],...   'String', num2str(get(stop_sli, 'Value')/samp_freq),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','Set the stop time (seconds)',...   'Callback', ['ebAct3D(''f_stop_txt'');'] );y_pos=y_pos-25;uicontrol(cfig, 'Style', 'text',...   'Position', [10 y_pos 40 20], 'String', 'Current');cur_sli = uicontrol(cfig, 'Style', 'slider',...   'Position', [ 55 y_pos 200 20],...   'Min', 1, 'Max', datlen, 'Value', 1,...   'Visible','on',...   'Tooltip','Shows the current point in the animation',...   'Callback',['ebAct3D(''cur_sli'');']);cur_txt = uicontrol(cfig, 'Style', 'edit',...   'Position', [260 y_pos 50 20],...   'String', num2str(get(cur_sli, 'Value')),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','Shows the current point in the animation (samples)',...   'Callback', ['ebAct3D(''cur_txt'');'] );cur_txt2 = uicontrol(cfig, 'Style', 'edit',...   'Position', [320 y_pos 50 20],...   'String', num2str(get(cur_sli, 'Value')/samp_freq),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','Shows the current point in the animation (seconds)',...   'Callback', ['ebAct3D(''f_cur_txt'');'] );% ***************************************************************% **                play/movie/misc controls                   **y_pos=cfig_height-30;livemonBH = uicontrol(cfig, 'Style', 'checkbox',...   'Position', [430 y_pos 100 20],'Value',1,...   'Tooltip','Update the waveform window during play',...   'String', 'Live Monitor', 'Callback', [''] );   y_pos=y_pos-25;uicontrol(cfig, 'Style', 'text',...   'Position', [460 y_pos 40 20], 'String', 'Skip:');uicontrol(cfig, 'Style', 'text',...   'Position', [390 y_pos 40 20], 'String', 'QT x:');decimateH = uicontrol(cfig, 'Style', 'edit',...   'Position', [500 y_pos 30 20],...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','Play every nth point',...   'String', num2str(fix(samp_freq/20)), 'Callback', [''] );qtfactorH = uicontrol(cfig, 'Style', 'edit',...   'Position', [430 y_pos 30 20],...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','QT movie takes x times as long as real-time',...   'String', '1', 'Callback', [''] );y_pos=y_pos-25;uicontrol(cfig, 'Style', 'text',...   'Position', [390 y_pos 40 20], 'String', 'Movie:');e_movieBH = uicontrol(cfig, 'Style', 'checkbox',...   'Position', [430 y_pos 55 20],'Value',0,...   'Tooltip','Save the eyeball animation as a QuickTime movie',...   'String', 'Eyes', 'Callback', [''] );wf_movieBH = uicontrol(cfig, 'Style', 'checkbox',...   'Position', [480 y_pos 50 20],'Value',0,...   'Tooltip','Save the waveform animation as a QuickTime movie',...   'String', 'Data', 'Callback', [''] );   uicontrol(cfig, 'Style', 'text',...   'Position', [390 y_pos-18 55 15], 'String', 'Eye Size:');ewindsizeH = uicontrol('Style','popup','Units','pixels',...   'Position',[450 y_pos-22 80 20],...   'String','large|medium|small',...   'Tooltip','Change the Eye Monitor window size',...   'HorizontalAlignment', 'center',...   'Value', efigpopup,...    'Callback',['ebAct3D(''resize'');']);y_pos=cfig_height-143; x_pos=337;plotXYh = uicontrol(cfig,'Style','CheckBox','Units','pixels',...   'ForeGroundColor','white','BackGroundColor',[0.75 0.75 0.75],...   'Position',[x_pos y_pos-25 60 20], 'Value', 0,...   'String','XY Plot','UserData','control',...   'Tooltip','Plot phase plane data in the waveform monitor',...   'Callback', ['ebAct3D(''wf_draw'')']);plotXY = get(plotXYh, 'value');xysetBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [x_pos+67 y_pos-25 60 20],'UserData',0,...   'Tooltip','XY plot settings',...   'String', 'XY Setup', 'Callback', ['ebAct3D(''xy_setup'');'] );plotSTMh = uicontrol(cfig, 'Style', 'Checkbox',...   'Position', [x_pos y_pos-50 60 20],'UserData',chLineH,...   'Value',~noSTM, 'Enable', plotStmEnab,...   'Tooltip','Plot stimulus data in the waveform monitor',...   'String', 'Plot Stm', 'Callback', ['ebAct3D(''wf_draw'')'] );   crossH = uicontrol(cfig, 'Style', 'Checkbox',...   'Position', [x_pos+67 y_pos-50 60 20],'UserData',chLineH,...   'Value',1, 'Tooltip','Show/Hide crosshairs',...   'String', 'C Hairs', 'Callback', ['ebAct3D(''crosshairs'');'] );   torMrkrBH = uicontrol(cfig, 'Style', 'Checkbox',...   'Position', [x_pos+134 y_pos-50 60 20],'UserData',0,...   'Tooltip','Display the torsion markers on the eyes',...   'Value',~noTOR, 'String', 'T Marks',...   'Callback', ['ebAct3D(''tormrkr'')'] );plotHORh = uicontrol(cfig,'Style','CheckBox','Units','pixels',...   'Position',[x_pos y_pos 60 20], 'Value', ~noHOR, 'Enable',plotHorEnab,...   'String','Plot Hor','UserData','control',...    'Tooltip','Plot horizontal data in the waveform monitor',...   'Callback', ['ebAct3D(''wf_draw'')'] );plotVRTh = uicontrol(cfig,'Style','CheckBox','Units','pixels',...   'Position',[x_pos+67 y_pos 60 20], 'Value', ~noVRT, 'Enable',plotVrtEnab,...   'ForeGroundColor','black','BackGroundColor',[0.75 0.75 0.75],...   'String','Plot Vrt','UserData','control',...    'Tooltip','Plot vertical data in the waveform monitor',...   'Callback', ['ebAct3D(''wf_draw'')'] );plotTORh = uicontrol(cfig,'Style','CheckBox','Units','pixels',...   'ForeGroundColor','black','BackGroundColor',[0.75 0.75 0.75],...   'Position',[x_pos+134 y_pos 60 20], 'Value', ~noTOR, 'Enable',plotTorEnab,...   'String','Plot Tor','UserData','control',...    'Tooltip','Plot torsional data in the waveform monitor',...   'Callback', ['ebAct3D(''wf_draw'')']);y_pos=cfig_height-225;eyecolorBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [10 y_pos 55 20],'UserData',0,...   'Tooltip','Don''t it make my brown eyes blue (or green or whatever... )',...   'String', 'Eye Color', 'Callback', ['ebAct3D(''color'');'] );qtPrefsBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [70 y_pos 60 20],'UserData',[2,3],...   'Tooltip','View/Modify the QuickTime settings',...   'Visible','on',...    'String', 'QT Prefs',...   'Callback', ['ebAct3D(''qtprefs'');'] );scaleBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [160 y_pos 60 20],'UserData',0,...   'Tooltip','Offset & scale the data',...   'String', 'Scale Data',...   'Callback', ['datscale;'] );pauseBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [250 y_pos 50 20],'UserData',0,...   'String', 'Pause',...   'UserData', stop_sli, ...   'Tooltip','Pause the animation (press any key to resume)',...   'Callback', ['disp(''playback paused: press any key to continue'');pause']);   playBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [305 y_pos 50 20],'UserData',0,...   'Tooltip','Make the eyeballs animate the data',...   'ForeGroundColor','blue','BackGroundColor',[0.75 0.75 0.75],...   'String', 'Play', 'Callback', ['ebAct3D(''play!'');'] );   stopBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [360 y_pos 46 20],'UserData',0,...   'String', 'Stop',...   'UserData', stop_sli, ...   'Tooltip','Stop the playback animation',...   'Callback', ['set(get(gco,''Userdata''),''Value'',1)'] );   % 'Userdata' contains the handle of the 'stop' slider.   % pressing 'Stop' sets the stop slider to 1, which will cause   % the playback loop to exit loadBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [420 y_pos 60 20],'UserData',0,...   'Tooltip','Load new data',...   'String', 'Load Data', 'Callback', ['ebdataload;ebAct3D(''load_data'')'] );doneBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [485 y_pos 45 20],'UserData',0,...   'Tooltip','Th-th-th-that''s all, folks!',...   'String', 'Done', 'Callback', ['ebAct3D(''done!'');'] );% ***************************************************************% **         create the hor/vrt/tor sliders & edit boxes           **y_pos=cfig_height-145;uicontrol(cfig, 'Style', 'text',...   'Position', [10 y_pos 40 20], 'String', 'Horiz.');hor_sli = uicontrol(cfig, 'Style', 'slider',...   'Position', [ 55 y_pos 150 20],...   'Min', -45, 'Max', 45, 'Value', 0,...   'Visible','on',...   'Tooltip','Manually the eyes horizontally',...   'Callback',['ebAct3D(''hor_sli'');']);hor_txt = uicontrol(cfig, 'Style', 'edit',...   'Position', [210 y_pos 40 20],...   'String', num2str(get(hor_sli, 'Value')),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','Manually move the eyes horizontally (degrees)',...   'Callback', ['ebAct3D(''hor_txt'');']);cboxOD = uicontrol(cfig,'Style','CheckBox','Units','pixels',...   'ForeGroundColor','black','BackGroundColor',[0.75 0.75 0.75],...   'Position',[260 y_pos 60 20], 'Value', 1,...   'String','Move OD','UserData',[od odSocket odMrkr],...    'Tooltip','Hor/Vrt/Tor controls affect the right eye',...   'Callback', [''] );y_pos=y_pos-25; %% y_pos=35uicontrol(cfig, 'Style', 'text',...   'Position', [10 y_pos 40 20], 'String', 'Vert.');vrt_sli = uicontrol(cfig, 'Style', 'slider',...   'Position', [55 y_pos 150 20],...   'Min', -30, 'Max', 30, 'Value', 0,...   'Visible','on',...   'Tooltip','Manually move the eyes vertically',...   'Callback',['ebAct3D(''vrt_sli'');']);vrt_txt = uicontrol(cfig, 'Style', 'edit',...   'Position', [210 y_pos 40 20],...   'String', num2str(get(vrt_sli, 'Value')),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','Manually move the eyes vertically (degrees)',...   'Callback', ['ebAct3D(''vrt_txt'');'] );cboxOS = uicontrol(cfig,'Style','CheckBox','Units','pixels',...   'ForeGroundColor','black','BackGroundColor',[0.75 0.75 0.75],...   'Position',[260 y_pos 60 20], 'Value', 1,...   'String','Move OS','UserData',[os osSocket osMrkr],...    'Tooltip','Hor/Vrt/Tor controls affect the left eye',...   'Callback', [''] );y_pos=y_pos-25; %% y_pos=10uicontrol(cfig, 'Style', 'text',...   'Position', [10 y_pos 40 20], 'String', 'Tors.');tor_sli = uicontrol(cfig, 'Style', 'slider',...   'Position', [ 55 y_pos 150 20],...   'Min', -45, 'Max', 45, 'Value', 0,...   'UserData', 0,...   'Tooltip','Manually tort the eyes',...   'Callback',['ebAct3D(''tor_sli'');']);tor_txt = uicontrol(cfig, 'Style', 'edit',...   'Position', [210 y_pos 40 20],...   'String', num2str(get(tor_sli, 'Value')),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Tooltip','Manually tort the eyes (degrees)',...   'Callback', ['ebAct3D(''tor_txt'');']);eyesfrontBH = uicontrol(cfig, 'Style', 'Pushbutton',...   'Position', [260 y_pos 60 20],'UserData',0,...   'Tooltip','Return H/V/T to zero.',...   'String', 'Straight',...   'Callback', ['ebAct3D(''eyesfront'');'] );% ***************************************************************% ***************************************************************% **               create the waveform window                  **% ***************************************************************% ***************************************************************planes = [];if ~noHOR,  planes = [planes 'h']; endif ~noVRT,  planes = [planes 'v']; endif ~noTOR,  planes = [planes 't']; end%if plotXY,  planes = [planes 'x']; end %%%%%%numplanes = length(planes);if numplanes == 1   wfigsize=[300 255]; elseif numplanes == 2   wfigsize=[300 507]; elseif numplanes == 3   wfigsize=[300 640]; elseif numplanes == 4   wfigsize=[300 780]; else   disp('No hor, vrt, or tor data loaded.  Aborting!')   ebAct3D('done!')endwfigpos(3:4) = wfigsize;% initialize the window objects handle list to zeros until they can% be properly initialized in the call to 'ebact('wf_draw')'.wH = zeros(15,1);wfig = figure('Resize','off','Position', wfigpos, ...              'Name',['Waveform Monitor'],'NumberTitle','off', ...              'UserData',{planes,wH,0}, ...              'Menubar','none',...              'Color',[0.2 0.2 0.2],...              'DeleteFcn','ebAct3D(''done!'')' );%set(wfig,'backingstore','off')colordef(wfig,'none')% OK, this is weird, but seems to be needed, or else the wform window will % slowly (1 pixel at a time) crawl rightwards.set(wfig,'Position', wfigpos)% ***************************************************************% **               store the control handles                   **cH = [plotHORh plotVRTh plotTORh,...      cboxOS cboxOD pauseBH decimateH qtfactorH,...      livemonBH e_movieBH wf_movieBH ewindsizeH,...       hor_sli vrt_sli tor_sli hor_txt vrt_txt tor_txt,...      start_sli stop_sli cur_sli,...      start_txt stop_txt cur_txt,...      start_txt2 stop_txt2 cur_txt2 qtPrefsBH crossH,...      plotXYh xysetBH stopBH plotSTMh rbzoomBH];set(cfig,'UserData', cH);ebAct3D('wf_draw')figure(cfig)