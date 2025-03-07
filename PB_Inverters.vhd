-- Author: Group 2, Session 201, Noemie Lamontagne, Sharisse Ji
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- pb inverter
--converting push buttons from active high to active low
ENTITY PB_Inverters is
	PORT
	(
		pb_n : IN std_logic_vector(3 downto 0); -- push buttons 3 to 0 as input
		pb : OUT std_logic_vector(3 downto 0) -- output inverted push buttons
	);
END PB_Inverters;

ARCHITECTURE gates OF PB_Inverters is

BEGIN
--NOT gate
pb <= not(pb_n);

END gates;