library ieee;
use ieee.std_logic_1164.all;

entity fir_top is
    port(
        clk       : in  std_logic;
        rst       : in  std_logic;
        valid_in  : in  std_logic;
        x         : in  std_logic_vector(7 downto 0);
        y         : out std_logic_vector(18 downto 0);
        valid_out : out std_logic
    );
end fir_top;

architecture Structural of fir_top is

    signal rom_address_s : std_logic_vector(2 downto 0);
    signal ram_address_s : std_logic_vector(2 downto 0);

    signal rom_out_s     : std_logic_vector(7 downto 0);
    signal ram_out_s     : std_logic_vector(7 downto 0);

    signal mac_init_s    : std_logic;

begin

    U_CONTROL : entity work.control_unit
        port map(
            clk         => clk,
            rst         => rst,
            valid_in    => valid_in,
            rom_address => rom_address_s,
            ram_address => ram_address_s,
            mac_init    => mac_init_s,
            valid_out   => valid_out
        );

    U_ROM : entity work.mlab_rom
        generic map(
            coeff_width => 8
        )
        port map(
            clk     => clk,
            en      => '1',
            addr    => rom_address_s,
            rom_out => rom_out_s
        );

    U_RAM : entity work.mlab_ram
        generic map(
            data_width => 8
        )
        port map(
            clk  => clk,
            we   => valid_in,
            en   => '1',
            addr => ram_address_s,
            di   => x,
            do   => ram_out_s,
            reset => rst
        );

    U_MAC : entity work.mac_unit
        port map(
            clk      => clk,
            b        => rom_out_s,
            c        => ram_out_s,
            rst     => rst,
            mac_init => mac_init_s,
            y        => y
        );

end Structural;