-- Basys 3 Phased Array Controller
-- By Jack Gallegos for CPE 133, Winter 2017, California Polytechnic State University

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port ( BUTTON_LEFT,BUTTON_RIGHT,BUTTON_CENTER,CLK : in std_logic;
           ELEMENT : out std_logic_vector(9 downto 0) := "0000000000";
           ANODE : out std_logic_vector(3 downto 0);
           CATHODE : out std_logic_vector(7 downto 0);
           NEG : out std_logic); -- 10 elements in this array
end top;
    


architecture Behavioral of top is

-- declare angle FSM
component angle_fsm
	generic (SIMULATING : boolean );
    Port ( CLK,LEFT,RIGHT,RST : in std_logic;
           CURRENT_ANGLE : out std_logic_vector(7 downto 0);
           CURRENT_ANGLE_INDEX : out std_logic_vector(4 downto 0) );
end component; 

-- declare angle display
component angle_display
    Port ( CURRENT_ANGLE : in std_logic_vector(7 downto 0); -- treat the angle as a signed 8-bit number (range -128 to 127 covered)
           CLK   : in std_logic;
           ANODE : out std_logic_vector(3 downto 0);
           CATHODE : out std_logic_vector(7 downto 0)   );
end component;

component time_delay
    Port ( CLK : in std_logic;
           CURRENT_ANGLE : in std_logic_vector(7 downto 0);
           CURRENT_ANGLE_INDEX : in std_logic_vector(4 downto 0);
           ELEMENT : out std_logic_vector(9 downto 0));
end component;

signal CURRENT_ANGLE : std_logic_vector(7 downto 0);
signal CURRENT_ANGLE_INDEX : std_logic_vector(4 downto 0);

begin

FSM : angle_fsm 
	generic map (SIMULATING => false ) 
	port map (
		CLK => CLK, 
		LEFT => button_left, 
		RIGHT => button_right, 
		RST => button_center, 
		CURRENT_ANGLE => CURRENT_ANGLE,
		CURRENT_ANGLE_INDEX => CURRENT_ANGLE_INDEX
		);

DISPLAY : angle_display 
	port map (
		CLK => CLK, 
		ANODE => ANODE, 
		CATHODE => CATHODE, 
		CURRENT_ANGLE => CURRENT_ANGLE);

DELAY : time_delay 
	port map (
		CLK => CLK, 
		CURRENT_ANGLE => CURRENT_ANGLE, 
		CURRENT_ANGLE_INDEX => CURRENT_ANGLE_INDEX, 
		ELEMENT => ELEMENT);

 
negative_indicate : process (CLK)
    variable angle_int : integer range -90 to 90;
begin
    angle_int := to_integer(signed(CURRENT_ANGLE));
    
    if angle_int >= 0 then
        NEG <= '0';
    else
        NEG <= '1';
    end if;
    
end process;
     




end Behavioral;
