% curtoggl.m:  Called from zoomtool to turn on/off the cursors.% Written by: Jonathan Jacobs (based on code by Peg Skelly!)%             June 1996 - July 1996  (last mod: 07/01/96)function curtoggl( whichCur )temp  = get(gca, 'UserData');bigHList = temp{2};hCur1Box = bigHList{17};hCur2Box = bigHList{18};if strcmp( whichCur, 'curOne' )   ga = get(hCur1Box,'UserData');   if( get(hCur1Box,'Value') == 0)      crsroff(ga,1001);      crsroff(ga,1002);    elseif( get(hCur1Box,'Value') == 1)      crsron(ga,1001);      crsron(ga,1002);   endendif strcmp( whichCur, 'curTwo' )   ga = get(hCur2Box,'UserData');   if( get(hCur2Box,'Value') == 0)      crsroff(ga,2001);      crsroff(ga,2002);    elseif( get(hCur2Box,'Value') == 1)      crsron(ga,2001);      crsron(ga,2002);   endend