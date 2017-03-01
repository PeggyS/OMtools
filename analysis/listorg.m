% listorg.m: calculate Listing's Torsion from horizontal and vertical data%			using Leftward, Upward, and Clockwise data as positive% written by:  Jonathan Jacobs%              November 2000  (last mod: 11/21/00)% Usage: listor (creates rlt and llt arrays of Listing torsion)rhrad = rh*pi/180; rvrad = rv*pi/180;lhrad = lh*pi/180; lvrad = lv*pi/180;rltrad = asin( (-sin(rhrad).*sin(rvrad)) ./ (1+ cos(rhrad).*cos(rvrad)) );lltrad = asin( (-sin(lhrad).*sin(lvrad)) ./ (1+ cos(lhrad).*cos(lvrad)) );rlt = rltrad*180/pi;llt = lltrad*180/pi;clear rhrad lhrad rvrad lvrad rltrad lltrad