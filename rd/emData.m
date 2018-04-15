classdef emData
   % emData Contains necessary data for analyzing eye movements
   %   Detailed explanation goes here
   
   properties
      recmeth = '';   % IR, VID, COIL, RCOIL
      start_times = []; % if sharing common timebase w/external data samples
      filename = '';
      pathname = '';
      comments = '';
      chan_names = {};
      %iscalibrated=0;
      vframes = [];
      calibrations = [];
      samp_freq = 0; % uint?
      numsamps =  0; % ?, uint32?
      h_pix_z = 0; h_pix_deg = 0;
      v_pix_z = 0; v_pix_deg = 0;
      
      rh=struct( 'data',[], 'unfilt',[], 'vel',[], ...
         'channel','rh', 'chan_comment',[], ...
         'saccades',struct('paramtype',[],'sacclist',struct()),...
         'blink',   struct('paramtype',[],'blinklist',struct()),...
         'fixation',struct('paramtype',[],'fixlist', struct()) );
      lh=struct( 'data',[], 'unfilt',[], 'vel',[], ...
         'channel','lh', 'chan_comment',[], ...
         'saccades',struct('paramtype',[],'sacclist',struct()),...
         'blink',   struct('paramtype',[],'blinklist',struct()),...
         'fixation',struct('paramtype',[],'fixlist', struct()) );
      rv=struct( 'data',[], 'unfilt',[], 'vel',[], ...
         'channel','rv', 'chan_comment',[], ...
         'saccades',struct('paramtype',[],'sacclist',struct()),...
         'blink',   struct('paramtype',[],'blinklist',struct()),...
         'fixation',struct('paramtype',[],'fixlist', struct()) );
      lv=struct( 'data',[], 'unfilt',[], 'vel',[], ...
         'channel','lv', 'chan_comment',[], ...
         'saccades',struct('paramtype',[],'sacclist',struct()),...
         'blink',   struct('paramtype',[],'blinklist',struct()),...
         'fixation',struct('paramtype',[],'fixlist', struct()) );
      rt=struct( 'data',[], 'unfilt',[], 'vel',[], ...
         'channel','rt', 'chan_comment',[], ...
         'saccades',struct('paramtype',[],'sacclist',struct()),...
         'blink',   struct('paramtype',[],'blinklist',struct()),...
         'fixation',struct('paramtype',[],'fixlist', struct()) );
      lt=struct( 'data',[], 'unfilt',[], 'vel',[], ...
         'channel','lt', 'chan_comment',[], ...
         'saccades',struct('paramtype',[],'sacclist',struct()),...
         'blink',   struct('paramtype',[],'blinklist',struct()),...
         'fixation',struct('paramtype',[],'fixlist', struct()) );
      hh=struct('data',[], 'vel',[], 'channel','hh','chan_comment',[]);
      hv=struct('data',[], 'vel',[], 'channel','hv','chan_comment',[]);
      st=struct('data',[], 'vel',[], 'channel','st','chan_comment',[]);
      sv=struct('data',[], 'vel',[], 'channel','sv','chan_comment',[]);
      ds=struct('data',[], 'channel','ds','chan_comment',[]);
      tl=struct('data',[], 'channel','tl','chan_comment',[]);
      
      other = {};
   end
                                                        
   methods
      % export basic data to base workspace
      % save filled emData struct as .mat file
   end
   
end

