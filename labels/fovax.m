% fovax.m: add axes that cross at the origin.function fovax(color)if nargin == 0  color = [1.0 0.25 0.0];endga=gca;ylim = get(ga,'Ylim');xlim = get(ga,'Xlim');line1H=line([xlim(1) xlim(2) NaN  0  0],...            [0 0 NaN [ylim(1) ylim(2)]]);%line1H=line([xlim(1) xlim(2)], [0 0]);%line2H=line([], [ylim(1) ylim(2)]);set(line1H,'color',color)%set(line2H,'color',color)