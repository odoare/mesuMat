function h = pico_plotMeasure(mesu,nn)
% h = plotmeasure(mesu,nn)
%
% Creates a figure and plots the data contained in the measure strucutre
% "mesu". nn is the figure number (optionnal). h is a figure handle.
%
% v0.01 - March, 9th 2020 - O. Doaré - olivier.doare@ensta-paris.fr


    if exist('nn')
        h = figure(nn) ;
    else
        h = figure ;
    end

    plot(mesu.t,mesu.y,'linewidth',2) ;
    ylim([-1.5*max([mesu.inNumRange{1},mesu.inNumRange{2}]),1.5*max([mesu.inNumRange{1},mesu.inNumRange{2}])]) ;
    xlabel ('T (s)') ;
    ylabel ('Volts') ;

    hold on
    plot([min(mesu.t),max(mesu.t)],[mesu.inNumRange{1},mesu.inNumRange{1}])
    plot([min(mesu.t),max(mesu.t)],[-mesu.inNumRange{1},-mesu.inNumRange{1}])
    plot([min(mesu.t),max(mesu.t)],[mesu.inNumRange{2},mesu.inNumRange{2}])
    plot([min(mesu.t),max(mesu.t)],[-mesu.inNumRange{2},-mesu.inNumRange{2}])
    hold off
    legend({'Channel A' ; 'Channel B' ; 'Range A' ; 'Range A' ; 'Range B' ; 'Range B'}) ;
