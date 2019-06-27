function m=OMmenu(f)

if nargin==0,f=findHotW;end

if ishandle(f)
   if ~strcmpi(f.Type,'figure')
      disp('OMmenu was called for a non-figure object')
      m=[];
      return
   end
else
   disp('OMmenu was called for a non object')
   return
end

% OMmenu already present?
temp=findobj(f,'Type','uimenu','Label','OMtools');
if ~isempty(temp),m=temp;return;end

% 'Label' vs 'Text'? 2016b chokes on 'Text'. 'Label' works and still works.

% add the main menu & submenus
m = uimenu(f,'Label','OMtools');
mitem(1) = uimenu(m,'Label','Line edit');
mitem(2) = uimenu(m,'Label','Text edit');
mitem(3) = uimenu(m,'Label','Axis edit');
mitem(4) = uimenu(m,'Label','Position edit');
mitem(5) = uimenu(m,'Label','Draw');
mitem(6) = uimenu(m,'Label','Dragger');

mitem(1).MenuSelectedFcn = @(hObject,event) linedit(f,hObject,event);
mitem(2).MenuSelectedFcn = @(hObject,event) textedit(f,hObject,event);
mitem(3).MenuSelectedFcn = @(hObject,event) axisedit(f,hObject,event);
mitem(4).MenuSelectedFcn = @(hObject,event) posedit(f,hObject,event);
mitem(5).MenuSelectedFcn = @(hObject,event) draw(f,hObject,event);
mitem(6).MenuSelectedFcn = @(hObject,event) dragger(f,hObject,event);

if nargout==0,clear m;end


