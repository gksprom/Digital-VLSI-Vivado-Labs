-------------------------------------------------------------------
-- BCD FULL ADDER (STRUCTURAL)
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_full_adder_structural is
    port (
        i_a     : in    std_logic_vector(4-1 downto 0);
        i_b     : in    std_logic_vector(4-1 downto 0);
        i_cin   : in    std_logic;
        o_s     : out   std_logic_vector(4-1 downto 0);
        o_cout  : out   std_logic
    );
end entity;

architecture structural_arch of bcd_full_adder_structural is

    component parallel_adder_4bit_structural is
        port (
            i_a     : in    std_logic_vector(4-1 downto 0);
            i_b     : in    std_logic_vector(4-1 downto 0);
            i_cin   : in    std_logic;
            o_s     : out   std_logic_vector(4-1 downto 0);
            o_cout  : out   std_logic
        );
    end component;

    signal w_sum_bin     : std_logic_vector(3 downto 0);
    signal w_carry_bin   : std_logic;
    signal w_correction  : std_logic;
    signal w_fix         : std_logic_vector(3 downto 0);
    signal w_unused      : std_logic;

begin

    ----------------------------------------------------------------
    -- FIRST 4-BIT ADDER: BINARY ADDITION
    ----------------------------------------------------------------
    ADDER_0 : parallel_adder_4bit_structural
        port map (
            i_a     => i_a,
            i_b     => i_b,
            i_cin   => i_cin,
            o_s     => w_sum_bin,
            o_cout  => w_carry_bin
        );

    ----------------------------------------------------------------
    -- CORRECTION LOGIC
    -- correction = carry OR (sum(3) and sum(2)) OR (sum(3) and sum(1))
    ----------------------------------------------------------------
    w_correction <= w_carry_bin or
                    (w_sum_bin(3) and w_sum_bin(2)) or
                    (w_sum_bin(3) and w_sum_bin(1));

    ----------------------------------------------------------------
    -- ADD 0110 IF CORRECTION IS NEEDED
    ----------------------------------------------------------------
    w_fix(3) <= '0';
    w_fix(2) <= w_correction;
    w_fix(1) <= w_correction;
    w_fix(0) <= '0';

    ----------------------------------------------------------------
    -- SECOND 4-BIT ADDER: BCD CORRECTION
    ----------------------------------------------------------------
    ADDER_1 : parallel_adder_4bit_structural
        port map (
            i_a     => w_sum_bin,
            i_b     => w_fix,
            i_cin   => '0',
            o_s     => o_s,
            o_cout  => w_unused
        );

    ----------------------------------------------------------------
    -- DECIMAL CARRY OUT
    ----------------------------------------------------------------
    o_cout <= w_correction;

end structural_arch;