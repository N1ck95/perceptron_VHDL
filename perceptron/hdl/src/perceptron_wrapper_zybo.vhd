library IEEE;
use IEEE.std_logic_1164.all;

-- wrapper to implement perceptron onto the Zybo board
entity perceptron_wrapper_zybo is
	port(
		x1	: in std_logic_vector(7 downto 0);
		x2	: in std_logic_vector(7 downto 0);
		x3	: in std_logic_vector(7 downto 0);
		x4	: in std_logic_vector(7 downto 0);
		x5	: in std_logic_vector(7 downto 0);
		x6	: in std_logic_vector(7 downto 0);
		x7	: in std_logic_vector(7 downto 0);
		x8	: in std_logic_vector(7 downto 0);
		x9	: in std_logic_vector(7 downto 0);
		x10	: in std_logic_vector(7 downto 0);		--80 bit to store all inputs
		y 	: out std_logic_vector(15 downto 0); 	--16 bit to store all outputs
		clk : in std_logic;	--clock signal
		rst : in std_logic
	);
end perceptron_wrapper_zybo;

architecture struct of perceptron_wrapper_zybo is
	constant HALF_BIN : std_logic_vector(8 downto 0) := "010000000";	--binary representation of 0.5 into the 9 bit domain used to initialize the weigths and biases

	component flip_flop_n_bit is
		generic (Nbit : positive := 16);
		port(
			d : in std_logic_vector(Nbit - 1 downto 0);
			clk : in std_logic;
			rst : in std_logic;
			q : out std_logic_vector(Nbit - 1 downto 0)
		);
	end component;
	
	component perceptron is
		port(
			x1	: in std_logic_vector(7 downto 0);
			x2	: in std_logic_vector(7 downto 0);
			x3	: in std_logic_vector(7 downto 0);
			x4	: in std_logic_vector(7 downto 0);
			x5	: in std_logic_vector(7 downto 0);
			x6	: in std_logic_vector(7 downto 0);
			x7	: in std_logic_vector(7 downto 0);
			x8	: in std_logic_vector(7 downto 0);
			x9	: in std_logic_vector(7 downto 0);
			x10	: in std_logic_vector(7 downto 0);
			w1	: in std_logic_vector(8 downto 0);
			w2	: in std_logic_vector(8 downto 0);
			w3	: in std_logic_vector(8 downto 0);
			w4	: in std_logic_vector(8 downto 0);
			w5	: in std_logic_vector(8 downto 0);
			w6	: in std_logic_vector(8 downto 0);
			w7	: in std_logic_vector(8 downto 0);
			w8	: in std_logic_vector(8 downto 0);
			w9	: in std_logic_vector(8 downto 0);
			w10	: in std_logic_vector(8 downto 0);
			b 	: in std_logic_vector(8 downto 0);
			y 	: out std_logic_vector(15 downto 0)
		);
	end component;
	
	signal tmp1 : std_logic_vector(179 - 1 downto 99);	--signal wrapping all imputs into a bigger signal to give as input to input flip flop
	signal tmp2 : std_logic_vector(179 - 1 downto 99);  --signal output of flip flop wrapping all signals to give as input to perceptron logic
	signal tmp_out : std_logic_vector(15 downto 0);		--signal output of perceptron to give as input to the output flip flop
	
	begin
		--map all inputs into  tmp1 std_logic_vector
		tmp1(178 downto 171) <= x1;
		tmp1(170 downto 163) <= x2;
		tmp1(162 downto 155) <= x3;
		tmp1(154 downto 147) <= x4;
		tmp1(146 downto 139) <= x5;
		tmp1(138 downto 131) <= x6;
		tmp1(130 downto 123) <= x7;
		tmp1(122 downto 115) <= x8;
		tmp1(114 downto 107) <= x9;
		tmp1(106 downto 99) <= x10;
		
		--input flip flop
		input_ff : flip_flop_n_bit
		generic map(Nbit => 80)
		port map(
			d	=> tmp1,
			clk => clk,
			rst => rst,
			q	=> tmp2
		);
		
		--perceptron logic
		my_perceptron : perceptron
		port map(
			x1 => tmp2(178 downto 171),
			x2 => tmp2(170 downto 163),
			x3 => tmp2(162 downto 155),
			x4 => tmp2(154 downto 147),
			x5 => tmp2(146 downto 139),
			x6 => tmp2(138 downto 131),
			x7 => tmp2(130 downto 123),
			x8 => tmp2(122 downto 115),
			x9 => tmp2(114 downto 107),
			x10 => tmp2(106 downto 99),
			w1 => HALF_BIN,
			w2 => HALF_BIN,
			w3 => HALF_BIN,
			w4 => HALF_BIN,
			w5 => HALF_BIN,
			w6 => HALF_BIN,
			w7 => HALF_BIN,
			w8 => HALF_BIN,
			w9 => HALF_BIN,
			w10 => HALF_BIN,
			b => HALF_BIN,
			y => tmp_out
		);
		
		--output flip flop
		output_ff : flip_flop_n_bit
		generic map(Nbit => 16)
		port map(
			d => tmp_out,
			clk => clk,
			rst => rst,
			q => y
		);
end struct;