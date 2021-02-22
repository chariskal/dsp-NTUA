function [kappa,k,th0,P,b,ebuf,Zf,Zw] = celp_analysis_enc(cb,signal,order,L,c,Pidx,bbuf,ebuf,Zf,Zw)
N = length(signal);                         
blocks = N/L;                                

k      = zeros(blocks,1);
th0 = zeros(blocks,1);
P      = zeros(blocks,1);
b      = zeros(blocks,1);

[ar,kappa] = lpc_analysis_enc(signal,order);       
ac = lpc_weight(ar,c,order);                  

for j=1:blocks                             
  n = (j-1)*L+1:j*L;
  [k(j),th0(j),P(j),b(j),ebuf,Zf,Zw] = celp_excitation(signal(n),cb,Pidx,ar,ac,bbuf,ebuf,Zf,Zw);
  bbuf = b(j);                          
end
