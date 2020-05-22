function [t,y] = bandFreqNoise(duration,Fs,F1,F2,amp)
    %% Noise filtered between F1 and F2
    leng = duration * Fs ;
    freqs = Fs*[0:leng/2-1]/(leng) ;
    ampl = ((freqs>F1) & (freqs<F2))*sqrt(leng);
    phase = 2*pi*(rand(1,leng/2)-0.5) ;
    ffty = ampl.*exp(1i*phase) ;
    ffty = [ffty(1:end),fliplr(ffty(1:end))] ;
    y = ifft(ffty,'symmetric').' ;
    t = (0:1/Fs:duration-1/Fs).' ;
    y = sqrt(2)*amp*y/rms(y) ;
