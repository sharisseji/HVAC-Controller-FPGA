-- Author: Group 2, Session 201, Noemie Lamontagne, Sharisse Ji
library ieee;
use ieee.std_logic_1164.all;

-- Simple Logic Processor
entity MODE_SELECT is
port(
	hex_num1										: in std_logic_vector(3 downto 0); -- 4 bit input
	hex_num2										: in std_logic_vector(3 downto 0); -- 4 bit input
	mux_select									: in std_logic; -- 1 bit select
	hex_out										:out std_logic_vector(3 downto 0) --output
);

end MODE_SELECT;

architecture mux_logic of MODE_SELECT is

begin
-- for the multiplexing of four hex input buses
--deciding which gate/operator result to display on leds
	with mux_select select
	hex_out <= (hex_num1) when '0',
				  (hex_num2) when '1';
				  

end mux_logic;