library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bb is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           parallel_in1, parallel_in2 : in STD_LOGIC_VECTOR(7 downto 0);
           serial_out1, serial_out2 : out STD_LOGIC);
end bb;

architecture Behavioral of bb is
    signal counter1, counter2 : integer range 0 to 7 := 0;
    signal serial_internal1, serial_internal2 : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter1 <= 0;
            serial_internal1 <= (others => '0');
        elsif rising_edge(clk) then
            if counter1 = 7 then
                counter1 <= 0;
                serial_internal1<= parallel_in1;
            else
                counter1 <= counter1 + 1;
                serial_internal1 <= serial_internal1(6 downto 0) & '0';
            end if;
        end if;
    end process;

    serial_out1 <= serial_internal1(7);
    
    process(clk, reset)
    begin
        if reset = '1' then
            counter2 <= 0;
            serial_internal2 <= (others => '0');
        elsif falling_edge(clk) then
            if counter2 = 7 then
                counter2 <= 0;
                serial_internal2 <= parallel_in2;
            else
                counter2 <= counter2 + 1;
                serial_internal2 <= serial_internal2(6 downto 0) & '0';
            end if;
        end if;
    end process;

    serial_out <= serial_internal(7);
end Behavioral;
