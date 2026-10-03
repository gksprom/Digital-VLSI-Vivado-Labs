library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity half_adder_dataflow is
    port (
        i_a     : in    std_logic;
        i_b     : in    std_logic;
        o_s     : out   std_logic;
        o_c     : out   std_logic
    );
end entity;

architecture dataflow_arch of half_adder_dataflow is

begin 
    
    o_s <= i_a xor i_b;
    o_c <= i_a and i_b;

end dataflow_arch;