--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Baud_Clk_Gen.vhd
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

entity Baud_Clk_Gen is
port (
	reset           : in  std_logic;
    clk             : in std_logic;
    baud_clk        : out std_logic;
    baud_clk_16x    : out std_logic;
    baud_div        : in std_logic_vector(15 downto 0)
);
end Baud_Clk_Gen;

architecture architecture_Baud_Clk_Gen of Baud_Clk_Gen is

	signal signal_name1 : std_logic;
	signal count : std_logic_vector (15 downto 0) ;
    signal count_16x : std_logic_vector (11 downto 0);

begin

    process ( clk, reset )
    begin
        if (reset = '0') then
            count <= (others => '0');
            baud_clk <= '0';
        elsif ( clk'event and clk = '1') then
            count <= count + 1;
                baud_clk <= '0';
                if ( count = baud_div - 1 ) then
                    count <= (others => '0');
                    baud_clk <= '1';
                else
                    baud_clk <= '0';
                end if;
        end if;
    end process;

    process ( clk, reset )
    begin
        if ( reset = '0') then
            baud_clk_16x <= '0';
            count_16x <= (others => '0');
        elsif (clk'event and clk = '1') then
            count_16x <= count_16x + 1;
            if( count_16x = baud_div ( 15 downto 4) - 1) then
                count_16x <= (others => '0');
                baud_clk_16x <= '1';
            else
                baud_clk_16x <= '0';
            end if;
        end if;
    end process;
   
end architecture_Baud_Clk_Gen;
