library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debayer_partA_final is
    generic (
        N : integer := 32
    );
    port (
        clk            : in  std_logic;
        rst_n          : in  std_logic;
        pixel          : in  std_logic_vector(7 downto 0);
        valid_in       : in  std_logic;
        new_image      : in  std_logic;
        R              : out std_logic_vector(7 downto 0);
        G              : out std_logic_vector(7 downto 0);
        B              : out std_logic_vector(7 downto 0);
        valid_out      : out std_logic;
        image_finished : out std_logic
    );
end debayer_partA_final;

architecture rtl of debayer_partA_final is

    -- Line Buffers (RAM FIFOs)
    type row_buffer_t is array (0 to N-1) of std_logic_vector(7 downto 0);
    signal fifo1, fifo2 : row_buffer_t := (others => (others => '0'));
    signal wr_ptr       : integer range 0 to N-1 := 0;

    attribute ram_style :string;
    attribute ram_style of fifo1 :signal is "block";
    attribute ram_style of fifo2 :signal is "block";

    -- 3x3 Window Registers
    signal p22, p21, p20 : std_logic_vector(7 downto 0) := (others => '0');
    signal p12, p11, p10 : std_logic_vector(7 downto 0) := (others => '0');
    signal p02, p01, p00 : std_logic_vector(7 downto 0) := (others => '0');

    -- Muxed signals for Edge Zero-Padding
    signal mux_p00, mux_p01, mux_p02 : std_logic_vector(7 downto 0);
    signal mux_p10, mux_p11, mux_p12 : std_logic_vector(7 downto 0);
    signal mux_p20, mux_p21, mux_p22 : std_logic_vector(7 downto 0);

    -- Control Counters
    signal in_count    : integer range 0 to N*N := 0;
    signal out_count   : integer range 0 to N*N := 0;
    -- Αυξήσαμε το όριο του μετρητή για να μην κάνει overflow
    signal shift_count : integer range 0 to N*N + N + 5 := 0; 
    signal out_row     : integer range 0 to N-1 := 0;
    signal out_col     : integer range 0 to N-1 := 0;

    signal flushing      : std_logic;
    signal shift_en      : std_logic;
    signal pixel_in_mux  : std_logic_vector(7 downto 0);
    
    signal row_even, col_even : std_logic;
    signal core_valid_in      : std_logic;
    signal core_last_in       : std_logic;

begin

    -- Ξεκινάμε να "αδειάζουμε" (flush) την pipeline όταν σταματήσουν τα pixels εισόδου
    flushing     <= '1' when (in_count = N*N) and (out_count < N*N) else '0';
    shift_en     <= valid_in or flushing;
    
    -- Αν κάνουμε flush, βάζουμε 0 στις κενές θέσεις (Zero padding στα όρια)
    pixel_in_mux <= pixel when valid_in = '1' else (others => '0');

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

                fifo1(0) <= pixel;
                fifo2(0) <= (others=>'0');
            else
                if valid_in = '1' and in_count < N*N then
                    in_count <= in_count + 1;
                end if;

                if shift_en = '1' then
                    if shift_count < N*N + N + 4 then
                        shift_count <= shift_count + 1;
                    end if;

                    -- ΔΙΟΡΘΩΣΗ ΕΔΩ: N + 2 κύκλοι (αντί για N + 1) για να ευθυγραμμιστεί το p11
                    if shift_count >= N + 2 and out_count < N*N then
                        out_count <= out_count + 1;
                        if out_col = N - 1 then
                            out_col <= 0;
                            out_row <= out_row + 1;
                        else
                            out_col <= out_col + 1;
                        end if;
                    end if;

                    -- Shift Registers (οδήγηση από τα δεξιά προς τα αριστερά)
                    p22 <= pixel_in_mux;
                    p21 <= p22;
                    p20 <= p21;

                    p12 <= fifo1(wr_ptr);
                    p11 <= p12;
                    p10 <= p11;

                    p02 <= fifo2(wr_ptr);
                    p01 <= p02;
                    p00 <= p01;

                    -- Εγγραφή στα FIFOs
                    fifo1(wr_ptr) <= pixel_in_mux;
                    fifo2(wr_ptr) <= fifo1(wr_ptr);

                    -- Κυκλικός Pointer για τα FIFOs
                    if wr_ptr = N-1 then
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

    -- Zero-Padding Πολυπλέκτες για τα ακριανά pixels
    mux_p00 <= (others => '0') when (out_row = 0) or (out_col = 0) else p00;
    mux_p01 <= (others => '0') when (out_row = 0)                  else p01;
    mux_p02 <= (others => '0') when (out_row = 0) or (out_col = N-1) else p02;

    mux_p10 <= (others => '0') when (out_col = 0)                  else p10;
    mux_p11 <= p11;
    mux_p12 <= (others => '0') when (out_col = N-1)                else p12;

    mux_p20 <= (others => '0') when (out_row = N-1) or (out_col = 0) else p20;
    mux_p21 <= (others => '0') when (out_row = N-1)                  else p21;
    mux_p22 <= (others => '0') when (out_row = N-1) or (out_col = N-1) else p22;

    -- Σήματα ελέγχου για το Core
    -- ΔΙΟΡΘΩΣΗ ΕΔΩ: Επίσης N + 2 για το πότε στέλνουμε valid στο core
    core_valid_in <= '1' when (shift_en = '1') and (shift_count >= N + 2) and (out_count < N*N) else '0';
    core_last_in  <= '1' when (core_valid_in = '1') and (out_count = N*N - 1) else '0';

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