% pico_plotAndSaveData.m
%
% Plots the data in the measurement "mesu" and save "mesu" in the .mat
% file described by the string "mesu.savefile"
%
% v0.01 - March, 9th 2020 - O. Doaré - olivier.doare@ensta-paris.fr

mesu.y = [resample(bufferChA,1,mesu.upSample),resample(bufferChB,1,mesu.upSample)]/1000 ;

mesu.t = time(1:mesu.upSample:end).' ;

mesu.timeStep = 1 / mesu.Fs ;

%mesu = rmfield(mesu,{'bufferChA','bufferChB','time'}) ;

if abs((mesu.timeStep-mesu.t(2)+mesu.t(1))/mesu.timeStep) > 1e-6 
    disp ('Warning sampling frequency different than requested') ;
end

save (mesu.saveFile,'mesu') ;

