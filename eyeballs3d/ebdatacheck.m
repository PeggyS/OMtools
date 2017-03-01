% ebdatacheck: called by eyeballs3d and ebAct3D to verify that valid data% (composed of up to six global, equal-length vectors -- lh, lv, lt, rh, rv, rt % and the sampling frequency, samp_freq) are loaded into memory. % Written by: Jonathan Jacobs%             May 2003 - June 2003  (last mod: 06/05/03)% Files necessary for proper operation:%   'eyeballs3d', 'ebAct3D.m', 'datscale.m', 'd2pt.m'%   'xyplotsettings.m', 'ebdatacheck.m', 'ebdataload.m'% If you have received this as a '.p' (pseudocode) file, all the% above-mentioned functions will also be '.p' files.  (And you shouldn't% even be reading this?)function [status, datlen, noHOR, noVRT, noTOR, noSTM] = datacheck(null);global rh lh rv lv rt lt st sv samp_freq% check the existence and validity of the data.% check from worst case (no data) to lesser problem (1D data)% to mildest cases (uniocular data).noLH=0; mtLH=0; if isempty(lh), noLH = 1; elseif all(lh==0), mtLH = 1; end  % 'all' case noRH=0; mtRH=0; if isempty(rh), noRH = 1; elseif all(rh==0), mtRH = 1; end  % had beennoLV=0; mtLV=0; if isempty(lv), noLV = 1; elseif all(lv==0), mtLV = 1; end  % set to '1'noRV=0; mtRV=0; if isempty(rv), noRV = 1; elseif all(rv==0), mtRV = 1; end  % but that madenoLT=0; mtLT=0; if isempty(lt), noLT = 1; elseif all(lt==0), mtLT = 1; end  % for extra andnoRT=0; mtRT=0; if isempty(rt), noRT = 1; elseif all(rt==0), mtRT = 1; end  % unnecessarynoST=0; mtST=0; if isempty(st), noST = 1; elseif all(st==0), mtST = 1; end  % repetitivenoSV=0; mtSV=0; if isempty(sv), noSV = 1; elseif all(sv==0), mtSV = 1; end  % workif noLH, lhlen = 0; else lhlen=max(size(lh)); endif noLV, lvlen = 0; else lvlen=max(size(lv)); endif noLT, ltlen = 0; else ltlen=max(size(lt)); endif noRH, rhlen = 0; else rhlen=max(size(rh)); endif noRV, rvlen = 0; else rvlen=max(size(rv)); endif noRT, rtlen = 0; else rtlen=max(size(rt)); endif noSV, svlen = 0; else svlen=max(size(sv)); endif noST, stlen = 0; else stlen=max(size(st)); endnoHOR  = (noLH & noRH) | (mtLH & mtRH) ;noVRT  = (noLV & noRV) | (mtLV & mtRV) ;noTOR  = (noLT & noRT) | (mtLT & mtRT) ;noDATA = noVRT & noHOR & noTOR;noSTM  = (noST & noSV) | (mtST & mtSV);datlen = 0;if noDATA   disp(' ')   disp('  *** datacheck: valid data not loaded in memory! ***')   disp('  The data must be composed of up to six equal-length vectors')   disp('  (lh, lv, lt, rh, rv, rt) that must be declared as global variables')   disp('  before they are read in.  Additionally, the sampling frequency,')   disp('  "samp_freq" must also be a global variable.')   disp(' ')   status = 0;   returnendif isempty(samp_freq)   samp_freq = input('Enter the sampling frequency: ');endhorlen = max(lhlen,rhlen);     %% we will assume that there will NEVERvrtlen = max(lvlen,rvlen);     %% be a data file with ONLY torsional torlen = max(ltlen,rtlen);     %% data.  if i am wrong about this, welldatlen = max(horlen, vrtlen);  %% i'll cross that bridge when i come to it.% so we have some data. is it HOR or VRT?plotHorEnab = 'on'; plotVrtEnab = 'on'; plotTorEnab = 'on';if noHOR                                     % so there must be vrt   %disp('No horizontal data loaded. Initializing lh & rh to zeros.')   lh = zeros(max(lvlen,rvlen),1);   rh = lh;   noLH = 0; noRH = 0;   plotHorEnab = 'off';endif noVRT   %disp('No vertical data loaded. Initializing lv & rv to zeros.')   lv = zeros(max(lhlen,rhlen),1);   rv = lv;   noLV = 0; noRV = 0;   plotVrtEnab = 'off';endif noTOR   %disp('No torsional data loaded. Initializing lt & rt to zeros.')   lt = zeros(max(lhlen,rhlen),1);   rt = lt;   noLT = 0; noRT = 0;   plotTorEnab = 'off';endif noSTM   %disp('No stimulus data loaded. Initializing st & sv to zeros.')   st = zeros(datlen,1);   sv = st;   noST = 0; noSV = 0;end% do we have BOTH eyes for each plane? could have embedded this check% in the HOR/VRT check, but it is easier to read (albeit slightly% less efficient) this way, since we will execute both checks.if noLH   lh = rh; %disp('No lh data loaded. Setting lh = rh.') elseif noRH   rh = lh; %disp('No rh data loaded. Setting rh = lh.')endif noLV   lv = rv; %disp('No lv data loaded. Setting lv = rv.') elseif noRV   rv = lv; %disp('No rv data loaded. Setting rv = lv.')end   if noLT   lt = rt; %disp('No lt data loaded. Setting lt = rt.') elseif noRT   rt = lt; %disp('No rt data loaded. Setting rt = lt.')end   if noST   st = zeros(datlen,1); %disp('No st data loaded. Setting st to zeros.') elseif noSV   sv = zeros(datlen,1); %disp('No sv data loaded. Setting sv to zeros.')endstatus = 1;