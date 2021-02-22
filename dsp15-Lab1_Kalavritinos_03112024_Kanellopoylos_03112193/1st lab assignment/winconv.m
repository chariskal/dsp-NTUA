function y = winconv(x,A,winlen)
% generate the window
w = A*hamming(winlen)';
% perform the convolution using FFT
NFFT = 2^(nextpow2(length(x)));
X = fft(x,NFFT); W = fft(w,NFFT);
Y = X.*W;
y = ifft(Y,NFFT);
    