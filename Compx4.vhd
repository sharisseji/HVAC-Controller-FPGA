-- Author: Group 2, Session 201, Noemie Lamontagne, Sharisse Ji
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- 4 bit comparator
entity Compx4 is
	PORT
	(
		A_4 	: in std_logic_vector(3 downto 0); -- 4 bit input , SWITCHES 3 DOWN TO 0
		B_4 	: in std_logic_vector(3 downto 0); -- 4 bit input
		
		AGTB_OUT	: out std_logic; 
		AEQB_OUT	: out std_logic; 
		ALTB_OUT	: out std_logic
	);
end Compx4;

ARCHITECTURE gates OF Compx4 is

	
  component Compx1 port (
		A 		: in std_logic; -- 1 bit input
		B 		: in std_logic; -- 1 bit input
		AGTB	: out std_logic; 
		AEQB	: out std_logic; 
		ALTB	: out std_logic
	);
	end component;
	
-- Create any signals, or temporary variables to be used
-- std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--	
	signal A3GTB3			: std_logic;
	signal A3EQB3			: std_logic;
	signal A3LTB3			: std_logic;
	
	
	signal A2GTB2			: std_logic;
	signal A2EQB2			: std_logic;
	signal A2LTB2			: std_logic;
	
	signal A1GTB1			: std_logic;
	signal A1EQB1			: std_logic;
	signal A1LTB1			: std_logic;
	
	signal A0GTB0			: std_logic;
	signal A0EQB0			: std_logic;
	signal A0LTB0			: std_logic;
	
	SIGNAL GREATER			: std_logic;
	signal EQUAL 			: STD_LOGIC;
	
-- Here the circuit begins
begin

--COMPONENT HOOKUP
	-- Daisy Chaining 1 bit adders to form full bit 4 adder
	INST1: Compx1 port map(A_4(3), B_4(3), A3GTB3, A3EQB3, A3LTB3);
	INST2: Compx1 port map(A_4(2), B_4(2), A2GTB2, A2EQB2, A2LTB2);
	INST3: Compx1 port map(A_4(1), B_4(1), A1GTB1, A1EQB1, A1LTB1);
	INST4: Compx1 port map(A_4(0), B_4(0), A0GTB0, A0EQB0, A0LTB0);
	
	GREATER <= (A3GTB3) OR ((A3EQB3) AND (A2GTB2)) OR ((A3EQB3) AND (A2EQB2) AND (A1GTB1)) OR ((A3EQB3) AND (A2EQB2) AND (A1EQB1) AND (A0GTB0)) ;	
	EQUAL <= (A3EQB3) AND  (A2EQB2) AND (A1EQB1) AND (A0EQB0);
	
	AGTB_OUT <= GREATER;	
	AEQB_OUT	<= EQUAL;	
	ALTB_OUT	<= (NOT GREATER) AND (NOT EQUAL);
	
	
end gates;
