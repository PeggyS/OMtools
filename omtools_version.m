function otver = omtools_version

verstr = '12 October 2020';

if nargout==0
   fprintf('OMtools version: %s\n',verstr)
   clear otver
   return
end

otver = verstr;