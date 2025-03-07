library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
--	HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
   clk        : in  std_logic := '0';
	DIN2 		: in  std_logic_vector(6 downto 0);	
	DIN1 		: in  std_logic_vector(6 downto 0);
	DOUT			: out	std_logic_vector(6 downto 0);
	DIG2			: out	std_logic;
	DIG1			: out	std_logic
   );
end component segment7_mux;

component Compx4 port (
	A_4 	: in std_logic_vector(3 downto 0); -- 4 bit input , SWITCHES 3 DOWN TO 0
	B_4 	: in std_logic_vector(3 downto 0); -- 4 bit input
		
	AGTB_OUT	: out std_logic; 
	AEQB_OUT	: out std_logic; 
	ALTB_OUT	: out std_logic
	);
end component;
	
	
component Bidir_shift_reg port (
	CLK				: in  std_logic := '0';
	RESET				: in  std_logic := '0';
	CLK_EN			: in 	std_logic := '0';
	LEFT0_RIGHT1	: in  std_logic := '0';
	REG_BITS			: out std_logic_vector(7 downto 0)
	);
end component;
	
component U_D_Bin_Counter8bit is port -- remove "is"?
	(
			CLK				: in std_logic;
			RESET				: in std_logic;
			CLK_EN			: in std_logic;
			UP1_DOWN0		: in std_logic;
			COUNTER_BITS	: out std_logic_vector(7 downto 0)
	);
	end component;
--	
component Tester port (
 MC_TESTMODE				: in  std_logic;
 I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
	); 
	end component;
----	
component HVAC 	port (
	HVAC_SIM					: in boolean;
	clk						: in std_logic; 
	run		   			: in std_logic;
	increase, decrease	: in std_logic;
	temp						: out std_logic_vector (3 downto 0)
	);
end component;
------------------------------------------------------------------
-- Add any Other Components here
------------------------------------------------------------------
component PB_Inverters port (
	pb_n : IN std_logic_vector(3 downto 0); 				-- push button input
	pb : OUT std_logic_vector(3 downto 0) 					-- inverted output
	);
end component;
	
component Energy_Monitor 	port (
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
end component;

component MODE_SELECT port(
	hex_num1										: in std_logic_vector(3 downto 0); -- 4 bit input
	hex_num2										: in std_logic_vector(3 downto 0); -- 4 bit input
	mux_select									: in std_logic; -- 1 bit select
	hex_out										:out std_logic_vector(3 downto 0) --output
);

end component;
------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------	
constant HVAC_SIM : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                      -- or TRUE for doing simulations with the HVAC Component

-- global clock
signal pb 						: std_logic_vector(3 downto 0);
signal clk_in					: std_logic;
signal hex_A, hex_B 			: std_logic_vector(3 downto 0);
signal hexA_7seg, hexB_7seg: std_logic_vector(6 downto 0);

-- general signal (may not all be necessary)
signal desiredtemp, vacationtemp, currenttemp: std_logic_vector(3 downto 0); -- currenttemp will be multiplexed
signal muxtemp : std_logic_vector(3 downto 0); -- temporary

-- ENERGY MONITOR (can these be the same names as above?)
signal AGTB						: std_logic;
signal AEQB						: std_logic;
signal ALTB						: std_logic;

signal vacationmode			: std_logic;
signal MCmode					: std_logic;
signal windowopen				: std_logic;
signal dooropen				: std_logic;

signal increase				: std_logic;
signal decrease				: std_logic;
signal run						: std_logic;

------------------------------------------------------------------- 
begin -- Here the circuit begins

clk_in <= clkin_50;	--hook up the clock input

-- temp inputs hook-up to internal busses. these will be erased later
--hex_A <= sw(3 downto 0); 
--hex_B <= sw(7 downto 4); 

desiredtemp <= sw(3 downto 0);
vacationtemp <= sw(7 downto 4); -- these need to be multiplexed together after this

--vacationmode <= pb(3); -- should be active high
--MCmode <= pb(2);
--windowopen <= pb(1);
--dooropen <= pb(0);
inst9: PB_Inverters port map( pb_n, pb);
--inst1: sevensegment port map (hex_A, hexA_7seg); -- inst 1 should take mux_temp (desired_temp and vacation temp with vacationmode as selector)
--inst2: sevensegment port map (hex_B, hexB_7seg);
--inst3: segment7_mux port map (clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1);
--inst4: Compx4 port map(hex_A, hex_B, leds(2), leds(1), leds(0));
--inst5: Bidir_shift_reg port map(clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
--inst6: U_D_Bin_Counter8bit port map(clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
--inst7: HVAC port map(HVAC_SIM, clk_in, sw(0), sw(1), sw(2), leds(3 downto 0)); -- outdated version, HVAC should go diectly to inst 8/energy monitor

-- FINAL CODE A BIT LIKE THIS (without the temp multiplexer):
inst1: sevensegment port map (muxtemp, hexA_7seg);
inst2: sevensegment port map (currenttemp, hexB_7seg); 
inst3: segment7_mux port map (clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1);
inst4: Compx4 port map(muxtemp, currenttemp, AGTB, AEQB, ALTB);
inst5: MODE_SELECT port map(desiredtemp, vacationtemp, pb(3), muxtemp);
INST6: Tester port map( pb(2), AEQB, AGTB, ALTB, desiredtemp, currenttemp, leds(6));
inst7: HVAC port map(HVAC_SIM, clk_in, run, increase, decrease, currenttemp); 
inst8: Energy_Monitor port map(AGTB, AEQB, ALTB, pb(3), pb(2), pb(1), pb(0),leds(0), leds(1), leds(2), leds(3), leds(4), leds(5), leds(7), decrease, increase, run);
		
end design;

