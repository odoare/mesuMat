function impresp = CalcFarinaRI(Fs, T, Fmin, Fmax, input, response)


    % Définition du vecteur du temps
    t=(0:length(response)-1)/Fs;
    % 

    responsei=response(length(response):-1:1);    % signal renversé

    % Calcul du filtre inverse
    EnvFiltInv=exp(-t/T*log(Fmax/Fmin));
    EnvFiltInv=rot90(EnvFiltInv)';
    FiltInv=input.*EnvFiltInv;

    % Filtrage inverse
    SigFilt=real(ifft(fft(responsei).*fft(FiltInv)));
    impresp=SigFilt(end:-1:1);
    
