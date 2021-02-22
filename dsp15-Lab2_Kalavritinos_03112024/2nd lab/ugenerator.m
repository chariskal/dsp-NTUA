function u = ugenerator(f,L,Fs)

% f  : pulse freq
% L  : output signal length
% Fs : sampling freq

% Usage: This function generates an excitation signal u as a pulse train 
%with T=1/f (f>0 intervals or a zero mean white-noise signal (if f<=0)
% In both case the signal length is L

    if (f <= 0)          
        
        % Random signal
        u = rand(1,L); 
        
        % Make u zero-mean
        u = u-mean(u);   
        
        % Unit Variance
        %u=u/sqrt(var(u));
        
        % Energy Normalization
         %u=u/sqrt(sum(u.^2));
    else                
        u = zeros(1,L);
        
        % Pulse train
        u(1:ceil((1/f)*Fs):L) = 1; 

    end

end