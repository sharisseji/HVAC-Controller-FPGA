-- Author: Group 2, Session 201, Noemie Lamontagne, Sharisse Ji
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- 1 bit comparator
entity Compx1 is
	PORT
	(
		A 						: in std_logic; -- 1 bit input
		B 						: in std_logic; -- 1 bit input
		AGTB	: out std_logic; 
		AEQB	: out std_logic; 
		ALTB	: out std_logic
	);
end Compx1;

ARCHITECTURE gates OF Compx1 is

BEGIN


--AGTB <= (A XOR B) AND (A);
--
--AEQB <= (A) XNOR (B);
--ALTB <= (A XOR B) AND (B);

	ALTB <= (NOT A) AND B;
	AGTB <= (NOT B) AND A;
	AEQB <= ((NOT A) AND B) XNOR ((NOT B) AND A);
	



END gates;