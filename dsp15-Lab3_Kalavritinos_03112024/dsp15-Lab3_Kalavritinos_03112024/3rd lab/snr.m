function SN = snr( signal, source )
    noise = source(:) - signal(:);  %find noise
    energy.sig = signal.' * signal; %find energies
    energy.n = noise.' * noise + eps;
    SN = 10*log10( energy.sig ./ energy.n + eps );      %compute SNR
end
