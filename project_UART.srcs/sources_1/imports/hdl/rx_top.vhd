-- rx_top.vhd

library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity rx_top is
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
end rx_top;

architecture architecture_rx_top of rx_top is

    component RX_FIFO_1 is 
    port( 
        DATA    : in std_logic_vector(9 downto 0);
        Q       : out std_logic_vector(9 downto 0);
        WE      : in std_logic;
        RE      : in std_logic;
        WCLOCK  : in std_logic;
        RCLOCK  : in std_logic;
        FULL    : out std_logic;
        EMPTY   : out std_logic;
        RESET   : in std_logic
    ) ;
    end component;

    component shift_reg_rd is
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
    end component;

    signal fifo_data_in : std_logic_vector (9 downto 0);
    signal rx_reg_data_out : std_logic_vector (7 downto 0);
    signal fifo_data_out : std_logic_vector (9 downto 0);
    signal wr_fifo, framing_error_s, parity_error_s : std_logic;

begin

    rx_fifo_in : RX_FIFO_1 port map( 
        DATA    => fifo_data_in,
        Q       => fifo_data_out,
        WE      => '1',
        RE      => '1',
        WCLOCK  => wr_fifo,
        RCLOCK  => oe,
        FULL    => rx_fifo_full,
        EMPTY   => rx_fifo_empty,
        RESET   => reset
    ) ;

    rx_sh_reg : shift_reg_rd port map(
    	baud_clk_16x    => baud_clk_16x,
        reset           => reset,
        parity_enable   => parity_enable,
        parity_even     => parity_even,
        data            => rx_reg_data_out,
        bits            => bits,
        framing_error   => framing_error_s,
        parity_error    => parity_error_s,
        RX              => RX,
        wr_fifo         => wr_fifo
    );

    fifo_data_in <= framing_error_s & parity_error_s & rx_reg_data_out;
    data_out <= fifo_data_out(7 downto 0);
    framing_error <= fifo_data_out(9);
    parity_error <= fifo_data_out(8);

end architecture_rx_top;