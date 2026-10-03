-------------------------------------------------------------------
-- FULL ADDER (STRUCTURAL)
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder_structural is
    port (
        i_a     : in    std_logic;
        i_b     : in    std_logic;
        i_cin   : in    std_logic;
        o_s     : out   std_logic;
        o_cout  : out   std_logic
    );
end entity;

architecture structural_arch of full_adder_structural is

    component half_adder_dataflow is
        port (
            i_a     : in    std_logic;
            i_b     : in    std_logic;
            o_s     : out   std_logic;
            o_c     : out   std_logic
        );
    end component;

    signal w_s1      : std_logic;
    signal w_c1      : std_logic;
    signal w_c2      : std_logic;

begin

    HA_0 : half_adder_dataflow
        port map (
            i_a => i_a,
            i_b => i_b,
            o_s => w_s1,
            o_c => w_c1
        );

    HA_1 : half_adder_dataflow
        port map (
            i_a => w_s1,
            i_b => i_cin,
            o_s => o_s,
            o_c => w_c2
        );

    o_cout <= w_c1 or w_c2;

end structural_arch;