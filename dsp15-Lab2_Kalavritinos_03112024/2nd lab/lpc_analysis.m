function [a, G, lpc_error] = lpc_analysis(speech_frame,lpc_order)
% a: LPC coefficients
% G: gain 
% Signal length
siglen = length(speech_frame);
% Window length
winlen = siglen;
% Window signal
w = hamming(winlen);
% Segment Smoothing
speech_frame = speech_frame .* w;
% LPC coefficients
a = lpc(speech_frame,lpc_order);  
% Reconstructed signal
speech_frame_est = filter([0 -a(2:end)],1,speech_frame);                                                                                                                                                                                                          
% Reconstruction error
lpc_error = speech_frame - speech_frame_est;
% Gain
error_energy = sum(lpc_error.^2);
G = sqrt(error_energy);                

end
