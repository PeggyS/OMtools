% PHnew.m: calculate the PG's pulse amplitude based on lots of
% calculations that are explained in THE BIG BOOK OF STUFF

% Written by Jonathan Jacobs
%            November 1997  (last mod: 11/07/97)

function y = PHnew( u )

if abs(u) <= 0.25
   y = abs(u)*20;
 elseif (abs(u)>0.25) & (abs(u)<=0.5)
   y = (abs(u)-0.25)*22.8 + 5;
 elseif (abs(u)>0.5) & (abs(u)<=1.0)
   y = (abs(u)-0.5)*9.1 + 10.7;
 elseif (abs(u)>1) & (abs(u)<=2)
   y = (abs(u)-1)*0.6 + 15.25;
 elseif (abs(u)>2) & (abs(u)<=5)
   y = (abs(u)-2)*5.9667 + 15.85;
 elseif (abs(u)>5) & (abs(u)<=10)
   y = (abs(u)-5)*3.234 + 33.75;
 elseif (abs(u)>10) & (abs(u)<=15)
   y = (abs(u)-10)*2.316 + 49.92;
 elseif (abs(u)>15) & (abs(u)<=20)
   y = (abs(u)-15)*1.1 + 61.5;
 elseif (abs(u)>20) & (abs(u)<=25)
   y = (abs(u)-20)*1.1 + 67;
 elseif (abs(u)>25) & (abs(u)<=30)
   y = (abs(u)-25)*0.5 + 72.5;
 elseif (abs(u)>30) & (abs(u)<=35)
   y = (abs(u)-30)*0.45 + 75;
 elseif (abs(u)>35) & (abs(u)<=40)
   y = (abs(u)-35)*0.75 + 77.25;
 elseif (abs(u)>40) & (abs(u)<=45)
   y = (abs(u)-40)*0.36 + 81;
 elseif (abs(u)>45) & (abs(u)<=50)
   y = (abs(u)-45)*0.34 + 82.8;


end