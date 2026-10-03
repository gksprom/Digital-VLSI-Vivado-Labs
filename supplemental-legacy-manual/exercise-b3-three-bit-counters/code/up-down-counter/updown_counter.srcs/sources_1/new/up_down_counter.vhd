library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity up_down_counter is
    port (
        clk      : in  std_logic;
        resetn   : in  std_logic;
        count_en : in  std_logic;
        dir      : in  std_logic;
        sum      : out std_logic_vector(2 downto 0);
        cout     : out std_logic
    );
end entity;

architecture rtl of up_down_counter is
    signal count : std_logic_vector(2 downto 0);
begin

    process(clk, resetn)
    begin
        if resetn = '0' then
            count <= (others => '0');

        elsif clk'event and clk = '1' then
            if count_en = '1' then
                case dir is
                    when '1' =>
                        count <= count + 1;

                    when '0' =>
                        count <= count - 1;

                    when others =>
                        count <= count;
                end case;
            end if;
        end if;
    end process;

    sum <= count;

    cout <= '1' when ((dir = '1' and count = "111") or
                      (dir = '0' and count = "000")) and
                      count_en = '1'
            else '0';

end rtl;

reset_run impl_1
set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
set_property STEPS.OPT_DESIGN.ARGS.DIRECTIVE ExploreWithRemap [get_runs impl_1]
set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE AltSpreadLogic_high [get_runs impl_1]
set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
launch_runs impl_1 -jobs 4

reset_run impl_1
launch_runs impl_1 -jobs 4

open_run impl_1
write_bitstream -force design_1_wrapper.bit