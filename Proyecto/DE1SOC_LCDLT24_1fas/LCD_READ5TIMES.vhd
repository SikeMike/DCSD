library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_read5timeas is
port(
	ReadBit : in std_logic;
	DATA : in std_logic;
	
	bitReady : out std_logic;
	dataBit : out std_logic
);	
end ldc_read5times;

architecture arc_de_lcd_read5times of lcd_read5_times is
type ESTADO is (E0, E1, E3, E4);

--DECLARACION DE LAS SENIALES DE CONTROL
signal MIRADO, TC_5LD_27,LD_5, LD_UNO, LD_CERO, FINUNO, FINCER0, ESUNO, ESCERO, RESUL_1, CL_0, CLEAR : std_logic;
--SEÑALES QUE NO SE USAN
--E_27, E_5
signal QUNO, QCERO: unsigned(3 downto 0);


--calculo del estado siguiente
COMP: process()
begin
	case EP is 
		when E0 =>
		if(ReadBit = '0') then
			
			
		