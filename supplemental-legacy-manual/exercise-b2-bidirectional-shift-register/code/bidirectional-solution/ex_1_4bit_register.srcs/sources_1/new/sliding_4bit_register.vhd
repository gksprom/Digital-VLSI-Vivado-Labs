library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sliding_4bit_register is
    port (
        clk : in std_logic;
        rst : in std_logic;
        pl  : in std_logic;
        en  : in std_logic;
        dir : in std_logic;  -- 0: right shift, 1: left shift
        si  : in std_logic;
        din : in std_logic_vector(3 downto 0);
        so  : out std_logic
    );
end entity;

architecture behavioral of sliding_4bit_register is
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
                case dir is
                    when '0' =>
                        -- right shift
                        dff <= si & dff(3 downto 1);

                    when '1' =>
                        -- left shift
                        dff <= dff(2 downto 0) & si;

                    when others =>
                        dff <= dff;
                end case;
            end if;
        end if;
    end process;

    so <= dff(0) when dir = '0' else dff(3);

end architecture;