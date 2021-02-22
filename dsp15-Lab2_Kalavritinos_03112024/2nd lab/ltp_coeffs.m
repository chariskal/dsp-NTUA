function[b,M]= ltp_coeffs(e)

[R,eta] = xcorr(e,250,'biased');
[A,M1]=max(R);
R(M1)=0;
[B,M2]=max(R);
M=abs(M1-M2);
    b=B/A;
end