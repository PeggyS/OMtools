% cpickact.m: back end of "colrpick," a slider-based GUI to select colors.% Written by: Jonathan Jacobs%             January 1998 - June 2002 (last mod: 06/13/02)% no mods between 1/98 and 6/02% 6/13/02: got rid of global variables.function cpickact( action )% get the handles and parameters declared and set in 'PosEdit'% from the 'UserData' field of the 'Position editor' window.  % This is a much cleaner method than relying on global variables (6/13/02)cpFig = get(gco,'Parent');cpH   = get(cpFig, 'UserData');cpBlueDataH = cpH{1};    cpBlueSlideH= cpH{2};    cpBlueVal = cpH{3};cpDoneH = cpH{4};        cpFig = cpH{5};          cpGreenDataH = cpH{6};cpGreenSlideH = cpH{7};  cpGreenVal = cpH{7};     cpRedDataH = cpH{9};     cpRedSlideH = cpH{10};   cpRedVal = cpH{11};      cpTestH = cpH{12};colorChanged = 0;redVal=get(cpRedSlideH,'Val');          greenVal=get(cpGreenSlideH,'Val');          blueVal=get(cpBlueSlideH,'Val');          if findstr(action, 'slide')   colorChanged = 1;   if strcmp( action, 'redslide')      redVal=get(cpRedSlideH,'Val');      set(cpRedDataH,'String', num2str(redVal));   end      if strcmp( action, 'greenslide')      greenVal=get(cpGreenSlideH,'Val');      set(cpGreenDataH,'String', num2str(greenVal));   end   if strcmp( action, 'blueslide')      blueVal=get(cpBlueSlideH,'Val');              set(cpBlueDataH,'String', num2str(blueVal));   endend   if findstr(action, 'text')   colorChanged = 1;   if strcmp( action, 'redtext')      newRedVal = str2num(get(cpRedDataH,'String'));      if (newRedVal >= 0) & (newRedVal <= 1)         set(cpRedSlideH, 'Value', newRedVal);      else         set(cpRedDataH, 'String', num2str(redVal));      end   end   if strcmp( action, 'greentext')      newGreenVal = str2num(get(cpGreenDataH,'String'));      if (newGreenVal >= 0) & (newGreenVal <= 1)         set(cpGreenSlideH, 'Value', newGreenVal);      else         set(cpGreenDataH, 'String', num2str(greenVal));      end   end   if strcmp( action, 'bluetext')      newBlueVal = str2num(get(cpBlueDataH,'String'));      if (newBlueVal >= 0) & (newBlueVal <= 1)         set(cpBlueSlideH, 'Value', newBlueVal);      else         set(cpBlueDataH, 'String', num2str(BlueVal));      end   endendif colorChanged   cpRedVal=get(cpRedSlideH,'Val');             cpGreenVal=get(cpGreenSlideH,'Val');             cpBlueVal=get(cpBlueSlideH,'Val');             set(cpTestH, 'BackGroundColor', [cpRedVal cpGreenVal cpBlueVal]);   %waitforbuttonpress   returnendif strcmp( action, 'done')   figure(cpFig)   closeend