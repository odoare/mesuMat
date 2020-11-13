function mesu = ni_defaultMeasure()
% function mesu = defaultmeasure()
% Outputs the default set of measurement parameters in the structure "mesu"

    mesu.saveFile = 'outputfilename.mat' ;
    mesu.daqID = 'Dev1';
    mesu.Fs = 44100 ;
    mesu.duration = 2 ;
    % Up sampling not implemented yet for NI cards
    % mesu.upSample = 1 ;
    mesu.inMap = [1] ;
    mesu.inDesc = {'ai0 Desc','ai1 Desc','ai2 Desc','ai3 Desc','ai4 Desc','ai5 Desc'} ;
    mesu.inCal = [1 1] ;
    mesu.inUnit = {'V', 'V'} ;
    mesu.sg = 0 ;
    mesu.outMap = [1] ;
    mesu.sgType = 'LogSweep' ;
    mesu.sgAmplitude = 1 ;
    mesu.sgStartFrequency = 100 ;
    mesu.sgEndFrequency = 1000 ;
    mesu.sgRepetitions = 3 ;
    mesu.displayLiveData = 0 ;
