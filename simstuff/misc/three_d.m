function fig = three_d()% This is the machine-generated representation of a Handle Graphics object% and its children.  Note that handle values may change when these objects% are re-created. This may cause problems with any callbacks written to% depend on the value of the handle at the time the object was saved.%% To reopen this object, just type the name of the M-file at the MATLAB% prompt. The M-file and its associated MAT-file must be on your path.load three_dh0 = figure('Name','three_d.m', ...	'Position',[296 390 560 420], ...	'Renderer','zbuffer', ...	'Tag','hotWind');h1 = axes('Parent',h0, ...	'View',[-37.5 30], ...	'CameraUpVector',[0 0 1], ...	'ColorOrder',mat0, ...	'NextPlot','add', ...	'XLim',[0 20], ...	'XLimMode','manual', ...	'YLim',[-50 0], ...	'YLimMode','manual', ...	'ZLim',[0 20], ...	'ZLimMode','manual');h2 = line('Parent',h1, ...	'Color',[1 1 0], ...	'Marker','^', ...	'MarkerFaceColor',[1 1 1], ...	'XData',mat1, ...	'YData',mat2, ...	'ZData',mat3);h2 = line('Parent',h1, ...	'Color',[1 0 1], ...	'Marker','diamond', ...	'MarkerFaceColor',[0.75 0.75 0.75], ...	'XData',mat4, ...	'YData',mat5, ...	'ZData',mat6);h2 = line('Parent',h1, ...	'Color',[0 1 1], ...	'Marker','square', ...	'MarkerFaceColor',[0 0 1], ...	'XData',mat7, ...	'YData',mat8, ...	'ZData',mat9);h2 = line('Parent',h1, ...	'Color',[1 0 0], ...	'Marker','o', ...	'MarkerFaceColor',[1 0.5 0], ...	'XData',mat10, ...	'YData',mat11, ...	'ZData',mat12);h2 = text('Parent',h1, ...	'HandleVisibility','off', ...	'Position',[-82.28375039210884 -347.0762019656161 82.07603805629111], ...	'String','X axis', ...	'VerticalAlignment','top');set(get(h2,'Parent'),'XLabel',h2);h2 = text('Parent',h1, ...	'HandleVisibility','off', ...	'HorizontalAlignment','right', ...	'Position',[-92.77948705134226 -326.217976361797 82.4740244212816], ...	'String','Y axis', ...	'VerticalAlignment','top');set(get(h2,'Parent'),'YLabel',h2);h2 = text('Parent',h1, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',[-93.45666200668666 -297.8386989841347 97.35871447192579], ...	'Rotation',90, ...	'String','Z axis', ...	'VerticalAlignment','baseline');set(get(h2,'Parent'),'ZLabel',h2);h2 = text('Parent',h1, ...	'HandleVisibility','off', ...	'HorizontalAlignment','center', ...	'Position',mat13, ...	'VerticalAlignment','bottom');set(get(h2,'Parent'),'Title',h2);h2 = surface('Parent',h1, ...	'CData',mat14, ...	'EdgeColor',[0.05001907377737087 1 0.3190814068818189], ...	'EdgeLighting','flat', ...	'FaceColor','none', ...	'FaceLighting','none', ...	'VertexNormals',mat15, ...	'XData',mat16, ...	'YData',mat17, ...	'ZData',mat18);if nargout > 0, fig = h0; end