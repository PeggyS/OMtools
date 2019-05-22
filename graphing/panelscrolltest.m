f=figure;
panel1 = uipanel('Parent',f);
panel2 = uipanel('Parent',panel1);
set(panel1,'Position',[0 0 0.95 1]);
set(panel2,'Position',[0 -1 1 2]);
%h = image;
%set(gca,'Parent',panel2);
s = uicontrol('Style','Slider','Parent',f,...
      'Units','normalized','Position',[0.95 0 0.05 1],...
      'Value',1);%,'Callback',{@slider_callback1,panel2});
addlistener(s,'ContinuousValueChange',...
   @(hObject,event) s_live(hObject,event,panel2));

t = uicontrol('Style','edit','Parent',panel2,...
      'Units','normalized','Position',[0.5 0.5 0.05 0.05],...
      'String',1);
   

function s_live(src,eventdata,arg1) %%%hObject,event)
val = get(src,'Value');
set(arg1,'Position',[0 -val 1 2])
end

function slider_callback1(src,eventdata,arg1)
val = get(src,'Value');
set(arg1,'Position',[0 -val 1 2])
end