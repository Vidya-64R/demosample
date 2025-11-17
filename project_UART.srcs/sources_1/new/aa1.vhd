library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aa1 is
    Port ( clk : in STD_LOGIC;
           out_signal : out STD_LOGIC);
end aa1;

architecture Behavioral of aa1 is
    signal prev_clk : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            out_signal <= '1';
            prev_clk <= '1';
        elsif falling_edge(clk) then
            out_signal <= '0';
            prev_clk <= '0';
        else
            out_signal <= prev_clk;
        end if;
    end process;
end Behavioral;
