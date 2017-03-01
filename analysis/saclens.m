% saclens.m:  plot the length of the saccade vs the time to reach% peak for the following slow phase.  Then plot saccade size vs % position excursion of the following slow phase (distance from % the end of the saccade to the peak of the slow phase).% written by:  Jonathan Jacobs%              October 1995 - April 1996  (last mod: 04/29/96)% we will go through the control point lists, a column at% a time, extracting the real points from the NaNs. % The stripped column is then used to index into the proper% column of the position data array.  The points are concatenated% into vectors (love that transpose operator) and displayed.%clear sac_dur peak_dur sac_dist peak_dist %% Broken in ML5!%clear on_v_list off_v_list slow_list%clear sac_dist peak_distsac_dur=[];   peak_dur=[];sac_dist=[];  peak_dist=[];on_v_list=[]; off_v_list=[]; slow_list=[];sac_dist=[];  peak_dist=[];if ~exist( 'sacp_on_mat' )   disp( 'You need to run "pickdata" first.' )   returnend[nRows, nCols] = size( sacv_on_mat );for z = 1:nCols   % whack out the 'NaNs'   num_pts = length( find( sacv_on_mat(:,z) < 100000 ) );   % concatenate the list of 'on' points   this_sacv_on = sacv_on_mat( 1:num_pts,z );   this_sacp_on = sacp_on_mat( 1:num_pts,z );   on_v_list    = [ on_v_list' this_sacv_on' ]';   % concatenate the list of 'off' points   this_sacv_off = sacv_off_mat( 1:num_pts,z );   this_sacp_off = sacp_off_mat( 1:num_pts,z );   off_v_list    = [ off_v_list' this_sacv_off' ]';   % calculate the duration of the saccade (2 posssible definitions)   % calculate & concatenate the list of saccade magnitudes (2 defs)   this_sac_dist  = pos(this_sacp_on,z) - pos(this_sacp_off,z);   sac_dist = [ sac_dist' this_sac_dist' ]';    % concatenate the list of 'slow_peak' points   this_slow_peak = slow_peak_mat( 1:num_pts,z );   slow_list = [ slow_list' this_slow_peak' ]';   % calculate & concatenate the list of slow_peak sizes   this_peak_dist = pos(this_slow_peak,z) - pos(this_sacp_off,z);   peak_dist = [ peak_dist' this_peak_dist' ]';end% this is easier since we aren't indexing into another array% with these points, as we did above. sac_dur  = 1000 * (off_v_list - on_v_list) / samp_freq;peak_dur = 1000 * (slow_list - off_v_list) / samp_freq;% now let's plot these suckers% set graph axis limits% the time calculations...x_limh_t = max( sac_dur ) + 1;x_liml_t = min( sac_dur ) - 1;y_limh_t = max( peak_dur ) + 1;y_liml_t = min( peak_dur ) - 1;% the position calculations...x_limh_p = max( sac_dist ) + 1;x_liml_p = min( sac_dist ) - 1;y_limh_p = max( peak_dist ) + 1;y_liml_p = min( peak_dist ) - 1;figure('Name','Saccade lengths','NumberT','off');orient landscapesubplot(2,1,1)plot( sac_dur, peak_dur, '.')axis( [x_liml_t x_limh_t y_liml_t y_limh_t])if length(what_f_names) > 65   [num, width] = size(what_files);   title( [num2str(num) ' files loaded.'] ) else   title(what_f_names)endxlabel('saccade duration (msec)')ylabel('time to peak (msec)')subplot(2,1,2)plot( sac_dist, peak_dist, '.')axis( [x_liml_p x_limh_p y_liml_p y_limh_p])xlabel('saccade distance (deg)')ylabel('peak excursion (deg)')%yorn = input( 'Plot saccade magnitude vs. duration? ', 's');%if (yorn == 'y') | (yorn == 'Y')if (0)   figure   plot( sac_dur, sac_dist, '.')   axis( [x_liml_t x_limh_t y_liml_p y_limh_p])   if length(what_f_names) > 65      [num, width] = size(what_files);      title( [num2str(num) ' files loaded.'] )    else      title(what_f_names)   end   xlabel('saccade duration (msec)')   ylabel('saccade distance (deg)')endif ~exist('debugme') debugme = 0; endif ~debugme   clear nRows nCols num_pts z yorn   clear this_peak_dist this_sac_dist   clear this_sacv_on this_sacv_off this_slow_peak   clear this_sacp_on this_sacp_off    clear x_limh_p x_liml_p x_limh_t x_liml_t    clear y_limh_p y_liml_p y_limh_t y_liml_t    clear on_v_list off_v_list slow_list   clear sac_dur sac_dist peak_dur peak_distend