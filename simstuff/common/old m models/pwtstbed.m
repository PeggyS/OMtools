function [ret,x0,str,ts,xts]=pwtstbed(t,x,u,flag);%PWTSTBED	is the M-file description of the SIMULINK system named PWTSTBED.%	The block-diagram can be displayed by typing: PWTSTBED.%%	SYS=PWTSTBED(T,X,U,FLAG) returns depending on FLAG certain%	system values given time point, T, current state vector, X,%	and input vector, U.%	FLAG is used to indicate the type of output to be returned in SYS.%%	Setting FLAG=1 causes PWTSTBED to return state derivatives, FLAG=2%	discrete states, FLAG=3 system outputs and FLAG=4 next sample%	time. For more information and other options see SFUNC.%%	Calling PWTSTBED with a FLAG of zero:%	[SIZES]=PWTSTBED([],[],[],0),  returns a vector, SIZES, which%	contains the sizes of the state vector and other parameters.%		SIZES(1) number of states%		SIZES(2) number of discrete states%		SIZES(3) number of outputs%		SIZES(4) number of inputs%		SIZES(5) number of roots (currently unsupported)%		SIZES(6) direct feedthrough flag%		SIZES(7) number of sample times%%	For the definition of other parameters in SIZES, see SFUNC.%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.% Note: This M-file is only used for saving graphical information;%       after the model is loaded into memory an internal model%       representation is used.% the system will take on the name of this mfile:sys = mfilename;new_system(sys)simver(1.3)if (0 == (nargin + nargout))     set_param(sys,'Location',[83,466,583,688])     open_system(sys)end;set_param(sys,'algorithm',     'RK-45')set_param(sys,'Start time',    '0.0')set_param(sys,'Stop time',     '.3')set_param(sys,'Min step size', '0.001')set_param(sys,'Max step size', '0.001')set_param(sys,'Relative error','1e-3')set_param(sys,'Return vars',   '')add_block('built-in/To Workspace',[sys,'/','t'])set_param([sys,'/','t'],...		'hide name',0,...		'mat-name','twClock',...		'buffer','100000',...		'Mask Display','',...		'Mask Translate','global t',...		'position',[410,157,465,173])add_block('built-in/To Workspace',[sys,'/','clock out1'])set_param([sys,'/','clock out1'],...		'hide name',0,...		'mat-name','pwmuxout',...		'buffer','100000',...		'position',[415,82,480,98])add_block('built-in/Mux',[sys,'/','Mux'])set_param([sys,'/','Mux'],...		'hide name',0,...		'inputs','2',...		'position',[355,72,385,108])add_block('built-in/To Workspace',[sys,'/','stm'])set_param([sys,'/','stm'],...		'hide name',0,...		'mat-name','pwstim',...		'buffer','100000',...		'position',[415,52,465,68])add_block('built-in/To Workspace',[sys,'/','out'])set_param([sys,'/','out'],...		'hide name',0,...		'mat-name','pwout',...		'buffer','100000',...		'position',[415,122,465,138])add_block('built-in/Sum',[sys,'/','Sum1'])set_param([sys,'/','Sum1'],...		'hide name',0,...		'inputs','+-',...		'position',[125,114,150,141])add_block('built-in/Clock',[sys,'/','Clock'])set_param([sys,'/','Clock'],...		'position',[360,155,380,175])add_block('built-in/Constant',[sys,'/',['Threshold',13,'1']])set_param([sys,'/',['Threshold',13,'1']],...		'hide name',0,...		'Value','0',...		'position',[30,140,60,160])add_block('built-in/Note',[sys,'/','PG width Testbed'])set_param([sys,'/','PG width Testbed'],...		'Font Weight','bold',...		'Font Size',12,...		'position',[75,15,80,20])%     Subsystem  'PW funct3'.new_system([sys,'/','PW funct3'])set_param([sys,'/','PW funct3'],'Location',[94,108,852,627])add_block('built-in/Note',[sys,'/',['PW funct3/The input, scaled by the piece-wise linear function, is compared to the output of the ',13,'resettable integrator, which integrates a constant value each iteration.']])set_param([sys,'/',['PW funct3/The input, scaled by the piece-wise linear function, is compared to the output of the ',13,'resettable integrator, which integrates a constant value each iteration.']],...		'position',[375,425,380,430])add_block('built-in/Note',[sys,'/',['PW funct3/This block uses a resettable integrator and a piecewise-linear function (PWfunc) to generate',13,'a pulse of appropriate duration for the incoming stimulus.']])set_param([sys,'/',['PW funct3/This block uses a resettable integrator and a piecewise-linear function (PWfunc) to generate',13,'a pulse of appropriate duration for the incoming stimulus.']],...		'position',[355,385,360,390])add_block('built-in/Note',[sys,'/',['PW funct3/This process continues until the error has been driven to zero or the input drops to zero,',13,'and the integrator is reset and the pulse is ended.']])set_param([sys,'/',['PW funct3/This process continues until the error has been driven to zero or the input drops to zero,',13,'and the integrator is reset and the pulse is ended.']],...		'position',[380,470,385,475])add_block('built-in/Note',[sys,'/','PW funct3/PW Function'])set_param([sys,'/','PW funct3/PW Function'],...		'Font Weight','bold',...		'Font Size',12,...		'position',[80,15,85,20])add_block('built-in/Abs',[sys,'/','PW funct3/Abs'])set_param([sys,'/','PW funct3/Abs'],...		'hide name',0,...		'position',[210,135,240,155])add_block('built-in/To Workspace',[sys,'/','PW funct3/To Workspace7'])set_param([sys,'/','PW funct3/To Workspace7'],...		'orientation',1,...		'hide name',0,...		'Font Name','Courier New',...		'mat-name','pwfn',...		'buffer','10000',...		'position',[248,265,282,290])add_block('built-in/To Workspace',[sys,'/','PW funct3/To Workspace3'])set_param([sys,'/','PW funct3/To Workspace3'],...		'orientation',1,...		'hide name',0,...		'Font Name','Courier New',...		'mat-name','sumout',...		'buffer','10000',...		'position',[388,255,442,275])add_block('built-in/Sum',[sys,'/','PW funct3/Sum'])set_param([sys,'/','PW funct3/Sum'],...		'inputs','-+',...		'position',[345,225,365,245])add_block('built-in/Constant',[sys,'/','PW funct3/dead zone'])set_param([sys,'/','PW funct3/dead zone'],...		'orientation',3,...		'Value','.04',...		'position',[335,85,365,105])add_block('built-in/Relational Operator',[sys,'/',['PW funct3/Relational',13,'Operator2']])set_param([sys,'/',['PW funct3/Relational',13,'Operator2']],...		'hide name',0,...		'Operator','<=',...		'position',[380,53,410,77])add_block('built-in/To Workspace',[sys,'/','PW funct3/To Workspace2'])set_param([sys,'/','PW funct3/To Workspace2'],...		'hide name',0,...		'Font Name','Courier New',...		'mat-name','rni',...		'buffer','10000',...		'position',[345,129,385,151])add_block('built-in/Constant',[sys,'/','PW funct3/out thresh'])set_param([sys,'/','PW funct3/out thresh'],...		'Value','0.2',...		'position',[505,250,535,270])add_block('built-in/Relational Operator',[sys,'/',['PW funct3/Relational',13,'Operator1']])set_param([sys,'/',['PW funct3/Relational',13,'Operator1']],...		'hide name',0,...		'position',[555,228,585,252])add_block('built-in/To Workspace',[sys,'/','PW funct3/To Workspace6'])set_param([sys,'/','PW funct3/To Workspace6'],...		'orientation',1,...		'hide name',0,...		'Font Name','Courier New',...		'mat-name','nostm',...		'buffer','10000',...		'position',[570,90,620,110])%     Subsystem  ['PW funct3/Good Reset',13,'Integrator'].new_system([sys,'/',['PW funct3/Good Reset',13,'Integrator']])set_param([sys,'/',['PW funct3/Good Reset',13,'Integrator']],'Location',[80,355,604,681])add_block('built-in/Inport',[sys,'/',['PW funct3/Good Reset',13,'Integrator/in_1']])set_param([sys,'/',['PW funct3/Good Reset',13,'Integrator/in_1']],...		'position',[50,70,70,90])add_block('built-in/Product',[sys,'/',['PW funct3/Good Reset',13,'Integrator/Product']])set_param([sys,'/',['PW funct3/Good Reset',13,'Integrator/Product']],...		'hide name',0,...		'position',[195,75,225,95])add_block('built-in/Logical Operator',[sys,'/',['PW funct3/Good Reset',13,'Integrator/Logical',13,'Operator2']])set_param([sys,'/',['PW funct3/Good Reset',13,'Integrator/Logical',13,'Operator2']],...		'orientation',3,...		'hide name',0,...		'Operator','NOT',...		'Number of Input Ports','1',...		'position',[130,115,170,135])add_block('built-in/Inport',[sys,'/',['PW funct3/Good Reset',13,'Integrator/in_3']])set_param([sys,'/',['PW funct3/Good Reset',13,'Integrator/in_3']],...		'Port','3',...		'position',[50,230,70,250])add_block('built-in/Inport',[sys,'/',['PW funct3/Good Reset',13,'Integrator/in_2']])set_param([sys,'/',['PW funct3/Good Reset',13,'Integrator/in_2']],...		'Port','2',...		'position',[50,165,70,185])add_block('built-in/Outport',[sys,'/',['PW funct3/Good Reset',13,'Integrator/out_1']])set_param([sys,'/',['PW funct3/Good Reset',13,'Integrator/out_1']],...		'position',[400,165,420,185])add_block('built-in/Reset Integrator',[sys,'/',['PW funct3/Good Reset',13,'Integrator/Reset',13,'Integrator']])set_param([sys,'/',['PW funct3/Good Reset',13,'Integrator/Reset',13,'Integrator']],...		'hide name',0,...		'position',[295,160,325,190])add_line([sys,'/',['PW funct3/Good Reset',13,'Integrator']],[75,175;290,175])add_line([sys,'/',['PW funct3/Good Reset',13,'Integrator']],[150,175;150,140])add_line([sys,'/',['PW funct3/Good Reset',13,'Integrator']],[230,85;260,85;260,165;290,165])add_line([sys,'/',['PW funct3/Good Reset',13,'Integrator']],[75,80;190,80])add_line([sys,'/',['PW funct3/Good Reset',13,'Integrator']],[150,110;150,90;190,90])add_line([sys,'/',['PW funct3/Good Reset',13,'Integrator']],[75,240;180,240;180,185;290,185])add_line([sys,'/',['PW funct3/Good Reset',13,'Integrator']],[330,175;395,175])set_param([sys,'/',['PW funct3/Good Reset',13,'Integrator']],...		'Mask Display','1/s')%     Finished composite block ['PW funct3/Good Reset',13,'Integrator'].set_param([sys,'/',['PW funct3/Good Reset',13,'Integrator']],...		'orientation',2,...		'hide name',0,...		'position',[415,155,455,195])add_block('built-in/To Workspace',[sys,'/','PW funct3/To Workspace1'])set_param([sys,'/','PW funct3/To Workspace1'],...		'hide name',0,...		'Font Name','Courier New',...		'mat-name','rstsig',...		'buffer','10000',...		'position',[565,125,615,145])add_block('built-in/Logical Operator',[sys,'/',['PW funct3/Logical',13,'Operator']])set_param([sys,'/',['PW funct3/Logical',13,'Operator']],...		'orientation',2,...		'hide name',0,...		'Operator','or',...		'position',[565,157,590,193])add_block('built-in/Logical Operator',[sys,'/',['PW funct3/Logical',13,'Operator1']])set_param([sys,'/',['PW funct3/Logical',13,'Operator1']],...		'orientation',3,...		'hide name',0,...		'Operator','NOT',...		'Number of Input Ports','1',...		'position',[600,200,630,220])add_block('built-in/Outport',[sys,'/','PW funct3/pgw'])set_param([sys,'/','PW funct3/pgw'],...		'position',[725,230,745,250])add_block('built-in/Inport',[sys,'/','PW funct3/mcspl'])set_param([sys,'/','PW funct3/mcspl'],...		'position',[60,120,85,140])%     Subsystem  ['PW funct3/Input',13,'Switch'].new_system([sys,'/',['PW funct3/Input',13,'Switch']])set_param([sys,'/',['PW funct3/Input',13,'Switch']],'Location',[189,72,587,302])add_block('built-in/Inport',[sys,'/',['PW funct3/Input',13,'Switch/mcspl']])set_param([sys,'/',['PW funct3/Input',13,'Switch/mcspl']],...		'position',[65,94,85,116])add_block('built-in/Outport',[sys,'/',['PW funct3/Input',13,'Switch/mcsw']])set_param([sys,'/',['PW funct3/Input',13,'Switch/mcsw']],...		'position',[335,85,355,105])add_block('built-in/To Workspace',[sys,'/',['PW funct3/Input',13,'Switch/To Workspace5']])set_param([sys,'/',['PW funct3/Input',13,'Switch/To Workspace5']],...		'orientation',3,...		'hide name',0,...		'Font Name','Courier New',...		'mat-name','mcsw',...		'buffer','10000',...		'position',[297,55,343,70])add_block('built-in/Switch',[sys,'/',['PW funct3/Input',13,'Switch/Switch2']])set_param([sys,'/',['PW funct3/Input',13,'Switch/Switch2']],...		'hide name',0,...		'Threshold','0.5',...		'position',[275,80,305,110])add_block('built-in/Inport',[sys,'/',['PW funct3/Input',13,'Switch/pgw']])set_param([sys,'/',['PW funct3/Input',13,'Switch/pgw']],...		'Port','2',...		'position',[65,145,85,165])%     Subsystem  ['PW funct3/Input',13,'Switch/lead//trail',13,'edge det'].new_system([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det']],'Location',[19,367,394,587])add_block('built-in/Note',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/It is also possible to remove the SIGNUM function',13,'and the ''=='', and replace them with a simple',13,'switch with a threshold of (say) 150 or so.']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/It is also possible to remove the SIGNUM function',13,'and the ''=='', and replace them with a simple',13,'switch with a threshold of (say) 150 or so.']],...		'position',[185,155,190,160])add_block('built-in/Abs',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Abs']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Abs']],...		'hide name',0,...		'position',[195,83,225,107])%     Subsystem  ['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign'].new_system([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],'Location',[159,417,467,586])add_block('built-in/Outport',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/out_1']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/out_1']],...		'position',[265,70,285,90])add_block('built-in/Inport',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/in_1']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/in_1']],...		'position',[35,30,55,50])add_block('built-in/Relational Operator',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/Relational',13,'Operator']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/Relational',13,'Operator']],...		'Operator','>',...		'position',[140,32,170,63])add_block('built-in/Sum',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/Sum']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/Sum']],...		'inputs','+-',...		'position',[215,64,235,91])add_block('built-in/Relational Operator',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/Relational',13,'Operator1']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/Relational',13,'Operator1']],...		'Operator','<',...		'position',[140,92,170,123])add_block('built-in/Constant',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/Constant']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign/Constant']],...		'Value','0',...		'position',[65,105,85,125])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],[60,40;135,40])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],[95,40;95,100;135,100])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],[90,115;135,115])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],[110,115;110,55;135,55])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],[175,110;185,110;185,85;210,85])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],[175,50;185,50;185,70;210,70])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],[240,80;260,80])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],...		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...		'Mask Type','Sign')set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],...		'Mask Dialogue','y = sign(x)',...		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')%     Finished composite block ['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign'].set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Sign']],...		'hide name',0,...		'position',[135,82,165,108])add_block('built-in/Derivative',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Derivative']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Derivative']],...		'hide name',0,...		'position',[80,85,110,105])add_block('built-in/Inport',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/in_1']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/in_1']],...		'position',[35,85,55,105])add_block('built-in/Relational Operator',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Relational',13,'Operator']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Relational',13,'Operator']],...		'hide name',0,...		'Operator','==',...		'position',[260,88,290,112])add_block('built-in/Constant',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Threshold',13,'1']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/Threshold',13,'1']],...		'hide name',0,...		'position',[205,114,225,136])add_block('built-in/Outport',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/out_1']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/out_1']],...		'position',[330,90,350,110])add_block('built-in/Note',[sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/leading//trailing edge detection']])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det/leading//trailing edge detection']],...		'position',[170,35,240,40])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det']],[230,95;255,95])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det']],[170,95;190,95])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det']],[115,95;130,95])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det']],[230,125;245,125;255,105])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det']],[295,100;325,100])add_line([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det']],[60,95;75,95])set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det']],...		'Mask Display','Lead/Trail\nEdge Det')%     Finished composite block ['PW funct3/Input',13,'Switch/lead//trail',13,'edge det'].set_param([sys,'/',['PW funct3/Input',13,'Switch/lead//trail',13,'edge det']],...		'hide name',0,...		'position',[120,89,180,121])add_block('built-in/To Workspace',[sys,'/',['PW funct3/Input',13,'Switch/To Workspace8']])set_param([sys,'/',['PW funct3/Input',13,'Switch/To Workspace8']],...		'orientation',2,...		'hide name',0,...		'Font Name','Courier New',...		'mat-name','lted',...		'buffer','10000',...		'position',[130,127,175,143])add_line([sys,'/',['PW funct3/Input',13,'Switch']],[90,105;95,105;95,60;235,60;235,85;270,85])add_line([sys,'/',['PW funct3/Input',13,'Switch']],[185,105;270,105])add_line([sys,'/',['PW funct3/Input',13,'Switch']],[200,105;200,135;180,135])add_line([sys,'/',['PW funct3/Input',13,'Switch']],[310,95;320,95;320,75])add_line([sys,'/',['PW funct3/Input',13,'Switch']],[310,95;330,95])add_line([sys,'/',['PW funct3/Input',13,'Switch']],[90,105;115,105])add_line([sys,'/',['PW funct3/Input',13,'Switch']],[90,155;235,155;235,95;270,95])set_param([sys,'/',['PW funct3/Input',13,'Switch']],...		'Mask Display','Input\nSwitch')%     Finished composite block ['PW funct3/Input',13,'Switch'].set_param([sys,'/',['PW funct3/Input',13,'Switch']],...		'hide name',0,...		'position',[135,115,185,170])%     Subsystem  'PW funct3/Sign'.new_system([sys,'/','PW funct3/Sign'])set_param([sys,'/','PW funct3/Sign'],'Location',[159,417,467,586])add_block('built-in/Constant',[sys,'/','PW funct3/Sign/Constant'])set_param([sys,'/','PW funct3/Sign/Constant'],...		'Value','0',...		'position',[65,105,85,125])add_block('built-in/Relational Operator',[sys,'/',['PW funct3/Sign/Relational',13,'Operator1']])set_param([sys,'/',['PW funct3/Sign/Relational',13,'Operator1']],...		'Operator','<',...		'position',[140,92,170,123])add_block('built-in/Sum',[sys,'/','PW funct3/Sign/Sum'])set_param([sys,'/','PW funct3/Sign/Sum'],...		'inputs','+-',...		'position',[215,64,235,91])add_block('built-in/Relational Operator',[sys,'/',['PW funct3/Sign/Relational',13,'Operator']])set_param([sys,'/',['PW funct3/Sign/Relational',13,'Operator']],...		'Operator','>',...		'position',[140,32,170,63])add_block('built-in/Inport',[sys,'/','PW funct3/Sign/in_1'])set_param([sys,'/','PW funct3/Sign/in_1'],...		'position',[35,30,55,50])add_block('built-in/Outport',[sys,'/','PW funct3/Sign/out_1'])set_param([sys,'/','PW funct3/Sign/out_1'],...		'position',[265,70,285,90])add_line([sys,'/','PW funct3/Sign'],[240,80;260,80])add_line([sys,'/','PW funct3/Sign'],[175,50;185,50;185,70;210,70])add_line([sys,'/','PW funct3/Sign'],[175,110;185,110;185,85;210,85])add_line([sys,'/','PW funct3/Sign'],[90,115;135,115])add_line([sys,'/','PW funct3/Sign'],[110,115;110,55;135,55])add_line([sys,'/','PW funct3/Sign'],[60,40;135,40])add_line([sys,'/','PW funct3/Sign'],[95,40;95,100;135,100])set_param([sys,'/','PW funct3/Sign'],...		'Mask Display','plot(-50,-50,50,50,[-50,50],[0,0],[0,0],[-50,50],[-40,0],[-30,-30],[0,40],[30,30])',...		'Mask Type','Sign',...		'Mask Dialogue','y = sign(x)')set_param([sys,'/','PW funct3/Sign'],...		'Mask Help','Sign Function:\n\t\t\ty = 1 if x > 0\n\t\t\ty = 0 if x = 0\n\t\t\ty = -1 if x < 0')%     Finished composite block 'PW funct3/Sign'.set_param([sys,'/','PW funct3/Sign'],...		'hide name',0,...		'position',[655,227,685,253])add_block('built-in/Memory',[sys,'/',['PW funct3/loop',13,'breaker']])set_param([sys,'/',['PW funct3/loop',13,'breaker']],...		'orientation',2,...		'position',[315,310,355,340])add_block('built-in/Note',[sys,'/','PW funct3/(Init input:0)'])set_param([sys,'/','PW funct3/(Init input:0)'],...		'position',[335,285,340,290])add_block('built-in/Constant',[sys,'/','PW funct3/Constant3'])set_param([sys,'/','PW funct3/Constant3'],...		'orientation',1,...		'hide name',0,...		'Value','1000',...		'position',[467,130,503,150])add_block('built-in/Constant',[sys,'/','PW funct3/Constant1'])set_param([sys,'/','PW funct3/Constant1'],...		'orientation',3,...		'hide name',0,...		'Value','0',...		'position',[472,200,498,220])add_block('built-in/Look Up Table',[sys,'/','PW funct3/PWfn'])set_param([sys,'/','PW funct3/PWfn'],...		'orientation',1,...		'hide name',0,...		'move name',0,...		'Input_Values','[ 0, 0.05:5, 5:10, 10:50 ]',...		'Output_Values','[ 0, (0.05:5)*0+15,  (5:10)*1+10,  (10:50)*2]')set_param([sys,'/','PW funct3/PWfn'],...		'position',[243,175,287,210])add_line([sys,'/','PW funct3'],[615,195;615,185;595,185])add_line([sys,'/','PW funct3'],[590,240;615,240;615,225])add_line([sys,'/','PW funct3'],[615,240;650,240])add_line([sys,'/','PW funct3'],[485,155;485,160;460,160])add_line([sys,'/','PW funct3'],[485,195;485,190;460,190])add_line([sys,'/','PW funct3'],[540,260;550,245])add_line([sys,'/','PW funct3'],[350,80;350,70;375,70])add_line([sys,'/','PW funct3'],[415,65;595,65;595,85])add_line([sys,'/','PW funct3'],[595,65;655,65;655,165;595,165])add_line([sys,'/','PW funct3'],[410,175;315,175;315,140;340,140])add_line([sys,'/','PW funct3'],[410,175;315,175;315,230;340,230])add_line([sys,'/','PW funct3'],[560,175;460,175])add_line([sys,'/','PW funct3'],[545,175;545,135;560,135])add_line([sys,'/','PW funct3'],[370,235;550,235])add_line([sys,'/','PW funct3'],[415,235;415,250])add_line([sys,'/','PW funct3'],[190,145;205,145])add_line([sys,'/','PW funct3'],[90,130;130,130])add_line([sys,'/','PW funct3'],[310,325;110,325;110,155;130,155])add_line([sys,'/','PW funct3'],[690,240;720,240])add_line([sys,'/','PW funct3'],[705,240;705,325;360,325])add_line([sys,'/','PW funct3'],[265,215;265,260])add_line([sys,'/','PW funct3'],[265,240;340,240])add_line([sys,'/','PW funct3'],[245,145;265,145;265,170])add_line([sys,'/','PW funct3'],[265,145;265,60;375,60])set_param([sys,'/','PW funct3'],...		'Mask Display','PW\nfunction')%     Finished composite block 'PW funct3'.set_param([sys,'/','PW funct3'],...		'hide name',0,...		'position',[235,114,285,146])add_block('built-in/From Workspace',[sys,'/','double pulse4'])set_param([sys,'/','double pulse4'],...		'hide name',0,...		'matl_expr','[0, t1, t1+.001, t1+d1, t1+d1+.001, t1+d1+.001+ipd, t1+d1+.001+ipd, t1+d1+.001+ipd+d2, t1+d1+.001+ipd+d2, 10000; 0, 0, p1, p1, 0, 0, p2, p2, 0, 0 ]''')set_param([sys,'/','double pulse4'],...		'Mask Display','Double\nPulse',...		'Mask Dialogue','Double Pulse|Pulse 1 Magnitude|Time of Pulse 1 Onset|Pulse 1 Duration|Interpulse Delay|Pulse 2 Magnitude|Pulse 2 Duration')set_param([sys,'/','double pulse4'],...		'Mask Translate','p1=@1; t1=@2; d1=@3; ipd=@4; p2=@5; d2=@6;',...		'Mask Entries','goal\/0\/stoptime\/0\/0\/0\/',...		'position',[25,68,80,102])add_line(sys,[385,165;405,165])add_line(sys,[390,90;410,90])add_line(sys,[155,130;180,130;180,80;350,80])add_line(sys,[65,150;110,150;120,135])add_line(sys,[85,85;110,85;120,120])add_line(sys,[330,80;330,60;410,60])add_line(sys,[290,130;410,130])add_line(sys,[325,130;325,100;350,100])add_line(sys,[180,130;230,130])drawnow% Return any arguments.if (nargin | nargout)	% Must use feval here to access system in memory	if (nargin > 3)		if (flag == 0)			eval(['[ret,x0,str,ts,xts]=',sys,'(t,x,u,flag);'])		else			eval(['ret =', sys,'(t,x,u,flag);'])		end	else		[ret,x0,str,ts,xts] = feval(sys);	endelse	drawnow % Flash up the model and execute load callbackend