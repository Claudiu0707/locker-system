# Three digit cipher for locker systems - VHDL implementation
This projects contains the design and implementation of a system designed to secure lockers using a three digit alpha-numerical code. <br /> The main target of this project is the Artix-7 XC7A100T hardware architecture. Our development and testing of this project took place on a <i><b>Digilent Nexys A7 board</b></i>.

## Usage & constraints
- An FPGA board is required in order to test the functionality of the cipher system. 
- Should the design of this project be implemented on other FPGA architectures, XDC [constraints file](https://github.com/Claudiu0707/locker-system/tree/main/Locker/Locker.srcs/constrs_1/new) will be modified by the user according to the desired target.
- A <b>bitstream</b> must be generated and uploaded onto the FPGA board.

### User manual - How should the system behave?
1. The user is expected to find the system in an <b>idle state</b>, waiting for input. This state is characterized by an empty display and all LEDs turned off.
   
2. Pressing the <b>ADD_DIGIT</b> button will activate the system and display the leftmost digit. At the same time, a LED that indicates to the user that a digit should be introduced is activated. In this state, the user can choose the digit using the <b>UP</b> and <b>DOWN</b> buttons. Once the user is satisfied with the digit they chose, they must press the <b>ADD_DIGIT</b> button, and the system will move to the
   next digit. This process is repeated until all three digits have been introduced.
   
3. After selecting the third and final digit, press the <b>ADD_DIGIT</b> button. The system will then enter the <b>locked state</b>. A new LED activates and stays active until the locker is later
   unlocked. At the same time, the LED, which was activated when the user began the introduction of the code, will be turned off, and the display will be cleared.
   
4. To unlock the locker, press the <b>ADD_DIGIT</b> button again. The introduction of the code is identical to the one described before. As before, if the user is satisfied with the 3rd digit, pressing the <b>ADD_DIGIT</b> button will confirm the code, which is compared to the one previously introduced. If both are identical, the system is unlocked and it comes back to the <b>idle state</b>. Otherwise, the system remains locked and a new LED signalises that the code was wrong.

5. At any point during these steps, should the user activate the <b>RST</b> reset switch, the system will automatically be brought back to the <b>idle state</b>.

A more detailed walkthrough of these steps can be found in the [documentation](https://github.com/Claudiu0707/locker-system/blob/main/Project%20Documentation.pdf) for this project.
