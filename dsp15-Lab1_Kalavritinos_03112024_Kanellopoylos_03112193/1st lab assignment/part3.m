  %% q 3.1
  [signal_input,Fs]=wavread('speech_utterance.wav');
  signal_input=signal_input';
  N=length(signal_input);
T=1/Fs;
n=0:N-1;
ts=n*T;
 
win_length=Fs*20*10^-3+1;
winamp = [1,5]*(1/win_length);

zc = zerocross(signal_input,winamp(1),win_length);
E = energy(signal_input,winamp(2),win_length);

   % time index for the ST-ZCR and STE after delay compensation
  out = (win_length-1)/2:(N+win_length-1)-(win_length-1)/2;
  t = (out-(win_length-1)/2)*(1/Fs);

  figure(1);
   plot(ts,signal_input); hold on;
   plot(t,zc(out),'r'); xlabel('t, seconds');
   title('Short-time Zero Crossing Rate');
   legend('signal','STZCR');

  figure(2);
   plot(ts,signal_input); hold on;
   plot(t,E(out),'r'); xlabel('t, seconds');
   title('Short-time Energy');
   legend('signal','STE');
   %waitforbuttonpress
      
 %Different hamming window lengths testing             
  win_length=[Fs*10*10^-3+1,Fs*20*10^-3+1, Fs*40*10^-3+1, Fs*80*10^-3+1];
     
  figure(3); 
  diff_len_ZCRtesting(signal_input,win_length,N,Fs,ts)

  figure(4);
  diff_len_ENtesting(signal_input,win_length,N,Fs,ts)
% waitforbuttonpress          
 clear all;         
%% q 3.2

 [signal_input,Fs]=wavread('music.wav');
  signal_input=signal_input';
  N=length(signal_input);
T=1/Fs;
n=0:N-1;
ts=n*T;
 
win_length=Fs*20*10^-3+1;
winamp = [1,5]*(1/win_length);

zc = zerocross(signal_input,winamp(1),win_length);
E = energy(signal_input,winamp(2),win_length);

   % time index for the ST-ZCR and STE after delay compensation
  out = round((win_length-1)/2):(N+win_length-1)-round((win_length-1)/2);
  t = (out-(win_length-1)/2)*(1/Fs);

  figure(5);
   plot(ts,signal_input); hold on;
   plot(t,zc(out),'r'); xlabel('t, seconds');
   title('Short-time Zero Crossing Rate');
   legend('signal','STZCR');

  figure(6);
   plot(ts,signal_input); hold on;
   plot(t,E(out),'r'); xlabel('t, seconds');
   title('Short-time Energy');
   legend('signal','STE');
   %waitforbuttonpress
                
   %Different hamming window lengths testing             
  win_length=[Fs*10*10^-3+1,Fs*20*10^-3+1, Fs*40*10^-3+1, Fs*80*10^-3+1];
    
  figure(7); 
  diff_len_ZCRtesting(signal_input,win_length,N,Fs,ts)

  figure(8);
  diff_len_ENtesting(signal_input,win_length,N,Fs,ts)