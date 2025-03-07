-- Author: Group 2, Session 201, Noemie Lamontagne, Sharisse Ji
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- ENERGY MONITOR
entity Energy_Monitor is
	PORT
	(
		AGTB	: in std_logic; 
		AEQB	: in std_logic; 
		ALTB	: in std_logic;
		
		vacation_mode: in std_logic;
		MC_test_mode: in std_logic;
		window_open: in std_logic;
		door_open: in std_logic;
		
		furnace: out std_logic;
		at_temp: out std_logic;
		AC: out std_logic;
		blower: out std_logic;
		window: out std_logic;
		door: out std_logic;
		vacation: out std_logic;
		
		decrease: out std_logic;
		increase: out std_logic;
		run: out std_logic
		
	);
end Energy_Monitor;

ARCHITECTURE one OF Energy_Monitor IS
	
	--Signal ud_bin_counter	: UNSIGNED(7 downto 0);
	
BEGIN

process (AGTB, AEQB, ALTB, vacation_mode, MC_test_mode, window_open, door_open ) is
begin
	
	-- Comparator Inuts
	if (AEQB = '1') then
		run <= '0';
		increase <= '0';
		decrease <= '0';
		at_temp <= '1';
		
		AC <= '0';
		furnace <= '0';
		blower <= '0';
		
	elsif(ALTB = '1') then
		run <= '1';
		increase <= '0';
		decrease <= '1';
		at_temp <= '0';
		
		AC <= '1';
		furnace <= '0';
		blower <= '1'; -- this doesn't include a negation of the first two statements though
		
	elsif(AGTB = '1') then
		run <= '1';
		increase <= '1';
		decrease <= '0';
		at_temp <= '0';
		
		AC <= '0';
		furnace <= '1';
		blower <= '1'; -- neither does this
	end if;
	
	-- Door, Window, and Vaction LEDs
	if (door_open = '1') then
		door <= '1';
		run <= '0';
	ELSE
		door <= '0';
	end if;
	if (window_open = '1') then
		window <= '1';
		run <= '0';
	ELSE
		window <= '0';
	end if;
	if (vacation_mode = '1') then
		vacation <= '1';
	Else
		vacation <='0';
	end if;
	
	
	-- General Conditions that apply to all cases
	if ((window_open = '1') OR (door_open = '1')) then
		run <= '0';
		blower <= '0';
		
	end if;
	if (MC_test_mode = '1') then
		run <= '0';
		blower <= '0';
	end if;
	
	
end process;
end;
	