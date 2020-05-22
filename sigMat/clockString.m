function cs = clocktring()
% function cs = clocktring()
% Outputs cs as a string containing the actual time in the day

    cv = clock ;
    cs = [num2str(cv(4)),':',num2str(cv(5)),':',num2str(round(cv(6)))] ;
        
