% bleach.m: turn all lines/text to white.% Written by:  Jonathan Jacobs%              March 2001 - July 2001 (last mod: 07/05/01)function bleach(null)axlist = get(gcf,'Children');set(gcf,'color','black')for a = 1:length(axlist)	% find all the objects in the axis	ga = axlist(a);	children = get(ga,'children');	% Find the handles for lines, text, patches?	chillen = length(children);	otherlist=[];	for i=1:chillen	a = lower(get(children(i),'Type'));	   if strcmp(a,'line')	      set(children(i),'Color', 'w');	      set(children(i),'MarkerEdgeColor', 'auto');	      set(children(i),'MarkerFaceColor', 'none');	    elseif strcmp(a,'text')	      set(children(i),'Color', 'w');	    elseif strcmp(a,'patch')	      set(children(i),'FaceColor', 'w');	      set(children(i),'EdgeColor', 'w');	   end	end    set(ga,'color','black')    set(get(ga,'xlabel'),'color','w')    set(ga,'xcolor','w')    set(get(ga,'ylabel'),'color','w')    set(ga,'ycolor','w')    set(get(ga,'zlabel'),'color','w')    set(ga,'zcolor','w')    set(get(ga,'title' ),'color','w')end