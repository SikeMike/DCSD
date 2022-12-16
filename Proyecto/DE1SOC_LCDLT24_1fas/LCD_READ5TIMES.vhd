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
	DataBit : out std_logic
);	
end lcd_read5times;

architecture arc_de_lcd_read5times of lcd_read5times is
type ESTADO is (E0, E1, E2, E3, E4, E5);

--DECLARACION DE LAS SENIALES DE CONTROL
signal MIRADO, DAT_LISTO, TC_5, LD_27,LD_5, LD_UNO, LD_CERO, LDCONT, esUNO, ESCERO, RESUL_1, CL_0, CLEAR, CLEAR_27 : std_logic;
signal MAS0S, MAS1S: std_logic;
signal E_UNO, E_CERO, E_27, E_5, finUno, finCero : std_logic;
signal QUNO, QCERO, aux_cont0, aux_cont1, aux_cont5, aux_cont27: unsigned(2 downto 0);
signal EP, ES : ESTADO;
--signal x, y: unsigned;

--SEÃ‘ALES QUE NO SE USAN
-- lD_27, LD_5, LD_0, LD_1, Q_27, Q_5


begin
--calculo del estado siguiente
COMB: process(EP, mirado, esUNO, DAT_LISTO, MAS0S, ReadBit)
begin
	case EP is
	when E0 =>
	if (ReadBit = '1') then
		ES <= E1;
	else
		ES <=E0;
	end if;
	when E1 =>
	if (mirado = '1') then
		ES<= E2;
	else
		ES<=E1;
	end if;
	when E2 =>
	if((esUNO='1' or esUNO='0') and TC_5='1') then
		ES<=E3;
	elsif ((esUNO='1' or esUNO='0') and TC_5='0') then
		ES<=E1;
	end if;
	when E3 =>
	if(mirado ='0')then
		ES<=E3;
	elsif(mirado ='1') then
		if(MAS0S='1') then
			ES<=E4;
		else
			ES<=E5;
		end if;
	end if;
	when E4 =>
		ES <= E0;
	when E5 =>
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

--activación de las señales de control
CLEAR<= '1' when (EP = E0) else '0';
CL_0<= '1' when (EP = E3) else '0';
CLEAR_27<= '1' when (EP = E2) else '0';

E_27<='1' when (EP=E1) else '0';
E_5<='1' when (EP=E2) else '0';

BitReady<= '1' when (EP = E3 or EP = E4) else '0';
RESUL_1 <= '1' when (EP = E4) else '0';
LDCONT<= '1' when (EP = E0 and ReadBit = '1') else '0';

E_UNO<= '1' when (EP = E1 and mirado = '1' and esUNO = '1') else '0';
E_CERO<='1' when (EP = E1 and mirado = '1' and esUNO = '0') else '0';


--comparador  si es uno o cero
esUno<= '1' when (DATA = '1') else '0';
esCero<= '1' when (DATA < '1') else '0';

--comparador si hay mas ceros o unos
MAS0S<= '1' when (QCERO > QUNO) else '0';
MAS1S<= '1' when (QCERO < QUNO) else '0';

--registro del databit
RegDataBit : process(CLK, RESET_L, CL_0)
begin
	if (RESET_L = '0') then --reset o comando
		DataBit <= '0';
	elsif(CLK'event and CLK = '1') then
		if(RESUL_1 = '1') then
			DataBit <= '1';
		elsif (CL_0 = '1') then
			DataBit <= '0';
		end if;
end if;
end process RegDataBit;

--contador de unos
ContUnos : process(CLK, RESET_L)
begin
	if(RESET_L = '0') then
		QUNO <= "000";
	elsif(CLK'event and CLK = '1') then
		if(E_UNO = '1' )then  --increase
			aux_cont1 <= aux_cont1 + "001";
		if(finUno = '1') then
			QUNO <= aux_cont1;
		if(CLEAR = '1' ) then
			aux_cont1 <= "000";
		end if;
		end if;
		end if;
	end if;
end process ContUnos;
--contador de ceros
ContCeros: process(CLK, RESET_L)
begin
	if(RESET_L = '0') then
		QCERO <= "000";
	elsif(CLK'event and CLK = '1') then
		if(E_CERO = '1' )then  --increase
			aux_cont0 <= aux_cont0 + "001";
		if(finCero = '1') then
			QCERO <= aux_cont0;
		if(CLEAR = '1' ) then
			aux_cont0 <= "000";
		end if;
		end if;
		end if;
end if;
end process ContCeros;
--con 300 x sera 27.777 = 110110010000001
--con 600 x sera 13.888 = 11011001000000
--con 1200 x sera 6944 =  1101100100000

--contador de 27
Cont27 : process (CLK, RESET_L)	
begin
	if(RESET_L = '0') then
		aux_cont27 <= "000";
		mirado <= '0';
	elsif (CLK'event and CLK = '1' ) then
		--if(E_27='1' and aux_cont27 )
	end if;
		
end process Cont27;
--contador de 5
Cont5 : process(CLK, RESET_L)
begin
	if(RESET_L = '0') then
		aux_cont5 <= "000";
		TC_5 <= '0';
	elsif (CLK'event and CLK = '1' ) then
		if (E_5 = '1' and aux_cont5 > "000") then
			aux_cont5 <= aux_cont5 - "001";
		elsif (aux_cont5 = "000") then
			TC_5 <= '1';
		else
			TC_5 <= '0';	
		end if;
	end if;
end process Cont5;
end arc_de_lcd_read5times;
			
			
		