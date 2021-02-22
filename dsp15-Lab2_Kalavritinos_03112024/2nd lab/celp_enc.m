function [x6] = celp_enc(sig,winlen,L,c,cb,Pidx,Fs,winovlp)
len = length(sig);  
w=hamming(winlen);
frame_num  = fix(len/winlen);    %frames
blocks  = winlen/L;      %blocks per frame
order = Fs/1000+4;       %predictor order
ebuf  = zeros(Pidx(2),1);%Vectors to store previous excitation samples
ebuf2 = ebuf; 
bbuf = 0; 
x6   = zeros(len,1);          %sythesised signal
b      = zeros(blocks,frame_num);
e      = zeros(len,1);        %excitation signal
k      = zeros(blocks,frame_num);                  
theta0 = zeros(blocks,frame_num);     %parameters per window frame.
P      = zeros(blocks,frame_num);
Zf = []; 
Zw = []; 
Zi = [];   %Memory hangover in filters.
for i=1:frame_num
  n = (i-1)*winlen+1:i*winlen;                    % Time index of current speech frame.

  [kappa,kf,theta0f,Pf,bf,ebuf,Zf,Zw] = celp_analysis_enc(cb,sig(n),order,L,c,Pidx,bbuf,ebuf,Zf,Zw);

  %%Κβαντιση
  g=rc2lar(kappa);
  g=udecode(uencode(g,5),5);
  kappa=lar2rc(g);
  theta0 = udecode(uencode(theta0,5,0.2),5,0.2);
  b= udecode(uencode(b,6,1.4),6,1.4);

  [x6(n),ebuf2,Zi] = celp_synthesis_enc(cb,kappa,kf,theta0f,L,Pf,bf,ebuf2,Zi);

  e(n)        = ebuf(Pidx(2)-winlen+1:Pidx(2));
  k(:,i)      = kf;
  theta0(:,i) = theta0f;
  P(:,i)      = Pf;
  b(:,i)      = bf; 
  bbuf = bf(blocks);       
end
%wavwrite(x6,Fs,32,'synthesis_celp_encoded.wav');

%% Plots

t = (0:(length(sig)-1)) / Fs;
figure()
plot(t,sig);grid on;
title('Natural voice');
xlabel('Time (Seconds)'); 
hold on
plot(t ,x6, 'r' );grid on;
title('Reconstructed Voice');
xlabel('Time (Seconds)');

figure()
subplot(2,1,1);
% Spectogram usage: [S,F,T,P] = spectrogram(x,window,noverlap,nfft,fs)
[S,frame_num,T,P] = spectrogram(sig, w, winovlp, nextpow2(len), Fs);
surf(T,frame_num,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Natural Voice');

subplot(2,1,2);
[S,frame_num,T,P] = spectrogram(x6, w, winovlp, nextpow2(len), Fs);
surf(T,frame_num,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Reconstructed Voice');
xlabel('Time (Seconds)'); ylabel('Hz');
end