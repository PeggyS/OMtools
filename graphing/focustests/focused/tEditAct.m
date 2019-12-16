% tEditAct.m: called by textedit to make the changes to text properties.% Written by: Jonathan Jacobs%             March 1997 - June 2019 (last mod: 06/03/19)function tEditAct(src,action)if nargin<2,textedit;return;endteFig = findme('textEditingWindow');if ishandle(teFig)	h = teFig.UserData;else	disp('Cannot find the editor window')   beep	returnend% control,axis numbers stored in TagwhichStr=src.Tag;tag = str2num(whichStr); %#ok<ST2NM>linum = tag(1);axnum = tag(2);ud=src.UserData;if ~ishandle(ud)   disp('That figure is no longer available.')   disp('This is the current window.')   gf=findHotW;   figure(gf)endif strcmpi(ud.Type,'axes')   gf=get(ud,'Parent');   ga=ud;elseif strcmpi(ud.Type,'figure')   gf=ud;endaxList = findobj(gf,'Type','axes');numAxes=length(axList);if strcmp(action, 'delete')   try delete(h.textH(linum,axnum)); catch; end   % remove the controls for that row   try delete(h.edTxtH(linum,axnum)); catch; end   try delete(h.edTFSzH(linum,axnum)); catch; end   try delete(h.edTRotH(linum,axnum)); catch; end   try delete(h.edTColrH(linum,axnum)); catch; end   try delete(h.edTDelH(linum,axnum)); catch; end   try delete(h.edTFontH(linum,axnum)); catch; end   try delete(h.edAxLabelH(linum,axnum)); catch; end   elseif strcmp(action, 'fontS')   newfsize = str2double(h.edTFSzH(linum,axnum).String);   if (newfsize>=6) && (newfsize<=24)      h.textH(linum,axnum).FontSize=newfsize;   end   elseif strcmp(action, 'str')   newstr = h.edTxtH(linum,axnum).String;   h.textH(linum,axnum).String=newstr;   elseif strcmp(action, 'font')   uisetfont(h.textH(linum,axnum),'Font Properties');   newfsize = h.textH(linum,axnum).FontSize;   h.edTFSzH(linum,axnum).String=num2str(newfsize);   elseif strcmp(action, 'axFont')   a=uisetfont(ga, 'Font Properties');   if ~isstruct(a), return; end        %% if cancelled   newFontName = ga.FontName;   newFontSize = ga.FontSize;   %newFontAngle = get(ga,'FontAngle');   %newFontStrikeThrough = get(ga,'FontStrikeThrough');   %newFontUnderline = get(ga,'FontUnderline');   %newFontWeight = get(ga,'FontWeight');   for i = 1:numAxes      axList(i).FontName=newFontName;      axList(i).FontSize=newFontSize;      %set(axList(i),'FontAngle',newFontAngle);      %set(axList(i),'FontStrikeThrough',newFontStrikeThrough);      %set(axList(i),'FontUnderline',newFontUnderline);      %set(axList(i),'FontWeight',newFontWeight);   end   h.edTaxFSzH.String=num2str(newFontSize);   elseif strcmp(action, 'axFontS')   newfsize = str2double(h.edTaxFSzH.String);   if (newfsize>=6) && (newfsize<=24)      for i = 1:numAxes         axList(i).FontSize=newfsize;      end   end   elseif strcmp(action, 'rot')   newrot = str2double(h.edTRotH(linum,axnum).String);   if (newrot>=0) && (newrot<=360)      h.textH(linum,axnum).Rotation=newrot;   end   elseif strcmp(action, 'colr')   colorval = h.edTColrH(linum,axnum).Value;   color = whatcolor(colorval);   newcolor = color.rgb;   h.textH(linum,axnum).Color=newcolor;   h.edTColrH(linum,axnum).ForegroundColor=color.fg;   h.edTColrH(linum,axnum).BackgroundColor=color.bg;      elseif strcmp(action, 'axColr')   colorval = h.edTaxColrH.Value;   color = whatcolor(colorval);   newcolor = color.rgb;   h.edTaxColrH.ForegroundColor=color.fg;   h.edTaxColrH.BackgroundColor=color.bg;   for i=1:numAxes      axList(i).XColor=newcolor;      axList(i).YColor=newcolor;      axList(i).ZColor=newcolor;   end      elseif any( strcmp(action,{'refresh','done','focusgained'}) )   curdir=pwd;   dErrFlag = 0;   cd(matlabroot)   try    cd(findomprefs)   catch, dErrFlag=1; end   startXYPos  = teFig.Position;   teStartXPos = startXYPos(1);   teStartYPos = startXYPos(2);   teStartYHgt = startXYPos(4);   if ~dErrFlag      save tePrefs.mat teStartXPos teStartYPos teStartYHgt   end   cd(curdir)   close(teFig)   if any(strcmp(action,{'refresh','focusgained'}))      gf=findHotW;      figure(gf)      textedit   endend