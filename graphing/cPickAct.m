% cpickact.m: back end of "colrpick," a slider-based GUI to select colors.% Written by: Jonathan Jacobs%             January 1998 - June 2002 (last mod: 06/13/02)% no mods between 1/98 and 6/02% 6/13/02: got rid of global variables.function cPickAct( action )if nargin==0,colrpick;return;end% get the handles and parameters declared and set in 'PosEdit'% from the 'UserData' field of the 'Position editor' window.% This is a much cleaner method than relying on global variables (6/13/02)cpFig = findwind('Color Picker');cpH   = get(cpFig, 'UserData');cpBlueDataH = cpH{1};    cpBlueSlideH= cpH{2};    %cpBlueVal = cpH{3};cpFig = cpH{5};          cpGreenDataH = cpH{6};   %cpDoneH = cpH{4};cpGreenSlideH = cpH{7};  cpRedDataH = cpH{9};     %cpGreenVal = cpH{8};cpRedSlideH = cpH{10};   cpTestH = cpH{12};       %cpRedVal = cpH{11};colorChanged = 0;redVal=get(cpRedSlideH,'Val');greenVal=get(cpGreenSlideH,'Val');blueVal=get(cpBlueSlideH,'Val');if contains(action, 'slide')   colorChanged = 1;   switch action      case 'redslide'         redVal=get(cpRedSlideH,'Val');         set(cpRedDataH,'String', num2str(redVal,2));               case 'greenslide'         greenVal=get(cpGreenSlideH,'Val');         set(cpGreenDataH,'String', num2str(greenVal,2));               case 'blueslide'         blueVal=get(cpBlueSlideH,'Val');         set(cpBlueDataH,'String', num2str(blueVal,2));         % set live update of slider         %      otherwise   end   endif contains(action, 'text')   colorChanged = 1;   switch action      case 'redtext'         newRedVal = str2double(get(cpRedDataH,'String'));         if (newRedVal >= 0) && (newRedVal <= 1)            set(cpRedSlideH, 'Value', newRedVal);         else            set(cpRedDataH, 'String', num2str(redVal));         end      case 'greentext'         newGreenVal = str2double(get(cpGreenDataH,'String'));         if (newGreenVal >= 0) && (newGreenVal <= 1)            set(cpGreenSlideH, 'Value', newGreenVal);         else            set(cpGreenDataH, 'String', num2str(greenVal));         end      case 'bluetext'         newBlueVal = str2double(get(cpBlueDataH,'String'));         if (newBlueVal >= 0) && (newBlueVal <= 1)            set(cpBlueSlideH, 'Value', newBlueVal);         else            set(cpBlueDataH, 'String', num2str(blueVal));         end      otherwise   endendif colorChanged   cpRedVal=get(cpRedSlideH,'Val');   cpGreenVal=get(cpGreenSlideH,'Val');   cpBlueVal=get(cpBlueSlideH,'Val');   color=whatcolor([cpRedVal cpGreenVal cpBlueVal]);   set(cpTestH, 'BackGroundColor', [cpRedVal cpGreenVal cpBlueVal]);   set(cpTestH, 'ForeGroundColor', color.bg);   returnendif strcmp( action, 'done')   figure(cpFig)   closeend