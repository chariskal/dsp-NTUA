function [a,k,G,P,b,ebuf,Zf,Zw] = celp_analysis(x,L,order,c,cb,Pidx,bbuf,ebuf,Zf,Zw)
                                                                   
N = length(x);   %Frame length.
blocks = N/L;    %Number of sub-blocks.
k      = zeros(blocks,1); %initializations
G = zeros(blocks,1);
P      = zeros(blocks,1);
b      = zeros(blocks,1);

[a,Gain,~]=lpc_analysis(x,order);   %LPC
a= a';
ac = lpc_weight(a,c,order);      %Coefficients of filter A(z/c).

for j=1:blocks                   %Excitation sequence in blocks.
  n = (j-1)*L+1:j*L;
  [k(j),G(j),P(j),b(j),ebuf,Zf,Zw] = celp_excitation(x(n),cb,Pidx,a,ac,bbuf,ebuf,Zf,Zw);
  bbuf = b(j);                          % Last estimated b.
end