library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mac_unit is
    port(
        clk      : in  std_logic;
        rst      : in  std_logic;
        mac_init : in  std_logic;
        b        : in  std_logic_vector(7 downto 0);
        c        : in  std_logic_vector(7 downto 0);
        y        : out std_logic_vector(18 downto 0)
    );
end mac_unit;

architecture Behavioral of mac_unit is
    signal acc     : std_logic_vector(18 downto 0);
    signal product : std_logic_vector(15 downto 0);
begin

    product <= b * c;

    process(clk, rst)
    begin
        if rst = '1' then
            acc <= (others => '0');
        elsif clk'event and clk = '1' then
            if mac_init = '1' then
                acc <= "000" & product;
            else
                acc <= acc + ("000" & product);
            end if;
        end if;
    end process;

    y <= acc;

end Behavioral;