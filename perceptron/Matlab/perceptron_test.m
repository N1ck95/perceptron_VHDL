%% Test the activation function
a = -4 : 0.01 : 4;

for i = 1 : length(a)
    y(i) = activation(a(i));
end
plot(a, y)