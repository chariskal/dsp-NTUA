function [x4,e] = celp(x,N,L,c,cb,Pidx,Fs,winovlp)
order = Fs/1000+4;  %predictor order
len = length(x);  
w=hamming(N);
frames  = fix(len/N);    %frames
blocks  = N/L;      %blocks per frame
Ebf  = zeros(Pidx(2),1);    %Vectors to store previous excitation samples
Ebf2 = Ebf; 
Bbf = 0; 
x4   = zeros(len,1);          %sythesised signal
b      = zeros(blocks,frames);
e      = zeros(len,1);        %excitation signal
k      = zeros(blocks,frames);                  
Gain = zeros(blocks,frames);     %parameters per window frame.
P      = zeros(blocks,frames);
Zf = []; 
Zw = []; 
Zi = [];   %Memory hangover in filters.

for i=1:frames
  nstart=(i-1)*N+1;
  nend=i*N;
  n = nstart:nend; 
  frame=x(n);
  [ar,kf,G,Pf,bf,Ebf,Zf,Zw] = celp_analysis(frame,L,order,c,cb,Pidx,Bbf,Ebf,Zf,Zw);
  [x4(n),Ebf2,Zi] = celp_synthesis(cb,ar,kf,G,Pf,bf,Ebf2,Zi);
 
  e(n)        = Ebf(Pidx(2)-N+1:Pidx(2));
  k(:,i)      = kf;
  Gain(:,i) = G;
  P(:,i)      = Pf;
  b(:,i)      = bf; Bbf = bf(blocks);  %Last estimated b used in next frame.
end
% Scale/Normalize the synthetic voice signal in [-1 1]
x4 = x4/max(x4); 

%wavwrite(x4,Fs,32,'synthesis_celp.wav');
%% Plots

t = (0:(length(x)-1)) / Fs;
figure()
plot(t,x);grid on;
title('Natural voice');
xlabel('Time (Seconds)'); 
hold on
plot(t ,x4, 'r' );grid on;
title('Reconstructed Voice');
xlabel('Time (Seconds)');

figure()
subplot(2,1,1);
% Spectogram usage: [S,F,T,P] = spectrogram(x,window,noverlap,nfft,fs)
[~,frames,T,P] = spectrogram(x, w, winovlp, nextpow2(len), Fs);
surf(T,frames,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Natural Voice');

subplot(2,1,2);
[~,frames,T,P] = spectrogram(x4, w, winovlp, nextpow2(len), Fs);
surf(T,frames,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Reconstructed Voice');
xlabel('Time (Seconds)'); ylabel('Hz');
end