library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_translator is

  --seniales de entrada y salida
  port(
    CLK :     in std_logic;
    RESET_L : in std_logic;

    COMAND_READY :          in std_logic;
    COMAND : in std_logic_vector(7 downto 0);
   

    DEL_SCREEN :    out std_logic;
    DRAW_FIG : out std_logic;
    DONE :      out std_logic;
    COLOUR_CODE : out std_logic_vector(2 downto 0)
  );

end lcd_translator;

architecture arc_de_lcd_translator of lcd_translator is

type ESTADO is (E0, E1, E2, E3);

--declaracion de las seniales de control
signal EP, ES : ESTADO;
signal LD_Com, Clear, INIT, CAMBIO_COLOR : std_logic;
signal Q_Com : std_logic_vector(7 downto 0);

signal Code_DEL_SCREEN : std_logic_vector(7 downto 0) := "01100100";  -- tecla d
signal Code_DRAW_FIG : std_logic_vector(7 downto 0) := "01110011";    -- tecla s


begin
  --calculo del estado siguiente (combinacional)
  COMB : process(EP, COMAND_READY)
  begin
    case EP is
      when E0 =>
        ES <= E1;

      when E1 =>
        if (COMAND_READY = '1') then
          ES <= E2;
        else
          ES <= E1;
        end if;

      when E2 =>
        ES <= E3;

      when E3 =>
        ES <= E1;

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
  LD_Com <= '1' when (EP = E1) else '0';
  DONE <= '1' when (EP = E1) else '0';
  Clear <= '1' when (EP = E2) else '0';
  INIT <= '1' when (EP = E0) else '0';


  --Comparadores 
  DEL_SCREEN <= '1' when (Code_DEL_SCREEN = Q_Com) else '0';
  DRAW_FIG <= '1' when (Code_DRAW_FIG = Q_Com) else '0';
  CAMBIO_COLOR <= '1' when (Q_COM(7 downto 3) = "01010") else '0';

  --Registro COMAND
  RegCom : process(CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      Q_Com <= (others => '0');                   --reset
    elsif (CLK'event and CLK = '1') then --flanco de reloj
      if (Clear = '1') then
        Q_Com <= (others => '0');                 --clear
      elsif (LD_Com = '1') then
        Q_Com <= COMAND;                  --cargar COMAND
      end if;
    end if;
  end process RegCom;

  --Registro Color
  RegComColor : process (CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      COLOUR_CODE<= (others => '0');                   --reset
    elsif (CLK'event and CLK = '1') then
      if(INIT = '1') then
        COLOUR_CODE<= (others => '0');
      elsif (CAMBIO_COLOR = '1') then
          COLOUR_CODE <= Q_COM(2 downto 0);
      end if;
    end if;
  end process RegComColor;

end arc_de_lcd_translator;