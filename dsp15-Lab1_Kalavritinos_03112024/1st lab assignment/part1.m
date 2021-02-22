 fs=8192;
 L=1000;
 N=1000;
 d=zeros(1000,10); %preallocating matrix d
   for i=0:9
     d(:,i+1)=tone(i);
   end
%% q 1.2

D1=abs(fft(d(:,2)));
D8=abs(fft(d(:,9)));

figure(1), plot(D1);
  title('DFT of d1[n]')
  ylabel('Magnitude');
  xlabel('bins');
figure(2), plot(D8);
  title('DFT of d8[n]')
  ylabel('Magnitude');
  xlabel('bins');
  clear D1 D8
%% q 1.3
AM1=3112024;
AM2=3112193;
AM=AM1+AM2;

dig=zeros(1,8); % preallocating matrix
 for i=0:6
   dig(8-i)=mod(AM,10);
   AM=fix(AM/10);
 end
sil=zeros(1,100);
s1=[tone(dig(1)) sil tone(dig(2)) sil tone(dig(3)) sil tone(dig(4)) sil tone(dig(5)) sil tone(dig(6)) sil tone(dig(7)) sil tone(dig(8))];
wavwrite(s1,8192,32,'tone_sequence.wav')
figure(3), plot(abs(fft(s1)));
 title ('FFT of AM sum tone sequence');
 ylabel('Magnitude');
  xlabel('F in bins');
%% q 1.4 DFT του συνολικού σήματος που δημιουργήσαμε νωριτερα
w_ham=hamming(N)'; %hamming window
w_rec=ones(1,N);   %rectangular window
  
s2=[tone(dig(1)).*w_ham sil tone(dig(2)).*w_ham sil tone(dig(3)).*w_ham sil tone(dig(4)).*w_ham sil tone(dig(5)).*w_ham sil tone(dig(6)).*w_ham sil tone(dig(7)).*w_ham sil tone(dig(8)).*w_ham];
s3=[tone(dig(1)).*w_rec sil tone(dig(2)).*w_rec sil tone(dig(3)).*w_rec sil tone(dig(4)).*w_rec sil tone(dig(5)).*w_rec sil tone(dig(6)).*w_rec sil tone(dig(7)).*w_rec sil tone(dig(8)).*w_rec];
 figure(4), plot(abs(fft(s2))); %hamming window
  title('FFT using hamming');
  ylabel('Magnitude');
  xlabel('F in bins');
 figure(5), plot(abs(fft(s3))); %rectangular window
  title('FFT using Rect');
  ylabel('Magnitude');
  xlabel('F in bins');
  
  % DFT κάθε τόνου χωριστά που υπάρχει στο σήμα του 1.3

w_ham = transpose(hamming(L));
for i = 0:7
window=abs(fft(w_ham.*s1(1+(1100*i):(i+1)*1000+100*i)));
figure(6),plot(window); hold on   
 title('FFT using hamming');
  ylabel('Magnitude');
  xlabel('F in bins');
end
w_rec =ones(1,L);
for i = 0:7
window=abs(fft(w_rec.*s1(1+(1100*i):(i+1)*1000+100*i)));
  figure(7),plot(window); hold on
  title('FFT using Rect');
  ylabel('Magnitude');
  xlabel('F in bins')
end
    
  %% q 1.5  
     for i = 0:9
     DFT(:,i+1) = abs(fft(tone(i)));
     end
     j=1;
    for w=1:10
    for i=1:1000
    if(DFT(i,w)>300)
        b(w,j)=i;
        j=j+1;
    end
    if(j==3) break; end
    end   
    j=1;
    end %%Τοποθετώ στον b τους δείκτες κάθε tone
    f_min=0.5346;
    f_max=1.1328;
    k_max=181;
    k_min=86;
   step=(f_max-f_min)/(k_max-k_min);%%->κατάτμηση τόνων
   for w=1:10
    for i=3:4
       b(w,i)=b(w,i-2)*step;%%βάζω και τις freq 
       b(w,i+1)=w-1;%%που αντιστοιχούν σε κάθε δείκτη
    end 
   end
   
   %% q.1.5 alternative using energy
   %energy=zeros(1000,10);
   %   for i=0:9
   %     energy(:,i+1)= abs(fft(tone(i))).^2;
   %   end
   %  ind=find(energy> min(max(energy))/2);
   %  k=zeros(10,2);
   %   j=0;
   %  for i=0:9
   %    k(i+1,:)= [ind(j+1)-i*1000, ind(j+2)-i*1000];
   %    j=j+4;
   %  end 
   %  k=Fs/N.*k; % calculating Freq in Hz instead of bins
   %% q1.6
    [y, fs]=wavread('tone_sequence.wav');
    y=y';
    vector=ttdecode(y,b)
    
   %% q1.7
   load('my_touchtones.mat');
   vector=ttdecode(easySig,b)
   vector=ttdecode(hardSig,b)