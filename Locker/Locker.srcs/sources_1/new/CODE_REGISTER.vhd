library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CODE_REGISTER is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WRITE_ENABLE : in STD_LOGIC;
           LOAD_CODE : in STD_LOGIC;
           CUR_POS : in STD_LOGIC_VECTOR (1 downto 0); -- 00, 01, 10
           CUR_CHAR : in STD_LOGIC_VECTOR (3 downto 0); --current input
           SAVED_CODE: out STD_LOGIC_VECTOR (11 downto 0);
           CURRENT_CODE: out STD_LOGIC_VECTOR (11 downto 0);
           EQ_CODES : out STD_LOGIC);           
end CODE_REGISTER;

architecture Behavioral of CODE_REGISTER is
signal EQ_CHECK: STD_LOGIC;

type CODE_ARRAY is array(0 to 2) of std_logic_vector(3 downto 0);
signal S_CURRENT_CODE: CODE_ARRAY:=(others=>"0000");
signal S_SAVED_CODE: CODE_ARRAY:=(others=>"0000");


begin
process(CLK, RST)
    begin
        if RST='1' then
            S_CURRENT_CODE <= (others => "UUUU");
            S_SAVED_CODE <= (others => "UUUU");
        elsif rising_edge(CLK) then
            if WRITE_ENABLE='1' then
                case CUR_POS is
                    when "00" => S_CURRENT_CODE(0) <= CUR_CHAR;
                    when "01" => S_CURRENT_CODE(1) <= CUR_CHAR;
                    when "10" => S_CURRENT_CODE(2) <= CUR_CHAR;
                    when others => null;
                end case;
            end if;
            
            if LOAD_CODE='1' then
                S_SAVED_CODE <= S_CURRENT_CODE;
            end if;
        end if;
end process;

CURRENT_CODE <= S_CURRENT_CODE(2)&S_CURRENT_CODE(1)&S_CURRENT_CODE(0);
SAVED_CODE <= S_SAVED_CODE(2)&S_SAVED_CODE(1)&S_SAVED_CODE(0);
EQ_CODES <= '1' when S_CURRENT_CODE=S_SAVED_CODE else '0';

end Behavioral;
