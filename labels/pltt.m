figuret=maket(rt);plot(t,rt,'c',t,lt,'y--')maxpt=max(max([lt,rt]));minpt=min(min([lt,rt]));maxt=max(t);retH=text(maxt,maxpt,'RET');letH=text(maxt,minpt,'LET');set(retH,'color','c');set(letH,'color','y');title(nameclean(namelist))eptdraggerclear maxpt minpt maxt retH letH