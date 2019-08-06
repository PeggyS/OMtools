% led_recon.m: plot the digital stim information% Usage: led_stim = led_recon(digdata,doplot)%  digdata is created in base workspace by running 'rd' or 'datstat' (rd_dig)%  if doplot = 1, LED stim will be overplotted on frontmost figure%  led_stim.x_pos contains LED position%  led_stim.time  contains time vector%  led_stim.laser shows when laser target was turned on%% written by: Jonathan Jacobs%             December 2018  (last mod: 12/07/18)function led_stim = led_recon(digdata,doplot)global samp_freqif nargin<2, doplot=0; endif isempty(digdata);led_stim=[];return;endwhichLED  = digdata.whichLED;LEDangles = digdata.LEDangles;laser_on  = digdata.laser_on;t_stim    = digdata.stimtime;  % milliseconds from start of recordind = fix(samp_freq * t_stim/1000);for i=2:length(ind)-1 % 1st entry is extra zero   start = ind(i)+1;   stop  = ind(i+1);   tseg  = start:stop;   led_stim.x_pos(tseg) =  LEDangles(whichLED(i)) * ones(length(tseg),1);   led_stim.laser(tseg) =  laser_on(i) * ones(length(tseg),1);endled_stim.time = maket(led_stim.x_pos);if doplot   aa = length(t_stim)*2-1;      xx(1:2:aa)   = t_stim/1000;         % odd indices   xx(2:2:aa-1) = t_stim(2:end)/1000;  % even indices   yy(1:2:aa)   = whichLED;   yy(2:2:aa-1) = whichLED(1:end-1);      %figure   dp=plot(xx,LEDangles(yy),'md-');   set(dp,'markerfacecolor','g')   set(dp,'markeredgecolor','w')   set(dp,'MarkerSize',4)   set(dp,'LineWidth',0.75)end