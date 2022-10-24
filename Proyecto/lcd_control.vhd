library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_control is

  -- señales de entrada y salida
  port(
    LCD_Init_Done, OP_SETCURSOR, OP_DRAWCOLOUR, CLK, RESETL : in std_logic;
    XCOL :     in std_logic_vector(7 downto 0);
    YROW :     in std_logic_vector(8 downto 0);
    RGB :      in std_logic_vector(15 downto 0);
    NUM_PIX :  in std_logic_vector(16 downto 0);

    DONE_CURSOR, DONE_COLOUR, LCD_CS_N, LCD_WR_N, LCD_RS : out std_logic;
    LCD_DATA : out std_logic_vector(15 downto 0)
  );

end lcd_control;

architecture arc_de_lcd_control of lcd_control is

--declaracion de las señales
signal EP, ES : integer range 0 to 12;
signal RXCOL :  std_logic_vector(7 downto 0);
signal RYROW :  std_logic_vector(8 downto 0);
signal RRGB :   std_logic_vector(15 downto 0);
signal CONT_Q : std_logic_vector(2 downto 0);
signal LD_INF, CL_MUX, DEC_PIX, END_PIX, CL_DAT, INC_DAT, LD_2C, RS_DAT, RS_COM, LCD_RES, D0, D1, D2, D3, D4, D5, D6, D7 : std_logic;
signal aux_q :  std_logic := '0';
signal aux_contpix : unsigned(16 downto 0);
signal aux_contdat : unsigned(2 downto 0);

begin

  --calculo del estado siguiente (combinacional)
  COMB : process(EP, LCD_INIT_DONE, OP_SETCURSOR, OP_DRAWCOLOUR, D0, D1, D2, D3, D4, D5, D6, END_PIX)
  begin
    case EP is
      when 0 =>
        if (LCD_INIT_DONE = '0') then
          ES <= 0;
        else -- LCD_INIT_DONE = '1'
          if (OP_SETCURSOR = '1') then
            ES <= 1;
          elsif (OP_SETCURSOR = '0' and OP_DRAWCOLOUR = '1') then
            ES <= 12;
          else
            ES <= 0;
          end if;
        end if;
      when 1 => ES <= 2;
      when 2 => ES <= 3;
      when 3 =>
        if (D0 = '1' or D1 = '1' or D3 = '1' or D4 = '1') then
          ES <= 11;
        elsif (D2 = '1') then
          ES <= 10;
        elsif (D5 = '1') then
          ES <= 9;
        else -- D6 = '1'
          ES <= 4;
        end if;
      when 4 => ES <= 5;
      when 5 => ES <= 6;
      when 6 => ES <= 7;
      when 7 =>
        if (END_PIX = '1') then
          ES <= 8;
        else
          ES <= 5;
        end if;
      when 8 => ES <= 0;
      when 9 => ES <= 0;
      when 10 => ES <= 2;
      when 11 => ES <= 2;
      when 12 => ES <= 2;
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

  --activacion de las señales de control
  CL_MUX <= '1' when (EP = 0 or EP = 1 or EP = 12) else '0';
  CL_DAT <= '1' when (EP = 1) else '0';
  LD_INF <= '1' when (EP = 1 or EP = 12) else '0';
  RS_COM <= '1' when (EP = 1 or EP = 10 or EP = 12) else '0';
  LD_2C <= '1' when (EP = 12) else '0';
  LCD_CS_N <= '1' when (EP = 2 or EP = 5) else '0';
  LCD_WR_N <= '1' when (EP = 2) else '0';
  INC_DAT <= '1' when (EP = 4 or EP = 10 or EP = 11) else '0';
  RS_DAT <= '1' when (EP = 4 or EP = 11) else '0';
  DONE_CURSOR <= '1' when (EP = 9) else '0';
  DEC_PIX <= '1' when (EP = 6) else '0';
  DONE_COLOUR <= '1' when (EP = 8) else '0';

  --Registro XCOL
  RegXCOL : process(CLK, RESETL)
  begin
    if (RESETL = '0') then
      RXCOL <= (others => '0');          --reset
    elsif (CLK'event and CLK = '1') then --flanco de reloj
      if (LD_INF = '1') then
        RXCOL <= XCOL;                   --cargar dato
      end if;
    end if;
  end process RegXCOL;

  --Registro YROW
  RegYROW : process(CLK, RESETL)
  begin
    if (RESETL = '0') then
      RYROW <= (others => '0');          --reset
    elsif (CLK'event and CLK = '1') then --flanco de reloj
      if (LD_INF = '1') then
        RYROW <= YROW;                   --cargar dato
      end if;
    end if;
  end process RegYROW;

  --Registro RGB
  RegRGB : process(CLK, RESETL)
  begin
    if (RESETL = '0') then
      RRGB <= (others => '0');           --reset
    elsif (CLK'event and CLK = '1') then --flanco de reloj
      if (LD_INF = '1') then
        RRGB <= RGB;                     --cargar dato
      end if;
    end if;
  end process RegRGB;

  --Biestable JK dato o comando
  BiestableJK : process (CLK, RESETL)
  begin
    if (RESETL = '0') then
      aux_q <= '0';                      --reset
    elsif (CLK'event and CLK = '1') then --flanco de reloj
      if (RS_DAT = '1' and RS_COM = '0') then
        aux_q <= '1';                    --10 set
      elsif (RS_DAT = '0' and RS_COM = '1') then
        aux_q <= '0';                    --01 clear
      elsif (RS_DAT = '1' and RS_COM = '1') then
        aux_q <= not aux_q;              --11 opposite
      end if;
    end if;
    LCD_RES <= aux_q;                    --asignar valor
  end process BiestableJK;

  --Contador de pixeles
  ContPix : process (CLK, RESETL)
  begin
    if (RESETL = '0') then
      aux_contpix <= "00000000000000000";                  --reset
    elsif (CLK'event and CLK = '1') then             --flanco de reloj
      if (LD_INF = '1') then                         --cagar dato
        aux_contpix <= unsigned(NUM_PIX);
      elsif (DEC_PIX = '1' and aux_contpix > "00000000000000000") then --decrease
        aux_contpix <= aux_contpix - "00000000000000001";
      end if;
    end if;
    if (aux_contpix = "0000000000000000") then                        --activación señal tc
      END_PIX <= '1';
    else
      END_PIX <= '0';
    end if;
  end process ContPix;

  --Contador de salida de datos
  ContDat : process (CLK, RESETL, CL_DAT)
  begin
    if (RESETL = '0' or CL_DAT = '1') then
      aux_contdat <= "000";          --reset
    elsif (CLK'event and CLK = '1') then --flanco de reloj
      if (LD_2C = '1') then
        aux_contdat <= "110";
      elsif (INC_DAT = '1' and aux_contdat < "111") then
        aux_contdat <= aux_contdat + "001";
      end if;
    end if;
    CONT_Q <= std_logic_vector(aux_contdat);
  end process ContDat;

  --Multiplexor
  LCD_DATA <=
    (x"002A") when CONT_Q = "000" else
    (x"0000") when CONT_Q = "001" else
    (x"00" & XCOL) when CONT_Q = "010" else
    (x"002B") when CONT_Q = "011" else
    ("000000000000000" & YROW(0)) when CONT_Q = "100" else
    ((x"00" & YROW(7 downto 0))) when CONT_Q = "101" else
    x"002C" when CONT_Q = "110" else
    (RRGB) when CONT_Q = "111" else
    "UUUUUUUUUUUUUUUU";

  --Decodificador
  D0 <= '1' when (CONT_Q = "000") else '0';
  D1 <= '1' when (CONT_Q = "001") else '0';
  D2 <= '1' when (CONT_Q = "010") else '0';
  D3 <= '1' when (CONT_Q = "011") else '0';
  D4 <= '1' when (CONT_Q = "100") else '0';
  D5 <= '1' when (CONT_Q = "101") else '0';
  D6 <= '1' when (CONT_Q = "110") else '0';
  D7 <= '1' when (CONT_Q = "111") else '0';

end arc_de_lcd_control;
