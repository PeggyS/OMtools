function swj=find_swj(found, data, samp_freq, debug)

% 'found' is output of 'findsaccs', which must have been called with
%    an 'amplitude' range that detects SWJs.
% 'data' is vector of position samples that was analyzed in 'findsaccs'
% 'samp_freq' is self-explanatory
% 'out' = struct list of SWJs by time index (start,stop,ampl(?))

% how do the magik work? (possibilities)
% walk the 'found' structure from 2:end (or 1:end-1 ?)
% if mag(sacc(i)) is in SWJ range, look at prev (next?) sacc to see if
% falls within time range for SWJ, and also has approp opposite amplitude.
% while curr sacc is a candidate, look at next, and next, etc.
% track start/stop, ampl of SWJs (can have single SWJ or trains)

if nargin<4, debug=0; end

swj.ampl(found.num)=NaN;
swj.start(found.num)=NaN;
swj.stop(found.num)=NaN;
swj_hi=5.00;  % max ampl for SWJ
swj_lo=0.10;  % min ampl for SWJ
swj_isi_lo=0.10*samp_freq; % shortest allowable ISI ~100ms
swj_isi_hi=0.50*samp_freq; % longest  allowable ISI ~500ms

c=1;prev_good=0;
for jj=1:found.num-1
   swj.end_of_train(c)=1;
   swj.start_of_train(c)=0;
   % is this a good candidate?
   if isnan(found.start(jj)) || isnan(found.stop(jj))
      %disp(['#' num2str(jj) ': is NaN'])
      continue
   end
   ampl1 = data(found.stop(jj))-data(found.start(jj));
   if abs(ampl1)>swj_lo && abs(ampl1)<swj_hi
      % look at next saccade. see if it's the return saccade
      if isnan(found.start(jj+1)) || isnan(found.stop(jj+1))
         if debug, disp(['   #' num2str(jj) '+1: is NaN']); end
         continue
      end
      ampl2=data(found.stop(jj+1)) - data(found.start(jj+1));
      % the saccs must be in opposite directions
      if sign(ampl1)==sign(ampl2)
         if debug, disp(['   #' num2str(jj) '+1: wrong direction ']); end
         continue
      end
      if abs(abs(ampl2)-abs(ampl1)) < 0.5*max(abs(ampl1),abs(ampl2))
         % short enough time between saccs n & n+1
         if found.start(jj+1)-found.stop(jj) < swj_isi_hi && ...
              found.start(jj+1)-found.stop(jj) > swj_isi_lo
            % yes, looks like the return saccade
            swj.ampl(c)  = ampl1;
            try    swj.start(c) = found.start(jj);
            catch, keyboard; end
            try    swj.stop(c)  = found.stop(jj+1);
            catch, keyboard; end
            swj.end_of_train(c)=0;
            if prev_good == 0
               swj.start_of_train(c)=1;
            end
            prev_good=1;
            c=c+1;
            if debug, disp(['   #' num2str(jj) ': is good!']); end
         else
            if debug, disp(['   #' num2str(jj) '+1: bad ISI']); end
         end
         
      end %if abs(ampl2)
   end %if abs(ampl)   
end %for jj

if debug, disp([num2str(c-1) ' SWJ found']); end

swj.start=swj.start(1:c-1);
swj.stop=swj.stop(1:c-1);
swj.ampl=swj.ampl(1:c-1);
swj.num_swj=c-1;