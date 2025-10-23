
----------------------------------------------------------------------------------
-- University: TECHNICAL UNIVERSITY of CLUJ-NAPOCA
-- Student: MURESAN CLAUDIU, STAN PAUL IOAN
-- 
-- Create Date: 05/20/2025 04:41:14 PM
-- Design Name: 
-- Module Name: LOCKER_TOP
-- Project Name: LOCKER SECURITY SYSTEM WITH PIN CODE 
-- Target Devices:     
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity LOCKER_TOP is
    Port ( CLK:            in STD_LOGIC;
           RST:            in STD_LOGIC;
           ADD_DIGIT:      in STD_LOGIC;
           UP_BTN:         in STD_LOGIC;
           DOWN_BTN:       in STD_LOGIC;
           WRONG_INPUT:    out STD_LOGIC;
           AVAILABLE:      out STD_LOGIC;
           INPUT_DIGIT:    out STD_LOGIC;
           CATHODE_OUT:    out STD_LOGIC_VECTOR (7 downto 0);
           ANODE_OUT:      out STD_LOGIC_VECTOR (7 downto 0));
end LOCKER_TOP;

architecture Behavioral of LOCKER_TOP is

component EU_LOCKER is
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
end component;

component CU_LOCKER is
    Port ( CLK:             in STD_LOGIC;
           RST:             in STD_LOGIC;
           ADD_DIGIT:       in STD_LOGIC;                       --OUTSIDE INPUT
           UP_BTN:          in STD_LOGIC;                       --OUTSIDE INPUT
           DOWN_BTN:        in STD_LOGIC;                       --OUTSIDE INPUT
           
           EQ_CODES:        in STD_LOGIC;                       --From EU to CU(1 - LOCKED | 0 - UNLOCKED)
           
           RST_DIGIT:       out STD_LOGIC;
           WRITE_ENABLE:    out STD_LOGIC;                      --From CU to EU
           LOAD_CODE:       out STD_LOGIC;                      --From CU to EU
           INC:             out STD_LOGIC;                      --From CU to EU
           DEC:             out STD_LOGIC;                      --From CU to EU
           COMPARE:         out STD_LOGIC;                      --From CU to EU
           CUR_POS:         out STD_LOGIC_VECTOR (1 downto 0);  --From CU to EU. Which digit we are at in the code
           
           AVAILABLE:       out STD_LOGIC;                      --1 when locker is occupied
           INPUT_DIGIT:     out STD_LOGIC;                     --1 when waiting for input digit
           WRONG_INPUT:     out STD_LOGIC);
end component;

component SSD_MUX is
    Port ( CLK      : in STD_LOGIC;
           RST      : in STD_LOGIC;
           DIGITS   : in STD_LOGIC_VECTOR(23 downto 0);
           CATHODE  : out STD_LOGIC_VECTOR(7 downto 0);
           ANODE    : out STD_LOGIC_VECTOR(7 downto 0));
end component SSD_MUX;

component CLOCK_DIVIDER is
    Port (  CLK: in STD_LOGIC;
            RST: in STD_LOGIC;
            CLK_OUT: out STD_LOGIC
         );
end component CLOCK_DIVIDER;

component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

--Signals coming from outside
signal CLK_IN, RST_IN, ADD_DIGIT_IN, UP_BTN_IN, DOWN_BTN_IN: STD_LOGIC;

--Signals going outside
signal AVAILABLE_IN, INPUT_DIGIT_IN: STD_LOGIC;
signal SSD_OUT_IN: STD_LOGIC_VECTOR (23 downto 0);
signal WRONG_INPUT_IN: STD_LOGIC;
--Signals from CU to EU
signal WE_IN, LD_CODE_IN, INC_IN, DEC_IN, COMP_IN, RST_DIGIT_IN: STD_LOGIC;
signal CUR_POS_IN: STD_LOGIC_VECTOR (1 downto 0);
--Signals from EU to CU
signal EQ_IN: STD_LOGIC;
signal DIGITS: STD_LOGIC_VECTOR (23 downto 0);

--
signal T_CLK_OUT: STD_LOGIC;

begin
    CU_U:   CU_LOCKER port map (CLK, RST, ADD_DIGIT_IN, UP_BTN_IN, DOWN_BTN_IN, EQ_IN, RST_DIGIT_IN, WE_IN, 
                                LD_CODE_IN, INC_IN, DEC_IN, COMP_IN, CUR_POS_IN, AVAILABLE_IN, INPUT_DIGIT_IN, WRONG_INPUT_IN);
    EU_U:   EU_LOCKER port map (CLK, RST_IN, RST_DIGIT_IN, WE_IN, LD_CODE_IN, INC_IN, DEC_IN, COMP_IN, CUR_POS_IN, EQ_IN, SSD_OUT_IN);
    CLK_U:  CLOCK_DIVIDER port map (CLK, RST, T_CLK_OUT);
    SSD_U:  SSD_MUX port map (T_CLK_OUT, RST, DIGITS, CATHODE_OUT, ANODE_OUT);
    
    MPG_ADD: MPG port map (ADD_DIGIT ,CLK, ADD_DIGIT_IN);
    MPG_UP:  MPG port map (UP_BTN, CLK, UP_BTN_IN);
    MPG_DOWN:  MPG port map (DOWN_BTN, CLK, DOWN_BTN_IN);
    CLK_IN <= CLK;
    RST_IN <= RST;
    AVAILABLE <= AVAILABLE_IN;
    INPUT_DIGIT<=INPUT_DIGIT_IN;
    DIGITS<= SSD_OUT_IN;
    WRONG_INPUT <= WRONG_INPUT_IN;
end Behavioral;
