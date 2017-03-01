% lEditA5.m:  called by linedit5 to make the changes to line properties.% Written by:  Jonathan Jacobs%              March 1997 - February 2006  (last mod: 02/16/06)function lEditAct(ga, whichStr, action)% get the handles and parameters declared and set in 'PosEdit'% from the 'UserData' field of the 'Position editor' window.  % This is a much cleaner method than relying on global variables (6/13/02)leFig = get(gco,'Parent');leHnd = get(leFig, 'UserData');edLColrH = leHnd{1};      edLDelH = leHnd{2};      edLFColrH = leHnd{3};edLMkEdClrH = leHnd{4};   edLMkFcClrH = leHnd{5};  edLMSzH = leHnd{6};edLSEdgeH = leHnd{7};     edLSFaceH = leHnd{8};    edLStylH = leHnd{9};edLSymbH = leHnd{10};     edLWidH = leHnd{11};     edShowMeH = leHnd{12};leColors = leHnd{13};     leColorStr = leHnd{14};  leFig = leHnd{15};leH = leHnd{16};          leMkClrStr = leHnd{17};  leStartXPos = leHnd{18};leStartYPos = leHnd{19};  leStyles = leHnd{20};    leSymbol = leHnd{21};leSymbStr = leHnd{22};tag = str2num(whichStr);which = tag(1);col = tag(2);tmpColrStr = blanks(13);% constants for the extra colorsLASTBUILTINCOLOR = 8;ORANGE = 9;  DKORANGE = 10;LTGRAY = 11; DKGRAY = 12;OTHER = 13;  AUTO = 14; NONE = 15; if strcmp(action, 'delete')   delete(leH(which,col))   % remove the controls for that row   delete(edShowMeH(which,col));   if (edLColrH(which,col))      delete(edLColrH(which,col));   end   if (edLFColrH(which,col))      delete(edLFColrH(which,col));   end   if (edLSEdgeH(which,col))      delete(edLSEdgeH(which,col));   end   if (edLSFaceH(which,col))      delete(edLSFaceH(which,col));   end   delete(edLWidH(which,col));   if (edLStylH(which,col))      delete(edLStylH(which,col));      delete(edLMSzH(which,col));      delete(edLSymbH(which,col));      delete(edLMkFcClrH(which,col));      delete(edLMkEdClrH(which,col));   end   delete(edLDelH(which,col)); elseif strcmp(action, 'mrkrSz')   newMkrSz = str2num(get(edLMSzH(which,col), 'String'));   if (newMkrSz > 0) & (newMkrSz <= 36)      set(leH(which,col), 'MarkerSize', newMkrSz);   end elseif strcmp(action, 'showme')   showMe = get(leH(which,col), 'Selected');   if strcmp(showMe,'on')      newSVal = 'off';      newStr = ['Show'];    else      newSVal = 'on';      newStr = ['Don''t'];   end   set(leH(which,col), 'Selected', newSVal);   set(edShowMeH(which,col), 'String', newStr); % look at Offset/Gain portion of Eyeballs3D (xyplotsettings.m) to get code to % create a window that lets you set various params.  ideally we'll give user % the opportunity to decide the name of the variables created and whether % to use entire data or just what's visible in the current view. elseif strcmp(action, 'datacopy')   ga = get(leH(which,col), 'Parent');   xlims=get(ga,'XLim');	xlow = xlims(1); xhigh=xlims(2);		temp = get(leH(which,col), 'XData');		diff = abs(temp-xlow);	startpt = find( diff==min(diff) );	if isempty(startpt), startpt = 1; else startpt=startpt(1);end		diff = abs(temp-xhigh);	stoppt = find( diff==min(diff) );	if isempty(stoppt), stoppt = length(temp); else stoppt=stoppt(1);end	xdatafull = get(leH(which,col), 'XData');   ydatafull = get(leH(which,col), 'YData');   xdata = xdatafull(startpt:stoppt);   ydata = ydatafull(startpt:stoppt);   disp('Displayed X data saved as "xdata"; full X data saved as "xdatafull"')   disp('Displayed Y data saved as "xdata"; full Y data saved as "ydatafull"')   assignin('base','xdata',xdata)   assignin('base','ydata',ydata)   assignin('base','xdatafull',xdatafull)   assignin('base','ydatafull',ydatafull) elseif strcmp(action, 'datamod')	; % allow user to replace existing data or to modify it.	 elseif strcmp(action, 'width')   newwid = str2num(get(edLWidH(which,col), 'String'));   if (newwid >= 0) & (newwid <= 10)      set(leH(which,col), 'LineWidth', newwid);   end elseif strcmp(action, 'surf')   value = get(edLSFaceH(which,col), 'value');   set(edLSFaceH(which,col), 'BackgroundColor', 'w')   set(edLSFaceH(which,col), 'ForegroundColor', 'k')   if value == 1      set(leH(which,col), 'FaceColor', 'none')    elseif value == 2      set(leH(which,col), 'FaceColor', 'flat')    elseif value == 3       set(leH(which,col), 'FaceColor', 'interp')    elseif value == 4      set(leH(which,col), 'FaceColor', 'texturemap')    elseif value == 5      newSurf = uisetcolor;      if length(newSurf) == 3         set(leH(which,col), 'FaceColor', newSurf)         set(edLSFaceH(which,col), 'BackgroundColor', newSurf)         if sum(newSurf) < 0.3 | newSurf == 'k'            %set(edLSFaceH(which,col), 'ForegroundColor', [1 1 1])         end      end   end elseif strcmp(action, 'edge')   value = get(edLSEdgeH(which,col), 'value');   set(edLSEdgeH(which,col), 'BackgroundColor', 'w')   set(edLSEdgeH(which,col), 'ForegroundColor', 'k')   if value == 1      set(leH(which,col), 'EdgeColor', 'none')    elseif value == 2      set(leH(which,col), 'EdgeColor', 'flat')    elseif value == 3       set(leH(which,col), 'EdgeColor', 'interp')    elseif value == 4      newEdge = uisetcolor;      if length(newEdge) == 3         set(leH(which,col), 'EdgeColor', newEdge)         set(edLSEdgeH(which,col), 'BackgroundColor', newEdge)         if sum(newEdge) < 0.3 | newEdge == 'k'            %set(edLSEdgeH(which,col), 'ForegroundColor', [1 1 1])         end      end   end    elseif strcmp(action, 'colr')   isLine = strcmp(get(leH(which,col),'Type'), 'line');   %set(edLColrH(which,col), 'BackgroundColor', 'c')   set(edLColrH(which,col), 'ForegroundColor', 'k')   colorval = get(edLColrH(which,col), 'value');   if colorval == OTHER      newcolor = uisetcolor;      if newcolor == 0         return      end      % truncate the RGB components to fit w/in 13 chars.      for k=1:3         tempstr = [num2str(newcolor(k)) ' 0 '];         if tempstr(1) == '1'            tmpColrStr( (k-1)*4+1:k*4 ) = ' 1  ';          else            tmpColrStr( (k-1)*4+1:k*4 ) = [tempstr(2:4) ' '];         end      end      % update the popup string      newColorStr = leColorStr;      newColorStr(OTHER,1:13)=tmpColrStr(1:13);      set(edLColrH(which,col),'String',newColorStr);      %set(edLColrH(which,col),'value',OTHER); %% <- bec. of ML4 bug      linedit5    elseif colorval == ORANGE      %restore old colors string      set(edLColrH(which,col),'String',leColorStr);      set(edLColrH(which,col),'value',ORANGE); %% <- bec. of ML4 bug      newcolor = [1 0.5 0];    elseif colorval == DKORANGE      %restore old colors string      set(edLColrH(which,col),'String',leColorStr);      set(edLColrH(which,col),'value',DKORANGE); %% <- bec. of ML4 bug      newcolor = [1.0 0.25 0.0];    elseif colorval == LTGRAY      %restore old colors string      set(edLColrH(which,col),'String',leColorStr);      set(edLColrH(which,col),'value',LTGRAY); %% <- bec. of ML4 bug      newcolor = [0.75 0.75 0.75];    elseif colorval == DKGRAY      %restore old colors string      set(edLColrH(which,col),'String',leColorStr);      set(edLColrH(which,col),'value',DKGRAY); %% <- bec. of ML4 bug      newcolor = [0.5 0.5 0.5];    else % colorval <= LASTBUILTINCOLOR      %restore old colors string      set(edLColrH(which,col),'String',leColorStr);      set(edLColrH(which,col),'value',colorval); %% <- bec. of ML4 bug      newcolor = leColors(colorval);   end   if ~isempty(findstr(newcolor,leColors)) | (colorval > LASTBUILTINCOLOR)      if (isLine)         set(leH(which,col), 'Color', newcolor);       else         set(leH(which,col), 'EdgeColor', newcolor);      end   end   set(edLColrH(which,col), 'BackgroundColor', newcolor)   %%%% optional comment out   if sum(newcolor) < 0.3 | newcolor == 'k'      set(edLColrH(which,col), 'ForegroundColor', [0 0 0])   %%%%%%%      set(edLColrH(which,col), 'BackgroundColor', [1 1 1])   %%%%%%%   end elseif strcmp(action, 'fcolr')   set(edLFColrH(which,col), 'BackgroundColor', 'w')   set(edLFColrH(which,col), 'ForegroundColor', 'k')   colorval = get(edLFColrH(which,col), 'value');   if colorval == OTHER      newcolor = uisetcolor;      if length(newcolor) ~= 3         return      end      % truncate the RGB components to fit w/in 13 chars.      for k=1:3         tempstr = [num2str(newcolor(k)) ' 0 '];         if tempstr(1) == '1'            tmpColrStr( (k-1)*4+1:k*4 ) = ' 1  ';          else            tmpColrStr( (k-1)*4+1:k*4 ) = [tempstr(2:4) ' '];         end      end      % update the popup string      newColorStr = leColorStr;      newColorStr(OTHER,1:13)=tmpColrStr(1:13);      set(edLFColrH(which,col),'String',newColorStr);      set(edLFColrH(which,col),'value',OTHER); %% <- bec. of ML4 bug      linedit5    elseif colorval == ORANGE      %restore old colors string      set(edLFColrH(which,col),'String',leColorStr);      set(edLFColrH(which,col),'value',ORANGE); %% <- bec. of ML4 bug      newcolor = [1 0.5 0];    elseif colorval == DKORANGE      %restore old colors string      set(edLFColrH(which,col),'String',leColorStr);      set(edLFColrH(which,col),'value',DKORANGE); %% <- bec. of ML4 bug      newcolor = [1.0 0.25 0.0];    elseif colorval == LTGRAY      %restore old colors string      set(edLFColrH(which,col),'String',leColorStr);      set(edLFColrH(which,col),'value',LTGRAY); %% <- bec. of ML4 bug      newcolor = [0.75 0.75 0.75];    elseif colorval == DKGRAY      %restore old colors string      set(edLFColrH(which,col),'String',leColorStr);      set(edLFColrH(which,col),'value',DKGRAY); %% <- bec. of ML4 bug      newcolor = [0.5 0.5 0.5];    else % colorval<= LASTBUILTINCOLOR      %restore old colors string      set(edLFColrH(which,col),'String',leColorStr);      set(edLFColrH(which,col),'value',colorval); %% <- bec. of ML4 bug      newcolor = leColors(colorval);   end   if ~isempty(findstr(newcolor,leColors)) | (colorval > LASTBUILTINCOLOR)      set(leH(which,col), 'FaceColor', newcolor);   end   set(edLFColrH(which,col), 'BackgroundColor', newcolor )   %%%% optional comment out   if sum(newcolor) < 0.3 | newcolor == 'k'      set(edLColrH(which,col), 'ForegroundColor', [0 0 0])   %%%%%%%      set(edLColrH(which,col), 'BackgroundColor', [1 1 1])   %%%%%%%   end elseif strcmp(action, 'style')   temp = get(edLStylH(which,col), 'value');   newstyle = ( (2*temp)-1:(2*temp) );   set(leH(which,col), 'LineStyle', leStyles(newstyle)); elseif strcmp(action, 'symb')   newsymb = get(edLSymbH(which,col), 'value');   set(leH(which,col), 'Marker', leSymbol(newsymb)); elseif strcmp(action, 'mkfclr')   colorval = get(edLMkFcClrH(which,col), 'value');   set(edLMkFcClrH(which,col), 'BackgroundColor', 'w')   set(edLMkFcClrH(which,col), 'ForegroundColor', 'k')   if colorval == OTHER      newcolor = uisetcolor;      if newcolor == 0         return      end      % truncate the RGB components to fit w/in 13 chars.      for k=1:3         tempstr = [num2str(newcolor(k)) ' 0 '];         if tempstr(1) == '1'            tmpColrStr( (k-1)*4+1:k*4 ) = ' 1  ';          else            tmpColrStr( (k-1)*4+1:k*4 ) = [tempstr(2:4) ' '];         end      end      % update the popup string      newColorStr = leMkClrStr;      newColorStr(OTHER,1:13)=tmpColrStr(1:13);      set(edLMkFcClrH(which,col),'String',newColorStr);      set(edLMkFcClrH(which,col),'value',OTHER); %% <- bec. of ML4 bug      linedit5    elseif colorval == ORANGE      %restore old colors string      set(edLMkFcClrH(which,col),'String',leMkClrStr);      set(edLMkFcClrH(which,col),'value',ORANGE); %% <- bec. of ML4 bug      newcolor = [1 0.5 0];    elseif colorval == DKORANGE      %restore old colors string      set(edLMkFcClrH(which,col),'String',leMkClrStr);      set(edLMkFcClrH(which,col),'value',DKORANGE); %% <- bec. of ML4 bug      newcolor = [1.0 0.25 0.0];    elseif colorval == LTGRAY      %restore old colors string      set(edLMkFcClrH(which,col),'String',leMkClrStr);      set(edLMkFcClrH(which,col),'value',LTGRAY); %% <- bec. of ML4 bug      newcolor = [0.75 0.75 0.75];    elseif colorval == DKGRAY      %restore old colors string      set(edLMkFcClrH(which,col),'String',leMkClrStr);      set(edLMkFcClrH(which,col),'value',DKGRAY); %% <- bec. of ML4 bug      newcolor = [0.5 0.5 0.5];    else % colorval <= LASTBUILTINCOLOR      %restore old colors string      set(edLMkFcClrH(which,col),'String',leMkClrStr);      newcolor = leColors(colorval);   end   set(leH(which,col), 'MarkerFaceColor', newcolor);   if strcmp(newcolor,'n') | strcmp(newcolor,'a')       set(edLMkFcClrH(which,col), 'BackgroundColor', 'w')    else      set(edLMkFcClrH(which,col), 'BackgroundColor', newcolor) %%%% optional comment out   end   if sum(newcolor) < 0.3 | newcolor == 'k'      set(edLMkFcClrH(which,col), 'ForegroundColor', [0 0 0])   %%%%%%%      set(edLMkFcClrH(which,col), 'BackgroundColor', [1 1 1])   %%%%%%%   end elseif strcmp(action, 'mkeclr')   colorval = get(edLMkEdClrH(which,col), 'value');   set(edLMkEdClrH(which,col), 'BackgroundColor', 'w')   set(edLMkEdClrH(which,col), 'ForegroundColor', 'k')   if colorval == OTHER      newcolor = uisetcolor;      if newcolor == 0         return      end      % truncate the RGB components to fit w/in 13 chars.      for k=1:3         tempstr = [num2str(newcolor(k)) ' 0 '];         if tempstr(1) == '1'            tmpColrStr( (k-1)*4+1:k*4 ) = ' 1  ';          else            tmpColrStr( (k-1)*4+1:k*4 ) = [tempstr(2:4) ' '];         end      end      % update the popup string      newColorStr = leMkClrStr;      newColorStr(OTHER,1:13)=tmpColrStr(1:13);      set(edLMkEdClrH(which,col),'String',leMkClrStr);      set(edLMkEdClrH(which,col),'value',OTHER); %% <- bec. of ML4 bug      linedit5    elseif colorval == ORANGE      %restore old colors string      set(edLMkEdClrH(which,col),'String',leMkClrStr);      set(edLMkEdClrH(which,col),'value',ORANGE); %% <- bec. of ML4 bug      newcolor = [1 0.5 0];    elseif colorval == DKORANGE      %restore old colors string      set(edLMkEdClrH(which,col),'String',leMkClrStr);      set(edLMkEdClrH(which,col),'value',DKORANGE); %% <- bec. of ML4 bug      newcolor = [1.0 0.25 0.0];    elseif colorval == LTGRAY      %restore old colors string      set(edLMkEdClrH(which,col),'String',leMkClrStr);      set(edLMkEdClrH(which,col),'value',LTGRAY); %% <- bec. of ML4 bug      newcolor = [0.75 0.75 0.75];    elseif colorval == DKGRAY      %restore old colors string      set(edLMkEdClrH(which,col),'String',leMkClrStr);      set(edLMkEdClrH(which,col),'value',DKGRAY); %% <- bec. of ML4 bug      newcolor = [0.5 0.5 0.5];    else % colorval <= LASTBUILTINCOLOR      %restore old colors string      set(edLMkEdClrH(which,col),'String',leMkClrStr);      newcolor = leColors(colorval);   end   set(leH(which,col), 'MarkerEdgeColor', newcolor);   if strcmp(newcolor,'n') | strcmp(newcolor,'a')      set(edLMkEdClrH(which,col), 'BackgroundColor', 'w')    else      set(edLMkEdClrH(which,col), 'BackgroundColor', newcolor)  %%%% optional comment out   end   if sum(newcolor) < 0.3 | newcolor == 'k'      set(edLMkEdClrH(which,col), 'ForegroundColor', [0 0 0])   %%%%%%%      set(edLMkEdClrH(which,col), 'BackgroundColor', [1 1 1])   %%%%%%%   end elseif strcmp(action, 'done') | strcmp(action, 'update')   curdir=pwd;   dErrFlag = 0;   eval(['cd ' '''' matlabroot ''''])   eval(['cd(findomprefs)'], 'dErrFlag=1;')   startXYPos = get(leFig, 'Position');   leStartXPos = startXYPos(1);   leStartYPos = startXYPos(2);   if ~dErrFlag, eval(['save le5Prefs.mat leStartXPos leStartYPos']), end   eval(['cd ' '''' curdir ''''])    close(leFig)   if strcmp(action, 'update')      linedit5   endend