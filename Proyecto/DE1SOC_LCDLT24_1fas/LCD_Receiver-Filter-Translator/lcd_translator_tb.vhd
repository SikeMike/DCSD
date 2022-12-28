library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.ALL;

entity lcd_translator_tb is

  -- Entidad vacia

end lcd_translator_tb;

architecture arq_lcd_translator_tb of lcd_translator_tb is

component lcd_translator
  -- seniales de entrada y salida
  port(
    CLK :     in std_logic;
    RESET_L : in std_logic;

    COMAND_READY :          in std_logic;
    COMAND : in std_logic_vector(7 downto 0);
    
    COLOUR_CODE : out std_logic_vector(2 downto 0);
    DEL_SCREEN :    out std_logic;
    DRAW_FIG : out std_logic;
    DONE :      out std_logic
  );

end component;

--declaracion de las seniales de control
signal tb_CLK : std_logic := '0';
signal tb_RESET_L : std_logic := '0';

signal tb_COMAND_READY : std_logic := '0';
signal tb_COMAND : std_logic_vector(7 downto 0) := (others => '0');

signal tb_COLOUR_CODE: std_logic_vector(2 downto 0) :=(others=> '0');

signal tb_DEL_SCREEN : std_logic;
signal tb_DRAW_FIG : std_logic;
signal tb_DONE : std_logic;

begin

  uTranslator : lcd_translator port map (

    CLK => tb_CLK,
    RESET_L => tb_RESET_L,

    COMAND_READY => tb_COMAND_READY,
    COMAND => tb_COMAND,

    COLOUR_CODE => tb_COLOUR_CODE,

    DEL_SCREEN => tb_DEL_SCREEN,
    DRAW_FIG => tb_DRAW_FIG,
    DONE => tb_DONE

  );

  tb_CLK <= not tb_CLK after 10 ns;

  simulacion : process
  begin
    wait for 10 ns; --(para sincronizar)
    wait for 20 ns;
    tb_RESET_L <= '1';
    wait for 60 ns;
    tb_COMAND_READY <= '1';
    tb_COMAND <= "01100100";
    wait for 60 ns;
    tb_COMAND_READY <= '1';
    tb_COMAND <= "01010111";
   
    wait for 60 ns;
    tb_COMAND_READY <= '1';
    tb_COMAND<= "01110011";

    wait for 60 ns;
    tb_COMAND_READY <= '1';
    tb_COMAND <= "01010100";
	
    wait;
  end process;

end arq_lcd_translator_tb;
