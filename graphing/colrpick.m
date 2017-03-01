% colrPick.m: a slider-based GUI to pick colors by RGB values.% written by: Jonathan Jacobs%             January 1998 - June 2002 (last mod: 06/13/02)% no mods between 1/98 and 6/02% 6/13/02: got rid of global variables.function colrPick(null)cpRedVal = []; cpGreenVal = []; cpBlueVal = [];fig_width = 310;fig_height = 115;cpStartXPos = 20;cpStartYPos = (480 - fig_height)/2;% make the windowcpFig = figure('pos',[cpStartXPos, cpStartYPos, fig_width, fig_height],...       'Resize', 'off', 'Name', 'Color Picker',...       'NumberTitle', 'off',...       'MenuBar', 'none',...       'Tag', 'colrEditingWindow');% ***************************************************************% create the sliderscpRedSlideH = uicontrol(cpFig, 'Style', 'slider',...   'Position', [55 80 190 20],...   'Min', 0, 'Max', 1, 'Value', 0.5,...   'Callback',[ 'cpickact(''redslide'');']);cpGreenSlideH = uicontrol(cpFig, 'Style', 'slider',...   'Position', [55 55 190 20],...   'Min', 0, 'Max', 1, 'Value', 0.5,...   'Callback',[ 'cpickact(''greenslide'');']);cpBlueSlideH = uicontrol(cpFig, 'Style', 'slider',...   'Position', [55 30 190 20],...   'Min', 0, 'Max', 1, 'Value', 0.5,...   'Callback',[ 'cpickact(''blueslide'');']);% ***************************************************************% create the labelsr_label = uicontrol(cpFig, 'Style', 'text',...   'BackgroundColor','r',...   'Pos', [10 80 40 20],...   'String', 'Red');   g_label = uicontrol(cpFig, 'Style', 'text',...   'BackgroundColor','g',...   'Pos', [10 55 40 20],...   'String', 'Green');b_label = uicontrol(cpFig, 'Style', 'text',...   'BackgroundColor','b',...   'Pos', [10 30 40 20],...   'String', 'Blue');% ***************************************************************% set the datacpRedDataH = uicontrol(cpFig, 'Style', 'edit',...   'Pos', [250 80 50 20],...   'String', num2str(get(cpRedSlideH, 'Value')),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Callback', ['cpickact(''redtext'');']);cpGreenDataH = uicontrol(cpFig, 'Style', 'edit',...   'Pos', [250 55 50 20],...   'String', num2str(get(cpGreenSlideH, 'Value')),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Callback', [ 'cpickact(''greentext'');'] );cpBlueDataH = uicontrol(cpFig, 'Style', 'edit',...   'Pos', [250 30 50 20],...   'String', num2str(get(cpBlueSlideH, 'Value')),...   'BackGroundColor','magenta','ForeGroundColor','white',...   'Callback', [ 'cpickact(''bluetext'');'] );% ***************************************************************% quit and clean upcpDoneH = uicontrol( 'Style','Pushbutton','Units','pixels',...    'Position',[50 5 70 20],...    'String','Done','UserData',cpFig,...    'Callback',[ 'cpickact(''done'');' ]);% ***************************************************************% the color test patchcpTestH = uicontrol( 'Style','Text','Units','pixels',...    'Position',[150 5 70 20],...    'String','sample','UserData',cpFig,...    'Callback',[ '' ]);set(cpTestH, 'BackGroundColor', [.5 .5 .5]);% set the editing window so that we can't plot anything in itmlVer = version;if mlVer(1) == '4'   set(cpFig, 'NextPlot', 'new'); elseif mlVer(1) >= '5'   %hidegui else   error('unknown MATLAB version!')   returnend% put these handles and parameters into a cell array and place it into% the 'Color picker' window 'UserData' field.  This replaces the use% of global variables. (6/13/02)cpH = {cpBlueDataH    cpBlueSlideH    cpBlueVal        cpDoneH ...       cpFig          cpGreenDataH    cpGreenSlideH    cpGreenVal ...       cpRedDataH     cpRedSlideH     cpRedVal         cpTestH};set(cpFig, 'UserData', cpH)%waitforbuttonpress