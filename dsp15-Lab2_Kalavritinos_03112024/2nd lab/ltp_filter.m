function [s_ltp,e] = ltp_filter(x,Fs,winlen,winovlp,pitch)
siglen=length(x);
winstep = winlen - winovlp;   
w=hamming(winlen);   
pos = 1; i = 1;
 while (pos+winlen < siglen)
     frames(:,i) = x(pos:pos+winlen-1);
     pos = pos + (winlen - winovlp);
     i = i + 1;
 end
 e=zeros(1,siglen);
nw = size(frames,2);
%% Δημιουργία pitch filter ή long-term predition filter
% Initialize the voice reconstruction buffer with zeros 
pitch_zp = [pitch zeros(1,nw-length(pitch))]; % Zero-Padding of pitch signal
s_ltp = zeros(1,siglen);
% Define a counter for the beginning sample of the moving window 
count=1;
for i=1:nw 
    % i is the window index. Ignore the first 3 signal frames to compensate for the np~=n inequality
    currentframe = frames(:,i); 
    % Smoothing with hamming doing sample-by-sample multipication 
    windowedframe = w.*currentframe;    
    [a,G,error1] = lpc_analysis( windowedframe,52);
    
    [b,M]=ltp_coeffs(w.*error1);
    frame_est = filter([1 zeros(1,M-1) -b],1,w.*error1); %ltp filter
    error = windowedframe-frame_est;
    % Reconstruct the i-frame
    f = pitch_zp(i);
    u = ugenerator(f,winlen,Fs);   
    sframe=filter(1,[1 zeros(1,M-1) -b],u);
    %sframe=  filter(1,-b,u);     %inverse ltp filter before i-lpc filter
    sframe = filter(G,a,sframe);               
    %sframe=sframe';
    
    % Overlap - Add: Add the reconstructed frame into the reconstruction buffer 
    % by overlapping the i-1 segment by 2/3 of window size
    segstart = count;
    segend = min((segstart+winlen-1),siglen);
    seglen = segend - segstart + 1;
    
    s_ltp(segstart:segend) = s_ltp(segstart:segend) + sframe(1:seglen); 
    e(segstart:segend)=e(segstart:segend)+error(1:seglen)'; %error
    count = count + winstep;
end    
%% Amplitude Normalization of reconstructed speech
% Scale/Normalize the synthetic voice signal in [-1 1]

s_ltp = s_ltp./max(s_ltp); 
wavwrite(s_ltp,Fs,32,'synthesis_lpc_long.wav');

%% Plots
t = [0:(length(x)-1)] / Fs;

figure()
plot(t,x);grid on;
title('Natural and Reconstructed voice');
xlabel('Time (Seconds)'); 

hold on
plot(t ,s_ltp, 'r' );grid on;


figure()
subplot(2,1,1);
% Spectogram usage: [S,F,T,P] = spectrogram(x,window,noverlap,nfft,fs)
[S,F,T,P] = spectrogram(x, w, winovlp, nextpow2(siglen), Fs);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Natural Voice');

subplot(2,1,2);
[S,F,T,P] = spectrogram(s_ltp, w, winovlp, nextpow2(siglen), Fs);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Reconstructed Voice');
xlabel('Time (Seconds)'); ylabel('Hz');

end


