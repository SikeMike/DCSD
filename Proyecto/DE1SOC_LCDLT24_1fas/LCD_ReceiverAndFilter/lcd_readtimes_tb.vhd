library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.ALL;
--use ieee.std_logic_arith.UNSIGNED;

entity lcd_read5times_tb is

end lcd_read5times_tb;

architecture arq_lcd_read5times_tb of lcd_read5times_tb is

component lcd_read5times
--seniales de entrada y salida
port(
	CLK: in std_logic;
	RESET_L : in std_logic;

	ReadBit : in std_logic;
	DATA : in std_logic;
	velocidad : std_logic_vector(10 downto 0);
	
	bitReady : out std_logic;
	DataBit : out std_logic
);
end component;
--declaracion de las seniales de control
signal tb_CLK : std_logic := '0';
signal tb_RESET_L : std_logic := '0';

signal tb_ReadBit : std_logic := '0';
signal tb_DATA : std_logic := '0';
signal tb_velocidad : std_logic_vector(10 downto 0);

signal tb_bitReady : std_logic := '0';
signal tb_DataBit : std_logic := '0';

begin

u5times : lcd_read5times port map(
	CLK => tb_CLK,
	RESET_L => tb_RESET_L,

	ReadBit => tb_ReadBit,
	DATA => tb_DATA,
	velocidad => tb_velocidad,
	
	bitReady => tb_bitReady,
	DataBit => tb_DataBit
);
tb_CLK<= not tb_CLK after 10 ns;

simulacion : process
begin
	wait for 20 ns;
	tb_RESET_L<= '1';
	
	wait for 20 ns;
	tb_ReadBit <= '1';
	tb_DATA <= '1';
	tb_velocidad <= "00100101100";
	 

	wait for 800 ns;
	wait;
end process;

end arq_lcd_read5times_tb;
