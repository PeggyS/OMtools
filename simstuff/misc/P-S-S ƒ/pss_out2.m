function fig = pss_out2()% This is the machine-generated representation of a Handle Graphics object% and its children.  Note that handle values may change when these objects% are re-created. This may cause problems with any callbacks written to% depend on the value of the handle at the time the object was saved.%% To reopen this object, just type the name of the M-file at the MATLAB% prompt. The M-file and its associated MAT-file must be on your path.load pss_out2h0 = figure('Position',[219 124 633 454], ...	'Tag','hotWind');h1 = axes('Parent',h0, ...	'Box','on', ...	'CameraUpVector',[0 1 0], ...	'ColorOrder',mat0, ...	'FontSize',12, ...	'NextPlot','add', ...	'XGrid','on', ...	'XTick',mat1, ...	'XTickMode','manual', ...	'YGrid','on', ...	'ZGrid','on', ...	'ZTick',[-1 0 1], ...	'ZTickMode','manual');h2 = line('Parent',h1, ...	'Color',[1 1 0], ...	'XData',mat2, ...	'YData',mat3);h2 = line('Parent',h1, ...	'Color',[1 1 0], ...	'XData',mat4, ...	'YData',mat5);h2 = line('Parent',h1, ...	'Color',[1 1 0], ...	'XData',mat6, ...	'YData',mat7);h2 = line('Parent',h1, ...	'Color',[1 1 0], ...	'XData',mat8, ...	'YData',mat9);h2 = line('Parent',h1, ...	'Color',[1 1 0], ...	'XData',mat10, ...	'YData',mat11);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[0.997955010224949 5.081300813008131 17.32050807568877], ...	'String','pls\_sld\_stp.mdl -- 1� to 5� saccades', ...	'VerticalAlignment','bottom');set(get(h2,'Parent'),'Title',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',mat12, ...	'String','Time (sec)', ...	'VerticalAlignment','cap');set(get(h2,'Parent'),'XLabel',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[-0.07361963190184051 1.975609756097561 17.32050807568877], ...	'Rotation',90, ...	'String','Eye Position (deg)', ...	'VerticalAlignment','baseline');set(get(h2,'Parent'),'YLabel',h2);h2 = text('Parent',h1, ...	'FontSize',12, ...	'HandleVisibility','off', ...	'HorizontalAlignment','right', ...	'Position',[-0.3394683026584868 5.536585365853659 17.32050807568877], ...	'Visible','off');set(get(h2,'Parent'),'ZLabel',h2);if nargout > 0, fig = h0; end