% subp.m:  plot a subsection of an array vs time% usage: subp(inputArray, startTime, duration)% See also: SUB, TPLOT% Written by:  Jonathan Jacobs%             February 1997  (last mod: 02/28/97)function subp(inputArray, startTime, duration)global samp_freqif nargin == 0   help subp   returnendtplot( sub(inputArray, startTime, duration), startTime );