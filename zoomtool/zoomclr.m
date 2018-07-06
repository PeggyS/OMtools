function zoomclr(ga,zoom_resize)% ZOOMCLR Used by ZOOMTOOL to remove itself from the axes.%       ZOOMCLR(H) where H is the axis ZOOMTOOL is active in.%%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN%           ZOOMYOUT%       Dennis W. Brown 1-10-94%       Copyright (c) 1994 by Dennis W. Brown%       May be freely distributed.%       Not for use in commercial products.% Modifications by Jonathan Jacobs%                  September 1997 - February 2010 (last mod: 02/09/10)if nargin<1, ga = gca; endif nargin<2, zoom_resize = 1; endgf=ga.Parent;gf.KeyPressFcn='';% get handles stored in Axis 'UserData'temp = ga.UserData;if isempty(temp), return; end    h  = temp{1};h2 = temp{2};%%% handles and etc stored in 2nd cell of userdata.cur1horH=h2{1};       cur1LblX=h2{2};          cur1LblY=h2{3};cur1vertH=h2{4};      cur1VisFrameBgH=h2{5};   cur1VisFrameH=h2{6}; cur2horH=h2{7};       cur2LblX=h2{8};          cur2LblY=h2{9};cur2vertH=h2{10};     cur2VisFrameBgH=h2{11};  cur2VisFrameH=h2{12}; hC1Color=h2{13};      hC2Color=h2{14};         hClrX=h2{15};hClrXY=h2{16};        hCur1Box=h2{17};         hCur2Box=h2{18};hCurMode=h2{19};      hLToggle=h2{20};         hXHigh=h2{21};hXLow=h2{22};         hYAutoRange=h2{23};      hYHigh=h2{24};hYLow=h2{25};         lhand=h2{26};            linVisFrameBgH=h2{27};linVisFrameH=h2{28};  oldBGcolor=h2{29};       oldWindNextPlot=h2{30};oldWindTag=h2{31};    ztOrigXLims=h2{32};      ztOrigYLims=h2{33};ztUpdateH=h2{34};     init_fig_size=h2{35};	  init_fig_units=h2{36};hRBzoom=h2{37};		 init_ax_pos=h2{38};	     hCur1Frame=h2{39};hCur2Frame=h2{40};	 hLToggleFrame=h2{41};    hRBreset=h2{42};hCur1Width=h2{43};    hCur2Width=h2{44}; % Clean up objects with handles stored in 'UserData' of the axis objectfor i = 1:length(h)    delete(h(i));end% Clean up cursor controls (there are two of each)for i = 1:2    delete(findpush(gf,'<'));    delete(findpush(gf,'>'));    delete(findpush(gf,'<<'));    delete(findpush(gf,'>>'));enddelete(hClrXY);delete(hClrX);%delete(findpush(gf,'C1 clr'));%delete(findpush(gf,'C2 clr'));% Clean off cursorsdelete(findline(ga,1001));delete(findline(ga,1002));delete(findline(ga,2001));delete(findline(ga,2002));% clean off readout labelsdelete(finduitx(gf,'-- X --'));delete(finduitx(gf,'-- Y --'));delete(finduitx(gf,'Delta X'));delete(finduitx(gf,'Delta Y'));delete(finduitx(gf,'-- X --'));delete(finduitx(gf,'-- Y --'));% Clean off the rest of the labelsdelete(findchbx(gf,'Cursor 1'));delete(findchbx(gf,'Cursor 2'));delete(finduitx(gf,'X axis zoom'));delete(finduitx(gf,'Y axis zoom'));delete(finduitx(gf,'XY zoom'));delete(finduitx(gf,'Min'));delete(finduitx(gf,'Max'));delete(finduitx(gf,'Min'));delete(finduitx(gf,'Max'));delete(finduitx(gf,'Cursor Erase Mode'));delete(finduitx(gf,'Rubber Band zoom'));for i = 1:length(lhand)   bxstr1 = [num2str(i) '   '];   bxstr2 = [num2str(i) '  '];   bxstr3 = [num2str(i) ' <-'];   bxstr4 = [num2str(i) '<-'];   bxstr5 = ['0' num2str(i) '  '];   bxstr6 = ['0' num2str(i) '<-'];   delete(findchbx(gf,bxstr1));   delete(findchbx(gf,bxstr2));   delete(findchbx(gf,bxstr3));   delete(findchbx(gf,bxstr4));   delete(findchbx(gf,bxstr5));   delete(findchbx(gf,bxstr6));endclear lhand% save the size and position of the window% if 'omprefs' doesn't exist, or can not be created, then don't% try to save the preferences.%dErrFlag = 0; fErrFlag = 0; mkdir_stat = 1;gf.Units='Normalized';tmp_zoom_fig_size = get(gf, 'Position');curdir=pwd;cd( findztprefs )try    load 'ztPrefs.mat';catch endemodenum = get(hCurMode,'Value');if emodenum==1   emode = 'xor'; %#ok<NASGU> else   emode = 'normal'; %#ok<NASGU>endzoom_fig_size = tmp_zoom_fig_size; %#ok<NASGU>C1Width = get(hCur1Width,'Value'); %#ok<NASGU>C2Width = get(hCur2Width,'Value'); %#ok<NASGU>save('ztPrefs.mat', 'emode', 'zoom_fig_size', 'C1Width', 'C2Width')cd( curdir )% allow axes to be replaced with new plot commandgf.NextPlot='replace';% remove keypress function%set( gf, 'KeyPressFcn', '' );% remove line functionschildH = ga.Children;for i = 1:length(childH)   set(childH(i), 'ButtonDownFcn', '')   set(childH(i), 'UserData', '')end% restore the background color ga.Color=oldBGcolor;% restore the original axis limits%if (0)%   set(gca,'XLim',ztOrigXLims);%   set(gca,'YLim',ztOrigYLims);%end% restore the original taggf.Tag=oldWindTag;gf.NextPlot=oldWindNextPlot;delete( hXLow );       delete( hXHigh );       delete( hYLow );delete( hYHigh );      delete( hC2Color );     delete( hC1Color );delete( hCurMode );    delete( ztUpdateH );    delete( hYAutoRange );delete( hCur1Box );    delete( hCur2Box );     delete( hRBzoom );delete( hCur1Frame );  delete( hCur2Frame );   delete( hLToggleFrame );delete( hRBreset );    delete( hCur1Width );   delete( hCur2Width );% remove frame crapdelete(cur1VisFrameH);   delete(cur1VisFrameBgH)delete(cur2VisFrameH);   delete(cur2VisFrameBgH)delete(linVisFrameH);    delete(linVisFrameBgH)ga.UserData=[];% adjust size of axis back to originalold = ga.Units;ga.Units='normal';if zoom_resize   pos = ga.Position;   pos(2) = pos(2)-0.04;   pos(3) = pos(3)+0.065;   pos(4) = pos(4)+2*0.04;   ga.Position=pos;   gf.Position=init_fig_size; else   ga.Position=init_ax_pos;endga.Units=old;clear global linVisTogFlag curVisTogFlag 