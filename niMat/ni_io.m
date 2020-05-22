%
% ni_inout.m : Data acquisition with NI daq cards
% ---------------------------------------------------------------
%
% Prepare and launch a data acquisition with a NI card.
%
% The structure "mesu" contains all the measurement parameters as well as
% the acquired data. At the end of the process, the data is saved in a file
% whose filename is stored in "mesu.savefile".
%
% The acquisition process performed by this script consists in three steps:
%
% 1. Adjust the parameters of the acquisition task with the help of the
% function ni_ioDialog.m. If the "mesu" struct is already in the global
% wotkspace, its values are initialisation values of the gui, which is
% not launched if "mesu.nogui" exists and is true.
%
% 2. The acquisition task is launched. 
%
% 3. The resulting data is plotted and the "mesu" structure is saved in the
% file described by the "mesu.saveFile" string.
%
% v0.01 - May, 19th 2020 - O. Doaré - olivier.doare@ensta-paris.fr

if exist('mesu')~=0
    if isfield(mesu,'nogui')
        if ~mesu.nogui
            mesu = ni_ioDialog(mesu) ;
        end
    else
        mesu = ni_ioDialog(mesu) ;
    end
else
    mesu = ni_ioDialog() ;
end

mesu = createOutputSignal(mesu) ;

mesu = ni_myStream(mesu) ;

if isfield(mesu,'saveFile')
    save (mesu.saveFile,'mesu') ;
else
    warning('Warning: no saveFile, data not saved')
end

ni_plotMeasure(mesu) ;
