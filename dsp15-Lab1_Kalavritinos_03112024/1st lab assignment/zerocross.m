function zc = zerocross(x,A,winlen)
%ENERGY   Short-time energy computation.

% generate x[n] and x[n-1]
x1 = x;
x2 = [0, x(1:end-1)];

% generate the first difference
firstDiff = sign(x1)-sign(x2);
absFirstDiff = abs(firstDiff);

zc = winconv(absFirstDiff,A,winlen);
