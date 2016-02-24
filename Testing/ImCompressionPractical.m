close all;
clear all;
f1=@(block_struct) dct2(block_struct.data);
f2=@(block_struct) idct2(block_struct.data);

Im = imread('lena_gray.bmp');
imwrite (Im,'newwall.bmp');

figure,imshow(Im);
J = blockproc(Im, [8,8], f1);
depth = find(abs(J) <50);
J(depth) = zeros(size(depth));
K = blockproc(J, [8,8],f2)/255;
figure,imshow(K);
K
imwrite(K,'newwall.bmp');
compression_ration = numel(J)/numel(depth)