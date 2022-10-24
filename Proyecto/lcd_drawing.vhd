library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_drawing is

  -- señales de entrada y salida
  port(
    DEL_SCREEN, DRAW_FIG, DONE_CURSOR, DONE_COLOUR, CLK, RESETL : in std_logic;
    COLOUR_CODE : in std_logic_vector(2 downto 0);

    XCOL :    out std_logic_vector(7 downto 0);
    YROW :    out std_logic_vector(8 downto 0);
    RGB :     out std_logic_vector(15 downto 0);
    NUM_PIX : out std_logic_vector(16 downto 0);

    OP_SETCURSOR, OP_DRAWCOLOUR : out std_logic
  );

end lcd_drawing;

architecture arc_de_lcd_drawing of lcd_drawing is

--declaracion de las señales
signal EP, ES : integer range 0 to 4;
signal LD_Square, Next_Row, END_Square, SEL_M, SEL_PIX, WHITE : std_logic;
signal Q_Square : unsigned(8 downto 0);
signal Colour : std_logic_vector(15 downto 0); 

begin

  --calculo del estado siguiente (combinacional)
  COMB : process(EP, DEL_SCREEN, DRAW_FIG, DONE_CURSOR, DONE_COLOUR, END_Square)
  begin
    case EP is
      when 0 =>
        if (DEL_SCREEN = '1') then
          ES <= 1;
        elsif (DEL_SCREEN = '0' and DRAW_FIG = '1') then
          ES <= 3;
        else
          ES <= 0;
        end if;
      when 1 =>
        if (DONE_CURSOR = '1') then
          ES <= 2;
        else
          ES <= 1;
        end if;
      when 2 =>
        if (DONE_COLOUR = '1') then
          ES <= 0;
        else
          ES <= 2;
        end if;
      when 3 =>
        if (DONE_CURSOR = '1') then
          ES <= 4;
        else
          ES <= 3;
        end if;
      when 4 =>
        if (DONE_COLOUR = '1' and END_Square = '1') then
          ES <= 0;
        elsif (DONE_COLOUR = '1' and END_Square = '0') then
          ES <= 3;
        else
          ES <= 4;
        end if;
    end case;
  end process COMB;

  --calculo del estado siguiente(secuencial)
  SEC : process(CLK, RESETL)
  begin
    if (RESETL = '0') then
      EP <= 0;
    elsif (CLK'event and CLK = '1') then
      EP <= ES;
    end if;
  end process SEC;

  --activación de las señales de control
  OP_SETCURSOR <= '1' when ((EP = 0 and (DEL_SCREEN = '1' or DRAW_FIG = '1')) or (EP = 4 and DONE_COLOUR = '1' and END_SQUARE = '0')) else '0';
  OP_DRAWCOLOUR <= '1' when (EP = 1 and DONE_CURSOR = '1') or (EP = 3 and DONE_CURSOR = '1') else '0';
  WHITE <= '1' when (EP = 1 and DONE_CURSOR = '1') else '0';
  SEL_PIX <= '1' when (EP = 1 and DONE_CURSOR = '1') else '0';
  LD_Square <= '1' when (EP = 0 and DEL_SCREEN = '0' and DRAW_FIG = '1') else '0';
  SEL_M <= '1' when ((EP = 0 and DEL_SCREEN = '0' and DRAW_FIG = '1') or (EP = 4 and DONE_COLOUR = '1' and END_SQUARE = '0')) else '0';
  Next_Row <= '1' when (EP = 4 and DONE_COLOUR = '1' and END_SQUARE = '0') else '0';

  --Multiplexor de NUM_PIX
  NUM_PIX <=
    ("00000000001111000") when SEL_PIX = '0' else -- '120'
    ("10010110000000000") when SEL_PIX = '1' else -- '76800'
     "UUUUUUUUUUUUUUUUU";

  --Multiplexor de Colour
  Colour <=
    (x"0000") when COLOUR_CODE = "000" else -- negro
    (x"001F") when COLOUR_CODE = "001" else -- azul
    (x"07E0") when COLOUR_CODE = "010" else -- verde
    (x"07FF") when COLOUR_CODE = "011" else -- celeste
    (x"F800") when COLOUR_CODE = "100" else -- rojo
    (x"F81F") when COLOUR_CODE = "101" else -- fuxia
    (x"FFE0") when COLOUR_CODE = "110" else -- amarillo
    (x"B596") when COLOUR_CODE = "111" else -- gris
     "UUUUUUUUUUUUUUUU";

  --Multiplexor de RGB
  RGB <=
    (Colour) when WHITE = '0' else
    (x"FFFF") when WHITE = '1' else
      "UUUUUUUUUUUUUUUU";

  --Multiplexor de XCOL
  XCOL <=
    ("00000000") when SEL_M = '0' else
    ("00111011") when SEL_M = '1' else
     "UUUUUUUU"; 

  --Multiplexor de YROW
  YROW <=
      (std_logic_vector(Q_Square)) when SEL_M = '1' else
      ("000000000") when SEL_M='0' else
       "UUUUUUUUU";

  --Contador LD_Square
  ContColumnas : process (CLK, RESETL)
  begin
    if (RESETL = '0') then
      Q_Square <= "000000000";
    elsif (CLK'event and CLK = '1') then
      if (LD_SQUARE = '1') then
        Q_Square <= "001001111";
      elsif (Next_Row = '1') then
        Q_Square <= Q_Square + "000000001";
      end if;
    end if;
  end process ContColumnas;

  --Comparador END_SQUARE
  END_SQUARE <= '1' when (Q_Square = "100100001") else '0';

end arc_de_lcd_drawing;