% ML_W_switch: (Mac ONLY) switch foreground application to either MATLAB
% or to its assistant MATLABWindow (responsible for all App Designer windows)
%  ML_W_switch('ml')  will make MATLAB active
%  ML_W_switch('mlw') will make MATLABWindow active
%
% Requires the presence of the AppleScripts applications MLW_act and ML_act
% You will manually have to activate ML_act and MLW_act before they can be
% called from here. Simply Control-click on each and select "Open" from the
% pop-up menu. You may be asked if you really want to allow them to run.
% This is necessary any time you install a new copy of OMtools, because
% they are considered new and quarrantined apps until you agree they are
% not going to destroy your computer or bring pestilence upon the land.
%
% Content of scripts:
%   tell application "MATLABWindow"  --(or "MATLAB")
%	    activate
%   end tell

% Written by Jonathan Jacobs
% 05 Sept 2017 - Oct 2020

function ML_W_switch(which)

if ~contains(computer,'MAC'), return; end
if nargin~=1
   return
end

olddir=pwd;
[supt_dir, ~, ~] = fileparts(mfilename('fullpath'));
cd(supt_dir)

switch lower(which)
   case 'ml'
      %! open "ML_act.app"
      a=system('open ML_act.app');
      if a~=0  % a==0 means it worked
         % failed
         help ML_W_switch
      else      
         % succeeded
      end
   case 'mlw'
      %! open "MLW_act.app"
      a=system('open MLW_act.app');
      if a~=0  % a==0 means it worked
         % failed
         help ML_W_switch
      else      
         % succeeded
      end
   otherwise
      disp('ML_W_switch: unknown action.')
end

try    cd(olddir)
catch, end
pause(0.25)
% could also use system('open ML[W]_act.app')