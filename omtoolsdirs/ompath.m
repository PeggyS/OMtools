% OMpath.m: add the directories needed to use the% OMtools analysis m-files.% Written by:  Jonathan Jacobs%              December 1995 - June 2009  (last mod: 06/20/09)% 21 March 2003: added '/' as sep character for MATLAB 6.5 (OS X, yay!)% 24 March 2003: added sep2 for UNIX (ML6.5 on OS X)% 20 June 2009:  added 'overrides' directory.  loads BEFORE standard ML toolboxes% March 2017. Gutted and modernizedfunction ompath()curdir=pwd;omtoolspath = char(findomtools);cd(omtoolspath)modelspath=[];if exist([omtoolspath '/simstuff'],'dir')    modelspath = omtoolspath;else    cd ..    if exist([pwd '/simstuff'],'dir')        modelspath = pwd;    endend% check if omtools appears on matlabpathP = matlabpath;mlp = lower(P);nomt = strfind(mlp,'omtools');% as of 8 Mar 2017, there are 13 OMtools folders that appear on the MATLAB% path. I may be removing some (personal) eventually.if length(nomt) < 12 %% && isempty(modelspath)    disp('Adding OMtools folders to MATLAB paths.')else    disp(' ')    disp('The OMtools folders are set.')    disp('  (If you think this is not so, or that the paths are damaged,)')    disp('  (run MATLAB''s pathtool and manually delete any OMtools paths.)')    cd(curdir)    returnendsep  = filesep;sep2 = pathsep;% add 'overrides' to appear BEFORE any MATLAB built-in functions% if using R2012a or later, can ignore Overrides, since ML defaults to proper java windowstemp=ver('MATLAB');ML_VER = str2double(temp.Version);if (ML_VER > 7.13) && (ML_VER <= 8.1)    over_dir = [omtoolspath sep 'overrides'];    if exist(over_dir,'dir')        mlp = path( [omtoolspath sep 'overrides' sep2], mlp);    endend% core stuff.  should ALWAYS be presentcd(omtoolspath)add = '';add = [add omtoolspath sep2];if exist('omprefs','dir'),   add = [add omtoolspath sep 'omprefs' sep2];   endadd = [add omtoolspath sep 'rd' sep2];add = [add omtoolspath sep 'rd' sep 'pickdata' sep2];add = [add omtoolspath sep 'utils' sep2];add = [add omtoolspath sep 'utils' sep 'filt' sep2];add = [add omtoolspath sep 'analysis' sep2];add = [add omtoolspath sep 'analysis' sep 'tplot3' sep2];add = [add omtoolspath sep 'labels' sep2];add = [add omtoolspath sep 'omtoolsdirs' sep2];% might not be present in some installations%if exist('personal','dir'),   add = [add omtoolspath sep 'personal' sep2];   endif exist('graphing','dir'),   add = [add omtoolspath sep 'graphing' sep2];   endif exist('zoomtool','dir'),   add = [add omtoolspath sep 'zoomtool' sep2];   endif exist('eyeballs3d','dir'), add = [add omtoolspath sep 'eyeballs3d' sep2]; endif ~isempty(modelspath)    add = [add modelspath sep 'simstuff' sep2];    add = [add modelspath sep 'simstuff' sep 'misc' sep2];    add = [add modelspath sep 'simstuff' sep 'diagrams' sep2];    add = [add modelspath sep 'simstuff' sep 'common' sep2];    add = [add modelspath sep 'simstuff' sep 'LNsim' sep2];    add = [add modelspath sep 'simstuff' sep 'LNsim' sep 'mfiles' sep2];    add = [add modelspath sep 'simstuff' sep 'CNsim' sep2];    add = [add modelspath sep 'simstuff' sep 'CNsim' sep 'mfiles' sep2];    add = [add modelspath sep 'simstuff' sep 'SPsim' sep2];    add = [add modelspath sep 'simstuff' sep 'SPsim' sep 'mfiles' sep2];    add = [add modelspath sep 'simstuff' sep 'SaccSim' sep2];    add = [add modelspath sep 'simstuff' sep 'SaccSim' sep 'mfiles' sep2];endpath( add, P );disp('Do you want to save the OMtools folders onto the MATLAB path?')disp('They will automatically remain available until you remove them')disp('by using the MATLAB "Set Path" tool. (y/n)')commandwindowyorn = input('--> ','s');if strcmpi(yorn,'y')    savepathendcd(curdir)