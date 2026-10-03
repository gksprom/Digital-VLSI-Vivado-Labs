library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use std.env.all;

entity debayer_partA_final_tb is
    generic (
        N           : integer := 32;
        BASE_PATH   : string  := ".";
        INPUT_FILE  : string  := "input.txt";
        OUTPUT_FILE : string  := "dut_rgb.txt"
    );
end debayer_partA_final_tb;

architecture sim of debayer_partA_final_tb is

    constant CLK_PERIOD       : time   := 10 ns;
    constant FULL_INPUT_PATH  : string := BASE_PATH & "/" & INPUT_FILE;
    constant FULL_OUTPUT_PATH : string := BASE_PATH & "/" & OUTPUT_FILE;

    signal clk            : std_logic := '0';
    signal rst_n          : std_logic := '0';
    signal pixel          : std_logic_vector(7 downto 0) := (others => '0');
    signal valid_in       : std_logic := '0';
    signal new_image      : std_logic := '0';
    signal R              : std_logic_vector(7 downto 0);
    signal G              : std_logic_vector(7 downto 0);
    signal B              : std_logic_vector(7 downto 0);
    signal valid_out      : std_logic;
    signal image_finished : std_logic;

    file infile  : text open read_mode  is FULL_INPUT_PATH;
    file outfile : text open write_mode is FULL_OUTPUT_PATH;

begin

    clk <= not clk after CLK_PERIOD / 2;

    uut : entity work.debayer_partA_final
        generic map (
            N => N
        )
        port map (
            clk            => clk,
            rst_n          => rst_n,
            pixel          => pixel,
            valid_in       => valid_in,
            new_image      => new_image,
            R              => R,
            G              => G,
            B              => B,
            valid_out      => valid_out,
            image_finished => image_finished
        );

    stimulus_proc : process
        variable line_in     : line;
        variable pixel_int   : integer;
        variable pixels_read : integer := 0;
    begin
        rst_n     <= '0';
        pixel     <= (others => '0');
        valid_in  <= '0';
        new_image <= '0';

        wait for 3 * CLK_PERIOD;
        wait until rising_edge(clk);
        rst_n <= '1';
        wait until rising_edge(clk);

        while not endfile(infile) loop
            readline(infile, line_in);
            read(line_in, pixel_int);

            assert (pixel_int >= 0) and (pixel_int <= 255)
                report "Pixel value out of 8-bit range: " & integer'image(pixel_int)
                severity failure;

            pixel <= std_logic_vector(to_unsigned(pixel_int, 8));
            valid_in <= '1';

            if pixels_read = 0 then
                new_image <= '1';
            else
                new_image <= '0';
            end if;

            pixels_read := pixels_read + 1;
            wait until rising_edge(clk);
        end loop;

        valid_in  <= '0';
        new_image <= '0';
        pixel     <= (others => '0');

        assert pixels_read = N * N
            report "Input file contains " & integer'image(pixels_read) &
                   " pixels, but N*N = " & integer'image(N * N)
            severity failure;

        while image_finished /= '1' loop
            wait until rising_edge(clk);
        end loop;

        wait for 2 * CLK_PERIOD;
        report "Simulation finished successfully. Read " & integer'image(pixels_read) & " pixels.";
        stop;
        wait;
    end process;

    output_proc : process(clk)
        variable line_out : line;
    begin
        if rising_edge(clk) then
            if valid_out = '1' then
                write(line_out, to_integer(unsigned(R)));
                write(line_out, string'(" "));
                write(line_out, to_integer(unsigned(G)));
                write(line_out, string'(" "));
                write(line_out, to_integer(unsigned(B)));
                writeline(outfile, line_out);
            end if;
        end if;
    end process;

end sim;
