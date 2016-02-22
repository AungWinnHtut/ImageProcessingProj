function q = stepsize(n, p)
% Create a subband quantization array of step sizes ordered by
% decomposition (first to last) and subband (horizontal, vertical,
% diagonal, and for final decomposition the approximation subband).

if length(p) == 2		% Implicit Quantization
	q = [];
	qn = 2 ^ (8 - p(2) + n) * (1 + p(1) / 2 ^ 11);
	for k = 1:n
		qk = 2 ^ -k * qn;
		q = [q (2 * qk) (2 * qk) (4 * qk)];
	end
	q = [q qk];
else					% Expkicit Quantization
	q = p;
end

q = round(q * 100) / 100;	% Round to 1/100th place
if any(100 * q > 65535)
	error('The quantizing steps are not UINT16 representable.');
end
if any (q == 0)
	error('The quantizing step of 0 is not allowed.');
end