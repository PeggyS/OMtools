% simlib.m:    displays a palette to open the OMlab simulation libraries% Written by:  Jonathan Jacobs%              December 1997 - January 1998 (last mod: 01/08/98)function simlib(numCols)% check if the simulation library window is already open% if it is, bring it to the frontwNum = findMe('simEditingWindow');if wNum > -1   figure(wNum)   returnendcomp = computer;CR = [13];% If you want to add a new library button, all you need to do is% create new 'libStr' and 'cbStr' entries.  Just make sure that you% pad all string entries with blanks so they are all the same length% libStr: text that shows up in the buttonlibStr(1,:) = ['CN Library '];libStr(2,:) = ['LN Library '];libStr(3,:) = ['SP Library '];libStr(4,:) = ['Sacc. Lib. '];libStr(5,:) = ['Plant Lib. '];libStr(6,:) = ['Stim. Lib. '];libStr(7,:) = ['Filter Lib.'];libStr(8,:) = ['Misc. Lib. '];libStr(9,:) = ['Testbed    '];% cbStr: mfile called when button is clickedcbStr(1,:) = ['cnlib5   '];cbStr(2,:) = ['lnlib5   '];cbStr(3,:) = ['splib5   '];cbStr(4,:) = ['sacclib5 '];cbStr(5,:) = ['plantlib5'];cbStr(6,:) = ['stimlib5 '];cbStr(7,:) = ['filtlib5 '];cbStr(8,:) = ['misclib5 '];cbStr(9,:) = ['testbed5 '];numLibs = min(size(libStr));buttonWid = 80;buttonHgt = 30;if nargin == 0   numCols = 3;endfig_width = numCols*(buttonWid+8);fig_height = (fix((numLibs-1)/numCols)+1)*(buttonHgt+5) + 5;startXPos = 20;startYPos = 30;y_pos = fig_height-5;simlibFig = figure('pos',[startXPos, startYPos, fig_width, fig_height],...       'Resize', 'off', 'Name', 'Simulation Libraries',...       'NumberTitle', 'off',... %'NextPlot', 'new',...       'MenuBar', 'none',...       'Tag','simmEditingWindow');% set up the labels%y_pos = y_pos-30;%uicontrol('Style', 'text', 'Units', 'pixels',...%          'Position',[5 y_pos 180 25],...%          'String', ['Click a button to open the library']);% set up the uicontrolsy_pos = y_pos - buttonHgt;count=0;numRows = fix((numLibs-1)/numCols) + 1;for y=1:numRows   x_pos = 10;   for x=1:numCols      count = count + 1;      if count <= numLibs         libH(x,y) = uicontrol('Style','push','Units','pixels',...           'BackgroundColor','magenta','ForeGroundColor','white',...           'Position',[x_pos y_pos buttonWid buttonHgt],...           'String',libStr(count,:),...           'UserData',' ', 'Tag',' ',...           'Callback',[cbStr(count,:)]);           x_pos = x_pos + buttonWid+5;      end   end   y_pos = y_pos - (buttonHgt+5);end% set the editing window so that we can't plot anything in itmlVer = version;if mlVer(1) == '4'   set(simlibFig, 'NextPlot', 'new'); elseif mlVer(1) >= '5'   hidegui else   error('unknown MATLAB version!')   returnend