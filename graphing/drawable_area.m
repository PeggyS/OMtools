function zp=drawable_area

z=figure('Units','Pixels','Toolbar','none','Visible','on','MenuBar','none');
z.WindowState = 'maximized'; %<- does not work if invisible
%z.Visible='off';
pause(0.6)
zp=z.Position;
close(z)
