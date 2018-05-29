function seriesname = getseriesname(shortname)

seriesname = shortname;
if contains(shortname,'_')
   seriesname=[strtok(shortname,'_') '_'];
end

while isdigit(seriesname(end))
   seriesname = seriesname(1:end-1);
end