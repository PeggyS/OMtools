% mainseq.m: Plot max. velocity of saccade vs amplitude.%            Plot saccade duration vs amplitdue.% written by:  Jonathan Jacobs%              January 1996 - November 2000  (last mod: 11/15/00)% We will go through the control point lists, a column at a time, % extracting the real points from the NaNs.  The stripped % column is then used to index into the proper column of % the position or velocity data array.  The points are concatenated% into vectors (love that transpose operator) and plotted.saci_dist=[]; sacp_dist=[]; sacf_dist=[]; true_max_vel1=[]; true_max_vel2=[];true_max_vel3=[]; norm_max_vel=[];sacv_dur=[]; sacp_dur=[]; init_eye_vel=[];sacv1_dist=[]; sacv2_dist=[];if ~exist( 'sacp_on_mat')   disp( 'You need to run "pickdata" first.' )   returnend[nRows, nCols] = size( sacp_on_mat );for z = 1:nCols   % whack out the 'NaNs'   num_pts = length( find(sacp_on_mat(:,z) < 100000) );   % extract the list of 'on' points   this_sacv_on = sacv_on_mat( 1:num_pts,z );   this_sacp_on = sacp_on_mat( 1:num_pts,z );   % extract the list of 'off' points   this_sacv_off = sacv_off_mat( 1:num_pts,z );   this_sacp_off = sacp_off_mat( 1:num_pts,z );   %calculate and concatenate the saccade duaration   this_samp_freq = samp_f_mat(z);   this_sacv_dur = 1000 * (this_sacv_off - this_sacv_on) / this_samp_freq;   this_sacp_dur = 1000 * (this_sacp_off - this_sacp_on) / this_samp_freq;   sacv_dur = [ sacv_dur' this_sacv_dur' ]';   sacp_dur = [ sacp_dur' this_sacp_dur' ]';   % extract the list of 'max_vel' points   this_max_v_pt = max_v_pt_mat( 1:num_pts,z );   % calculate and concatenate the saccade mag and max velocity   this_saci_dist = abs( pos(this_sacp_on,z) - pos(this_sacv_on,z) );   this_sacp_dist = abs( pos(this_sacp_on,z) - pos(this_sacp_off,z) );   this_sacf_dist = abs( pos(this_sacv_off,z) - pos(this_sacp_off,z) );   this_base_eye_vel1 = vel(this_sacv_on,z);   this_base_eye_vel2 = vel(this_sacv_off,z);   this_base_eye_vel3 = (vel(this_sacv_on,z)+vel(this_sacv_off,z))/2;   this_norm_max_vel = vel(this_max_v_pt,z);   this_true_max_vel1 = abs( this_base_eye_vel1 - this_norm_max_vel );   this_true_max_vel2 = abs( this_base_eye_vel2 - this_norm_max_vel );   this_true_max_vel3 = abs( this_base_eye_vel3 - this_norm_max_vel );      %take abs for plotting purposes. (needed signed vals for calcs.)   this_norm_max_vel  = abs(this_norm_max_vel);   saci_dist = [ saci_dist' this_saci_dist' ]';   sacp_dist = [ sacp_dist' this_sacp_dist' ]';   sacf_dist = [ sacf_dist' this_sacf_dist' ]';   norm_max_vel  = [ norm_max_vel'   this_norm_max_vel'  ]';   true_max_vel1 = [ true_max_vel1'  this_true_max_vel1'  ]';   true_max_vel2 = [ true_max_vel2'  this_true_max_vel2'  ]';   true_max_vel3 = [ true_max_vel3'  this_true_max_vel3'  ]';endsacv1_dist = saci_dist + sacp_dist;sacv2_dist = saci_dist + sacp_dist + sacf_dist;% now let's plot these suckers% generate main sequence lines for comparisonmax_ampl = 1.25 * max(sacv2_dist);ampl_vec = 0:0.1:max_ampl;dur_yar = (ampl_vec .^ 0.4)  * 21;dur_bah = (ampl_vec .^ 0.15) * 26;if length(what_f_names) > 65   [num, width] = size(what_files);   files_str = [num2str(num) ' files']; else   files_str = what_f_names;endfigure('Name','Peak Vel vs Amplitude','NumberTitle','off');orient portraitsubplot(4,3,1)plot( sacp_dist, norm_max_vel, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinestitle([files_str])ylabel('Unmod. Peak Vel. (�/sec)')subplot(4,3,2)plot( sacv1_dist, norm_max_vel, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinessubplot(4,3,3)plot( sacv2_dist, norm_max_vel, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinessubplot(4,3,4)plot( sacp_dist, true_max_vel1, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinesylabel('Mod. PV 1 (�/sec)')subplot(4,3,5)plot( sacv1_dist, true_max_vel1, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinessubplot(4,3,6)plot( sacv2_dist, true_max_vel1, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinessubplot(4,3,7)plot( sacp_dist, true_max_vel2, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinesylabel('Mod. PV 2 (�/sec)')subplot(4,3,8)plot( sacv1_dist, true_max_vel2, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinessubplot(4,3,9)plot( sacv2_dist, true_max_vel2, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinessubplot(4,3,10)plot( sacp_dist, true_max_vel3, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinesxlabel('Unmod. Sacc. Size (�)')ylabel('Mod. PV 3 (�/sec)')subplot(4,3,11)plot( sacv1_dist, true_max_vel3, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinesxlabel('Mod. 1 (�)')subplot(4,3,12)plot( sacv2_dist, true_max_vel3, 'r.')hold on; box onset(gca,'Xlim',[0 max_ampl]);pvlinesxlabel('Mod. 2 (�)')%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%if length(what_f_names) > 65   [num, width] = size(what_files);   files_str = [num2str(num) ' files']; else   files_str = what_f_names;endfigure('Name','Duration vs Amplitude','NumberTitle','off');orient portraitsubplot(2,3,1)plot( sacp_dist, sacp_dur, 'r.')title([files_str])hold onmax_y = max( max(sacp_dur), max(dur_yar) );plot(ampl_vec, dur_yar,  'c')%plot(ampl_vec, dur_bah, 'b')axis([0, max_ampl, 0, 1.2*max_y])hold offylabel('Sacc. Dur. (msec) [pdcp]')subplot(2,3,2)plot( sacv1_dist, sacp_dur, 'r.')hold onmax_y = max( max(sacp_dur), max(dur_bah) );plot(ampl_vec, dur_yar,  'c')%plot(ampl_vec, dur_bah, 'b')axis([0, max_ampl, 0, 1.2*max_y])hold offsubplot(2,3,3)plot( sacv2_dist, sacp_dur, 'r.')hold onmax_y = max( max(sacp_dur), max(dur_bah) );plot(ampl_vec, dur_yar,  'c')%plot(ampl_vec, dur_bah, 'b')axis([0, max_ampl, 0, 1.2*max_y])hold offsubplot(2,3,4)plot( sacp_dist, sacv_dur, 'r.')hold onmax_y = max( max(sacv_dur), max(dur_bah) );plot(ampl_vec, dur_yar,  'c')%plot(ampl_vec, dur_bah, 'b')axis([0, max_ampl, 0, 1.2*max_y])hold offxlabel('Unmod. Sacc. Size (�)')ylabel('Sacc. Dur. (msec) [vdcp]')subplot(2,3,5)plot( sacv1_dist, sacv_dur, 'r.')hold onmax_y = max( max(sacv_dur), max(dur_bah) );plot(ampl_vec, dur_yar,  'c')%plot(ampl_vec, dur_bah, 'b')axis([0, max_ampl, 0, 1.2*max_y])hold offxlabel('Modification 1 (�)')subplot(2,3,6)plot( sacv2_dist, sacv_dur, 'r.')hold onmax_y = max( max(sacv_dur), max(dur_bah) );plot(ampl_vec, dur_yar,  'c')%plot(ampl_vec, dur_bah, 'b')axis([0, max_ampl, 0, 1.2*max_y])hold offxlabel('Modification 2 (�)')%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%if ~exist('export') export = 0; endif export   clear mainseqmat stdline   expdir   mainseqmat(:,1) = sacp_dist;   mainseqmat(:,2) = sacv1_dist;   mainseqmat(:,3) = sacv2_dist;   mainseqmat(:,4) = sacp_dur;   mainseqmat(:,5) = sacv_dur;   mainseqmat(:,6) = norm_max_vel;   mainseqmat(:,7) = true_max_vel;      stdline(:,1) = ampl_vec';   stdline(:,2) = dur_yar';   stdline(:,3) = dur_bah';   stdline(:,4) = PV_Bah';   stdline(:,5) = PV_ZS';   save mainseq.txt mainseqmat -ascii   save stdline.txt stdline -ascii   omdirend%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%if ~exist('debugme') debugme = 0; endif ~debugme   clear nRows nCols num_pts z when when_sec title_str files_str   clear this_saci_dist this_sacp_dist this_sacf_dist   clear this_max_vel true_max_vel norm_mav_vel this_max_v_pt   clear sacv_dur this_sacv_dur sacp_dur this_sacp_dur this_samp_freq   clear this_sacv_on this_sacv_off this_sacp_on this_sacp_off   clear saci_dist sacp_dist sacf_dist sacv1_dist sacv2_dist   clear init_eye_vel   clear PV_ZS PV_Bah dur_yar dur_bah max_yend