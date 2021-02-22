function[X]=dft(x,N)
 M = exp(-1i*(0:N-1)'*(0:N-1)*2*pi/N); % DFT matrix
 X = x*M;   % DFT
end