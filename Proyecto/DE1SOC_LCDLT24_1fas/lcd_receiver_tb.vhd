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
    COMMAND : out std_logic_vector(7 downto 0)
  );

end component;

-- declaracion de las seniales de control
signal tb_CLK : std_logic := 0;
signal tb_RESET_L : std_logic := 0;

signal tb_DATA : std_logic := 0;
signal tb_BITREAD : std_logic := 0;
signal tb_DATA_BIT : std_logic := 0;
signal tb_DONE : std_logic := 0;

signal tb_READBIT : std_logic;
signal tb_DATARECEIVED : std_logic;
signal tb_COMMAND : std_logic_vector(7 downto 0);

begin

  uReceiver : lcd_receiver port map (

    CLK => tb_CLK
    RESET_L => tb_RESET_L

    DATA => tb_DATA
    BITREAD => tb_BITREAD
    DATA_BIT => tb_DATA_BIT
    DONE => tb_DONE

    READBIT => tb_READBIT
    DATARECEIVED => tb_DATARECEIVED
    COMMAND => tb_COMMAND

  );

  tb_CLK <= not tb_CLK after 10 ns;

  simulacion : process
  begin
    wait for 20 ns;     -- ciclo 1
    tb_RESET_L <= '1';
    tb_LCD_Init_Done <= '1';
    wait for 20 ns;
    tb_OP_SETCURSOR <= '1';
    tb_XCOL <= conv_std_logic_vector(14, 8);
    tb_YROW <= conv_std_logic_vector(23, 9);
    tb_RGB <= "0000000000000000";
    wait for 20 ns;
    tb_OP_SETCURSOR <= '0';
    wait for 380 ns;
    tb_OP_DRAWCOLOUR <= '1';
    tb_XCOL <= conv_std_logic_vector(6, 8);
    tb_YROW <= conv_std_logic_vector(78, 9);
    tb_RGB <= x"001F";
    tb_NUM_PIX <= "00000000000000011";
    wait for 60 ns;     -- ciclo 15
    tb_OP_DRAWCOLOUR <= '0';
    wait;
  end process ;

end arq_lcd_receiver_tb;
