library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;	--add numeric standard package(for type convertion)

entity perceptron is
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
end perceptron;

architecture struct of perceptron is
	constant HALF_BIN : std_logic_vector(20 downto 0) := "000000100000000000000";	--binary representation of 0.5 in 21 bit, used to compute the activation function output

	--signals where to put the results of the xi * wi operations
	signal a1 : std_logic_vector(16 downto 0);
	signal a2 : std_logic_vector(16 downto 0);
	signal a3 : std_logic_vector(16 downto 0);
	signal a4 : std_logic_vector(16 downto 0);
	signal a5 : std_logic_vector(16 downto 0);
	signal a6 : std_logic_vector(16 downto 0);
	signal a7 : std_logic_vector(16 downto 0);
	signal a8 : std_logic_vector(16 downto 0);
	signal a9 : std_logic_vector(16 downto 0);
	signal a10 : std_logic_vector(16 downto 0);
	
	signal a :std_logic_vector(20 downto 0);	--signal where to put the sum of all ai signals and bias b

	signal tmp : std_logic_vector(20 downto 0);	--signal where to put the output of the activation function before being truncated to fit in the output y
	
	begin
		a1 <= std_logic_vector(signed(x1)*signed(w1));	--is needed to specify that inputs are signed values and then convert the result onto std_logic_vector
		a2 <= std_logic_vector(signed(x2)*signed(w2));
		a3 <= std_logic_vector(signed(x3)*signed(w3));
		a4 <= std_logic_vector(signed(x4)*signed(w4));
		a5 <= std_logic_vector(signed(x5)*signed(w5));
		a6 <= std_logic_vector(signed(x6)*signed(w6));
		a7 <= std_logic_vector(signed(x7)*signed(w7));
		a8 <= std_logic_vector(signed(x8)*signed(w8));
		a9 <= std_logic_vector(signed(x9)*signed(w9));
		a10 <= std_logic_vector(signed(x10)*signed(w10));

		--process to compute the value of a by summing all ai and bias
		process_to_a : process(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, b)	--do this process when one of the ai or the bias changes
		variable a_v : std_logic_vector(20 downto 0);	signal where to put the sum of all ai
		variable i : integer := 1;	--counting variable
		begin
			for i in 1 to 10 loop
				case(i) is
					when 1 => a_v := (20 downto 17 => a1(16)) & a1;	--to fit a1 into 20 bits replicate the MSB (sign) four times (this have to be done with each ai before summing)
					when 2 => a_v := std_logic_vector(signed(a_v) + signed((20 downto 17 => a2(16)) & a2));
					when 3 => a_v := std_logic_vector(signed(a_v) + signed((20 downto 17 => a3(16)) & a3));
					when 4 => a_v := std_logic_vector(signed(a_v) + signed((20 downto 17 => a4(16)) & a4));
					when 5 => a_v := std_logic_vector(signed(a_v) + signed((20 downto 17 => a5(16)) & a5));
					when 6 => a_v := std_logic_vector(signed(a_v) + signed((20 downto 17 => a6(16)) & a6));
					when 7 => a_v := std_logic_vector(signed(a_v) + signed((20 downto 17 => a7(16)) & a7));
					when 8 => a_v := std_logic_vector(signed(a_v) + signed((20 downto 17 => a8(16)) & a8));
					when 9 => a_v := std_logic_vector(signed(a_v) + signed((20 downto 17 => a9(16)) & a9));
					when 10 => a_v := std_logic_vector(signed(a_v) + signed((20 downto 17 => a10(16)) & a10));
				end case;
			end loop;
			a <= std_logic_vector(signed(a_v) + signed(b(8) & b(8) & b(8) & b(8) & b(8) & b & (6 downto 0 => '0')));	--to sum bias I need to align his LSB (add 7 zeroes at the LSB) and then replicate the MSB (sign) five times to fit into 20 bit 
		end process;
		
		process_a : process(a)
		begin
			if(to_integer(signed(a)) >= 65536 ) then	--compare a with 2, if is greather than 2 the output should be 1
				tmp <= "000001000000000000000";		--output value of 1 in bynary representation in 21 bits
			elsif (to_integer(signed(a)) <= -65536) then	--compare a with -2 if is lower than -2 the output should be 0
				tmp <= (20 downto 0 => '0');		--output value of 0
			else
				tmp <= std_logic_vector(signed((a(20) & a(20) & a(20 downto 2))) + signed(HALF_BIN));	--for the linear region I have to comput the output value based on this formula
			end if;
		end process;
		y <= tmp(20 downto 5);	--truncate tmp LSB to fit onto y
end struct;