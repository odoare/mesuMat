%
% pico_io.m : Data acquisition with Picoscope 2000 or 4000 driver
% ---------------------------------------------------------------
%
% Prepare and launch a data acquisition with a picoscope ps2000 or ps4000.
%
% The structure "mesu" contains all the measurement parameters as well as
% the acquired data. At the end of the process, the data is saved in a file
% whose filename is stored in "mesu.savefile".
%
% The acquisition process performed by this script consists in three steps:
%
% 1. Adjust the parameters of the acquisition task with the help of the
% function pico_io_dialog.m. If the "mesu" struct is already in the global
% wotkspace, its values are initialisation values of the gui, which is
% not launched if "mesu.nogui" exists and is true.
%
% 2. The acquisition task is launched. A different script is executed,
% depending on the "mesu.deviceType". For now the later can take two
% values, "ps2000" or "ps4000", there are only such devices in my lab.
% Other devices could be added.
%
% 3. The resulting data is plotted and the "mesu" structure is saved in the
% file describe by the "mesu.savefile" string.
%
% v0.02 - May, 19th 2020 - O. Doaré - olivier.doare@ensta-paris.fr

if exist('mesu')~=0
    if isfield(mesu,'nogui')
        if ~mesu.nogui
            mesu = pico_ioDialog(mesu) ;
        end
    else
        mesu = pico_ioDialog(mesu) ;
    end
else
    mesu = pico_ioDialog() ;
end
    
if 1/mesu.upSample/mesu.Fs < 1e-6
    error(['Frequency = ',num2str(mesu.upSample*mesu.Fs),' Hz > 1MHz']) ;
    return ;
end

if mesu.duration*mesu.Fs*mesu.upSample > 10e6
    error(['Total number of samples = ',num2str(mesu.nsamples*mesu.upSample),' > 10^6']) ;
    return ;
end

if mesu.picoDev=='ps2000'
    if mesu.inRange{1}<2 || mesu.inRange{2}<2
        error(['A range < 50mV cannot be selected on 2204 and 2205 devices']) ;
        return ;
    end
end

switch mesu.picoDev
    case 'ps2000'
        ps2000_myFastStream ;
    case 'ps4000'
        ps4000_myFastStream ;
end

pico_arrangeAndSaveData ;

pico_plotMeasure(mesu) ;
