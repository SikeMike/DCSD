library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.ALL;

entity lcd_controlANDdrawing_tb is

  -- Entidad vacia

end lcd_controlANDdrawing_tb;

architecture arq_lcd_controlANDdrawing_tb of lcd_controlANDdrawing_tb is

component lcd_control
  port(
    CLK :    in std_logic;
    RESET_L : in std_logic;

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

component lcd_drawing
  port(
    CLK :    in std_logic;
    RESET_L : in std_logic;

    DEL_SCREEN :  in std_logic;
    DRAW_FIG :    in std_logic;
    DONE_CURSOR : in std_logic;
    DONE_COLOUR : in std_logic;
    COLOUR_CODE : in std_logic_vector(2 downto 0);

    XCOL :          out std_logic_vector(7 downto 0);
    YROW :          out std_logic_vector(8 downto 0);
    RGB :           out std_logic_vector(15 downto 0);
    NUM_PIX :       out std_logic_vector(16 downto 0);
    OP_SETCURSOR :  out std_logic;
    OP_DRAWCOLOUR : out std_logic
  );

end component;

--SIGNALS DE LCD_CONTROL
signal tb_CLK : std_logic := '0';
signal tb_RESET_L : std_logic := '0';

signal tb_LCD_Init_Done : std_logic := '0';
signal tb_OP_SETCURSOR : std_logic := '0';
signal tb_OP_DRAWCOLOUR : std_logic := '0';
signal tb_XCOL : std_logic_vector(7 downto 0) := "00000000";
signal tb_YROW : std_logic_vector(8 downto 0) := "000000000";
signal tb_RGB : std_logic_vector(15 downto 0) := "0000000000000000";
signal tb_NUM_PIX : std_logic_vector(16 downto 0) := "00000000000000000";

signal tb_DONE_CURSOR : std_logic := '0';
signal tb_DONE_COLOUR : std_logic := '0';
signal tb_LCD_CS_N : std_logic := '0';
signal tb_LCD_WR_N : std_logic := '0';
signal tb_LCD_RS : std_logic := '0';
signal tb_LCD_DATA : std_logic_vector(15 downto 0) := "0000000000000000";

--SIGNALS DE LCD_DRAWING
--signal tb_CLK : std_logic := '0';
--signal tb_RESET_L : std_logic := '0';

signal tb_DEL_SCREEN : std_logic := '0';
signal tb_DRAW_FIG : std_logic := '0';
--signal tb_DONE_CURSOR : std_logic := '0';
--signal tb_DONE_COLOUR : std_logic := '0';
signal tb_COLOUR_CODE : std_logic_vector(2 downto 0) := "000";

--signal tb_XCOL : std_logic_vector(7 downto 0);
--signal tb_YROW : std_logic_vector(8 downto 0);
--signal tb_RGB : std_logic_vector(15 downto 0);
--signal tb_NUM_PIX : std_logic_vector(16 downto 0);
--signal tb_OP_SETCURSOR : std_logic;
--signal tb_OP_DRAWCOLOUR : std_logic;


begin

  uCont : lcd_control port map (
    CLK => tb_CLK,
    RESET_L => tb_RESET_L,

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

  uDraw : lcd_drawing port map (
    CLK => tb_CLK,
    RESET_L => tb_RESET_L,

    DEL_SCREEN => tb_DEL_SCREEN,
    DRAW_FIG => tb_DRAW_FIG,
    DONE_CURSOR => tb_DONE_CURSOR,
    DONE_COLOUR => tb_DONE_COLOUR,
    COLOUR_CODE => tb_COLOUR_CODE,

    XCOL => tb_XCOL,
    YROW => tb_YROW,
    RGB => tb_RGB,
    NUM_PIX => tb_NUM_PIX,
    OP_SETCURSOR => tb_OP_SETCURSOR,
    OP_DRAWCOLOUR => tb_OP_DRAWCOLOUR
  );

  tb_CLK <= not tb_CLK after 10 ns;

  sim_contANDdraw : process
  begin
    wait for 20 ns;     -- ciclo 1
    tb_RESET_L <= '1';
    wait for 20 ns;
    tb_LCD_Init_Done <= '1';
    wait for 20 ns;
    tb_DRAW_FIG <= '1';
    tb_COLOUR_CODE <= "101";
    wait for 40 ns;
    tb_DRAW_FIG <= '0';
    wait for 4000 ns;
    tb_DEL_SCREEN <= '1';
    wait;
  end process ;

end arq_lcd_controlANDdrawing_tb;
