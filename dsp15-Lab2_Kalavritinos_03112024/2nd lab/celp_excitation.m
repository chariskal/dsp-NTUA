function [k,G,P,b,ebuf,Zf,Zw] = celp_excitation(x,cb,Pidx,ar,ac,b,ebuf,Zf,Zw)
[L,~] = size(cb);                       % Block length and codebook size.
F = length(ebuf);       %No. of previous excitation samples.

% The columns of E are the signal e(n-P) for Pidx(1) < P < Pidx(2).
E = zeros(L,Pidx(2)-Pidx(1)+1);

% For P < L, the signal e(n-P) is estimated as the output of the pitch
% filter with zero input. b*ebuf(F-P+1:F) is memory hangover in the filter.
if (Pidx(1) < L)
  if (Pidx(2) < L)
    P2 = Pidx(2);
  else
    P2 = L;
  end
  for P = Pidx(1):P2-1
    i = P - Pidx(1) + 1;
    E(:,i) = filter(1,[1 zeros(1,P-1) -1],zeros(L,1),b*ebuf(F-P+1:F));
  end
end

% For P >= L, the signal e(n-P) can be obtained from previous excitation
% samples only, buffered in the vector ebuf.
if (Pidx(2) >= L)
  if (Pidx(1) >= L)
    P1 = Pidx(1);
  else
    P1 = L;
  end
  col = ebuf(F-P1+1:F-P1+L);
  row = flipud(ebuf(F-Pidx(2)+1:F-P1+1));
  i = P1-Pidx(1)+1:Pidx(2)-Pidx(1)+1;
  E(:,i) = toeplitz(col,row);
end
%ελαχιστοποιηση ενεργειας
[z0,Zw] = filter(ar,ac,x,Zw);     % z0 = X(z)*W(z).
z2= filter(1,ac,E,Zf);            % z2 = E(z)*z^(-P) / A(z/c)
                                  % for Pidx(1) < P < Pidx(2).
Pw2  = sum(z2.^2);         % Vector with signal power for each P.
Pw02 = z0'*z2;        % Vector with cross-correlations for each P.

[~,Phat] = max(Pw02.^2./(Pw2 + 10*eps));  % Find index Phat of max value.
P = Phat + Pidx(1) - 1;                   % Offset index with first P.
b = abs(Pw02(Phat)/(Pw2(Phat) + 10*eps));  

if (b > 1)                                 
  b = 1;
end

if (P < L)
 e = filter(1,[1 zeros(1,P-1) -b],zeros(L,1),b*ebuf(F-P+1:F));
else
 e = b*ebuf(F-P+1:F-P+L);
end

% ελαχιστοποιηση ανάμεσα σε
% X(z)*W(z) - b*E(z)*z^(-P)/A(z/c) and theta0*rho_k(z)/A(z/c).

z0 = z0 - filter(1,ac,e,Zf);  % Subtract b*E(z)*z^(-P)/A(z/c).
z1 = filter(1,ac,cb);              % Zeta_w1 = rho_k(z) / A(z/c)
                                        % for all index k in codebook.
Pw1  = sum(z1.^2);         % Vector with signal power for each P.
Pw01 = z0'*z1;        % Vector with cross-correlations for each P.

[~,k] = max(Pw01.^2./Pw1);           % Find index k of max value,
G = Pw01(k)/Pw1(k);              % and gain theta0 using this k.

if (P < L)
  e = filter(1,[1 zeros(1,P-1) -b],G*cb(:,k),b*ebuf(F-P+1:F));
else
  e = G*cb(:,k) + b*ebuf(F-P+1:F-P+L);
end
ebuf = [ebuf(L+1:F); e];                
[~,Zf] = filter(1,ac,e,Zf);          