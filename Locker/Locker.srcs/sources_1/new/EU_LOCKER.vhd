library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity EU_LOCKER is
    Port ( CLK:          in STD_LOGIC;
           RST:          in STD_LOGIC;
           
           RST_DIGIT:    in STD_LOGIC;
           WRITE_ENABLE: in STD_LOGIC;                          --From CU to EU
           LOAD_CODE:    in STD_LOGIC;                          --From CU to EU
           INC:          in STD_LOGIC;                          --From CU to EU
           DEC:          in STD_LOGIC;                          --From CU to EU
           COMPARE:      in STD_LOGIC;                          --From CU to EU
           CUR_POS:      in STD_LOGIC_VECTOR (1 downto 0);      --From CU to EU;
           EQ_CODES:     out STD_LOGIC;                         --From EU to CU
           
           SSD_OUT:      out STD_LOGIC_VECTOR (23 downto 0));   --To display
end EU_LOCKER;

architecture Behavioral of EU_LOCKER is

--signal CODE_REG_IN, SAVED_CODE_OUT, CURRENT_CODE_OUT : STD_LOGIC_VECTOR(11 downto 0);
signal TEMP_DIGIT_VALUE: std_logic_vector(3 downto 0):="0000";
signal DIGIT_VALUE: std_logic_vector(3 downto 0);
signal EQ_CODE_IN: STD_LOGIC;
signal CURRENT_CODE_IN, SAVED_CODE_IN: STD_LOGIC_VECTOR (11 downto 0);
signal TEMP_SSD_OUT: std_logic_vector(7 downto 0);
type SSD_ARRAY is array(0 to 2) of std_logic_vector(7 downto 0);
signal S_SSD_OUT: SSD_ARRAY:=(others=>"00000000");


component CODE_REGISTER is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WRITE_ENABLE : in STD_LOGIC;
           LOAD_CODE : in STD_LOGIC;
           CUR_POS : in STD_LOGIC_VECTOR (1 downto 0); -- 00, 01, 10
           CUR_CHAR : in STD_LOGIC_VECTOR (3 downto 0); --current input
           SAVED_CODE: out STD_LOGIC_VECTOR (11 downto 0);
           CURRENT_CODE: out STD_LOGIC_VECTOR (11 downto 0);
           EQ_CODES : out STD_LOGIC);
end component;

component HEX_TO_SSD is
    Port ( HEX_IN : in STD_LOGIC_VECTOR (3 downto 0);
           SSD_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

begin
    UUT_CR:  CODE_REGISTER port map (CLK, RST, WRITE_ENABLE, LOAD_CODE, CUR_POS, DIGIT_VALUE,SAVED_CODE_IN, CURRENT_CODE_IN, EQ_CODE_IN);
    UUT_SSD: HEX_TO_SSD  port map (DIGIT_VALUE, TEMP_SSD_OUT);
    
process(CLK ,RST)
    begin
        if RST='1' or RST_DIGIT ='1' then
            TEMP_DIGIT_VALUE<="0000";
        elsif rising_edge(CLK) and WRITE_ENABLE = '1' then
            if INC = '1' then
                    TEMP_DIGIT_VALUE<=TEMP_DIGIT_VALUE+1;
            end if;
            if DEC = '1' then
                    TEMP_DIGIT_VALUE<=TEMP_DIGIT_VALUE-1;
            end if;
        end if;
end process;

DIGIT_VALUE<=TEMP_DIGIT_VALUE;      --This is placed onto HEX_TO_SSD at HEX_IN
EQ_CODES <= EQ_CODE_IN;

process(CLK, RST)
    begin
        if RST='1' then
            S_SSD_OUT <= (others => "11111111");                --Changed from UUUU_UUUU to 0111_1111
        elsif rising_edge(CLK) then
            if WRITE_ENABLE='1' then
                case CUR_POS is
                    when "00" => S_SSD_OUT(0) <= TEMP_SSD_OUT;
                    when "01" => S_SSD_OUT(1) <= TEMP_SSD_OUT;
                    when "10" => S_SSD_OUT(2) <= TEMP_SSD_OUT;
                    when others => null;
                end case;
            else
                S_SSD_OUT <= (others => "11111111");
            end if;
        end if;
end process;

SSD_OUT <= S_SSD_OUT(2)&S_SSD_OUT(1)&S_SSD_OUT(0);

end Behavioral;
