function [ar,kappa] = lpc_analysis_enc(signal_frame,order)
[rx,eta] = xcorr(signal_frame,order,'biased');
[a,~,kappa] = lev_dur(rx(order+1:2*order+1),order);
ar = [1; -a];
