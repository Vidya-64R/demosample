--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FIFO_ENC.vhd
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

entity FIFO_ENC is
port (
                DATA   : in    std_logic_vector(9 downto 0);
                Q      : out   std_logic_vector(9 downto 0);
                WE     : in    std_logic;
                RE     : in    std_logic;
                WCLOCK : in    std_logic;
                RCLOCK : in    std_logic;
                FULL   : out   std_logic;
                EMPTY  : out   std_logic;
                RESET  : in    std_logic
);
end FIFO_ENC;

architecture architecture_FIFO_ENC of FIFO_ENC is
   -- signal, component etc. declarations

    component RX_FIFO_1 is
        port( DATA   : in    std_logic_vector(9 downto 0);
              Q      : out   std_logic_vector(9 downto 0);
              WE     : in    std_logic;
              RE     : in    std_logic;
              WCLOCK : in    std_logic;
              RCLOCK : in    std_logic;
              FULL   : out   std_logic;
              EMPTY  : out   std_logic;
              RESET  : in    std_logic
            );
    end component;

begin
    TX_FIFO_M : RX_FIFO_1 port map(
                DATA    => DATA,
                Q       => Q,
                WE      => WE,
                RE      => RE,
                WCLOCK  => WCLOCK,
                RCLOCK  => RCLOCK,
                FULL    => FULL,
                EMPTY   => EMPTY,
                RESET   => RESET
    );
end architecture_FIFO_ENC;
