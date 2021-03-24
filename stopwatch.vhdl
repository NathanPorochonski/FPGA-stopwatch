library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- entity declaration

entity stopwatch is
   port(
      clk: in std_logic;
      clear, go: in std_logic;
      hex0, hex1: out std_logic_vector(6 downto 0)
   );
end stopwatch;

-- architecture body
architecture arch of stopwatch is
   signal d0_reg, d0_next: std_logic_vector(3 downto 0);
   signal d1_reg, d1_next: std_logic_vector(3 downto 0);
   signal t_reg, t_next: std_logic_vector(25 downto 0);
   signal tick: std_logic;
begin
   -- registers for BCD counters and tick generator
   process(clk)
   begin
      if (clk'event and clk='1') then
         d0_reg <= d0_next;
         d1_reg <= d1_next;
         t_reg <= t_next;
      end if;
   end process;
    
   -- next‐state logic
   
   -- 0.1 sec tick generator
   t_next <= (others => '0') when t_reg=4999999 else
				 t_reg + 1;
   -- tick asserted 1 clock cycle for every 0.1 sec          
   tick <= '1' when t_reg=0 else '0';
	
   -- 0.1 second counter
   -- d0_next depends on clear, go, d0_reg, tick
   d0_next <= "0000" when clear='1' else  
			     "0001" when go='1' and tick='1' and d0_reg = "0000" else
			     "0010" when go='1' and tick='1' and d0_reg = "0001" else
			     "0011" when go='1' and tick='1' and d0_reg = "0010" else
			     "0100" when go='1' and tick='1' and d0_reg = "0011" else
			     "0101" when go='1' and tick='1' and d0_reg = "0100" else
			     "0110" when go='1' and tick='1' and d0_reg = "0101" else
			     "0111" when go='1' and tick='1' and d0_reg = "0110" else
				  "1000" when go='1' and tick='1' and d0_reg = "0111" else
				  "1001" when go='1' and tick='1' and d0_reg = "1000" else
				  "0000" when go='1' and tick='1' and d0_reg = "1001" else
				  d0_reg;
               
   -- 1 second counter
   -- d1_next depends on clear, go, d0_reg, d1_reg, tick
	d1_next <= "0000" when clear='1' else
			     "0001" when go='1' and tick='1' and d1_reg = "0000" and d0_reg = "1001" else
			     "0010" when go='1' and tick='1' and d1_reg = "0001" and d0_reg = "1001" else
			     "0011" when go='1' and tick='1' and d1_reg = "0010" and d0_reg = "1001" else
			     "0100" when go='1' and tick='1' and d1_reg = "0011" and d0_reg = "1001" else
			     "0101" when go='1' and tick='1' and d1_reg = "0100" and d0_reg = "1001" else
			     "0110" when go='1' and tick='1' and d1_reg = "0101" and d0_reg = "1001" else
			     "0111" when go='1' and tick='1' and d1_reg = "0110" and d0_reg = "1001" else
				  "1000" when go='1' and tick='1' and d1_reg = "0111" and d0_reg = "1001" else
				  "1001" when go='1' and tick='1' and d1_reg = "1000" and d0_reg = "1001" else
				  "0000" when go='1' and tick='1' and d1_reg = "1001" and d0_reg = "1001" else
				  d1_reg;
				  
   -- output logic
   -- decoding circuit for 7‐segment LED displays
   hex0 <= "1000000" when d0_reg = "0000" else
			  "1111001" when d0_reg = "0001" else
           "0100100" when d0_reg = "0010" else
           "0110000" when d0_reg = "0011" else
           "0011001" when d0_reg = "0100" else
           "0010010" when d0_reg = "0101" else
           "0000010" when d0_reg = "0110" else
           "1111000" when d0_reg = "0111" else
           "0000000" when d0_reg = "1000" else
           "0011000" when d0_reg = "1001";
			  
	hex1 <= "1000000" when d1_reg = "0000" else
			  "1111001" when d1_reg = "0001" else
           "0100100" when d1_reg = "0010" else
           "0110000" when d1_reg = "0011" else
           "0011001" when d1_reg = "0100" else
           "0010010" when d1_reg = "0101" else
           "0000010" when d1_reg = "0110" else
           "1111000" when d1_reg = "0111" else
           "0000000" when d1_reg = "1000" else
           "0011000" when d1_reg = "1001";
end arch;