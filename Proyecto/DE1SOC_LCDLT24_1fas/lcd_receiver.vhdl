library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_receiver is

  --seniales de entrada y salida
  port(
    CLK :    in std_logic;
    RESET_L : in std_logic;

    DATA : in std_logic;
    DATA_BIT : in std_logic;
    BITREAD : in std_logic;
    DONE : in std_logic;

    READBIT : out std_logic;
    DATARECEIVED : out std_logic;
    COMMAND : out std_logic_vector(7 downto 0)
  );

end lcd_receiver;

architecture arc_de_lcd_receiver of lcd_receiver is

type ESTADO is (E0, E1, E2, E3, E4, E5, E6, E7);

--declaracion de las seniales de control
signal EP, ES : ESTADO;
signal Clear, LD_Start, StartBit, FIN_Cdwn, DEC_Cdwn, Shift, Sum, LD_Parity, LD_Stop, StopBit, Odd, ParityBit, ParityCheck : std_logic;

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
  READBIT <= '1' when (EP = E2 or EP = E4 or EP = E5) else '0'
--   lcd_cs_n_LOW <= '1' when (EP = E1 or EP = E7) else '0';
--   lcd_wr_n_LOW <= '1' when (EP = E1 or EP = E7) else '0';
  
--   INC_DAT <= '1' when (EP = E3 or EP = E4 or EP = E6) else '0';
--   RS_DAT <= '1' when (EP = E3 or EP = E6) else '0';
--   DONE_CURSOR <= '1' when (EP = E5) else '0';
--   DEC_PIX <= '1' when (EP = E7) else '0';
--   DONE_COLOUR <= '1' when (EP = E10) else '0';

--   --asignacion de las seniales en low
--   LCD_CS_N <= not lcd_cs_n_LOW;
--   LCD_WR_N <= not lcd_wr_n_LOW;

--   --Registro XCOL
--   RegXCOL : process(CLK, RESET_L)
--   begin
--     if (RESET_L = '0') then
--       RXCOL <= (others => '0');          --reset
--     elsif (CLK'event and CLK = '1') then --flanco de reloj
--       if (LD_INF = '1') then
--         RXCOL <= XCOL;                   --cargar dato
--       end if;
--     end if;
--   end process RegXCOL;

--   --Registro YROW
--   RegYROW : process(CLK, RESET_L)
--   begin
--     if (RESET_L = '0') then
--       RYROW <= (others => '0');          --reset
--     elsif (CLK'event and CLK = '1') then --flanco de reloj
--       if (LD_INF = '1') then
--         RYROW <= YROW;                   --cargar dato
--       end if;
--     end if;
--   end process RegYROW;

--   --Registro RGB
--   RegRGB : process(CLK, RESET_L)
--   begin
--     if (RESET_L = '0') then
--       RRGB <= (others => '0');           --reset
--     elsif (CLK'event and CLK = '1') then --flanco de reloj
--       if (LD_INF = '1') then
--         RRGB <= RGB;                     --cargar dato
--       end if;
--     end if;
--   end process RegRGB;

--   --Registro LCD_RS
--   RegLCD_RS : process(CLK, RESET_L, RS_COM)
--   begin
--     if (RESET_L = '0' or RS_COM = '1') then
--       LCD_RS <= '0';                     --reset o comando
--     elsif (CLK'event and CLK = '1') then --flanco de reloj
--       if (RS_DAT = '1') then
--         LCD_RS <= '1';                   --dato
--       end if;
--     end if;
--   end process RegLCD_RS;

--   --Contador de pixeles
--   ContPix : process (CLK, RESET_L)
--   begin
--     if (RESET_L = '0') then
--       aux_contpix <= "00000000000000000";                              --reset
--       END_PIX <= '0';
--     elsif (CLK'event and CLK = '1') then                               --flanco de reloj
--       if (LD_INF = '1') then                                           --cagar dato
--         aux_contpix <= unsigned(NUM_PIX);
--       elsif (DEC_PIX = '1' and aux_contpix > "00000000000000000") then --decrease
--         aux_contpix <= aux_contpix - "00000000000000001";
-- 		elsif (aux_contpix = "0000000000000000") then
-- 			END_PIX <= '1';                                               --activacion señal control
-- 		else
-- 			END_PIX <= '0';
--       end if;
--     end if;
--   end process ContPix;

--   --Contador de salida de datos
--   ContDat : process (CLK, RESET_L, CL_DAT)
--   begin
--     if (RESET_L = '0' or CL_DAT = '1') then
--       aux_contdat <= "000";              --reset
--     elsif (CLK'event and CLK = '1') then --flanco de reloj
--       if (LD_2C = '1') then
--         aux_contdat <= "110";            --6
--       elsif (INC_DAT = '1' and aux_contdat < "111") then
--         aux_contdat <= aux_contdat + "001";
--       end if;
--     end if;
--   end process ContDat;
  
--   CONT_Q <= std_logic_vector(aux_contdat);

--   --Multiplexor
--   LCD_DATA <=
--     (x"002A") when CONT_Q = "000" else
--     (x"0000") when CONT_Q = "001" else
--     (x"00" & RXCOL) when CONT_Q = "010" else
--     (x"002B") when CONT_Q = "011" else
--     ("000000000000000" & YROW(0)) when CONT_Q = "100" else
--     ((x"00" & RYROW(7 downto 0))) when CONT_Q = "101" else
--     (x"002C") when CONT_Q = "110" else
--     (RRGB) when CONT_Q = "111" else
--     (x"002A");

--   --Decodificador
--   D0 <= '1' when (CONT_Q = "000") else '0';
--   D1 <= '1' when (CONT_Q = "001") else '0';
--   D2 <= '1' when (CONT_Q = "010") else '0';
--   D3 <= '1' when (CONT_Q = "011") else '0';
--   D4 <= '1' when (CONT_Q = "100") else '0';
--   D5 <= '1' when (CONT_Q = "101") else '0';
--   D6 <= '1' when (CONT_Q = "110") else '0';
--   D7 <= '1' when (CONT_Q = "111") else '0';

end arc_de_lcd_receiver;