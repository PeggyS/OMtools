%findwind.m: Find named window.% [tgtwind]=findwind('name') find the named window.function tgtwind = findwind(windname)tgtwind = -1;windowlist = get(0,'Children');for i = 1:length(windowlist)   if strcmp(get(windowlist(i),'Name'), windname)	  tgtwind = windowlist(i);	  break   endend