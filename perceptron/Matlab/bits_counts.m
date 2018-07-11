%% Compute number of bits of each std_logic_vector
N_x = 8;    %Number of bits of the inputs (MSB is for sign)
N_w = 9;    %Number of bits of the multiplier coefficient (MSB is for sign)

%Use Fixed point repres:
% X: 1 bit for sign, 1 bit for integer part and 6 bits for decimal part
% W: 1 bit for sign, 1 bit for integer part and 7 bits for decimal part

N_k = N_x + N_w ;    %Number of bits of each mult output (MSB is for sign)

% K: 1 bit for sign, 1 bit for integer part and N_k - 2 (17 - 2 = 15) bits for decimal part

%There are 11 terms to add: 10 all of the same lenght (N_k) and one of
%lenght N_w wich is less than N_k so add one bit for each sum that I have to perform:
N_z_in = N_k + ceil(log2(10));   %Number of bits in input to the sigmoid function (MSB is for sign)

% Z: 1 bit for sign, 4 bits for integer part and 22 bits for decimal part

N_y = 16;   %Number of bits as output of the perceptron (unsigned)


%% Representation of 2 and -2 for activation function inputs

lsb_x = 1 / (2^(N_x-1));    %X represents with N_x bits the numbers from 1 to -1
lsb_w = 1 / (2^(N_w-1));    %w and b represents with N_w bits the numbers from 1 to -1

lsb_product = lsb_x * lsb_w;   %To do the product is not needed to align the lsb

%Do not consider bias for the moment: if we sum the 10 multiplications we
%don't need to align the lsb because are already aligned and so this sum
%have lsb:

lsb_part_sum = lsb_product;

%Now to sum the bias we have to align his lsb by adding 7 zeroes in tail
%and replicating MSB 5 times on head
%Doing this we can so sum the two quantities and the result will so have
%the lsb of the partial sum:

lsb_sum = lsb_part_sum;

%To represent 2 so we have to do:
repr_2 = ceil(2/lsb_sum);
repr_min_2 = 2^N_z_in - repr_2;

bin_2 = dec2bin(repr_2, N_z_in)
bin_min_2 = dec2bin(repr_min_2, N_z_in)

%% Compute values for a.f outputs

% To repr 1 for y
repr_1 = ceil(1/lsb_sum);
bin_1 = dec2bin(repr_1, N_z_in);    %This value should be truncated to fit in 16 bits

% Values for the linear part: y = a/4 + 0.5
% To divide by 4 the input to the activation function (a) just need to shift
% right two times a

% Repr of 0.5 that have to be summed to a/4
repr_05 = ceil(0.5/lsb_sum);
bin_05 = dec2bin(repr_05, N_z_in);

%% Compute inputs for testbench

% I choosed to test the perceptron with 8 different inputs such that the
% input to the activation function will be tested in the two constant areas
% and in the linear area.

%The maximum value that I can represent on 8 bits is 011111111 wich is 0.9922

%Compute the value of -1 for x, I'll convert this value in binary directly
%in VHDL
min_one = ceil(-1/lsb_w)

%  I decided to set all weigths and the bias to 0.5 
half_w = ceil(0.5/lsb_w);
half_w_repr = dec2bin(one_w, N_w-1) %N.b I have to add one 0 in the head of this binary repr for the sign

%% Check tb results

%Check inputs to activation function

%To check for correctness of the computed value: int_val*lsb should be
%equal to the computed value

%Expected values as input to activation function
exp_a_case(1) = (0.9922*0.5) * 6 + 0.5;
exp_a_case(2) = (0.9922*0.5) * 5 -1*0.5 + 0.5;
exp_a_case(3) = (0.9922*0.5) * 4 -1*0.5 + 0.5;
exp_a_case(4) = (0.9922*0.5) * 3 -1*0.5*2 + 0.5;
exp_a_case(5) = (0.9922*0.5) * 2 -1*0.5*3 + 0.5;
exp_a_case(6) = (0.9922*0.5) * 1 -1*0.5*4 + 0.5;
exp_a_case(7) = -1*0.5*5 + 0.5;
exp_a_case(8) = -1*0.5*6 + 0.5;

%Values given as input to activation function in simulation
a_case(1) = 113920*lsb_sum;
a_case(2) = 81280*lsb_sum;
a_case(3) = 65024*lsb_sum;
a_case(4) = 32384*lsb_sum;
a_case(5) = -256*lsb_sum;
a_case(6) = -32896*lsb_sum;
a_case(7) = -65536*lsb_sum;
a_case(8) = -81920*lsb_sum;

% In all of the cases the values are equal, now check for the final result
% correctness

%Expected y:
exp_y_case(1) = activation(exp_a_case(1));
exp_y_case(2) = activation(exp_a_case(2));
exp_y_case(3) = activation(exp_a_case(3));
exp_y_case(4) = activation(exp_a_case(4));
exp_y_case(5) = activation(exp_a_case(5));
exp_y_case(6) = activation(exp_a_case(6));
exp_y_case(7) = activation(exp_a_case(7));
exp_y_case(8) = activation(exp_a_case(8));

%I check the value of tmp instead of y because y is truncated so the
%comparison will be less significative

tmp_case(1) = 32768 * lsb_sum;
tmp_case(2) = 32768 * lsb_sum;
tmp_case(3) = 32640 * lsb_sum;
tmp_case(4) = 24480 * lsb_sum;
tmp_case(5) = 16320 * lsb_sum;
tmp_case(6) = 8160 * lsb_sum;
tmp_case(7) = 0;
tmp_case(8) = 0;

hold on
plot(exp_a_case, exp_y_case, '.b')
plot(a_case, tmp_case, 'og')
hold off

%As is possible see from the plot the result perfectly matches the expectations