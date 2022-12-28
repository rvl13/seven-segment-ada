# seven-segment-ada

A simple display driver for 7 Segment LED displays of any arbitary number of digits, controlled directly using GPIOs. programmed in Ada.
<br>
<br>

Please read the hackster post here :
<br>
https://www.hackster.io/RVLAD/7-segment-led-display-driver-with-ada-on-stm32f4-discovery-cccc0a
<br>
Althogh the code on hackster post is a bit outdated, but still relevant to the latest code in this repo.

<br>
<br>
Note that it requires installing arm-elf ada compiler
<br>
Then download the Ada Drivers Library (ADL) from here : https://github.com/AdaCore/Ada_Drivers_Library
<br>
Then place this project in Ada_Drivers_Library/examples/STM32F4_DISCO/
<br>
And finally open the SevenSegment.gpr file in GNAT Studio.
