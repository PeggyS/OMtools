function addfocus(whatfig,fn_name)

% for demo mode
% Prepare the figure
if nargin==0
   hFig = figure;  % etc. - prepare the figure
   hFig.Name = 'focustest';
   fn_name='ftest_gui'; %eg 'nafx_gui' name of the caller function
else
   if ishandle(whatfig)
      hFig=whatfig;
      figname = hFig.Name;
   elseif ischar(whatfig)
      figname=whatfig;
      hFig=findme(whatfig);
   end
end

% Get the underlying Java reference
warning off MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
jFig = get(hFig, 'JavaFrame');
if ~isempty(jFig)
   % this branch gets used
   
   jAxis = jFig.getAxisComponent;
   
   % Set the focus event callback
   %fname is 3rd arg in receiving funct
   set(jAxis.getComponent(0), 'FocusGainedCallback',{@myMatlabFunc,fn_name});
   set(jAxis.getComponent(0), 'FocusLostCallback',  {@myMatlabFunc,fn_name});
   
else
   %%%%% unclean? unclean?
   % haven't seen this used
   %temp = matlab.internal.webwindowmanager.instance.windowList;
   Beeper;Beeper;Beeper;
   disp('this might be important: addfocus if jJig is empty')
   keyboard
   webWindows = matlab.internal.webwindowmanager.instance.windowList;
   for i=1:length(webWindows)
      if strcmp(webWindows(i).Title,figname)
         win = webWindows(i);
         break
      end
   end
   
   %%% create myMatlabF
   win.FocusGained = {@myMatlabFunc2};%,hFig};
   win.FocusLost   = {@myMatlabFunc3};%,hFig};
   %win.FocusGained = {@myMatlabFunc2,hFig};
   %win.FocusLost   = {@myMatlabFunc3,hFig};
   
end
end % function


function myMatlabFunc(~, jEventData, fnname) %,arg4,arg5)
% do whatever you wish with the event/hFig information
if contains(char(jEventData),'FOCUS_GAINED')
   %disp('focus gained')
   focusgained = 'focusgained';
   cmdname = [fnname '(' focusgained ');'];
elseif contains(char(jEventData),'FOCUS_LOST')
   %disp('focus lost')
   focuslost = 'focuslost';
   cmdname = [fnname '(' focuslost ');'];
end
%disp(cmdname)
eval(cmdname)
end



% have these been used lately?
function myMatlabFunc3(a,b)%,hFig)  %%don't sweat the a,b. can't do anything about it.
% do whatever you wish with the event/hFig information
disp('focus lost')
keyboard
end
function myMatlabFunc2(a,b)%,hFig)
% do whatever you wish with the event/hFig information
disp('focus')
keyboard
end

%%%%%
%%%%% back to the clean...

