% pEditAct.m:  called by pEdit to make the changes to graph positions.% Written by:  Jonathan Jacobs%              March 1997 - Feb 2006  (last mod: 02/14/06)function pEditAct(ga, whichStr, action)% get the handles and parameters declared and set in 'PosEdit'% from the 'UserData' field of the 'Position editor' window.  % This is a much cleaner method than relying on global variables (6/13/02)peFig = get(gco,'Parent');peH   = get(peFig, 'UserData');axPosH = peH{1};      oldUnits = peH{2};     orientH = peH{3};peAxUnitsH = peH{4};  peFig = peH{5};        peGAH = peH{6};pePgUnitsH = peH{7};  peStartXPos = peH{8};  peStartYPos = peH{9};pgPosH = peH{10};tag = str2num(whichStr);which = tag(1);col = tag(2);gf = findHotW;if gf == -1   if strcmp(action,'done')    else      disp('Error: no valid figure window.')      return   end else   %ga = get(gf,'CurrentAxes');   if which == 0, which=1; end   ga = peGAH(which);  end%gf = get(ga, 'Parent');%ga = get(gf,'CurrentAxes');%gPos = get(ga, 'Position'); if strcmp(action, 'axPos')   gPos = get(ga,'Position');   gPos(col) = str2num(get(axPosH(which,col), 'String'));   set(ga, 'Position', gPos); elseif strcmp(action,'axunits')   newUnits = get(peAxUnitsH(which),'value');   if newUnits == 1      set(ga,'Units','normalized');    elseif newUnits == 2      set(ga,'Units','pixels');    elseif newUnits == 3      set(ga,'Units','inches');    elseif newUnits == 4      set(ga,'Units','centimeters');   end   newpos = get(ga,'Pos');   for i=1:4       set(axPosH(which,i),'string',num2str(newpos(i),4))   end    elseif strcmp(action,'pgunits')   newUnits = get(pePgUnitsH(which),'value');   if newUnits == 1      set(gf,'PaperUnits','normalized');    elseif newUnits == 2      set(gf,'PaperUnits','inches');    elseif newUnits == 3      set(gf,'PaperUnits','centimeters');   end   newpgpos = get(gf, 'PaperPosition');   for i=1:4      set(pgPosH(i),'String', num2str(newpgpos(i),4));   end     elseif strcmp(action, 'orient')   neworient = get(orientH, 'value');   if neworient == 1      figure(gf)      orient landscape      %set(gf, 'PaperOrientation', 'landscape');      set(orientH, 'value', 1);      figure(peFig)    elseif neworient == 2      figure(gf)       orient portrait      %set(gf, 'PaperOrientation', 'portrait');      set(orientH, 'value', 2);      figure(peFig)    end elseif strcmp(action, 'restore')   %[r,c] = size(oldUnits);   %for i = 1:r     %   set(ga, 'Units', oldUnits(i,:));   %end elseif strcmp(action, 'pgPos')   pgPos = get(gf,'PaperPosition');   pgPos(col) = str2num(get(pgPosH(col),'String'));   set(gf,'PaperPosition',pgPos); elseif strcmp(action, 'update') | strcmp(action, 'done')   %pEditAct(get(gco,'UserData'),get(gco,'Tag'),'restore');   curdir=pwd;   dErrFlag = 0;   eval(['cd ' '''' matlabroot ''''])   eval(['cd(findomprefs)'], 'dErrFlag=1;')   startXYPos = get(peFig, 'Position');   peStartXPos = startXYPos(1);   peStartYPos = startXYPos(2);   if ~dErrFlag, eval(['save pePrefs.mat peStartXPos peStartYPos']), end   eval(['cd ' '''' curdir ''''])   peH = get(peFig,'UserData');   close(peFig)   if strcmp(action, 'update')      posedit      %wNum = findme('posiEditingWindow');      %set(wNum,'UserData',peH)   endend