% lpf.m:  low-pass filter.
% Usage: output = lpf(input, filter order, cutoff freq, samp freq);

% Written by:  Jonathan Jacobs
%              May 1997 - January 2004 (last mod: 01/10/04)

% guess what? either 'butter' or 'filtfilt' can't handle NaNs!
% wankers.  Temporarily replace those nasty NaNs with honest zeros.
% then swap the NaNs back after the filtering's done.

function out = lpf(in, ord, cutoff, sampf)

if nargin < 4
   help lpf
   return
end

if isempty(in)
   fprintf('\nInput array is empty. No filter applied.\n')
   out=in;   
   return
end

nanPts = isnan(in);
in = bridgenan(in);

if all(isnan(in)) || isempty(in)
   fprintf('\nInput array is empty or NaN. No filter applied.\n')
   out=in;   
   return
end
   

nyqf = sampf/2;
[b,a] = butter(ord, cutoff/nyqf);

try
   out = filtfilt(b,a,in);
catch ME
   fprintf('\nToo many NaNs in input signal.\n');
   fprintf('%s\n',ME.identifier);
   out(nanPts)=NaN;
   %keyboard
end

out(nanPts) = NaN;