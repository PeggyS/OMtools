function omprefpath = findomprefs

% written by:  Jonathan Jacobs
%              February 2011

% Does 'omprefs' folder exist? It can exist in a number of places.
% Best location for any user-modified files is on $HOME/documents/MATLAB

sep = filesep;

comp = lower( computer('arch') );
if strcmp(comp(1),'m') || strcmp(comp(1),'g')
   homedir = getenv('HOME');
   documents = 'documents';
   sharedir = '/Users/Shared';
elseif strcmp(comp(1),'p')|| strcmp(comp(1),'w')
   homedir = getenv('USERPROFILE');
   documents = 'My Documents';
   sharedir = 'C:\Program Files\Common Files';
end

% NOTE: on OS X at least, matlabroot is the PACKAGE (really a folder) that
% is the MATLAB application. Go UP a level to be in the folder containing MATLAB
oldpath = pwd;
if strcmpi(homedir,'/home/mluser')
   homedir='/MATLAB Drive';
   cd('/MATLAB Drive')
else
   cd(matlabroot)
end

% possible locations where omprefs might be, as of ML2010b
locations = {
   {'homedir'}; ...
   {'homedir', 'documents', 'MATLAB'}; ...
   {'homedir', 'documents', 'MATLAB', 'OMtools'}; ...
   {'homedir', 'documents', 'MATLAB', 'omtools_prefs'}; ...
   {'homedir', 'documents', 'MATLAB', 'Add-Ons','toolboxes','OMtools', 'code'}; ...
   {'sharedir'}; ...
   {'sharedir', 'OMtools'}; ...
   {'matlabroot'}; ...
   {'matlabroot', 'OMtools'}; ...
   {'matlabroot', 'toolbox'};...
   {'matlabroot', 'toolbox', 'OMtools'}; ...
   };

   %{'matlabdir'}; ...
   %{'matlabdir', 'OMtools'}; ...


ompf=0; omtf=0;						%% omprefs folders found, OMtools folders found
%omtoolspath = cell(10,1);
omprefpath = cell(10,1);
omtoolspath = findomtools;

for jj=1:length(locations)
   cd(matlabroot)
   try
      temp1=char(locations{jj}(1));
      cd(eval(temp1))
      dir_err=0;
      %fprintf('good topdir %d: %s\n',jj,eval(temp1))
   catch
      %disp( ['dir_error: ' locations{j}] );
      %dir_err=1;
      %fprintf('bad topdir %d: %s\n',jj,eval(temp1))
      continue;
   end
   
   % if there are subdirectories, navigate to them.
   numsubdir = length(locations{jj});
   if numsubdir > 1
      dir_err=0;
      for k=2:numsubdir
         temp2=char(locations{jj}(k));
         try
            cd(temp2)
         catch
            dir_err=1;
         end
      end % for k
   end %if numsubdir
   
   if ~dir_err			% we have found a valid OMtools folder
      %if strfind(pwd,'OMtools') %#ok<STRIFCND>
         %omtf = omtf+1;
         %omtoolspath{omtf} = pwd;
      %end
      dirfiles = dir;
      for ii = 1:length(dirfiles)
         temp3 = deblank(dirfiles(ii).name);
         if strcmpi( temp3,'omtools_prefs')	%% we have found a valid omprefs folder
            try
               cd(temp3)
               cd('omprefs')
               ompf=ompf+1;
               omprefpath{ompf} = fullfile(pwd);
            catch
               % 
            end
            %return
         end
      end %for i
   end %if ~dir_err
end %for j

if ompf<1
   disp('Could not find any OMtools prefs location. ')
   disp('I will create an "omprefs" folder.')
   disp('Where do you want me to make it?')
   disp( ' 1. In your existing OMtools folder.')
   disp([' 2. In ' homedir sep documents sep 'MATLAB' sep 'omtools_prefs (recommended)' ])
   disp([' 3. In ' sharedir sep 'MATLAB' sep 'omtools_prefs (if multiple user accounts run MATLAB)' ])
   commandwindow
   ompchoice = input('--> ');
   
   if ompchoice == 1
      if omtf == 1 % unlikely that omtf=0 since we are running a program from OMtools
         omtoolspath = char(omtoolspath{1});
         cd(omtoolspath)
         mkdir('omprefs')
         omprefpath = fullfile(omtoolspath,'omprefs');
         cd('omprefs')
      elseif omtf > 1
         %omprefpath = '';
         disp('Multiple OMtools folders found. You should only have one OMtools folder')
         disp('on your MATLAB path. Please remove or rename all redundant OMtools folders.')
         error('Cannot create a folder for OMtools preferences. Aborting.')
      end
   elseif ompchoice==2
      cd(fullfile(homedir,documents,'MATLAB'))
      if ~exist( [homedir sep documents sep 'MATLAB' sep 'omtools_prefs'],'dir' )
         mkdir('omtools_prefs')
      end
      cd('omtools_prefs')
      mkdir('omprefs'); cd('omprefs')
      omprefpath = pwd;
      cd(oldpath)
   elseif ompchoice==3
      cd(fullfile(sharedir,'MATLAB'))
      if ~exist( fullfile(sharedir,'MATLAB','omtools_prefs'),'dir' )
         mkdir('omtools_prefs')
      end
      cd('omtools_prefs')
      mkdir('omprefs'); cd('omprefs')
      omprefpath = pwd;
      cd(oldpath)
   end
   
elseif ompf == 1
   omprefpath = char(omprefpath{1});
elseif ompf >1
   disp('Multiple omprefs folders found:')
   for m=1:ompf
      disp([num2str(m) ': ' char(omprefpath{m}) ] )
   end
   disp([char(13) 'Which one would you like to use? '])
   disp('(Best practice is to use one in your home directory.)')
   choice = 0;
   while choice < 1
      commandwindow
      choice = input('--> ');
   end
   temp = char(omprefpath{ompf});
   disp('Would you like to inactivate the other installations? (y/n)')
   commandwindow
   yorn=input('--> ','s');
   if strcmpi(yorn,'y')
      for m=1:ompf
         if choice == m
            % do nothing
         else
            % add an 'x' to the front of the other OMtools folders
            a = strfind(omprefpath{m}, 'omprefs');
            b = [ omprefpath{m}(1:a-1) 'OM_x' omprefpath{m}(a+2:end) ];
            movefile(omprefpath{m}, b);
         end
      end
   end
   omprefpath = temp;
   return
end %if ompf
%cd(omtoolspath); cd('..')
try
   cd(oldpath)
catch
end