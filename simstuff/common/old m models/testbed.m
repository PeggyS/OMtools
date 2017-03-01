function [ret,x0,str,ts,xts]=testbed(t,x,u,flag);%TESTBED	is the M-file description of the SIMULINK system named TESTBED.%	The block-diagram can be displayed by typing: TESTBED.%%	SYS=TESTBED(T,X,U,FLAG) returns depending on FLAG certain%	system values given time point, T, current state vector, X,%	and input vector, U.%	FLAG is used to indicate the type of output to be returned in SYS.%%	Setting FLAG=1 causes TESTBED to return state derivatives, FLAG=2%	discrete states, FLAG=3 system outputs and FLAG=4 next sample%	time. For more information and other options see SFUNC.%%	Calling TESTBED with a FLAG of zero:%	[SIZES]=TESTBED([],[],[],0),  returns a vector, SIZES, which%	contains the sizes of the state vector and other parameters.%		SIZES(1) number of states%		SIZES(2) number of discrete states%		SIZES(3) number of outputs%		SIZES(4) number of inputs%		SIZES(5) number of roots (currently unsupported)%		SIZES(6) direct feedthrough flag%		SIZES(7) number of sample times%%	For the definition of other parameters in SIZES, see SFUNC.%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.% Note: This M-file is only used for saving graphical information;%       after the model is loaded into memory an internal model%       representation is used.% the system will take on the name of this mfile:sys = mfilename;new_system(sys)simver(1.3)if (0 == (nargin + nargout))     set_param(sys,'Location',[14,381,550,706])     open_system(sys)end;set_param(sys,'algorithm',     'RK-45')set_param(sys,'Start time',    '0.0')set_param(sys,'Stop time',     '.5')set_param(sys,'Min step size', '0.001')set_param(sys,'Max step size', '0.001')set_param(sys,'Relative error','1e-3')set_param(sys,'Return vars',   '')add_block('built-in/To Workspace',[sys,'/','t'])set_param([sys,'/','t'],...		'hide name',0,...		'mat-name','t',...		'buffer','100000',...		'Mask Display','',...		'Mask Translate','global t',...		'position',[395,257,445,273])add_block('built-in/To Workspace',[sys,'/','stm1'])set_param([sys,'/','stm1'],...		'hide name',0,...		'mat-name','stm2',...		'buffer','100000',...		'position',[395,232,445,248])add_block('built-in/To Workspace',[sys,'/','clock out1'])set_param([sys,'/','clock out1'],...		'hide name',0,...		'mat-name','muxout',...		'buffer','100000',...		'position',[415,127,465,143])add_block('built-in/Mux',[sys,'/','Mux'])set_param([sys,'/','Mux'],...		'hide name',0,...		'inputs','2',...		'position',[355,117,385,153])add_block('built-in/To Workspace',[sys,'/','stm'])set_param([sys,'/','stm'],...		'hide name',0,...		'mat-name','stm1',...		'buffer','100000',...		'position',[415,97,465,113])add_block('built-in/To Workspace',[sys,'/','out'])set_param([sys,'/','out'],...		'hide name',0,...		'mat-name','out',...		'buffer','100000',...		'position',[415,167,465,183])add_block('built-in/Sum',[sys,'/','Sum1'])set_param([sys,'/','Sum1'],...		'hide name',0,...		'inputs','+-',...		'position',[125,159,150,186])add_block('built-in/Note',[sys,'/','Testbed'])set_param([sys,'/','Testbed'],...		'Font Weight','bold',...		'Font Size',12,...		'position',[485,5,490,10])%     Subsystem  'noise'.new_system([sys,'/','noise'])set_param([sys,'/','noise'],'Location',[54,341,339,470])add_block('built-in/Outport',[sys,'/','noise/Out_1'])set_param([sys,'/','noise/Out_1'],...		'position',[230,40,250,60])add_block('built-in/Gain',[sys,'/','noise/Gain'])set_param([sys,'/','noise/Gain'],...		'Gain','[sqrt(Cov)]/[sqrt(Ts)]',...		'position',[155,31,195,69])add_block('built-in/Zero-Order Hold',[sys,'/',['noise/Zero-Order',13,'Hold']])set_param([sys,'/',['noise/Zero-Order',13,'Hold']],...		'Sample time','Ts',...		'position',[85,34,120,66])add_block('built-in/White Noise',[sys,'/','noise/White Noise'])set_param([sys,'/','noise/White Noise'],...		'Seed','seed',...		'position',[25,40,45,60])add_line([sys,'/','noise'],[50,50;80,50])add_line([sys,'/','noise'],[200,50;225,50])add_line([sys,'/','noise'],[125,50;150,50])set_param([sys,'/','noise'],...		'Mask Display','plot(t(:),r2(:))',...		'Mask Type','Continuous White Noise.')set_param([sys,'/','noise'],...		'Mask Dialogue','White noise for continuous (s-domain) systems.\nBand-limited using zero-order-hold.|Noise Power:|Sample Time:|Seed')set_param([sys,'/','noise'],...		'Mask Translate','Cov = @1; Ts = @2; seed = @3; r = rand(1,12); r2 = [r(1),r;r,r(12)]; t =[1:13;1:13];')set_param([sys,'/','noise'],...		'Mask Help','Implemented using white noise into Zero-Order Hold block. The seed and power can be vectors of the same length to produce a vector of white noise sources. For faster simulation, set sample time to the highest value possible but in accordance with the fastest dynamics of system.')set_param([sys,'/','noise'],...		'Mask Entries','[0.0001]\/0.01\/[23341]\/')%     Finished composite block 'noise'.set_param([sys,'/','noise'],...		'hide name',0,...		'position',[250,7,295,43])add_block('built-in/Step Fcn',[sys,'/','Step'])set_param([sys,'/','Step'],...		'hide name',0,...		'Time','.1',...		'After','4',...		'position',[320,8,350,32])add_block('built-in/To Workspace',[sys,'/','out1'])set_param([sys,'/','out1'],...		'hide name',0,...		'mat-name','out2',...		'buffer','100000',...		'position',[415,187,465,203])%     Subsystem  ['Pulse',13,'Generator'].new_system([sys,'/',['Pulse',13,'Generator']])set_param([sys,'/',['Pulse',13,'Generator']],'Location',[158,441,759,682])add_block('built-in/Outport',[sys,'/',['Pulse',13,'Generator/out_1']])set_param([sys,'/',['Pulse',13,'Generator/out_1']],...		'hide name',0,...		'position',[560,105,580,125])add_block('built-in/Gain',[sys,'/',['Pulse',13,'Generator/Gain']])set_param([sys,'/',['Pulse',13,'Generator/Gain']],...		'hide name',0,...		'Gain','ht',...		'position',[510,102,535,128])add_block('built-in/Product',[sys,'/',['Pulse',13,'Generator/Product']])set_param([sys,'/',['Pulse',13,'Generator/Product']],...		'hide name',0,...		'position',[455,105,480,125])add_block('built-in/Logical Operator',[sys,'/',['Pulse',13,'Generator/Logical',13,'Operator1']])set_param([sys,'/',['Pulse',13,'Generator/Logical',13,'Operator1']],...		'Operator','NOT',...		'Number of Input Ports','1',...		'position',[355,38,385,62])add_block('built-in/Logical Operator',[sys,'/',['Pulse',13,'Generator/Logical',13,'Operator']])set_param([sys,'/',['Pulse',13,'Generator/Logical',13,'Operator']],...		'Operator','XOR',...		'position',[285,38,315,62])add_block('built-in/Constant',[sys,'/',['Pulse',13,'Generator/Constant1']])set_param([sys,'/',['Pulse',13,'Generator/Constant1']],...		'Value','stt',...		'position',[295,149,320,171])add_block('built-in/Clock',[sys,'/',['Pulse',13,'Generator/Clock1']])set_param([sys,'/',['Pulse',13,'Generator/Clock1']],...		'hide name',0,...		'position',[295,100,315,120])add_block('built-in/Relational Operator',[sys,'/',['Pulse',13,'Generator/Relational',13,'operator']])set_param([sys,'/',['Pulse',13,'Generator/Relational',13,'operator']],...		'hide name',0,...		'position',[370,102,400,133])add_block('built-in/Sum',[sys,'/',['Pulse',13,'Generator/Sum1']])set_param([sys,'/',['Pulse',13,'Generator/Sum1']],...		'hide name',0,...		'inputs','+-',...		'position',[130,120,150,140])add_block('built-in/Sum',[sys,'/',['Pulse',13,'Generator/Sum']])set_param([sys,'/',['Pulse',13,'Generator/Sum']],...		'hide name',0,...		'inputs','+-',...		'position',[135,35,155,55])add_block('built-in/Constant',[sys,'/',['Pulse',13,'Generator/Constant']])set_param([sys,'/',['Pulse',13,'Generator/Constant']],...		'position',[25,30,45,50])add_block('built-in/Unit Delay',[sys,'/',['Pulse',13,'Generator/Unit Delay']])set_param([sys,'/',['Pulse',13,'Generator/Unit Delay']],...		'orientation',2,...		'Sample time','[Ts,st1]',...		'position',[145,75,195,95])add_block('built-in/Unit Delay',[sys,'/',['Pulse',13,'Generator/Unit Delay1']])set_param([sys,'/',['Pulse',13,'Generator/Unit Delay1']],...		'orientation',2,...		'Sample time','[Ts,st2]',...		'x0','ini',...		'position',[140,165,190,185])add_line([sys,'/',['Pulse',13,'Generator']],[390,50;430,50;430,110;450,110])add_line([sys,'/',['Pulse',13,'Generator']],[320,50;350,50])add_line([sys,'/',['Pulse',13,'Generator']],[325,160;345,160;345,125;365,125])add_line([sys,'/',['Pulse',13,'Generator']],[540,115;555,115])add_line([sys,'/',['Pulse',13,'Generator']],[485,115;505,115])add_line([sys,'/',['Pulse',13,'Generator']],[405,120;450,120])add_line([sys,'/',['Pulse',13,'Generator']],[320,110;365,110])add_line([sys,'/',['Pulse',13,'Generator']],[140,85;105,85;105,50;130,50])add_line([sys,'/',['Pulse',13,'Generator']],[160,45;230,45;230,85;200,85])add_line([sys,'/',['Pulse',13,'Generator']],[50,40;130,40])add_line([sys,'/',['Pulse',13,'Generator']],[155,130;210,130;210,175;195,175])add_line([sys,'/',['Pulse',13,'Generator']],[135,175;100,175;100,135;125,135])add_line([sys,'/',['Pulse',13,'Generator']],[50,40;70,40;70,125;125,125])add_line([sys,'/',['Pulse',13,'Generator']],[160,45;280,45])add_line([sys,'/',['Pulse',13,'Generator']],[155,130;245,130;245,55;280,55])set_param([sys,'/',['Pulse',13,'Generator']],...		'Mask Display','plot(0,0,100,100,[90,75,75,60,60,35,35,20,20,10],[20,20,80,80,20,20,80,80,20,20])',...		'Mask Type','Pulse Generator')set_param([sys,'/',['Pulse',13,'Generator']],...		'Mask Dialogue','Pulse Generator.|Pulse period (secs):|Pulse width:|Pulse height:|Pulse start time:')set_param([sys,'/',['Pulse',13,'Generator']],...		'Mask Translate','Ts=@1; du=@2; ht=@3; stt=@4; ini=ones(length(ht),1); st1=rem(stt,Ts); st2=rem(stt+du,Ts);if(Ts<=1.2*du),ini=zeros(length(ht),1);end;')set_param([sys,'/',['Pulse',13,'Generator']],...		'Mask Help','Pulse generator which ensures pulse\ntransitions are hit. Provides a vector of pulses when the height is entered as a vector.\nUnmask to see how it works.')set_param([sys,'/',['Pulse',13,'Generator']],...		'Mask Entries','.5\/.04\/2\/.1\/')%     Finished composite block ['Pulse',13,'Generator'].set_param([sys,'/',['Pulse',13,'Generator']],...		'hide name',0,...		'position',[115,7,150,43])add_block('built-in/Signal Generator',[sys,'/','Sig Gen'])set_param([sys,'/','Sig Gen'],...		'hide name',0,...		'Peak','1.000000',...		'Peak Range','5.000000',...		'Freq','10.000000',...		'Freq Range','100.000000',...		'Wave','Sqr',...		'Units','Rads',...		'position',[175,8,220,42])add_block('built-in/Clock',[sys,'/','tbClock'])set_param([sys,'/','tbClock'],...		'position',[340,252,365,278])add_block('built-in/Gain',[sys,'/','phasic gain'])set_param([sys,'/','phasic gain'],...		'hide name',0,...		'Gain','1.0',...		'position',[215,265,255,305])add_block('built-in/From Workspace',[sys,'/',['From',13,'Workspace']])set_param([sys,'/',['From',13,'Workspace']],...		'hide name',0,...		'matl_expr','[0,0]',...		'position',[370,12,410,38])add_block('built-in/From Workspace',[sys,'/',['Ramp Step',13,'Ramp']])set_param([sys,'/',['Ramp Step',13,'Ramp']],...		'hide name',0,...		'matl_expr','[0, t_on, t_on, dur; initval, (t_on*slope)+initval, (t_on*slope)+(step+initval), (dur*slope)+(step+initval) ]''',...		'Mask Display','Ramp Step\nRamp')set_param([sys,'/',['Ramp Step',13,'Ramp']],...		'Mask Dialogue','Ramp Step Ramp|Initial value|Time of step|Size of step|Ramp duration|Ramp slope',...		'Mask Translate','initval = @1; t_on = @2; step = @3; dur = @4; slope = @5;')set_param([sys,'/',['Ramp Step',13,'Ramp']],...		'Mask Entries','0\/0\/0\/10\/1\/',...		'position',[25,18,95,52])add_block('built-in/From Workspace',[sys,'/','pulse step'])set_param([sys,'/','pulse step'],...		'hide name',0,...		'matl_expr','[0, t_on, t_on+.001, t_on+dur,t_on+dur+.001 500000; 0, 0,peakval,peakval,0,0]''',...		'Mask Display','Pulse')set_param([sys,'/','pulse step'],...		'Mask Dialogue','Pulse|Peak value|Time of step|Step duration',...		'Mask Translate','peakval = @1; t_on = @2; dur = @3; ',...		'Mask Entries','5\/0\/.02\/',...		'position',[40,223,85,257])%     Subsystem  'Subsystem'.new_system([sys,'/','Subsystem'])set_param([sys,'/','Subsystem'],'Location',[597,187,929,382])open_system([sys,'/','Subsystem'])add_block('built-in/Note',[sys,'/','Subsystem/y = mx + b'])set_param([sys,'/','Subsystem/y = mx + b'],...		'position',[40,10,45,15])add_block('built-in/Inport',[sys,'/','Subsystem/in_1'])set_param([sys,'/','Subsystem/in_1'],...		'position',[30,65,50,85])add_block('built-in/Sum',[sys,'/','Subsystem/Sum'])set_param([sys,'/','Subsystem/Sum'],...		'position',[170,70,190,90])add_block('built-in/Gain',[sys,'/','Subsystem/slope'])set_param([sys,'/','Subsystem/slope'],...		'Gain','slope',...		'position',[80,54,125,96])add_block('built-in/Constant',[sys,'/','Subsystem/intercept'])set_param([sys,'/','Subsystem/intercept'],...		'Value','intercept',...		'position',[75,125,130,155])add_block('built-in/Outport',[sys,'/','Subsystem/out_1'])set_param([sys,'/','Subsystem/out_1'],...		'position',[285,70,305,90])add_block('built-in/Saturation',[sys,'/','Subsystem/Saturation'])set_param([sys,'/','Subsystem/Saturation'],...		'Lower Limit','0',...		'Upper Limit','50',...		'position',[225,68,255,92])add_line([sys,'/','Subsystem'],[55,75;75,75])add_line([sys,'/','Subsystem'],[135,140;145,140;145,85;165,85])add_line([sys,'/','Subsystem'],[130,75;165,75])add_line([sys,'/','Subsystem'],[195,80;220,80])add_line([sys,'/','Subsystem'],[260,80;280,80])set_param([sys,'/','Subsystem'],...		'Mask Display','Alexander''s\nLaw',...		'Mask Dialogue','Alexander''s Law|Slope|Intercept',...		'Mask Translate','slope=@1;intercept=@2;',...		'Mask Entries','5\/0\/')%     Finished composite block 'Subsystem'.set_param([sys,'/','Subsystem'],...		'hide name',0,...		'position',[205,153,270,197])add_block('built-in/Constant',[sys,'/',['Threshold',13,'1']])set_param([sys,'/',['Threshold',13,'1']],...		'hide name',0,...		'Value','0',...		'position',[35,170,65,190])add_block('built-in/From Workspace',[sys,'/','double pulse4'])set_param([sys,'/','double pulse4'],...		'hide name',0,...		'matl_expr','[0, t1, t1+.001, t1+d1, t1+d1+.001, t1+d1+.001+ipd, t1+d1+.001+ipd, t1+d1+.001+ipd+d2, t1+d1+.001+ipd+d2, 10000; 0, 0, p1, p1, 0, 0, p2, p2, 0, 0 ]''')set_param([sys,'/','double pulse4'],...		'Mask Display','Double\nPulse',...		'Mask Dialogue','Double Pulse|Pulse 1 Magnitude|Time of Pulse 1 Onset|Pulse 1 Duration|Interpulse Delay|Pulse 2 Magnitude|Pulse 2 Duration')set_param([sys,'/','double pulse4'],...		'Mask Translate','p1=@1; t1=@2; d1=@3; ipd=@4; p2=@5; d2=@6;',...		'Mask Entries','45\/0\/1\/0\/45\/1\/',...		'position',[30,113,85,147])add_line(sys,[370,265;390,265])add_line(sys,[390,135;410,135])add_line(sys,[90,240;390,240])add_line(sys,[155,175;180,175;180,125;350,125])add_line(sys,[70,180;120,180])add_line(sys,[90,130;110,130;120,165])add_line(sys,[330,125;330,105;410,105])add_line(sys,[275,175;410,175])add_line(sys,[325,175;325,145;350,145])add_line(sys,[180,175;200,175])drawnow% Return any arguments.if (nargin | nargout)	% Must use feval here to access system in memory	if (nargin > 3)		if (flag == 0)			eval(['[ret,x0,str,ts,xts]=',sys,'(t,x,u,flag);'])		else			eval(['ret =', sys,'(t,x,u,flag);'])		end	else		[ret,x0,str,ts,xts] = feval(sys);	endelse	drawnow % Flash up the model and execute load callbackend