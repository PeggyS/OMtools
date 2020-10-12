% centerOnWindow: Calculate new position to center 'thisFig' on top of
% 'trgtFig'. Will try to move 'thisFig' if possible.
% Usage:  newThisPos=centerOnWindow(thisFig,trgtFig)
% Inputs: thisFig,trgtFig can either be window handles or 
%         position vectors [x_orig y_orig width height]
% Output: newThisPos is a position vector.     

% Written by: Jonathan Jacobs
% September 2020  (last mod: 30 Sep 20)

function newThisPos=centerOnWindow(thisFig,trgtFig)

if nargin~=2
   disp('Usage: newPos=centerOnWindow(thisFig,tgtFig)')
   return
end

try    trgtPos=trgtFig.Position;
catch, trgtPos=trgtFig; end
try    thisPos=thisFig.Position;
catch, thisPos=thisFig; end

trgtCenter = [trgtPos(1)+trgtPos(3)/2, trgtPos(2)+trgtPos(4)/2];

newThisOrigin = [trgtCenter(1)-thisPos(3)/2, trgtCenter(2)-thisPos(4)/2];
newThisPos    = [newThisOrigin, thisPos(3),thisPos(4)];

try    thisFig.Position = newThisPos;
catch, end

if nargout==0
   clear newThisPos; 
end

