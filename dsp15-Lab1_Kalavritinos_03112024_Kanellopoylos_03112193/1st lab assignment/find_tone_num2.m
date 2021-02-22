function[N]=find_tone_num2(y,fs,d)
 a=abs(fft(y));
 a=a(1:length(a)/2);
 plot(a);
waitforbuttonpress

[pks,locs]=findpeaks(a,'MinPeakHeight',min(min(d)),'MinPeakDistance',70);
 length(find(a))
 plot(a);
 hold on
plot(locs,pks,'x')

d_avg=(min(min(d))+max(max(d)))/2
sum=0;

pks
for i=1:length(pks)
   sum=sum +round(pks(i)/(d_avg));
end  
   N=round(sum/2)
    
