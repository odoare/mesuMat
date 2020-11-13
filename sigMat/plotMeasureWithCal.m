function h = plotMeasureWithCal(mesu,nn)
% h = plotmeasure(mesu,nn)
%
% Creates a figure and plots the data contained in the measure strucutre
% "mesu". nn is the figure number (optionnal). h is a figure handle.
%
% The calibration describer by mesu.cal and mesu.unit is applied to the
% plotted data.
%
% v0.01 - March, 9th 2020 - O. Doaré - olivier.doare@ensta-paris.fr

    if exist('nn')
        h = figure(nn) ;
    else
        h = figure ;
    end
    
    if isfield(mesu,'in0dBFS')
        fact = mesu.in0dBFS ;
    else
        fact = ones(1,length(mesu.inDesc)) ;
    end

    legendca = {} ;
    for i1=1:length(mesu.inDesc)
        %legendca = {legendca{:} ; ['Channel ',num2str(i1),' (',mesu.inUnit{1},')']} ;
        legendca = {legendca{:} , [mesu.inDesc{i1},' (',mesu.inUnit{i1},')']} ;
    end
    
    plot(mesu.t,fact.*mesu.y./mesu.inCal,'linewidth',2) ;
    xlabel ('T (s)') ;
    ylabel ('Data') ;

    legend(legendca) ;
