library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.ALL;

entity lcd_drawing_tb is

  -- Entidad vacia

end lcd_drawing_tb;

architecture arq_lcd_drawing_tb of lcd_drawing_tb is

component lcd_drawing

  port(
    DEL_SCREEN, DRAW_FIG, DONE_CURSOR, DONE_COLOUR, CLK, RESETL : in std_logic;
    COLOUR_CODE : in std_logic_vector(2 downto 0);

    XCOL :    out std_logic_vector(7 downto 0);
    YROW :    out std_logic_vector(8 downto 0);
    RGB :     out std_logic_vector(15 downto 0);
    NUM_PIX : out std_logic_vector(16 downto 0);

    OP_SETCURSOR, OP_DRAWCOLOUR : out std_logic
  );

end component;

signal tb_DEL_SCREEN : std_logic := '0';
signal tb_DRAW_FIG : std_logic := '0';
signal tb_DONE_CURSOR : std_logic := '0';
signal tb_DONE_COLOUR : std_logic := '0';
signal tb_CLK : std_logic := '0';
signal tb_RESETL : std_logic := '0';
signal tb_COLOUR_CODE : std_logic_vector(2 downto 0) := "000";
signal tb_XCOL : std_logic_vector(7 downto 0);
signal tb_YROW : std_logic_vector(8 downto 0);
signal tb_RGB : std_logic_vector(15 downto 0);
signal tb_NUM_PIX : std_logic_vector(16 downto 0);
signal tb_OP_SETCURSOR : std_logic;
signal tb_OP_DRAWCOLOUR : std_logic;

begin

  instancia2 : lcd_drawing port map (
    DEL_SCREEN => tb_DEL_SCREEN,
    DRAW_FIG => tb_DRAW_FIG,
    DONE_CURSOR => tb_DONE_CURSOR,
    DONE_COLOUR => tb_DONE_COLOUR,
    CLK => tb_CLK,
    RESETL => tb_RESETL,
    COLOUR_CODE => tb_COLOUR_CODE,
    XCOL => tb_XCOL,
    YROW => tb_YROW,
    RGB => tb_RGB,
    NUM_PIX => tb_NUM_PIX,
    OP_SETCURSOR => tb_OP_SETCURSOR,
    OP_DRAWCOLOUR => tb_OP_DRAWCOLOUR
  );

  tb_CLK <= not tb_CLK after 10 ns;

  simulacion : process
  begin
    wait for 20 ns;     -- ciclo 1
    tb_RESETL <= '1';
    wait for 20 ns;
    tb_DEL_SCREEN <= '1';
    wait for 40 ns;
    tb_DEL_SCREEN <= '0';
    tb_DONE_CURSOR <= '1';
    wait for 40 ns;
    tb_DONE_CURSOR <= '0';
    tb_DONE_COLOUR <= '1';
    wait for 40 ns;
    tb_DONE_COLOUR <= '0';
    tb_DRAW_FIG <= '1';
    wait for 40 ns;
    tb_DRAW_FIG <= '0';
    tb_DONE_CURSOR <= '1';
    wait for 40 ns;
    tb_DONE_CURSOR <= '0';
    tb_DONE_COLOUR <= '1';
    wait for 40 ns;
    tb_DONE_CURSOR <= '1';
    wait for 800 ns;
    wait;
  end process ;

end arq_lcd_drawing_tb;
