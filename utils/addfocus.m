function addfocus(whatfig,foc_fun,varargin)

if nargin==0
   % demo mode. create test focus window
   if (0), hFig = figure;   %#ok<*UNRCH>
   else,   hFig = uifigure; pause(0.1); % SLOOOOOOOW... wait for it to be registered
   end
   hFig.Name = 'focustest';
   figname = hFig.Name;
   foc_fun='ftest_act'; %eg 'nafx_gui' name of the caller function
else
   % use specified window, can specify by either handle or Tag string
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
jFrame = hFig.JavaFrame;

if ~isempty(jFrame)
   % for old-style figures
   jAxis = jFrame.getAxisComponent;
   a=jAxis.getComponent(0);
   ah=handle(a,'CallbackProperties');
   
   % Set the event callbacks (fname is 3rd arg in receiving funct)
   ah.FocusGainedCallback={@focus_act,foc_fun,'gained',varargin};
   ah.FocusLostCallback  ={@focus_act,foc_fun,'lost',varargin};
   
else
   % for UIFIGURE.
   webWindows = matlab.internal.webwindowmanager.instance.windowList;
   found=0;
   for i=1:length(webWindows)
      if strcmp(webWindows(i).Title,figname)
         win = webWindows(i);
         found=1;
         break
      end
   end
   if found
      win.FocusGained = {@focus_act,foc_fun,'gained'};
      win.FocusLost   = {@focus_act,foc_fun,'lost'};
   else
      disp('Could not find UIFIGURE window')
      return
   end
   
end
end % function


function focus_act(jAxis,jEventData,foc_fun,gorl,varargin) %#ok<INUSL>
% do whatever you wish with the event/hFig information
if contains(gorl,'gained')
   %disp('focus gained')
   %if contains(char(jEventData),'FOCUS_GAINED')
   focusgained = 'focusgained';
   if isa(foc_fun,'function_handle')
      if isempty(varargin{:})
         feval(foc_fun,'focusgained');
      else
         feval(foc_fun,varargin,'focusgained');
      end
      return
   else
      cmdname = [foc_fun '(' focusgained ');'];
   end
elseif contains(gorl,'lost')
   %disp('focus lost')
   %elseif contains(char(jEventData),'FOCUS_LOST')
   focuslost = 'focuslost';
   if isa(foc_fun,'function_handle')
      if isempty(varargin{:})
         feval(foc_fun,'focuslost');
      else
         feval(foc_fun,varargin,'focuslost');
      end
      return
   else
      cmdname = [foc_fun '(' focuslost ');'];
   end
end

try    eval(cmdname)
catch, disp(['addfocus: could not run ' cmdname ])
end

end % my

