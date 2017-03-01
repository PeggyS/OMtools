% stripbad.m:  remove the 'bad' pts from an x and a y vector.% written by:  Jonathan Jacobs%              May 1996 (last mod: 05/20/96)function [new_x, new_y] = stripbad( x, y, bad )% if we only give 2 arguments, then they are assumed to be the% data vector and the bad points list.if nargin < 2   disp( 'stripbad requires at least a data vector and a bad points list') elseif nargin == 2   bad = y;   y = x;end% make sure the inputs are good[rX, cX] = size(x);lenX = max(rX, cX);if (rX ~= 1) & (cX ~= 1)   disp( 'stripbad: x input must be a n by 1 (or 1 by n) vector' )   returnend[rY, cY] = size(y);lenY = max(rY, cY);if (rY ~= 1) & (cY ~= 1)   disp( 'stripbad: y input must be a n by 1 (or 1 by n) vector' )   returnendif lenX ~= lenY   disp( 'stripbad: x and y vectors must have the same length' )   returnend% clean up the 'bad' list if needed.  we want it to be in ascending% order and not to have entries that go beyond the length of the% target vectors.bad = sort(bad);bad = bad(find(bad>0));bad = bad(find(bad<=lenX));[rBad, cBad] = size(bad);        % make it a row vectorif cBad == 1   bad = bad';endbad = [bad, lenX+1];    % so we can get the last segment% we'll make x and y row vectors for now.if cX == 1   x = x';   xtrans = 1;  % flag so we can untranspose the final resultendif cY == 1   y = y';   ytrans = 1;  % flag so we can untranspose the final resultend% time to start strippingnew_x = []; new_y = [];lastgoodpt = 1;for i = 1:length(bad)   new_x = [ new_x, x(lastgoodpt:bad(i)-1) ];    new_y = [ new_y, y(lastgoodpt:bad(i)-1) ];    lastgoodpt = bad(i)+1;end% reflip new_x, new_y if necessaryif xtrans == 1   new_x = new_x';endif ytrans == 1   new_y = new_y';enddisp( [ num2str(length(new_x)) ' (x,y) points remain.'] )