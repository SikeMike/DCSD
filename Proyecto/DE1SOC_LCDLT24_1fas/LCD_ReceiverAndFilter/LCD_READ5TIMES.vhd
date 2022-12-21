library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_read5times is
port(
	CLK: in std_logic;
	RESET_L : in std_logic;

	ReadBit : in std_logic;
	DATA : in std_logic;
	velocidad : in std_logic_vector(10 downto 0);
	
	bitReady : out std_logic;
	DataBit : out std_logic
);	
end lcd_read5times;

architecture arc_de_lcd_read5times of lcd_read5times is
type ESTADO is (E0, E1, E2, E3, E4, E5, E6);

--DECLARACION DE LAS SENIALES DE CONTROL
signal MIRADO, TC_5, LD_27,LD_5, LD_V , esUNO, ESCERO, RESUL_1, CL_0, CLEAR : std_logic;
signal MAS0S: std_logic;
signal E_UNO, E_CERO, E_27, E_5 : std_logic;
signal QUNO, QCERO, aux_cont0, aux_cont1, aux_cont5: unsigned(2 downto 0);
signal EP, ES : ESTADO;
signal v_out, aux_cont27: unsigned(14 downto 0);


begin
--calculo del estado siguiente
COMB: process(EP, mirado, esUNO, MAS0S, ReadBit)
begin
	case EP is
	when E0 =>
	if (ReadBit = '1') then
		ES <= E1;
	else
		ES <=E0;
	end if;
	when E1 =>
	--if (mirado = '1') then
		ES<= E2;
	--else
		--ES<=E1;
	--end if;
	when E2 => 
	if (mirado = '1') then
		ES<=E3;
	else
		ES<=E2;
	end if;
	when E3 =>
	if(TC_5='1') then
		ES<=E4;
	else
		ES <= E1;
	end if;
	when E4 =>
	if(mirado = '0')then
		ES<=E4;
	elsif(mirado ='1') then
		if(MAS0S='1') then
			ES<=E5;
		else
			ES<=E6;
		end if;
	end if;
	when E5 =>
		ES <= E0;
	when E6 =>
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
--calculo de la velocidad
--con 300 x sera 27.777 = 110110010000001
--con 600 x sera 13.888 = 11011001000000
--con 1200 x sera 6944 =  1101100100000
v_out<=
("110110010000001") when velocidad = "00100101100" else --300
("011011001000000") when velocidad = "01001011000" else --600
"001101100100000"; --1200

--activación de las señales de control
CLEAR <= '1' when (EP = E0) else '0';
LD_5 <= '1' when (EP=E0) else '0';
LD_V<= '1' when ((EP=E1) or (EP=E3 and TC_5='1')) else '0';

E_27 <= '1' when (EP=E2 or EP=E4) else '0';
E_5 <= '1' when (EP=E3) else '0';

E_UNO <= '1' when (EP = E3 and esUNO = '1') else '0';
E_CERO <='1' when (EP = E3 and esUNO = '0') else '0';

CL_0 <= '1' when (EP = E4 and mirado = '1' and MAS0S = '1') else '0';
RESUL_1 <= '1' when (EP = E4 and mirado = '1' and MAS0S = '0') else '0';

BitReady<= '1' when (EP = E5 or EP = E6) else '0';

--comparador  si es uno o cero
esUno <= '1' when (DATA = '1') else '0';
esCero <= '1' when (DATA < '1') else '0';

--comparador si hay mas ceros o unos
MAS0S <= '1' when (QCERO > QUNO) else '0';
--MAS1S <= '1' when (QCERO < QUNO) else '0';

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

--contador de 27
Cont27 : process (CLK, RESET_L)	
begin
	if(RESET_L = '0') then
		aux_cont27 <= "000000000000000";
		mirado <= '0';
	elsif (CLEAR = '1') then
		aux_cont27<="000000000000000";
		mirado<='0';
	elsif (CLK'event and CLK = '1' ) then
		if(LD_V='1') then
			aux_cont27<=v_out;
			if(E_27='1' and aux_cont27 > "000000000000000") then
				aux_cont27<= aux_cont27 - "000000000000001";
				mirado <= '0';
			elsif(aux_cont27 = "000000000000000") then
				mirado <= '1';
			else
				mirado <= '0';
			end if;
		end if;
	end if;
	
end process Cont27;
--contador de 5
Cont5 : process(CLK, RESET_L)
begin
	if(RESET_L = '0') then
		aux_cont5 <= "000";
		TC_5 <= '0';
	elsif (CLEAR = '1') then
		aux_cont5 <= "000";
		TC_5 <= '0';
	elsif (CLK'event and CLK = '1' ) then
		if(LD_5 = '1') then
			aux_cont5<= "101"; --5
			if (E_5 = '1' and aux_cont5 > "000") then
				aux_cont5 <= aux_cont5 - "001";
			elsif (aux_cont5 = "000") then
				TC_5 <= '1';
			else
				TC_5 <= '0';	
			end if;
		end if;
	end if;
end process Cont5;

--contador de unos
ContUnos : process(CLK, RESET_L)
begin
	if(RESET_L = '0') then
		QUNO <= "000";
	elsif(CLK'event and CLK = '1') then
		if(E_UNO = '1' )then  --increase
			aux_cont1 <= aux_cont1 + "001";
			QUNO <= aux_cont1;
		if(CLEAR = '1' ) then
			aux_cont1 <= "000";
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
			QCERO <= aux_cont0;
		if(CLEAR = '1' ) then
			aux_cont0 <= "000";
		end if;
		end if;
end if;
end process ContCeros;


end arc_de_lcd_read5times;
			
			
		