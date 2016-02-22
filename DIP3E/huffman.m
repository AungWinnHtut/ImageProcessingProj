function CODE = huffman(p)
%HUFFMAN Builds a variable-length Huffman code for a symbol source.
% CODE = HUFFMAN(P) returns a Huffman code as binary strings in
% cell array CODE for input symbol probability vector P. Each word
% in CODE corresponds to a symbol whose probability is at the
% corresponding index of P.
%
% Based on huffman5 by Sean Danaher, University of Northumbria,
% Newcastle UK. Availabe at the MATLAB Central File Exchange:
% Category General DSP in Signal Processing and Communications.

%Check the input arguments for reasonableness.
error(nargchk(1, 1, nargin));
if (ndims(p) ~= 2) | (min(size(p)) > 1) | ~isreal(p) | ~isnumeric(p)
    error('P must be a real numeric vector.');
end
 % Global variable surviving all recursions of function 'makecode'
 global CODE
 CODE = call(length(p), 1);     % Init global cell array
 
 if length(p) > 1               % When more than one symbol ...
     p = p / sum(p);            % Normalize the input probabilities
     s = reduce(p);             % Do Huffman source symbol reductions
     makecode(s, []);           % Recursively generate the code
 else
     CODE = {'1'};              % Else, trivial one symbol case!
 end;