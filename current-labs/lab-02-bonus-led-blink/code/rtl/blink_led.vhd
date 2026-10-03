-------------------------------------------------------------------
-- Blink Single LED Example
-- Digital VLSI Course
-- Microlab <ipapalambrou@microlab.ntua.gr> Ilias Papalamprou
-------------------------------------------------------------------
-- This code implements a simple module that blinks an output  
-- LED on Zybo, using a single-bit shift register.
--
-- Original code from: 
-- https://digilent.com/reference/learn/programmable-logic/tutorials/zybo-led-demo/start
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity blink_led is
    generic (
        COUNTER_LIMIT : natural := 28
    );
    port (
        -----------------------------------------------------------
        -- CONTROL SIGNALS
        i_clk   : in    std_logic;
        -----------------------------------------------------------
        -- MAIN SIGNALS
        o_led0  : out   std_logic
    );
end entity;

architecture behavioral_arch of blink_led is

    signal count_reg : std_logic_vector(COUNTER_LIMIT-1 downto 0) := (others => '0');

begin
    
    BLINK_LED_PROCESS : process(i_clk)
    begin
        if (rising_edge(i_clk)) then
            count_reg <= count_reg + 1;
        end if;
    end process;

    o_led0 <= count_reg(COUNTER_LIMIT-1);

end behavioral_arch;