-------------------------------------------------------------------
-- 4-BCD PARALLEL ADDER (STRUCTURAL) - TESTBENCH
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity parallel_bcd_adder_4digit_structural_tb is
end entity;

architecture tb of parallel_bcd_adder_4digit_structural_tb is

    component parallel_bcd_adder_4digit_structural is
        port (
            i_a     : in    std_logic_vector(16-1 downto 0);
            i_b     : in    std_logic_vector(16-1 downto 0);
            i_cin   : in    std_logic;
            o_s     : out   std_logic_vector(16-1 downto 0);
            o_cout  : out   std_logic
        );
    end component;

    signal i_a      : std_logic_vector(15 downto 0) := (others => '0');
    signal i_b      : std_logic_vector(15 downto 0) := (others => '0');
    signal i_cin    : std_logic := '0';
    signal o_s      : std_logic_vector(15 downto 0);
    signal o_cout   : std_logic;

    constant TIME_DELAY : time := 10 ns;

    ----------------------------------------------------------------
    -- INTEGER (0..9999) TO 4-DIGIT BCD
    ----------------------------------------------------------------
    function to_bcd4(value : integer) return std_logic_vector is
        variable v_thousands : integer;
        variable v_hundreds  : integer;
        variable v_tens      : integer;
        variable v_ones      : integer;
        variable v_result    : std_logic_vector(15 downto 0);
    begin
        v_thousands := (value / 1000) mod 10;
        v_hundreds  := (value / 100) mod 10;
        v_tens      := (value / 10) mod 10;
        v_ones      := value mod 10;

        v_result(15 downto 12) := std_logic_vector(to_unsigned(v_thousands, 4));
        v_result(11 downto 8)  := std_logic_vector(to_unsigned(v_hundreds, 4));
        v_result(7 downto 4)   := std_logic_vector(to_unsigned(v_tens, 4));
        v_result(3 downto 0)   := std_logic_vector(to_unsigned(v_ones, 4));

        return v_result;
    end function;

begin

    DUT : parallel_bcd_adder_4digit_structural
        port map (
            i_a     => i_a,
            i_b     => i_b,
            i_cin   => i_cin,
            o_s     => o_s,
            o_cout  => o_cout
        );

    STIMULUS : process
    begin
        ------------------------------------------------------------
        -- 0000 + 0000 + 0 = 0000
        ------------------------------------------------------------
        i_a   <= to_bcd4(0);
        i_b   <= to_bcd4(0);
        i_cin <= '0';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(0) and o_cout = '0')
        report "ERROR: wrong output for 0000 + 0000 + 0"
        severity error;

        ------------------------------------------------------------
        -- 0001 + 0001 + 0 = 0002
        ------------------------------------------------------------
        i_a   <= to_bcd4(1);
        i_b   <= to_bcd4(1);
        i_cin <= '0';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(2) and o_cout = '0')
        report "ERROR: wrong output for 0001 + 0001 + 0"
        severity error;

        ------------------------------------------------------------
        -- 0009 + 0001 + 0 = 0010
        ------------------------------------------------------------
        i_a   <= to_bcd4(9);
        i_b   <= to_bcd4(1);
        i_cin <= '0';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(10) and o_cout = '0')
        report "ERROR: wrong output for 0009 + 0001 + 0"
        severity error;

        ------------------------------------------------------------
        -- 0012 + 0034 + 0 = 0046
        ------------------------------------------------------------
        i_a   <= to_bcd4(12);
        i_b   <= to_bcd4(34);
        i_cin <= '0';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(46) and o_cout = '0')
        report "ERROR: wrong output for 0012 + 0034 + 0"
        severity error;

        ------------------------------------------------------------
        -- 0099 + 0001 + 0 = 0100
        ------------------------------------------------------------
        i_a   <= to_bcd4(99);
        i_b   <= to_bcd4(1);
        i_cin <= '0';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(100) and o_cout = '0')
        report "ERROR: wrong output for 0099 + 0001 + 0"
        severity error;

        ------------------------------------------------------------
        -- 0999 + 0001 + 0 = 1000
        ------------------------------------------------------------
        i_a   <= to_bcd4(999);
        i_b   <= to_bcd4(1);
        i_cin <= '0';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(1000) and o_cout = '0')
        report "ERROR: wrong output for 0999 + 0001 + 0"
        severity error;

        ------------------------------------------------------------
        -- 1234 + 4321 + 0 = 5555
        ------------------------------------------------------------
        i_a   <= to_bcd4(1234);
        i_b   <= to_bcd4(4321);
        i_cin <= '0';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(5555) and o_cout = '0')
        report "ERROR: wrong output for 1234 + 4321 + 0"
        severity error;

        ------------------------------------------------------------
        -- 5678 + 1111 + 0 = 6789
        ------------------------------------------------------------
        i_a   <= to_bcd4(5678);
        i_b   <= to_bcd4(1111);
        i_cin <= '0';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(6789) and o_cout = '0')
        report "ERROR: wrong output for 5678 + 1111 + 0"
        severity error;

        ------------------------------------------------------------
        -- 8056 + 0943 + 1 = 9000
        ------------------------------------------------------------
        i_a   <= to_bcd4(8056);
        i_b   <= to_bcd4(943);
        i_cin <= '1';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(9000) and o_cout = '0')
        report "ERROR: wrong output for 8056 + 0943 + 1"
        severity error;

        ------------------------------------------------------------
        -- 9999 + 0000 + 1 = 0000 with carry out = 1
        ------------------------------------------------------------
        i_a   <= to_bcd4(9999);
        i_b   <= to_bcd4(0);
        i_cin <= '1';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(0) and o_cout = '1')
        report "ERROR: wrong output for 9999 + 0000 + 1"
        severity error;

        ------------------------------------------------------------
        -- 9999 + 9999 + 0 = 9998 with carry out = 1
        ------------------------------------------------------------
        i_a   <= to_bcd4(9999);
        i_b   <= to_bcd4(9999);
        i_cin <= '0';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(9998) and o_cout = '1')
        report "ERROR: wrong output for 9999 + 9999 + 0"
        severity error;

        ------------------------------------------------------------
        -- 9999 + 9999 + 1 = 9999 with carry out = 1
        ------------------------------------------------------------
        i_a   <= to_bcd4(9999);
        i_b   <= to_bcd4(9999);
        i_cin <= '1';
        wait for TIME_DELAY;

        assert (o_s = to_bcd4(9999) and o_cout = '1')
        report "ERROR: wrong output for 9999 + 9999 + 1"
        severity error;

        report "4-BCD PARALLEL ADDER TEST COMPLETED SUCCESSFULLY"
        severity note;

        wait;
    end process;

end architecture;