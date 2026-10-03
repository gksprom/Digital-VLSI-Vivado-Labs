library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity modulo_counter is
    port(
        clk      : in  std_logic;
        resetn   : in  std_logic;  -- async reset, active low
        count_en : in  std_logic;  -- sync enable, active high
        modulo   : in  std_logic_vector(2 downto 0); -- limit value
        sum      : out std_logic_vector(2 downto 0);
        cout     : out std_logic   -- '1' when wrap happens
    );
end entity;

architecture rtl of modulo_counter is
    signal count : std_logic_vector(2 downto 0);
begin

    process(clk, resetn)
    begin
        if resetn = '0' then
            count <= (others => '0');

        elsif clk'event and clk = '1' then
            if count_en = '1' then
                if count = modulo then
                    count <= (others => '0');   -- wrap to 0
                else
                    count <= count + 1;         -- increment
                end if;
            end if;
        end if;
    end process;

    sum  <= count;
    cout <= '1' when (count_en = '1' and count = modulo) else '0';

end rtl;