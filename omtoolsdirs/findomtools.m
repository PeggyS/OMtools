function [omtoolspath,out] = findomtools

% written by:  Jonathan Jacobs
%              February 2011

% Does 'OMtools' folder exist? It can exist in a number of places:
% original location: matlabroot.  No longer a good idea, but will allow it.
% other locations: inside folder containing MATLAB; inside toolbox
% or even in home directory 'MATLAB' folder.

comp = lower( computer('arch') );
if strcmp(comp(1),'m') || strcmp(comp(1),'g')
   homedir = getenv('HOME');
   documents = 'documents'; %#ok<NASGU>
   sharedir = '/Users/Shared/MATLAB'; %#ok<NASGU>
elseif strcmp(comp(1),'p')|| strcmp(comp(1),'w')
   homedir = getenv('USERPROFILE');
   documents = 'My Documents'; %#ok<NASGU>
   sharedir = 'C:\Program Files\Common Files'; %#ok<NASGU>
end

olddir = pwd;
cd(matlabroot)
if strcmpi(homedir,'/home/mluser')
   homedir='/MATLAB Drive'; %#ok<NASGU>
   cd('/MATLAB Drive')
   %fprintf('pwd: %s\n',pwd)
else
end

locations = {
   {'homedir'}; ...
   {'homedir', 'documents', 'MATLAB'}; ...
   {'homedir', 'documents', 'MATLAB','Add-Ons','toolboxes'}; ...
   {'sharedir'}; ...
   {'sharedir','documents','MATLAB'};
   };
   %%%{'matlabroot'}; ...
   %%%{'matlabroot', 'toolbox'}; ...

omtf=0;								%% omtools folders found
omtoolspath = cell(10,1);
ot_ver = cell(10,1);
for jj=1:length(locations)   
   cd(matlabroot)
   try
      temp1=char(locations{jj}(1));
      cd(eval(temp1))
      dir_err=0;
      %fprintf('good topdir %d: %s\n',jj,eval(temp1))
   catch
      %disp( ['dir not present: ' char(locations{j}) ...
      %   ' (' eval('sharedir') ')'] );
      %keyboard
      %fprintf('bad topdir %d: %s\n',jj,eval(temp1))
      %dir_err=1;
      continue;
   end
   
   % if there are subdirectories, navigate through them.
   numsubdir = length(locations{jj});
   if numsubdir > 1
      dir_err=0;
      for k=2:numsubdir
         temp2=char(locations{jj}(k));
         try
            cd(temp2) 
         catch
             dir_err=1;
             %keyboard
         end
      end % for k
   end %if numsubdir
   
   if ~dir_err
      %fprintf('pwd: %s\n',pwd)
      dirfiles = dir;
      for ii = 1:length(dirfiles)
         temp3 = deblank(lower(dirfiles(ii).name));
         if strcmpi( temp3, 'omtools')
            omtf = omtf+1;
            omtoolspath{omtf} = fullfile(pwd,'OMtools');
            temp=pwd;
            cd(omtoolspath{omtf})
            try
               ot_ver{omtf} = omtools_version;
            catch
               ot_ver{omtf} = 'unknown version';
            end
            cd(temp)
            if nargout==0
               fprintf('%s:  %s\n',omtoolspath{omtf},ot_ver{omtf});
            end
         end
      end %for ii
   else
       %fprintf('bad jj:%d\n',jj)
       %keyboard
   end %if ~dir_err
end %for j
omtoolspath=omtoolspath(1:omtf);

if omtf == 0
   fprintf('No OMtools found!\n')
   omtoolspath='';
elseif omtf == 1
   omtoolspath = char(omtoolspath);
elseif omtf > 1
   for m = 1:length(omtoolspath)
      if ~isempty(char(omtoolspath{m}))
         disp([num2str(m) ': ' char(omtoolspath{m}) '  ' char(ot_ver{m})] )
      else
         break
      end
   end
   omtp=0;
   while omtp <1 || omtp > length(omtoolspath)
      commandwindow
      omtp = input('Select which OMtools you want to use: ');
   end
   omtoolspath = char(omtoolspath{omtp});
end

if nargout==0
   clear out omtoolspath
else
   out = ot_ver{omtf};
end

try    cd(olddir)
catch, end

return