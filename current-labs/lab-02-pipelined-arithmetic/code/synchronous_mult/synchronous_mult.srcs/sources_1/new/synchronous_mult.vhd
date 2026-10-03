library ieee;
use ieee.std_logic_1164.all;

entity synchronous_mult is
    port (
        clk : in  std_logic;
        A   : in  std_logic_vector(3 downto 0);
        B   : in  std_logic_vector(3 downto 0);
        P   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture structural of synchronous_mult is

    -- 2D Array signals for the systolic grid
    type grid_signal is array (0 to 3, 0 to 3) of std_logic;
    signal ai, ao, bi, bo, si, so, ci, co : grid_signal := (others => (others => '0'));

    -- Skewing (Input) registers for synchronizing A and B
    signal a1_d1 : std_logic := '0';
    signal a2_d1, a2_d2 : std_logic := '0';
    signal a3_d1, a3_d2, a3_d3 : std_logic := '0';

    signal b1_d1, b1_d2 : std_logic := '0';
    signal b2_d1, b2_d2, b2_d3, b2_d4 : std_logic := '0';
    signal b3_d1, b3_d2, b3_d3, b3_d4, b3_d5, b3_d6 : std_logic := '0';

    -- Deskewing (Output) registers for T=10 latency alignment
    signal p0_pipe : std_logic_vector(8 downto 0) := (others => '0');
    signal p1_pipe : std_logic_vector(6 downto 0) := (others => '0');
    signal p2_pipe : std_logic_vector(4 downto 0) := (others => '0');
    signal p3_pipe : std_logic_vector(2 downto 0) := (others => '0');
    signal p4_pipe : std_logic_vector(1 downto 0) := (others => '0');
    signal p5_pipe : std_logic_vector(0 downto 0) := (others => '0');

begin

    ----------------------------------------------------------------
    -- 1. Input Skewing
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            -- A skew: A(j) delayed by j cycles
            a1_d1 <= A(1);
            a2_d1 <= A(2); a2_d2 <= a2_d1;
            a3_d1 <= A(3); a3_d2 <= a3_d1; a3_d3 <= a3_d2;

            -- B skew: B(i) delayed by 2*i cycles
            b1_d1 <= B(1); b1_d2 <= b1_d1;
            b2_d1 <= B(2); b2_d2 <= b2_d1; b2_d3 <= b2_d2; b2_d4 <= b2_d3;
            b3_d1 <= B(3); b3_d2 <= b3_d1; b3_d3 <= b3_d2; b3_d4 <= b3_d3; b3_d5 <= b3_d4; b3_d6 <= b3_d5;
        end if;
    end process;

    ----------------------------------------------------------------
    -- 2. Boundary Assignments
    ----------------------------------------------------------------
    ai(0,0) <= A(0); ai(0,1) <= a1_d1; ai(0,2) <= a2_d2; ai(0,3) <= a3_d3;
    bi(0,0) <= B(0); bi(1,0) <= b1_d2; bi(2,0) <= b2_d4; bi(3,0) <= b3_d6;

    ----------------------------------------------------------------
    -- 3. Grid Generation and Interconnections
    ----------------------------------------------------------------
    rows: for i in 0 to 3 generate
        cols: for j in 0 to 3 generate
            cell: entity work.fa_star
                port map (
                    clk => clk, a_in => ai(i,j), b_in => bi(i,j), s_in => si(i,j), c_in => ci(i,j),
                    a_out => ao(i,j), b_out => bo(i,j), s_out => so(i,j), c_out => co(i,j)
                );

            -- Horizontal propagation of B and Carry
            horiz: if j < 3 generate
                bi(i, j+1) <= bo(i,j);
                ci(i, j+1) <= co(i,j);
            end generate;

            -- Vertical propagation of A and Diagonal propagation of Sums
            vert: if i < 3 generate
                ai(i+1, j) <= ao(i,j);
                
                diag_sum: if j > 0 generate
                    si(i+1, j-1) <= so(i,j);
                end generate;
                
                -- The last cell of a row passes its carry to the last cell of the next row
                last_sum: if j = 3 generate
                    si(i+1, 3) <= co(i,3);
                end generate;
            end generate;
        end generate;
    end generate;

    ----------------------------------------------------------------
    -- 4. Output Alignment (T=10 Latency)
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            p0_pipe <= p0_pipe(7 downto 0) & so(0,0); -- Produced at T=1
            p1_pipe <= p1_pipe(5 downto 0) & so(1,0); -- Produced at T=3
            p2_pipe <= p2_pipe(3 downto 0) & so(2,0); -- Produced at T=5
            p3_pipe <= p3_pipe(1 downto 0) & so(3,0); -- Produced at T=7
            p4_pipe <= p4_pipe(0 downto 0) & so(3,1); -- Produced at T=8
            p5_pipe(0) <= so(3,2);                    -- Produced at T=9
        end if;
    end process;

    P(0) <= p0_pipe(8);
    P(1) <= p1_pipe(6);
    P(2) <= p2_pipe(4);
    P(3) <= p3_pipe(2);
    P(4) <= p4_pipe(1);
    P(5) <= p5_pipe(0);
    P(6) <= so(3,3); -- Produced at T=10
    P(7) <= co(3,3); -- Produced at T=10

end architecture;