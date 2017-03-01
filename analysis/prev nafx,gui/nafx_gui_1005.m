% nafx_gui.m:   % Written by:  Jonathan Jacobs%              December 2001 - March 2007  (last mod: 03/23/07)function nafx_gui()global samp_freq qstrglobal posArrayNAFXH velArrayNAFXH posLimNAFXH velLimNAFXH tauNAFXHglobal numFovNAFXH fovCritNAFXH dblPlotNAFXH fovStatNAFXH nafx2snelH tauVersHnafxFig = findme('NAFXwindow');if nafxFig > 0   figure(nafxFig)   returnendevalin('base', 'global posArrayNAFXH velArrayNAFXH tauNAFXH qstr')evalin('base', 'global posLimNAFXH velLimNAFXH numFovNAFXH')evalin('base', 'global fovCritNAFXH dblPlotNAFXH fovStatNAFXH nafx2snelH tauVersH')if isempty(samp_freq), samp_freq = 500; end   tau = 'empty';qstr = '''';scrsize = get(0,'Screensize');mBarHgt = 35;maxHgt = scrsize(4)-mBarHgt;maxWid = scrsize(3);fig_width = 250;fig_height = 400;CR = char([10 13]);  % multi-platform carriage return% default valuesposArray = '';velArray = '';posLim = 1;%posLim = '0.5';velLim = 1;%velLim = '4';fovstat = 0;dblplot = 1;age_range = 1;tau_vers2 = 1;% make sure that 'omprefs' folder exists.  switch to it.gp_err = 0;oldpath = pwd;cd(matlabroot)eval('cd(''omprefs'')','gp_err=1;')if gp_err % must make a omprefs directory   mkdir('omprefs')   cd('omprefs')end% Set the window position.  Check if the window is already open.% If not, then we will first try to read its last saved position from% the pref file.  If not, we will place it at its default position.% Make sure that it will be drawn completely on the screen.% If not, move it so that it will.dErrFlag=0; fErrFlag=0;if ~exist('nafxXPos'), nafxXPos = []; endif ~exist('nafxYPos'), nafxYPos = []; endif isempty(nafxXPos)   if ~dErrFlag      eval(['load nafxprefs.mat'],'fErrFlag=1;');      % make sure that the window will be on the screen!      if nafxXPos<1,nafxXPos=1;end      if nafxYPos<1,nafxYPos=1;end      if (nafxYPos+fig_height)>maxHgt         nafxYPos=maxHgt-fig_height;      end      if (nafxXPos+fig_width)>maxWid         nafxXPos=maxWid-fig_width;      end      end           cd(oldpath) endif dErrFlag | fErrFlag   nafxXPos = 20;   nafxYPos = (maxHgt - fig_height)/2;end%% this is the first step towards eliminating the use of globals.nafxHandList = {qstr posArrayNAFXH velArrayNAFXH posLimNAFXH velLimNAFXH ...          tauNAFXH numFovNAFXH fovCritNAFXH dblPlotNAFXH fovStatNAFXH tauVersH};                                nafxFig = findme('NAFXwindow');if nafxFig < 0   linelist = {0};   nafxFig = figure('pos',[nafxXPos, nafxYPos, fig_width, fig_height],...     'Resize', 'off','Name',['NAFX v2.1 (Sep 2009)'],...     'NumberTitle', 'off','MenuBar', 'none','Color','k',...     'Tag','NAFXwindow',...     'UserData', {nafxHandList,linelist} ); else   figure(nafxFig)endx_orig=8;y_pos=fig_height-30;uicontrol('Style','Frame','Pos',[3 y_pos-22 245 50],...          'BackgroundColor',[0.5 0.5 0.5]);uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos+4 150 20],...          'HorizontalAlignment','Left',...          'String', ['Calculate using ''zoomtool'':']);nafxprepH = uicontrol('Style','Push','Units','Pixels',...			'Position', [x_orig+155 y_pos+1 70 25],...			'Tooltip',['Select segment start, stop, minfov and maxfov points ' CR,...			          'using "zoomtool''s" cursor1 button and "nafxprep" will ' CR,...			          'create a position-centered and a velocity array.'],...		    'String','nafxprep', 'Callback',['nafxprep']);y_pos=y_pos-20;uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos 95 20],...          'HorizontalAlignment','Left',...          'String', ['Subject age:']);nafx2snelH = uicontrol('Style','popup','Units','pixels',... 			'Position',[x_orig+100 y_pos 140 20],...			'String',['SELECT AGE|Under 6 y.o.|6-12 y.o.|12+ to 40 y.o.|' ...			           '40+ to 60 y.o.|over 60 y.o.|Dog (any age)'], ...			'HorizontalAlignment', 'center',...			'Tooltip',['Select the age of the subject (human), or "dog"' CR,...			           'to convert NAFX to the proper Snellen acuity.'],...			'Value', age_range);y_pos=y_pos-34;% set up the labelsuicontrol('Style','Frame','Pos',[3 fig_height-270 245 216],...          'BackgroundColor',[0.5 0.5 0.5]);uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos 95 25],...          'HorizontalAlignment','Left',...          'String', ['Position Array:']);posArrayNAFXH = uicontrol('Style','edit','Units','pixels',... 'BackgroundColor','magenta','ForeGroundColor','white',... 'Tooltip',['Enter the name of the position segment to be analyzed.' CR,... 			'Automatically filled in when you use "nafxprep"'],... 'Position',[x_orig+100 y_pos 135 25], 'String',posArray);y_pos=y_pos-30;uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos 95 25],...          'HorizontalAlignment','Left',...          'String', ['Velocity Array:']);velArrayNAFXH = uicontrol('Style','edit','Units','pixels',... 'BackgroundColor','magenta','ForeGroundColor','white',... 'Tooltip',['Enter the name of the velocity segment to be analyzed.' CR,... 			'Automatically filled in when you use "nafxprep"'],... 'Position',[x_orig+100 y_pos 135 25], 'String',velArray);y_pos=y_pos-30;uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos 95 25],...          'HorizontalAlignment','Left',...          'String', ['Position Limit:']);pos_lim_array=[0.5, 0.75, 1, 1.25, 1.5, 2, 2.5 ,3, 3.5, 4, 4.5, 5, 5.5, 6];posLimNAFXH = uicontrol('Style','popup','Units','pixels',... 'Position',[x_orig+100 y_pos 135 25],... 'String',['0.5 deg|0.75 deg|1.0 deg|1.25 deg|1.5 deg|2.0 deg|2.5 deg|',... 			'3.0 deg|3.5 deg|4.0 deg|4.5 deg|5.0 deg|5.5 deg|6.0 deg'],... 'value',posLim,'UserData',pos_lim_array,... 'Tooltip',['Enter the position window limit.' CR,... 			'It can be one of the following values:' CR,... 			'0.5, 0.75, 1.0, 1.25, 1.5. 2.0, 2.5' CR,... 			'3.0, 3.5, 4.0, 4.5, 5.0, 5.5 or 6.0 deg'],... 'Callback',...   ['set(tauNAFXH,''String'',''empty'');']);%%    'if temp>6,',...%%    '   set(gco,''string'',''6'');',...%%    ' else,',...%%    '   set(gco,''string'',temp);',...    %%    'end;']);%% 09/18/07: added code to set "tau" field to "empty" whenever value is changed %%y_pos=y_pos-30;uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos 95 25],...          'HorizontalAlignment','Left',...          'String', ['Velocity Limit:']);vel_lim_array = [4,5,6,7,8,9,10];velLimNAFXH = uicontrol('Style','popup','Units','pixels',... 'Position',[x_orig+100 y_pos 135 25],... 'String',['4 deg/sec|5 deg/sec|6 deg/sec|7 deg/sec|8 deg/sec|9 deg/sec|10 deg/sec'],... 'value',velLim,'UserData',vel_lim_array,... 'HorizontalAlignment','Right',... 'Tooltip',['Enter the velocity window limit.' CR,... 			'It can be one of the following values:' CR,... 			'4, 5, 6, 7, 8, 9 or 10 deg per sec'],... 'Callback',...   [';',...    'set(tauNAFXH,''String'',''empty'');']); %'BackgroundColor','magenta','ForeGroundColor','white',...%% 09/18/07: added code to set "tau" field to "empty" whenever value is changed %%%%   ['temp = abs(str2num(get(gco,''string'')));',...%%    'if temp>12,',...%%    '   set(gco,''string'',''12'');',...%%    ' else,',...%%    '   set(gco,''string'',temp);',...    %%    'end;']);y_pos=y_pos-30;uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos 95 25],...          'HorizontalAlignment','Left',...          'String', ['Sampling Freq.:']);sampFreqH = uicontrol('Style','edit','Units','pixels',... 'BackgroundColor','magenta','ForeGroundColor','white',... 'Position',[x_orig+100 y_pos 135 25],...  'Tooltip',['Sampling frequency of the data. Should' CR,...  			 'be automatically detected. It is used to' CR,...  			 'determine filtering and differentiation values.'],...  'String', num2str(samp_freq) );y_pos=y_pos-30;uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos 95 25],...          'HorizontalAlignment','Left',...          'String', ['Foveation Criteria:']);fovCritNAFXH = uicontrol('Style','popup','Units','pixels',... 'Position',[x_orig+100 y_pos-2 135 25],... 'HorizontalAlignment','center',... 'String','Pos & Vel|Pos Only|Vel Only',... 'Tooltip',['Determines what criteria will be used to' CR,... 			'determine selection of raw foveation points.' CR,... 			'Default is "Pos & Vel"'],... 'Value',1, 'UserData',['showpv';'showp ';'showv '] );y_pos=y_pos-30;uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos 95 25],...          'HorizontalAlignment','Left',...          'String', ['Tau:']);tauNAFXH = uicontrol('Style','edit','Units','pixels',... 'BackgroundColor','magenta','ForeGroundColor','white',... 'Position',[x_orig+100 y_pos 135 25],... 'Tooltip',['"Tau" is normally determined automatically' CR,... 			'based on the above position and velocity limits.' CR,... 			'If you manually enter a value here, it will' CR,... 			'over-ride the automatic value (DANGEROUS!).'],... 'String',num2str(tau) );y_pos=y_pos-35;uicontrol('Style','Frame','Pos',[3 y_pos-63 245 90],...          'BackgroundColor',[0.5 0.5 0.5]);y_pos=y_pos-2;uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos 55 25],...          'HorizontalAlignment','Left', 'FontSize', 9,...          'String', ['Raw P,V points plot:']);dblPlotNAFXH = uicontrol('Style','popup','Units','pixels',...   'Position',[x_orig+56 y_pos-2 95 25],'FontSize', 9,...   'String','Together|Separate|None',...   'Tooltip',['Determines how raw foveation points for the' CR,... 			  'position and velocity segments are displayed.' CR,... 			  'They can be plotted on the same graph, on' CR,... 			  'separate graphs, or not at all.'],...   'Value', dblplot);fovStatNAFXH = uicontrol('Style','checkbox','Units','pixels',...   'Position',[160 y_pos 90 25],'FontSize', 9,...   'Tooltip',['Determines whether or not to output' CR,... 			  'statistics about the foveations.'],...   'Value', fovstat, 'String','Show Stats' );y_pos=y_pos-30;uicontrol('Style', 'text', 'Units', 'pixels',...          'Position',[x_orig y_pos 80 23],...          'HorizontalAlignment','Left', 'FontSize', 9,...          'String', '# of calculated Foveations:' );numFovNAFXH = uicontrol('Style','edit','Units','Pixels',... 'BackgroundColor','magenta','ForeGroundColor','white',... 'Position', [90 y_pos 65 25],... 'Tooltip',['Displays the best guess of the number of foveations' CR,... 			'detected by the algorithm.  This value can be replaced' CR,... 			'by your more accurate count of the actual number of ' CR,... 			'nystagmus cycles present in the data segment.'],... 'String','empty');fovCalcH = uicontrol('Style','Push','Units','Pixels',... 'Position', [160 y_pos 85 25],... 'String','Calc Fovs.',... 'Tooltip',['Once you have entered all the above required' CR,... 			'values, click this button to see how many' CR,... 			'foveation periods meet the criteria.  You can' CR,... 			'modify any settings and recalculate as desired.'],... 'Callback',...   ['funcNAFX  = get(fovCritNAFXH,''UserData'');',...    'valNAFX   = get(fovCritNAFXH,''value'');',...    'funcNAFX  = [deblank(funcNAFX(valNAFX,:)) ''gui''];',...    'posArray  = get(posArrayNAFXH,''string'');',...    'velArray  = get(velArrayNAFXH,''string'');',...	'pos_temp  = get(posLimNAFXH,''Value'');',...    'pos_array_temp = get(posLimNAFXH,''UserData'');',...	'posLim    = pos_array_temp(pos_temp);',...	'clear pos_temp pos_array_temp;',...	'vel_temp = get(velLimNAFXH,''Value'');',...    'vel_array_temp = get(velLimNAFXH,''UserData'');',...	'velLim    = vel_array_temp(vel_temp);',...	'clear vel_temp vel_array_temp;',...    'tau       = str2num(get(   tauNAFXH,''string''));',...    'dblplot   = get(dblPlotNAFXH,''value'');',...    'fovstat   = get(fovStatNAFXH,''value'');',...    'tau_vers2 = get(tauVersH,''value'');',...    'age_range = get(nafx2snelH,''value'');',...    'dstr=[''nafx('' posArray '','' velArray '','' num2str(samp_freq) ];',...    'dstr=[dstr '',['' num2str(posLim) '','' num2str(velLim) ''],'' ];',...    'dstr=[dstr qstr funcNAFX(1:end-3) qstr '','' num2str(dblplot) '');''];',...    'disp('' ''),',...    'disp(dstr),',...    'nafx(eval(posArray),eval(velArray),samp_freq,[posLim,velLim], ' ...                   'funcNAFX,dblplot,tau_vers2);',...   ]);y_pos=y_pos-30;tauVersH = uicontrol('Style','checkbox','Units','Pixels',... 'Foregroundcolor','k',... 'Position', [30 y_pos 100 20],'String','Use Tau v2', ... 'Tooltip',['Choose which version of the Tau Surface to' CR,... 			'use for NAFX calculations.  The default is' CR,... 			'Tau version 2 (box is checked).'],... 'Value',tau_vers2, 'Callback',['set(tauNAFXH,''String'',''empty'');'] ...   );nafxCalcH = uicontrol('Style','Push','Units','Pixels',... 'Position', [160 y_pos 85 25],... 'String','Calc NAFX',... 'Tooltip',['After you have determined the number of foveations' CR,... 			'(and optionally modified the given value), click' CR,... 			'this button to calculate the NAFX for this data segment.'],... 'Callback',...   ['funcNAFX = ''nafxgui'';',...    'posArray = get(posArrayNAFXH,''string'');',...    'velArray = get(velArrayNAFXH,''string'');',...	'pos_temp  = get(posLimNAFXH,''Value'');',...    'pos_array_temp = get(posLimNAFXH,''UserData'');',...	'posLim    = pos_array_temp(pos_temp);',...	'clear pos_temp pos_array_temp;',...	'vel_temp = get(velLimNAFXH,''Value'');',...    'vel_array_temp = get(velLimNAFXH,''UserData'');',...	'velLim    = vel_array_temp(vel_temp);',...	'clear vel_temp vel_array_temp;',...    'numfov   = str2num(get(numFovNAFXH,''string''));',...    'fovstat  = get(fovStatNAFXH,''value'');',...    'tau_vers2 = get(tauVersH,''value'');',...    'age_range = get(nafx2snelH,''value'');',...    'set(fovStatNAFXH,''value'',0);',...    'dstr=[''nafx('' posArray '','' velArray '','' num2str(samp_freq) '',''];',...    'dstr=[dstr num2str(numfov) '','' qstr funcNAFX(1:end-3) qstr '',[0,'' ];',...    'dstr=[dstr num2str(posLim) '','' num2str(velLim) '']);''];',...    'disp(dstr),',...    'nafx(eval(posArray),eval(velArray),samp_freq,numfov, ' ...                     'funcNAFX,[0,posLim,velLim],tau_vers2);',...    'set(fovStatNAFXH,''value'',fovstat);',...   ]);y_pos=y_pos-30;doneH = uicontrol('Style','Push','Units','Pixels',... 'Position', [90 y_pos 70 25],... 'String','Done',... 'Tooltip',['When you''re sick and tired of calculating NAFXes' CR,... 			'you can make this go away.  Go outside and enjoy' CR,... 			'the real world for a while.'],... 'Callback',...   ['nafxtemp=get(gcf,''position'');',...    'nafxXPos = nafxtemp(1);',...    'nafxYPos = nafxtemp(2);',...    'posArray = get(posArrayNAFXH,''string'');',...    'velArray = get(velArrayNAFXH,''string'');',...    'posLim   = get(posLimNAFXH,''value'');',...    'velLim   = get(velLimNAFXH,''value'');',...    'numfov   = str2num(get(numFovNAFXH,''string''));',...    'fovstat  = get(fovStatNAFXH,''value'');',...    'tau_vers2 = get(tauVersH,''value'');',...    'age_range = get(nafx2snelH,''value'');',...    'dblplot   = get(dblPlotNAFXH,''value'');',...	'close(gcf);',...    'oldpath=pwd;',...    'cd(matlabroot); cd(''omprefs'');',...    'if exist(''posArray'',''var'') & exist(''velArray'',''var''),',...    'save nafxprefs.mat nafxXPos nafxYPos posArray velArray posLim velLim ' ...                       'dblplot age_range fovstat tau_vers2;',...     'end,',...    'cd(oldpath),',...     'clear global posArrayNAFXH velArrayNAFXH posLimNAFXH velLimNAFXH,',...    'clear global fovCritNAFXH numFovNAFXH dblPlotNAFXH qstr tau_vers2,',...    'clear global fovStatNAFXH tauNAFXH nafx2snelH tauVersH NAFshowOutput,',...    'clear funcNAFX modeNAFX valNAFX nafxXPos nafxYPos dstr qstr tau,',...    'clear age_range numfov oldpath tau_vers2,',...    'clear dblplot fovstat nafxtemp posArray velArray posLim velLim curdir',...   ]);%%    'velLim   = str2num(get(velLimNAFXH,''string''));',...