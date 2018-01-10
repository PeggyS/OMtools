% rdpath.m:  Either read in the last directory (&path) from which a data file% was RD, or write the directory (&path) to the RD directory.% If rdpath.txt is missing,running "RD" will generate it.% Written by:  Jonathan Jacobs%              July 1997 - March 2004 (last mod: 03/11/04)function rdpath( mode, thisPath )if nargin == 0, thisPath=pwd; mode ='r'; endif nargin == 1, thisPath=pwd; endgp_err = 0;oldpath = pwd;cd(matlabroot)try cd(findomprefs); catch, gp_err=1; endif gp_err % must make a omprefs directory   cd(findomtools)   mkdir('omprefs')endswitch lower(mode(1))   case {'r'}      fid = fopen('rdpath.txt');      if fid > 0         lastRD_txt = fread(fid,'*char');         fclose(fid);         lastrdpath = lastRD_txt';         if nargin==0;disp(['Current rd directory: ' lastrdpath ]);end         try            cd(lastrdpath)         catch                        disp('Bad path to last-read file!')            disp(['Resetting to default data directory: ' dataroot])            rdpath('w',dataroot)            cd(dataroot)         end               else         disp('rdpath.txt is missing from omprefs folder.')         disp('I will attempt to create and initialize it.')         rdpath('w',dataroot)               end         case {'w'}      fid=fopen('rdpath.txt','w');      fwrite(fid, thisPath, 'char');      fclose(fid);      cd(oldpath)end