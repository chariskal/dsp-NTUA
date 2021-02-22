function [s_lpc,e,frames] = lpc_vocoder(s,Fs,winlen,winovlp,pitch)
siglen=length(s);
winstep = winlen - winovlp;   
w=hamming(winlen);      
 pos = 1; i = 1;
 while (pos+winlen < siglen)
     frames(:,i) = s(pos:pos+winlen-1);
     pos = pos + (winlen - winovlp);
     i = i + 1;
 end
nw = size(frames,2);
%% LPC analysis and speech reconstruction

order = Fs/1000+4;         %ταξη προβλέπτη
%order2=12;
s_lpc = zeros(1,siglen);   %voice reconstruction
e=zeros(1,siglen);
count=1;               % Define a counter for the begining sample of the moving window 

pitch_zp = [pitch zeros(1,nw-length(pitch))]; % Zero-Padding of pitch signal

for i=1:nw 
    % i is the window index. Ignore the first 3 signal frames to compensate for the np~=n inequality
    currentframe = frames(:,i); 
    
    % Smoothing with hamming doing sample-by-sample multipication 
    windowedframe = w.*currentframe;     
    % Estimate the LPC parameters(The same function as in section 1)
    [a,G,error] = lpc_analysis( windowedframe,order );
    % Generate excitation signal u as a pulse train with T=1/f intervals or a white-noisy
    % signal both having the same length as the analysis window
    f = pitch_zp(i);
    u = ugenerator(f,winlen,Fs);    
 
    % Reconstruct the i-frame
    sframe = filter(G,a,u);      %inverse filter

    % Overlap - Add: Add the reconstructed frame into the reconstruction buffer 
    % by overlapping the i-1 segment by 2/3 of window size
    segstart = count;
    segend = min((segstart+winlen-1),siglen);
    seglen = segend - segstart + 1;
    
    s_lpc(segstart:segend) = s_lpc(segstart:segend) + sframe(1:seglen); 
    e(segstart:segend)=e(segstart:segend)+error(1:seglen)';
    count = count + winstep;
   
end    

%% Amplitude Normalization of reconstructed speech
% Scale/Normalize the synthetic voice signal in [-1 1]
s_lpc = s_lpc/max(s_lpc); 
wavwrite(s_lpc,Fs,32,'synthesis_lpc.wav');
%% Plots
t = [0:(length(s)-1)] / Fs;

figure()
plot(t,s);grid on;
title('Natural and recontructed Voice');
xlabel('Time (Seconds)'); 

hold on
plot(t ,s_lpc, 'r' );grid on;
xlabel('Time (Seconds)');


figure()
subplot(2,1,1);
% Spectogram usage: [S,F,T,P] = spectrogram(x,window,noverlap,nfft,fs)
[S,F,T,P] = spectrogram(s, w, winovlp, nextpow2(siglen), Fs);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Natural Voice');

subplot(2,1,2);
[S,F,T,P] = spectrogram(s_lpc, w, winovlp, nextpow2(siglen), Fs);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Reconstructed Voice');
xlabel('Time (Seconds)'); ylabel('Hz');

end