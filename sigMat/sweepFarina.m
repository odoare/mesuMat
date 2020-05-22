function [t,S] = sweepFarina(duration, Fs, F1, F2, amp)
  t = (0:round(Fs*duration)-1)/Fs;
  denom = log(F2/F1) ;
  K = 2*pi*F1*duration/denom ;
  L = duration/denom ;
  S = (amp*sin(K*(exp(t/L)-1))).';
  