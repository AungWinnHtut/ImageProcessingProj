function rmse = compare(f1,f2,scale)
% COMPARE Computers and displays the error between two matrices.
% between inputs F1 and F2, displays a histogram of the difference,
% and displays a scaled difference image. When SCALE is omitted, a 
% scale factor of 1 is used.

% Check input arguments and set defaults.
error(nargchk(2, 3, nargin));
if nargin < 3
    scale = 1;
end

% Compute the root-mean-square error.
e = double(f1) - double(f2);
[m,n] = size(e);
rmse = sqrt(sum(e(:) .^ 2) / (m * n));

% Output error image % histogram if an error (i.e., rmse ~= 0).
if rmse
    % Form error historgram.
    emax = max(abs(e(:)));
    [h,x] = hist(e(:), emax);
    
    if length(h) >= 1
        figure; bar(x, h, 'k');
        
        % Scale the error image symmetrically and display
        emax = emax / scale;
        e = mat2gray(e, [-emax, emax]);
        figure; imshow(e);
    end
end