function [freq,H] = tfMeasure(mesu, varargin)
% [freq,H] = tmeasure(mesu, varargin)
% 
% Compute the transfer function between the first and the second channel of
% the measurement structure "mesu". Pwelch method is used (tfestimate
% Matlab function)
%
% Optionnal parameters :
%
% displayPlot : If 1 the data is plotted
%
% map : a [1x2] vector specifying the input and output channels of the
%       measurement used in for the transfer function
%
%
% NFFT : The tfestimate function will be called using data windows of that
%        size.
%
% All other parameters of the Pwelch method are the defaults ones of
% tfestimate.
%
% Outputs are freq, a vector of frequencies, and H the transfer function
% cutted below the Nyquist frequency.
%
% v0.01 - March, 9th 2020 - O. Doaré - olivier.doare@ensta-paris.fr


if nargin<2
    NFFT = 2^15 ;
    displayPlot = false ;
    map = [1 2] ;
elseif nargin==2
    NFFT = 2^15 ;
    displayPlot = varargin{1} ;
    map = [1 2] ;
elseif nargin==3
    NFFT = 2^15 ;
    map = varargin{2} ;
    displayPlot = varargin{1} ;    
elseif nargin==4
    NFFT = varargin{3} ;
    map = varargin{2} ;
    displayPlot = varargin{1} ;    
else    
    error('Wrong number of arguments');
end

if isfield(mesu,'in0dBFS')
    fact = mesu.in0dBFS ;
else
    fact = ones(1,length(mesu.inDesc)) ;
end

Fs = 1/(mesu.t(2)-mesu.t(1)) ;

N_ov=NFFT/2;
win=hanning(NFFT);
freq=(0:NFFT/2)*Fs/NFFT;

H = tfestimate(fact(map(1))*mesu.y(:,map(1))/mesu.inCal(map(1)),...
    fact(map(2))*mesu.y(:,map(2))./mesu.inCal(map(1)),win,N_ov,NFFT) ;

if displayPlot
    subplot(2,1,1)
    plot(freq,20*log10(abs(H))) ;
    xlabel('Freq(Hz)')
    ylabel('20 log_{10} |H|')
    subplot(2,1,2)
    plot(freq,angle(H)) ;
    xlabel('Freq(Hz)')
    ylabel('Phase (rad)')
    title(['TF beween ',mesu.inDesc{1},' and ',mesu.inDesc{2}])
end
