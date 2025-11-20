--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: reg_module_comb.vhd
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

entity reg_module_comb is
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
    status          : in std_logic_vector(7 downto 0)
);
end reg_module_comb;


architecture architecture_reg_module_comb of reg_module_comb is
	signal config_reg_lat, baud_rate_div_l_lat, baud_rate_div_h_lat : std_logic_vector(7 downto 0);
    signal config_reg_wr : std_logic;
    signal baud_rate_div_l_wr : std_logic;
    signal baud_rate_div_h_wr, fifo_wr_n, fifo_wr_i : std_logic;
	signal data_in, data_out, fifo_reset : std_logic_vector(7 downto 0) ;
    signal config_set, config_reset, baud_rate_div_l_reset, baud_rate_div_l_set, baud_rate_div_h_reset, baud_rate_div_h_set : std_logic_vector(7 downto 0);

    component REG_LAT_8 is 
        port(
            Data    : in std_logic_vector(7 downto 0);
            Enable  : in std_logic;
            Aclr    : in std_logic_vector(7 downto 0);
            Aset    : in std_logic_vector(7 downto 0);
            Gate    : in std_logic;
            Q       : out std_logic_vector( 7 downto 0)
            ) ;
    end component;


begin

    data <= data_out when (cs = '0' and oe = '0') else "ZZZZZZZZ";
    data_in <= data when (cs = '0' and rw = '0') else data_in;

--CONFIGURATION REGISTER CONTROL (0x05)
    config_reg_wr <= '1' when (cs = '0' and address = "101" and rw = '0') else '0';
    data_out <= config_reg when (cs = '0' and address = "101" and oe = '0') else "ZZZZZZZZ";
    config_reg_m : REG_LAT_8 port map( 
        Data    => data_in,
        Enable  => (config_reg_wr),
        Aclr    => config_reset,
        Aset    => config_set,
        Gate    => '1',
        Q       => config_reg
        );

    config_reset <= "01000000" when reset = '0' else "11111111";
    config_set   <= "01000000" when reset = '0' else "00000000";


--WRITE FIFO CONTROL (0x03)
    fifo_wr_i <= '0' when (cs = '0' and address = "011" and rw = '0') else '1';
    fifo_wr_n <= '1' when (cs = '0' and address = "011") else '0';
    fifo_wr <= fifo_wr_i;
    fifo_reset <= "00000000" when reset = '0' else "11111111";

    wr_fifo_r : REG_LAT_8 port map( 
        Data    => data_in,
        Enable  => fifo_wr_n,
        Aclr    => fifo_reset,
        Aset    => "00000000",
        Gate    => '1',
        Q       => write_fifo
        );

--READ FIFO CONTROL (0x04)
    fifo_rd <= '1' when (cs = '0' and address = "100" and oe = '0') else '0';
    data_out <= read_fifo when (cs = '0' and address = "100" and oe = '0') else "ZZZZZZZZ";

--BAUD RATE LOW REGISTER CONTROL (0x02)
    baud_rate_div_l_wr <= '1' when (cs = '0' and address = "010" and rw = '0') else '0';
    data_out <= baud_rate_div_l_lat when (cs = '0' and address = "010" and oe = '0') else "ZZZZZZZZ";

    baud_rate_div_l_m : REG_LAT_8 port map( 
    Data    => data_in,
    Enable  => (baud_rate_div_l_wr),
    Aclr    => baud_rate_div_l_reset,
    Aset    => baud_rate_div_l_set,
    Gate    => '1',
    Q       => baud_rate_div_l_lat
    );

    baud_rate_div_l <= baud_rate_div_l_lat;
    baud_rate_div_l_reset <= "00100000" when reset = '0' else "11111111";
    baud_rate_div_l_set   <= "00100000" when reset = '0' else "00000000";

--BAUD RATE HIGH REGISTER (0x01)
    baud_rate_div_h_wr <= '1' when (cs = '0' and address = "001" and rw = '0') else '0';
    data_out <= baud_rate_div_h_lat when (cs = '0' and address = "001" and oe = '0') else "ZZZZZZZZ";
    
    baud_rate_div_h_m : REG_LAT_8 port map( 
    Data    => data_in,
    Enable  => (baud_rate_div_h_wr),
    Aclr    => baud_rate_div_h_reset,
    Aset    => baud_rate_div_h_set,
    Gate    => '1',
    Q       => baud_rate_div_h_lat
    );

    baud_rate_div_h_reset <= "00000000" when reset = '0' else "11111111";
    baud_rate_div_h_set   <= "00000000" when reset = '0' else "00000000";
    baud_rate_div_h <= baud_rate_div_h_lat;

--STATUS REGISTER READ (0x06)
    data_out <= status when (cs = '0' and address = "110" and oe = '0') else "ZZZZZZZZ";

end architecture_reg_module_comb;
