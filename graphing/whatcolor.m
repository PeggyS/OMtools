function color = whatcolor(colorval)

% whatcolor: calculate color given ML color letter (e.g., 'k','b','g', etc),
% numeric color triplet (e.g., [1 0 1]), or index value from OMtools popup menu.
%
% Usage: color=whatcolor(colorval)
% output fields:
%    color.rgb
%    color.str
%    color.fg
%    color.bg
%    color.index
%    color.lum
%    color.colorlist

% written by: Jonathan Jacobs
%              June 2008 - June 2019  (last mod: 06/03/19)

if nargin<1
   disp('whatcolor needs an input value');
   color=[];
   return
end

if length(colorval)==1 && colorval==0
   color=[];
   return
end

color=struct('index',0,'str','','rgb',[0 0 0],...
   'lum',[],'fg',[0 0 0],'bg',[1 1 1],'colorlist',{''});

g=grapconsts;

abbrev    = g.geColorAbbrev;
colorlist = [g.geColorStr;'auto'];

color.colorlist=colorlist;

rgb{g.ORANGE}   = [1 0.5 0];
rgb{g.DKORANGE} = [1 0.25 0];
rgb{g.LTGRAY}   = [0.75 0.75 0.75];
rgb{g.MEDGRAY}  = [0.5 0.5 0.5];
rgb{g.DKGRAY}   = [0.15 0.15 0.15];

rgb{g.CORNFLOWER}  = [0.301 0.745 0.933];
rgb{g.NAVYBLUE}    = [0 0.447 0.741];
rgb{g.CHOCOLATE}   = [0.85 0.325 0.098];
rgb{g.BRIGHTSUN}   = [0.929 0.694 0.125];
rgb{g.VIVIDVIOLET} = [0.494 0.184 0.556];
rgb{g.SUSHI}       = [0.466 0.674 0.188];
rgb{g.FIREBRICK}   = [0.635 0.078 0.184];
rgb{g.OFFWHITE}    = [0.94 0.94 0.94];

rgb{g.OTHER} = 'other...';
rgb{g.NONE}  = 'none';
rgb{g.AUTO}  = 'auto';

lumcheck=1;

%%%%% single char
if ischar(colorval)   % kbgcrmyw, etc
   switch colorval(1)
      case abbrev
         color.index = find(strcmp(abbrev,colorval(1)));
      otherwise
         disp('whatcolor: otherwise?')
         return
   end
   
   if color.index>=1 && color.index<=8
      % the all-integer ML colors
      temp = dec2bin(color.index-1,3);
      color.rgb = [str2double(temp(1)) str2double(temp(2)) str2double(temp(3))];
   else
      color.rgb = rgb{color.index};
   end
   color.str = colorlist{color.index};
   color.fg  = color.rgb;
end



%%%%% menu index: built-in (1-8) & extended (9-24)
if isnumeric(colorval) && length(colorval)==1   
   if colorval==0 || colorval>g.AUTO
      disp('colorval: index out of range')
      color=[];
      return
   end
   color.index=colorval;
   if colorval<=g.WHITE
      % create RGB triplet. A lookup list would obviously have
      % be easier, but this was more fun
      temp = dec2bin(colorval-1,3);
      color.rgb=[0 0 0];
      for ii=1:length(temp)
         color.rgb(4-ii)=str2double(temp(4-ii));
      end
      color.fg = color.rgb;
      
   elseif colorval>=g.ORANGE && colorval<=g.FIREBRICK
      color.rgb=rgb{colorval};
      color.fg = color.rgb;

   elseif colorval==g.OFFWHITE
      color.rgb=rgb{colorval};
      color.fg = [0 0 0];

   elseif colorval==g.OTHER
      temp=uisetcolor;
      if isempty(color)
         color=[];
         return
      end
      color=whatcolor(temp);
      if isempty(color);return;end
      
   elseif colorval==g.NONE || colorval==g.AUTO
      color.rgb=rgb{colorval};
   end
   
   color.index=colorval;
   if color.index ~= g.OTHER
      color.str = colorlist{color.index};
   end   
end



%%%%% input is a triplet, just find index from [r g b]
if isnumeric(colorval) && length(colorval)==3
   color.fg=[];
   if all(colorval==0 | colorval==1) 
      % nice clean integers
      color.index=colorval(1)*4 + colorval(2)*2 + colorval(3) + 1;
      
   elseif any(colorval>0 & colorval<1) 
      % some funky triplet. Brute-force it for now
      if all(colorval==[1 0.5 0])
         color.index = g.ORANGE;
      elseif all(colorval==[1.0 0.25 0.0])
         color.index = g.DKORANGE;
      elseif all(colorval==[0.75 0.75 0.75])
         color.index = g.LTGRAY;
      elseif all(colorval==[0.5 0.5 0.5])
         color.index = g.MEDGRAY;
      elseif all(colorval==[0.15 0.15 0.15])
         color.index = g.DKGRAY;
      elseif all(colorval==[0.94 0.94 0.94])
         color.index = g.OFFWHITE;                  
      elseif all(colorval==[0 0.447 0.741])
         color.index = g.NAVYBLUE;
      elseif all(colorval==[0.85 0.325 0.098])
         color.index = g.CHOCOLATE;
      elseif all(colorval==[0.929 0.694 0.125])
         color.index = g.BRIGHTSUN;
      elseif all(colorval==[0.494 0.184 0.556])
         color.index = g.VIVIDVIOLET;
      elseif all(colorval==[0.466 0.674 0.188])
         color.index = g.SUSHI;
      elseif all(colorval==[0.301 0.745 0.933])
         color.index = g.CORNFLOWER;
      elseif all(colorval==[0.635 0.078 0.184])
         color.index = g.FIREBRICK;         
      else
         color.index = g.OTHER;
         % truncate the RGB components to fit w/in 13 chars.
         valstr=cell(1,3);
         for k=1:3
            temp= num2str(colorval(k),2);
            if ~contains(temp,'.')
               valstr{k} = temp(1);
            else
               [~,b] = strtok(temp,'.');
               valstr{k} = b;
            end
         end
         color.str=[valstr{1} ' ' valstr{2} ' ' valstr{3}];
      end      
   end %if all(colorval   
   color.rgb=colorval;
   if isempty(color.fg)
      color.fg=colorval;
   end   
end % if length(colorval)==1



%%%%% special cases
if color.index == g.OTHER
   % add the selected color to the menu list string
   color.colorlist{g.OTHER}=color.str;
else
   % we DON'T do this for OTHER
   color.str = colorlist{color.index};
end

% for colors too light to display against WHITE
if any(ismember([g.WHITE,g.OFFWHITE:g.AUTO],color.index))
   color.fg=[0 0 0];
   color.bg=[1 1 1];
   lumcheck=0;
elseif color.index==g.YELLOW
   color.fg=[0.65 0.65 0];
   color.bg=[1 1 1];
   lumcheck=0;
end


%%%%% calculate luminance to determine bg color
color.lum = perceivedlum(color.rgb);
avglum=(color.lum.a+color.lum.b+color.lum.c)/3;

if lumcheck==1 && isempty(color.bg)
   if avglum>0.6, color.bg=[0 0 0];
   else,          color.bg=[1 1 1];
   end
end
end % function whatcolor



%%%%%%%%%%%%%
function lum = perceivedlum( rgb )

R = rgb(1);
G = rgb(2);
B = rgb(3);

lum.a = sqrt( 0.299*R^2 + 0.587*G^2 + 0.114*B^2 );
lum.b = 0.299*R + 0.587*G + 0.114*B;
lum.c = 0.2126*R + 0.7152*G + 0.0722*B;

end %function lum