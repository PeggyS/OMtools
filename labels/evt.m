%evt.m: Eye Velocity vs Time axis labelscomp = computer;vers = version;if vers(1) >= '6'   degstr = '\circ'; else   if comp(1) == 'M'     degstr = '�';   else     degstr = ' deg';   endend xlabel( 'Time (sec)' )ylabel( ['Eye Velocity (' degstr '/sec)'] )