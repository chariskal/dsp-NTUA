function SN = snr_2( signal, source,noiseframe)
%�������� ������� ������

    energy.sig = signal.' * signal;
    energy.n = noiseframe.' * noiseframe + eps;

    SN = 10*log10( energy.sig ./ energy.n + eps );
end
