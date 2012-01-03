function SpreadSpectrumEmbed(origfile, markedfile, wmfile, n, alpha)
% Embed watermark into an image according to spread spectrum watermarking algorithm

% Parameters:
% (1) origfile          : filename of cover image - e.g. 'fruits.bmp'
% (2) markedfile        : filename of output image - e.g. 'fruits_w.bmp'
% (3) wmfile            : random sequence file
% (4) n                 : # of bits representing the watermark - e.g. 1000
% (5) alpha             : the strength of the watermark - e.g. 5


% Preprocessing - read original image
rgb_image = imread(origfile);
ycbcr_image = rgb2ycbcr(rgb_image);
y = ycbcr_image(:,:,1);             % extract luminance component
dct_image = dct2(y);                % Compute the DCT of Y plane

%dlmwrite('orig_y_img.txt', ycbcr_image(:,:,1));
%dlmwrite('inv_orig_img.txt', y);
%dlmwrite('orig_dct.txt', dct_image);
%dlmwrite('orig_img.txt', ycbcr_image);

% Reshape the dct_image matrix to a dct_vector
[width, height] = size(dct_image);
vector_size = width * height;
dct_vector = reshape(dct_image, 1, vector_size);

%'index' is the index of each value of 'sorted_dct_vector' in the original 'dct_vector'
[sorted_dct_vector index] = sort(dct_vector, 'descend');

% Generate watermarked sequence
watermark_seq = GenerateGaussianSequence(n);

% Embed watermark seqeunce to original dct_vector
for i = 1 : n
    %str1 = sprintf('before: dct_vector(index(1, %d) = %s', i, dct_vector(index(1,i)));
    %disp(str1);
    %dct_vector(index(1,i)) = dct_vector(index(1,i)) + 1;
    dct_vector(index(1,i)) = dct_vector(index(1,i)) + (watermark_seq(i) * alpha);
    %dct_vector(index(1,i)) = dct_vector(index(1,i)) * (1 + alpha * watermark_seq(i)); 
    %str1 = sprintf('after: dct_vector(index(1, %d) = %s', i, dct_vector(index(1,i)));
    %disp(str1);
end

%dlmwrite('wtmr_dct_vector.txt', dct_vector);

% Output watermarked image with RGB color space
watermarked_dct_image = reshape(dct_vector, width, height);
%dlmwrite('wtmr_dct.txt', watermarked_dct_image);
inverse_dct_image = idct2(watermarked_dct_image);
%dlmwrite('inv_wtmr_img.txt', inverse_dct_image);
new_ycbcr_image = ycbcr_image;
new_ycbcr_image(:,:,1) = inverse_dct_image;
%dlmwrite('wtmr_y_img.txt', new_ycbcr_image(:,:,1));
%dlmwrite('wtmr_img.txt', new_ycbcr_image);

% Check whether modified DCT results to same image with original one
result = isequal(new_ycbcr_image, ycbcr_image);
if result == 1
    fprintf('Result image is the same with original one.\nChange either alpha value or watermark size??\nExiting...\n\n');
    return;
end

% Save watermark sequence in a file
dlmwrite(wmfile, watermark_seq);

% Save watermarked image in RGB mode
watermarked_rgb = ycbcr2rgb(new_ycbcr_image);
imwrite(watermarked_rgb, markedfile);

end