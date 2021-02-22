function ar = rf2lpc(kappa)
M = length(kappa);
ar = zeros(M,1);

for j=1:M
  ar(j)     = kappa(j);
  ar(1:j-1) = ar(1:j-1) - kappa(j)*ar(j-1:-1:1);
end
