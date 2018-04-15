function addfocus2%(hFig)

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
end % function

function myMatlabFunc3(a,b)%,hFig)
% do whatever you wish with the event/hFig information
disp('focus lost')
end
function myMatlabFunc2(a,b)%,hFig)
% do whatever you wish with the event/hFig information
disp('focus')
end
