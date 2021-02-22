function [x,ebuf,Zi] = celp_synthesis(cb,a,k,theta0,P,b,ebuf,Zi)
[L,~] = size(cb);         %Block length and codebook size.
F = length(ebuf);         %No. of previous excitation samples.
blocks = length(k);            %No. blocks per frame.
N = L*blocks;                  %Frame length.

e = zeros(N,1);

for j=1:blocks
   n = (j-1)*L+1:j*L;
   % Find the signal e(n) based on the parameters b, P, theta0, and k.
   if (P(j) < L)
    Zp   = b(j)*ebuf(F-P(j)+1:F);
    e(n) = filter(1,[1 zeros(1,P(j)-1) -b(j)],theta0(j)*cb(:,k(j)),Zp);
   else
    e(n) = theta0(j)*cb(:,k(j)) + b(j)*ebuf(F-P(j)+1:F-P(j)+L);
   end
  ebuf = [ebuf(L+1:F); e(n)];           % Update e(n) buffer.
end

[x,Zi] = filter(1,a,e,Zi);        % i-lpc filter