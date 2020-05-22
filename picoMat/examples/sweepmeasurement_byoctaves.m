% Sweep measurement between 20 and 20000 Hz by octaves
%
% ... a way to produce a sort of logarithmic sweep with picoscope ...
%
% The correctness of the impulse response computation has to be checked...
%
% 

% SCOPE TYPE
mesu.deviceType = 'ps2000' ;

% Base of the file names for the measurements
basefilename = 'test_' ;

% Octave frequency bands
frequencies = [20,40,80,160,320,640,1280,2560,5120,10240,20000] ;

% Measurement parameters
mesu.Fs = 50000 ;
mesu.duration = 1 ;
mesu.upSample = 20 ;
mesu.inRange{1} = 7 ;
mesu.inRange{2} = 6 ;
mesu.inCoupling{1} = 1 ;
mesu.inCoupling{2} = 1 ;
mesu.inDesc = {'Channel A','Channel B'} ;
mesu.sg = 1 ;
mesu.sgType = 'Sweep' ;
mesu.sgAmplitude = 1 ;
mesu.sgRepetitions = 3 ;
mesu.displayLiveData = 1 ;
mesu.inCal = [1, 1] ;
mesu.inUnit = {'V', 'V'} ;
mesu.nogui = true ;

% Measurements between each pair of frequencies

for i1 = 1:length(frequencies)-1
    mesu.saveFile = [basefilename,num2str(i1),'.mat'] ;
    mesu.sgStartFrequency = frequencies(i1) ;
    mesu.sgEndFrequency = frequencies(i1+1) ;
    pico_io ;
    pico_arrangeAndSaveData ;
end

% Transfer function computation for each octave

for i1 = 1:length(frequencies)-1
    filenam = [basefilename,num2str(i1),'.mat'] ;
    load(filenam) ;
    [freq,H] = tfMeasure(mesu,1,[1 2],2^15) ;
    if i1==1
        Hout = H ;
        freqout = freq ;
    end
    Hout(find(freq<mesu.sgEndFrequency&freq>=mesu.sgStartFrequency)) ...
        = H(find(freq<mesu.sgEndFrequency&freq>=mesu.sgStartFrequency)) ;
    freqout(find(freq<mesu.sgEndFrequency&freq>=mesu.sgStartFrequency)) ...
        = freq(find(freq<mesu.sgEndFrequency&freq>=mesu.sgStartFrequency)) ;
end

H = Hout(find(freqout<=mesu.sgEndFrequency)) ;
fH = freqout(find(freqout<=mesu.sgEndFrequency)) ;

figure(1)
subplot(2,1,1)
hold on 
plot(fH,20*log10(abs(H))) ;
xlabel('Freq(Hz)')
ylabel('20 log_{10} |H|')
title(['TF beween ',mesu.inDesc{1},' and ',mesu.inDesc{2}])
subplot(2,1,2)
hold on 
plot(fH,angle(H)) ;
xlabel('Freq(Hz)')
ylabel('Phase (rad)')

% Compute impulse response (ifft of the symetrized transfer function)

G = ifft([H(1:end-1).',fliplr(H(1:end).')].') ;
tG = [0:1/mesu.sgEndFrequency/2:1/(fH(2)-fH(1))] ;

figure(2)
hold on 
plot (tG, real(G),'-o')
xlabel Time
ylabel ('G(t)')
title(['Impulse response'])
%hold on

save ([basefilename,'traite.mat'], 'H', 'fH', 'G', 'tG') ;
