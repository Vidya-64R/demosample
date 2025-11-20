-- shift_reg_rd.vhd

library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity shift_reg_rd is
port (
	baud_clk_16x    : IN  std_logic;
    reset           : IN std_logic;
    parity_enable   : IN std_logic;
    parity_even     : in std_logic;
    data            : out std_logic_vector (7 downto 0);
    bits            : in std_logic_vector ( 3 downto 0);
    framing_error   : out std_logic;
    parity_error    : out std_logic;
    RX              : in std_logic;
    wr_fifo         : out std_logic
);
end shift_reg_rd;

architecture architecture_shift_reg_rd of shift_reg_rd is

    type state is (idle, rx_state,parity_state, stop, wait_state);
    signal state_m : state;
	signal data_latch, rx_reg : std_logic_vector(7 downto 0) ;
    signal count, start_sample_count : std_logic_vector(3 downto 0);
    signal baud_cnt : std_logic_vector ( 4 downto 0);
    signal baud_pulse, start_baud_clock : std_logic;
    signal parity_bit_rx, parity_bit_calc, stop_bit, fifo_wr_pulse, reg_en : std_logic;
    signal baud_pulse_cnt, wait_cnt : std_logic_vector(3 downto 0);

begin

    process(reset, start_baud_clock, baud_clk_16x)
    begin
        if (reset = '0') then
            baud_pulse <= '0';
            baud_cnt <= (others => '0');
        elsif ( baud_clk_16x'event and baud_clk_16x = '1') then
            if(start_baud_clock = '1') then
                baud_cnt <= baud_cnt + 1;
                if(baud_cnt = "01111") then
                    baud_pulse <= '1';
                    baud_cnt <= (others => '0');
                else
                    baud_pulse <= '0';
                end if;
            else
                baud_cnt <= "00000";
                baud_pulse <= '0';
            end if;
        end if;
    end process;

    process(reset, baud_clk_16x)
    begin
        if(reset = '0') then

            state_m <= idle;
            rx_reg <= (others => '0');
            start_sample_count <= (others => '0');
            start_baud_clock <= '0';
            count <= (others => '0');
            stop_bit <= '0';
            parity_error <= '0';
            framing_error <= '0';
            wait_cnt <= (others => '0');
            fifo_wr_pulse <= '0';
            reg_en <= '0';
            parity_bit_calc <= '0';
            parity_bit_rx <= '0';

        elsif (baud_clk_16x'event and baud_clk_16x = '1') then

            case state_m is

                when idle =>
                    fifo_wr_pulse <= '0';
                    framing_error <= '0';
                    parity_error <= '0';
                    rx_reg <= (others => '0');
                    if (RX = '0') then
                        start_sample_count <= start_sample_count + 1;
                        if (start_sample_count = x"8") then
                            start_sample_count <= (others => '0');
                            state_m <= rx_state;
                            start_baud_clock <= '1';
                        else
                            state_m <= idle;
                        end if;
                    else
                        state_m <= idle;
                    end if;

                when rx_state =>

                    if(baud_pulse = '1') then
                        count <= count + 1;
                        if(count = bits - 1) then
                            count <= (others => '0');
                            if ( parity_enable = '0') then
                                state_m <= stop;
                            else
                                state_m <= parity_state;
                            end if;
                        end if;
                        rx_reg(7) <= RX;
                        rx_reg(6 downto 0) <= rx_reg(7 downto 1);
                    else
                        state_m <= rx_state;
                    end if;

                when parity_state =>
                    
                    if(baud_pulse = '1') then
                        parity_bit_rx <= RX;
                        parity_bit_calc <= rx_reg(0) xor rx_reg(1) xor rx_reg(2) xor rx_reg(3) xor rx_reg(4) xor rx_reg(5) xor rx_reg(6) xor rx_reg(7);
                        if ( parity_even = '1') then
                            if (parity_bit_calc = not(parity_bit_rx)) then
                                parity_error <= '1';
                            end if;
                        else
                            if (parity_bit_calc = (parity_bit_rx)) then
                                parity_error <= '1';
                            end if;
                        end if;
                        state_m <= stop;
                    end if;

                when stop =>

                    if ( baud_pulse = '1') then

                        if ( Rx = '0') then
                            framing_error <= '1';
                        end if;
                        start_baud_clock <= '0';
                        state_m <= wait_state;
                    end if;
                    
                when wait_state =>
                    fifo_wr_pulse <= '1';
                    wait_cnt <= wait_cnt + 1;
                    if (wait_cnt = "0101") then
                        wait_cnt <= "0000";
                        state_m <= idle;
                    else
                        state_m <= wait_state;
                    end if;

            end case;
        end if;
    end process;

    data <= rx_reg;
    wr_fifo <= fifo_wr_pulse;

end architecture_shift_reg_rd;