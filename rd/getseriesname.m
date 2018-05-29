function seriesname = getseriesname(shortname)

us=strfind(shortname,'_');
lastus = us(end);

if lastus>1
   if isdigit(shortname(lastus+1))
      seriesname=[shortname(1:us(end)) '_'];
   else
      seriesname=shortname;
   end
end

while isdigit(seriesname(end))
   seriesname = seriesname(1:end-1);
end