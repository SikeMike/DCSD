library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_receiver is

  --seniales de entrada y salida
  port(
    CLK :     in std_logic;
    RESET_L : in std_logic;

    DATA :     in std_logic;
    BITREAD :  in std_logic;
    DATA_BIT : in std_logic;
    DONE :     in std_logic;

    READBIT :      out std_logic;
    DATARECEIVED : out std_logic;
    COMANDO :      out std_logic_vector(7 downto 0)
  );

end lcd_receiver;

architecture arc_de_lcd_receiver of lcd_receiver is

type ESTADO is (E0, E1, E2, E3, E4, E5, E6, E7);

--declaracion de las seniales de control
signal EP, ES : ESTADO;
signal Clear, LD_Start, StartBit, FIN_Cdwn, DEC_Cdwn, Shift, Sum, LD_Parity, LD_Stop, StopBit, Odd, InputK, ParityBit, ParityCheck : std_logic;

signal Aux_Comand : std_logic_vector(7 downto 0);

signal Q_Cdwn : unsigned(2 downto 0);

begin

  --calculo del estado siguiente (combinacional)
  COMB : process(DATA, BITREAD, StartBit, FIN_Cdwn, StopBit, ParityCheck, Done)
  begin
    case EP is
      when E0 =>
        ES <= E1;

      when E1 =>
        if (DATA = '0') then
          ES <= E2;
        else
          ES <= E1;
        end if;

      when E2 =>
        if (BITREAD = '1') then
          ES <= E3;
        else
          ES <= E2;
        end if;

      when E3 =>
        if (StartBit = '1') then
          ES <= E0;
        else
          ES <= E4;
        end if;

      when E4 =>
        if (BITREAD = '1' and FIN_Cdwn = '1') then
          ES <= E5;
        else
          ES <= E4;
        end if;
      
      when E5 =>
        if (BITREAD = '0') then
          ES <= E5;
        else
          ES <= E6;
        end if;

      when E6 =>
        if (StopBit = '0' and ParityCheck = '1') then
          ES <= E7;
        else
          ES <= E0;
        end if;

      when E7 =>
        if (Done = '1') then
          ES <= E0;
        else
          ES <= E7;
        end if;

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
  Clear <= '1' when (EP = E0) else '0';
  READBIT <= '1' when (EP = E2 or EP = E4 or EP = E5) else '0';
  LD_Start <= '1' when (EP = E2 and BITREAD = '1') else '0';

  Shift <= '1' when (EP = E4 and BITREAD = '1' and FIN_Cdwn = '0') else '0';
  DEC_Cdwn <= '1' when (EP = E4 and BITREAD = '1' and FIN_Cdwn = '0') else '0';
  Sum <= '1' when (EP = E4 and BITREAD = '1' and FIN_Cdwn = '0') else '0';
  LD_Parity <= '1' when (EP = E4 and BITREAD = '1' and FIN_Cdwn = '1') else '0';

  LD_Stop <= '1' when (EP = E5 and BITREAD = '1') else '0';
  DATARECEIVED <= '1' when (EP = E7) else '0';

  --OR Gate
  InputK <= '1' when (Sum = '1' or Clear = '1') else '0';

  --Registro StartBit
  RegStart : process(CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      StartBit <= '0';                   --reset
    elsif (CLK'event and CLK = '1') then --flanco de reloj
      if (Clear = '1') then
        StartBit <= '0';                 --clear
      elsif (LD_Start = '1') then
        StartBit <= DATA_BIT;            --cargar startbit
      end if;
    end if;
  end process RegStart;

  --Registro ParityBit
  RegParity : process(CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      ParityBit <= '0';                  --reset
    elsif (CLK'event and CLK = '1') then --flanco de reloj
      if (Clear = '1') then
        ParityBit <= '0';                 --clear
      elsif (LD_Parity = '1') then
        ParityBit <= DATA_BIT;           --cargar paritybit
      end if;
    end if;
  end process RegParity;

  --Registro StopBit
  RegStop : process(CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      StopBit <= '0';                    --reset
    elsif (CLK'event and CLK = '1') then --flanco de reloj
      if (Clear = '1') then
        StopBit <= '0';                  --clear
      elsif (LD_Stop = '1') then
        StopBit <= DATA_BIT;             --cargar stopbit
      end if;
    end if;
  end process RegStop;

  --Registro de desplazamiento COMANDO
  RegCOMANDO : process(CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      Aux_Comand <= (others => '0');              --reset
    elsif (CLK'event and CLK = '1') then          --flanco de reloj
      if (Clear = '1') then
        Aux_Comand <= (others => '0');               --clear
      elsif (Shift = '1') then
        Aux_Comand <= Aux_Comand(6 downto 0) & DATA_BIT;
      end if;
    end if;
  end process RegCOMANDO;
--###############################################
  COMANDO <= Aux_Comand;
--###############################################

  --Biestable Flip Flop Odd
  FlipFlopOdd : process (CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      Odd <= '0';                             --reset
    elsif (CLK'event and CLK = '1') then      --flanco de reloj
      if (Sum = '1' and InputK = '1') then
        Odd <= not Odd;                        --flip
      elsif (Sum = '1' and InputK = '0') then
        Odd <= '1';                            --set
      elsif (Sum = '0' and InputK = '1') then
        Odd <= '0';                            --clear
      end if;
    end if;
  end process FlipFlopOdd;

  --Contador de bits recibidos
  ContBits : process (CLK, RESET_L)
  begin
    if (RESET_L = '0') then
      Q_Cdwn <= to_unsigned(0, 3);        --reset
    elsif (CLK'event and CLK = '1') then  --flanco de reloj
      if (Clear = '1') then
        Q_Cdwn <= to_unsigned(7, 3);      --load (clear)
      elsif (DEC_Cdwn = '1') then
        Q_Cdwn <= (Q_Cdwn - to_unsigned(1, 3));         --decrease
      end if;
    end if;
  end process ContBits;
--###############################################
  FIN_Cdwn <= '1' when (Q_Cdwn = 0) else '0';
--###############################################

--Comparador ParityCheck
  ParityCheck <= '1' when (Odd = ParityBit) else '0';

end arc_de_lcd_receiver;