--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:08:13 12/20/2017
-- Design Name:   
-- Module Name:   C:/Users/Steven/Desktop/basys3_phased_array//time_delay_tb.vhd
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: time_delay
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY time_delay_tb IS
END time_delay_tb;
 
ARCHITECTURE behavior OF time_delay_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT time_delay
    PORT(
         CLK : IN  std_logic;
         CURRENT_ANGLE : IN  std_logic_vector(7 downto 0);
         CURRENT_ANGLE_INDEX : IN  std_logic_vector(4 downto 0);
         ELEMENT : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal CURRENT_ANGLE : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(0, 8));
   signal CURRENT_ANGLE_INDEX : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(9, 5));

 	--Outputs
   signal ELEMENT : std_logic_vector(9 downto 0);

component clock_divider is
	Generic ( DIVISOR : natural ); -- must be even
	Port( 
			CLK : in  std_logic;
			CLKDIV : out  std_logic);
end component;
 
 
	signal count : natural := 0;
	constant one_ms : natural := 100000;
	
BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: time_delay PORT MAP (
          CLK => CLK,
          CURRENT_ANGLE => CURRENT_ANGLE,
          CURRENT_ANGLE_INDEX => CURRENT_ANGLE_INDEX,
          ELEMENT => ELEMENT
        );

	CLK <= not CLK after 5 ns;
	
	-- run simulator to 15ms
	process(CLK) is
	begin
	if(rising_edge(CLK)) then
		count <= count + 1;
		if(count = 20) then
			CURRENT_ANGLE <= std_logic_vector(to_signed(-10, 8));
			CURRENT_ANGLE_INDEX <= std_logic_vector(to_unsigned(8, 5));
		elsif(count = one_ms*2) then
			CURRENT_ANGLE <= std_logic_vector(to_signed(-40, 8));
			CURRENT_ANGLE_INDEX <= std_logic_vector(to_unsigned(5, 5));
		elsif(count = one_ms*4) then
			CURRENT_ANGLE <= std_logic_vector(to_signed(-90, 8));
			CURRENT_ANGLE_INDEX <= std_logic_vector(to_unsigned(0, 5));
		elsif(count = one_ms*7) then
			CURRENT_ANGLE <= std_logic_vector(to_signed(10, 8));
			CURRENT_ANGLE_INDEX <= std_logic_vector(to_unsigned(10, 5));
		elsif(count = one_ms*10) then
			CURRENT_ANGLE <= std_logic_vector(to_signed(40, 8));
			CURRENT_ANGLE_INDEX <= std_logic_vector(to_unsigned(13, 5));
			
		end if;
	end if;
	end process;
		
END;
