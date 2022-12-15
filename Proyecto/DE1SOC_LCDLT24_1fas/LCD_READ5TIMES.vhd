library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_read5times is
port(
	CLK: in std_logic;
	RESET_L : in std_logic;

	ReadBit : in std_logic;
	DATA : in std_logic;
	velocidad : in unsigned;

	bitReady : out std_logic;
	dataBit : out std_logic
);	
end lcd_read5times;

architecture arc_de_lcd_read5times of lcd_read5times is
type ESTADO is (E0, E1, E3, E4);

--DECLARACION DE LAS SENIALES DE CONTROL
signal MIRADO, DAT_LISTO, TC_5LD_27,LD_5, LD_UNO, LD_CERO, LDCONT, esUNO, ESCERO, RESUL_1, CL_0, CLEAR : std_logic;
signal MAS0S, MAS1S: std_logic;
signal E_UNO, E_CERO, finUno, finCero : std_logic;
signal QUNO, QCERO: unsigned(3 downto 0);
signal EP, ES : ESTADO;

--SEÃ‘ALES QUE NO SE USAN
--E_27, E_5


begin
--calculo del estado siguiente
COMB: process(EP, mirado, esUNO, DAT_LISTO, MAS0S, ReadBit)
begin
	case EP is
	when E0=>
	if (ReadBit ='1') then
		ES<= E1;
	else
		ES<=E0;
	end if;
	when E1=>
	if (mirado='1' AND esUNO='1' and DAT_LISTO='1' AND MAS0S='1') then
		ES<= E3;
	elsif(mirado='1' AND esUNO='1' and DAT_LISTO='1' AND MAS0S='0') then 
		ES<=E4;
	end if;
	when E3=>
		ES<=E0;
	when E4=>
		ES<=E0;
	when others=>
		ES<=E0;
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

--activación de las señales de control
CLEAR<= '1' when (EP=E0) else '0';
CL_0<= '1' when (EP=E3) else '0';
BitReady<= '1' when (EP=E3 or EP=E4) else '0';
RESUL_1 <= '1' when (EP=E4) else '0';
LDCONT<= '1' when (EP=E0 and ReadBit= '1') else '0';
E_UNO<= '1' when (EP=E1 and mirado='1' and esUNO ='1') else '0';
E_CERO<='1' when (EP=E1 and mirado='1' and esUNO='0') else '0';

finUno<='1' when (EP=E1 and mirado='1' and (esUNO='1' or esUNO='0') and dat_listo='1') else '0';
finCero<='1' when (EP=E1 and mirado='1' and esUNO='1' and dat_listo='1') else '0';


--comparador  si es uno o cero
esUno<= '1' when (DATA = '1') else '0';
esCero<= '1' when (DATA < '1') else '0';

--comparador si hay mas ceros o unos
MAS0S<= '1' when (QCERO > QUNO) else '0';
MAS1S<= '1' when (QCERO < QUNO) else '0';
end arc_de_lcd_read5times;
			
			
		