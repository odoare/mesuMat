function mesu = audio_defaultMeasure()
% function mesu = audio_defaultMeasure()
% Outputs a default set of measurement parameters

    mesu.saveFile = 'outputfilename.mat' ;
    mesu.audioDev = 1 ;
    mesu.Fs = 44100 ;
    mesu.duration = 2 ;
    mesu.upSample = 1 ;
    mesu.inMap = [1 2] ;
    mesu.inDesc = {'ai0Info','ai1Info'} ;
    mesu.inCal = [1 1] ;
    mesu.in0dBFS = [5.17 5.17] ;    
    mesu.inUnit = {'V', 'V'} ;
    mesu.sg = 0 ;
    mesu.outMap = [1] ;
    mesu.sgType = 'LogSweep' ;
    mesu.sgAmplitude = 1 ;
    mesu.sgStartFrequency = 100 ;
    mesu.sgEndFrequency = 1000 ;
    mesu.sgRepetitions = 3 ;
    mesu.peakSync = 1 ;
    mesu.displayLiveData = 0 ;
    
