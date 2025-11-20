--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: shift_reg.vhd
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

entity shift_reg_tx is
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
end shift_reg_tx;

architecture architecture_shift_reg of shift_reg_tx is
    type state is (idle, start_bit, tx_state, stop);
    signal state_m : state;
	signal data_latch : std_logic_vector(7 downto 0) ;
    signal count : std_logic_vector(3 downto 0);
    signal data_avail : std_logic;
    signal wr_d : std_logic;
    signal baud_pulse : std_logic;
    signal parity_bit : std_logic;
    signal baud_pulse_cnt : std_logic_vector(3 downto 0);
begin

    process(baud_clk_16x, reset)
    begin
        if(reset = '0') then
            baud_pulse_cnt <= "0000";
            baud_pulse <= '0';
        elsif(baud_clk_16x'event and baud_clk_16x = '1') then
            if(status = '1') then
                baud_pulse_cnt <= baud_pulse_cnt + 1;
                baud_pulse <= '0';
                if(baud_pulse_cnt = x"F") then
                    baud_pulse <= '1';
                end if;
            else
                baud_pulse <= '0';
                baud_pulse_cnt <= (others => '0');
            end if;
        end if;
    end process;

    process(reset, baud_clk_16x)
    begin
        if ( reset = '0') then
            wr_d <= '1';
        elsif ( baud_clk_16x'event and baud_clk_16x = '1') then
            wr_d <= wr;
        end if;
    end process;

    data_avail <= wr and not(wr_d);

    process(reset, baud_clk_16x, state_m)
    begin
        if ( reset = '0') then
            state_m <= idle;
            TX <= '1';
            status <= '0';
            data_latch <= (others => '0');
            count <= (others => '0');
            parity_bit <= '0';
        elsif ( baud_clk_16x'event and baud_clk_16x = '1') then

            case state_m is

                when idle =>

                    count <= (others => '0');
                    status <= '0';
                    TX <= '1';
                    if (data_avail = '1') then
                        status <= '1';
                        state_m <= start_bit;
                        data_latch <= data;
                        parity_bit <= data(7) xor data(6) xor data(5) xor data(4) xor data(3) xor data(2) xor data(1) xor data(0);
                    else
                        state_m <= idle;
                        data_latch <= (others => '0');
                    end if;

                when start_bit =>
                    TX <= '1';
                    if(baud_pulse = '1') then
                        state_m <= tx_state;
                        TX <= '0';
                    else
                        state_m <= start_bit;
                        
                    end if;

                when tx_state =>

                    if ( baud_pulse = '1' ) then
                        if(count < bits) then
                            data_latch(6 downto 0) <= data_latch(7 downto 1);
                            count <= count + 1;
                            TX <= data_latch(0);
                            state_m <= tx_state;
                        else
                            if(parity_enable = '0') then
                                status <= '0';
                                TX <= '1';
                                state_m <= idle;
                            else
                                if ( parity_even = '1') then
                                    TX <= parity_bit;
                                else
                                    TX <= not(parity_bit);
                                end if;
                                state_m <= stop;
                            end if;
                        end if;
                    end if;

                when stop =>
                    if ( baud_pulse = '1' ) then
                        status <= '0';
                        TX <= '1';
                        state_m <= idle;
                    end if;
            end case;
        end if;
    end process;
   
end architecture_shift_reg;
