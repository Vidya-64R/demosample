--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: top.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::ProASIC3L> <Die::A3PE3000L> <Package::484 FBGA>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity top is
port (
	clkin   : in  std_logic;
    reset   : in  std_logic;
    rw      : in std_logic;
    oe      : in std_logic;
    CS      : in std_logic;
    data    : inout std_logic_vector(7 downto 0);
    TX      : out std_logic;
    RX      : in std_logic;
    addr    : in std_logic_vector(2 downto 0)
);
end top;

architecture architecture_top of top is

	signal baud_clk, baud_clk_16x, baud_clk_16x_pre, clk : std_logic;
    signal baud_rate_div_h, baud_rate_div_l : std_logic_vector(7 downto 0);
    signal baud_rate_div : std_logic_vector(15 downto 0);
    signal config_reg, status_reg, write_fifo, read_fifo : std_logic_vector(7 downto 0);
    signal fifo_rd_clk, fifo_wr_clk, start_tx : std_logic;
    signal address : std_logic_vector(2 downto 0);
    
--    signal    m_axi_lite_awready          :  std_logic                         ;-- AXI4-Lite
--signal    m_axi_lite_awvalid          :  std_logic                         ;-- AXI4-Lite
--signal    m_axi_lite_awaddr           :  std_logic_vector (31 downto 0);-- AXI4-Lite
--signal    m_axi_lite_wready           :  std_logic                         ;-- AXI4-Lite
--signal    m_axi_lite_wvalid           :  std_logic                         ;-- AXI4-Lite
--signal    m_axi_lite_wdata            :  std_logic_vector (31 downto 0);-- AXI4-Lite
--signal    m_axi_lite_bready           :  std_logic                         ;-- AXI4-Lite
--signal    m_axi_lite_bvalid           :  std_logic                         ;-- AXI4-Lite
--signal    m_axi_lite_bresp            :  std_logic_vector(1 downto 0)      ;-- AXI4-Lite
--signal    s_axi_lite_arready          :  std_logic                         ;-- AXI4-Lite
--signal    s_axi_lite_arvalid          :  std_logic                         ;-- AXI4-Lite
--signal    s_axi_lite_araddr           :  std_logic_vector (31 downto 0);-- AXI4-Lite
--signal    s_axi_lite_rready           :  std_logic                         ;-- AXI4-Lite
--signal    s_axi_lite_rvalid           :  std_logic                         ;-- AXI4-Lite
--signal    s_axi_lite_rdata            :  std_logic_vector (31 downto 0);-- AXI4-Lite
--signal    s_axi_lite_rresp            :  std_logic_vector(1 downto 0)      ;-- AXI4-Lite

    component Baud_Clk_Gen is
        port (
            reset           : in  std_logic;
            clk             : in std_logic;
            baud_clk        : out std_logic;
            baud_clk_16x    : out std_logic;
            baud_div        : in std_logic_vector(15 downto 0)
        );
    end component;

    component tx_top is
        port (
            reset           : IN  std_logic;
            baud_clk        : IN  std_logic;
            rw              : in std_logic;
            data_in         : in std_logic_vector ( 7 downto 0);
            bits            : in std_logic_vector ( 3 downto 0);
            parity_enable   : in std_logic;
            parity_odd      : in std_logic;
            parity_even     : in std_logic;
            tx_fifo_full    : out std_logic;
            tx_fifo_empty   : out std_logic;
            status_sh_reg   : out std_logic;
            TX              : out std_logic
        );
    end component;

    component rx_top is
    port (
    	reset           : IN  std_logic;
        baud_clk_16x    : IN  std_logic;
        oe              : in std_logic;
        data_out        : out std_logic_vector ( 7 downto 0);
        bits            : in std_logic_vector ( 3 downto 0);
        parity_enable   : in std_logic;
        parity_even     : in std_logic;
        rx_fifo_full    : out std_logic;
        rx_fifo_empty   : out std_logic;
        framing_error   : out std_logic;
        parity_error    : out std_logic;
        RX              : in std_logic
    );
    end component;

    component reg_module_comb is
    port (
        clk             : in std_logic;
        reset           : in std_logic;
        cs              : in std_logic;
        rw              : IN  std_logic;
        oe              : IN  std_logic;
        address         : in std_logic_vector(2 downto 0);
        data            : inout std_logic_vector(7 downto 0);

        fifo_rd         : out std_logic;
        fifo_wr         : out std_logic;
        start_tx        : out std_logic;
        baud_rate_div_l : inout std_logic_vector(7 downto 0);
        baud_rate_div_h : inout std_logic_vector(7 downto 0);
        write_fifo      : out std_logic_vector(7 downto 0);
        read_fifo       : in std_logic_vector(7 downto 0);
        config_reg      : inout std_logic_vector(7 downto 0);
        status          : inout std_logic_vector(7 downto 0)
    );
    end component;

--COMPONENT axi_uart
--PORT (
--    s_axi_aclk : IN STD_LOGIC;
--    s_axi_aresetn : IN STD_LOGIC;
--    interrupt : OUT STD_LOGIC;
--    s_axi_awaddr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
--    s_axi_awvalid : IN STD_LOGIC;
--    s_axi_awready : OUT STD_LOGIC;
--    s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
--    s_axi_wvalid : IN STD_LOGIC;
--    s_axi_wready : OUT STD_LOGIC;
--    s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
--    s_axi_bvalid : OUT STD_LOGIC;
--    s_axi_bready : IN STD_LOGIC;
--    s_axi_araddr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
--    s_axi_arvalid : IN STD_LOGIC;
--    s_axi_arready : OUT STD_LOGIC;
--    s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
--    s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
--    s_axi_rvalid : OUT STD_LOGIC;
--    s_axi_rready : IN STD_LOGIC;
--    rx : IN STD_LOGIC;
--    tx : OUT STD_LOGIC
--  );
--  END COMPONENT;
  
begin

    clk <= clkin;
    baud_clk_16x <= baud_clk_16x_pre;

    baud_clk_module : baud_clk_gen port map(
        reset           => reset,
        clk             => clk,
        baud_clk        => baud_clk,
        baud_clk_16x    => baud_clk_16x_pre,
        baud_div        => baud_rate_div
    );

    baud_rate_div <= baud_rate_div_h & baud_rate_div_l;

    tx_top_module : tx_top port map(
        reset           => reset,
        baud_clk        => baud_clk_16x,
        rw              => fifo_wr_clk,
        TX              => TX,
        data_in         => write_fifo,
        tx_fifo_full    => status_reg(0),
        tx_fifo_empty   => status_reg(1),
        status_sh_reg   => status_reg(4),
        parity_enable   => config_reg(0),
        parity_odd      => config_reg(2),
        parity_even     => config_reg(1),
        bits            => config_reg(6 downto 3)
    );

    rx_top_module : rx_top port map(
    	reset           => reset,
        baud_clk_16x    => baud_clk_16x,
        oe              => fifo_rd_clk,
        data_out        => read_fifo,
        bits            => config_reg(6 downto 3),
        parity_enable   => config_reg(0),
        parity_even     => config_reg(1),
        rx_fifo_full    => status_reg(2),
        rx_fifo_empty   => status_reg(3),
        framing_error   => status_reg(6),
        parity_error    => status_reg(5),
        RX              => RX
    );


    reg_mod_top : reg_module_comb port map(
        clk             => clk,
        reset           => reset,
        cs              => cs,
        rw              => rw,
        oe              => oe,
        address         => addr,
        data            => data,

        fifo_rd         => fifo_rd_clk,
        fifo_wr         => fifo_wr_clk,
        start_tx        => start_tx,

        baud_rate_div_l => baud_rate_div_l,
        baud_rate_div_h => baud_rate_div_h,
        write_fifo      => write_fifo,
        read_fifo       => read_fifo,
        config_reg      => config_reg,
        status          => status_reg
    );

--slave_axi_uart : axi_uart
--  PORT MAP (
--    interrupt     => open,       
--    s_axi_aclk       => clkin,
--    s_axi_aresetn    => reset,
--    s_axi_awaddr     => m_axi_lite_awaddr (3 downto 0),
--    s_axi_awvalid    => m_axi_lite_awvalid,
--    s_axi_awready    => m_axi_lite_awready,
--    s_axi_wdata      => m_axi_lite_wdata,
--    s_axi_wstrb      => "1111",
--    s_axi_wvalid     => m_axi_lite_wvalid,
--    s_axi_wready     => m_axi_lite_wready,
--    s_axi_bresp      => m_axi_lite_bresp,
--    s_axi_bvalid     => m_axi_lite_bvalid,
--    s_axi_bready     => m_axi_lite_bready,
--    s_axi_araddr     => s_axi_lite_araddr (3 downto 0),
--    s_axi_arvalid    => s_axi_lite_arvalid,
--    s_axi_arready    => s_axi_lite_arready,
--    s_axi_rdata      => s_axi_lite_rdata,
--    s_axi_rresp      => s_axi_lite_rresp,
--    s_axi_rvalid     => s_axi_lite_rvalid,
--    s_axi_rready     => s_axi_lite_rready,
--    rx               => rx,    -- these will go to board 
--    tx               => tx
--    );

  
    status_reg(7) <= '0';

end architecture_top;