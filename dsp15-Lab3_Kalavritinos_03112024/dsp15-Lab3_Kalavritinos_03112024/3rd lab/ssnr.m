function[SSNR] = ssnr(x,source,Fs,noiseframe)
L=30*10^-3*Fs;              %frame length
m=floor(length(x)/L);       %number of frames
sum=0;
k=0;
for i=0:m-1
        Snr=snr_2(x(L*i+1:L*i+L,1),source(L*i+1:L*i+L,1),noiseframe);   %find SNR for the frame
        if Snr>35
            Snr=35;             % κατώφλια
        elseif Snr<-10
                Snr=0;
                k=k+1;    
        end
        sum=sum+Snr;            %άθροισέ τα
end

SSNR=sum/m;             % βγάλε μέσο όρο