function diff_len_ZCRtesting(signal_input,win_length,N,Fs,ts)

           for i=1:length(win_length)  
              winamp = [1,5]*(1/win_length(i));

              zc = zerocross(signal_input,winamp(1),win_length(i));

              % time index for the ST-ZCR and STE after delay compensation
        out = round((win_length(i)-1)/2):(N+win_length(i)-1)-round((win_length(i)-1)/2);
              t = (out-(win_length(i)-1)/2)*(1/Fs);

              
              subplot(2,2,i), plot(ts,signal_input); hold on;
              subplot(2,2,i), plot(t,zc(out),'r'); xlabel('t, seconds');
              title('Short-time Zero Crossing Rate'); 
            end


end