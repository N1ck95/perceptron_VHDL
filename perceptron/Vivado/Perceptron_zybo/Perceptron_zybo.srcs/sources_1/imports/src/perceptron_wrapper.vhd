library IEEE;
use IEEE.std_logic_1164.all;

entity perceptron_wrapper is
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
		w10	: in std_logic_vector(8 downto 0); -- 80 + 90 + 9 = 179 bit to store all input
		b 	: in std_logic_vector(8 downto 0);
		y 	: out std_logic_vector(15 downto 0); --16 bit to store all outputs
		clk : in std_logic;
		rst : in std_logic
	);
end perceptron_wrapper;

architecture struct of perceptron_wrapper is
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
	
	signal tmp1 : std_logic_vector(179 - 1 downto 0);
	signal tmp2 : std_logic_vector(179 - 1 downto 0);
	signal tmp_out : std_logic_vector(15 downto 0);
	
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
		tmp1(98 downto 90) <= w1;
		tmp1(89 downto 81) <= w2;
		tmp1(80 downto 72) <= w3;
		tmp1(71 downto 63) <= w4;
		tmp1(62 downto 54) <= w5;
		tmp1(53 downto 45) <= w6;
		tmp1(44 downto 36) <= w7;
		tmp1(35 downto 27) <= w8;
		tmp1(26 downto 18) <= w9;
		tmp1(17 downto 9) <= w10;
		tmp1(8  downto 0) <= b;
		
		input_ff : flip_flop_n_bit
		generic map(Nbit => 179)
		port map(
			d	=> tmp1,
			clk => clk,
			rst => rst,
			q	=> tmp2
		);
		
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
			w1 => tmp2(98 downto 90),
			w2 => tmp2(89 downto 81),
			w3 => tmp2(80 downto 72),
			w4 => tmp2(71 downto 63),
			w5 => tmp2(62 downto 54),
			w6 => tmp2(53 downto 45),
			w7 => tmp2(44 downto 36),
			w8 => tmp2(35 downto 27),
			w9 => tmp2(26 downto 18),
			w10 => tmp2(17 downto 9),
			b => tmp2(8 downto 0),
			y => tmp_out
		);
		
		output_ff : flip_flop_n_bit
		generic map(Nbit => 16)
		port map(
			d => tmp_out,
			clk => clk,
			rst => rst,
			q => y
		);
end struct;