-------------------------------------------------------------------
-- BCD FULL ADDER (STRUCTURAL) - TESTBENCH
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_full_adder_structural_tb is
end entity;

architecture tb of bcd_full_adder_structural_tb is

    ----------------------------------------------------------------
    -- COMPONENT
    ----------------------------------------------------------------
    component bcd_full_adder_structural is
        port (
            i_a     : in    std_logic_vector(4-1 downto 0);
            i_b     : in    std_logic_vector(4-1 downto 0);
            i_cin   : in    std_logic;
            o_s     : out   std_logic_vector(4-1 downto 0);
            o_cout  : out   std_logic
        );
    end component;

    ----------------------------------------------------------------
    -- SIGNALS
    ----------------------------------------------------------------
    signal i_a      : std_logic_vector(3 downto 0) := (others => '0');
    signal i_b      : std_logic_vector(3 downto 0) := (others => '0');
    signal i_cin    : std_logic := '0';
    signal o_s      : std_logic_vector(3 downto 0);
    signal o_cout   : std_logic;

    constant TIME_DELAY : time := 10 ns;

begin

    DUT : bcd_full_adder_structural
        port map (
            i_a     => i_a,
            i_b     => i_b,
            i_cin   => i_cin,
            o_s     => o_s,
            o_cout  => o_cout
        );

    STIMULUS : process
        variable v_a        : integer;
        variable v_b        : integer;
        variable v_cin      : integer;
        variable v_total    : integer;
        variable v_digit    : integer;
        variable v_cout_exp : std_logic;
    begin

        for v_a in 0 to 9 loop
            for v_b in 0 to 9 loop
                for v_cin in 0 to 1 loop

                    i_a <= std_logic_vector(to_unsigned(v_a, 4));
                    i_b <= std_logic_vector(to_unsigned(v_b, 4));

                    if v_cin = 0 then
                        i_cin <= '0';
                    else
                        i_cin <= '1';
                    end if;

                    wait for TIME_DELAY;

                    v_total := v_a + v_b + v_cin;

                    if v_total >= 10 then
                        v_digit    := v_total - 10;
                        v_cout_exp := '1';
                    else
                        v_digit    := v_total;
                        v_cout_exp := '0';
                    end if;

                    assert (o_s = std_logic_vector(to_unsigned(v_digit, 4)) and
                            o_cout = v_cout_exp)
                    report "ERROR: wrong output for A=" & integer'image(v_a) &
                           " B=" & integer'image(v_b) &
                           " Cin=" & integer'image(v_cin)
                    severity error;

                end loop;
            end loop;
        end loop;

        report "BCD FULL ADDER TEST COMPLETED SUCCESSFULLY"
        severity note;

        wait;
    end process;

end architecture;