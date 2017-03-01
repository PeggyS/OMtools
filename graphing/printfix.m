% printfix.m: May fix the problem where figure will not print out correctly,% and instead looks pixelated (especially the text), rather than like it was% printed using PostScript (which should be smooth). % Written by:  Jonathan Jacobs%              June 2000  (last mod: 06/15/00)function rmoderenderer = get(gcf,'renderer');rmode    = get(gcf,'renderermode');disp(['Renderer:      ' renderer]);disp(['Renderer Mode: ' rmode]);if strcmp(rmode,'manual')   disp('The  renderer mode is set to manual.  This could be a problem.')   yn=lower(input('Shall I set it to auto (y/n)? ','s'));   if yn=='y'      set(gcf,'renderermode','auto');   endenddisp(' ')