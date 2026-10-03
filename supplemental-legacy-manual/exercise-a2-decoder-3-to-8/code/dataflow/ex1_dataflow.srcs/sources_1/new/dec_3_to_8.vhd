----------------------------------------------------------------------------------
-- DECODER 3 TO 8
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec_3_to_8 is
    port (
        enc : in  std_logic_vector(3-1 downto 0);
        dec : out std_logic_vector(8-1 downto 0)
    );
end entity;

architecture dataflow_arch of dec_3_to_8 is

begin

    dec(0) <= (not enc(2)) and (not enc(1)) and (not enc(0));
    dec(1) <= (not enc(2)) and (not enc(1)) and enc(0);
    dec(2) <= (not enc(2)) and enc(1) and (not enc(0));
    dec(3) <= (not enc(2)) and enc(1) and enc(0);
    dec(4) <= enc(2) and (not enc(1)) and (not enc(0));
    dec(5) <= enc(2) and (not enc(1)) and enc(0);
    dec(6) <= enc(2) and enc(1) and (not enc(0));
    dec(7) <= enc(2) and enc(1) and enc(0);

end dataflow_arch;