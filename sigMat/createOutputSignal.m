function mesu = createOutputSignal(mesu)
% createOutputSignal.m
% Create the output signal described by the fields of mesu
% and add it in the structure mesu
%
% v0.01 - March, 19th 2020 - O. Doar� - olivier.doare@ensta-paris.fr

% If up sampling factor is not defined, it is considered to be unity
if isfield(mesu,'upSample')
    ups = mesu.upSample ;
else
    ups = 1 ;
end

effFs = mesu.Fs*ups ;

switch mesu.sgType
    case 'LogSweep'
        [~,mesu.outSig] = sweepFarina(mesu.duration,...
            effFs,...
            mesu.sgStartFrequency * ups,...
            mesu.sgEndFrequency * ups,...
            mesu.sgAmplitude) ;        
    case 'Noise'
        [~,mesu.outSig] = bandFreqNoise(mesu.duration,...
            effFs,...
            mesu.sgStartFrequency * ups,...
            mesu.sgEndFrequency * ups,...
            mesu.sgAmplitude) ;        
    case 'File'
        [os,Fs] = audioread(mesu.sgFile) ;        
        mesu.outSig = os(:,1) ;
        if effFs ~= Fs
            warning(['File frequency = ',num2str(Fs),'Hz  is different than requested'])
        end
end
