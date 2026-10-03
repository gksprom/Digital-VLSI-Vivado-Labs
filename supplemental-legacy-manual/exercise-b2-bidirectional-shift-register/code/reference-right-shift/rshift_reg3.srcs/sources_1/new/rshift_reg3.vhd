library IEEE;
use IEEE.std_logic_1164.all;

entity rshift_reg3 is
    port (
        clk, rst, si, en, pl : in std_logic;
        din                  : in std_logic_vector(3 downto 0);
        so                   : out std_logic
    );
end rshift_reg3;

architecture rtl of rshift_reg3 is
    signal dff : std_logic_vector(3 downto 0);
begin

    edge : process(clk, rst)
    begin
        if rst = '0' then
            dff <= (others => '0');

        elsif clk'event and clk = '1' then
            if pl = '1' then
                dff <= din;

            elsif en = '1' then
                dff <= si & dff(3 downto 1);
            end if;
        end if;
    end process;

    so <= dff(0);

end rtl;