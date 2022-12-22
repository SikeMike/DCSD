library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.ALL;

entity lcd_filter_tb is

  -- Entidad vacia

end lcd_filter_tb;

architecture arq_lcd_filter_tb of lcd_filter_tb is

component lcd_filter

  -- seniales de entrada y salida
  port(
    CLK:      in std_logic;
    RESET_L : in std_logic;

    OP_FILTER : in std_logic;
    RX :        in std_logic;
    SPEED :     in std_logic_vector(1 downto 0);

    FILTER_DONE : out std_logic;
    RX_BIT :      out std_logic
  );

end component;

--declaracion de las seniales de control
signal tb_CLK : std_logic := '0';
signal tb_RESET_L : std_logic := '0';

signal tb_OP_FILTER : std_logic := '0';
signal tb_RX : std_logic := '1';
signal tb_SPEED : std_logic_vector(1 downto 0) := "01";

signal tb_FILTER_DONE : std_logic;
signal tb_RX_BIT : std_logic;

begin

  uFilter : lcd_filter port map (

    CLK => tb_CLK,
    RESET_L => tb_RESET_L,

    OP_FILTER => tb_OP_FILTER,
    RX => tb_RX,
    SPEED => tb_SPEED,

    FILTER_DONE => tb_FILTER_DONE,
    RX_BIT => tb_RX_BIT

  );

  tb_CLK <= not tb_CLK after 10 ns;

  simulacion : process
  begin
    wait for 20 ns;
    tb_RESET_L <= '1';
    wait for 60 ns;
    tb_OP_FILTER <= '1';
    tb_RX <= '1';
    wait for 20 ns;
    tb_OP_FILTER <= '0';
    wait;
  end process;

end arq_lcd_filter_tb;
