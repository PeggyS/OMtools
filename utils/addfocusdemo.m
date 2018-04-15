function addfocus%(hFig)

% Prepare the figure
if nargin==0
   %hFig = uifigure('Name','focustest');  % etc. - prepare the figure
   %return
end

% Get the underlying Java reference
warning off MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
jFig = get(hFig, 'JavaFrame');
if ~isempty(jFig)
   jAxis = jFig.getAxisComponent;
   % Set the focus event callback
   set(jAxis.getComponent(0),'FocusGainedCallback',{@myMatlabFunc,hFig});
   set(jAxis.getComponent(0),'FocusLostCallback',{@myMatlabFunc,hFig});
else
   %temp = matlab.internal.webwindowmanager.instance.windowList;
   webWindows = matlab.internal.webwindowmanager.instance.windowList;
   for i=1:length(webWindows)
      if strcmp(webWindows(i).Title,'Findsaccs control')
         win = webWindows(i);
         break
      end
   end

   win.FocusGained = {@myMatlabFunc2};%,hFig};
   win.FocusLost   = {@myMatlabFunc3};%,hFig};
   %win.FocusGained = {@myMatlabFunc2,hFig};
   %win.FocusLost   = {@myMatlabFunc3,hFig};

end
end % function

function myMatlabFunc3(a,b)%,hFig)
% do whatever you wish with the event/hFig information
   disp('focus lost')
end
function myMatlabFunc2(a,b)%,hFig)
% do whatever you wish with the event/hFig information
   disp('focus')
end

function myMatlabFunc(jAxis, jEventData, hFig)
% do whatever you wish with the event/hFig information
if contains(char(jEventData),'FOCUS_GAINED')
   disp('focus')
elseif contains(char(jEventData),'FOCUS_LOST')
   disp('focus lost')
end
end
