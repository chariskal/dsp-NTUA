function [enc_lpc,e] = lpc_encoded(x,Fs,winlen,winovlp,pitch)
 siglen=length(x);
 winstep = winlen - winovlp;   
 w=hamming(winlen);      
  pos = 1; i = 1;
 while (pos+winlen < siglen)
     frames(:,i) = x(pos:pos+winlen-1);
     pos = pos + (winlen - winovlp);
     i = i + 1;
 end
nw = size(frames,2);
%% LPC analysis and speech reconstruction
 f=udecode(uencode(pitch,6,1),6,1);

order = 52;                  %ταξη προβλέπτη
enc_lpc = zeros(1,siglen);   %voice reconstruction
e=zeros(1,siglen);
count=1;               
%pitch_zp = [pitch zeros(1,nw-length(pitch))]; % Zero-Padding of pitch signal

for i=1:nw 
    currentframe = frames(:,i); 
    windowedframe = w.*currentframe;     
    [a1,G1(i),error] = lpc_analysis(windowedframe,order );
    
    [r,eta] = xcorr(windowedframe,order,'biased');
    [~,~,kappa] = lev_dur(r(order+1:2*order+1),order);
    
    g=rc2lar(kappa);
    g=udecode(uencode(g,5),5);
    kappa=lar2rc(g);
    a=rf2lpc(kappa);
    a=[1 -a'];
    
    if f(i)>0
        u(i,:)=ones(1,winlen);
    else
        u(i,:)=zeros(1,winlen);
    end
    G1(i)=abs(i./G1(i));
    Glog=20*log(G1(i));
    Z=uencode(Glog,5,max(G1));
    G(i)=udecode(10^Z,5,max(G1));
    % Reconstruct the i-frame
    sframe = filter(G(i),a,u(i,:));      

    % Overlap - Add: Add the reconstructed frame into the reconstruction buffer 
    % by overlapping the i-1 segment by 2/3 of window size
    segstart = count;
    segend = min((segstart+winlen-1),siglen);
    seglen = segend - segstart + 1;
    
    enc_lpc(segstart:segend) = enc_lpc(segstart:segend) + sframe(1:seglen); 
    e(segstart:segend)=e(segstart:segend)+error(1:seglen)';
    count = count + winstep;
end    

%% Amplitude Normalization of reconstructed speech
% Scale/Normalize the synthetic voice signal in [-1 1]
enc_lpc = enc_lpc/max(max(enc_lpc),abs(min(enc_lpc))); 
%wavwrite(enc_lpc,Fs,32,'synthesis_encoded_lpc.wav');
%% Plots
t = [0:(length(x)-1)] / Fs;

figure()
plot(t,x);grid on;
title('Natural Voice');
xlabel('Time (Seconds)'); 

hold on
plot(t ,enc_lpc, 'r' );grid on;
title('Reconstructed Voice');
xlabel('Time (Seconds)');


figure()
subplot(2,1,1);
% Spectogram usage: [S,F,T,P] = spectrogram(x,window,noverlap,nfft,fs)
[S,F,T,P] = spectrogram(x, w, winovlp, nextpow2(siglen), Fs);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Natural Voice');

subplot(2,1,2);
[S,F,T,P] = spectrogram(enc_lpc, w, winovlp, nextpow2(siglen), Fs);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Reconstructed Voice');
xlabel('Time (Seconds)'); ylabel('Hz');

end