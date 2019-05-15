% emd_extract: extract data from emData structure and place into base workspace

% written by: Jonathan Jacobs
% January 2017 - January 2019

% 01/25/19: Explicitly write empty data arrays to base if no valid data

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
   commandwindow
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
      if strcmpi(curr_name,char(candidate{i}))
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
         commandwindow
         match=input('--> ');
      end
   end
   emd = evalin('base',char(candidate{match}) );
end

digdata   = emd.digdata;   assignin('base','digdata'  ,digdata);
dataname  = emd.filename;  assignin('base','dataname' ,dataname);
samp_freq = emd.samp_freq; assignin('base','samp_freq',samp_freq);
numsamps  = emd.numsamps;  
t = (1:numsamps)/samp_freq;assignin('base','t',t');

if ~isempty(emd.start_times)
   global start_times %#ok<*TLEV>
   start_times = emd.start_times;
   assignin('base','start_times',start_times);
end

disp([emd_name ': Channels saved to base workspace: '])

global rh; global rhv;
if ~isempty(emd.rh.pos) && ~all(isnan(emd.rh.pos))
   rh =emd.rh.pos; 
   rhv=d2pt(emd.rh.pos,3,samp_freq);
   disp([sprintf('\b'),' rh']);
else
   rh=[]; rhv=[];
end
assignin('base','rh',rh); 
assignin('base','rhv',rhv);

global lh; global lhv;
if ~isempty(emd.lh.pos) && ~all(isnan(emd.lh.pos))
   lh =emd.lh.pos;
   lhv=d2pt(emd.lh.pos,3,samp_freq);
   disp([sprintf('\b'),' lh']);
else
   lh=[]; lhv=[];
end
assignin('base','lh',lh);
assignin('base','lhv',lhv);

global rv; global rvv;
if ~isempty(emd.rv.pos) && ~all(isnan(emd.rv.pos))
   rv =emd.rv.pos; 
   rvv=d2pt(emd.rv.pos,3,samp_freq);
   disp([sprintf('\b'),' rv']);
else
   rv=[]; rvv=[];
end
assignin('base','rv',rv); 
assignin('base','rvv',rvv);

global lv; global lvv;
if ~isempty(emd.lv.pos) && ~all(isnan(emd.lv.pos))
   lv =emd.lv.pos;
   lvv=d2pt(emd.lv.pos,3,samp_freq);
   disp([sprintf('\b'),' lv']);
else
   lv=[]; lvv=[];
end
assignin('base','lv',lv);
assignin('base','lvv',lvv);

global rt; global rtv;
if ~isempty(emd.rt.pos) && ~all(isnan(emd.rt.pos))
   rt =emd.rh.pos;
   rtv=d2pt(emd.rt.pos,3,samp_freq);
   disp([sprintf('\b'),' rt']);
else
   rt=[]; rtv=[];
end
assignin('base','rt',rt);
assignin('base','rtv',rtv);

global lt; global ltv;
if ~isempty(emd.lt.pos) && ~all(isnan(emd.lt.pos))
   lt =emd.lh.pos;
   ltv=d2pt(emd.lt.pos,3,samp_freq);
   disp([sprintf('\b'),' lt']);
else
   lt=[]; ltv=[];
end
assignin('base','lt',lt);
assignin('base','ltv',ltv);

global st; 
if ~isempty(emd.st.pos) && ~all(isnan(emd.st.pos))
   st=emd.st.pos; 
   disp([sprintf('\b'),' st']);
else
   st=[];
end
assignin('base','st',st);

global sv; 
if ~isempty(emd.sv.pos) && ~all(isnan(emd.sv.pos))
   sv=emd.sv.pos; 
   disp([sprintf('\b'),' sv']);
else
   sv=[];
end
assignin('base','sv',sv);

global ds; 
if ~isempty(emd.ds.pos) && ~all(isnan(emd.ds.pos))
   ds=emd.ds.pos; 
   disp([sprintf('\b'),' ds']);
else
   ds=[];
end
assignin('base','ds',ds);

global tl; 
if ~isempty(emd.tl.pos) && ~all(isnan(emd.tl.pos))
   tl=emd.tl.pos; 
   disp([sprintf('\b'),' tl']);
else
   tl=[];
end
assignin('base','tl',tl);

global hh; 
if ~isempty(emd.hh.pos) && ~all(isnan(emd.hh.pos))
   hh=emd.hh.pos; 
   disp([sprintf('\b'),' hh']);
else
   hh=[];
end
assignin('base','hh',hh);

global hv; 
if ~isempty(emd.hv.pos) && ~all(isnan(emd.hv.pos))
   hv=emd.hv.pos; 
   disp([sprintf('\b'),' hv']);
else
   hv=[];
end
assignin('base','hv',hv);

% ask to load 'extras' file?