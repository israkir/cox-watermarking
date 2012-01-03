function watermark_sequence = GenerateGaussianSequence(n)
% Generate normally distributed random numbers as a sequence
% Take their sign() to map them to {-1, 1}

% Parameters:
% (1) n: # of bits, if not specified n = 1000

if (nargin == 0)
    n = 1000;
end

watermark_sequence = sign(randn(1, n));

for i = 1 : n
    if watermark_sequence(i) == -1
        watermark_sequence(i) = 0;
    end
end

end

