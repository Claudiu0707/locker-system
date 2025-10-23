library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU_LOCKER is
    Port ( CLK:             in STD_LOGIC;
           RST:             in STD_LOGIC;
           ADD_DIGIT:       in STD_LOGIC;                       --OUTSIDE INPUT
           UP_BTN:          in STD_LOGIC;                       --OUTSIDE INPUT
           DOWN_BTN:        in STD_LOGIC;                       --OUTSIDE INPUT
           
           EQ_CODES:        in STD_LOGIC;                       --From EU to CU(1 - LOCKED | 0 - UNLOCKED)
           
           RST_DIGIT:       out STD_LOGIC;                      --From CU to EU
           WRITE_ENABLE:    out STD_LOGIC;                      --From CU to EU
           LOAD_CODE:       out STD_LOGIC;                      --From CU to EU
           INC:             out STD_LOGIC;                      --From CU to EU
           DEC:             out STD_LOGIC;                      --From CU to EU
           COMPARE:         out STD_LOGIC;                      --From CU to EU
           CUR_POS:         out STD_LOGIC_VECTOR (1 downto 0);  --From CU to EU. Which digit we are at in the code
           
           AVAILABLE:       out STD_LOGIC;                      --1 when locker is occupied
           INPUT_DIGIT:     out STD_LOGIC;                     --1 when waiting for input digit
           WRONG_INPUT:     out STD_LOGIC);
end CU_LOCKER;

architecture Behavioral of CU_LOCKER is

type state_type is (IDLE, ADD_1, RST_1, ADD_2, RST_2, ADD_3, RST_3, LOAD, LOCK, UNLOCK_1, RST_U_1, UNLOCK_2, RST_U_2, UNLOCK_3, RST_U_3, CHECK, SUCCESS, FAIL);
signal CURRENT_STATE, NEXT_STATE: state_type;

begin

--State register
process(CLK, RST)
    begin
        if RST = '1' then
            CURRENT_STATE <= IDLE;
        elsif rising_edge(CLK) then
            CURRENT_STATE <= NEXT_STATE;
        end if;
end process;

--Next state logic
process(CURRENT_STATE, ADD_DIGIT, EQ_CODES) --UP_BTN, DOWN_BTN?
    begin
        NEXT_STATE <= CURRENT_STATE; --Default
        case CURRENT_STATE is
            when IDLE => 
                if ADD_DIGIT = '1' then
                    NEXT_STATE <= ADD_1;
                end if;
            when ADD_1 => 
                if ADD_DIGIT = '1' then
                    NEXT_STATE <= RST_1;
                end if;
            when RST_1 =>
                NEXT_STATE <= ADD_2;
            when ADD_2 => 
                if ADD_DIGIT = '1' then
                    NEXT_STATE <= RST_2;
                end if;
            when RST_2 =>
                NEXT_STATE <= ADD_3;
            when ADD_3 => 
                if ADD_DIGIT = '1' then
                    NEXT_STATE <= RST_3;
                end if;
            when RST_3 =>
                NEXT_STATE <= LOAD;
            when LOAD =>
                NEXT_STATE <= LOCK;
            when LOCK => 
                if ADD_DIGIT = '1' then
                    NEXT_STATE <= UNLOCK_1;
                end if;
            when UNLOCK_1 => 
                if ADD_DIGIT = '1' then
                    NEXT_STATE <= RST_U_1;
                end if;
            when RST_U_1 =>
                NEXT_STATE <= UNLOCK_2;
            when UNLOCK_2 => 
                if ADD_DIGIT = '1' then
                    NEXT_STATE <= RST_U_2;
                end if;
            when RST_U_2 =>
                NEXT_STATE <= UNLOCK_3;
            when UNLOCK_3 => 
                if ADD_DIGIT = '1' then
                    NEXT_STATE <= RST_U_3;
                end if;
            when RST_U_3 =>
                NEXT_STATE <= CHECK;
            when CHECK =>
                if EQ_CODES = '1' then
                    NEXT_STATE <= SUCCESS;
                else
                    NEXT_STATE <= FAIL;
                end if;
            when SUCCESS =>
                NEXT_STATE <= IDLE;
            when FAIL =>
                if ADD_DIGIT = '1' then
                    NEXT_STATE <= LOCK;
                end if;
            when others =>
                NEXT_STATE <= IDLE;
        end case;
end process;

--Output logic
process(CURRENT_STATE)
begin

        case CURRENT_STATE is
            when IDLE =>
                WRITE_ENABLE <= '0';
                LOAD_CODE <= '0';
                COMPARE <= '0';
                AVAILABLE <= '0';
                INPUT_DIGIT <= '0';
                WRONG_INPUT <= '0';
                RST_DIGIT <= '0'; 
            when ADD_1 =>
                CUR_POS <= "00";
                WRITE_ENABLE <= '1';
                INPUT_DIGIT <= '1';
                RST_DIGIT <= '0';
                AVAILABLE <= '0';
                LOAD_CODE <= '0';
                COMPARE <= '0';
                WRONG_INPUT <= '0';
            when RST_1 =>
                WRITE_ENABLE <= '1';
                RST_DIGIT <= '1';
                AVAILABLE <= '0'; 
                LOAD_CODE <= '0';
                COMPARE <= '0';
                INPUT_DIGIT <= '0';
                WRONG_INPUT <= '0';
            when ADD_2 =>
                CUR_POS <= "01";
                WRITE_ENABLE <= '1';
                INPUT_DIGIT <= '1'; 
                RST_DIGIT <= '0';
                AVAILABLE <= '0'; 
                LOAD_CODE <= '0';
                COMPARE <= '0';
                WRONG_INPUT <= '0';
            when RST_2 =>
                WRITE_ENABLE <= '1';
                RST_DIGIT <= '1';
                AVAILABLE <= '0'; 
                LOAD_CODE <= '0';
                COMPARE <= '0';
                INPUT_DIGIT <= '0';
                WRONG_INPUT <= '0';
            when ADD_3 =>
                CUR_POS <= "10";
                WRITE_ENABLE <= '1';
                INPUT_DIGIT <= '1'; 
                RST_DIGIT <= '0';
                AVAILABLE <= '0'; 
                LOAD_CODE <= '0';
                COMPARE <= '0';
                WRONG_INPUT <= '0';
            when RST_3 =>
                WRITE_ENABLE <= '1';
                RST_DIGIT <= '1';
                AVAILABLE <= '0';
                LOAD_CODE <= '0';
                COMPARE <= '0';
                INPUT_DIGIT <= '0';
                WRONG_INPUT <= '0';
            when LOAD =>
                LOAD_CODE <= '1';
                WRITE_ENABLE <= '0'; 
                RST_DIGIT <= '0';
                AVAILABLE <= '0';
                COMPARE <= '0';
                INPUT_DIGIT <= '0';
                WRONG_INPUT <= '0';
            when LOCK =>
                LOAD_CODE <= '0';
                AVAILABLE <= '1';
                WRITE_ENABLE <= '0';
                COMPARE <= '0';
                INPUT_DIGIT <= '0';
                WRONG_INPUT <= '0';
                RST_DIGIT <= '0'; 
            when UNLOCK_1 =>
                WRONG_INPUT <= '0';
                CUR_POS <= "00";
                WRITE_ENABLE <= '1';
                AVAILABLE <= '1';
                INPUT_DIGIT <= '1'; 
                LOAD_CODE <= '0';
                COMPARE <= '0';
                RST_DIGIT <= '0'; 
            when RST_U_1 =>
                WRITE_ENABLE <= '1';
                RST_DIGIT <= '1';
                AVAILABLE <= '1'; 
                LOAD_CODE <= '0';
                COMPARE <= '0';
                INPUT_DIGIT <= '0';
                WRONG_INPUT <= '0'; 
            when UNLOCK_2 =>
                CUR_POS <= "01";
                WRITE_ENABLE <= '1';
                AVAILABLE <= '1';
                INPUT_DIGIT <= '1'; 
                RST_DIGIT <= '0';
                LOAD_CODE <= '0';
                COMPARE <= '0';
                WRONG_INPUT <= '0';
            when RST_U_2 =>
                WRITE_ENABLE <= '1';
                RST_DIGIT <= '1';
                AVAILABLE <= '1'; 
                LOAD_CODE <= '0';
                COMPARE <= '0';
                INPUT_DIGIT <= '0';
                WRONG_INPUT <= '0';
            when UNLOCK_3 =>
                CUR_POS <= "10";
                WRITE_ENABLE <= '1';
                AVAILABLE <= '1';
                INPUT_DIGIT <= '1';
                RST_DIGIT <= '0';  
                LOAD_CODE <= '0';
                COMPARE <= '0';
                WRONG_INPUT <= '0';
            when RST_U_3 =>
                WRITE_ENABLE <= '1';
                RST_DIGIT <= '1';
                AVAILABLE <= '1'; 
                LOAD_CODE <= '0';
                COMPARE <= '0';
                INPUT_DIGIT <= '0';
                WRONG_INPUT <= '0';
            when CHECK =>
                COMPARE <= '1';
                AVAILABLE <= '1';
                RST_DIGIT <= '0';
                WRITE_ENABLE <= '0';
                LOAD_CODE <= '0';
                INPUT_DIGIT <= '0';
                WRONG_INPUT <= '0'; 
            when FAIL =>
                AVAILABLE <= '1';
                WRONG_INPUT <= '1';
                WRITE_ENABLE <= '0';
                LOAD_CODE <= '0';
                COMPARE <= '0';
                INPUT_DIGIT <= '0';
                RST_DIGIT <= '0'; 
            when others =>
                null;
        end case;
end process;

INC <= UP_BTN;
DEC <= DOWN_BTN;
end Behavioral;
