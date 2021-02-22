[x, Fs]=audioread('speech.wav');
load('pitch.mat');
siglen=length(x);
winlen = round(30 * Fs / 1000); % convert ms to points
winovlp = round(20* Fs / 1000); % convert ms to pointssiglen = length(s);
w=hamming(siglen);
t0 = [0:(length(x)-1)] / Fs;
%% part 1
[F0, T,c] = PitchTrackCepstrum(x, Fs, winlen, winovlp);
 figure;
  plot(t,pitch);
 hold on
    plot(T,F0,'r');
    legend('pitch track');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
%% part 2
[x2,e1,~]=lpc_vocoder(x,Fs,winlen,winovlp,pitch);
%sound(x2,48000);
%% part 3.1
[x3,e2]=ltp_filter(x,Fs,winlen,winovlp,pitch);
%sound(x3,48000);

figure()
subplot(3,1,1);
plot(t0,x)
box off  %removing box
grid on  %adding grid
title('Inputted signal');
xlabel('Time (Seconds)'); ylabel('signal');
axis([t(1), t(end), -2, 2])  %axis limits

subplot(3,1,2);
plot(t0,e1)
box off  %removing box
grid on  %adding grid
title('error e1');
xlabel('Time (Seconds)'); ylabel('e1');
axis([t(1), t(end), -0.1, 0.1])  %axis limits

subplot(3,1,3);
plot(t0,e2)
box off  %removing box
grid on  %adding grid
title('error e2');
xlabel('Time (Seconds)'); ylabel('e2');
axis([t(1), t(end), -2, 2])  %axis limits

%% part 3.2
c=0.8;   %perceptual filter constant
winlen=8*Fs/1000;
Pidx=[round(winlen/10) winlen];     
L=winlen/4;
clc
fprintf('computing codebook...');
cb=cb_gener(L);
fprintf('Done!\n');
winovlp=2/3*winlen;
[x4,e] = celp(x,winlen,L,c,cb,Pidx,Fs,winovlp);
%sound(x4,48000)

%% part 4
%Quantization
winlen = round(30 * Fs / 1000); % convert ms to points
winovlp = round(20* Fs / 1000); % convert ms to pointssiglen = length(s);
t0 = [0:(length(x)-1)] / Fs;

[x5,e3]=lpc_encoded(x,Fs,winlen,winovlp,pitch);
%sound(x5,48000);


c=0.8;   %perceptual filter constant
winlen=12*Fs/1000;
Pidx=[round(winlen/10) winlen];     
bbuf=0; 
ebuf=zeros(winlen,1);
L=winlen/4;
clc
fprintf('computing codebook...');
cb=cb_gener(L);
fprintf('Done!\n');
winovlp=8*Fs/1000;

[x6] = celp_enc(x,winlen,L,c,cb,Pidx,Fs,winovlp);
%sound(x6,48000)