function nafxAct(action)

nafxFig = findme('NAFXwindow');
if ishandle(nafxFig)
   h=nafxFig.UserData;
else
   disp('ERRRRRRRORRRRR')
   return
end

% handles from NAFX GUI
posArray = h.posArrayNAFXH.String;
velArray = h.velArrayNAFXH.String;

all_pos_str = h.posLimNAFXH.UserData;
posLimVal   = h.posLimNAFXH.Value;
posLim      = all_pos_str(posLimVal);

all_vel_str = h.velLimNAFXH.UserData;
velLimVal   = h.velLimNAFXH.Value;
velLim      = all_vel_str(velLimVal);

fovstat   = h.fovStatNAFXH.Value;
tau_vers2 = h.tauVersH.Value;
age_range = h.nafx2snelH.Value;
dblplot   = h.dblPlotNAFXH.Value;

switch lower(action)
   case 'calcnafx'
      funcNAFX = 'nafxgui';      
      numfov = str2double(h.numFovNAFXH.String);
      h.fovStatNAFXH.Value=0;
      
      % unfuxxor this quotidian mess!
      dstr=['nafx(' posArray ',' velArray ',' num2str(samp_freq) ','];
      dstr=[dstr num2str(numfov) ',' qstr funcNAFX(1:end-3) qstr ',[0,' ];
      dstr=[dstr num2str(posLim) ',' num2str(velLim) ']);'];
      disp(dstr)
      
      nafx(eval(posArray),eval(velArray),samp_freq,numfov, ...
         funcNAFX,[0,posLim,velLim],tau_vers2);
      
      h.fovStatNAFXH.Value=fovstat;
      
      
   case 'calcfovs'
      funcNAFX  = h.fovCritNAFXH.UserData;
      valNAFX   = h.fovCritNAFXH.Value;
      funcNAFX  = [deblank(funcNAFX(valNAFX,:)) 'gui'];
      
      %tau       = str2double(h.tauNAFXH.String);
      
      % unfuxxor this quotidian mess!
      dstr=['nafx(' posArray ',' velArray ',' num2str(samp_freq) ];
      dstr=[dstr ',[' num2str(posLim) ',' num2str(velLim) '],' ];
      dstr=[dstr qstr funcNAFX(1:end-3) qstr ',' num2str(dblplot) ');'];
      disp(' '),
      disp(dstr),
      nafx(eval(posArray),eval(velArray),samp_freq,[posLim,velLim], ...
         funcNAFX,dblplot,tau_vers2);
      
   case 'settau'
      tau_surf_temp = tau_surface(tau_vers2);
      tau_temp = tau_surf_temp(velLimVal, posLimVal);
      h.tauNAFXH.String = num2str(tau_temp);
      
      
   case 'done'
      nafxtemp = nafxFig.Position;
      nafxXPos = nafxtemp(1);
      nafxYPos = nafxtemp(2);
      close(nafxFig)
      oldpath=pwd;
      cd(findomprefs);
      if exist('posArray','var') && exist('velArray','var')
         save nafxprefs.mat nafxXPos nafxYPos posArray velArray ...
            posLim velLim dblplot age_range fovstat tau_vers2;
      end
      cd(oldpath)      
      
   otherwise
      
end

end %function