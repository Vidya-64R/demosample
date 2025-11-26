----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2023 05:07:33 PM
-- Design Name: vidya
-- Module Name: testbench_txrx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench_txrx is
--  Port ( );
end testbench_txrx;

architecture Behavioral of testbench_txrx is
component top is
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
end component;

	signal clkin   :std_logic:='0';
    signal reset   : std_logic;
    signal rw      :std_logic;
    signal oe : std_logic;
    signal CS   :std_logic;
    signal data : std_logic_vector(7 downto 0);
    signal TX  :  std_logic;
    signal RX  :std_logic;
    signal addr :std_logic_vector(2 downto 0);

begin
tb_tx_rx: top port map(
	clkin=>clkin,  
    reset=>reset,
    rw=>rw,
    oe=>oe,
    CS=>cs,
    data=>data,   
    TX=>tx,
    RX=>rx,
    addr=>addr);
    
    clk_uut:process
    begin
    clkin<= not clkin after 100 ns;
    end process clk_uut;
    
    rst_uut:process
    begin
    reset<='1' and '0' after 100 ns;
    end process rst_uut;
    
    top_uut:process
    begin
    rw<='0';oe<='0'; CS<='0'; RX<='0'; addr<="001"; 
    wait for 100 ps;
    
    rw<='1';oe<='1'; CS<='1'; RX<='1'; addr<="010"; 
    wait for 100 ps;
    
    rw<='0';oe<='0'; CS<='0'; RX<='0'; addr<="011"; 
    wait for 100 ps;
    
    rw<='1';oe<='0'; CS<='0'; RX<='0'; addr<="100"; 
    wait for 100 ps;
    
    rw<='0';oe<='0'; CS<='0'; RX<='0'; addr<="101"; 
    wait for 100 ps;
    
    rw<='0';oe<='0'; CS<='0'; RX<='0'; addr<="110"; 
    wait for 100 ps;
    
    end process top_uut;
    
end Behavioral;
