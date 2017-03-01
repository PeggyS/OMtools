% PHexpf4.m: Used by the PG to determine the pulse amplitude  % Written by:  Jonathan Jacobs%              October 1998  (last mod: 10/14/98)function out = PHexpf4( in )%%% calculated with modified PGcalc, for 2-pole plant%%% and delay before plant in testbed.%%% Ugly fix at end to fine-tune saccadessgn = sign(in);in = abs(in);if in>50, in=50; endc(1)=-98.53660008;c(2)=100.8929116; lambda(1)=0.3678493639;lambda(2)=-0.0035788741;numcoeff = length(lambda);out=0;for i = 1:numcoeff   out =  out + c(i)*exp(-lambda(i)*in);endout = sgn*out;%% OK, I admit that this is somewhat inelegant (actually it's plug ugly)%% but it seems to be the simplest way to tune the pulse height function.corrfac = [+1.00 -2.20 -0.90 -4.95 -1.00 -3.75 +0.50 -1.00 +3.00 +1.85...           +1.00 +0.40 -0.20 -0.50 -0.75 -0.90 -1.00 -1.10 -1.10 -1.20...           -1.25 -1.25 -1.25 -1.25 -1.20 -1.10 -1.10 -1.10 -1.00 -1.00...           -1.00 -1.00 -0.80 -0.75 -0.60 -0.55 -0.45 -0.40 -0.35 -0.25...           -0.15 -0.05  0.00 +0.15 +0.25 +0.30 +0.45 +0.55 +0.65 +0.75];if in >=1   diddle = corrfac(floor(in));   if ceil(in)~=in      denom=(ceil(in)-in);      diddle = diddle + (corrfac(ceil(in))-corrfac(floor(in))) * denom;   end else   diddle = 1;end out = out + diddle;