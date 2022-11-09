library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.ALL;

entity lcd_control_tb is

  -- Entidad vacia

end lcd_control_tb;

architecture arq_lcd_control_tb of lcd_control_tb is

component lcd_control

  -- seniales de entrada y salida
  port(
    CLK :    in std_logic;
    RESETL : in std_logic;

    LCD_Init_Done : in std_logic;
    OP_SETCURSOR :  in std_logic;
    OP_DRAWCOLOUR : in std_logic;
    XCOL :          in std_logic_vector(7 downto 0);
    YROW :          in std_logic_vector(8 downto 0);
    RGB :           in std_logic_vector(15 downto 0);
    NUM_PIX :       in std_logic_vector(16 downto 0);

    DONE_CURSOR : out std_logic;
    DONE_COLOUR : out std_logic;
    LCD_CS_N :    out std_logic;
    LCD_WR_N :    out std_logic;
    LCD_RS :      out std_logic;
    LCD_DATA :    out std_logic_vector(15 downto 0)
  );

end component;

-- declaracion de las seniales de control
signal tb_CLK : std_logic := '0';
signal tb_RESETL : std_logic := '0';

signal tb_LCD_Init_Done : std_logic := '0';
signal tb_OP_SETCURSOR : std_logic := '0';
signal tb_OP_DRAWCOLOUR : std_logic := '0';
signal tb_XCOL : std_logic_vector(7 downto 0) := "00000000";
signal tb_YROW : std_logic_vector(8 downto 0) := "000000000";
signal tb_RGB : std_logic_vector(15 downto 0) := "0000000000000000";
signal tb_NUM_PIX : std_logic_vector(16 downto 0) := "00000000000000000";

signal tb_DONE_CURSOR : std_logic;
signal tb_DONE_COLOUR : std_logic;
signal tb_LCD_CS_N : std_logic;
signal tb_LCD_WR_N : std_logic;
signal tb_LCD_RS : std_logic;
signal tb_LCD_DATA : std_logic_vector(15 downto 0);


begin

  uControl : lcd_control port map (
    CLK => tb_CLK,
    RESETL => tb_RESETL,

    LCD_Init_Done => tb_LCD_Init_Done,
    OP_SETCURSOR => tb_OP_SETCURSOR,
    OP_DRAWCOLOUR => tb_OP_DRAWCOLOUR,
    XCOL => tb_XCOL,
    YROW => tb_YROW,
    RGB => tb_RGB,
    NUM_PIX => tb_NUM_PIX,

    DONE_CURSOR => tb_DONE_CURSOR,
    DONE_COLOUR => tb_DONE_COLOUR,
    LCD_CS_N => tb_LCD_CS_N,
    LCD_WR_N => tb_LCD_WR_N,
    LCD_RS => tb_LCD_RS,
    LCD_DATA => tb_LCD_DATA
  );

  tb_CLK <= not tb_CLK after 10 ns;

  simulacion : process
  begin
    wait for 20 ns;     -- ciclo 1
    tb_RESETL <= '1';
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
    wait for 600 ns;
    wait;
  end process ;

end arq_lcd_control_tb;
