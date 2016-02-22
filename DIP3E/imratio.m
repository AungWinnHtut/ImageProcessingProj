function cr= imratio(f1,f2)
%IMRATIO Computes the ratio of the bytes in two images/variables.
% CR = IMRATIO(F1,F2) returns the ratio of the number of bytes in 
% variables/files F1 and F2. if F1 and F2 are an original and 
% compress image, respectively, CR is the compression ratio.

error(nargchk(2,2,nargin));
cr = bytes(f1)/bytes(f2);
