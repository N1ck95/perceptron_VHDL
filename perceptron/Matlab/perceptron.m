function y = perceptron(x, w, b)
    a = b;
    for(i = 1 : 1 : length(x))
        a = a + x(i)*w(i);
    end
    y = activation(a);
end