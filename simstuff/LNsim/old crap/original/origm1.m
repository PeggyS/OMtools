function [ret,x0,str,ts,xts]=m1(t,x,u,flag);%M1	is the M-file description of the SIMULINK system named M1.%	The block-diagram can be displayed by typing: M1.%%	SYS=M1(T,X,U,FLAG) returns depending on FLAG certain%	system values given time point, T, current state vector, X,%	and input vector, U.%	FLAG is used to indicate the type of output to be returned in SYS.%%	Setting FLAG=1 causes M1 to return state derivatives, FLAG=2%	discrete states, FLAG=3 system outputs and FLAG=4 next sample%	time. For more information and other options see SFUNC.%%	Calling M1 with a FLAG of zero:%	[SIZES]=M1([],[],[],0),  returns a vector, SIZES, which%	contains the sizes of the state vector and other parameters.%		SIZES(1) number of states%		SIZES(2) number of discrete states%		SIZES(3) number of outputs%		SIZES(4) number of inputs%		SIZES(5) number of roots (currently unsupported)%		SIZES(6) direct feedthrough flag%		SIZES(7) number of sample times%%	For the definition of other parameters in SIZES, see SFUNC.%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.% Note: This M-file is only used for saving graphical information;%       after the model is loaded into memory an internal model%       representation is used.% the system will take on the name of this mfile:sys = mfilename;new_system(sys)simver(1.3)if (0 == (nargin + nargout))     set_param(sys,'Location',[2,40,626,466])     open_system(sys)end;set_param(sys,'algorithm',     'RK-45')set_param(sys,'Start time',    '0.0')set_param(sys,'Stop time',     '6.0')set_param(sys,'Min step size', '0.001')set_param(sys,'Max step size', '0.001')set_param(sys,'Relative error','1e-7')set_param(sys,'Return vars',   '')set_param(sys,'AssignWideVectorLines','on');add_block('built-in/Sum',[sys,'/','Sum'])set_param([sys,'/','Sum'],...		'hide name',0,...		'inputs','-+',...		'position',[85,55,105,75])%     Subsystem  'trgtpos'.new_system([sys,'/','trgtpos'])set_param([sys,'/','trgtpos'],'Location',[246,408,340,408])add_block('built-in/Outport',[sys,'/','trgtpos/out_1'])set_param([sys,'/','trgtpos/out_1'],...		'position',[320,130,340,150])add_block('built-in/Gain',[sys,'/','trgtpos/Gain'])set_param([sys,'/','trgtpos/Gain'],...		'Gain','0.0',...		'position',[155,92,180,118])add_block('built-in/Gain',[sys,'/','trgtpos/Gain1'])set_param([sys,'/','trgtpos/Gain1'],...		'Gain','0.0',...		'position',[155,162,180,188])add_block('built-in/Step Fcn',[sys,'/','trgtpos/Step Input'])set_param([sys,'/','trgtpos/Step Input'],...		'Time','0',...		'position',[70,95,90,115])add_block('built-in/Sum',[sys,'/','trgtpos/Sum'])set_param([sys,'/','trgtpos/Sum'],...		'hide name',0,...		'position',[270,130,290,150])add_block('built-in/Step Fcn',[sys,'/','trgtpos/Step Input1'])set_param([sys,'/','trgtpos/Step Input1'],...		'Time','4.0',...		'After','1.0',...		'position',[70,165,90,185])add_line([sys,'/','trgtpos'],[295,140;315,140])add_line([sys,'/','trgtpos'],[95,105;150,105])add_line([sys,'/','trgtpos'],[95,175;150,175])add_line([sys,'/','trgtpos'],[185,105;220,105;220,135;265,135])add_line([sys,'/','trgtpos'],[185,175;220,175;220,145;265,145])set_param([sys,'/','trgtpos'],...		'Mask Display','Target\nPosition')%     Finished composite block 'trgtpos'.set_param([sys,'/','trgtpos'],...		'hide name',0,...		'position',[10,52,55,88])add_block('built-in/Gain',[sys,'/',['Gain',13,'_']])set_param([sys,'/',['Gain',13,'_']],...		'hide name',0,...		'Gain','1.0',...		'position',[295,41,330,69])add_block('built-in/Transport Delay',[sys,'/',['Transport',13,'Delay3']])set_param([sys,'/',['Transport',13,'Delay3']],...		'hide name',0,...		'Delay Time','0.100',...		'Mask Display','100\nms',...		'position',[115,120,140,150])add_block('built-in/Transport Delay',[sys,'/',['Transport',13,'Delay']])set_param([sys,'/',['Transport',13,'Delay']],...		'orientation',1,...		'hide name',0,...		'Delay Time','0.100',...		'Mask Display','100\nms',...		'position',[11,125,39,155])%     Subsystem  'plselin'.new_system([sys,'/','plselin'])set_param([sys,'/','plselin'],'Location',[2,57,626,408])%     Subsystem  'plselin/rstint2'.new_system([sys,'/','plselin/rstint2'])set_param([sys,'/','plselin/rstint2'],'Location',[87,75,622,445])add_block('built-in/Abs',[sys,'/','plselin/rstint2/Abs'])set_param([sys,'/','plselin/rstint2/Abs'],...		'position',[130,293,160,317])add_block('built-in/Dead Zone',[sys,'/','plselin/rstint2/Dead Zone'])set_param([sys,'/','plselin/rstint2/Dead Zone'],...		'Lower_value','0.05',...		'Upper_value','-0.05',...		'position',[130,92,160,118])add_block('built-in/Constant',[sys,'/','plselin/rstint2/Constant1'])set_param([sys,'/','plselin/rstint2/Constant1'],...		'Value','-0.05',...		'position',[130,35,150,55])add_block('built-in/Sum',[sys,'/','plselin/rstint2/Sum'])set_param([sys,'/','plselin/rstint2/Sum'],...		'position',[200,90,220,110])add_block('built-in/Gain',[sys,'/','plselin/rstint2/Gain2'])set_param([sys,'/','plselin/rstint2/Gain2'],...		'Gain','1000',...		'position',[245,87,270,113])add_block('built-in/Saturation',[sys,'/','plselin/rstint2/Saturation'])set_param([sys,'/','plselin/rstint2/Saturation'],...		'Lower Limit','0.0',...		'Upper Limit','1.0',...		'position',[305,88,335,112])add_block('built-in/Sum',[sys,'/','plselin/rstint2/Sum2'])set_param([sys,'/','plselin/rstint2/Sum2'],...		'position',[385,85,405,105])add_block('built-in/Sum',[sys,'/','plselin/rstint2/Sum3'])set_param([sys,'/','plselin/rstint2/Sum3'],...		'position',[335,290,355,310])add_block('built-in/Gain',[sys,'/','plselin/rstint2/Gain'])set_param([sys,'/','plselin/rstint2/Gain'],...		'orientation',2,...		'Gain','1000',...		'position',[350,157,375,183])add_block('built-in/Product',[sys,'/','plselin/rstint2/Product2'])set_param([sys,'/','plselin/rstint2/Product2'],...		'orientation',2,...		'position',[255,148,285,172])add_block('built-in/Constant',[sys,'/','plselin/rstint2/Constant'])set_param([sys,'/','plselin/rstint2/Constant'],...		'Value','-1',...		'position',[250,35,270,55])add_block('built-in/Integrator',[sys,'/','plselin/rstint2/Integrator'])set_param([sys,'/','plselin/rstint2/Integrator'],...		'position',[400,290,420,310])add_block('built-in/Outport',[sys,'/','plselin/rstint2/out_1'])set_param([sys,'/','plselin/rstint2/out_1'],...		'position',[515,290,535,310])add_block('built-in/Inport',[sys,'/','plselin/rstint2/in_1'])set_param([sys,'/','plselin/rstint2/in_1'],...		'position',[50,295,70,315])add_line([sys,'/','plselin/rstint2'],[165,305;330,305])add_line([sys,'/','plselin/rstint2'],[195,305;195,255;50,255;50,105;125,105])add_line([sys,'/','plselin/rstint2'],[75,305;125,305])add_line([sys,'/','plselin/rstint2'],[250,160;225,160;225,250;300,250;300,295;330,295])add_line([sys,'/','plselin/rstint2'],[425,300;465,300;465,170;380,170])add_line([sys,'/','plselin/rstint2'],[465,300;510,300])add_line([sys,'/','plselin/rstint2'],[155,45;180,45;180,95;195,95])add_line([sys,'/','plselin/rstint2'],[165,105;195,105])add_line([sys,'/','plselin/rstint2'],[225,100;240,100])add_line([sys,'/','plselin/rstint2'],[360,300;395,300])add_line([sys,'/','plselin/rstint2'],[410,95;450,95;450,145;325,145;325,155;290,155])add_line([sys,'/','plselin/rstint2'],[345,170;325,170;325,165;290,165])add_line([sys,'/','plselin/rstint2'],[275,45;360,45;360,90;380,90])add_line([sys,'/','plselin/rstint2'],[275,100;300,100])add_line([sys,'/','plselin/rstint2'],[340,100;380,100])%     Finished composite block 'plselin/rstint2'.set_param([sys,'/','plselin/rstint2'],...		'position',[385,135,415,185])add_block('built-in/Saturation',[sys,'/','plselin/Saturation'])set_param([sys,'/','plselin/Saturation'],...		'hide name',0,...		'Lower Limit','-0.0',...		'Upper Limit','1.0',...		'position',[315,148,345,172])add_block('built-in/Switch',[sys,'/','plselin/Switch'])set_param([sys,'/','plselin/Switch'],...		'Threshold','0.0',...		'position',[595,139,625,171])add_block('built-in/Constant',[sys,'/','plselin/Constant'])set_param([sys,'/','plselin/Constant'],...		'Value','0.0',...		'position',[515,80,535,100])add_block('built-in/Gain',[sys,'/','plselin/Gain3'])set_param([sys,'/','plselin/Gain3'],...		'orientation',2,...		'Gain','1000',...		'position',[445,372,470,398])add_block('built-in/Transport Delay',[sys,'/',['plselin/Transport',13,'Delay1']])set_param([sys,'/',['plselin/Transport',13,'Delay1']],...		'orientation',2,...		'Delay Time','0.001',...		'position',[355,370,395,400])add_block('built-in/Saturation',[sys,'/','plselin/Saturation2'])set_param([sys,'/','plselin/Saturation2'],...		'orientation',2,...		'Lower Limit','0.0',...		'Upper Limit','1.0',...		'position',[235,373,265,397])add_block('built-in/Fcn',[sys,'/',['plselin/Amplitude',13,'Nonlinearity',13,'']])set_param([sys,'/',['plselin/Amplitude',13,'Nonlinearity',13,'']],...		'hide name',0,...		'Expr','615*u[1]/(9.2+u[1])',...		'position',[275,320,315,340])add_block('built-in/Transport Delay',[sys,'/',['plselin/Transport',13,'Delay']])set_param([sys,'/',['plselin/Transport',13,'Delay']],...		'hide name',0,...		'Delay Time','0.001',...		'position',[155,100,195,130])add_block('built-in/Sum',[sys,'/','plselin/Sum'])set_param([sys,'/','plselin/Sum'],...		'inputs','+++',...		'position',[505,197,525,243])add_block('built-in/Constant',[sys,'/','plselin/Constant1'])set_param([sys,'/','plselin/Constant1'],...		'Value','0.0',...		'position',[265,110,285,130])add_block('built-in/Switch',[sys,'/','plselin/Switch1'])set_param([sys,'/','plselin/Switch1'],...		'hide name',0,...		'Threshold','0.040',...		'position',[315,79,345,111])add_block('built-in/Gain',[sys,'/','plselin/Gain4'])set_param([sys,'/','plselin/Gain4'],...		'hide name',0,...		'Gain','-1',...		'position',[380,82,405,108])add_block('built-in/Sum',[sys,'/','plselin/Sum1'])set_param([sys,'/','plselin/Sum1'],...		'hide name',0,...		'inputs','+-',...		'position',[245,85,265,105])add_block('built-in/Fcn',[sys,'/','plselin/Fcn'])set_param([sys,'/','plselin/Fcn'],...		'Expr','u[1]*100',...		'position',[240,150,280,170])add_block('built-in/Saturation',[sys,'/','plselin/Saturation1'])set_param([sys,'/','plselin/Saturation1'],...		'hide name',0,...		'Lower Limit','0.0',...		'Upper Limit','1.0',...		'position',[310,263,340,287])add_block('built-in/Gain',[sys,'/','plselin/Gain'])set_param([sys,'/','plselin/Gain'],...		'hide name',0,...		'Gain','100',...		'position',[250,262,275,288])add_block('built-in/Fcn',[sys,'/','plselin/Fcn1'])set_param([sys,'/','plselin/Fcn1'],...		'hide name',0,...		'Expr','-0.0102- u[1]*0.001248',...		'position',[305,220,345,240])add_block('built-in/Product',[sys,'/','plselin/Product1'])set_param([sys,'/','plselin/Product1'],...		'hide name',0,...		'position',[410,223,440,247])add_block('built-in/Saturation',[sys,'/','plselin/Saturation3'])set_param([sys,'/','plselin/Saturation3'],...		'hide name',0,...		'Lower Limit','-0.002',...		'Upper Limit','0.00',...		'position',[435,83,465,107])add_block('built-in/Product',[sys,'/','plselin/Product'])set_param([sys,'/','plselin/Product'],...		'position',[140,148,170,172])add_block('built-in/Outport',[sys,'/','plselin/out_1'])set_param([sys,'/','plselin/out_1'],...		'position',[650,145,670,165])add_block('built-in/Inport',[sys,'/','plselin/in_1'])set_param([sys,'/','plselin/in_1'],...		'position',[15,145,35,165])add_line([sys,'/','plselin'],[40,155;60,155;60,330;270,330])add_line([sys,'/','plselin'],[60,155;135,155])add_line([sys,'/','plselin'],[60,155;60,115;150,115])add_line([sys,'/','plselin'],[60,115;60,90;240,90])add_line([sys,'/','plselin'],[630,155;645,155])add_line([sys,'/','plselin'],[540,90;570,90;570,145;590,145])add_line([sys,'/','plselin'],[290,120;295,120;295,105;310,105])add_line([sys,'/','plselin'],[270,95;275,85;310,85])add_line([sys,'/','plselin'],[270,95;310,95])add_line([sys,'/','plselin'],[350,95;375,95])add_line([sys,'/','plselin'],[350,385;270,385])add_line([sys,'/','plselin'],[420,160;465,160;465,220;500,220])add_line([sys,'/','plselin'],[350,160;380,160])add_line([sys,'/','plselin'],[440,385;400,385])add_line([sys,'/','plselin'],[280,275;305,275])add_line([sys,'/','plselin'],[345,275;370,275;370,240;405,240])add_line([sys,'/','plselin'],[175,160;210,160;210,230;300,230])add_line([sys,'/','plselin'],[210,230;210,275;245,275])add_line([sys,'/','plselin'],[350,230;405,230])add_line([sys,'/','plselin'],[445,235;500,235])add_line([sys,'/','plselin'],[200,115;225,115;225,100;240,100])add_line([sys,'/','plselin'],[210,160;235,160])add_line([sys,'/','plselin'],[285,160;310,160])add_line([sys,'/','plselin'],[630,155;635,155;635,385;475,385])add_line([sys,'/','plselin'],[230,385;100,385;100,165;135,165])add_line([sys,'/','plselin'],[470,95;490,95;500,205])add_line([sys,'/','plselin'],[410,95;430,95])add_line([sys,'/','plselin'],[530,220;575,220;575,155;590,155])add_line([sys,'/','plselin'],[320,330;580,330;590,165])set_param([sys,'/','plselin'],...		'Mask Display','P.G.')%     Finished composite block 'plselin'.set_param([sys,'/','plselin'],...		'hide name',0,...		'position',[155,121,180,149])add_block('built-in/Gain',[sys,'/','Gain'])set_param([sys,'/','Gain'],...		'hide name',0,...		'Gain','0.25',...		'position',[200,120,240,150])add_block('built-in/Gain',[sys,'/',['Gain',13,'']])set_param([sys,'/',['Gain',13,'']],...		'hide name',0,...		'Gain','5.33',...		'position',[260,121,295,149])%     Subsystem  'NI1'.new_system([sys,'/','NI1'])set_param([sys,'/','NI1'],'Location',[35,206,485,536])add_block('built-in/Transport Delay',[sys,'/',['NI1/Transport',13,'Delay']])set_param([sys,'/',['NI1/Transport',13,'Delay']],...		'orientation',3,...		'hide name',0,...		'Delay Time','0.100',...		'position',[125,210,165,240])add_block('built-in/Inport',[sys,'/','NI1/from_ratio'])set_param([sys,'/','NI1/from_ratio'],...		'Port','3',...		'position',[80,260,100,280])add_block('built-in/Inport',[sys,'/','NI1/timbal'])set_param([sys,'/','NI1/timbal'],...		'Port','2',...		'position',[35,170,55,190])add_block('built-in/Outport',[sys,'/','NI1/out_1'])set_param([sys,'/','NI1/out_1'],...		'position',[415,135,435,155])add_block('built-in/Inport',[sys,'/','NI1/in_1'])set_param([sys,'/','NI1/in_1'],...		'position',[45,55,65,75])add_block('built-in/Product',[sys,'/','NI1/Product'])set_param([sys,'/','NI1/Product'],...		'hide name',0,...		'position',[205,108,235,132])add_block('built-in/Sum',[sys,'/','NI1/Sum'])set_param([sys,'/','NI1/Sum'],...		'hide name',0,...		'inputs','+-',...		'position',[280,135,300,155])add_block('built-in/Integrator',[sys,'/','NI1/Integrator'])set_param([sys,'/','NI1/Integrator'],...		'hide name',0,...		'position',[345,135,365,155])add_line([sys,'/','NI1'],[105,270;145,270;145,245])add_line([sys,'/','NI1'],[240,120;255,120;255,140;275,140])add_line([sys,'/','NI1'],[370,145;410,145])add_line([sys,'/','NI1'],[305,145;340,145])add_line([sys,'/','NI1'],[70,65;145,65;145,115;200,115])add_line([sys,'/','NI1'],[60,180;255,180;255,150;275,150])add_line([sys,'/','NI1'],[145,205;145,125;200,125])set_param([sys,'/','NI1'],...		'Mask Display','Neural\nIntegrator')%     Finished composite block 'NI1'.set_param([sys,'/','NI1'],...		'hide name',0,...		'position',[320,126,375,164])%     Subsystem  ['timbal',13,''].new_system([sys,'/',['timbal',13,'']])set_param([sys,'/',['timbal',13,'']],'Location',[157,119,622,459])add_block('built-in/Gain',[sys,'/',['timbal',13,'/Gain']])set_param([sys,'/',['timbal',13,'/Gain']],...		'hide name',0,...		'Gain','1.0',...		'position',[270,87,295,113])add_block('built-in/Outport',[sys,'/',['timbal',13,'/out_1']])set_param([sys,'/',['timbal',13,'/out_1']],...		'position',[345,90,365,110])add_block('built-in/Gain',[sys,'/',['timbal',13,'/Gain1']])set_param([sys,'/',['timbal',13,'/Gain1']],...		'hide name',0,...		'Gain','0.65',...		'position',[105,117,155,153])add_block('built-in/Gain',[sys,'/',['timbal',13,'/Gain2']])set_param([sys,'/',['timbal',13,'/Gain2']],...		'hide name',0,...		'Gain','0.35',...		'position',[105,46,155,84])add_block('built-in/Step Fcn',[sys,'/',['timbal',13,'/Step Input']])set_param([sys,'/',['timbal',13,'/Step Input']],...		'hide name',0,...		'Time','0.0',...		'position',[55,55,75,75])add_block('built-in/Sum',[sys,'/',['timbal',13,'/Sum1']])set_param([sys,'/',['timbal',13,'/Sum1']],...		'hide name',0,...		'position',[210,90,230,110])add_block('built-in/Step Fcn',[sys,'/',['timbal',13,'/Step Input2']])set_param([sys,'/',['timbal',13,'/Step Input2']],...		'hide name',0,...		'Time','3.0',...		'position',[55,125,75,145])add_line([sys,'/',['timbal',13,'']],[300,100;340,100])add_line([sys,'/',['timbal',13,'']],[235,100;265,100])add_line([sys,'/',['timbal',13,'']],[80,65;100,65])add_line([sys,'/',['timbal',13,'']],[80,135;100,135])add_line([sys,'/',['timbal',13,'']],[160,65;185,65;185,95;205,95])add_line([sys,'/',['timbal',13,'']],[160,135;185,135;185,105;205,105])set_param([sys,'/',['timbal',13,'']],...		'Mask Display','Tonic\nImbalance')%     Finished composite block ['timbal',13,''].set_param([sys,'/',['timbal',13,'']],...		'hide name',0,...		'position',[205,168,265,192])add_block('built-in/Constant',[sys,'/','Constant'])set_param([sys,'/','Constant'],...		'hide name',0,...		'Value','1.0',...		'Mask Display','Switch\nlight (on)\ndark (off)',...		'position',[35,260,85,300])%     Subsystem  'thrshn4'.new_system([sys,'/','thrshn4'])set_param([sys,'/','thrshn4'],'Location',[2,40,626,344])add_block('built-in/Note',[sys,'/',['thrshn4/The pulse size to P.G. is the ',13,'difference between tprime and',13,'the output of the Neural Integrator']])set_param([sys,'/',['thrshn4/The pulse size to P.G. is the ',13,'difference between tprime and',13,'the output of the Neural Integrator']],...		'position',[100,215,105,220])add_block('built-in/Switch',[sys,'/','thrshn4/Switch'])set_param([sys,'/','thrshn4/Switch'],...		'hide name',0,...		'position',[445,159,475,191])add_block('built-in/Sum',[sys,'/','thrshn4/Sum'])set_param([sys,'/','thrshn4/Sum'],...		'orientation',3,...		'hide name',0,...		'inputs','+-',...		'position',[299,220,326,245])add_block('built-in/Sum',[sys,'/','thrshn4/Sum3'])set_param([sys,'/','thrshn4/Sum3'],...		'hide name',0,...		'inputs','+-',...		'position',[165,294,190,321])add_block('built-in/Inport',[sys,'/','thrshn4/from_tprime'])set_param([sys,'/','thrshn4/from_tprime'],...		'Port','2',...		'position',[35,290,55,310])add_block('built-in/Inport',[sys,'/','thrshn4/threshold'])set_param([sys,'/','thrshn4/threshold'],...		'orientation',2,...		'position',[520,250,540,270])add_block('built-in/Inport',[sys,'/','thrshn4/from_NI'])set_param([sys,'/','thrshn4/from_NI'],...		'orientation',2,...		'Port','3',...		'position',[520,340,540,360])add_block('built-in/Note',[sys,'/',['thrshn4/This comparator is for voluntary',13,'saccades with or without ',13,' LN (foveating fast phases).']])set_param([sys,'/',['thrshn4/This comparator is for voluntary',13,'saccades with or without ',13,' LN (foveating fast phases).']],...		'position',[85,145,120,150])add_block('built-in/Outport',[sys,'/','thrshn4/ratio_to_NI'])set_param([sys,'/','thrshn4/ratio_to_NI'],...		'position',[260,45,280,65])add_block('built-in/Constant',[sys,'/','thrshn4/Constant1'])set_param([sys,'/','thrshn4/Constant1'],...		'position',[160,45,180,65])add_block('built-in/Outport',[sys,'/','thrshn4/to_PG'])set_param([sys,'/','thrshn4/to_PG'],...		'Port','2',...		'position',[555,85,575,105])add_block('built-in/Constant',[sys,'/','thrshn4/Constant'])set_param([sys,'/','thrshn4/Constant'],...		'Value','0.0',...		'position',[365,200,395,220])add_line([sys,'/','thrshn4'],[195,310;225,310;225,265;305,265;305,250])add_line([sys,'/','thrshn4'],[225,265;225,165;440,165])add_line([sys,'/','thrshn4'],[185,55;255,55])add_line([sys,'/','thrshn4'],[400,210;405,210;405,185;440,185])add_line([sys,'/','thrshn4'],[315,215;315,175;440,175])add_line([sys,'/','thrshn4'],[515,260;320,250])add_line([sys,'/','thrshn4'],[60,300;160,300])add_line([sys,'/','thrshn4'],[515,350;130,350;130,315;160,315])add_line([sys,'/','thrshn4'],[480,175;505,175;505,95;550,95])set_param([sys,'/','thrshn4'],...		'Mask Display','Internal\nMonitor')%     Finished composite block 'thrshn4'.set_param([sys,'/','thrshn4'],...		'orientation',2,...		'hide name',0,...		'position',[175,217,260,263])%     Subsystem  'Tprime1'.new_system([sys,'/','Tprime1'])set_param([sys,'/','Tprime1'],'Location',[2,57,626,462])add_block('built-in/Inport',[sys,'/','Tprime1/in_3'])set_param([sys,'/','Tprime1/in_3'],...		'Port','3',...		'position',[50,275,70,295])add_block('built-in/Outport',[sys,'/','Tprime1/out_1'])set_param([sys,'/','Tprime1/out_1'],...		'position',[590,225,610,245])add_block('built-in/Inport',[sys,'/','Tprime1/in_2'])set_param([sys,'/','Tprime1/in_2'],...		'Port','2',...		'position',[50,210,70,230])add_block('built-in/Inport',[sys,'/','Tprime1/in_1'])set_param([sys,'/','Tprime1/in_1'],...		'position',[50,155,70,175])add_block('built-in/Product',[sys,'/','Tprime1/Product'])set_param([sys,'/','Tprime1/Product'],...		'position',[315,228,345,252])add_block('built-in/Gain',[sys,'/','Tprime1/Gain1'])set_param([sys,'/','Tprime1/Gain1'],...		'Gain','1.0',...		'position',[225,232,250,258])add_block('built-in/Sum',[sys,'/','Tprime1/Sum'])set_param([sys,'/','Tprime1/Sum'],...		'hide name',0,...		'position',[155,226,175,264])add_block('built-in/Step Fcn',[sys,'/','Tprime1/Step Input1'])set_param([sys,'/','Tprime1/Step Input1'],...		'hide name',0,...		'Time','0',...		'After','0',...		'position',[175,45,195,65])add_block('built-in/Step Fcn',[sys,'/','Tprime1/Step Input'])set_param([sys,'/','Tprime1/Step Input'],...		'hide name',0,...		'Time','4.0',...		'position',[175,100,195,120])add_block('built-in/Gain',[sys,'/','Tprime1/Gain2'])set_param([sys,'/','Tprime1/Gain2'],...		'Gain','0',...		'position',[220,42,245,68])add_block('built-in/Gain',[sys,'/','Tprime1/Gain3'])set_param([sys,'/','Tprime1/Gain3'],...		'Gain','0.0',...		'position',[220,97,245,123])add_block('built-in/Sum',[sys,'/','Tprime1/Sum1'])set_param([sys,'/','Tprime1/Sum1'],...		'hide name',0,...		'position',[280,75,300,95])add_block('built-in/Gain',[sys,'/','Tprime1/Gain4'])set_param([sys,'/','Tprime1/Gain4'],...		'Gain','1.0',...		'position',[320,72,345,98])add_block('built-in/Constant',[sys,'/','Tprime1/Constant'])set_param([sys,'/','Tprime1/Constant'],...		'Value','-1',...		'position',[320,170,340,190])add_block('built-in/Sum',[sys,'/','Tprime1/Sum3'])set_param([sys,'/','Tprime1/Sum3'],...		'hide name',0,...		'position',[360,145,380,165])add_block('built-in/Abs',[sys,'/','Tprime1/Abs'])set_param([sys,'/','Tprime1/Abs'],...		'hide name',0,...		'position',[395,143,420,167])add_block('built-in/Product',[sys,'/','Tprime1/Product1'])set_param([sys,'/','Tprime1/Product1'],...		'position',[470,119,490,141])add_block('built-in/Sum',[sys,'/','Tprime1/Sum2'])set_param([sys,'/','Tprime1/Sum2'],...		'position',[540,225,560,245])add_line([sys,'/','Tprime1'],[180,245;220,245])add_line([sys,'/','Tprime1'],[200,55;215,55])add_line([sys,'/','Tprime1'],[200,110;215,110])add_line([sys,'/','Tprime1'],[250,55;260,55;260,80;275,80])add_line([sys,'/','Tprime1'],[250,110;260,110;260,90;275,90])add_line([sys,'/','Tprime1'],[565,235;585,235])add_line([sys,'/','Tprime1'],[305,85;315,85])add_line([sys,'/','Tprime1'],[75,220;110,220;110,235;150,235])add_line([sys,'/','Tprime1'],[75,285;110,285;110,255;150,255])add_line([sys,'/','Tprime1'],[255,245;310,245])add_line([sys,'/','Tprime1'],[350,240;535,240])add_line([sys,'/','Tprime1'],[495,130;510,130;510,230;535,230])add_line([sys,'/','Tprime1'],[350,85;400,85;400,125;465,125])add_line([sys,'/','Tprime1'],[345,180;355,160])add_line([sys,'/','Tprime1'],[75,165;185,165;185,205;280,205;280,235;310,235])add_line([sys,'/','Tprime1'],[185,165;185,150;355,150])add_line([sys,'/','Tprime1'],[385,155;390,155])add_line([sys,'/','Tprime1'],[425,155;440,155;440,135;465,135])set_param([sys,'/','Tprime1'],...		'Mask Display','Target\nPosition\n(Internal)')%     Finished composite block 'Tprime1'.set_param([sys,'/','Tprime1'],...		'hide name',0,...		'position',[135,304,190,346])add_block('built-in/To Workspace',[sys,'/','To Workspace2'])set_param([sys,'/','To Workspace2'],...		'hide name',0,...		'mat-name','tprime',...		'buffer','80000',...		'position',[305,317,355,333])add_block('built-in/Sum',[sys,'/',[' Sum',13,'']])set_param([sys,'/',[' Sum',13,'']],...		'hide name',0,...		'position',[410,123,425,152])add_block('built-in/Transport Delay',[sys,'/',['Transport',13,'Delay2']])set_param([sys,'/',['Transport',13,'Delay2']],...		'hide name',0,...		'Delay Time','0.030',...		'Mask Display','30\n ms',...		'position',[445,125,470,155])add_block('built-in/Transfer Fcn',[sys,'/','Transfer Fcn'])set_param([sys,'/','Transfer Fcn'],...		'hide name',0,...		'Numerator','[1.0]',...		'Denominator','[0.00126 0.187 1]',...		'Mask Display','EYE',...		'position',[485,126,515,154])add_block('built-in/To Workspace',[sys,'/','To Workspace'])set_param([sys,'/','To Workspace'],...		'mat-name','eyeout',...		'buffer','80000',...		'position',[545,132,595,148])add_block('built-in/Transport Delay',[sys,'/',['Transport',13,'Delay1']])set_param([sys,'/',['Transport',13,'Delay1']],...		'orientation',2,...		'hide name',0,...		'Delay Time','0.130',...		'Mask Display','130\nms',...		'position',[170,365,210,395])add_block('built-in/Constant',[sys,'/',['Nystagmus',13,'Threshold',13,'']])set_param([sys,'/',['Nystagmus',13,'Threshold',13,'']],...		'orientation',2,...		'hide name',0,...		'Value','0.35',...		'Mask Display','Nystagmus\nThreshold',...		'position',[440,209,500,241])add_block('built-in/To Workspace',[sys,'/','To Workspace1'])set_param([sys,'/','To Workspace1'],...		'mat-name','yout',...		'buffer','80000',...		'position',[525,247,575,263])add_block('built-in/Note',[sys,'/',['Voluntary saccades are not correct because the positive efference copy',13,'into Target Position (internal) does not have the proper dynamics.  (The ',13,'pulse step signal can be used with the eye plant dynamics and 130 ms delay.)',13,'']])set_param([sys,'/',['Voluntary saccades are not correct because the positive efference copy',13,'into Target Position (internal) does not have the proper dynamics.  (The ',13,'pulse step signal can be used with the eye plant dynamics and 130 ms delay.)',13,'']],...		'position',[200,460,205,465])add_block('built-in/Note',[sys,'/',['This model can generate a foveating nystagmus in primary position.',13,'',13,'',13,'']])set_param([sys,'/',['This model can generate a foveating nystagmus in primary position.',13,'',13,'',13,'']],...		'position',[200,425,205,430])add_line(sys,[245,135;255,135])add_line(sys,[185,135;195,135])add_line(sys,[110,65;110,100;25,100;25,120])add_line(sys,[430,140;440,140])add_line(sys,[475,140;480,140])add_line(sys,[145,135;150,135])add_line(sys,[195,325;300,325])add_line(sys,[435,225;265,225])add_line(sys,[195,325;275,325;265,240])add_line(sys,[380,145;405,145])add_line(sys,[300,135;315,135])add_line(sys,[270,180;295,180;295,145;315,145])add_line(sys,[170,230;150,230;150,200;305,200;315,155])add_line(sys,[165,380;80,380;80,340;130,340])add_line(sys,[245,135;245,55;290,55])add_line(sys,[25,160;25,325;130,325])add_line(sys,[90,280;90,310;130,310])add_line(sys,[335,55;395,55;405,130])add_line(sys,[380,145;380,380;215,380])add_line(sys,[60,70;80,70])add_line(sys,[520,140;520,15;70,15;80,60])add_line(sys,[170,255;100,255;110,135])add_line(sys,[380,145;380,255;265,255])add_line(sys,[520,140;540,140])add_line(sys,[380,255;520,255])drawnow% Return any arguments.if (nargin | nargout)	% Must use feval here to access system in memory	if (nargin > 3)		if (flag == 0)			eval(['[ret,x0,str,ts,xts]=',sys,'(t,x,u,flag);'])		else			eval(['ret =', sys,'(t,x,u,flag);'])		end	else		[ret,x0,str,ts,xts] = feval(sys);	endelse	drawnow % Flash up the model and execute load callbackend