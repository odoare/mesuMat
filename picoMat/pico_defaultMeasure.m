function mesu = pico_defaultMeasure()
% function mesu = defaultmeasure()
% Outputs the defaults measurement parameters in the structure "mesu"

    mesu.saveFile = 'outputfilename.mat' ;
    mesu.picoDev = 'ps2000' ;
    mesu.Fs = 50000 ;
    mesu.duration = 2 ;
    mesu.upSample = 20 ;
    mesu.nChannels = 2 ;
    mesu.inRange = {8, 8} ;
    mesu.inCoupling = {1, 1} ;
    mesu.inDesc = {'chAInfo','chBInfo'} ;
    mesu.inCal = [1, 1] ;
    mesu.inUnit = {'V', 'V'} ;
    mesu.sg = 0 ;
    mesu.sgType = 'sweep' ;
    mesu.sgAmplitude = 1 ;
    mesu.sgStartFrequency = 100 ;
    mesu.sgEndFrequency = 1000 ;
    mesu.sgRepetitions = 3 ;
    mesu.displayLiveData = -1 ;
        
