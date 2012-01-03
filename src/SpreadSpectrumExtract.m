function SpreadSpectrumExtract(suspfile, origfile, wmfile, n, alpha)
% Extract watermark from an image according to spread spectrum watermarking algorithm

% Parameters:
% (1) suspfile      : filename of suspect image
% (2) origfile      : filename of original file
% (3) n             : # of bits representing the watermark
% (4) alpha         : scaling factor

% Read watermarked image
rgb_image_w = imread(suspfile);
ycbcr_image_w = rgb2ycbcr(rgb_image_w);
y_w = ycbcr_image_w(:,:,1);
dct_image_w = dct2(y_w);

% Read original image - informed watermarking
rgb_image = imread(origfile);
ycbcr_image = rgb2ycbcr(rgb_image);
y = ycbcr_image(:,:,1);
dct_image = dct2(y);

%dlmwrite('extracted_y_img.txt', ycbcr_image_w(:,:,1));
%dlmwrite('extracted_dct_image.txt', dct_image_w);

[width_w, height_w] = size(dct_image_w);
vector_size_w = width_w * height_w;

dct_vector_w = reshape(dct_image_w, 1, vector_size_w);
[sorted_dct_vector index_w] = sort(dct_vector_w, 'descend');

%dlmwrite('extracted_dct_vector.txt', dct_vector_w);

[width, height] = size(dct_image);
vector_size = width * height;

dct_vector = reshape(dct_image, 1, vector_size);
[sorted_dct_vector index] = sort(dct_vector, 'descend');

% Extract watermark sequence from coefficients - w
w = [width_w, height_w];
for i = 1 : n
    %str1 = sprintf('dct_vector_w(index(1, %d) = %s', i, dct_vector_w(index_w(1,i)));
    %disp(str1);
    %str2 = sprintf('dct_vector_n(index(1, %d) = %s', i, dct_vector(index(1,i)));
    %disp(str2);
    w(i) = (dct_vector_w(index_w(1,i)) - dct_vector(index(1,i))) / alpha;
    w(i) = sign(w(i));
    if w(i) == -1
       w(i) = 0; 
    end
end

% Write extracted sequence into a file
filename = strcat(wmfile, '.extracted');
dlmwrite(filename, w);

% Read watermark sequence into matrix, compare similarity
origwm = dlmread(wmfile, ',');
[origwm_sim, similarities] = ComputeSimilarity(origwm, w, n);

fprintf('Original watermark similarity appears at index(100) = %d\n', origwm_sim);

% Plot the graph for similarities - resulting similarity for our
% watermark sequence is placed in 100th index in the graph
plot(similarities, 'DisplayName', 'similarities', 'YDataSource', 'similarities');

filename = regexp(suspfile, '\.', 'split');
saveas(gcf, strcat('figure_', filename{1}, '.png'));

end