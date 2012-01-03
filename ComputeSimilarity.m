function [origwm_similarity, similarities] = ComputeSimilarity(origwm, extwm, n)
% Compute the similarities of the original watermark along with other
% randomly generated n-1 sequences.

% Parameters:
% (1) origwm    : original watermark sequence
% (2) n         : # of bits in watermark

watermarks = zeros(n,n);
for i = 1 : n
    % Place the similarity for extracted watermark in 100th index
    if i == 100
        watermarks(i,:) = extwm;
        continue;
    end
    watermarks(i,:) = GenerateGaussianSequence(n); 
end

similarities = zeros(n);
for i = 1 : n
    %similarities(i) = origwm * watermarks(i,:)' / sqrt(watermarks(i,:) * watermarks(i,:)');
    similarities(i) = origwm * watermarks(i,:)' / sqrt(origwm * origwm'); 
end

origwm_similarity = similarities(100);

end

