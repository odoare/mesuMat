function y = fftfilter(data,Fs,F1,F2)

len = size(data,1) ;

fftdata = fft(data) ;
freq = ((0:len-1)*Fs/len).';

fftdata([find(freq<F1);...
    find(freq>F2 & freq<(Fs-F2));...
    find(freq>Fs-F1)],:) = 0 ;

y = ifft(fftdata)  ;





