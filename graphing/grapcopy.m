% grapcopy.m: copy a graph's elements (lines, surfaces, patches, text)% into a new figure.  Both the source and destination axes must exist before% running this function.% Written by:  Jonathan Jacobs%              April 1998 - May 2000 (last mod: 05/25/00)function grapcopy(null)if isempty(get(0,'children'))   disp('   You must have a source axis and')   disp('   a destination axis open on the')   disp('   screen to use this function.')   returnendisML5=0;MLvers=version;if MLvers(1) >= '5'   isML5=1;endisML4=0;MLvers=version;if MLvers(1) == '4'   isML4=1;enddisp('Click on the graph you want to copy.')disp('When you have done so, hit ENTER')pausegSource=gca;chList = get(gSource,'Children');lenChList = length(chList);chList(lenChList+1)=get(gSource,'Title');chList(lenChList+2)=get(gSource,'Xlabel');chList(lenChList+3)=get(gSource,'YLabel');chList(lenChList+4)=get(gSource,'ZLabel');disp('Now select a set of axes for the new graph')disp('When you have done so, hit ENTER')pausegDest = gca;gDestFig = get(gDest,'Parent');if gDest == gSource   %disp('   Destination can not be the same as the source.')   %disp('   Make sure that you have more than one set of')   %disp('   axes available on the screen and try again.')   disp(' making new fig  ')   gDestFig = figure;   gDest = gca;   %returnenddoAxProps=1;% do the axis propertiesif doAxProps   temp = get(gSource,'Box');   set(gDest,'Box',temp);   temp = get(gSource,'CLim');   set(gDest,'CLim',temp);   temp = get(gSource,'CLimMode');   set(gDest,'CLimMode',temp);   temp = get(gSource,'Color');   set(gDest,'Color',temp);   temp = get(gSource,'ColorOrder');   set(gDest,'ColorOrder',temp);   temp = get(gSource,'DrawMode');   set(gDest,'DrawMode',temp);   temp = get(gSource,'FontAngle');   set(gDest,'FontAngle',temp);   temp = get(gSource,'FontName');   set(gDest,'FontName',temp);   temp = get(gSource,'FontSize');   set(gDest,'FontSize',temp);   temp = get(gSource,'FontWeight');   set(gDest,'FontWeight',temp);   temp = get(gSource,'GridLineStyle');   set(gDest,'GridLineStyle',temp);   temp = get(gSource,'LineStyleOrder');   set(gDest,'LineStyleOrder',temp);   temp = get(gSource,'LineWidth');   set(gDest,'LineWidth',temp);   %temp = get(gSource,'NextPlot');   %set(gDest,'NextPlot',temp);   %temp = get(gSource,'Position');   %set(gDest,'Position',temp);   temp = get(gSource,'TickLength');   set(gDest,'TickLength',temp);   temp = get(gSource,'TickDir');   set(gDest,'TickDir',temp);   temp = get(gSource,'Units');   set(gDest,'Units',temp);   temp = get(gSource,'View');   set(gDest,'View',temp);   temp = get(gSource,'XColor');   set(gDest,'XColor',temp);   temp = get(gSource,'XDir');   set(gDest,'XDir',temp);   temp = get(gSource,'XGrid');   set(gDest,'XGrid',temp);   temp = get(gSource,'XLim');   set(gDest,'XLim',temp);   %temp = get(gSource,'XLimMode');   %set(gDest,'XLimMode',temp);   temp = get(gSource,'XScale');   set(gDest,'XScale',temp);   temp = get(gSource,'XTick');   set(gDest,'XTick',temp);   %temp = get(gSource,'XTickLabelMode');   %set(gDest,'XTickLabelMode',temp);   %temp = get(gSource,'XTickMode');   %set(gDest,'XTickMode',temp);   temp = get(gSource,'YColor');   set(gDest,'YColor',temp);   temp = get(gSource,'YDir');   set(gDest,'YDir',temp);   temp = get(gSource,'YGrid');   set(gDest,'YGrid',temp);   temp = get(gSource,'YLim');   set(gDest,'YLim',temp);   %temp = get(gSource,'YLimMode');   %set(gDest,'YLimMode',temp);   temp = get(gSource,'YScale');   set(gDest,'YScale',temp);   temp = get(gSource,'YTick');   set(gDest,'YTick',temp);   %temp = get(gSource,'YTickLabelMode');   %set(gDest,'YTickLabelMode',temp);   %temp = get(gSource,'YTickMode');   %set(gDest,'YTickMode',temp);   temp = get(gSource,'ZColor');   set(gDest,'ZColor',temp);   temp = get(gSource,'ZDir');   set(gDest,'ZDir',temp);   temp = get(gSource,'ZGrid');   set(gDest,'ZGrid',temp);   temp = get(gSource,'ZLim');   set(gDest,'ZLim',temp);   %temp = get(gSource,'ZLimMode');   %set(gDest,'ZLimMode',temp);   temp = get(gSource,'ZScale');   set(gDest,'ZScale',temp);   temp = get(gSource,'ZTick');   set(gDest,'ZTick',temp);   %temp = get(gSource,'ZTickLabelMode');   %set(gDest,'ZTickLabelMode',temp);   %temp = get(gSource,'ZTickMode');   %set(gDest,'ZTickMode',temp);      if isML4      %temp = get(gSource,'AspectRatio');      %set(gDest,'AspectRatio',temp);      temp = get(gSource,'Xform');      set(gDest,'Xform',temp);      %temp = get(gSource,'XTickLabels');      %set(gDest,'XTickLabels',temp);      %temp = get(gSource,'YTickLabels');      %set(gDest,'YTickLabels',temp);      %temp = get(gSource,'ZTickLabels');      %set(gDest,'ZTickLabels',temp);   end      if isML5      temp = get(gSource,'AmbientLightColor');      set(gDest,'AmbientLightColor',temp);      temp = get(gSource,'CameraPosition');      set(gDest,'CameraPosition',temp);      temp = get(gSource,'CameraPositionMode');      set(gDest,'CameraPositionMode',temp);      temp = get(gSource,'CameraTarget');      set(gDest,'CameraTarget',temp);      temp = get(gSource,'CameraTargetMode');      set(gDest,'CameraTargetMode',temp);      temp = get(gSource,'CameraUpVector');      set(gDest,'CameraUpVector',temp);      temp = get(gSource,'CameraUpVectorMode');      set(gDest,'CameraUpVectorMode',temp);      temp = get(gSource,'CameraViewAngleMode');      set(gDest,'CameraViewAngleMode',temp);      %temp = get(gSource,'DataAspectRatio');      %set(gDest,'DataAspectRatio',temp);      temp = get(gSource,'DataAspectRatioMode');      set(gDest,'DataAspectRatioMode',temp);      temp = get(gSource,'FontUnits');      set(gDest,'FontUnits',temp);      temp = get(gSource,'Layer');      set(gDest,'Layer',temp);      temp = get(gSource,'PlotBoxAspectRatio');      set(gDest,'PlotBoxAspectRatio',temp);      temp = get(gSource,'PlotBoxAspectRatioMode');      set(gDest,'PlotBoxAspectRatioMode',temp);      temp = get(gSource,'Projection');      set(gDest,'Projection',temp);      temp = get(gSource,'TickDirMode');      set(gDest,'TickDirMode',temp);      temp = get(gSource,'XAxisLocation');      set(gDest,'XAxisLocation',temp);      temp = get(gSource,'YAxisLocation');      set(gDest,'YAxisLocation',temp);      %%%CameraViewAngle = [6.60861]%      temp = get(gSource,'XTickLabel');%      set(gDest,'XTickLabel',temp);%      temp = get(gSource,'YTickLabel');%      set(gDest,'YTickLabel',temp);%      temp = get(gSource,'ZTickLabel');%      set(gDest,'ZTickLabel',temp);   endend% do all the children object propertieslenChList = length(chList);for i=length(chList):-1:1   if strcmp(get(chList(i),'Type'),'line')       figure(gDestFig)       hold on       destH = line(0,0);       temp = get(chList(i),'XData');       if ~isempty(temp)         set(destH,'Xdata',temp);       end       temp = get(chList(i),'YData');       if ~isempty(temp)         set(destH,'Ydata',temp);       end       temp = get(chList(i),'ZData');       if ~isempty(temp)         set(destH,'Zdata',temp);       end       temp = get(chList(i),'Color');       set(destH,'Color',temp);       temp = get(chList(i),'EraseMode');       set(destH,'EraseMode',temp);       temp = get(chList(i),'LineStyle');       set(destH,'LineStyle',temp);       temp = get(chList(i),'LineWidth');       set(destH,'LineWidth',temp);       temp = get(chList(i),'MarkerSize');       set(destH,'MarkerSize',temp);       if isML5          temp = get(chList(i),'Marker');          set(destH,'Marker',temp);          temp = get(chList(i),'MarkerEdgeColor');          set(destH,'MarkerEdgeColor',temp);          temp = get(chList(i),'MarkerFaceColor');          set(destH,'MarkerFaceColor',temp);       end    elseif strcmp(get(chList(i),'Type'),'patch')       figure(gDestFig)       hold on       destH = patch(0,0,0);       temp = get(chList(i),'XData');       if ~isempty(temp)         set(destH,'Xdata',temp);       end       temp = get(chList(i),'YData');       if ~isempty(temp)         set(destH,'Ydata',temp);       end       temp = get(chList(i),'ZData');       if ~isempty(temp)         set(destH,'Zdata',temp);       end       temp = get(chList(i),'CData');       if ~isempty(temp)         set(destH,'Cdata',temp);       end       temp = get(chList(i),'EdgeColor');       set(destH,'EdgeColor',temp);       temp = get(chList(i),'EraseMode');       set(destH,'EraseMode',temp);       temp = get(chList(i),'FaceColor');       set(destH,'FaceColor',temp);       temp = get(chList(i),'LineWidth');       set(destH,'LineWidth',temp);       if isML5          temp = get(chList(i),'CDataMapping');          set(destH,'CDataMapping',temp);          temp = get(chList(i),'FaceVertexCData');          if ~isempty(temp)            set(destH,'FaceVertexCData',temp);          end          temp = get(chList(i),'Faces');          set(destH,'Faces',temp);          temp = get(chList(i),'LineStyle');          set(destH,'LineStyle',temp);          temp = get(chList(i),'Marker');          set(destH,'Marker',temp);          temp = get(chList(i),'MarkerEdgeColor');          set(destH,'MarkerEdgeColor',temp);          temp = get(chList(i),'MarkerFaceColor');          set(destH,'MarkerFaceColor',temp);          temp = get(chList(i),'MarkerSize');          set(destH,'MarkerSize',temp);          temp = get(chList(i),'MarkerSize');          set(destH,'MarkerSize',temp);          temp = get(chList(i),'FaceLighting');          set(destH,'FaceLighting',temp);          temp = get(chList(i),'EdgeLighting');          set(destH,'EdgeLighting',temp);          temp = get(chList(i),'BackFaceLighting');          set(destH,'BackFaceLighting',temp);          temp = get(chList(i),'AmbientStrength');          set(destH,'AmbientStrength',temp);          temp = get(chList(i),'DiffuseStrength');          set(destH,'DiffuseStrength',temp);          temp = get(chList(i),'SpecularStrength');          set(destH,'SpecularStrength',temp);          temp = get(chList(i),'SpecularExponent');          set(destH,'SpecularExponent',temp);          temp = get(chList(i),'SpecularColorReflectance');          set(destH,'SpecularColorReflectance',temp);          temp = get(chList(i),'VertexNormals');          set(destH,'VertexNormals',temp);          temp = get(chList(i),'NormalMode');          set(destH,'NormalMode',temp);       end    elseif strcmp(get(chList(i),'Type'),'surface')       figure(gDestFig)       hold on       destH = surf([0 .01],[0 .01],[0 0;0 0]);       temp = get(chList(i),'XData');       if ~isempty(temp)         set(destH,'Xdata',temp);       end       temp = get(chList(i),'YData');       if ~isempty(temp)         set(destH,'Ydata',temp);       end       temp = get(chList(i),'ZData');       if ~isempty(temp)         set(destH,'Zdata',temp);       end       temp = get(chList(i),'CData');       if ~isempty(temp)         set(destH,'Cdata',temp);       end       temp = get(chList(i),'EdgeColor');       set(destH,'EdgeColor',temp);       temp = get(chList(i),'EraseMode');       set(destH,'EraseMode',temp);       temp = get(chList(i),'FaceColor');       set(destH,'FaceColor',temp);       temp = get(chList(i),'LineWidth');       set(destH,'LineWidth',temp);       temp = get(chList(i),'LineStyle');       set(destH,'LineStyle',temp);       temp = get(chList(i),'MarkerSize');       set(destH,'MarkerSize',temp);       temp = get(chList(i),'MeshStyle');       set(destH,'MeshStyle',temp);       if isML5          temp = get(chList(i),'CDataMapping');          set(destH,'CDataMapping',temp);          temp = get(chList(i),'Marker');          set(destH,'Marker',temp);          temp = get(chList(i),'MarkerEdgeColor');          set(destH,'MarkerEdgeColor',temp);          temp = get(chList(i),'MarkerFaceColor');          set(destH,'MarkerFaceColor',temp);          temp = get(chList(i),'FaceLighting');          set(destH,'FaceLighting',temp);          temp = get(chList(i),'EdgeLighting');          set(destH,'EdgeLighting',temp);          temp = get(chList(i),'BackFaceLighting');          set(destH,'BackFaceLighting',temp);          temp = get(chList(i),'AmbientStrength');          set(destH,'AmbientStrength',temp);          temp = get(chList(i),'DiffuseStrength');          set(destH,'DiffuseStrength',temp);          temp = get(chList(i),'SpecularStrength');          set(destH,'SpecularStrength',temp);          temp = get(chList(i),'SpecularExponent');          set(destH,'SpecularExponent',temp);          temp = get(chList(i),'SpecularColorReflectance');          set(destH,'SpecularColorReflectance',temp);          temp = get(chList(i),'VertexNormals');          set(destH,'VertexNormals',temp);          temp = get(chList(i),'NormalMode');          set(destH,'NormalMode',temp);       end    elseif strcmp(get(chList(i),'Type'),'text')       figure(gDestFig)       isSpecialText = 1;       if i == lenChList-3          title('')          destH = get(gDest,'Title');        elseif i == lenChList-2          xlabel('')          destH = get(gDest,'XLabel');        elseif i == lenChList-1          ylabel('')          destH = get(gDest,'YLabel');        elseif i == lenChList          zlabel('')          destH = get(gDest,'ZLabel');        else          destH = text(0,0,'dummy!');          isSpecialText = 0;       end       if isML5          oldHandVis = get(destH,'HandleVisibility');          set(destH,'HandleVisibility','off');       end       temp = get(chList(i),'Color');       set(destH,'Color',temp);       temp = get(chList(i),'EraseMode');       set(destH,'EraseMode',temp);       temp = get(chList(i),'FontAngle');       set(destH,'FontAngle',temp);       temp = get(chList(i),'FontName');       set(destH,'FontName',temp);       temp = get(chList(i),'FontSize');       set(destH,'FontSize',temp);       temp = get(chList(i),'FontWeight');       set(destH,'FontWeight',temp);       temp = get(chList(i),'HorizontalAlignment');       set(destH,'HorizontalAlignment',temp);       if isSpecialText          % do not try to copy the position of axis labels/title          % almost no one will ever modify the label/title position          % so let's not worry about it.        elseif ~isSpecialText          temp = get(chList(i),'Units');          set(destH,'Units',temp);          temp = get(chList(i),'Position');          set(destH,'Position',temp);       end       temp = get(chList(i),'Rotation');       set(destH,'Rotation',temp);       temp = get(chList(i),'String');       set(destH,'String',temp);       temp = get(chList(i),'VerticalAlignment');       set(destH,'VerticalAlignment',temp);       if isML5            temp = get(chList(i),'FontUnits');          set(destH,'FontUnits',temp);          temp = get(chList(i),'Interpreter');          set(destH,'Interpreter',temp);          temp = get(chList(i),'Editing');          set(destH,'Editing',temp);          set(destH,'HandleVisibility',oldHandVis);       end   endend%keyboarddisp('Done!')