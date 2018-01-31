function datstat

set(0,'ShowHiddenHandles','on')
winH = findwind('EM Data Manager');
if winH == -1
   datstat_gui
else
   refreshdata(winH)
   figure(winH)
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function winH = findwind(name)
winH = -1;
ch = get(0,'Children');
for i=1:length(ch)
   if strcmpi(ch(i).Name, name)
      winH = ch(i);
      break
   end
end

end %function
