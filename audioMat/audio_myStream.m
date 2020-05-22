function mesu = audio_myStream(mesu)
%
% function mesu = audio_myStream(mesu) 
% Performs the data acquisition session described by the field mesu
% and add the resulting input data in the structure
%
% v0.01 - March, 19th 2020 - O. Doare - olivier.doare@ensta-paris.fr

% Audio config

apr = audioPlayerRecorder('SampleRate',mesu.Fs,...
   'BitDepth','32-bit float',...
   'BufferSize',8192,...
   'PlayerChannelMapping',mesu.outMap,...
   'RecorderChannelMapping',mesu.inMap);
mesu.audioDevName = apr.getAudioDevices{mesu.audioDev} ;
apr.Device = mesu.audioDevName ;

% Upsampling not implemented yet
% effectiveSamples = mesu.duration*mesu.effectiveFrequency ;

if mesu.sg
    if mesu.peakSync
        outsig = [onepeakinthemiddle(mesu.Fs); mesu.outSig; onepeakinthemiddle(mesu.Fs)] ;
    else
        outsig = mesu.outSig ;
    end
else
    outsig = zeros(length(mesu.outSig),1) ;
end

% Initialize variables
data = []; outind = 1 ; bufs = apr.BufferSize ; nu = 0 ; no = 0 ;

% Add zeros at the end of outsig so that it has a lentgh equal to an
% integer multiple of 'BufferSize'
outsig = [outsig;zeros(bufs-mod(length(outsig),bufs),1)] ;

if mesu.displayLiveData == -1
    choice = questdlg('Plot live data ?', '', 'Yes','No','Yes');
    dld = choice=='Yes' ;
else
    dld = mesu.displayLiveData ;
end 

disp('Recording started...')

while outind+bufs <= length(outsig)+1
    [audioRecorded,nUnderruns,nOverruns] = apr(outsig(outind:outind+bufs-1));
    data = [data;audioRecorded] ;
    outind = outind+bufs ;
    if dld
        figure(999)
        plot(audioRecorded)
        axis([0 bufs -1 1])
    end
    nu = nu+nUnderruns ;
    no = no+nOverruns ;
end
disp('Recording complete.')
disp (['Number of overruns : ',num2str(no)]) ;
disp (['Number of underruns : ',num2str(nu)]) ;
release(apr);

% Get final data
if mesu.peakSync && mesu.sg
    [~,indy] = max(data(1:3*mesu.Fs/4,1)) ;
    istart = indy+mesu.Fs/2+1 ;
    iend = istart + mesu.duration*mesu.Fs - 1 ;
    mesu.y = data(istart:iend,:) ;
else
    mesu.y = data(1:mesu.duration*mesu.Fs,:) ;
end

mesu.date = date ;
mesu.time = clockString ;

% Upsampling not implemented yet
% mesu.y = resample(data(:,1),1,mesu.upSample) ;
% if length(mesu.inMap)>1
%     for i1=2:length(mesu.inMap)
%         mesu.y = [mesu.y , resample(data(:,i1),1,mesu.upSample)] ;
%     end
% end

mesu.t = (0:mesu.duration*mesu.Fs-1)'/mesu.Fs ;
mesu.timestep = 1 / mesu.Fs ;
