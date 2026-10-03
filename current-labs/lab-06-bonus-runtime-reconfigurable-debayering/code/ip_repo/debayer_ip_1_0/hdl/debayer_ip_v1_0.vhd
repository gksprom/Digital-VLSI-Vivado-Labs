library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debayer_ip_v1_0 is
    generic (
        C_S00_AXI_DATA_WIDTH  : integer := 32;
        C_S00_AXI_ADDR_WIDTH  : integer := 4;
        C_S00_AXIS_TDATA_WIDTH : integer := 8;
        C_M00_AXIS_TDATA_WIDTH : integer := 32;
        C_M00_AXIS_START_COUNT : integer := 32
    );
    port (
        -- AXI-Lite Slave
        s00_axi_aclk    : in  std_logic;
        s00_axi_aresetn : in  std_logic;
        s00_axi_awaddr  : in  std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_awprot  : in  std_logic_vector(2 downto 0);
        s00_axi_awvalid : in  std_logic;
        s00_axi_awready : out std_logic;
        s00_axi_wdata   : in  std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_wstrb   : in  std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
        s00_axi_wvalid  : in  std_logic;
        s00_axi_wready  : out std_logic;
        s00_axi_bresp   : out std_logic_vector(1 downto 0);
        s00_axi_bvalid  : out std_logic;
        s00_axi_bready  : in  std_logic;
        s00_axi_araddr  : in  std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_arprot  : in  std_logic_vector(2 downto 0);
        s00_axi_arvalid : in  std_logic;
        s00_axi_arready : out std_logic;
        s00_axi_rdata   : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_rresp   : out std_logic_vector(1 downto 0);
        s00_axi_rvalid  : out std_logic;
        s00_axi_rready  : in  std_logic;

        -- AXI-Stream Slave (pixel input)
        s00_axis_aclk    : in  std_logic;
        s00_axis_aresetn : in  std_logic;
        s00_axis_tready  : out std_logic;
        s00_axis_tdata   : in  std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
        s00_axis_tstrb   : in  std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
        s00_axis_tlast   : in  std_logic;
        s00_axis_tvalid  : in  std_logic;

        -- AXI-Stream Master (RGB output)
        m00_axis_aclk    : in  std_logic;
        m00_axis_aresetn : in  std_logic;
        m00_axis_tvalid  : out std_logic;
        m00_axis_tdata   : out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        m00_axis_tstrb   : out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
        m00_axis_tlast   : out std_logic;
        m00_axis_tready  : in  std_logic
    );
end debayer_ip_v1_0;

architecture arch_imp of debayer_ip_v1_0 is

    -- AXI-Lite slave component
    component debayer_ip_v1_0_S00_AXI is
        generic (
            C_S_AXI_DATA_WIDTH : integer := 32;
            C_S_AXI_ADDR_WIDTH : integer := 4
        );
        port (
            image_dim_data  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            image_dim_vld   : out std_logic;
            S_AXI_ACLK      : in  std_logic;
            S_AXI_ARESETN   : in  std_logic;
            S_AXI_AWADDR    : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S_AXI_AWPROT    : in  std_logic_vector(2 downto 0);
            S_AXI_AWVALID   : in  std_logic;
            S_AXI_AWREADY   : out std_logic;
            S_AXI_WDATA     : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_WSTRB     : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
            S_AXI_WVALID    : in  std_logic;
            S_AXI_WREADY    : out std_logic;
            S_AXI_BRESP     : out std_logic_vector(1 downto 0);
            S_AXI_BVALID    : out std_logic;
            S_AXI_BREADY    : in  std_logic;
            S_AXI_ARADDR    : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S_AXI_ARPROT    : in  std_logic_vector(2 downto 0);
            S_AXI_ARVALID   : in  std_logic;
            S_AXI_ARREADY   : out std_logic;
            S_AXI_RDATA     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_RRESP     : out std_logic_vector(1 downto 0);
            S_AXI_RVALID    : out std_logic;
            S_AXI_RREADY    : in  std_logic
        );
    end component;

    -- Internal signals
    signal image_dim_data_axi : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    signal image_dim_vld_axi  : std_logic;
    signal cfg_toggle_axi     : std_logic := '0';

    signal cfg_toggle_meta    : std_logic := '0';
    signal cfg_toggle_sync    : std_logic := '0';
    signal cfg_toggle_seen    : std_logic := '0';
    signal image_dim_data_axis : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal image_dim_vld_axis  : std_logic := '0';

    signal deb_R, deb_G, deb_B : std_logic_vector(7 downto 0);
    signal deb_valid_out        : std_logic;
    signal deb_img_done         : std_logic;
    signal deb_tready           : std_logic;
    signal deb_valid_in         : std_logic;
    signal first_pixel          : std_logic := '1';

begin

    -- AXI-Lite slave: handles register writes from ARM
    debayer_ip_v1_0_S00_AXI_inst : debayer_ip_v1_0_S00_AXI
        generic map (
            C_S_AXI_DATA_WIDTH => C_S00_AXI_DATA_WIDTH,
            C_S_AXI_ADDR_WIDTH => C_S00_AXI_ADDR_WIDTH
        )
        port map (
            image_dim_data  => image_dim_data_axi,
            image_dim_vld   => image_dim_vld_axi,
            S_AXI_ACLK      => s00_axi_aclk,
            S_AXI_ARESETN   => s00_axi_aresetn,
            S_AXI_AWADDR    => s00_axi_awaddr,
            S_AXI_AWPROT    => s00_axi_awprot,
            S_AXI_AWVALID   => s00_axi_awvalid,
            S_AXI_AWREADY   => s00_axi_awready,
            S_AXI_WDATA     => s00_axi_wdata,
            S_AXI_WSTRB     => s00_axi_wstrb,
            S_AXI_WVALID    => s00_axi_wvalid,
            S_AXI_WREADY    => s00_axi_wready,
            S_AXI_BRESP     => s00_axi_bresp,
            S_AXI_BVALID    => s00_axi_bvalid,
            S_AXI_BREADY    => s00_axi_bready,
            S_AXI_ARADDR    => s00_axi_araddr,
            S_AXI_ARPROT    => s00_axi_arprot,
            S_AXI_ARVALID   => s00_axi_arvalid,
            S_AXI_ARREADY   => s00_axi_arready,
            S_AXI_RDATA     => s00_axi_rdata,
            S_AXI_RRESP     => s00_axi_rresp,
            S_AXI_RVALID    => s00_axi_rvalid,
            S_AXI_RREADY    => s00_axi_rready
        );

    -- Cross the one-cycle AXI-Lite config pulse into the stream clock domain.
    process(s00_axi_aclk, s00_axi_aresetn)
    begin
        if s00_axi_aresetn = '0' then
            cfg_toggle_axi <= '0';
        elsif rising_edge(s00_axi_aclk) then
            if image_dim_vld_axi = '1' then
                cfg_toggle_axi <= not cfg_toggle_axi;
            end if;
        end if;
    end process;

    process(s00_axis_aclk, s00_axis_aresetn)
    begin
        if s00_axis_aresetn = '0' then
            cfg_toggle_meta     <= '0';
            cfg_toggle_sync     <= '0';
            cfg_toggle_seen     <= '0';
            image_dim_data_axis <= (others => '0');
            image_dim_vld_axis  <= '0';
        elsif rising_edge(s00_axis_aclk) then
            image_dim_vld_axis <= '0';
            cfg_toggle_meta    <= cfg_toggle_axi;
            cfg_toggle_sync    <= cfg_toggle_meta;

            if cfg_toggle_sync /= cfg_toggle_seen then
                cfg_toggle_seen     <= cfg_toggle_sync;
                image_dim_data_axis <= image_dim_data_axi;
                image_dim_vld_axis  <= '1';
            end if;
        end if;
    end process;

    -- first_pixel logic: high only for first pixel of each image
    process(s00_axis_aclk, s00_axis_aresetn)
    begin
        if s00_axis_aresetn = '0' then
            first_pixel <= '1';
        elsif rising_edge(s00_axis_aclk) then
            if deb_img_done = '1' then
                first_pixel <= '1';
            elsif s00_axis_tvalid = '1' and deb_tready = '1' then
                first_pixel <= '0';
            end if;
        end if;
    end process;

    deb_valid_in <= s00_axis_tvalid and deb_tready;

    -- Debayer accelerator
    u_debayer : entity work.debayer_partA_final
        port map (
            clk            => s00_axis_aclk,
            rst_n          => s00_axis_aresetn,
            image_dim      => image_dim_data_axis(10 downto 0),
            image_dim_vld  => image_dim_vld_axis,
            pixel          => s00_axis_tdata(7 downto 0),
            valid_in       => deb_valid_in,
            new_image      => first_pixel,
            R              => deb_R,
            G              => deb_G,
            B              => deb_B,
            valid_out      => deb_valid_out,
            image_finished => deb_img_done,
            tready         => deb_tready
        );

    -- AXI-Stream connections
    s00_axis_tready <= deb_tready;

    m00_axis_tdata  <= x"00" & deb_B & deb_G & deb_R;
    m00_axis_tvalid <= deb_valid_out;
    m00_axis_tlast  <= deb_img_done;
    m00_axis_tstrb  <= "1111";

end arch_imp;
