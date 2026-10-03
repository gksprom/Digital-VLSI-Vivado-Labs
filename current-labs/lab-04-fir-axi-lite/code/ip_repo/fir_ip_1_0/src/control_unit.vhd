library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
    port(
        clk         : in  std_logic;
        rst         : in  std_logic;
        valid_in    : in  std_logic;
        rom_address : out std_logic_vector(2 downto 0);
        ram_address : out std_logic_vector(2 downto 0);
        mac_init    : out std_logic;
        valid_out   : out std_logic
    );
end control_unit;

architecture Behavioral of control_unit is
    signal count         : std_logic_vector(2 downto 0) := "000";
    signal busy          : std_logic := '0';
    signal valid_out_reg : std_logic := '0';
begin

    process(clk, rst)
    begin
        if rst = '1' then
            count         <= "000";
            busy          <= '0';
            valid_out_reg <= '0';

        elsif clk'event and clk = '1' then
            valid_out_reg <= '0';

            if busy = '0' then
                if valid_in = '1' then
                    busy  <= '1';
                    count <= "001";
                else
                    count <= "000";
                end if;

            else
                if count = "000" then
                    valid_out_reg <= '1';

                    if valid_in = '1' then
                        busy  <= '1';
                        count <= "001";
                    else
                        busy  <= '0';
                        count <= "000";
                    end if;

                elsif count < "111" then
                    count <= count + 1;

                else
                    -- count = "111"
                    count <= "000";
                end if;
            end if;
        end if;
    end process;

    rom_address <= count;
    ram_address <= count;

    -- IMPORTANT: combinational, not registered
    mac_init <= '1' when (busy = '1' and count = "001") else '0';

    valid_out <= valid_out_reg;

end Behavioral;