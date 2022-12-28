library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_drawing is

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

end lcd_drawing;

architecture arc_de_lcd_drawing of lcd_drawing is

type ESTADO is (E0, E1, E2, E3, E4, E5, E6, E7, E8, E9);

--declaracion de las seniales de control
signal EP, ES : ESTADO;
signal LD_Square, Next_Row, END_Square, SEL_M, SEL_PIX, WHITE : std_logic;
signal Q_Square : unsigned(8 downto 0);
signal Colour : std_logic_vector(15 downto 0); 

begin

  --calculo del estado siguiente (combinacional)
  COMB : process(EP, DEL_SCREEN, DRAW_FIG, DONE_CURSOR, DONE_COLOUR, END_Square)
  begin
    case EP is
      when E0 =>
        if (DEL_SCREEN = '1') then
          ES <= E1;
        elsif (DRAW_FIG = '1') then
          ES <= E5;
        else
          ES <= E0;
        end if;
      when E1 =>
        ES <= E2;
      when E2 =>
        if (DONE_CURSOR = '1') then
          ES <= E3;
        else
          ES <= E2;
        end if;
      when E3 =>
        ES <= E4;
      when E4 =>
        if (DONE_COLOUR = '1') then
          ES <= E0;
        else
          ES <= E4;
        end if;
      when E5 =>
        ES <= E6;
      when E6 =>
        if (DONE_CURSOR = '1') then
          ES <= E7;
        else
          ES <= E6;
        end if;
      when E7 =>
        ES <= E8;
      when E8 =>
        if (DONE_COLOUR = '1' and END_Square = '1') then
          ES <= E0;
        elsif (DONE_COLOUR = '1' and END_Square = '0') then
          ES <= E9;
        else
          ES <= E8;
        end if;
      when E9 =>
        ES <= E6;
      when others =>
        ES <= E0;
    end case;
  end process COMB;

  --calculo del estado siguiente (secuencial)
  SEC : process(CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      EP <= E0;
    elsif (CLK'event and CLK = '1') then
      EP <= ES;
    end if;
  end process SEC;

  --activacion de las seniales de control
  OP_SETCURSOR <= '1' when (EP = E1 or EP = E5 or EP = E9) else '0';
  OP_DRAWCOLOUR <= '1' when (EP = E3 or EP = E7) else '0';
  WHITE <= '1' when (EP = E3) else '0';
  SEL_PIX <= '1' when (EP = E3) else '0';
  LD_Square <= '1' when (EP = E0 and DEL_SCREEN = '0' and DRAW_FIG = '1') else '0';
  SEL_M <= '1' when (EP = E5 or EP = E9) else '0';
  Next_Row <= '1' when (EP = E8 and DONE_COLOUR = '1' and END_SQUARE = '0') else '0';

  --Multiplexor de NUM_PIX
  NUM_PIX <=
    ("00000000001111000") when SEL_PIX = '0' else -- '120'
    ("10010110000000000") when SEL_PIX = '1' else -- '76800'
     "00000000001111000";

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
     (x"0000");

  --Multiplexor de RGB
  RGB <=
    (Colour) when WHITE = '0' else  --color de entrada
    (x"FFFF") when WHITE = '1' else --color blanco
     (Colour);

  --Multiplexor de XCOL
  XCOL <=
    ("00000000") when SEL_M = '0' else --posicion columna 0
    ("00111011") when SEL_M = '1' else --posicion columna 59
     ("00000000"); 

  --Multiplexor de YROW
  YROW <=
      (std_logic_vector(Q_Square)) when SEL_M = '1' else --posicion fila del cuadrado
      ("000000000") when SEL_M = '0' else                --posicion fila 0
       ("000000000");

  --Contador Q_Square
  ContColumnas : process (CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      Q_Square <= "000000000";
    elsif (CLK'event and CLK = '1') then
      if (LD_SQUARE = '1') then
        Q_Square <= "001100011"; --posicion fila 99
      elsif (Next_Row = '1') then
        Q_Square <= Q_Square + "000000001";
      end if;
    end if;
  end process ContColumnas;

  --Comparador END_SQUARE
  END_SQUARE <= '1' when (Q_Square = "011101111") else '0';  --cuando llega a 120 pixeles dibujados (Y=239)

end arc_de_lcd_drawing;