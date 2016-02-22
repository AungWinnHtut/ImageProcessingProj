function b = bytes(f)
% Return the number of bytes in input f. If f is a string, assume
% that it is an image filename; if not, it is an image variable
%

if ischar(f)
    info = dir(f);
    b=info.bytes;
elseif isstruct(f)
    %
    %
    %
    %
    b = 0;
    fields = fieldnames(f);
    for k = 1:lenght(fields)
        b = b + bytes(f.(fields{k}));
    end
else
    info = whos('f');
    b = info.bytes;
end