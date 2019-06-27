function dat=select_emdata(go,action)


emdm=findwind('EM Data');
if ishandle(emdm)
   busy=emdm.UserData.busy;
else
   datstat
   pause(0.25)
   busy=emdm.UserData.busy;
end

if nargin==1,action=[];end

if nargin==0, go=[];end
if ischar(go),go=[];end
if isempty(go) || ~ishandle(go)
   go=gco; % popup control
   if isempty(go);return;end
end

dat=find_loaded_emdm(go);

if strcmp(go.Style,'popupmenu')
   temp=go.String;
   if length(temp)>2
      dat.loadednames=temp(1:length(temp)-2);
   else
      dat.loadednames={''};
   end
   
   popstr=go.String;
   newsel=go.Value;
   
   % should only be empty before data has been loaded, or 
   % all data has been cleared?
   goud=go.UserData;
   if isa(goud,'emData')
      dat.lastselname=strtok(go.UserData.filename,'.lab');
   else
      dat.lastselname='';
   end
   
   if isempty(action)     
      % use popup selection
      if newsel==length(popstr)
         action='newdata';    % 2nd from bottom
      elseif newsel==length(popstr)-1
         action='refresh_menu';    % bottom
      else
         action='selectdata'; % all others
      end
   end
   
else
   return
end % if popupmenu

%emdm.RunningAppInstance.outside_call_to_add_data;
%emdm.RunningAppInstance.update_datalist;


switch lower(action)
   
   case 'selectdata'
      
      if newsel<=length(dat.loadednames)
         datsel=newsel;
      else
         disp('selectdata: newsel>datasel')
         return
      end

      % it is EM data
      dat.channels={''};      
      if datsel>0
         if isfield(dat,'f_info')
            dat.channels=dat.f_info(datsel).chan_names;
         end
         selected=dat.loaded_data.Items{datsel};
         data = evalin('base',[selected ';']);
      end
      
      if isa(data,'emData')
         go.UserData=data;
         dat.data=data;
         dat.lastselname=data.filename;
      else
         beep
         dat=select_emdata(go,'refresh menu');
         disp('selectdata: is not emData')
         return
      end
      go.Value = datsel;
      dat.lastselname = dat.loadednames{datsel};
      return

      
   case 'newdata'
      currloaded=go.String;
      %busy=1;
      if ishandle(emdm)
         emdm.RunningAppInstance.outside_call_to_add_data;
      else
         %rd;
         %dat=select_emdata('selectavaildata');
         %return
      end
      while busy==1
         %busy=emdmFig.UserData.busy;
         pause(0.5)
      end
      %disp('wait is over!')
      just_loaded=emdm.UserData.currdataname;
      go.UserData = evalin('base',[just_loaded ';']);      
      temp=sort([currloaded(1:end-2);just_loaded]);
      ind=find(strcmpi(temp,just_loaded));      
      go.Value=ind;
      go.String=[temp;currloaded(end-1:end)];           
      return
      
      
   case 'refresh_menu'
      names=dat.loadednames;
      good=find(~cellfun(@isempty,names));
      popstr=go.String;
      if isempty(good)
         popstr(1)={'Refresh menu'};
         popstr(2)={'Get new data'};
         dat.lastselind=1;
         dat.lastselname=popstr(1);
         go.String=popstr;
         go.Value=1;
         go.UserData=[]; % no data, so we clear
         return
      end
      
      if length(good)==1
         popstr(1)=names(1);
         popstr(2)={'Refresh menu'};
         popstr(3)={'Get new data'};
         dat.lastselind=1;
         dat.lastselname=names(1);

      else         
         
         % multiple data in memory
         dat.lastselind=0;
         for z=1:length(good)
            popstr(z)=names(z);
            if strcmpi(names(z),dat.lastselname)
               dat.lastselind=z;
               break
            end
            % was there a match?
            if ~dat.lastselind
               dat.lastselind=1;
            end
            
         end
         % select last-selected item
         popstr = [names(good);{'Refresh menu'};{'Get new data'}];
         dat.lastselname = popstr{dat.lastselind};

      end
      %select_emdata(go,'selectdata');
      
      go.Value  = dat.lastselind;
      go.String = popstr;

      
end %switch action

end %function select_emdata
