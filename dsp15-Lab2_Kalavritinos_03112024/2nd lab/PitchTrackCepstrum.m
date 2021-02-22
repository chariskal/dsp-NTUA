function [F0, T,c] = PitchTrackCepstrum(x, fs, nsample, noverlap)
 %% Initialization
 N = length(x);
window=hamming(nsample);
 %% Pitch detection for each frame
 pos = 1; i = 1;
 F0=zeros(1,580);
 while (pos+nsample < N)
     frame = x(pos:pos+nsample-1).*window;
     [F0(i),c(i)] = pitch(frame, fs);

     pos = pos + (nsample - noverlap);
     i = i + 1;
 end

 T = (round(nsample/2):(nsample-noverlap):N-1-round(nsample/2))/fs;
    % plot waveform
    subplot(2,1,1);
    t = (0:N-1)/fs;
    plot(t, x);
    legend('Waveform');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([t(1) t(end)]);

    % plot F0 track
    subplot(2,1,2);
    plot(T,F0);
    legend('pitch track');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    xlim([t(1) t(end)]);
    
end