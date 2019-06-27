function g = grapconsts

g.geStyles   = ['- ',': ','-.','--','no'];
g.geStyleStr = 'solid|dotted|dashdot|dashed|none';

g.geSymbol   = ['.','o','x','+','*','s','d','v','^','<','>','p','h','n'];
g.geSymbStr  = ['point|circle|x-mark|plus|star|square|diamond|'...
   'triangle (d)|triangle (u)|triangle (l)|triangle (r)|'...
   'pentagram|hexagram|none'];


g.geColorAbbrev = {'k','b','g','c','r','m','y','w','!','@','#',...
   '$','%','^','&','*','(',')','_','+','=','?','n','a'};

geColorStr1 = {'black';'blue';'green';'cyan';'red';'magenta';'yellow';'white';...
   'orange';'dk. orange';'lt. gray';'med. gray';'dk. gray'}; %1-13

geColorStr2 = {'cornflower';'navy blue';'chocolate';'bright sun';...
   'vivid violet';'sushi';'fire brick';'off-white';'other...';'none'}; %14-23

g.geColorStr=[geColorStr1;geColorStr2];

g.geMkEClrStr = [g.geColorStr;'auto'];
g.geMkFClrStr = [g.geColorStr;'auto'];

g.geSurfStr  = {'none';'flat';'interp';'map';'[RGB]'};
g.geEdgeStr  = {'none';'flat';'interp';'[RGB]'};

% constants for built-in colors [r g b]+1
g.BLACK  = 1; g.BLUE    = 2;
g.GREEN  = 3; g.CYAN    = 4;
g.RED    = 5; g.MAGENTA = 6;
g.YELLOW = 7; g.WHITE   = 8;

% constants for the extra colors
g.ORANGE    = 9;  g.DKORANGE    = 10;
g.LTGRAY    = 11; g.MEDGRAY     = 12;
g.DKGRAY    = 13; g.CORNFLOWER  = 14;
g.NAVYBLUE  = 15; g.CHOCOLATE   = 16;
g.BRIGHTSUN = 17; g.VIVIDVIOLET = 18;
g.SUSHI     = 19; g.FIREBRICK   = 20;
g.OFFWHITE  = 21;
g.LASTCOLOR = 21;

% non-color entries in color menus
g.OTHER = 22; 
g.NONE  = 23; 
g.AUTO  = 24;


g.rgb{g.BLACK}    = [0 0 0];
g.rgb{g.BLUE}     = [0 0 1];
g.rgb{g.GREEN}    = [0 1 0];
g.rgb{g.CYAN}     = [0 1 1];
g.rgb{g.RED}      = [1 0 0];
g.rgb{g.MAGENTA}  = [1 0 1];
g.rgb{g.YELLOW}   = [1 1 0];
g.rgb{g.WHITE}    = [1 1 1];
g.rgb{g.ORANGE}   = [1 0.5 0];
g.rgb{g.DKORANGE} = [1 0.25 0];
g.rgb{g.LTGRAY}   = [0.75 0.75 0.75];
g.rgb{g.MEDGRAY}  = [0.5 0.5 0.5];
g.rgb{g.DKGRAY}   = [0.15 0.15 0.15];

g.rgb{g.CORNFLOWER}  = [0.301 0.745 0.933];
g.rgb{g.NAVYBLUE}    = [0 0.447 0.741];
g.rgb{g.CHOCOLATE}   = [0.85 0.325 0.098];
g.rgb{g.BRIGHTSUN}   = [0.929 0.694 0.125];
g.rgb{g.VIVIDVIOLET} = [0.494 0.184 0.556];
g.rgb{g.SUSHI}       = [0.466 0.674 0.188];
g.rgb{g.FIREBRICK}   = [0.635 0.078 0.184];
g.rgb{g.OFFWHITE}    = [0.94 0.94 0.94];

