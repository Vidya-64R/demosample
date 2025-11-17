-- reg_lat_8.vhd

library ieee;
use ieee.std_logic_1164.all;
library proasic3l;
use proasic3l.all;

entity REG_LAT_8 is 
    port(
        Data    : in std_logic_vector(7 downto 0);
        Enable  : in std_logic;
        Aclr    : in std_logic_vector(7 downto 0);
        Aset    : in std_logic_vector(7 downto 0);
        Gate    : in std_logic;
        Q       : out std_logic_vector( 7 downto 0)) ;
        
end REG_LAT_8;

architecture DEF_ARCH of  REG_LAT_8 is

component REG_LAT is 
    port(
        Data    : in std_logic;
        Enable  : in std_logic;
        Aclr    : in std_logic;
        Aset    : in std_logic;
        Gate    : in std_logic;
        Q       : out std_logic
        ) ;
end component;

begin

    D0 : REG_LAT port map( 
        Data => Data(0),
        Enable  => Enable,
        Aclr => Aclr(0),
        Aset=> Aset(0),
       Gate    => Gate,
        Q => Q(0)
        ) ;

    D1: REG_LAT port map( 
        Data => Data(1),
        Enable  => Enable,
        Aclr=> Aclr(1),
        Aset=> Aset(1),
        Gate    => Gate,
        Q  => Q(1)
        ) ;

    D2 : REG_LAT port map( 
        Data  => Data(2),
        Enable  => Enable,
        Aclr => Aclr(2),
        Aset  => Aset(2),
        Gate    => Gate,
        Q   => Q(2)
        ) ;

    D3 : REG_LAT port map( 
        Data  => Data(3),
        Enable  => Enable,
        Aclr => Aclr(3),
        Aset => Aset(3),
        Gate    => Gate,
        Q    => Q(3)
        ) ;

    D4 : REG_LAT port map( 
        Data  => Data(4),
        Enable  => Enable,
        Aclr  => Aclr(4),
        Aset    => Aset(4),
        Gate    => Gate,
        Q   => Q(4)
        ) ;

    D5 : REG_LAT port map( 
        Data  => Data(5),
        Enable  => Enable,
        Aclr  => Aclr(5),
        Aset   => Aset(5),
        Gate    => Gate,
        Q    => Q(5)
        ) ;

    D6 : REG_LAT port map( 
        Data => Data(6),
        Enable  => Enable,
        Aclr  => Aclr(6),
        Aset   => Aset(6),
        Gate    => Gate,
        Q   => Q(6)
        ) ;

    D7 : REG_LAT port map( 
        Data  => Data(7),
        Enable  => Enable,
        Aclr => Aclr(7),
        Aset  => Aset(7),
        Gate    => Gate,
        Q  => Q(7)
        ) ;

    
end DEF_ARCH;