%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function winH = findwind(name)
winH = -1;
ch = get(0,'Children');
for i=1:length(ch)
   if strcmpi(ch(i).Name, name)
      winH = ch(i);
      break
   end
end
