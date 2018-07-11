library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;	--add numeric standard package(for type convertion)

-- testbench for perceptron_wrapper_zybo

entity perceptron_wrapper_tb is
end perceptron_wrapper_tb;

architecture bhv of perceptron_wrapper_tb is
	constant T_CLK : time := 10 ns;

	signal x1_tb : std_logic_vector(7 downto 0) := "01111111";	--initialize input to 0.9922 (127*lsb_x) (max value representable with 8 bits)
	signal x2_tb : std_logic_vector(7 downto 0) := "01111111";	
	signal x3_tb : std_logic_vector(7 downto 0) := "01111111";
	signal x4_tb : std_logic_vector(7 downto 0) := "01111111";
	signal x5_tb : std_logic_vector(7 downto 0) := "01111111";	
	signal x6_tb : std_logic_vector(7 downto 0) := "01111111";
	signal x7_tb : std_logic_vector(7 downto 0) := "00000000";	--initialize these other inputs to 0
	signal x8_tb : std_logic_vector(7 downto 0) := "00000000";
	signal x9_tb : std_logic_vector(7 downto 0) := "00000000";
	signal x10_tb : std_logic_vector(7 downto 0) := "00000000";
	
	signal y_tb : std_logic_vector(15 downto 0);
	
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal end_sim : std_logic := '1';


	component perceptron_wrapper_zybo is
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
		y 	: out std_logic_vector(15 downto 0); --16 bit to store all outputs
		clk : in std_logic;
		rst : in std_logic
	);
	end component;
	
	begin
		clk <= (not (clk) and end_sim) after T_CLK/2;
	
		--component to test
		test_perceptron : perceptron_wrapper_zybo
		port map(
			x1 => x1_tb,
			x2 => x2_tb,
			x3 => x3_tb,
			x4 => x4_tb,
			x5 => x5_tb,
			x6 => x6_tb,
			x7 => x7_tb,
			x8 => x8_tb,
			x9 => x9_tb,
			x10 => x10_tb,
			y => y_tb,
			clk => clk,
			rst => rst
		);
		
		-- at the beginning the input to activation function is 3.4766
		d_process : process(clk)
		variable t : integer := 0;
		begin
			if(rising_edge(clk)) then
				case(t) is	
					when 1 => rst <= '0';	-- disable reset
					when 2 => x1_tb <= std_logic_vector(to_signed(-128, 8)); --set x1 to -1, I'll have 2.4805 as input to activation function
					when 3 => x2_tb <= "00000000"; -- set x2 to 0, I'll have 1.9844 as input to a.f.
					when 5 => x3_tb <= std_logic_vector(to_signed(-128, 8)); -- 0.9883 as input to a.f.
					when 7 => x4_tb <= std_logic_vector(to_signed(-128, 8)); -- -0.0078 as input to a.f.
					when 9 => x5_tb <= std_logic_vector(to_signed(-128, 8)); -- -1.0039 as input to a.f.
					when 11 => x6_tb <= std_logic_vector(to_signed(-128, 8)); -- -2 as input to a.f.
					when 13 => x7_tb <= std_logic_vector(to_signed(-128, 8)); -- -2.5 as input to a.f.
					when 15 => end_sim <= '0';
					when others => null;
				end case;
				t := t + 1;
			end if;
		end process;
end bhv;