% findMe.m: used by the editing functions to find% if they have their window open% Written by:  Jonathan Jacobs%              September 1997  (last mod: 09/10/97)function theWindow = findMe(who)who = lower(who);windowList = get(0,'Children');if isempty(windowList)   %disp('No windows open.')   theWindow = -1;   returnend% check the children for the given stringfor i = 1:length(windowList)   a=lower(get(windowList(i),'Tag'));   if strcmp(a,who)      theWindow = windowList(i);      return   endend% if nothing foundtheWindow = -1;return