% doFFT.m: script to make pretty FFTs
% Usage: doFFT(input, samp freq);

% Written by:  Jonathan Jacobs
%              May 1997 - April 1998 (last mod: 04/09/98)

function [f_inp1,f] = doFFT(inp, sampf)

global samp_freq

if nargin < 1
   help doFFT
   return
 elseif nargin == 1
   if ~isempty(samp_freq)
      sampf = samp_freq;
      disp(['Sampling frequency: ' num2str(sampf) ' Hz.'])
    else
      sampf = -1;
      while sampf < 0
         sampf = input('Enter sampling frequency: ');
      end
   end
end

% NaNs make FFT puke. 
nanPts = isnan(inp);
inp = bridgenan(inp);

% remove DC component
temp = inp;
inp = temp - mean(temp);

len = length(inp);
f_inp = fft(inp);
f_inp = abs(f_inp);      %absolute val
f_inp = 2*f_inp/sampf;   %adjust for sampf

%f_inp = sqrt(f_inp .* conj(f_inp)/len);  %absolute val
%f_inp = 2*f_inp ./ sum(f_inp);           %normalize to spectral sum = 1

% restore the NaNs.
f_inp(nanPts) = NaN;

% make a frequency axis vector and plot.
f = sampf*(0:len-1)/len;             %frequency axis
figure
plot( f(1:len/2),f_inp(1:len/2) )
zoomtool
