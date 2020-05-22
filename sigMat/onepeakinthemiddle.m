function y = onepeakinthemiddle(l)
y = zeros(l,1) ;
if mod(l,2) == 0
    y(l/2) = 1;
else
    y((l+1)/2) = 1 ;
end

    