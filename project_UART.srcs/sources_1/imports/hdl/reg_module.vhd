--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: reg_module.vhd
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

entity reg_module is
port (
    clk             : in std_logic;
    reset           : in std_logic;
    cs              : in std_logic;
	rw              : IN  std_logic;
    address         : in std_logic_vector(2 downto 0);
    data            : inout std_logic_vector(7 downto 0);

    fifo_rd         : out std_logic;
    fifo_wr         : out std_logic;
    baud_rate_div_l : inout std_logic_vector(7 downto 0);
    baud_rate_div_h : inout std_logic_vector(7 downto 0);
    write_fifo      : inout std_logic_vector(7 downto 0);
    read_fifo       : in std_logic_vector(7 downto 0);
    config_reg      : inout std_logic_vector(7 downto 0);
    status          : inout std_logic_vector(7 downto 0)
);
end reg_module;

architecture architecture_reg_module of reg_module is

    type state is (idle, rws, cs1);
    signal statem : state;
	signal fifo_wr_d1, fifo_wr_d2 : std_logic;

begin

    process (clk, reset)
    begin
        if(reset = '0') then
            baud_rate_div_h <= x"00";
            baud_rate_div_l <= x"20";
            write_fifo <= x"00";
            config_reg <= x"40";
            status <= x"00";
            data <= "ZZZZZZZZ";
            fifo_wr <= '0';
            statem <= idle;
       elsif(clk'event and clk = '1') then
            case statem is
                when idle =>
                    data <= "ZZZZZZZZ";
                    if ( cs = '0') then
                        statem <= rws;
                    else
                        statem <= idle;
                    end if;

                when rws =>
                    if (rw = '0' ) then
                        case address is
                            when "001" =>
                                baud_rate_div_l <= data;
                            when "010" =>
                                baud_rate_div_h <= data;
                            when "011" =>
                                write_fifo <= data;
                                fifo_wr <= '1';
                            when "101" =>
                                config_reg <= data;
                        end case;
                    else
                        case address is
                            when "001" =>
                                data <= baud_rate_div_l;
                            when "010" =>
                                data <= baud_rate_div_h;
                            when "011" =>
                                data <= write_fifo;
                            when "101" =>
                                data <= config_reg;
                        end case;
                    end if;
                    statem <= cs1;

                when cs1 =>
                    fifo_wr <= '0';
                    if (cs = '1') then
                        statem <= idle;
                    else
                        statem <= cs1;
                    end if;
            end case;
        end if;
    end process;

--    fifo_wr <= fifo_wr_d2 and not(fifo_wr_d1);
   
end architecture_reg_module;
