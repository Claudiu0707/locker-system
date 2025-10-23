library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_LOCKER is
--  Port ( );
end TB_LOCKER;

architecture Behavioral of TB_LOCKER is
component LOCKER_TOP is
    Port ( CLK:            in STD_LOGIC;
           RST:            in STD_LOGIC;
           ADD_DIGIT:      in STD_LOGIC;
           UP_BTN:         in STD_LOGIC;
           DOWN_BTN:       in STD_LOGIC;
           AVAILABLE:      out STD_LOGIC;
           INPUT_DIGIT:    out STD_LOGIC;
           CATHODE_OUT:    out STD_LOGIC_VECTOR (7 downto 0);
           ANODE_OUT:      out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal CLK, RST, ADD_DIGIT, UP_BTN, DOWN_BTN, AVAILABLE, INPUT_DIGIT: STD_LOGIC;
signal CATHODE_OUT, ANODE_OUT: STD_LOGIC_VECTOR (7 downto 0);
begin
    UUT: LOCKER_TOP port map (CLK, RST, ADD_DIGIT, UP_BTN, DOWN_BTN, AVAILABLE, INPUT_DIGIT, CATHODE_OUT, ANODE_OUT);
    
    process
    begin
        CLK <='0';
        wait for 5ns;
        CLK <= '1';
        wait for 5ns;
    end process;
    
    process
    begin
        RST <= '1';
        ADD_DIGIT <= '0';
        UP_BTN <= '0';
        DOWN_BTN <= '0';
        wait for 10ns;
        RST <= '0';
        wait for 30ms;
        ADD_DIGIT <= '1';
        wait for 10ns;
        ADD_DIGIT <= '0';
        wait for 20ms;
        UP_BTN <= '1';
        wait for 30ns;
        
    end process;
end Behavioral;
