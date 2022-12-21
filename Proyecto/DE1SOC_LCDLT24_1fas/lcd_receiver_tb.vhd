library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.ALL;

entity lcd_receiver_tb is

  -- Entidad vacia

end lcd_receiver_tb;

architecture arq_lcd_receiver_tb of lcd_receiver_tb is

component lcd_receiver

  -- seniales de entrada y salida
  port(
    CLK :    in std_logic;
    RESET_L : in std_logic;

    DATA : in std_logic;
    BITREAD : in std_logic;
    DATA_BIT : in std_logic;
    DONE : in std_logic;

    READBIT : out std_logic;
    DATARECEIVED : out std_logic;
    COMANDO : out std_logic_vector(7 downto 0)
  );

end component;

-- declaracion de las seniales de control
signal tb_CLK : std_logic := '0';
signal tb_RESET_L : std_logic := '0';

signal tb_DATA : std_logic := '1';
signal tb_BITREAD : std_logic := '0';
signal tb_DATA_BIT : std_logic := '0';
signal tb_DONE : std_logic := '0';

signal tb_READBIT : std_logic;
signal tb_DATARECEIVED : std_logic;
signal tb_COMANDO : std_logic_vector(7 downto 0);

begin

  uReceiver : lcd_receiver port map (

    CLK => tb_CLK,
    RESET_L => tb_RESET_L,

    DATA => tb_DATA,
    BITREAD => tb_BITREAD,
    DATA_BIT => tb_DATA_BIT,
    DONE => tb_DONE,

    READBIT => tb_READBIT,
    DATARECEIVED => tb_DATARECEIVED,
    COMANDO => tb_COMANDO

  );

  tb_CLK <= not tb_CLK after 10 ns;

  simulacion : process
  begin
    wait for 20 ns;     -- E0 -> E1 (desactivo reset_l)
    tb_RESET_L <= '1';
    wait for 40 ns;     -- E1 -> E2 Cambio en DATA
    tb_DATA <= '0';
    wait for 40 ns;     -- E2 -> E3 Bitread se activa y guardo DATA_BIT en StartBit
    tb_BITREAD <= '1';
    tb_DATA_BIT <= '0';
    wait for 200 ns;
    wait;
  end process ;

end arq_lcd_receiver_tb;
