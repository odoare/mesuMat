function h = audio_plotMeasure(mesu,nn)
% h = audio_plotMeasure(mesu,nn)
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
    ylim([-1.1 1.1]) ;
    xlabel ('T (s)') ;
    ylabel ('Data (-)') ;

    hold on
    plot([min(mesu.t),max(mesu.t)],[1 1])
    plot([min(mesu.t),max(mesu.t)],[-1,-1])
    hold off
    legend([mesu.inDesc {'-1 (0 dBFS)','1 (0 dBFS)'}]) ;
    
