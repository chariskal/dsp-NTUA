function [x,ebuf,Zi] = celp_synthesis_enc(cb,kappa,k,theta0,L,P,b,ebuf,Zi)
F = length(ebuf);                      
blocks = length(k);                          
N = L*blocks;                                
e = zeros(N,1);

for j=1:blocks
  n = (j-1)*L+1:j*L;
 if (P(j) < L)
    Zp   = b(j)*ebuf(F-P(j)+1:F);
    e(n) = filter(1,[1 zeros(1,P(j)-1) -b(j)],theta0(j)*cb(:,k(j)),Zp);
  else
    e(n) = theta0(j)*cb(:,k(j)) + b(j)*ebuf(F-P(j)+1:F-P(j)+L);
  end
  ebuf = [ebuf(L+1:F); e(n)];           
end

a = rf2lpc(kappa);                      
[x,Zi] = filter(3,[1; -a],e,Zi);        
