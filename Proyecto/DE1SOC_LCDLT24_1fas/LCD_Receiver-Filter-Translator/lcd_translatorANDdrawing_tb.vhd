library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.ALL;

entity lcd_translatorANDdrawing_tb is
    --entidad vacia
end lcd_translatorANDdrawing_tb;

architecture arq_lcd_translatorANDdrawing_tb of lcd_translatorANDdrawing_tb is

component lcd_translator

  -- seniales de entrada y salida
  port(
    CLK :     in std_logic;
    RESET_L : in std_logic;

    COMAND_READY :          in std_logic;
    COMAND : in std_logic_vector(7 downto 0);
   
    COLOUR_CODE : out std_logic_vector(2 downto 0);
    DEL_SCREEN :    out std_logic;
    DRAW_FIG : out std_logic;
    DONE :      out std_logic
  );

end component;

component lcd_drawing

  --seniales de entrada y salida
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

--signals de LCD_TRANSLATOR
--declaracion de las seniales de control
signal tb_CLK : std_logic := '0';
signal tb_RESET_L : std_logic := '0';

signal tb_COMAND_READY : std_logic := '0';
signal tb_COMAND : std_logic_vector(7 downto 0) := (others => '0');
--signal tb_COLOUR_CODE: std_logic_vector(7 downto 0) :=(others=> '0');

signal tb_DEL_SCREEN : std_logic;
signal tb_DRAW_FIG : std_logic;
signal tb_DONE : std_logic;

--signals de LCD_DRAWING
--declaracion de las seniales de control

--signal tb_DEL_SCREEN : std_logic := '0';
--signal tb_DRAW_FIG : std_logic := '0';
signal tb_DONE_CURSOR : std_logic := '0';
signal tb_DONE_COLOUR : std_logic := '0';
signal tb_COLOUR_CODE : std_logic_vector(2 downto 0) := "000";

signal tb_XCOL : std_logic_vector(7 downto 0);
signal tb_YROW : std_logic_vector(8 downto 0);
signal tb_RGB : std_logic_vector(15 downto 0);
signal tb_NUM_PIX : std_logic_vector(16 downto 0);
signal tb_OP_SETCURSOR : std_logic;
signal tb_OP_DRAWCOLOUR : std_logic;

begin 
    uTranslator : lcd_translator port map(
        CLK => tb_CLK,
        RESET_L => tb_RESET_L,

        COMAND_READY => tb_COMAND_READY,
        COMAND => tb_COMAND,

        COLOUR_CODE => tb_COLOUR_CODE,

        DEL_SCREEN => tb_DEL_SCREEN,
        DRAW_FIG => tb_DRAW_FIG,
        DONE => tb_DONE

    );

    uDrawing : lcd_drawing port map(
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

    simCambioColor : process
    begin
        wait for 20 ns;
        tb_RESET_L <= '1';
        wait for 60 ns;
        tb_COMAND_READY <= '1';
        tb_COMAND <= "01100100";
        wait for 60 ns;
        tb_COMAND_READY <= '1';
        tb_COMAND <= "01010111";
      
        wait for 60 ns;
        tb_COMAND_READY <= '1';
        tb_COMAND<= "01110011";
        
        wait for 60 ns;
        tb_RESET_L <= '1';
        


    end process;

end arq_lcd_translatorANDdrawing_tb;
