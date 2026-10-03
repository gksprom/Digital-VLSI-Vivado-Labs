library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debayer_partA_final is
    port (
        clk            : in  std_logic;
        rst_n          : in  std_logic;
        -- Runtime image size configuration
        image_dim      : in  std_logic_vector(10 downto 0); -- max 1024
        image_dim_vld  : in  std_logic;
        -- Pixel input
        pixel          : in  std_logic_vector(7 downto 0);
        valid_in       : in  std_logic;
        new_image      : in  std_logic;
        -- RGB output
        R              : out std_logic_vector(7 downto 0);
        G              : out std_logic_vector(7 downto 0);
        B              : out std_logic_vector(7 downto 0);
        valid_out      : out std_logic;
        image_finished : out std_logic;
        -- Ready: only high after image_dim configured
        tready         : out std_logic
    );
end debayer_partA_final;

architecture rtl of debayer_partA_final is

    -- Maximum size always 1024
    constant MAX_N : integer := 1024;

    -- Line Buffers fixed at max size
    type row_buffer_t is array (0 to MAX_N-1) of std_logic_vector(7 downto 0);
    signal fifo1, fifo2 : row_buffer_t := (others => (others => '0'));
    signal wr_ptr       : integer range 0 to MAX_N-1 := 0;

    attribute ram_style : string;
    attribute ram_style of fifo1 : signal is "block";
    attribute ram_style of fifo2 : signal is "block";

    -- Runtime image dimension
    signal img_n        : integer range 1 to MAX_N := MAX_N;
    signal dim_ready    : std_logic := '0';

    -- 3x3 Window Registers
    signal p22, p21, p20 : std_logic_vector(7 downto 0) := (others => '0');
    signal p12, p11, p10 : std_logic_vector(7 downto 0) := (others => '0');
    signal p02, p01, p00 : std_logic_vector(7 downto 0) := (others => '0');

    -- Muxed signals for Edge Zero-Padding
    signal mux_p00, mux_p01, mux_p02 : std_logic_vector(7 downto 0);
    signal mux_p10, mux_p11, mux_p12 : std_logic_vector(7 downto 0);
    signal mux_p20, mux_p21, mux_p22 : std_logic_vector(7 downto 0);

    -- Control Counters
    signal in_count    : integer range 0 to MAX_N*MAX_N := 0;
    signal out_count   : integer range 0 to MAX_N*MAX_N := 0;
    signal shift_count : integer range 0 to MAX_N*MAX_N + MAX_N + 5 := 0;
    signal out_row     : integer range 0 to MAX_N-1 := 0;
    signal out_col     : integer range 0 to MAX_N-1 := 0;

    signal flushing      : std_logic;
    signal shift_en      : std_logic;
    signal pixel_in_mux  : std_logic_vector(7 downto 0);

    -- Effective write pointer: 0 on first pixel of new image, else wr_ptr.
    -- Using a single variable-index write pattern enables BRAM inference.
    signal wr_ptr_eff    : integer range 0 to MAX_N-1 := 0;

    signal row_even, col_even : std_logic;
    signal core_valid_in      : std_logic;
    signal core_last_in       : std_logic;

begin

    -- tready only when dimension has been configured
    tready <= dim_ready;

    flushing     <= '1' when (in_count = img_n*img_n) and (out_count < img_n*img_n) else '0';
    shift_en     <= valid_in or flushing;
    pixel_in_mux <= pixel when valid_in = '1' else (others => '0');

    -- On the first pixel of a new image, write to address 0 regardless of wr_ptr.
    -- This gives both branches a single variable-address write, enabling BRAM inference.
    wr_ptr_eff <= 0 when (new_image = '1') and (valid_in = '1') else wr_ptr;

    -- Latch image_dim when valid
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            img_n     <= MAX_N;
            dim_ready <= '0';
        elsif rising_edge(clk) then
            if image_dim_vld = '1' then
                img_n     <= to_integer(unsigned(image_dim));
                dim_ready <= '1';
            end if;
            -- Reset ready after image finished so next image needs new dim
            if image_dim_vld = '0' and in_count = 0 and out_count = 0 then
                null; -- keep ready
            end if;
        end if;
    end process;

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            in_count    <= 0;
            out_count   <= 0;
            shift_count <= 0;
            wr_ptr      <= 0;
            out_row     <= 0;
            out_col     <= 0;
            p22 <= (others=>'0'); p21 <= (others=>'0'); p20 <= (others=>'0');
            p12 <= (others=>'0'); p11 <= (others=>'0'); p10 <= (others=>'0');
            p02 <= (others=>'0'); p01 <= (others=>'0'); p00 <= (others=>'0');

        elsif rising_edge(clk) then
            if (new_image = '1') and (valid_in = '1') then
                in_count    <= 1;
                out_count   <= 0;
                shift_count <= 1;
                wr_ptr      <= 1;
                out_row     <= 0;
                out_col     <= 0;

                p22 <= pixel; p21 <= (others=>'0'); p20 <= (others=>'0');
                p12 <= (others=>'0'); p11 <= (others=>'0'); p10 <= (others=>'0');
                p02 <= (others=>'0'); p01 <= (others=>'0'); p00 <= (others=>'0');

                -- wr_ptr_eff = 0 here (combinatorial), so this writes to address 0
                fifo1(wr_ptr_eff) <= pixel;
                fifo2(wr_ptr_eff) <= (others=>'0');
            else
                if valid_in = '1' and in_count < img_n*img_n then
                    in_count <= in_count + 1;
                end if;

                if shift_en = '1' then
                    if shift_count < img_n*img_n + img_n + 4 then
                        shift_count <= shift_count + 1;
                    end if;

                    if shift_count >= img_n + 2 and out_count < img_n*img_n then
                        out_count <= out_count + 1;
                        if out_col = img_n - 1 then
                            out_col <= 0;
                            out_row <= out_row + 1;
                        else
                            out_col <= out_col + 1;
                        end if;
                    end if;

                    p22 <= pixel_in_mux;
                    p21 <= p22;
                    p20 <= p21;

                    p12 <= fifo1(wr_ptr_eff);
                    p11 <= p12;
                    p10 <= p11;

                    p02 <= fifo2(wr_ptr_eff);
                    p01 <= p02;
                    p00 <= p01;

                    fifo1(wr_ptr_eff) <= pixel_in_mux;
                    fifo2(wr_ptr_eff) <= fifo1(wr_ptr_eff);

                    if wr_ptr = img_n-1 then
                        wr_ptr <= 0;
                    else
                        wr_ptr <= wr_ptr + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    row_even <= '1' when (out_row mod 2 = 0) else '0';
    col_even <= '1' when (out_col mod 2 = 0) else '0';

    -- Zero-Padding Muxes
    mux_p00 <= (others => '0') when (out_row = 0) or (out_col = 0)             else p00;
    mux_p01 <= (others => '0') when (out_row = 0)                              else p01;
    mux_p02 <= (others => '0') when (out_row = 0) or (out_col = img_n-1)       else p02;

    mux_p10 <= (others => '0') when (out_col = 0)                              else p10;
    mux_p11 <= p11;
    mux_p12 <= (others => '0') when (out_col = img_n-1)                        else p12;

    mux_p20 <= (others => '0') when (out_row = img_n-1) or (out_col = 0)       else p20;
    mux_p21 <= (others => '0') when (out_row = img_n-1)                        else p21;
    mux_p22 <= (others => '0') when (out_row = img_n-1) or (out_col = img_n-1) else p22;

    core_valid_in <= '1' when (shift_en = '1') and (shift_count >= img_n + 2) and (out_count < img_n*img_n) else '0';
    core_last_in  <= '1' when (core_valid_in = '1') and (out_count = img_n*img_n - 1) else '0';

    u_core: entity work.debayer_core
        port map (
            clk       => clk,
            rst_n     => rst_n,
            valid_in  => core_valid_in,
            last_in   => core_last_in,
            p00       => mux_p00, p01 => mux_p01, p02 => mux_p02,
            p10       => mux_p10, p11 => mux_p11, p12 => mux_p12,
            p20       => mux_p20, p21 => mux_p21, p22 => mux_p22,
            row_even  => row_even,
            col_even  => col_even,
            r_out     => R,
            g_out     => G,
            b_out     => B,
            valid_out => valid_out,
            last_out  => image_finished
        );

end rtl;
