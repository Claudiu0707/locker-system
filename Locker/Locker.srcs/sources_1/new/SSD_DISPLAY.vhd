library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SSD_MUX is
    Port ( CLK      : in STD_LOGIC;
           RST      : in STD_LOGIC;
           DIGITS   : in STD_LOGIC_VECTOR(23 downto 0);
           CATHODE  : out STD_LOGIC_VECTOR(7 downto 0);
           ANODE    : out STD_LOGIC_VECTOR(7 downto 0));
end SSD_MUX;

architecture Behavioral of SSD_MUX is
    signal REFRESH_CNT : INTEGER := 0;
    signal CURRENT_DIGIT : STD_LOGIC_VECTOR(1 downto 0) := "00";
begin

    process(CLK, RST)
begin
    if RST = '1' then
        CURRENT_DIGIT <= "00";
        ANODE <= "11111111";
        CATHODE <= (others => '0');
    elsif rising_edge(CLK) then
        case CURRENT_DIGIT is
            when "00" =>
                CATHODE <= DIGITS(7 downto 0);       
                ANODE <= "11111110";                 
                CURRENT_DIGIT <= "01";
            when "01" =>
                CATHODE <= DIGITS(15 downto 8);      
                ANODE <= "11111101";
                CURRENT_DIGIT <= "10";
            when "10" =>
                CATHODE <= DIGITS(23 downto 16);    
                ANODE <= "11111011";
                CURRENT_DIGIT <= "00";
            when others =>
                CATHODE <= (others => '1');
                ANODE <= "11111111";
                CURRENT_DIGIT <= "00";
        end case;
    end if;
end process;
end Behavioral;
