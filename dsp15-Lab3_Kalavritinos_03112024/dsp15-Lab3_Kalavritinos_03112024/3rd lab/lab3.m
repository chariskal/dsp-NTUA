%%  Microphone arrays and Multichannel Signal processing
%   Μελέτη χαρακτηριστικών delay-and-sum beam pattern για Ομοιομορφες
%   γραμμικες συστοιχίες μικροφώνων ( ULA).

%% PART 1    1.4

d=0.04;     %απόσταση μεταξύ μκροφώνων
N=4;        %αριθμός μικροφώνων
f=2000;
thetas=pi/2; %γωνία
c=340;   %ταχύτητα ήχου
theta=(0:0.001*pi:pi);

%% 1.4.1
B1=beam_pattern(d,N,f,thetas,c,theta);
figure()
plot(theta,20*log10(abs(B1)),'r');
hold on
title('Delay and Sum pattern, variable N');
N=8;
B2=beam_pattern(d,N,f,thetas,c,theta);
plot(theta,20*log10(abs(B2)),'b');
N=16;
B3=beam_pattern(d,N,f,thetas,c,theta);
plot(theta,20*log10(abs(B3)),'g');
legend('N=4','N=8','N=16')

hold off

%% 1.4.2
figure();
N=8; 
d=0.04;
B1=beam_pattern(d,N,f,thetas,c,theta);
plot(theta,20*log10(abs(B1)),'r');
hold on
title('Delay and Sum pattern, variable d');
d=0.08;
B2=beam_pattern(d,N,f,thetas,c,theta);
plot(theta,20*log10(abs(B2)),'b');
d=0.16;
B3=beam_pattern(d,N,f,thetas,c,theta);
plot(theta,20*log10(abs(B3)),'g');
legend('d=4cm','d=8cm','d=16cm')

hold off

%% 1.4.3
N=8;
d=0.04;
c=340;   %ταχύτητα ήχου
theta=(-pi:0.001*pi:pi);

thetas=0; %γωνία
B1=beam_pattern(d,N,f,thetas,c,theta);
figure()
semilogr_polar(theta,abs(B1));
title('theta_s=0');

thetas=pi/4; %γωνία
B1=beam_pattern(d,N,f,thetas,c,theta);
figure()
semilogr_polar(theta,abs(B1));
title('theta_s=45');

thetas=pi/2; %γωνία
B1=beam_pattern(d,N,f,thetas,c,theta);
figure()
semilogr_polar(theta,abs(B1));
title('theta_s=90');

%% PART 2   2.1
%
% A.1

N=7;
d=0.04;
Fs=48000;
source=audioread('source_sim.wav');             %διαβασε τα σηματα
sensor1(:,1)=audioread('sensor_0_sim.wav');
sensor1(:,2)=audioread('sensor_1_sim.wav');
sensor1(:,3)=audioread('sensor_2_sim.wav');
sensor1(:,4)=audioread('sensor_3_sim.wav');
sensor1(:,5)=audioread('sensor_4_sim.wav');
sensor1(:,6)=audioread('sensor_5_sim.wav');
sensor1(:,7)=audioread('sensor_6_sim.wav');

yt = beamforming(sensor1,d,N,c,pi/4);    %υπολόγισε τα βάρη και την έξοδο στη συναρτηση 
audiowrite('sim_ds.wav',yt,Fs);

%%A.2 Waveforms and Spectrograms
noise=source-yt';
figure(); 
subplot(3,1,1);
plot(yt)
title('Beamformer Output');
xlabel('samples');
ylabel('Amplitude');
subplot(3,1,2);
plot(source,'r')
xlabel('samples');
ylabel('Amplitude');
title('original Voice');
subplot(3,1,3);
plot(noise,'g')
xlabel('samples');
ylabel('Amplitude');
title('Noise');

 
 central_mic=sensor1(:,4);          % Central microphone is in 4th column of array sensor1
 figure()
subplot(3,1,1);
L=0.02*Fs;
% Spectogram usage: [S,F,T,P] = spectrogram(x,window,noverlap,nfft,fs)
[~,F,T,P] = spectrogram(source, hamming(L), 3*L/4, L,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of original signal');


subplot(3,1,2);
[~,F,T,P] = spectrogram(central_mic, hamming(L), 3*L/4, L,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of noised signal');
xlabel('Time (Seconds)'); ylabel('Hz');

subplot(3,1,3);

[~,F,T,P] = spectrogram(yt, hamming(L), 3*L/4, L,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Beamformers output');
xlabel('Time (Seconds)'); ylabel('Hz');

%%A.3 SNR 

x_snr =snr(central_mic,source)
y_snr =snr(yt',source)

%% Part 2.1
%
% B.1

frame = audioread('sensor_3_sim.wav',[36000,37439]);   %Select frames
[source,Fs] = audioread('source_sim.wav',[36000,37439]);    
noise=frame-source;            %Find noise

wind=Fs*10/10^3;    %window
winovlp=wind/2;     %window overlap
f=(1:8000);         %frequency vector
[Px,f]=pwelch(frame,wind,winovlp,f,Fs,'twosided');  %power spectrum of noised signal
[Pu,f]=pwelch(noise,wind,winovlp,f,Fs,'twosided');  %power spectrum of noise
Hw=1-Pu./Px;    %Wiener filter
figure();
plot(f,10*log10(abs(Hw)))
xlabel('frequency');
ylabel('Magnitude (dB)');
title('Wiener Filter');
ylim([-60,2]);

%%B.2
figure();
nsd=abs(1-Hw).^2;  %speech distortion index
plot(f,10*log10(abs(nsd)))
xlabel('frequency');
ylabel('Magnitude (dB)');
title('Nsd');
%%Εφαρμογή του Wiener  B.3

Px=pwelch(frame,wind,winovlp,1440,'twosided');
Pu=pwelch(noise,wind,winovlp,1440,'twosided');
Hw=1-Pu./Px;
output=real(ifft(fft(frame).*Hw));
frame_multchannel=yt(1,36000:37439);


figure();
subplot(4,1,1)
plot(output);
ylim([-0.4 0.4])
title('Wiener output')
subplot(4,1,2)
plot(frame,'g');
ylim([-0.4 0.4])
title('Wiener input')
subplot(4,1,3)
plot(frame_multchannel,'b');
ylim([-0.4 0.4])
title('DAS beamformer output')
subplot(4,1,4)
plot(source,'r');
ylim([-0.4 0.4])
title('source')


f=(1:8000);
[Po,f]=pwelch(output,wind,winovlp,f,Fs,'twosided');
[Px,f]=pwelch(frame,wind,winovlp,f,Fs,'twosided');  %power spectrum of noised signal
[Ps,f]=pwelch(source,wind,winovlp,f,Fs,'twosided'); %power spectrum of original voice
[Pu,f]=pwelch(noise,wind,winovlp,f,Fs,'twosided');  %power spectrum of noise


figure();
title('Power Spectra');
plot(f,10*log10(Ps),'b');
hold on; 
plot(f,10*log10(Px),'g');
plot(f,10*log10(Pu),'r');
plot(f,10*log10(Po),'y');
legend('source','Wiener Input','Noise','wiener output')
%φασματα ισχύος για τα 4 σηματα

[Pmult,f]=pwelch(frame_multchannel,wind,winovlp,f,Fs,'twosided');
figure();
title('Power Spectra');
plot(f,10*log10(Ps),'b');
hold on; 
plot(f,10*log10(Px),'g');
plot(f,10*log10(Pmult),'r'); 
plot(f,10*log10(Po),'y');
legend('source','Wiener Input','Beamformer','wiener output')


%%Β.4
frame=frame./max(frame);        %normalize signal
source=source./max(source);
frame_multchannel=frame_multchannel./max(frame_multchannel);
output=output./max(output);

out_snrWiener =snr(output,source)
inp_snrWiener=snr(frame,source)
y_snrWiener =snr(frame_multchannel',source)




%% Part 2.2
%
%%A.1
N=7;
d=0.08;
Fs=48000;
source=audioread('source.wav');
sensor(:,1)=audioread('sensor_0.wav');
sensor(:,2)=audioread('sensor_1.wav');
sensor(:,3)=audioread('sensor_2.wav');
sensor(:,4)=audioread('sensor_3.wav');
sensor(:,5)=audioread('sensor_4.wav');
sensor(:,6)=audioread('sensor_5.wav');
sensor(:,7)=audioread('sensor_6.wav');

yt = beamforming(sensor,d,N,c,pi/2);

%%A.2
noise=source-yt';
figure(); 
subplot(3,1,1);
plot(yt)
title('beamformers output');
xlabel('samples');
ylabel('amplitude');
subplot(3,1,2);
plot(source,'r')
title('Original signal');
xlabel('samples');
ylabel('amplitude');
subplot(3,1,3);
plot(noise,'g')
title('Noise');
xlabel('samples');
ylabel('amplitude');

central_mic=sensor(:,4);

figure()
subplot(3,1,1);
% Spectogram usage: [S,F,T,P] = spectrogram(x,window,noverlap,nfft,fs)
[~,F,T,P] = spectrogram(yt,  hamming(L), 3*L/4, L,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Beamformers output');

subplot(3,1,2);
[~,F,T,P] = spectrogram(source,  hamming(L), 3*L/4, L,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of original Voice');
xlabel('Time (Seconds)'); ylabel('Hz');

subplot(3,1,3);
[~,F,T,P] = spectrogram(central_mic, hamming(L), 3*L/4, L,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of noised signal');
xlabel('Time (Seconds)'); ylabel('Hz');

%%A.3 SSNR
%central_mic=central_mic./max(central_mic);
source=source./max(source);
pure_noise_frame=yt(10^4:10^4+1440);
pure_noise_frame2=central_mic(10^4:10^4+1440);

SSnr=ssnr(central_mic,source,Fs,pure_noise_frame2)
SSnr2=ssnr((yt./max(yt))',source,Fs,pure_noise_frame')

audiowrite('real_ds.wav',yt,Fs);

%% Part B( Optional)
%post filtering with Wiener
%  1

winlen=30*10^-3*Fs;
winoverlap=20*10^-3*Fs;
siglen=length(yt);
winstep = winlen - winoverlap;   
w=hamming(winlen);      
pos = 1; i = 1;
 while (pos+winlen < siglen)
     frames(:,i) = yt(pos:pos+winlen-1);
     pos = pos + (winlen - winoverlap);
     i = i + 1;
 end
nw = size(frames,2);
s= zeros(1,siglen);   %voice reconstruction
count=1;               % Define a counter for the begining sample of the moving window 

pure_noise_frame=yt(10^4:10^4+1440);
Pu=pwelch(pure_noise_frame,wind,winovlp,1440,'twosided');
wind=Fs*10/10^3;    %window
winovlp=wind/2;     %window overlap

for i=1:nw 
    currentframe = frames(:,i); 
    Px=pwelch(currentframe,wind,winovlp,1440,'twosided');
    Hw=1-Pu./Px;
    output=real(ifft(fft(currentframe).*Hw));
    windowedframe = w.*output;     

    % Overlap - Add: Add the reconstructed frame into the reconstruction buffer 
    % by overlapping the i-1 segment by 2/3 of window size
    
    segstart = count;
    segend = min((segstart+winlen-1),siglen);
    seglen = segend - segstart + 1;
    
    s(segstart:segend) = s(segstart:segend) + windowedframe(1:seglen)'; 
    count = count + winstep;
end    

%
%%Q2
% Waveforms and Spectrograms

source=audioread('source.wav');
[len, ~]=size(source);
central_mic=sensor(:,4);

figure(); 
subplot(4,1,1);
plot(source)
title('source');
xlabel('samples');
ylabel('amplitude');
subplot(4,1,2);
plot(central_mic,'r')
title('Noisy signal (central microphone)');
xlabel('samples');
ylabel('amplitude');
subplot(4,1,3);
plot(yt,'g')
title('Beamformer output/Wiener input');
xlabel('samples');
ylabel('amplitude');
subplot(4,1,4);
plot(s,'m')
title('Wiener output');
xlabel('samples');
ylabel('amplitude');


figure()
subplot(4,1,1);
% Spectogram usage: [S,F,T,P] = spectrogram(x,window,noverlap,nfft,fs)
[~,F,T,P] = spectrogram(source,  hamming(L), 3*L/4, L,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of original Voice');
xlabel('Time (Seconds)'); ylabel('Hz');

subplot(4,1,2);
[~,F,T,P] = spectrogram(central_mic,  hamming(L), 3*L/4, L,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of noisy signal');
xlabel('Time (Seconds)'); ylabel('Hz');

subplot(4,1,3);
[S,F,T,P] = spectrogram(yt, hamming(L), 3*L/4, L,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of beamformer output/Wiener input');
xlabel('Time (Seconds)'); ylabel('Hz');

subplot(4,1,4);
[S,F,T,P] = spectrogram(s, hamming(L), 3*L/4, L,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
title('Spectrogram of Wiener output');
xlabel('Time (Seconds)'); ylabel('Hz');


pure_noise_frame3=s(10^4:10^4+1440);
audiowrite('real_mmse.wav',s,Fs);

%%A.3 SSNR
%central_mic=central_mic./max(central_mic);
source=source./max(source);
yt=yt./max(yt);
SSNR=ssnr(yt',source,Fs,pure_noise_frame')
SSNR2=ssnr(s',source,Fs,pure_noise_frame3')