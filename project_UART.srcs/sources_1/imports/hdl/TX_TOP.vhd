--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: TX_TOP.vhd
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

entity tx_top is
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
end tx_top;

architecture architecture_tx_top of tx_top is

    type state_main is (idle, wait_sts, check_empty, dummy, dummy2, tx_status);
    signal state_main_tx : state_main;
    signal sh_reg_status, sh_reg_wr : std_logic;
    signal fifo_read_tx , fifo_full_tx, fifo_empty_tx : std_logic;
    signal empty_stat_cnt : std_logic_vector(2 downto 0);
    signal data_o : std_logic_vector ( 7 downto 0);

    component shift_reg_tx is
        port (
            baud_clk_16x    : IN  std_logic;
            reset           : IN std_logic;
            parity_enable   : IN std_logic;
            parity_odd      : in std_logic;
            parity_even     : in std_logic;
            data            : IN std_logic_vector (7 downto 0);
            bits            : in std_logic_vector ( 3 downto 0);
            TX              : OUT std_logic;
            status          : INOUT std_logic;
            wr              : IN std_logic
        );
    end component;

    component TX_FIFO_1 is
        port( DATA   : in    std_logic_vector(7 downto 0);
              Q      : out   std_logic_vector(7 downto 0);
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

    sh_reg_tx1 : shift_reg_tx port map(
        baud_clk_16x    => baud_clk,
        reset           => reset,
        parity_enable   => parity_enable,
        parity_odd      => parity_odd,
        parity_even     => parity_even,
        data            => data_o,
        bits            => bits,
        TX              => TX,
        status          => sh_reg_status,
        wr              => sh_reg_wr
    );

    RX_FIFO_M : TX_FIFO_1 port map(
        DATA => data_in,
        Q => data_o,
        WE => '1',
        RE => fifo_read_tx,
        WCLOCK => rw,
        RCLOCK => baud_clk,
        FULL => fifo_full_tx,
        EMPTY => fifo_empty_tx,
        RESET => reset
    );

    TX_FIFO_FULL <= fifo_full_tx;
    TX_FIFO_EMPTY <= fifo_empty_tx;
    status_sh_reg <= sh_reg_status;

    process(baud_clk, reset)
    begin
        if (reset = '0') then
            state_main_tx <= idle;
            fifo_read_tx <= '0';
            sh_reg_wr <= '1';
            empty_stat_cnt <= (others => '0');
        elsif (baud_clk'event and baud_clk = '1') then
            case state_main_tx is

            when idle =>

                if ( fifo_empty_tx = '0' and sh_reg_status = '0') then
                    fifo_read_tx <= '1';
                    sh_reg_wr <= '0';
                    state_main_tx <= wait_sts;
                else
                    fifo_read_tx <= '0';
                    sh_reg_wr <= '1';
                    state_main_tx <= idle;
                end if;

            when wait_sts =>

                if(empty_stat_cnt > x"2") then
                    state_main_tx <= tx_status;
                else
                    fifo_read_tx <= '0';
                    sh_reg_wr <= '1';
                    state_main_tx <= wait_sts;
                    empty_stat_cnt <= empty_stat_cnt + 1;
                end if;

            when check_empty => 

                if ( fifo_empty_tx = '0') then
                    fifo_read_tx <= '0';
                    sh_reg_wr <= '1';
                    state_main_tx <= dummy;
                else
                    state_main_tx <= idle;
                end if;

            when dummy =>
                fifo_read_tx <= '0';
                sh_reg_wr <= '1';
                state_main_tx <= dummy2;

            when dummy2 =>
                state_main_tx <= tx_status;

            when tx_status => 

                if ( sh_reg_status = '1') then
                    fifo_read_tx <= '0';
                    sh_reg_wr <= '1';
                    state_main_tx <= tx_status;
                else
                    if ( fifo_empty_tx = '0') then
                        fifo_read_tx <= '1';
                        sh_reg_wr <= '0';
                        state_main_tx <= dummy;
                    end if;
                end if;

            end case;
        end if;
    end process;
    
end architecture_TX_TOP;
