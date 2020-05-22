function mesu = ni_myStream(mesu)
%
% function mesu = ni_myStream(mesu) 
% Performs the data acquisition session described by the field mesu
% and add the resulting input data in the structure
%
% v0.01 - March, 19th 2020 - O. Doaré - olivier.doare@ensta-paris.fr

% create session
s = daq.createSession('ni');

% Set session properties
s.Rate = mesu.effectiveFrequency; % sampling rate

% Add Input Channels to Session
for i1 = 1:length(mesu.inMap)
    addAnalogInputChannel(s,mesu.daqID,mesu.inName{i1},'Voltage');
end

% Add output Channels to Session
if mesu.sg
    addAnalogOutputChannel(s,mesu.daqID,mesu.outName,'Voltage');
    % send the output signal to the right output
    queueOutputData(s,mesu.outSig);
else
    s.DurationInSeconds = mesu.duration ;
end

% lauch measurement
[data,time] = s.startForeground;

mesu.date = date ;
mesu.time = clockString ;

% Extract voltage and time data

mesu.y = resample(data(:,1),1,mesu.upSample) ;
if length(mesu.inMap)>1
    for i1=2:length(mesu.inMap)
        mesu.y = [mesu.y , resample(data(:,i1),1,mesu.upSample)] ;
    end
end

mesu.t = time(1:mesu.upSample:end) ;

mesu.timestep = 1 / mesu.Fs ;
