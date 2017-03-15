Description
===========

This is a simple spread-spectrum based informed watermarking implementation in MATLAB. It is based 
on the paper [Ingemar J. Cox, Joe Kilian, F. Thomson Leighton, and Talal Shamoon, "Secure Spread 
Spectrum Watermarking for Multimedia," IEEE Trans. on Image Processing, Dec. 1997](
http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=650120).

SpreadSpectrumEmbed.m
---------------------

Description: Embeds n watermark sequence into an image file, outputs watermarked image file and 
writes the watermark sequence into a file with extension '.seq'. If the watermarked image results 
to the same image with original one after spectrum operations (this is highly related to the n 
size of watermark sequence and alpha value), it warns the user outputting related message.

Uses: `GenerateGaussianSequence.m`

Arguments: `origfile`, `markedfile`, `wmfile`, `n`, `alpha`

Returns: `void`

Example Run:

    >> SpreadSpectrumEmbed('fruits.bmp', 'fruits_w.bmp', 'wm.seq', 1000, 2)

SpreadSpectrumExtract.m
-----------------------

Description: Extracts watermark sequence (if there exists) from a suspected image file, writes 
extracted watermark sequence in a file with extension '.extracted', reads the original watermark 
sequence, computes the similarities of randomly generated n-1 training watermark sequence along 
with the original one, plots these similarities into a figure file with extension '.png'.

Uses: `GenerateGaussianSequence.m`, `ComputeSimilarity.m`

Arguments: `suspfile`, `origfile`, `wmfile`, `n`, `alpha`

Returns: `void`

Example Run:

    >> SpreadSpectrumExtract('fruits_w.bmp', 'fruits.bmp', 'wm.seq', 1000, 2)

GenerateGaussianSequence.m
--------------------------

Description: Generates n sequence of normally distributed pseudo random numbers of the numbers 
{0, 1}. This is an auxiliary script which is called inside embbedding and extracting programs.

Arguments: `n`

Returns: `watermark_sequence`

Example Call:

    ..
    .. watermark_seq = GenerateGaussianSequence(n);
    ..


ComputeSimilarity.m
-------------------

Description: Computes the similarities between original watermark sequence and n-1 randomly 
generated training watermark sequences with the extracted watermark from suspected image. 

Arguments: `origwm`, `extwm`, `n`

Returns: `origwm_similarity`, `similarities`

Example Call:

    ..
    .. [origwm_sim, similarities] = ComputeSimilarity(origwm, w, n);
    ..

Note
----
Working directory for Matlab interpreter must be same for all referenced argument files -- which 
means if you do not want to specify file paths, just copy the test files into the src/ directory 
and run embedding and extracting.