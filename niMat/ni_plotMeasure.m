function h = ni_plotMeasure(mesu,nn)
% h = ni_plotMeasure(mesu,nn)
%
% Creates a figure and plots the data contained in the measure strucutre
% "mesu". nn is the figure number (optionnal). h is a figure handle.
%
% v0.01 - March, 19th 2020 - O. Doaré - olivier.doare@ensta-paris.fr


    if exist('nn')
        h = figure(nn) ;
    else
        h = figure ;
    end

    plot(mesu.t,mesu.y,'linewidth',2) ;
    ylim([-11 11]) ;
    xlabel ('T (s)') ;
    ylabel ('Volts') ;

    hold on
    plot([min(mesu.t),max(mesu.t)],[10 10])
    plot([min(mesu.t),max(mesu.t)],[-10,-10])
    hold off
    legend([mesu.inDesc {'-10V','10V'}]) ;
