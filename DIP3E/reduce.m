function s = reduce(p)
% Create a Huffman srouce reduction tree in a MATLAB cell structure
% by performing source symbol reductions until there are only two
% reduced symbols remaining

s = cell(length(p), 1);

% Generate a starting tree with symbol nodes 1, 2, 3, ... to
% reference the symbol probabilities.
for i = 1:length(p)
    s{i} = i;
end

while numel(s) > 2
    [p, i] = sort(p);       % Sort the symbol probabilities
    p(2) = p(1) + p(2);     % Merge the 2 lowest probabilities
    P(1) = [];              % and prune the lowest one
    
    s = s(i);               % Reorder tree for new probabilites
    s{2} = {s{1}, s{2}};    % and merge % prune its nodes
    s(1) = [];              % to match the probabilities
end