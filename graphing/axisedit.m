% axisedit.m:  change axis properties in a figure% Written by:  Jonathan Jacobs%              March 1997 - February 2006 (last mod: 02/16/06)function axisedit(gf)if isempty(get(0,'Child'))   disp('Nothing to edit, buddy.')   returnendif nargin == 0   gf = findHotW;   if gf == -1      disp('No valid plot window found.  Possible reasons:')      disp(' * You don''t have a figure window open.')      disp(' * You are trying to edit a Zoomtool window.')      disp(' * I am having a nervous breakdown.')      return   endendif strcmp( get(gf,'Tag'), 'EditingWindow')   disp( 'Bring a graph window to the front and try again.')   returnend% get ML versiontemp = version;mlVer = temp(1);% check if the axis editing window is already open% if it is, bring it to the frontwNum = findme('axisEditingWindow');if wNum > -1   figure(wNum)   returnendfontsize=12;txtBG = 'c';txtFG = 'black';BG = [0.75 0.75 0.75];% constants for the extra colorsLASTBUILTINCOLOR = 8;ORANGE = 9;  DKORANGE = 10;LTGRAY = 11; DKGRAY = 12; OFFWHITE = 13;NONE = 14;   OTHER = 15;xtl = []; ytl = []; ztl = [];xticks = []; yticks = []; zticks = [];tmpColrStr = blanks(13);aeColors = ['k','b','g','c','r','m','y','w','?','*','@','#','$','%'];aeColorStr = ['black        ';'blue         ';'green        ';...   'cyan         ';'red          ';'magenta      ';...   'yellow       ';'white        ';'orange       ';...   'dk. orange   ';'lt. gray     ';'dk. gray     ';...   'off-white    ';'none         ';'other...     '];scrsize = get(0,'Screensize');maxHgt = scrsize(4)-35; %% menubar eats some spacemaxWid = scrsize(3);% this little bit of fun is needed because not every child in the figure is an axis.ch = get(gf,'Children');numCh = length(ch);if numCh == 0   disp('Nothing to edit, buddy.')   returnendcount = 0;for i = 1:numCh   if strcmpi(get(ch(i),'type'),'axes')      count = count + 1;      tempga(count) = ch(i);      axpos(count,:) = get(tempga(count),'Position');   endendif ~count, disp('No axes found. Quitting.'); return; end% howzabout a rudimentary sorting from top to bottom% and from left to right, in case we've got m x n axes?tempXY = axpos(:,1:2);[~,ind] = sort(tempXY(:,1));ind = flipud(ind);tempXY = tempXY(ind,:);tempga = tempga(ind);[~,ind] = sort(tempXY(:,2));ind = flipud(ind);tempXY = tempXY(ind,:);ga = tempga(ind);realAxes = length(ga);numAxes = length(ga);% is there a 3D plot?for i = 1:numAxes   azel=get(ga(i),'View');   if azel(1) == 0      is3D = 0;      numDim = 2;   else      is3D = 1;      numDim = 3;   endendaxColors = ['k','b','g','c','r','m','y','w'];numXYZLims = 4;propStr(1,:) = 'X Ticks  ';propStr(2,:) = 'X Grid   ';propStr(3,:) = 'Y Ticks  ';propStr(4,:) = 'Y Grid   ';if is3D   numXYZLims = 6;   propStr(5,:) = 'Z Ticks  ';   propStr(6,:) = 'Z Grid   ';endpropStr(7,:) = 'X Log/Lin';propStr(8,:) = 'Y Log/Lin';propStr(9,:) = 'Z Log/Lin';if mlVer == '4'   XTLStr = 'XTickLabels';   YTLStr = 'YTickLabels';   ZTLStr = 'ZTickLabels';elseif mlVer >= '5'   XTLStr = 'XTickLabel';   YTLStr = 'YTickLabel';   ZTLStr = 'ZTickLabel';endoffset = [0 75];if is3D   fig_width = 485;else   fig_width = 325;endfig_height = (110*numAxes) + 112;% This lets us only show a few axes if we have too much to fit on the screenstartAx=1; stopAx=numAxes;while fig_height>maxHgt && (startAx~=stopAx)   disp('The window required is bigger than the screen.')   %disp('Information will be truncated.')   disp(['There are ' num2str(numAxes) ' axes.  You can select which ones to edit.'])   disp('(Counting goes left to right, and top to bottom, ')   disp('just like natural reading order.)')   startAx=input('Start with axis number: ');   stopAx =input('Stop at axis number: ');   if stopAx<startAx      stopAx=startAx;      disp('Stopping axis must be greater than or equal to starting axis.')   end   numAxes = stopAx-startAx+1;   fig_height = (110*numAxes) + 87;end% We might have too many objects in just one axis so we have to% limit # of objects in the selected axis:if startAx == stopAx && (fig_height > maxHgt)   disp(['There are ' num2str(numObj(startAx)) ' objects in this axis'])   disp('That is too many to display at once.')   while fig_height > maxHgt      startObj(startAx) =input('Start with object number: ');      stopObj(startAx)  =input('Stop at object number: ');      if stopObj(startAx)<startObj(startAx)         stopObj(startAx)=startObj(startAx);         disp('Stopping object must be greater than or equal to starting object.')      end      numObj(startAx) = stopObj(startAx)-startObj(startAx)+1;      fig_height = (110*numAxes) + 87;      if fig_height > maxHgt         disp('Still too many objects.  Try again...')      end   endend% Set the window position.  Check if the window is already open.% If not, then we will first try to read its last saved position from% the pref file.  If not, we will place it at its default position.% Make sure that it will be drawn completely on the screen.% If not, move it so that it will.dErrFlag=0; fErrFlag=0;if ~exist('aeStartXPos','var'), aeStartXPos=[]; endif isempty(aeStartXPos)   curdir = pwd;   cd(matlabroot)   try    cd(findomprefs)   catch, dErrFlag=1; end   if dErrFlag      mkdir_stat = mkdir('omprefs');      if ~mkdir_stat         disp('** axisedit: Unable to create ''omprefs'' dir in MATLAB root dir.')         disp('** You may continue, but prefs will not be saved.')      end   else      try    load aePrefs.mat aeStartXPos aeStartYPos      catch, fErrFlag=1; end      if fErrFlag         aeStartXPos = 50;         aeStartYPos = 100;         save aePrefs.mat      end            cd(curdir)      % make sure that the window will be on the screen!      if aeStartXPos<1,aeStartXPos=1;end      if aeStartYPos<1,aeStartYPos=1;end      if (aeStartYPos+fig_height)>maxHgt         aeStartYPos=maxHgt-fig_height;      end      if (aeStartXPos+fig_width)>maxWid         aeStartXPos=maxWid-fig_width;      end   end   cd(curdir)endif dErrFlag || fErrFlag   aeStartXPos = 20;   aeStartYPos = (maxHgt-fig_height)/2;endaeFig = figure('pos',[aeStartXPos, aeStartYPos, fig_width, fig_height],...   'Resize', 'off', ... %'Color','k',...   'Name', ['Axis editor: editing figure ' num2str(gf)],...   'NumberTitle', 'off','NextPlot', 'new',...   'MenuBar', 'none','Tag', 'axisEditingWindow');axH = zeros(100,numAxes+1); axPropH = [];y_pos = fig_height;%%%%%%  set up the popup menu   %%%%%%% insure that there is a REAL color to set FG & BG menu colorsfigcolr = get(gf,'Color');edFigBGcolr = figcolr;edFigFGcolr = 'k';if ~strcmp(figcolr,'none')   % we might need to use WHITE text if the BG is too dark...   if sum(figcolr)<0.3 || strcmpi(figcolr,'k')      edFigBGcolr = [1 1 1];      edFigFGcolr = [0 0 0];   end   % we might need to use BLACK text if the FG is too light...   if all(figcolr==[1 1 0]) || all(figcolr==[0 1 0]) || all(figcolr==[1 1 1])      edFigFGcolr = 'k';   endend%%%% set the color%% Take care of the special casesif strcmp(figcolr, 'none')   edFigBGcolr = 'k';   edFigFGcolr = 'w';   colrindex = NONE;   elseif (any(figcolr>0 & figcolr<1))   if all(figcolr==[1 0.5 0])      colrindex = ORANGE;      colorStr = aeColors(colrindex);   elseif all(figcolr==[1.0 0.25 0.0])      colrindex = DKORANGE;      colorStr = aeColors(colrindex);   elseif all(figcolr==[0.75 0.75 0.75])      colrindex = LTGRAY;      colorStr = aeColors(colrindex);      colorStr = aeColors(colrindex);   elseif all(figcolr==[0.15 0.15 0.15])      colrindex = DKGRAY;      colorStr = aeColors(colrindex);   elseif all(figcolr==[0.94 0.94 0.94])      colrindex = OFFWHITE;      colorStr = aeColors(colrindex);   else      colrindex = OTHER;   endelse   colrindex = figcolr(1)*4 + figcolr(2)*2 + figcolr(3) + 1;endcolorStr = aeColors(colrindex);% create the popup menuy_pos = y_pos - 30;uicontrol('Style', 'Frame','Position', [2 y_pos-3 275 30], ...   'BackgroundColor',[0.75 0.75 0.75]);uicontrol('Style', 'text', 'pos', [5 y_pos+2 150 20],...   'String','Figure background color','FontSize',fontsize,...   'BackgroundColor',[0.75 0.75 0.75]);aeColrH(numAxes+1) = uicontrol('Style','popup','Units','pixels',...   'BackgroundColor',edFigBGcolr,'ForeGroundColor',edFigFGcolr,...   'Position',[160 y_pos+2 120 20],...   'String',aeColorStr,'FontSize',fontsize, ...   'HorizontalAlignment', 'center',...   'Value', colrindex,...   'UserData', ga(1), 'Tag', mat2str([numAxes+1,1]),...   'Callback','aEditAct(get(gco,''UserData''),get(gco,''Tag''),''colr'')');% modify the popup menuif colrindex == OTHER   % truncate the RGB components to fit w/in 13 chars.   for k=1:3      tempstr = [num2str(figcolr(k)) ' 0 '];      if strcmp(tempstr(1),'1')         tmpColrStr( (k-1)*4+1:k*4 ) = ' 1  ';      else         tmpColrStr( (k-1)*4+1:k*4 ) = [tempstr(2:4) ' '];      end   end   % update the popup string   newColorStr = aeColorStr;   newColorStr(OTHER,1:13)=tmpColrStr(1:13);   set(aeColrH(numAxes+1),'String',newColorStr);   set(aeColrH(numAxes+1),'Value',OTHER); %% <- bec. of ML4 bugend%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% add labelsy_pos = y_pos-30;uicontrol('Style', 'text', 'pos', [  5 y_pos 75 20], 'Str', 'X Low');uicontrol('Style', 'text', 'pos', [ 85 y_pos 75 20], 'Str', 'X High');uicontrol('Style', 'text', 'pos', [165 y_pos 75 20], 'Str', 'Y Low');uicontrol('Style', 'text', 'pos', [245 y_pos 75 20], 'Str', 'Y High');if is3D   uicontrol('Style', 'text', 'pos', [285 y_pos 65 20], 'Str', 'Z Low');   uicontrol('Style', 'text', 'pos', [355 y_pos 65 20], 'Str', 'Z High');endy_pos = y_pos-2;for j=1:realAxes   chilH = get(ga(j), 'Children');   xlabH = get(ga(j),'Xlabel');   ylabH = get(ga(j),'Ylabel');   zlabH = get(ga(j),'Zlabel');   axH(1:length(chilH)+3,j) = [chilH; xlabH; ylabH; zlabH];      xt  = get(ga(j), 'XTick');   xticks(1:length(xt),j) = xt';   xtl = get(ga(j), XTLStr);   if isempty(xtl)      prop(1,j) = 0;   else      prop(1,j) = 1;   end      xgProp = get(ga(j), 'XGrid');   if strcmp(xgProp,'off')      prop(2,j) = 0;   else      prop(2,j) = 1;   end      yt  = get(ga(j), 'YTick');   yticks(1:length(yt),j) = yt';   ytl = get(ga(j), YTLStr);   if isempty(ytl)      prop(3,j) = 0;   else      prop(3,j) = 1;   end      ygProp = get(ga(j), 'YGrid');   if strcmp(ygProp,'off')      prop(4,j) = 0;   else      prop(4,j) = 1;   end      xllProp = get(ga(j), 'XScale');   if strcmp(xllProp,'linear')      prop(7,j) = 0;   else      prop(7,j) = 1;   end      yllProp = get(ga(j), 'YScale');   if strcmp(yllProp,'linear')      prop(8,j) = 0;   else      prop(8,j) = 1;   end      if is3D      zt  = get(ga(j), 'ZTick');      zticks(1:length(zt),j) = zt';      ztl = get(ga(j), ZTLStr);      if isempty(ztl)         prop(5,j) = 0;      else         prop(5,j) = 1;      end            zgProp = get(ga(j), 'ZGrid');      if strcmp(zgProp,'off')         prop(6,j) = 0;      else         prop(6,j) = 1;      end            zllProp = get(ga(j), 'ZScale');      if strcmp(zllProp,'linear')         prop(9,j) = 0;      else         prop(9,j) = 1;      end   endendfor j=startAx:stopAx   % set up the uicontrols   uicontrol('Style', 'Frame','Position', [2 y_pos-103  321+(is3D*160) 107], ...      'BackgroundColor',[0.75 0.75 0.75]);   y_pos = y_pos-25;   xyLims(j,1:2) = get(ga(j), 'XLim');   xyLims(j,3:4) = get(ga(j), 'YLim');   if is3D      xyLims(j,5:6) = get(ga(j), 'ZLim');   end   % axis limits -- editable text   for i=1:numXYZLims      xyLimH(i,j) = uicontrol('Style','edit','Units','pixels',...         'BackgroundColor',txtBG,'ForeGroundColor',txtFG,...         'Position',[5+(i-1)*80 y_pos 75 25],...         'String', num2str(xyLims(j,i)),'FontSize',fontsize, ...         'UserData',ga(j), 'Tag', mat2str([i j]),...         'Callback','aEditAct(get(gco,''UserData''),get(gco,''Tag''),''lims'')');   end      y_pos = y_pos-25;   for i=1:numXYZLims      axPropH(i,j) = uicontrol('Style','checkbox','Units','pixels',...         'BackgroundColor',BG,'ForeGroundColor','black',...         'Position',[5+(i-1)*80 y_pos 75 20],...         'Value', prop(i,j),...         'String',propStr(i,:),'FontSize',fontsize, ...         'UserData',ga(j), 'Tag', mat2str([i j]),...         'Callback','aEditAct(get(gco,''UserData''),get(gco,''Tag''),''cbox'')');   end      y_pos = y_pos-25;   for i=1:numDim      axPropH(6+i,j) = uicontrol('Style','checkbox','Units','pixels',...         'BackgroundColor',BG,'ForeGroundColor','black',...         'Position',[5+(i-1)*160 y_pos 90 20],...         'Value', prop(6+i,j),...         'String',propStr(6+i,:),'FontSize',fontsize, ...         'UserData',ga(j), 'Tag', mat2str([6+i j]),...         'Callback','aEditAct(get(gco,''UserData''),get(gco,''Tag''),''cbox'')');   end         %%%%%%  set up the popup menu   %%%%%%   % insure that there is a REAL color to set FG & BG menu colors   axcolr = get(ga(j),'Color');   edAxBGcolr = axcolr;   edAxFGcolr = 'k';      if ~strcmp(axcolr,'none')      % we might need to use WHITE text if the BG is too dark...      if sum(axcolr)<0.3 || strcmpi(axcolr,'k')         edAxBGcolr = [1 1 1];         edAxFGcolr = [0 0 0];      end      % we might need to use BLACK text if the FG is too light...      if all(axcolr==[1 1 0]) || all(axcolr==[0 1 0]) || all(axcolr==[1 1 1])         edAxFGcolr = 'k';      end   end      %%%% set the color   %% Take care of the special cases   if strcmp(axcolr, 'none')      edAxBGcolr = [1 1 1];      edAxFGcolr = [0 0 0];      colrindex = NONE;         elseif (any(axcolr>0 & axcolr<1))      if all(axcolr==[1 0.5 0])         colrindex = ORANGE;      elseif all(axcolr==[1.0 0.25 0.0])         colrindex = DKORANGE;      elseif all(axcolr==[0.75 0.75 0.75])         colrindex = LTGRAY;      elseif all(axcolr==[0.2 0.2 0.2])         colrindex = DKGRAY;      else         colrindex = OTHER;      end         else      colrindex = axcolr(1)*4 + axcolr(2)*2 + axcolr(3) + 1;   end   colorStr = aeColors(colrindex);      % create the popup menu   y_pos = y_pos - 25;   uicontrol('Style', 'text', 'pos', [5 y_pos 100 20],...      'Str', 'Background color:','FontSize',fontsize,...      'BackgroundColor',[0.75 0.75 0.75]);   aeColrH(j) = uicontrol('Style','popup','Units','pixels',...      'BackgroundColor',edAxBGcolr,'ForeGroundColor',edAxFGcolr,...      'Position',[105 y_pos+2 120 20],...      'String',aeColorStr,'FontSize',fontsize, ...      'HorizontalAlignment', 'center',...      'Value', colrindex,...      'UserData', ga(j), 'Tag', mat2str([j,0]),...      'Callback','aEditAct(get(gco,''UserData''),get(gco,''Tag''),''colr'')');         isBox = strcmp(get(ga(j),'Box'), 'on');   aeBoxH(j) = uicontrol('Style','checkbox','Units','pixels',...      'BackgroundColor',BG,'ForeGroundColor','black',...      'Position',[225 y_pos 80 20],...      'Value', isBox,...      'String','Axis Box','FontSize',fontsize, ...      'UserData',ga(j), 'Tag', mat2str([10 j]),...      'Callback','aEditAct(get(gco,''UserData''),get(gco,''Tag''),''cbox'')');      % modify the popup menu   if colrindex == OTHER      % truncate the RGB components to fit w/in 13 chars.      for k=1:3         tempstr = [num2str(axcolr(k)) ' 0 '];         if tempstr(1) == '1'            tmpColrStr( (k-1)*4+1:k*4 ) = ' 1  ';         else            tmpColrStr( (k-1)*4+1:k*4 ) = [tempstr(2:4) ' '];         end      end      % update the popup string      newColorStr = aeColorStr;      newColorStr(OTHER,1:13)=tmpColrStr(1:13);      set(aeColrH(j),'String',newColorStr);      set(aeColrH(j),'Value',OTHER); %% <- bec. of ML4 bug   end      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   y_pos = y_pos - 10;   endy_pos = y_pos - 20;% do the 'invert' boxfigColr = get(gf,'Color');if strcmp(figColr,'none') || all(figColr==[0 0 0]) || all(figColr==[.2 .2 .2])   invert = 0;else   invert = 1;endinvertAxPropH = uicontrol('Style','checkbox','Units','pixels',...   'BackgroundColor',[.66 .66 .66],'ForeGroundColor',[0 0 0],...   'Position',[95 y_pos 170 20],...   'Value', invert,...   'String','Invert background now','FontSize',fontsize, ...   'UserData', ga, 'Tag', mat2str([11 j]),...   'Callback','aEditAct(get(gco,''UserData''),get(gco,''Tag''),''cbox'')');updateH = uicontrol('Style','push','Units','pixels',...   'Position',[15 y_pos 50 20],...   'String','Update',...   'UserData',aeFig, 'Tag', '[0 0]',...   'Callback','aEditAct(get(gco,''UserData''),get(gco,''Tag''),''update'')');y_pos = y_pos-25;temp = get(gf,'InvertHardcopy');if strcmp(temp,'on')   invertPrint=1;else   invertPrint=0;endinvertHCH = uicontrol('Style','checkbox','Units','pixels',...   'BackgroundColor',[.66 .66 .66],'ForeGroundColor',[0 0 0],...   'Position',[95 y_pos 210 20],...   'Value', invertPrint,...   'String','Force white BG for print or export','FontSize',fontsize, ...   'UserData', ga, 'Tag', mat2str([12 j]),...   'Callback','aEditAct(get(gco,''UserData''),get(gco,''Tag''),''cbox'')');doneH = uicontrol('Style','push','Units','pixels',...   'Position',[15 y_pos 50 20],...   'String','Done',...   'UserData',aeFig, 'Tag', '[0 0]',...   'Callback','aEditAct(get(gco,''UserData''),get(gco,''Tag''),''done'')');% put these handles and parameters into a cell array and place it into% the 'Line editor' window 'UserData' field.  This replaces the use% of global variables. (6/13/02)aeH = {aeBoxH   aeColors      aeColorStr      aeColrH    ...   aeFig    aeStartXPos   aeStartYPos     axColors   ...   axH      axPropH       invertAxPropH   xticks     ...   xtl      XTLStr        xyLimH          yticks     ...   ytl      YTLStr        zticks          ztl        ...   ZTLStr   invertHCH };set(aeFig,'UserData',aeH)%bring graph back to the frontfigure(gf)