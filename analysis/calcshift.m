% calcshift.m: calculates the shift necessary to make the% midway point between the vertical cursors equal to zero.% To use: place zoomtool cursors to span the vertical range% you wish to shift and type 'calcshift'% Written by: Jonathan Jacobs% May 1999 - July 2002  (last mod: 07/19/02)function shift = calcshift(verbose)% find zoomtool windowzoomwindow = findme('zoomed window');figure(zoomwindow)temp=get(gca,'UserData');hlist=temp{2};cur1vertH=hlist{4};cur2vertH=hlist{10};c1 = get(cur1vertH,'YData');c2 = get(cur2vertH,'YData');temp1 = c1(1);temp2 = c2(1);cur1 = max([temp1 temp2]); cur2 = min([temp1 temp2]); shift = (cur1+cur2)/2;if nargout == 0   disp(['   Shift = ' num2str(shift)])end