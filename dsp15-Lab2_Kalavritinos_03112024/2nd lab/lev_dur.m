function [a,xi,kappa] = lev_dur(r,M)
kappa = zeros(M,1);
a = zeros(M,1);
xi = [r(1); zeros(M,1)];
for j=1:M
kappa(j) = (r(j+1) - a(1:j-1)'*r(j:-1:2))/xi(j);
a(j) = kappa(j);
a(1:j-1) = a(1:j-1) - kappa(j)*a(j-1:-1:1);
xi(j+1) = xi(j)*(1 - kappa(j)^2);
end

