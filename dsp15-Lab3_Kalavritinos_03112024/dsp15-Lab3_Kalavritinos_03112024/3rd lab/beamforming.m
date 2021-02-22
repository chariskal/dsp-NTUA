function[signal] = beamforming(sensor,d,N,c,Thet)
w= linspace(-pi,pi,length(sensor)).*48000; 

tau=zeros(N,1);
    for n=0:N-1
    tau(n+1)=(-1*(n-((N-1)/2))*d*cos(Thet))/c;
    end
summed_sig=0;
sensor=sensor';
for k=1:N
    s=(fft(sensor(k,:))).*exp(1j*tau(k,:)*w);
    summed_sig=s/N+summed_sig; 
end
signal=real(ifft(summed_sig));
end