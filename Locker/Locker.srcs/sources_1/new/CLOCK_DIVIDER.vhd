library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CLOCK_DIVIDER is
    Port (  CLK: in STD_LOGIC;
            RST: in STD_LOGIC;
            CLK_OUT: out STD_LOGIC
         );
end CLOCK_DIVIDER;

architecture Behavioral of CLOCK_DIVIDER is
signal COUNT: INTEGER := 1;
signal TEMP_CLK: STD_LOGIC := '0';
begin

--This clock divider transforms 100MHz into 90Hz. For each rising edge, count is updated. So, half a clock output cycle is completed after 555_555 clock input cycles.
--So, an output clock cycle is given after 1_111_110 clock cycles, which gives a frequency of 90Hz(divide 100 000 000Hz by 1_111_110 => 90Hz)
process(CLK, RST)
begin
    if RST = '1' then
        TEMP_CLK <= '0';
        COUNT <= 1;
    elsif RISING_EDGE(CLK) then 
        COUNT <= COUNT + 1;
        if COUNT = 357_142 then             --357_142 aprox. 140Hz
            TEMP_CLK <= NOT TEMP_CLK;
            COUNT <= 1;
        end if;
    end if;
end process;
CLK_OUT <= TEMP_CLK;
end Behavioral;
