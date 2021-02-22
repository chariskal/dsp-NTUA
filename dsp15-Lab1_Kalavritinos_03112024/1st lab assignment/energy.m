function En = energy(x,A,winlen)
%ENERGY   Short-time energy computation.
% energy calculation
x2 = x.^2;
En = winconv(x2,A,winlen);