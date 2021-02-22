function kappa = find_kappas(ar)
ar = ar(:);
P = length( ar );
A = zeros(P,P);
A(:,P) = ar;
kappa = zeros(P,1);

kappa(P) = A(P,P);

for m = P:-1:2,
  for i = 1:m-1,
     A(i,m-1) = (A(i,m) + kappa(m) * A(m-i,m)) / (1-kappa(m)*kappa(m));
     kappa(m-1) = A(m-1,m-1);
  end
  %for i=1:length(kappa)
   %   if kappa(i)>1 
    %      kappa(i)=0.99;
  %    elseif kappa(i)<-1
  %        kappa(i)=-0.99;
  %    end
 % end
end