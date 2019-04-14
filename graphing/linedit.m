% linedit.m:   change/delete line properties in a figure% Written by:  Jonathan Jacobs%              March 1997 - February 2006  (last mod: 02/16/06)function linedit(gf)if isempty(get(0,'Child'))   disp('Nothing to edit, slick.')   yorn=input('Is there really an open figure? ','s');   if strcmpi(yorn,'y')      disp('MATLAB may have been set to have invisible components.')      yorn=input('I can try to read it anyway.  Would you like me to try? ','s');      if strcmpi(yorn,'y')         set(0,'showhiddenhandles','on')      end   else      return   endendif nargin == 0   gf = findHotW;   if gf == -1      disp('No valid plot window found.  Possible reasons:')      disp(' * You don''t have a figure window open.')      disp(' * You are trying to edit a Zoomtool window.')      disp(' * I am having a nervous breakdown.')      disp(' * The Figure''s objects were set to be invisible.')      disp(' ')      yorn=input('Is there really an open figure? ','s');      if strcmpi(yorn,'y')         disp('The figure may have been set to have invisible components.')         yorn=input('I can try to read it anyway.  Would you like me to try? ','s');         if strcmpi(yorn,'y')            set(0,'showhiddenhandles','on')         end      else         return      end   endendif nargin==0   gf = findHotW;endif ~ishandle(gf)   disp(' ')   disp('I''ve tried all my tricks. I can''t see a figure.')   disp('I apologize, but I must give up. Contact jxj24@case.edu for help.')   returnendfontsize = 12;txtBG = 'c'; % FG/BG for editable text fieldstxtFG = 'k';comp = computer;ver=version;if strcmpi(comp(1),'m')   if ver(1)>=6      newLine = 10;   else      newLine = 13;   endelse   %newLine = [13 10];   newLine = 13;endif strcmp( get(gf,'Tag'), 'EditingWindow')   disp( 'Bring a graph window to the front and try again.')   returnend% check if the line editing window is already open% if it is, bring it to the frontwNum = findme('lineEditingWindow');if wNum > -1   figure(wNum)   returnendscrsize = get(0,'Screensize');mBarHgt = 35;maxHgt = scrsize(4)-mBarHgt;maxWid = scrsize(3);% not every child in the figure is an axis.ch = get(gf,'Children');numCh = length(ch);if numCh == 0   disp('Nothing to edit, slick.')   returnendcount = 0;tempga=zeros(numCh,1);axpos=zeros(numCh,50);for i = 1:numCh   if strcmpi( get(ch(i),'type'),'axes')      count = count + 1;      tempga(count) = ch(i);      axpos(count,1:4) = get(tempga(count),'Position');   endendif count==0, disp('No axes found. Quitting.'); return; end% howzabout a rudimentary sorting from top to bottom% and from left to right, in case we've got m x n axes?tempXY = axpos(:,1:2);[~,ind] = sort(tempXY(:,1));ind = flipud(ind);tempXY = tempXY(ind,:);tempga = tempga(ind);[~,ind] = sort(tempXY(:,2));ind = flipud(ind);%tempXY = tempXY(ind,:);ga = tempga(ind);numAxes = length(ga(ga>0));%tmpColrStr = blanks(13);h.leStyles   = ['- ',': ','-.','--','no'];h.leStyleStr = 'solid|dotted|dashdot|dashed|none';h.leSymbol   = ['.','o','x','+','*','s','d','v','^','<','>','p','h','n'];h.leSymbStr  = ['point|circle|x-mark|plus|star|square|diamond|'...   'triangle (d)|triangle (u)|triangle (l)|triangle (r)|'...   'pentagram|hexagram|none'];h.leColors   = ['k','b','g','c','r','m','y','w','?','*','@','#','$','a','n'];h.leColorStr = [   'black        ';'blue         ';'green        ';...   'cyan         ';'red          ';'magenta      ';...   'yellow       ';'white        ';'orange       ';...   'dk. orange   ';'lt. gray     ';'med. gray    ';...   'dk. gray     ';'off-white    ';'other...     '];h.leMkClrStr = [   'black        ';'blue         ';'green        ';...   'cyan         ';'red          ';'magenta      ';...   'yellow       ';'white        ';'orange       ';...   'dk. orange   ';'lt. gray     ';'med. gray    ';...   'dk. gray     ';'off-white    ';'other...     ';...   'auto         ';'none         '];h.leSurfStr  = ['none  '; 'flat  '; 'interp';'map   ';'[RGB] '];h.leEdgeStr  = ['none  '; 'flat  '; 'interp';'[RGB] '];% constants for the extra colors% LASTBUILTINCOLOR = 8;% ORANGE = 9;  DKORANGE = 10;% LTGRAY = 11; MEDGRAY  = 12;% DKGRAY = 13; OFFWHITE = 14;OTHER = 15;  %AUTO = 16; NONE = 17;% set up the uilineH  = zeros(20,numAxes);patchH = zeros(20,numAxes);surfH  = zeros(20,numAxes);numLines = zeros(numAxes,1); numPatch = zeros(numAxes,1);numSurf  = zeros(numAxes,1); numObj   = zeros(numAxes,1);startObj = zeros(numAxes,1); stopObj  = zeros(numAxes,1);totalLines = zeros(numAxes,1);h.leH  = zeros(60,numAxes); % collection of lines, patches and surfaces% how many lines/surfaces/patches are in each axisfor k = 1:numAxes   [numLines(k)] = countobj('line', ga(k));   if numLines(k) > 0      [numLines(k),  lineH(1:numLines(k),k)] = countobj('line', ga(k));   end   [numPatch(k)] = countobj('patch', ga(k));   if numPatch(k) > 0      [numPatch(k), patchH(1:numPatch(k),k)] = countobj('patch', ga(k));   end   [numSurf(k)] = countobj('surface', ga(k));   if numSurf(k) > 0      [numSurf(k), surfH(1:numSurf(k),k)] = countobj('surface', ga(k));   end   numObj(k) = numLines(k) + numPatch(k)+ numSurf(k);   h.leH(1:numObj(k),k) = [lineH(1:numLines(k),k); ...      patchH(1:numPatch(k),k); surfH(1:numSurf(k),k)];   totalLines(k) = numObj(k);   startObj(k) = 1;   stopObj(k) = numObj(k);end%popup_wid = 110;%ctrl_height = 30;fig_width = 550;fig_height = 50*sum(totalLines) + 12*numAxes + 55;% This lets us only show a few axes if we have too much to fit on the screenstartAx=1; stopAx=numAxes;while fig_height>maxHgt && startAx~=stopAx   disp('The window required is bigger than the screen.')   %disp('Information will be truncated.')   disp(['There are ' num2str(numAxes) ' axes.  You can select which ones to edit.'])   disp('(Counting goes left to right, and top to bottom, ')   disp('just like natural reading order.)')   startAx=input('Start with axis number: ');   stopAx =input('Stop at axis number: ');   if stopAx<startAx      stopAx=startAx;      disp('Stopping axis must be greater than or equal to starting axis.')   end   numAxes = stopAx-startAx+1;   fig_height = 45*sum(totalLines(startAx:stopAx)) + 12*numAxes + 55;end% We might have too many objects in just one axis so we have to% limit # of objects in the selected axis:if startAx == stopAx && (fig_height > maxHgt)   disp(['There are ' num2str(numObj(startAx)) ' objects in this axis'])   disp('That is too many to display at once.')   while fig_height > maxHgt      startObj(startAx) = input('Start with object number: ');      temp              = input('Stop at object number: ');      stopObj(startAx)  = min(temp, numObj(startAx));      if stopObj(startAx)<startObj(startAx)         stopObj(startAx)=startObj(startAx);         disp('Stopping object must be greater than or equal to starting object.')      end      numObj(startAx) = stopObj(startAx)-startObj(startAx)+1;      fig_height = 45*numObj(startAx) + 10 + 55;      if fig_height > maxHgt         disp('Still too many objects.  Try again...')      end   endend% Set the window position.  Check if the window is already open.% If not, then we will first try to read its last saved position from% the pref file.  If not, we will place it at its default position.% Make sure that it will be drawn completely on the screen.% If not, move it so that it will.dErrFlag=0; fErrFlag=0;if ~exist('leStartXPos','var'),leStartXPos=[];leStartYPos=[]; endif isempty(leStartXPos)   curdir=pwd;   cd(matlabroot)   try    cd(findomprefs)   catch, dErrFlag=1; end   if dErrFlag      mkdir_stat=mkdir('omPrefs');      if ~mkdir_stat         disp('** linedit: Unable to create ''omPrefs'' dir.')         disp('** You may continue, but prefs will not be saved.')      end   else      try    load le5Prefs.mat leStartXPos leStartYPos      catch, fErrFlag=1; end      if fErrFlag         leStartXPos = 50;         leStartYPos = 100;         save le5Prefs.mat leStartXPos leStartYPos      end            % make sure that the window will be on the screen!      if leStartXPos<1,leStartXPos=1;end      if leStartYPos<1,leStartYPos=1;end      if (leStartYPos+fig_height)>maxHgt         leStartYPos=maxHgt-fig_height;      end      if (leStartXPos+fig_width)>maxWid         leStartXPos=maxWid-fig_width;      end   end   cd(curdir)endif dErrFlag || fErrFlag   leStartXPos = 20;   leStartYPos = (maxHgt-fig_height)/2;endif ishandle(gf)   fignum=num2str(gf.Number);else   fignum=num2str(gf);endleFig = figure('pos',[leStartXPos, leStartYPos, fig_width, fig_height],...   'Resize', 'off','Name',['Line editor: editing figure ' fignum],...   'NumberTitle', 'off','MenuBar', 'none',... %'Color','k',...   'NextPlot','new',...   'Tag','lineEditingWindow');% set up the labelsuicontrol('Style', 'text', 'Units', 'pixels',...   'Position',[50 fig_height-35 85 30],...   'HorizontalAlignment','Center','FontSize',11, ...   'String', ['Line Color' newLine '(Face Color)']);uicontrol('Style', 'text', 'Units', 'pixels',...   'Position',[165 fig_height-35 75 30],...   'HorizontalAlignment','Center','FontSize',11, ...   'String', ['Line Style' newLine 'Width']);uicontrol('Style', 'text', 'Units', 'pixels',...   'Position',[275 fig_height-35 95 30],...   'HorizontalAlignment','Center','FontSize',11, ...   'String', ['Symbol Type' newLine 'Edge Color']);uicontrol('Style', 'text', 'Units', 'pixels',...   'Position',[390 fig_height-35 75 30],...   'HorizontalAlignment','Center','FontSize',11, ...   'String', ['Symbol Size' newLine 'Face Color']);uicontrol('Style', 'text', 'Units', 'pixels',...   'Position',[500 fig_height-35 40 30],...   'HorizontalAlignment','Center','FontSize',11, ...   'String', ['Data' newLine 'Ops.']);y_pos = fig_height-35;for j=startAx:stopAx   y_pos = y_pos+20;   for i=startObj(j):stopObj(j)      uicontrol('Style','Frame','Pos',[2 y_pos-75 545 50],...         'BackgroundColor',[0.75 0.75 0.75]);      y_pos = y_pos-50;            if strcmp(get(h.leH(i,j),'Selected'),'on')  % show me!         showStr = 'Don''t';      else         showStr = 'Show';      end      h.edShowMeH(i,j) = uicontrol('Style','Push','Units','Pixels',...         'Position', [5 y_pos-16 41 36],...         'String',showStr,'FontSize',fontsize, ...         'UserData',ga(j), 'Tag', mat2str([i,j]),...         'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''showme'')');            % read through each axis object, get its type, color, style, marker, etc.      % line/patch color      isLine  = strcmpi(get(h.leH(i,j),'Type'), 'line');      isSurf  = strcmpi(get(h.leH(i,j),'Type'), 'surface');      isPatch = strcmpi(get(h.leH(i,j),'Type'), 'patch');      if isLine         lcolr = get(h.leH(i,j),'Color');         color = whatcolor(lcolr);         lFGcolr = lcolr;         lBGcolr = color.bgstr;         lColrIndex = color.index;               elseif isPatch         peColr = get(h.leH(i,j),'EdgeColor');         color = whatcolor(peColr);         lFGcolr    = colorval;         lBGcolr    = color.bgstr;         lColrIndex = color.index;                  pfColr = get(h.leH(i,j),'FaceColor');         color = whatcolor(pfColr);         pfFGcolr = colorval;         pfBGcolr = color.bgstr;         pfColrIndex = color.index;               elseif isSurf         %lcolr = [0 0 0];         %sfStrFlag=0; %seStrFlag=0;                  % surface face color         sfColr = get(h.leH(i,j),'FaceColor');         if ischar(sfColr)            %sfStrFlag=1;            switch sfColr               case 'none',       sFaceIndex=1;               case 'flat',       sFaceIndex=2;               case 'interp',     sFaceIndex=3;               case 'texturemap', sFaceIndex=4;            end         else            %lcolr = sfColr;            sFaceIndex=5;         end         color = whatcolor(sfColr);         sfFGcolr = sfColr;         sfBGcolr = color.bgstr;         %sFaceIndex = color.index;                  % surface edge color         seColr = get(h.leH(i,j),'EdgeColor');         if ischar(seColr)            %seStrFlag=1;            switch seColr               case 'none',   sEdgeIndex=1;               case 'flat',   sEdgeIndex=2;               case 'interp', sEdgeIndex=3;            end         else            %lcolr = seColr;            sEdgeIndex=4;         end         color = whatcolor(seColr);         seFGcolr = sfColr;         seBGcolr = color.bgstr;         %sEdgeIndex = color.index;      end %is line/patch/surf                        % create and set the popup menus      if isLine || isPatch     % create the line/patch popup menus         h.edLSFaceH(i,j) = 0;         h.edLSEdgeH(i,j) = 0;         %lFGcolr = [0 0 0];   %%% 08/01/08 fix         %pfFGcolr = [0 0 0];   %%% 08/01/08 fix         h.edLColrH(i,j) = uicontrol('Style','popup','Units','pixels',...            'Position',[45 y_pos 116 20],...            'String',h.leColorStr,'FontSize',fontsize, ...            'Value', lColrIndex,'UserData',ga(j), 'Tag', mat2str([i,j]),...            'BackgroundColor',lBGcolr,'ForeGroundColor',lFGcolr,...            'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''colr'')');         if isPatch            h.edLFColrH(i,j) = uicontrol('Style','popup','Units','pixels',...               'BackgroundColor',pfBGcolr,'ForeGroundColor',pfFGcolr,...               'Position',[45 y_pos-20 115 20],...               'String',h.leColorStr,'FontSize',fontsize, ...               'Value', pfColrIndex,'FontSize',fontsize, ...               'UserData',ga(j), 'Tag', mat2str([i,j]),...               'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''fcolr'')');         else            h.edLFColrH(i,j) = 0;         end                        elseif isSurf     % make the surf popup menus         %if ~sfStrFlag, sFaceIndex = 5; end         h.edLColrH(i,j) = 0;         h.edLFColrH(i,j) = 0;         %seFGcolr = [0 0 0];   %%% 08/01/08 fix         %sfFGcolr = [0 0 0];   %%% 08/01/08 fix         h.edLSFaceH(i,j) = uicontrol('Style','popup','Units','pixels',...            'BackgroundColor',sfBGcolr,'ForeGroundColor',sfFGcolr,...            'Position',[45 y_pos-20 116 20],...            'String',h.leSurfStr,'FontSize',fontsize, ...            'Value', sFaceIndex,...            'UserData',ga(j), 'Tag', mat2str([i,j]),...            'Callback',...            'lEditAct(get(gco,''UserData''),get(gco,''Tag''),''surf'')');         h.edLSEdgeH(i,j) = uicontrol('Style','popup','Units','pixels',...            'BackgroundColor',seBGcolr,'ForeGroundColor',seFGcolr,...            'Position',[45 y_pos 116 20],...            'String',h.leEdgeStr,'FontSize',fontsize, ...            'Value', sEdgeIndex,...            'UserData',ga(j), 'Tag', mat2str([i,j]),...            'Callback',...            'lEditAct(get(gco,''UserData''),get(gco,''Tag''),''edge'')');      end             if isLine || isPatch         % modify the popup menu         if lColrIndex == OTHER            newColorStr = h.leColorStr;            newColorStr(OTHER,1:13)=pad(color.str,13);            set(h.edLColrH(i,j),'String',newColorStr);         end      end            if isPatch         % modify the edge color popup menu         if pfColrIndex == OTHER            newColorStr = h.leColorStr;            newColorStr(OTHER,1:13)=pad(color.str,13);            set(h.edLFColrH(i,j),'String',newColorStr);         end      end            temp = get(h.leH(i,j),'LineStyle');      if length(temp)==1         linStyle = [temp, ' '];      else         linStyle = temp;      end      temp = strfind(h.leStyles,linStyle(1:2));      styleIndex = (temp+1)/2;      h.edLStylH(i,j) = uicontrol('Style','popup','Units','pixels',...         'BackgroundColor',txtBG,'ForeGroundColor',txtFG,...         'Position',[160 y_pos 116 20],...         'String',h.leStyleStr,'FontSize',fontsize, ...         'Value',styleIndex, 'UserData',ga(j), 'Tag', mat2str([i,j]),...         'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''style'')');            h.edLWidH(i,j) = uicontrol('Style','edit','Units','pixels',...         'BackgroundColor',txtBG,'ForeGroundColor',txtFG,...         'Position',[170 y_pos-22 40 20],...         'String',num2str(get(h.leH(i,j),'LineWidth')),...         'FontSize',fontsize,'UserData',ga(j), 'Tag', mat2str([i,j]),...         'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''width'')');                  %%%if (1)     %% isLine      symb = get(h.leH(i,j),'Marker');      symbIndex = strfind(h.leSymbol,symb(1));      h.edLSymbH(i,j) = uicontrol('Style','popup','Units','pixels',...         'Position',[270 y_pos 116 20],...         'String',h.leSymbStr,'FontSize',fontsize, ...         'Value',symbIndex, 'UserData',ga(j), 'Tag', mat2str([i,j]),...         'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''symb'')');            % set marker edge color      edgeClr = get(h.leH(i,j),'MarkerEdgeColor');      color = whatcolor(edgeClr);      meFGcolr = edgeClr;      meBGcolr = color.bgstr;      meColrIndex = color.index;            if strcmpi(edgeClr,'none') || strcmpi(edgeClr,'auto')         meBGcolr = 'w';         meFGcolr = 'k';      end            % update the popup string      newColorStr = h.leMkClrStr;      newColorStr(OTHER,1:13)=pad(color.str,13);            h.edLMkEdClrH(i,j) = uicontrol('Style','popup','Units','pixels',...         'BackgroundColor',meBGcolr,'ForeGroundColor',meFGcolr,...         'Position',[270 y_pos-20 116 20],...         'String',h.leMkClrStr,'FontSize',fontsize, ...         'Value',meColrIndex,...         'UserData',ga(j), 'Tag', mat2str([i,j]),...         'Callback',...         'lEditAct(get(gco,''UserData''),get(gco,''Tag''),''mkeclr'')');      set(h.edLMkEdClrH(i,j),'String',newColorStr);            % marker face color      faceClr = get(h.leH(i,j),'MarkerFaceColor');      color = whatcolor(faceClr);      mfFGcolr = faceClr;      mfBGcolr = color.bgstr;      mfColrIndex = color.index;            if strcmpi(faceClr,'none') || strcmpi(faceClr,'auto')         mfBGcolr = 'w';         mfFGcolr = 'k';      end            % update the popup string      newColorStr = h.leMkClrStr;      newColorStr(OTHER,1:13)=pad(color.str,13);            h.edLMkFcClrH(i,j) = uicontrol('Style','popup','Units','pixels',...         'BackgroundColor',mfBGcolr,'ForeGroundColor',mfFGcolr,...         'Position',[388 y_pos-20 116 20],...         'String',h.leMkClrStr,'FontSize',fontsize, ...         'Value',mfColrIndex, 'UserData',ga(j), 'Tag', mat2str([i,j]),...         'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''mkfclr'')');      set(h.edLMkFcClrH(i,j),'String',newColorStr);            % marker size      h.edLMSzH(i,j) = uicontrol('Style','edit','Units','pixels',...         'BackgroundColor',txtBG,'ForeGroundColor',txtFG,...         'Position',[395 y_pos+2 40 20],...         'String',num2str(get(h.leH(i,j),'MarkerSize')),...         'FontSize',fontsize, 'UserData',ga(j), 'Tag', mat2str([i,j]),...         'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''mrkrSz'')');            %%%else      %%%   edLSymH(i,j) = 0;      %%%   h.edLMSzH(i,j) = 0;      %%%   h.edLMkEdClrH(i,j) = 0;      %%%   h.edLMkFcClrH(i,j) = 0;      %%%end            h.edLDelH(i,j) = uicontrol('Style','push','Units','pixels',...         'Position',[445 y_pos+2 40 20],...         'String','Delete','FontSize',fontsize, ...         'UserData',ga(j), 'Tag', mat2str([i,j]),...         'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''delete'')');            if isLine         h.yankH(i,j) = uicontrol('Style','push','Units','Pixels',...            'Position',[500 y_pos+2 40 20],...            'String','Copy', 'FontSize',fontsize, ...            'UserData',ga(j), 'Tag', mat2str([i,j]),...            'Tooltip','Copy data to base workspace as "xdata", "ydata"',...            'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''datacopy'')');      end         end   y_pos = y_pos-28;end %for jy_pos = y_pos-20;doneLH = uicontrol('Style','push','Units','pixels',...   'Position',[5 y_pos 50 20],...   'String','Done',...   'UserData',leFig, 'Tag', '[0 0]',...   'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''done'')'); %#ok<NASGU>updateLH = uicontrol('Style','push','Units','pixels',...   'Position',[75 y_pos 50 20],...   'String','Update',...   'UserData',leFig, 'Tag', '[0 0]',...   'Callback','lEditAct(get(gco,''UserData''),get(gco,''Tag''),''update'')'); %#ok<NASGU>% put these handles and parameters into a cell array and place it into% the 'Line editor' window 'UserData' field.  This replaces the use% of global variables. (6/13/02)% h.leH = {h.edLColrH      h.edLDelH      h.edLFColrH    h.edLMkEdClrH ...%    h.edLMkFcClrH   h.edLMSzH      h.edLSEdgeH    h.edLSFaceH   ...%    h.edLStylH      h.edLSymbH     h.edLWidH      edShowMeH   ...%    leColors      h.leColorStr   leFig        h.leH         ...%    h.leMkClrStr    leStartXPos  leStartYPos  h.leStyles    ...%    h.leSymbol      h.leSymbStr};set(leFig,'UserData',h)% bring the graph back to the frontfigure(gf)