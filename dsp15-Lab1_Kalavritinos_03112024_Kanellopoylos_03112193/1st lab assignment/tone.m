function[out]=tone(num)
n=[1:1000];
[x,y]=tone_freqs(num);
out=sin(x*n)+sin(y*n);