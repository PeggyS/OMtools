function fig = pfs_fix1()% This is the machine-generated representation of a Handle Graphics object% and its children.  Note that handle values may change when these objects% are re-created. This may cause problems with any callbacks written to% depend on the value of the handle at the time the object was saved.%% To reopen this object, just type the name of the M-file at the MATLAB% prompt. The M-file and its associated MAT-file must be on your path.load pfs_fix1h0 = figure('Position',[296 390 560 420], ...	'Tag','hotWind');h1 = axes('Parent',h0, ...	'Box','on', ...	'CameraUpVector',[0 1 0], ...	'ColorOrder',mat0, ...	'FontSize',12);h2 = line('Parent',h1, ...	'Color',[1 1 0], ...	'XData',mat1, ...	'YData',mat2);h2 = line('Parent',h1, ...	'Color',[1 0 1], ...	'XData',mat3, ...	'YData',mat4);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[1.995381062355658 2.131964809384165 17.32050807568877], ...	'String','Param set: Pfs.mat   Fixation system enabled.', ...	'VerticalAlignment','bottom');set(get(h2,'Parent'),'Title',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[1.995381062355658 -7.475073313782991 17.32050807568877], ...	'String','Time (sec)', ...	'VerticalAlignment','cap');set(get(h2,'Parent'),'XLabel',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[-0.1662817551963048 -2.539589442815249 17.32050807568877], ...	'Rotation',90, ...	'String','Eye Position (deg)', ...	'VerticalAlignment','baseline');set(get(h2,'Parent'),'YLabel',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','right', ...	'Position',[-0.674364896073903 2.791788856304986 17.32050807568877], ...	'Visible','off');set(get(h2,'Parent'),'ZLabel',h2);if nargout > 0, fig = h0; end