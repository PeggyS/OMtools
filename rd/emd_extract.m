function emd_extract(emd_name)

global dataname samp_freq

if nargin==0,emd_name='';end

% take from structure already in memory
varlist = evalin('base','whos');
candidate = cell(length(varlist),1);
x=0;
for i=1:length(varlist)
   if strcmpi(varlist(i).class, 'emData')
      x=x+1;
      candidate{x} = varlist(i).name;      
      if strcmpi(emd_name,varlist(i).name)
         break
      end      
   end
end

if x == 0
   disp('No eye-movement data structures found in memory.')
   disp('Would you like to load a saved one from disk?')
   yorn=input('--> ','s');
   if strcmpi(yorn,'y')
      [fn, pn] = uigetfile('*.mat','Select an eye movement .mat file');
      if fn==0,disp('Canceled.');return;end
      a=load([pn fn]);
      field_name = cell2mat( fieldnames(a) );
      emd = eval([ 'a.' field_name] );
   else
      return
   end
elseif x==1
   emd = evalin('base',char(candidate{1}) );
else
   curr_name = strtok(emd_name,'.');
   match=0;
   for i=1:x
      if strcmp(curr_name,char(candidate{i}))
         match=i;
         break
      end
   end
   if ~match
      for i=1:x
         disp( [num2str(i) ': ' char(candidate{i})] )
      end
      disp('Which eye-movement data do you want to extract?')
      while match<1 || match>x
         match=input('--> ');
      end
   end
   emd = evalin('base',char(candidate{match}) );
end

dataname  = emd.filename;  assignin('base','dataname',dataname);
samp_freq = emd.samp_freq; assignin('base','samp_freq',samp_freq);
numsamps  = emd.numsamps;  
t = (1:numsamps)/samp_freq;assignin('base','t',t');

if ~isempty(emd.start_times)
   global start_times %#ok<*TLEV>
   start_times = emd.start_times;
   assignin('base','start_times',start_times);
end

disp([emd_name ': Channels saved to base workspace: '])

if ~isempty(emd.rh.pos) && ~all(isnan(emd.rh.pos))
   global rh;  rh =emd.rh.pos; assignin('base','rh',rh); 
   global rhv; rhv=d2pt(emd.rh.pos,3,samp_freq); assignin('base','rhv',rhv); 
   disp([sprintf('\b'),' rh']);
end
if ~isempty(emd.lh.pos) && ~all(isnan(emd.lh.pos))
   global lh;  lh =emd.lh.pos; assignin('base','lh',lh); 
   global lhv; lhv=d2pt(emd.lh.pos,3,samp_freq); assignin('base','lhv',lhv); 
   disp([sprintf('\b'),' lh']);
end
if ~isempty(emd.rv.pos) && ~all(isnan(emd.rv.pos))
   global rv;  rv =emd.rv.pos; assignin('base','rv',rv); 
   global rvv; rvv=d2pt(emd.rv.pos,3,samp_freq); assignin('base','rvv',rvv); 
   disp([sprintf('\b'),' rv']);
end
if ~isempty(emd.lv.pos) && ~all(isnan(emd.lv.pos))
   global lv;  lv =emd.lv.pos; assignin('base','lv',lv); 
   global lvv; lvv=d2pt(emd.lv.pos,3,samp_freq); assignin('base','lvv',lvv); 
   disp([sprintf('\b'),' lv']);
end
if ~isempty(emd.rt.pos) && ~all(isnan(emd.rt.pos))
   global rt;  rt =emd.rt.pos; assignin('base','rt',rt); 
   global rtv; rtv=d2pt(emd.rt.pos,3,samp_freq); assignin('base','rtv',rtv); 
   disp([sprintf('\b'),' rt']);
end
if ~isempty(emd.lt.pos) && ~all(isnan(emd.lt.pos))
   global lt;  lt =emd.lt.pos; assignin('base','lt',lt); 
   global ltv; ltv=d2pt(emd.lt.pos,3,samp_freq); assignin('base','ltv',ltv); 
   disp([sprintf('\b'),' lt']);
end
if ~isempty(emd.st.pos) && ~all(isnan(emd.st.pos))
   global st; st=emd.st.pos; assignin('base','st',st); 
   disp([sprintf('\b'),' st']);
end
if ~isempty(emd.sv.pos) && ~all(isnan(emd.sv.pos))
   global sv; sv=emd.sv.pos; assignin('base','sv',sv); 
   disp([sprintf('\b'),' sv']);
end
if ~isempty(emd.ds.pos) && ~all(isnan(emd.ds.pos))
   global ds; ds=emd.ds.pos; assignin('base','ds',ds); 
   disp([sprintf('\b'),' ds']);
end
if ~isempty(emd.tl.pos) && ~all(isnan(emd.tl.pos))
   global tl; tl=emd.tl.pos; assignin('base','tl',tl); 
   disp([sprintf('\b'),' tl']);
end
if ~isempty(emd.hh.pos) && ~all(isnan(emd.hh.pos))
   global hh; hh=emd.hh.pos; assignin('base','hh',hh); 
   disp([sprintf('\b'),' hh']);
end
if ~isempty(emd.hv.pos) && ~all(isnan(emd.hv.pos))
   global hv; hv=emd.hv.pos; assignin('base','hv',hv); 
   disp([sprintf('\b'),' hv']);
end

% ask to load 'extras' file?