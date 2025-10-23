library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HEX_TO_SSD is
    Port ( HEX_IN : in STD_LOGIC_VECTOR (3 downto 0);
           SSD_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end HEX_TO_SSD;

architecture Behavioral of HEX_TO_SSD is


begin

process(HEX_IN)
    begin
        case HEX_IN is
            when "0000" => SSD_OUT <= "11000000";       --CHARACTER -0-
            when "0001" => SSD_OUT <= "11111001";       --CHARACTER -1-
            when "0010" => SSD_OUT <= "10100100";       --CHARACTER -2-
            when "0011" => SSD_OUT <= "10110000";       --CHARACTER -3-
            when "0100" => SSD_OUT <= "10011001";       --CHARACTER -4-
            when "0101" => SSD_OUT <= "10010010";       --CHARACTER -5-
            when "0110" => SSD_OUT <= "10000010";       --CHARACTER -6-
            when "0111" => SSD_OUT <= "11111000";       --CHARACTER -7-
            when "1000" => SSD_OUT <= "10000000";       --CHARACTER -8-
            when "1001" => SSD_OUT <= "10010000";       --CHARACTER -9-
            when "1010" => SSD_OUT <= "10001000";       --CHARACTER -A- 
            when "1011" => SSD_OUT <= "10000011";       --CHARACTER -B-
            when "1100" => SSD_OUT <= "11000110";       --CHARACTER -C-
            when "1101" => SSD_OUT <= "10100001";       --CHARACTER -D-
            when "1110" => SSD_OUT <= "10000110";       --CHARACTER -E-
            when "1111" => SSD_OUT <= "10001110";       --CHARACTER -F-
            when others => SSD_OUT <= "11111111";       --CHARACTER -DOT-
        end case;
end process;

end Behavioral;
