figuret=maket(rh);plot(t,st,'r')maxpt=max(max([st]));minpt=min(min([st]));maxt=max(t);stm=text(maxt,maxpt-(maxpt-minpt)*.5,'STIM');set(stm,'color','r');title(nameclean(namelist))eptdragger