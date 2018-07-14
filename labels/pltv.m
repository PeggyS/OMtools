function pltvglobal rv lv sv datanameplthFigH = figure;plthFigColor = get(plthFigH,'color');if plthFigColor(1) >= 0.6     %% Light background   lvColor = 'g';   rvColor = 'b'; elseif plthFigColor(1) < 0.6   lvColor = 'y';   rvColor = 'c';endif ~isempty(rv)   t=maket(rv); elseif ~isempty(lv)   t=maket(lv); else   disp('No vertical data!?!')   returnend maxpt=max(max([lv,rv]));minpt=min(min([lv,rv]));maxt=max(t);hold onif ~isempty(lv)   lvH=plot(t,lv,lvColor);   lvH.DisplayName='lv';   lvtxtH=text(maxt,minpt,'LV');   lvtxtH.Color=lvColor;end   if ~isempty(rv)   rvH=plot(t,rv,rvColor);   rvH.DisplayName='rv';   rvtxtH=text(maxt,maxpt,'RV');   rvtxtH.Color=rvColor;end   if ~isempty(sv)   svH=plot(t,sv,'r');   svH.DisplayName='sv';   svtxtH=text(maxt,maxpt,'Vert Stim');   svtxtH.Color='r';end   if exist('dataname','var')   if ~isempty(dataname)      title(nameclean(dataname));   endendevt; %dragger