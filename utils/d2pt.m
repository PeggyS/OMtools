% d2pt.m:  differentiate & filter input_val to get velocity% This is equivalent to ASYST's "2ptd1"% This version can deal with data arrays of multiple columns.% The columns of the result matrix are the differentiation of the% columns of the input matrix.  Usage:  b = d2pt(a, order, fs);% (e.g., rhv = d2pt(rh, 1, samp_freq);% written by: Jonathan Jacobs%             September 1995 - October 2003  (last mod: 10/27/03)function [ diff_val ] = d2pt( input_val, cutoff, samp_temp )global samp_freq %filename namelist what_f_names sac_on[comp, ~] = computer;if strcmp(comp(1), 'M')   BS = char(8); else   BS = '';endif nargin == 0   disp( ' ' )   disp( 'Sorry, but "d2pt" requires the name of a data array on ' )   disp( 'which to operate and (optionally) a filter order and (optionally)' )   disp( 'a sampling frequency (scalar or vector).  If no sampling frequency' )   disp( 'is supplied, d2pt will attempt to use the value in "samp_freq", and' )   disp( 'if necessary, will prompt you to input a value.' )   disp( ' ' )   disp( '   Example: "rhv = d2pt(rh,1);" will use a very high lowpass,' )   disp( '   which will give the least filtering:  f_cut ~ 1/4 f_samp, ' )   disp( '   whereas using a cutoff of 2 will give f_cut ~ 1/8 f_samp, ' )   disp( '   and using a cutoff of 3 will give f_cut ~ 1/16 f_samp. ' )   disp( '   You can choose as high a filter order as you''d like, but remember' )   disp( '   that the filtering will get more and more extreme.' )    disp( '   When in doubt, try choice "1" first.' )   disp( ' ' )   returnend[numRows, numCols] = size( input_val );if nargin == 3, samp_freq = samp_temp; end%if nargin < 3, samp_temp = samp_freq; endif nargin < 2, cutoff = []; end%if isempty('samp_freq'), samp_freq = samp_temp; endif (isempty(samp_freq)) || (samp_freq == 0)   samp_freq = input('What is the sampling frequency? '); else   %disp( ['Sampling frequency: ' mat2str(fix(samp_f_vect)) 'Hz.'] );endsamp_f_vect = samp_freq*ones(min(numRows,numCols),1);diff_factor = 0.44294647;  % value from "2ptdiff.ast". has to do with                           % z_transform mapping stuff.if (nargin == 1) || (isempty(cutoff)) % only the target array given   disp( ' ' )   disp( 'Choose your low-pass cutoff frequency:' );   disp(  '  -1) Cancel.  (No differentiation.)' );   disp(  '   0) Differentiate with no filtering.' );   disp([ '   1) ' mat2str(samp_f_vect/2 * diff_factor) 'Hz.' ]);   disp([ '   2) ' mat2str(samp_f_vect/4 * diff_factor) 'Hz.' ]);   disp([ '   3) ' mat2str(samp_f_vect/8 * diff_factor) 'Hz.' ]);   disp(  '       ...etc...' )    disp(' ')   cutoff = -1000;   while (cutoff < -1) || (cutoff > 10)      cutoff = input( [BS '--> ']);   endend[nRows, nCols] = size(input_val);if (nRows == 1)                   % make sure we are dealing with columnar   input_val = input_val';        % data ("vertically oriented")   temp = nRows;                  % swap nRows and nCols   nRows = nCols;   nCols = temp;end% equivalent (and MUCH slower) code:%up_lim = nRows - 2;                % we can go only from 3 to len-2, since                                    % the filter uses two pts below and                                    % two points  above the nth pt.% for i = 3: up_lim,%   diff_val(i) = ( input_val(i+2) - input_val(i-2) ) * samp_f_vect/4.;% end% calc result (except for extremals) with a one line difference eqn.diff_val = NaN*ones( nRows, nCols );   %initialize diff_valif cutoff == -1   disp( 'd2pt: no differentiation performed.' )   return elseif cutoff == 0   for i = 1:nCols      temp_diff = diff(input_val(:,i));      diff_len = length(temp_diff);      temp_diff = [temp_diff'   temp_diff(diff_len)]';      diff_val(1:nRows,i) = temp_diff * samp_f_vect(i);   end elseif cutoff >= 1   diff_val(cutoff+1:nRows-cutoff,:) = input_val((2*cutoff)+1:nRows,:)...                                     - input_val(1:nRows-(2*cutoff),:);   for i = 1:nCols      diff_val(:,i) = diff_val(:,i) * samp_f_vect(i)/(2*cutoff);   end  else   disp( 'Invalid choice for cutoff.' )   disp( 'No differentiation performed.' )end% now do the extremals% the beginning values are easy...if cutoff == 0   diff_val(length(input_val),:) = diff_val(length(input_val)-1,:); elseif cutoff >= 1   for i=1:cutoff      diff_val(i,:) = diff_val(cutoff+1,:);   endend% ...but the end values are trickier since the data sets were probably% different lengths before they were padded with NaNslastdata = zeros(nCols,1);for i=1:nCols   lastdata(i) = length(find(isfinite(input_val(:,i))));   if cutoff >= 1      for j=0:cutoff-1	         diff_val(lastdata(i)-j,i) = diff_val(lastdata(i)-cutoff,i);      end   endend% find longest data set%maxpts = max(lastdata); % let's take a guess at what sort of data we are dealing with,% velocity or acceleration.  Make an assumption that max velocity% will never exceed 3000 deg/sec.  The result will be used to set% axis limits and labels.% data_max = max(stripnan(diff_val));% if data_max < 3000                   % most likely to be velocity%    win_lim = 4.0*ones(maxpts,1);%    y_labl  = 'velocity (deg/sec)';%  else%    win_lim = 1000*ones(maxpts,1);    % so this is probably acceleration%    y_labl  = 'acceleration (deg/sec^2)';% end% % % let's make a snazzy graph...% if (0)%    figure;%    plot( diff_val(1:maxpts,:) )%    hold on%    plot( zeros(maxpts,1), 'c' );   % slip window from%    plot(  win_lim, 'c:' );        % -4 to +4 deg/sec (vol) or%    plot( -win_lim, 'c:' );        % ?? to ?? deg/s^2 (accel)%    xlabel( 'sample number' )%    ylabel( y_labl )%    if ~exist('what_f_names')%       title(namelist)%     else%       title(what_f_names)%    end%    hold off%    drawnow% end