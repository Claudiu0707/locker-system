# System to secure lockers
The aim of the project is to design and implement a system to secure lockers using a three digit alpha-numerical code. <br />The project is designed to target the Artix-7 XC7A100T hardware architecture.

## Usage
To test the functionality of the system there is the necessity of a FPGA board (For the development and testing, a <b>Digilent Nexys A7</b> board was used).
The design can be adapted to other FPGA architectures by modifying the XDC [constraints file](https://github.com/Claudiu0707/locker-system/tree/main/Locker/Locker.srcs/constrs_1/new).<br />
A <b>bitstream</b> needs to be generated and uploaded to the FPGA board. 

### User manual
1. The user is expected to find the system in an <b>idle state</b>, waiting for input. This state is characterized by an empty display and all LEDs turned off.
   
2. Press the <b>ADD_DIGIT</b> button to activate the system. The display will show the leftmost digit. At the same time, an LED that indicates to the user that a digit should be introduced is activated. In this state, the user can choose the digit
   using the <b>UP</b> and <b>DOWN</b> buttons, the pressing of these buttons having immediate action on the display. Once the user is satisfied with the digit they chose, they must press the <b>ADD_DIGIT</b> button, and the system will move to the
   next digit. This process is repeated until all three digits have been introduced.
   
3. After selecting the third and final digit, press the <b>ADD_DIGIT</b> button. The system will then enter the <b>locked state</b>. At this point, the locker is locked and an LED that indicates this will become active. The LED stays active until the locker is later
   unlocked. At the same time, the LED, which was activated when the user began the introduction of the code, will be turned off, and the display will be cleared.
   
4. To unlock the locker, press the <b>ADD_DIGIT</b> button again. The introduction of the code is almost identical to the one described before, but this time, besides the LED that indicates the introduction of digits, the LED that indicates that the
   system is locked is also active. Same as before, if the user is satisfied with the 3rd digit, pressing the <b>ADD_DIGIT</b> button will confirm the code, which is compared to the one previously introduced. If both are identical, the system is unlocked
   (the locked LED is turned off), and it comes back to the <b>idle state</b>. Otherwise, the locked LED continues to be active, and, besides that, an LED which signalsthat the code was wrong becomes active too. To bring the system back to the
   <b>locked state</b>, the user should press the <b>ADD_DIGIT</b> button once again.
   
5. At any point during these steps, should the user activate the <b>RST</b> reset switch, the system will automatically be brought back to the <b>idle state</b>. 

## Notes for future developments
This project can receive further improvements to enhance the functionality of the system.<br />
Refining and organizing the code could also benefit to the readability of it.
