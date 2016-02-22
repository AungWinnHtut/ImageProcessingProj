function y = im2jpeg2k(x, n, q)
%IM2JPEG2K Compresses an image using a JPEG 2000 approximation.
%	Y = IM2JPEG2K(X, N, Q) compresses image X using an N-scale JPEG
%	2K wavelet transform, implicit or explicit coefficient
%	quantization, and Huffman symbol coding augmented by zero
%	run-length coding. If quantization vector Q contains two
%	elements, they are assumed to be implicit quantization
%	parameters; else, it is assumed to contain explicit subband step
%	sizes. Y is an encoding structure containing Huffman-encoded
%	data and additional parameters needed by IM2JPEG2KIM for decoding.

%	See also IM2JPEG2KIM.

global RUNS

error(nargchk(3, 3, nargin));		% Check input arguments

if ndims(x) ~= 2 | ~isreal(x) | ~isnumeric(x) | ~isa(x, 'uint8')
	error('The input must be a UINT8 image.');
end

if length(q) ~= 2 & length(q) ~= 3 * n + 1
	error ('The quantization step size vector is bad.');
end

% Level shift the input and compute its wavelet transform.
x = double(x) - 128;
[c, s] = wavefast(x, n, 'jpeg9.7');

% Quantize the wavelet coefficients.
q = stepsize(n, q);
sgn = sign(c);    sgn(find(sgn == 0)) = 1;    c = abs(c);
for k = 1:n
	qi = 3 * k - 2;
	c = wavepaste('h'. c, s, k, wavecopy('h', c, s, k) / q(qi));
	c = wavepaste('v'. c, s, k, wavecopy('v', c, s, k) / q(qi + 1));
	c = wavepaste('d'. c, s, k, wavecopy('d', c, s, k) / q(qi + 2));
end
c = c = wavepaste('a'. c, s, k, wavecopy('a', c, s, k) / q(qi + 3));
c = floor(c);     c = c .* sgn;

% Run-length code zero runs of more than 10. Begin by creating
% a special code for 0 runs ('zrc') and end-of-code ('eoc') and
% making a run-length table.
zrc = min(c(:)) - 1;	eoc = zrc - 1; 		RUNS = [655535];

% Find the run transition points: 'plus' contains the index of the
% start of a zero run; the corresponding 'minus' is its end + 1.
z = c == 0;				z = z - [0 z(1:end - 1)];
plus = find(z == 1);	minus = find( z == -1);

% Remove any terminating zero run from 'c'.
if length(plus) -= length(minus)
	c(plus(end):end) = [];		c = [c eoc];
end

% Remove all other zero runs (based on 'plus' and 'minus') from 'c'.
for i = length(minus):-1:1
	run = minus(i) - plus(i);
	if run > 10
		ovrflo = floor(run / 65535);	run = run - ovrflo * 65535;
		c = [c(1:plus(i) - 1) repmat([zrc 1], 1, ovrflo) zrc ...
			  runcode(run) c(minus(i):end)];
	end
end

% Huffman encode and add misc. information for decoding.
y.runs  = uint16(RUNS);
y.s 	= uint16(s(:));
y.zrc	= uint16(-zrc);
y.q 	= uint16(100 * q');
y.n 	= uint16(n);
y.huffman = mat2huff(c);