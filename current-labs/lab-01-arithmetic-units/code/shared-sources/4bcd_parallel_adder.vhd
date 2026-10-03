-------------------------------------------------------------------
-- 4-BCD PARALLEL ADDER (STRUCTURAL)
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity parallel_bcd_adder_4digit_structural is
    port (
        i_a     : in    std_logic_vector(16-1 downto 0);
        i_b     : in    std_logic_vector(16-1 downto 0);
        i_cin   : in    std_logic;
        o_s     : out   std_logic_vector(16-1 downto 0);
        o_cout  : out   std_logic
    );
end entity;

architecture structural_arch of parallel_bcd_adder_4digit_structural is

    component bcd_full_adder_structural is
        port (
            i_a     : in    std_logic_vector(4-1 downto 0);
            i_b     : in    std_logic_vector(4-1 downto 0);
            i_cin   : in    std_logic;
            o_s     : out   std_logic_vector(4-1 downto 0);
            o_cout  : out   std_logic
        );
    end component;

    signal w_c1    : std_logic;
    signal w_c2    : std_logic;
    signal w_c3    : std_logic;

begin

    ----------------------------------------------------------------
    -- DIGIT 0 : UNITS
    ----------------------------------------------------------------
    BCD_FA_0 : bcd_full_adder_structural
        port map (
            i_a     => i_a(3 downto 0),
            i_b     => i_b(3 downto 0),
            i_cin   => i_cin,
            o_s     => o_s(3 downto 0),
            o_cout  => w_c1
        );

    ----------------------------------------------------------------
    -- DIGIT 1 : TENS
    ----------------------------------------------------------------
    BCD_FA_1 : bcd_full_adder_structural
        port map (
            i_a     => i_a(7 downto 4),
            i_b     => i_b(7 downto 4),
            i_cin   => w_c1,
            o_s     => o_s(7 downto 4),
            o_cout  => w_c2
        );

    ----------------------------------------------------------------
    -- DIGIT 2 : HUNDREDS
    ----------------------------------------------------------------
    BCD_FA_2 : bcd_full_adder_structural
        port map (
            i_a     => i_a(11 downto 8),
            i_b     => i_b(11 downto 8),
            i_cin   => w_c2,
            o_s     => o_s(11 downto 8),
            o_cout  => w_c3
        );

    ----------------------------------------------------------------
    -- DIGIT 3 : THOUSANDS
    ----------------------------------------------------------------
    BCD_FA_3 : bcd_full_adder_structural
        port map (
            i_a     => i_a(15 downto 12),
            i_b     => i_b(15 downto 12),
            i_cin   => w_c3,
            o_s     => o_s(15 downto 12),
            o_cout  => o_cout
        );

end structural_arch;