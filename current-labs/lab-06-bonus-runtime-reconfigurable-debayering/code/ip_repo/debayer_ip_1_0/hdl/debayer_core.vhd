library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debayer_core is
    port (
        clk           : in  std_logic;
        rst_n         : in  std_logic;
        valid_in      : in  std_logic;
        last_in       : in  std_logic;

        p00, p01, p02 : in  std_logic_vector(7 downto 0);
        p10, p11, p12 : in  std_logic_vector(7 downto 0);
        p20, p21, p22 : in  std_logic_vector(7 downto 0);
        row_even      : in  std_logic;
        col_even      : in  std_logic;

        r_out         : out std_logic_vector(7 downto 0);
        g_out         : out std_logic_vector(7 downto 0);
        b_out         : out std_logic_vector(7 downto 0);
        valid_out     : out std_logic;
        last_out      : out std_logic
    );
end debayer_core;

architecture rtl of debayer_core is
begin
    process(clk, rst_n)
        variable r_v  : unsigned(7 downto 0);
        variable g_v  : unsigned(7 downto 0);
        variable b_v  : unsigned(7 downto 0);
        variable sum2 : unsigned(8 downto 0);
        variable sum4 : unsigned(9 downto 0);
    begin
        if rst_n = '0' then
            r_out     <= (others => '0');
            g_out     <= (others => '0');
            b_out     <= (others => '0');
            valid_out <= '0';
            last_out  <= '0';

        elsif rising_edge(clk) then
            valid_out <= valid_in;
            last_out  <= last_in;

            if valid_in = '1' then
                r_v  := (others => '0');
                g_v  := (others => '0');
                b_v  := (others => '0');
                sum2 := (others => '0');
                sum4 := (others => '0');

                -- GBRG Pattern
                if (row_even = '1' and col_even = '1') then
                    g_v := unsigned(p11);
                    sum2 := resize(unsigned(p01), 9) + resize(unsigned(p21), 9);
                    r_v  := sum2(8 downto 1);
                    sum2 := resize(unsigned(p10), 9) + resize(unsigned(p12), 9);
                    b_v  := sum2(8 downto 1);

                elsif (row_even = '1' and col_even = '0') then
                    b_v := unsigned(p11);
                    sum4 := resize(unsigned(p01), 10) + resize(unsigned(p10), 10) +
                            resize(unsigned(p12), 10) + resize(unsigned(p21), 10);
                    g_v := sum4(9 downto 2);
                    sum4 := resize(unsigned(p00), 10) + resize(unsigned(p02), 10) +
                            resize(unsigned(p20), 10) + resize(unsigned(p22), 10);
                    r_v := sum4(9 downto 2);

                elsif (row_even = '0' and col_even = '1') then
                    r_v := unsigned(p11);
                    sum4 := resize(unsigned(p01), 10) + resize(unsigned(p10), 10) +
                            resize(unsigned(p12), 10) + resize(unsigned(p21), 10);
                    g_v := sum4(9 downto 2);
                    sum4 := resize(unsigned(p00), 10) + resize(unsigned(p02), 10) +
                            resize(unsigned(p20), 10) + resize(unsigned(p22), 10);
                    b_v := sum4(9 downto 2);

                else
                    g_v := unsigned(p11);
                    sum2 := resize(unsigned(p10), 9) + resize(unsigned(p12), 9);
                    r_v  := sum2(8 downto 1);
                    sum2 := resize(unsigned(p01), 9) + resize(unsigned(p21), 9);
                    b_v  := sum2(8 downto 1);
                end if;

                r_out <= std_logic_vector(r_v);
                g_out <= std_logic_vector(g_v);
                b_out <= std_logic_vector(b_v);
            end if;
        end if;
    end process;
end rtl;
