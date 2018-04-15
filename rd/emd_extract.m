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

disp([emd_name ': channels saved to base workspace: '])

if ~isempty(emd.rh.data)
   global rh;  rh =emd.rh.data; assignin('base','rh',rh); 
   global rhv; rhv=emd.rh.vel;  assignin('base','rhv',rhv); 
   disp([sprintf('\b'),' rh']);
end
if ~isempty(emd.lh.data)
   global lh;  lh =emd.lh.data; assignin('base','lh',lh); 
   global lhv; lhv=emd.lh.vel;  assignin('base','lhv',lhv); 
   disp([sprintf('\b'),' lh']);
end
if ~isempty(emd.rv.data)
   global rv;  rv =emd.rv.data; assignin('base','rv',rv); 
   global rvv; rvv=emd.rv.vel;  assignin('base','rvv',rvv); 
   disp([sprintf('\b'),' rv']);
end
if ~isempty(emd.lv.data)
   global lv;  lv =emd.lv.data; assignin('base','lv',lv); 
   global lvv; lvv=emd.lv.vel;  assignin('base','lvv',lvv); 
   disp([sprintf('\b'),' lv']);
end
if ~isempty(emd.rt.data)
   global rt;  rt =emd.rt.data; assignin('base','rt',rt); 
   global rtv; rtv=emd.rt.vel;  assignin('base','rtv',rtv); 
   disp([sprintf('\b'),' rt']);
end
if ~isempty(emd.lt.data)
   global lt;  lt =emd.lt.data; assignin('base','lt',lt); 
   global ltv; ltv=emd.lt.vel;  assignin('base','ltv',ltv); 
   disp([sprintf('\b'),' lt']);
end
if ~isempty(emd.st.data)
   global st; st=emd.st.data; assignin('base','st',st); 
   disp([sprintf('\b'),' st']);
end
if ~isempty(emd.sv.data)
   global sv; sv=emd.sv.data; assignin('base','sv',sv); 
   disp([sprintf('\b'),' sv']);
end
if ~isempty(emd.ds.data)
   global ds; ds=emd.ds.data; assignin('base','ds',ds); 
   disp([sprintf('\b'),' ds']);
end
if ~isempty(emd.tl.data)
   global tl; tl=emd.tl.data; assignin('base','tl',tl); 
   disp([sprintf('\b'),' tl']);
end
if ~isempty(emd.hh.data)
   global hh; hh=emd.hh.data; assignin('base','hh',hh); 
   disp([sprintf('\b'),' hh']);
end
if ~isempty(emd.hv.data)
   global hv; hv=emd.hv.data; assignin('base','hv',hv); 
   disp([sprintf('\b'),' hv']);
end

% ask to load 'extras' file?