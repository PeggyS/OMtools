% isdigit.m: True for elements of a string that are digits.% Written by:  Jonathan Jacobs%              May 1999  (last mod: 05/27/99)function out = isdigit(in)x = double(in);%out = zeros(1,length(x));out = find(x>=48 & x<=57);%outmat(where) = 1;if isempty(out),out=0;end%out = outmat;