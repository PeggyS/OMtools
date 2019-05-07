% swj: process output of findsaccs to detect square-wave jerks
% usage: swj = find_swj(found, data, samp_freq, debug);
% 'found' is output of findsaccs, which must have been called using
%    an amplitude range that detects SWJs.
%    Also suggest using 10 deg/sec as vel_on, vel_off parameters
% 'data' is vector of position data that was analyzed in 'findsaccs'
% 'samp_freq' is self-explanatory
% 'swj' is struct of SWJ arrays indexed using sample # (.start,.stop,.ampl)  
%    Also includes number of sjw found: swj.num_swj

% written by: Jonathan Jacobs  April 2019

function swj = find_swj(found, data, samp_freq, debug)

if nargin<4, debug=1; end

% Walk 'found' from 2:end
% If mag(sacc(i)) is in SWJ range, check next sacc to see if it falls
% within time range for SWJ, and also has acceptable OPPOSITE amplitude.
% Track start/stop, ampl of SWJs (can have single SWJ or trains)
swj.ampl(found.num)=NaN;
swj.start(found.num)=NaN;
swj.stop(found.num)=NaN;
swj_hi=4.00;  % max ampl for SWJ
swj_lo=0.15;  % min ampl for SWJ
swj_isi_lo=0.10*samp_freq; % shortest allowable ISI ~100ms
swj_isi_hi=0.40*samp_freq; % longest  allowable ISI ~500ms

c=1;prev_good=0;
for jj=1:found.num-1
   tr_str='';
   swj.end_of_train(c)=0;
   swj.start_of_train(c)=0;
   snum=['#' num2str(jj)];
   % is this a good candidate?
   if isnan(found.start(jj)) || isnan(found.stop(jj))
      if prev_good==1
         tr_str='end of train';
         swj.end_of_train(c)=1;
      end
      prev_good=0;
      disp([snum ' (' num2str(found.start(jj)) '): is NaN. ' tr_str])
      continue
   end
   ampl1=data(found.stop(jj))-data(found.start(jj));
   a1_str=num2str(ampl1,3);
   indstr = [snum ' (' num2str(found.start(jj)) '): ampl=' a1_str ', '];
   
   if abs(ampl1)>swj_lo && abs(ampl1)<swj_hi
      % look at next saccade. see if it's the return saccade
      if isnan(found.start(jj+1)) || isnan(found.stop(jj+1))
         if prev_good==1
            tr_str='end of train';
            swj.end_of_train(c)=1;
         end
         prev_good=0;
         if debug
            disp([indstr 'next sacc has a NaN time. ' tr_str]);
         end
         continue
      end
      
      % short enough time between saccs n & n+1
      isi=found.start(jj+1)-found.stop(jj);
      isi_str=num2str(isi/samp_freq);
      if  (isi > swj_isi_hi) && (isi < swj_isi_lo)
         if prev_good==1
            tr_str=' end of train';
            swj.end_of_train(c)=1;
         end
         prev_good=0;
         if debug,disp([indstr 'next sacc bad ISI=' isi_str ' ' tr_str]);end
         continue
      end      
      
      % the saccs must be in opposite directions
      ampl2=data(found.stop(jj+1))-data(found.start(jj+1));
      a2_str=num2str(ampl2,3);
      if sign(ampl1)==sign(ampl2)
         if prev_good==1
            tr_str='end of train';
            swj.end_of_train(c)=1;
         end
         prev_good=0;
         if debug,disp([indstr 'next sacc in wrong direction ' tr_str]);end
         continue
      end
      
      % approx equal amplitudes
      if abs(abs(ampl2)-abs(ampl1)) > 0.5*max(abs(ampl1),abs(ampl2))
         if prev_good==1
            tr_str=' end of train';
            swj.end_of_train(c)=1;
         end
         prev_good=0;
         if debug, disp([indstr 'next sacc bad ampl=' a2_str ' ' tr_str]); end
         continue
      end %if abs(ampl2)
         
      % yes, looks like the return saccade. accept as swj
      swj.ampl(c) = ampl1;
      try    swj.start(c) = found.start(jj);
      catch, keyboard; end
      try    swj.stop(c)  = found.stop(jj+1);
      catch, keyboard; end
      swj.end_of_train(c)=0; %bec we KNOW next sacc is part of this SWJ
      if prev_good==0
         swj.start_of_train(c)=1;
         tr_str=' start of train';
      end
      c=c+1;
      if debug
         disp([indstr 'GOOD! ampl2=' a2_str ', ISI=' isi_str ' ' tr_str]);
      end
      prev_good=1;      
   end %if abs(ampl1)
   
end %for jj

if debug, disp([num2str(c-1) ' SWJ found']); end

swj.start=swj.start(1:c-1);
swj.stop=swj.stop(1:c-1);
swj.ampl=swj.ampl(1:c-1);
swj.num_swj=c-1;

if debug
   assignin('base','swj',swj);
   disp('Results saved in base as "swj"');
end