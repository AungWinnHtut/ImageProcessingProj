function Y = uniquant(X, del, thr, ymax)
% uniquant    Uniform scalar quantizer (or inverse quantizer) with threshold
% Note: Use three arguments for inverse quantizing and
%       four arguments for quantizing.
%
% Y = uniquant(X, del, thr, ymax);     % quantizer
% X = uniquant(Y, del, thr);           % inverse quantizer
% ----------------------------------------------
% arguments:
%   X    - the values to be quantized (or result after inverse
%          quantizer), a vector or matrix with real values.
%   Y    - the indexes for the quantizer cells, the bins are indexed as
%          ..., -3, -2, -1, 0, 1, 2, 3, ...  where 0 is for the zero bin
%   del  - delta i quantizer, size/width of all cells except zero-cell
%   thr  - threshold value, width of zero cell is from -thr to +thr
%   ymax - largest value for y, only used when quantizing
% ----------------------------------------------

%----------------------------------------------------------------------
% Copyright (c) 1999.  Karl Skretting.  All rights reserved.
% Hogskolen in Stavanger (Stavanger University), Signal Processing Group
% Mail:  karl.skretting@tn.his.no   Homepage:  http://www.ux.his.no/~karlsk/
% 
% HISTORY:
% Ver. 1.0  27.07.99  Karl Skretting, Signal Processing Project 1999
%                     function made based on c_q1.m
% Ver. 1.2  22.10.10  KS: same as ..\ICTools\uniquant
%----------------------------------------------------------------------

S=sign(X);
X=abs(X);

if (nargin == 4)       % quantizing X --> Y
   Y=floor((X-thr)/del)+1;
   if (thr>del)
      Y(Y<0)=0;
   end
   ymax=floor(ymax);
   Y(Y>ymax)=ymax;
elseif (nargin == 3)   % inverse quantizing X --> Y
   Y=zeros(size(X));		
   I=find(X);
   Y(I)=(X(I)*del)+(thr-del/2);
else
   error('uniquant: invalid number of input arguments, see help.'); 
end
Y=Y.*S;

return