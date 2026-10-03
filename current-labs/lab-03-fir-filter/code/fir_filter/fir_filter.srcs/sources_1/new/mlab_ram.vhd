library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mlab_ram is
    generic (
        data_width : integer := 8
    );
    port (
        clk   : in  std_logic;
        reset : in  std_logic;   -- asynchronous reset
        we    : in  std_logic;   -- memory write enable
        en    : in  std_logic;   -- operation enable
        addr  : in  std_logic_vector(2 downto 0);
        di    : in  std_logic_vector(data_width-1 downto 0);
        do    : out std_logic_vector(data_width-1 downto 0)
    );
end mlab_ram;

architecture Behavioral of mlab_ram is

    type ram_type is array (7 downto 0) of std_logic_vector(data_width-1 downto 0);
    signal RAM : ram_type := (others => (others => '0'));

begin

    process(clk, reset)
    begin
        if reset = '1' then
            RAM <= (others => (others => '0'));
            do  <= (others => '0');

        elsif clk'event and clk = '1' then
            if en = '1' then
                if we = '1' then
                    RAM(7) <= RAM(6);
                    RAM(6) <= RAM(5);
                    RAM(5) <= RAM(4);
                    RAM(4) <= RAM(3);
                    RAM(3) <= RAM(2);
                    RAM(2) <= RAM(1);
                    RAM(1) <= RAM(0);
                    RAM(0) <= di;
                    do <= di;   -- write-first behavior
                else
                    do <= RAM(conv_integer(addr));
                end if;
            end if;
        end if;
    end process;

end Behavioral;