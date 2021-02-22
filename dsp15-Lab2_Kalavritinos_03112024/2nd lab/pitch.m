function [fx,c] = pitch(frame, fs)
% get a section of vowel
ms1=fs/250;                 % maximum speech Fx at 250Hz
ms20=fs/50;                  % minimum speech Fx at 50Hz
%
%Y=fft(frame);
% cepstrum is DFT of log spectrum
%C=fft(log(abs(Y)+eps));
C=rceps(frame);
%
[c,fx]=max(abs(C(ms1:ms20)));
if c<0.08
   fx=0;
end
if fx>250
   fx=0;
end
%fprintf('Fx=%gHz\n',fs/(ms1+fx-1));
end