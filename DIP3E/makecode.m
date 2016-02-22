function makecode(sc, codeword)
% Scan the nodes of a Huffman source reduction tree recursively to
% generate the indicated variable length code words.

% Global variable surviving all recursive calls
global CODE
if isa(sc, 'cell')                   % For cell array nodes,
    makecode(sc{1}, [codeword 0]);   % add a 0 if the 1st element
    makecode(sc{2}, [codeword 1]);   % or a 1 if the 2nd
else                                 % For leaf (numberic) nodes,
    CODE{sc} = char('0' + codeword); % create a char code string
end