library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_synchronous_mult is
end entity;

architecture behavior of tb_synchronous_mult is

    -- Σήματα για τη σύνδεση με το Unit Under Test (UUT)
    signal clk : std_logic := '0';
    signal A   : std_logic_vector(3 downto 0) := (others => '0');
    signal B   : std_logic_vector(3 downto 0) := (others => '0');
    signal P   : std_logic_vector(7 downto 0);

    -- Ορισμός περιόδου ρολογιού (100 MHz)
    constant clk_period : time := 10 ns;

begin

    -- Σύνδεση του Πολλαπλασιαστή
    uut: entity work.synchronous_mult
        port map (
            clk => clk,
            A   => A,
            B   => B,
            P   => P
        );

    -- Παραγωγή ρολογιού
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Διαδικασία τροφοδοσίας δεδομένων (Stimulus)
    stim_proc: process
    begin		
        -- Αρχική αναμονή για σταθεροποίηση
        wait for 105 ns;

        -----------------------------------------------------------
        -- Τροφοδοσία εισόδων σε κάθε κύκλο (Pipeline Testing)
        -----------------------------------------------------------
        
        -- Πράξη 1: 3 * 5 = 15 (0x0F)
        A <= "0011"; B <= "0101";
        wait for clk_period;

        -- Πράξη 2: 10 * 2 = 20 (0x14)
        A <= "1010"; B <= "0010";
        wait for clk_period;

        -- Πράξη 3: 15 * 15 = 225 (0xE1)
        A <= "1111"; B <= "1111";
        wait for clk_period;

        -- Πράξη 4: 7 * 6 = 42 (0x2A)
        A <= "0111"; B <= "0110";
        wait for clk_period;

        -- Πράξη 5: 12 * 4 = 48 (0x30)
        A <= "1100"; B <= "0100";
        wait for clk_period;

        -- Μηδενισμός εισόδων και αναμονή για να αδειάσει η σωλήνωση (pipeline flush)
        A <= "0000"; B <= "0000";
        
        -- Περιμένουμε αρκετά για να δούμε όλα τα αποτελέσματα να βγαίνουν στην έξοδο P
        -- Λόγω του latency (περίπου 11-12 κύκλοι), χρειαζόμαστε τουλάχιστον 150-200ns
        wait for 300 ns;

        -- Τερματισμός της διαδικασίας stimulus χωρίς assert failure
        -- Το wait χωρίς παραμέτρους σταματάει το process για πάντα, 
        -- επιτρέποντας στο simulation να παραμείνει ενεργό στο Vivado.
        wait;
    end process;

end architecture;