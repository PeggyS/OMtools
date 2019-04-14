% rotButt.m:  handles most of the control buttons in "rotplot"% this way we don't need to declare a whole bunch of global% variables in the main workspace.% Written by: Jonathan Jacobs%             May 1996 - July 2002 (last mod: 06/14/02)% 6/14/02 -- converted from global variables to stored handlesfunction rotButt( buttName )% get the handles and parameters declared and set in 'PosEdit'% from the 'UserData' field of the 'Position editor' window.  % This is a much cleaner method than relying on global variables (6/13/02)rpFig = findme('rotpEditingWindow');if ishandle(rpFig)   rpH = get(rpFig, 'UserData');endsli_azm = rpH{1};       sli_elv = rpH{2};       azm_cur = rpH{3};elv_cur = rpH{4};       %elv = rpH{5};          azm = rpH{6};rpFig = rpH{8};         rpXHighH = rpH{9};      %rotfig = rpH{7};        rpXLowH = rpH{10};      rpYHighH = rpH{11};     rpYLowH = rpH{12};rpZHighH = rpH{13};     rpZLowH = rpH{14};      %h3D = rpH{15};%hXvsY = rpH{16};       hYvsZ = rpH{17};        hXvsZ = rpH{18};rpZoomOutH = rpH{20};   %rpZoomInH = rpH{19};   rpQuitH = rpH{21};%rpUpdateH = rpH{22};   rpStartXPos = rpH{23};  rpStartYPos = rpH{24};ga = get(rpZoomOutH, 'UserData');%rotfig = get(h, 'Parent');if strcmp( buttName, 'zoomin' )   temp = zoomin;   set(rpXLowH,  'String', num2str(temp(1)) );   set(rpXHighH, 'String', num2str(temp(2)) );   set(rpYLowH,  'String', num2str(temp(3)) );   set(rpYHighH, 'String', num2str(temp(4)) );   set(rpZLowH,  'String', num2str(temp(5)) );   set(rpZHighH, 'String', num2str(temp(6)) );endif strcmp( buttName, 'zoomout' )   temp = zoomout;   set(rpXLowH,  'String', num2str(temp(1)) );   set(rpXHighH, 'String', num2str(temp(2)) );   set(rpYLowH,  'String', num2str(temp(3)) );   set(rpYHighH, 'String', num2str(temp(4)) );   set(rpZLowH,  'String', num2str(temp(5)) );   set(rpZHighH, 'String', num2str(temp(6)) );endif strcmp( buttName, 'XvsZ')   set(ga,'View', [0 0]);   set(sli_azm, 'Value', 0 );                % update slider   set(azm_cur, 'String', num2str(0) );      % value & display   set(sli_elv, 'Value', 0 );   set(elv_cur, 'String', num2str(0) );   returnendif strcmp( buttName, 'YvsZ')   set(ga,'View', [90 0]);   set(sli_azm, 'Value', 90 );                % update slider   set(azm_cur, 'String', num2str(90) );      % value & display   set(sli_elv, 'Value', 0 );   set(elv_cur, 'String', num2str(0) );   returnendif strcmp( buttName, 'XvsY')   set(ga,'View', [0 90]);   set(sli_azm, 'Value', 0 );                 % update slider   set(azm_cur, 'String', num2str(0) );       % value & display   set(sli_elv, 'Value', 90 );   set(elv_cur, 'String', num2str(90) );   returnendif strcmp( buttName, '3D')   set(ga,'View', [-37.5 30]);   set(sli_azm, 'Value', -37.5 );             % update slider   set(azm_cur, 'String', num2str(-37.5) );   % value & display   set(sli_elv, 'Value', 30 );   set(elv_cur, 'String', num2str(30) );   returnendif strcmp( buttName, 'sli_azm')   azm=get(sli_azm,'Val');             % this will change   elv=get(sli_elv,'Val');             % the screen view and will   if azm<=-179.90      azm=180;                         % wrap around at the      set(sli_azm,'Val',azm);          % low or high end     elseif azm>=179.90      azm=-180;      set(sli_azm,'Val',azm);   end   set(ga,'View', [azm elv]);          % update the azimuth readout.   set( azm_cur,'String', num2str(azm) );endif strcmp( buttName, 'sli_elv')   azm=get(sli_azm,'Val');             % this will change   elv=get(sli_elv,'Val');             % the screen view and will   if elv<=-179.90      elv=180;                         % wrap around at the      set(sli_elv,'Val',elv);          % low or high end     elseif elv>=179.90      elv=-180;      set(sli_elv,'Val',elv);   end   set(ga,'View', [azm elv]);          % update the elevation readout.   set( elv_cur,'String', num2str(elv) );endif strcmp( buttName, 'azm_cur')   old_elv = str2double(get(elv_cur,'String'));  % type in a new   new_azm = str2double(get(azm_cur,'String'));  % azimuth value   set(ga,'View', [new_azm old_elv]);   set(sli_azm, 'Value', new_azm);endif strcmp( buttName, 'elv_cur')   new_elv = str2double(get(elv_cur,'String'));  % type in a new   old_azm = str2double(get(azm_cur,'String'));  % elevation value   set(ga,'View', [old_azm new_elv]);   set(sli_elv, 'Value', new_elv);endif strcmp( buttName, 'xLow' )   old_XHigh = str2double(get(rpXHighH,'String'));  % type in a new   new_XLow  = str2double(get(rpXLowH, 'String'));  % xLow value   if new_XLow < old_XHigh               set(ga, 'XLim', [new_XLow old_XHigh]);   endendif strcmp( buttName, 'xHigh' )   new_XHigh = str2double(get(rpXHighH,'String'));  % type in a new   old_XLow  = str2double(get(rpXLowH, 'String'));  % xHigh value   if new_XHigh > old_XLow               set(ga, 'XLim', [old_XLow new_XHigh]);   endendif strcmp( buttName, 'yLow' )   old_YHigh = str2double(get(rpYHighH,'String'));  % type in a new   new_YLow  = str2double(get(rpYLowH, 'String'));  % yLow value   if new_YLow < old_YHigh               set(ga, 'YLim', [new_YLow old_YHigh]);   endendif strcmp( buttName, 'yHigh' )   new_YHigh = str2double(get(rpYHighH,'String'));  % type in a new   old_YLow  = str2double(get(rpYLowH, 'String'));  % yHigh value   if new_YHigh > old_YLow               set(ga, 'YLim', [old_YLow new_YHigh]);   endendif strcmp( buttName, 'zLow' )   old_ZHigh = str2double(get(rpZHighH,'String'));  % type in a new   new_ZLow  = str2double(get(rpZLowH, 'String'));  % zLow value   if new_ZLow < old_ZHigh               set(ga, 'ZLim', [new_ZLow old_ZHigh]);   endendif strcmp( buttName, 'zHigh' )   new_ZHigh = str2double(get(rpZHighH,'String'));  % type in a new   old_ZLow  = str2double(get(rpZLowH, 'String'));  % zHigh value   if new_ZHigh > old_ZLow               set(ga, 'ZLim', [old_ZLow new_ZHigh]);   endendif strcmp( buttName, 'quit') || strcmp( buttName, 'update')   figure(rpFig)   curdir = pwd;   cd(matlabroot)   cd(findomprefs)   startXYPos = get(rpFig, 'Position');   rpStartXPos = startXYPos(1);   rpStartYPos = startXYPos(2);   save rpPrefs.mat rpStartXPos rpStartYPos   cd(curdir)            close(rpFig)   if strcmp(buttName,'update')      rotplot   endend