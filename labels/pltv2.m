t=maket(lv);figure;subplot(2,1,1)plot(t,rv,'c')maxpt=max(max(rv));minpt=min(min(rv));maxt=max(t);rehH=text(maxt,maxpt,'REV');set(rehV,'color','c');ylabel('Eye Position (�)')title(nameclean(namelist))subplot(2,1,2)plot(t,lv,'y--')maxpt=max(max(lv));minpt=min(min(lv));lehH=text(maxt,maxpt,'LEV');set(lehV,'color','y');ylabel('Eye Position (�)')xlabel('Time (sec)')orient landscape