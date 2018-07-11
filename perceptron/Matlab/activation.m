function y = activation(a)
    if(a <= -2)
        y = 0; 
    elseif(a >= 2)
        y = 1;
    else
        y = a/4 + 1/2;
    end
end