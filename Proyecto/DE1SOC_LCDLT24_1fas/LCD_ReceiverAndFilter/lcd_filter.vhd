library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_filter is

  --seniales de entrada y salida
  port(
    CLK:      in std_logic;
    RESET_L : in std_logic;

    OP_FILTER : in std_logic;
    RX :        in std_logic;
    SPEED :     in std_logic_vector(1 downto 0);
    
    FILTER_DONE : out std_logic;
    RX_BIT :      out std_logic
  );
end lcd_filter;

architecture arc_de_lcd_filter of lcd_filter is

type ESTADO is (E0, E1, E2, E3, E4, E5);

--declaracion de las seniales de control
signal EP, ES : ESTADO;

signal Init, LD_WaitingCicles, DEC_Cicles, Waiting_End, DEC_Reading, END_Reading, IS_0, INC_1, INC_0, Output_1, Output_0 : std_logic;

signal WaitingCicles : std_logic_vector(14 downto 0);

signal Abs0, Abs1 : std_logic_vector(2 downto 0);

signal q_cicles : unsigned(14 downto 0);
signal q_reading, aux_cont1, aux_cont0 : unsigned(2 downto 0);

signal int0s, int1s : integer;

begin

  --calculo del estado siguiente
  COMB: process(EP, OP_FILTER, Waiting_End, END_Reading, RX, IS_0)
    begin
      case EP is
        when E0 =>
          if (OP_FILTER = '1') then
            ES <= E1;
          else
            ES <= E0;
          end if;

        when E1 => 
          if (Waiting_End = '1' and END_Reading = '1') then
            ES <= E2;
          else
            ES <= E1;
          end if;

        when E2 =>
          ES <= E0;

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

  --calculo de la SPEED
  --con 300 x sera 27.777 = 110110010000001
  --con 600 x sera 13.888 = 11011001000000
  --con 1200 x sera 6944 =  1101100100000
  WaitingCicles <=
    (std_logic_vector(to_unsigned(5, 15))) when (SPEED = "01") else --300       #########################
    (std_logic_vector(to_unsigned(13888, 15))) when (SPEED = "10") else --600
    (std_logic_vector(to_unsigned(6944, 15))); --1200

  --activacion de las seniales de control
  Init <= '1' when (EP = E0) else '0';
  LD_WaitingCicles <= '1' when ((EP = E0 and OP_FILTER = '1') or (EP = E1 and Waiting_End = '1' and END_Reading = '0')) else '0';

  DEC_Cicles <= '1' when (EP = E1 and Waiting_End = '0') else '0';
  DEC_Reading <= '1' when (EP = E1 and Waiting_End = '1' and End_Reading = '0') else '0';

  INC_1 <= '1' when (EP = E1 and Waiting_End = '1' and End_Reading = '0' and RX = '1') else '0';
  INC_0 <='1' when (EP = E1 and Waiting_End = '1' and End_Reading = '0' and RX = '0') else '0';

  Output_0 <= '1' when (EP = E1 and Waiting_End = '1' and End_Reading = '1' and IS_0 = '1') else '0';
  Output_1 <= '1' when (EP = E1 and Waiting_End = '1' and End_Reading = '1' and IS_0 = '0') else '0';

  FILTER_DONE <= '1' when (EP = E2) else '0';

  --comparador si hay mas ceros o unos
  int0s <= (to_integer(unsigned(Abs0)));
  int1s <= (to_integer(unsigned(Abs1)));
  IS_0 <= '1' when (int0s > int1s) else '0';

  --registro del RX_BIT
  RegRXBit : process(CLK, RESET_L)
  begin
    if (RESET_L = '0') then --reset o comando
      RX_BIT <= '0';
    elsif (CLK'event and CLK = '1') then
      if (Output_0 = '1') then
        RX_BIT <= '0';
      elsif (Output_1 = '1') then
        RX_BIT <= '1';
      end if;
    end if;
  end process RegRXBit;

  --contador de waitingcicles
  Cont27 : process (CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      q_cicles <= to_unsigned(0, 15);
    elsif (CLK'event and CLK = '1' ) then
      if (LD_WaitingCicles = '1') then
        q_cicles <= unsigned(WaitingCicles);
      elsif (DEC_Cicles = '1') then
        q_cicles <= (q_cicles - to_unsigned(1, 15));
      end if;
    end if;
  end process Cont27;
  --###############################################################
  Waiting_End <= '1' when (q_cicles = to_unsigned(0, 15)) else '0';
  --###############################################################

  --contador de 5
  Cont5 : process(CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      q_reading <= to_unsigned(0, 3);
    elsif (CLK'event and CLK = '1' ) then
      if (Init = '1') then
        q_reading <= to_unsigned(3, 3);                 --#################################################################################5
      elsif (DEC_Reading = '1') then
        q_reading <= (q_reading - to_unsigned(1, 3));
      end if;
    end if;
  end process Cont5;
  --###############################################################
  END_Reading <= '1' when (q_reading = to_unsigned(0, 3)) else '0';
  --###############################################################

  --contador de unos
  ContUnos : process(CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      aux_cont1 <= to_unsigned(0, 3);
    elsif (CLK'event and CLK = '1') then
      if (Init = '1') then
        aux_cont1 <= to_unsigned(0, 3);
      elsif (INC_1 = '1') then  --increase
        aux_cont1 <= (aux_cont1 + to_unsigned(1, 3));
      end if;
    end if;
  end process ContUnos;
  --##################################
  Abs1 <= std_logic_vector(aux_cont1);
  --##################################

  --contador de ceros
  ContCeros: process(CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      aux_cont0 <= to_unsigned(0, 3);
    elsif(CLK'event and CLK = '1') then
      if (Init = '1') then
        aux_cont0 <= to_unsigned(0, 3);
      elsif (INC_0 = '1') then  --increase
        aux_cont0 <= (aux_cont0 + to_unsigned(1, 3));
      end if;
    end if;
  end process ContCeros;
  --##################################
  Abs0 <= std_logic_vector(aux_cont0);
  --##################################

end arc_de_lcd_filter;