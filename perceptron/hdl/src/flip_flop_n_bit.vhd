library IEEE;
use IEEE.std_logic_1164.all;

-- flip flow n bit with reset active high
entity flip_flop_n_bit is
	generic (Nbit : positive := 16);
	port(
		d : in std_logic_vector(Nbit - 1 downto 0);
		clk : in std_logic;
		rst : in std_logic;
		q : out std_logic_vector(Nbit - 1 downto 0)
	);
end flip_flop_n_bit;

-- behavioral approach
architecture bhv of flip_flop_n_bit is
begin
	flip_flop_n_bit_proc : process(clk, rst)
	begin
		if(rst = '1')then
			q <= (others => '0');
		elsif(rising_edge(clk)) then
			q(Nbit-1 downto 0) <= d(Nbit-1 downto 0);
		end if;
	end process;
end bhv;