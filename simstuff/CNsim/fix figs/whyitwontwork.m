function fig = whyitwontwork()% This is the machine-generated representation of a Handle Graphics object% and its children.  Note that handle values may change when these objects% are re-created. This may cause problems with any callbacks written to% depend on the value of the handle at the time the object was saved.%% To reopen this object, just type the name of the M-file at the MATLAB% prompt. The M-file and its associated MAT-file must be on your path.load whyitwontworkh0 = figure('Position',[296 390 560 420], ...	'Tag','hotWind');h1 = axes('Parent',h0, ...	'Box','on', ...	'CameraUpVector',[0 1 0], ...	'ColorOrder',mat0, ...	'FontSize',12, ...	'NextPlot','add');h2 = line('Parent',h1, ...	'Color',[0 1 0], ...	'XData',mat1, ...	'YData',mat2);h2 = line('Parent',h1, ...	'Color',[1 0 0], ...	'XData',mat3, ...	'YData',mat4);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[0.997690531177829 -8.844574780058654 17.32050807568877], ...	'VerticalAlignment','cap');set(get(h2,'Parent'),'XLabel',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[-0.08314087759815242 -0.07038123167155597 17.32050807568877], ...	'Rotation',90, ...	'VerticalAlignment','baseline');set(get(h2,'Parent'),'YLabel',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','right', ...	'Position',[-0.3371824480369515 9.407624633431084 17.32050807568877], ...	'Visible','off');set(get(h2,'Parent'),'ZLabel',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[0.997690531177829 8.234604105571847 17.32050807568877], ...	'String','ps30: g,  out: r', ...	'VerticalAlignment','bottom');set(get(h2,'Parent'),'Title',h2);if nargout > 0, fig = h0; end