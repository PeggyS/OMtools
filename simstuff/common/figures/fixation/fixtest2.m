function fig = fixtest2()% This is the machine-generated representation of a Handle Graphics object% and its children.  Note that handle values may change when these objects% are re-created. This may cause problems with any callbacks written to% depend on the value of the handle at the time the object was saved.%% To reopen this object, just type the name of the M-file at the MATLAB% prompt. The M-file and its associated MAT-file must be on your path.load fixtest2h0 = figure('Name','fixtest2.m', ...	'Position',[296 390 560 420], ...	'Tag','hotWind');h1 = axes('Parent',h0, ...	'Box','on', ...	'CameraUpVector',[0 1 0], ...	'ColorOrder',mat0, ...	'FontSize',12, ...	'DefaulttextUnits','data');h2 = line('Parent',h1, ...	'Color',[0 0 1], ...	'XData',mat1, ...	'YData',mat2);h2 = line('Parent',h1, ...	'Color',[0 1 0], ...	'XData',mat3, ...	'YData',mat4);h2 = line('Parent',h1, ...	'Color',[1 0 0], ...	'XData',mat5, ...	'YData',mat6);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',mat7, ...	'String','Fixbed test: "gaussian" gain = 0.5; mu = -0.25', ...	'VerticalAlignment','bottom');set(get(h2,'Parent'),'Title',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[1.995381062355658 -5.791788856304986 17.32050807568877], ...	'String','Time (sec)', ...	'VerticalAlignment','cap');set(get(h2,'Parent'),'XLabel',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[-0.2032332563510393 2.434017595307916 17.32050807568877], ...	'Rotation',90, ...	'String','Eye Vel (blue,green); Eye Pos (red)', ...	'VerticalAlignment','baseline');set(get(h2,'Parent'),'YLabel',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','right', ...	'Position',[-0.674364896073903 11.31964809384164 17.32050807568877], ...	'Visible','off');set(get(h2,'Parent'),'ZLabel',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'Position',mat8, ...	'String','r: pos err', ...	'VerticalAlignment','baseline');h2 = text('Parent',h1, ...	'FontSize',12, ...	'Position',[1.179723502304147 -4.210526315789475 0], ...	'String','b: vel err', ...	'VerticalAlignment','baseline');h2 = text('Parent',h1, ...	'FontSize',12, ...	'Position',[1.6036866359447 -1.447368421052633 0], ...	'String','g: reduced vel err', ...	'VerticalAlignment','baseline');if nargout > 0, fig = h0; end