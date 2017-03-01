% eyemovie.m: watch the dancing eyes!% usage: eyemovie( 'plane', start, stop, speed, view, conjugacy, decimate )%   plane:       'h' -- horizontal only%                'v' -- vertical only%                'b' -- both planes     (default)%   start, stop: enter as time or sample number  (default = entire record)%   speed:       default is 1, higher values cause movie to run slower%                (You may need to experiment to find what works for you)     %   view:        0 --  display as if you were looking at the subject's eyes (default)%                1 --  display as if you were looking through the subject's eyes%   conjugacy:   0 --  display each eye in separate plots (default)%                1 --  display both eyes on one plot%   decimate:    n --  display sample corresponding to each 1/n th of a second%                      (default = 20)%% NOTE: If you want to play data that was NOT read in with "RD", you must% type "globaliz" from the command line BEFORE running EyeMovie.%% NOTE: Use of arguments is optional; however if you wish to use a% non-default value, you must enter all the arguments that precede it.      % Written by: Jonathan Jacobs%             February 1997 - February 2000 (last mod:  02/17/00)% must be accompanied by 'eyeMovAct.m', 'pause2.m', and 'findMe.m'function eyemovie(plane, startAt, stopAt, speedFactor, viewMode, conjugacy, decimate)global lh rh lv rv st sv samp_freq namearrayglobal whatSampH whatTimeH startH stopHglobal speedFacH decimateH planeH conjugacyH povH xLimH yLimH% we insist on a black background!colordef none% check if the eye movie window is already open% if it is, bring it to the frontwNum = findMe('eyemovieWindow');if wNum > -1   figure(wNum)   returnendif isempty(samp_freq) | samp_freq == 0   samp_freq = input('Enter the sampling frequency: ' );endif isempty(namearray)   namearray = 'current file';endmaxpts = max( [size(lh) size(rh) size(lv) size(rv) size(st) size(sv)] );maxtime = maxpts/samp_freq(1);% fill in the missing input arguments (if any)if nargin < 7, decimate = 20; endif nargin < 6, conjugacy = 1; endif nargin < 5, viewMode = 1; endif nargin < 4, speedFactor = 1; endif nargin < 3, stopAt = maxtime; endif nargin < 2, startAt = 0; endif nargin < 1, plane = 'b'; endif conjugacy > 1, conjugacy = 1; endif viewMode > 1,  viewMode  = 1; end% This skanky trick allowed us to use these vars in the "Play" callback of 'eyeMovAct'% No longer needed since 'eyeMovAct' now reads them from the controls in the GUI% (thanks to the judicious use of global variables)% I'm leaving it here as a reminder that it could be useful under other circumstances%assignin('base','plane',plane);%assignin('base','startAt',startAt);%assignin('base','stopAt',stopAt);%assignin('base','speedFactor',speedFactor);%assignin('base','viewMode',viewMode);%assignin('base','conjugacy',conjugacy);%assignin('base','decimate',decimate);if viewMode == 0   LEplot = 2;   REplot = 1;   povStr = ['      Looking AT the subject''s eyes']; elseif viewMode == 1   LEplot = 1;   REplot = 2;   povStr = ['Watching THROUGH the subject''s eyes'];end% make sure we have a valid plane argumentwhile (plane ~= 'h')&(plane ~= 'v')&(plane ~= 'b')   plane = lower(input('Show (H)orizontal, (V)ertical or (B)oth? ', 's'));endif plane == 'h'    planeIndex = 1;  elseif plane == 'v'    planeIndex = 2;  elseif plane == 'b'    planeIndex = 3;endconjIndex = conjugacy + 1;povIndex = viewMode + 1;[nmRows, nmCols] = size(namearray);nameStr = deblank(namearray(nmRows,:));eyemovieH = figure('Name', ['Eye Movie! for ' nameStr],...                   'Pos', [246 390 660 420],...                   'MenuBar', 'none','Tag', 'eyemovieWindow');% draw initial eye positions & set axis limits %xlims = [-50 50];ylims = [-15 15];% set up line originsif viewMode == 0         %% looking AT eyes   yPOV = ylims(2);   lexPOV =  2;    leAxXorig = 0.578;   rexPOV = -2;    reAxXorig = 0.13;  elseif viewMode == 1   %% looking THROUGH eyes   yPOV = ylims(1);   lexPOV = -2;    leAxXorig = 0.13;   rexPOV =  2;    reAxXorig = 0.578;end% Now we'll set up the axes.  The alert reader trying to decipher all this% code will notice that the lines (~60) between these comments and the % beginning of the GUI stuff is duplicated in 'eyeMovAct' (which has some% extra stuff thrown in).  This is because the user would find it somewhat% disconcerting to see no graphs (not even empty axes) in the figure window% when 'eyemovie' is first invoked. % set up the graphs.  If we want to display a conjugacy plot we will% only need one plot, otherwise we must set up two subplots.if ~conjugacy   reAxis = subplot(1,2,REplot);   set(reAxis,'Pos',[reAxXorig 0.25 0.327 0.665]);   title('Right Eye','Color','c') else   reAxis = subplot(1,1,1);   set(reAxis,'Pos',[0.13 0.25 0.775 0.665]);endhold onset(reAxis, 'xlim', xlims);set(reAxis, 'ylim', ylims);set(reAxis, 'Box', 'on');rAxVGrdLin = plot([0 0],ylims,'w--');rAxHGrdLin = plot(xlims,[0 0],'w--');set(reAxis,'Xtick',[-50 -40 -30 -20 -10 0 10 20 30 40 50]);xtlstr = get(reAxis,'XTickLabels');xtl = abs(str2num(xtlstr));set(reAxis,'XTickLabels',xtl);ylabel('<-- D                  Gaze                 U -->');if conjugacy   if viewMode      xlabel('LE     RE');      title('<-- L                  Gaze                 R -->')     elseif ~viewMode      title('RE     LE');      xlabel('<-- R                  Gaze                 L -->')   end elseif ~conjugacy  if viewMode      title('Right Eye','Color','c');      xlabel('<-- L                  Gaze                 R -->')   elseif ~viewMode      title('Right Eye','color','c');      xlabel('<-- R                  Gaze                 L -->')  endend% initialize the LE axisif conjugacy    % left eye will go in the already-created axis   ;  else   % create an axis for the left eye   leAxis = subplot(1,2,LEplot);   set(leAxis,'Pos',[leAxXorig 0.25 0.327 0.665]);   hold on   set(leAxis, 'xlim', xlims);   set(leAxis, 'ylim', ylims);   set(leAxis, 'Box', 'on');   lAxVGrdLin = plot([0 0],ylims,'w--');   lAxHGrdLin = plot(xlims,[0 0],'w--');   %lCrossH = plot(0, 0, 'w+', 'markersize', 255);   set(leAxis,'Xtick',[-50 -40 -30 -20 -10 0 10 20 30 40 50]);   title('Left Eye','Color','y')   xtlstr = get(leAxis,'XTickLabels');   xtl = abs(str2num(xtlstr));   set(leAxis,'XTickLabels',xtl);   ylabel('<-- D                  Gaze                 U -->');   if ~viewMode      xlabel('<-- R                  Gaze                 L -->')    else      xlabel('<-- L                  Gaze                 R -->')   endendif conjugacy   eyeballL = plot(lexPOV, yPOV,'yo');   eyeballR = plot(rexPOV, yPOV,'co');   %eyeballs = plot([lexPOV rexPOV],[yPOV yPOV],'wo');   %set(eyeballs,'Markersize',10);   set(eyeballL,'Markersize',10);   set(eyeballR,'Markersize',10);end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% user interface setup %%%uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.025 .06 .08 .045],...   'String', 'Samp #');whatSampH = uicontrol( eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.105 .06 .07 .045],'UserData',gca,...   'String', '1',...   'HorizontalAlignment', 'left',...   'BackGroundColor','magenta','ForeGroundColor','white' );uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.025 .0 .08 .045],...   'String', 'Time');whatTimeH = uicontrol( eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.105 .0 .07 .045],'UserData',gca,...   'String', '0',...   'HorizontalAlignment', 'left',...   'BackGroundColor','magenta','ForeGroundColor','white' );uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.20 .06 .07 .045],...   'String', 'Start:');startH = uicontrol( eyemovieH, 'Style', 'edit',...   'Units','normal','Pos', [.27 .06 .07 .045],'UserData',gca,...   'String', num2str(startAt),...   'HorizontalAlignment', 'left',...   'BackGroundColor','magenta','ForeGroundColor','white' );uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.20 .0 .07 .045],...   'String', 'Stop:');stopH = uicontrol( eyemovieH, 'Style', 'edit',...   'Units','normal','Pos', [.27 .0 .07 .045],'UserData',gca,...   'String', num2str(stopAt),...   'HorizontalAlignment', 'left',...   'BackGroundColor','magenta','ForeGroundColor','white' );uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.57 .12 .1 .045],...   'String', '� X Lims:');xLimH = uicontrol( eyemovieH, 'Style', 'edit',...   'Units','normal','Pos', [.67 .12 .05 .045],'UserData',gca,...   'String', num2str(xlims(2)),...   'HorizontalAlignment', 'left',...   'BackGroundColor','magenta','ForeGroundColor','white' );uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.75 .12 .1 .045],...   'String', '� Y Lims:');yLimH = uicontrol( eyemovieH, 'Style', 'edit',...   'Units','normal','Pos', [.85 .12 .05 .045],'UserData',gca,...   'String', num2str(ylims(2)),...   'HorizontalAlignment', 'left',...   'BackGroundColor','magenta','ForeGroundColor','white' );uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.36 .06 .075 .045],...   'String', 'Speed:');speedFacH = uicontrol( eyemovieH, 'Style', 'edit',...   'Units','normal','Pos', [.435 .06 .07 .045],'UserData',gca,...   'String', num2str(speedFactor),...   'HorizontalAlignment', 'left',...   'BackGroundColor','magenta','ForeGroundColor','white' );uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.36 .0 .14 .045],...   'String', 'Every 1/n sec:');decimateH = uicontrol( eyemovieH, 'Style', 'edit',...   'Units','normal','Pos', [.50 .0 .055 .045],'UserData',gca,...   'String', num2str(decimate),...   'HorizontalAlignment', 'left',...   'BackGroundColor','magenta','ForeGroundColor','white' );uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.57 .06 .095 .04],...   'String', 'Plane:');planeH = uicontrol( eyemovieH, 'Style', 'popup',...   'Units','normal','Pos', [.57 .0 .12 .05],'UserData',gca,...   'String', ['Horiz|Vert|Both'],...   'Value', planeIndex,...   'HorizontalAlignment', 'left',...   'BackGroundColor','cyan','ForeGroundColor','black' );uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.70 .06 .10 .04],...   'String', 'Conjugacy:');conjugacyH = uicontrol( eyemovieH, 'Style', 'popup',...   'Units','normal','Pos', [.70 .0 .12 .05],'UserData',gca,...   'String', ['Off|On'],...   'Value', conjIndex,...   'HorizontalAlignment', 'left',...   'BackGroundColor','cyan','ForeGroundColor','black' );uicontrol(eyemovieH, 'Style', 'text',...   'Units','normal','Pos', [.83 .06 .135 .04],...   'String', 'Point of View:');povH = uicontrol( eyemovieH, 'Style', 'popup',...   'Units','normal','Pos', [.83 .0 .15 .05],'UserData',gca,...   'String', ['Observer|Subject'],...   'Value', povIndex,...   'HorizontalAlignment', 'left',...   'BackGroundColor','cyan','ForeGroundColor','black' );playBH = uicontrol( eyemovieH, 'Style', 'Pushbutton',...   'Units','normal','Pos', [.025 .12 .08 .045],'UserData',gca,...   'String', 'Play', 'Callback', 'eyeMovAct;' );   pauseBH = uicontrol( eyemovieH, 'Style', 'Pushbutton',...   'Units','normal','Pos', [.125 .12 .08 .045],'UserData',gca,...   'String', 'Pause', 'Callback', 'pause;' );doneBH = uicontrol( eyemovieH, 'Style', 'Pushbutton',...   'Units','normal','Pos', [.225 .12 .08 .045],'UserData',gca,...   'String', 'Done',...   'Callback', ['clear global whatSampH whatTimeH startH stopH speedFacH '...                'decimateH planeH conjugacyH povH xLimH yLimH; close(gcf)'] );