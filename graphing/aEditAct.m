% aEditAct.m:  called by axisedit to make the changes to axis properties.% Written by:  Jonathan Jacobs%              March 1997 - February 2006 (last mod: 02/16/06)function aEditAct(ga, whichStr, action)% get the handles and parameters declared and set in 'PosEdit'% from the 'UserData' field of the 'Position editor' window.% This is a much cleaner method than relying on global variables (6/13/02)aeFig = get(gco,'Parent');aeH = get(aeFig, 'UserData');aeBoxH = aeH{1};       aeColors = aeH{2};        aeColorStr = aeH{3};aeColrH = aeH{4};      aeFig = aeH{5};           aeStartXPos = aeH{6};aeStartYPos = aeH{7};  axColors = aeH{8};        axH = aeH{9};axPropH = aeH{10};     invertAxPropH = aeH{11};  xticks = aeH{12};xtl = aeH{13};         XTLStr = aeH{14};         xyLimH = aeH{15};yticks = aeH{16};      ytl = aeH{17};            YTLStr = aeH{18};zticks = aeH{19};      ztl = aeH{20};            ZTLStr = aeH{21};invertHCH = aeH{22};% constants for the extra colorsLASTBUILTINCOLOR = 8;ORANGE = 9;  DKORANGE = 10;LTGRAY = 11; DKGRAY = 12;NONE = 13;   OTHER = 14;tag = str2num(whichStr);which = tag(1);col = tag(2);gf = get(ga(1), 'Parent');if strcmp(action, 'cbox')      if which == 1      newstate = get(axPropH(which,col),'Value');      if newstate == 0         set(ga, XTLStr, [])         %set(ga, 'XTick',[]);      elseif newstate == 1         set(ga, 'xticklabelmode','auto');         %set(ga, XTLStr, xtl)         %set(ga, 'XTick', xticks(:,col))      end         elseif which == 2      newstate = get(axPropH(which,col),'Value');      if newstate == 0         set(ga, 'XGrid','off');      elseif newstate == 1         set(ga, 'XGrid', 'on')      end         elseif which == 3      newstate = get(axPropH(which,col),'Value');      if newstate == 0         set(ga, YTLStr,[]);         %set(ga, 'YTick',[]);      elseif newstate == 1         set(ga, 'yticklabelmode','auto');         %set(ga, YTLStr, ytl)         %set(ga, 'YTick', yticks(:,col))      end         elseif which == 4      newstate = get(axPropH(which,col),'Value');      if newstate == 0         set(ga, 'YGrid','off');      elseif newstate == 1         set(ga, 'YGrid', 'on')      end         elseif which == 5      newstate = get(axPropH(which,col),'Value');      if newstate == 0         set(ga, ZTLStr,[]);         %set(ga, 'ZTick',[]);      elseif newstate == 1         set(ga, 'zticklabelmode','auto');         %set(ga, ZTLStr, ztl)         %set(ga, 'ZTick', zticks(:,col))      end         elseif which == 6      newstate = get(axPropH(which,col),'Value');      if newstate == 0         set(ga, 'ZGrid','off');      elseif newstate == 1         set(ga, 'ZGrid', 'on')      end         elseif which == 7      newstate = get(axPropH(which,col),'Value');      if newstate == 0         set(ga, 'XScale','linear');      elseif newstate == 1         set(ga, 'XScale', 'log')      end         elseif which == 8      newstate = get(axPropH(which,col),'Value');      if newstate == 0         set(ga, 'YScale','linear');      elseif newstate == 1         set(ga, 'YScale','log');      end         elseif which == 9      newstate = get(axPropH(which,col),'Value');      if newstate == 0         set(ga, 'ZScale','linear');      elseif newstate == 1         set(ga, 'XScale','log');      end         elseif which == 10      newstate = get(aeBoxH(col),'Value');      if newstate == 0         set(ga, 'Box','off');      elseif newstate == 1         set(ga, 'Box','on');      end         elseif which == 11      newstate = get(invertAxPropH,'Value');      if newstate == 0         % black bg, white objects         set(gf, 'Color', 'k');         set(gf, 'InvertHardCopy', 'on');         %%% don't need explicitly since MATLAB bug is only for title         %if get(get(ga,'XLabel'),'Color') == [0 0 0]         %  set(get(ga,'XLabel'),'Color','w')         %end         %if get(get(ga,'YLabel'),'Color') == [0 0 0]         %  set(get(ga,'YLabel'),'Color','w')         %end         %if get(get(ga,'ZLabel'),'Color') == [0 0 0]         %  set(get(ga,'ZLabel'),'Color','w')         %end         for j = 1:length(ga)            if all( get(get(ga(j),'Title'),'Color')==[0 0 0] )               set(get(ga(j),'Title'),'Color', [1 1 1])            end            set(ga(j),'Color', 'k');            set(ga(j),'XColor', 'w');            set(ga(j),'YColor', 'w');            set(ga(j),'ZColor', 'w');            for i = 1:length(axH)               if strcmp(get(axH(i,j),'Type'),'line') || ...                     strcmp(get(axH(i,j),'Type'),'text')                  if all( get(axH(i,j),'Color')==[0 0 0] )                     set(axH(i,j), 'Color', [1 1 1]);                  end               end            end %for i         end %for j               elseif newstate == 1         % white bg, black objects         set(gf, 'Color', 'w');         set(gf, 'InvertHardCopy', 'off');         %%% don't need explicitly since MATLAB bug is only for title         %if get(get(ga,'XLabel'),'Color') == [1 1 1]         %  set(get(ga,'XLabel'),'Color','k')         %end         %if get(get(ga,'YLabel'),'Color') == [1 1 1]         %  set(get(ga,'YLabel'),'Color','k')         %end         %if get(get(ga,'ZLabel'),'Color') == [1 1 1]         %  set(get(ga,'ZLabel'),'Color','k')         %end         for j = 1:length(ga)            if all( get(get(ga(j),'Title'),'Color')==[1 1 1])               set(get(ga(j),'Title'),'Color', [0 0 0])            end            set(ga(j),'Color', 'w');            set(ga(j),'XColor', 'k');            set(ga(j),'YColor', 'k');            set(ga(j),'ZColor', 'k');            for i = 1:length(axH)               if strcmp(get(axH(i,j),'Type'),'line') || ...                     strcmp(get(axH(i,j),'Type'),'text')                  if all( get(axH(i,j),'Color')==[1 1 1] )                     set(axH(i,j), 'Color', [0 0 0]);                  end               end            end %for i         end %for j      end %if newstate      aEditAct(get(gco,'UserData'),get(gco,'Tag'),'update')         elseif which == 12      if get(invertHCH,'value') == 1         set(gf,'InvertHardCopy','on')      else         set(gf,'InvertHardCopy','off')      end         end %if which   elseif strcmp(action,'lims')   xyzLims(1:2) = get(ga, 'XLim');   xyzLims(3:4) = get(ga, 'YLim');   xyzLims(5:6) = get(ga, 'ZLim');   newLim = str2num( get(xyLimH(which,col),'String') );   if (1)      xyzLims(which) = newLim(1,1);      if (xyzLims(1) < xyzLims(2))         set(ga,'XLim',xyzLims(1:2));      end      if (xyzLims(3) < xyzLims(4))         set(ga,'YLim',xyzLims(3:4));      end      if (xyzLims(5) < xyzLims(6))         set(ga,'ZLim',xyzLims(5:6));      end   end   elseif strcmp(action, 'colr')   colorval = get(aeColrH(which), 'value');   set(aeColrH(which), 'BackgroundColor', 'c')   set(aeColrH(which), 'ForegroundColor', 'k')   if col==1      what=gf;   else      what=ga;   end   if colorval==OTHER      newcolor=uisetcolor;      if newcolor==0         return      end      % truncate the RGB components to fit w/in 13 chars.      for k=1:3         tempstr = [num2str(newcolor(k)) ' 0 '];         if tempstr(1) == '1'            tmpColrStr( (k-1)*4+1:k*4 ) = ' 1  ';         else            tmpColrStr( (k-1)*4+1:k*4 ) = [tempstr(2:4) ' '];         end      end      tmpColrStr = pad(tmpColrStr,13);      % update the popup string      newColorStr = aeColorStr;      newColorStr(OTHER,1:13)=tmpColrStr(1:13);      set(aeColrH(which),'String',newColorStr);      set(aeColrH(which),'value',OTHER); %% <- bec. of ML4 bug      axisedit   elseif colorval == ORANGE      %restore old colors string      set(aeColrH(which),'String',aeColorStr);      set(aeColrH(which),'value',ORANGE); %% <- bec. of ML4 bug      newcolor = [1 0.5 0];   elseif colorval == DKORANGE      %restore old colors string      set(aeColrH(which),'String',aeColorStr);      set(aeColrH(which),'value',DKORANGE); %% <- bec. of ML4 bug      newcolor = [1.0 0.25 0.0];   elseif colorval == LTGRAY      %restore old colors string      set(aeColrH(which),'String',aeColorStr);      set(aeColrH(which),'value',LTGRAY); %% <- bec. of ML4 bug      newcolor = [0.75 0.75 0.75];   elseif colorval == DKGRAY      %restore old colors string      set(aeColrH(which),'String',aeColorStr);      set(aeColrH(which),'value',DKGRAY); %% <- bec. of ML4 bug      newcolor = [0.2 0.2 0.2];   elseif colorval == NONE      %restore old colors string      set(aeColrH(which),'String',aeColorStr);      set(aeColrH(which),'value',NONE); %% <- bec. of ML4 bug      set(what, 'Color', 'none');      set(aeColrH(which), 'BackgroundColor', [1 1 1])      set(aeColrH(which), 'ForegroundColor', [0 0 0])      return   else % colorval <= 8      %restore old colors string      set(aeColrH(which),'String',aeColorStr);      set(aeColrH(which),'value',colorval); %% <- bec. of ML4 bug      newcolor = aeColors(colorval);   end      if (colorval>LASTBUILTINCOLOR) || contains(newcolor,aeColors)      set(what, 'Color', newcolor);   end      set(aeColrH(which), 'BackgroundColor', newcolor)    if sum(newcolor)<0.3 || strcmpi(newcolor,'k')      set(aeColrH(which), 'BackgroundColor', [1 1 1])      set(aeColrH(which), 'ForegroundColor', [0 0 0])   end   elseif strcmp(action,'done') || strcmp(action,'update')   curdir = pwd;   cd(matlabroot)   dErrFlag=0;   try    cd(findomprefs)   catch, dErrFlag=1;end   startXYPos = get(aeFig, 'Position');   aeStartXPos = startXYPos(1);   aeStartYPos = startXYPos(2);   if ~dErrFlag      save aePrefs.mat aeStartXPos aeStartYPos   end   cd(curdir)   close(aeFig)   if strcmp(action,'update')      axisedit   endend