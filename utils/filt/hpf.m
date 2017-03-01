% hpf.m:  high-pass filter.% Usage: output = hpf(input, filter order, cutoff freq, samp freq);% Written by:  Jonathan Jacobs%              May 1997 - January 2004 (last mod: 01/10/04)% guess what? either 'butter' or 'filtfilt' can't handle NaNs!% wankers.  Temporarily replace those nasty NaNs with honest zeros.% then swap the NaNs back after the filtering's done.function out = hpf(in, ord, cutoff, sampf)if nargin < 4   help hpf   returnendnanPts = isnan(in);in = bridgenan(in);nyqf = sampf/2;[b,a] = butter(ord, cutoff/nyqf, 'high');out = filtfilt(b,a,in);out(nanPts) = NaN;