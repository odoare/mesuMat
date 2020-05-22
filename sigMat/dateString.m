function ds = datestring()
% function ds = datestring()
% Outputs ds as a string containing the actual date and time in the day

    cv = clock ;
    ds = [num2str(cv(1)),'-',num2str(cv(2)),'-',num2str(cv(3)),...
        '   ',num2str(cv(4)),':',num2str(cv(5)),':',num2str(round(cv(6)))] ;
        
