function dat=select_emdata(go,action)


emdm=findwind('EM Data');
if ishandle(emdm)
   busy=emdm.UserData.busy;
else
   datstat
   %busy=0;
end

if nargin==1,action=[];end

if nargin==0, go=[];end
if ischar(go),go=[];end
if isempty(go) || ~ishandle(go)
   go=gco; % popup control
   if isempty(go);return;end
end

%if isempty(go) || ~ishandle(go) || ~strcmp(go.Style,'popupmenu')
%   %test string,value
%   go=struct;
%   go.String={'Get new data';'Refresh'};
%   go.Value=1;
%   go.Tag='fakepop';
%end

dat=find_loaded_emdm(go);

if strcmp(go.Style,'popupmenu')
   dat.loadednames=go.Tag;
   if isempty(dat.loadednames),dat.loadednames={''};end
   availdata=go.String;
   newsel=go.Value;
   if isempty(action)     
      % use popup selection
      if newsel==length(availdata)-1
         action='newdata';    % 2nd from bottom
      elseif newsel==length(availdata)
         action='refresh';    % bottom
      else
         action='selectdata'; % all others
      end
   else
      % use received command
      action='refresh';
   end
else
   return
end

%emdm.RunningAppInstance.outside_call_to_add_data;
%emdm.RunningAppInstance.update_datalist;


switch lower(action)
   
   case 'newdata'
      %if newsel==length(availdata), return; end
      
      % what data or data action was selected?
      if newsel==length(availdata)-1   % "add new data"
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
         go.Value=1;
         return
      end
      
      
   case 'selectdata'
      % it is EM data
      dat.channels=dat.f_info(newsel).chan_names;
      selected=dat.loaded_data.Items{newsel};
      data = evalin('base',[selected ';']);
      go.UserData=data;
      

   case 'refresh'
      names=dat.loadednames;      
      good=find(~cellfun(@isempty,names));
      availdata=go.String;
      
      if isempty(good)
         availdata(1)={'Get new data'};
         availdata(2)={'Refresh'};
         go.String=availdata;
         go.Value=2;
         dat.lastselname=availdata(1);
         go.Tag=''; %dat.lastselname{1};
         return
      end
      
      if length(good)==1
         go.Value=1;
         dat.lastselname=names(1);
         availdata(1)=names(1);
         availdata(2)={'Get new data'};
         availdata(3)={'Refresh'};
         go.String=availdata;
         go.Tag=dat.lastselname{1};
      else
         % multiple data in memory
         dat.lastselind=1;
         for z=1:length(good)
            availdata(z)=names(z);
            if strcmpi(names(z),dat.lastselname{1})
               dat.lastselind=z;
            end
         end
         % select last-selected item
         availdata = [names(good);{'Get new data'};{'Refresh'}];
         go.String = availdata;
         go.Value  = dat.lastselind;
         dat.lastselname = availdata(dat.lastselind);
         go.Tag = dat.lastselname{1};
      end
      
end %switch action

end %function select_emdata
