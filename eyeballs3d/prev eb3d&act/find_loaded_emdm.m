function dat=find_loaded_emdm(go)

dat.loaded_data.Items={};

% find all emData sets in base memory
temp=evalin('base','whos');
tlen=length(temp);
dat.loadednames=cell(tlen,1);

% load the f_info struct
cnt=0;
for ii=1:tlen
   if strcmpi(temp(ii).class,'emData')
      cnt=cnt+1;
      [~,emd_info] = getEMD(temp(ii).name);
      if isempty(emd_info)
         continue
      else
         dat.loadednames{cnt}=temp(ii).name;
         dat.loaded_data.Items{cnt}=dat.loadednames{cnt};
         dat.f_info(cnt).filename=emd_info.filename;
         dat.f_info(cnt).pathname=emd_info.pathname;
         dat.f_info(cnt).samp_freq=emd_info.samp_freq;
         dat.f_info(cnt).cutoff=emd_info.samp_freq/20;
         dat.f_info(cnt).numsamps=emd_info.numsamps;
         dat.f_info(cnt).chan_names=emd_info.chan_names;
      end
   end
end %for ii

if cnt==0, dat=[]; return; end
dat.loadednames=dat.loadednames(1:cnt);
%dat.loadednames=~cellfun(@isempty,dat.loadednames);

if nargin==0,   return;end
if isempty(go), return;end

go.UserData=dat;
go.String=[dat.loadednames;{'Get new data';'Refresh'}];

end %function update_datalist

