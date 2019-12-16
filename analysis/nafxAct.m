% nafxAct.m: Back-end dispatcher for nafx_gui.

% Written by: Jonathan Jacobs  
% June 2018 

function nafxAct(action)

nafxFig = findme('NAFXwindow');
if ishandle(nafxFig)
   temp=nafxFig.UserData;
   h=temp{1};
   linelist=temp{2};
else
   nafx
   %disp('ERRRRRRRORRRRR')
   return
end

% window refresh      
if strcmpi(action,'focusgained') || strcmpi(action,'updateAvailData')
   dat=select_emdata(h.availDataH,'refresh_menu');
   if ~isempty(dat.loadednames{1})
      dat=select_emdata(h.availDataH,'selectdata');
      if isfield(dat,'data') && isa(dat.data,'emData')
         h.dat=dat;
      end
   end
   return
end


% find datstat window
emdm = findme('EM Data');
if ~ishandle(emdm)
   datstat
   pause(0.5) % because appdesigner apps are sloooooooooooow.
end
emdm = findwind('EM Data');
if ~ishandle(emdm)
   disp('Can not find the data manager window.')
   return
else
   h.emHand = emdm.UserData;
end

% handles from NAFX GUI
samp_freq = str2double(h.sampFreqH.String);
posArray  = h.posArrayNAFXH.UserData;
posStr    = h.posArrayNAFXH.String;
velArray  = h.velArrayNAFXH.UserData;
velStr    = h.velArrayNAFXH.String;

all_pos_str = h.posLimNAFXH.UserData;
posLimVal   = h.posLimNAFXH.Value;
posLim      = all_pos_str(posLimVal);

all_vel_str = h.velLimNAFXH.UserData;
velLimVal   = h.velLimNAFXH.Value;
velLim      = all_vel_str(velLimVal);

fovstat   = h.fovStatNAFXH.Value;
tau       = str2double(h.tauNAFXH.String);
tau_vers2 = h.tauVersH.Value;
age_range = h.nafx2snelH.Value;
dblplot   = h.dblPlotNAFXH.Value;


if strcmpi(action,'done')
   nafxtemp = nafxFig.Position;
   nafxXPos = nafxtemp(1);
   nafxYPos = nafxtemp(2);
   try   delete(nafxFig)
   catch, end
   oldpath=pwd;
   cd(findomprefs);
   if exist('posArray','var') && exist('velArray','var')
      save nafxprefs.mat nafxXPos nafxYPos posArray velArray ...
         posLim velLim dblplot age_range fovstat tau_vers2;
   end
   cd(oldpath)
   return
end


switch lower(action)
   
   case 'selectavaildata'
      h.dat=select_emdata(h.availDataH,[]);
      
   case {'plotaction'}
      emdname=h.availDataH.String{h.availDataH.Value};
      if contains(emdname,{'Refresh Menu';'Get new data'})
         disp('You need to load valid data first.')
         return
      end
      
      %get current channel menu props
      chan_num = h.datachanH.Value;
      chanlist = h.datachanH.String;
      chan_str = chanlist{chan_num};
      if     chan_str(1)=='r', color='b';
      elseif chan_str(1)=='l', color='g';
      end
      
      temp=h.plotactionH.UserData;
      if ~isempty(temp)
         h.datawindow=temp{1};
         h.datachan=temp{2};
         datalineH=temp{3};
      end
      
      % {'Choose Plot Action'};{'New Plot'};{'Grab Existing'};...
      % {'Show Current'};{'Update Current'};
      
      if isempty(temp)
         plotaction=2;
      else
         plotaction = h.plotactionH.Value;
      end
      
      if plotaction==1  % 'Choose Plot Action'
         return
      end
      
      if plotaction==2  % 'newplot' ??also 'addtoplot'??
         pos=evalin('base',[emdname '.' chan_str '.pos;']);
         t=maket(pos,samp_freq);
         h.datawindow=figure;
         datalineH = plot(t,pos,color);
         if ~ishandle(datalineH)
            disp('Could not plot the line')
            return
         end
         datalineH.DisplayName = chan_str;
         zoomtool
         h.plotactionH.UserData = [{h.datawindow},{chan_str},{datalineH}];
         nafxFig.UserData = [{h},{linelist}];
         ept
         title( nameclean([emdname ' -- ' chan_str]) )
      end
      
      if plotaction==3  % 'grabplot'
         disp('Coming soon. Maybe.')
         return
         yorn=input('Use front figure window? ','s'); %#ok<UNRCH>
         if strcmpi(yorn,'y')
            frontfig=findHotW;
            if isempty(frontfig) || ~ishandle(frontfig)
               beep
               disp('No eligible figure window found')
               return
            else
               % LOTS to do here: Look for a front window. is it from
               % the proper data set? what channels(s)? guess from line
               % color?
               figure(frontfig)
               % get first line data? guess at channel?
               h.showplotH.UserData = [{frontfig};{[]};{[]}];
               zoomtool
            end
         end
      end
      
      if plotaction==4  % 'showplot'
         if isempty(temp)
            % should be caught before hitting this
            beep
            disp('No previous plot')
            return
         else
            % use previous datawindow
            if ishandle(h.datawindow)
               figure(h.datawindow);
               % better make sure proper channel is selected
               oldchan=find(strcmpi(chanlist, h.datachan));
               h.datachanH.Value=oldchan; %chan num
            else
               beep
               disp('Previous figure is missing')
            end
         end
      end
      
      % get old fig handle, and assorted plot info
      if plotaction==5  % 'updateplot'
         if ~ishandle(h.datawindow)
            beep
            disp('Cannot find your previous window')
            return
         end
         figure(h.datawindow)
         % replace data in figure
         pos=evalin('base',[emdname '.' chan_str '.pos;']);
         t=maket(pos,samp_freq);
         datalineH.YData=pos;
         datalineH.XData=t;
         datalineH.Color=color;
         zoomclr;zoomtool
      end
      
      % set menu back to 'Choose Plot Action'
      h.plotactionH.Value = 1;  % 'Choose Plot Action'
      
      
   case 'calcnafx'
      funcNAFX = 'nafxgui';
      numfov = str2double(h.numFovNAFXH.String);
      h.fovStatNAFXH.Value=0;
      
      % unfuxxor this quotidian mess!
      % display the command-line equiv of operation being performed
      dstr=['nafx(' posStr ',' velStr ',' num2str(samp_freq) ','];
      dstr=[dstr num2str(numfov) ',' '''' funcNAFX(1:end-3) '''' ',[0,' ];
      dstr=[dstr num2str(posLim) ',' num2str(velLim) ']);'];
      disp(dstr)
      
      nafx(posArray{1},velArray{1},samp_freq,numfov,funcNAFX, ...
         [0,posLim,velLim],tau);
      
      h.fovStatNAFXH.Value=fovstat;
      
      
   case 'calcfovs'
      funcNAFX  = h.fovCritNAFXH.UserData;
      valNAFX   = h.fovCritNAFXH.Value;
      funcNAFX  = [deblank(funcNAFX(valNAFX,:)) 'gui'];
      %tau       = str2double(h.tauNAFXH.String);
      
      % unfuxxor this quotidian mess!
      % display the command-line equiv of operation being performed
      dstr=['nafx(' posStr ',' velStr ',' num2str(samp_freq) ];
      dstr=[dstr ',[' num2str(posLim) ',' num2str(velLim) '],' ];
      dstr=[dstr '''' funcNAFX(1:end-3) '''' ',' num2str(dblplot) ');'];
      disp(' ')
      disp(dstr)
      nafx(posArray{1},velArray{1},samp_freq,[posLim,velLim], ...
         funcNAFX,dblplot,tau);
      
   case 'settau'
      tau_surf_temp = tau_surface(tau_vers2);
      tau_temp = tau_surf_temp(velLimVal, posLimVal);
      h.tauNAFXH.String = num2str(tau_temp);
            
   otherwise
      % nothing
end

end %function
