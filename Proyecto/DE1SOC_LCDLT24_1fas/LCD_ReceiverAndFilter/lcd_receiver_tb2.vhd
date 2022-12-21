library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.ALL;

entity lcd_receiver_tb is

  -- Entidad vacia

end lcd_receiver_tb;

architecture arq_lcd_receiver_tb of lcd_receiver_tb is

component lcd_receiver

  -- seniales de entrada y salida
  port(
    CLK :    in std_logic;
    RESET_L : in std_logic;

    RX : in std_logic;
    FILTER_DONE : in std_logic;
    RX_BIT : in std_logic;
    DONE : in std_logic;

    OP_FILTER : out std_logic;
    COMAND_READY : out std_logic;
    COMANDO : out std_logic_vector(7 downto 0)
  );

end component;

-- declaracion de las seniales de control
signal tb_CLK : std_logic := '0';
signal tb_RESET_L : std_logic := '0';

signal tb_RX : std_logic := '1';
signal tb_FILTER_DONE : std_logic := '0';
signal tb_RX_BIT : std_logic := '0';
signal tb_DONE : std_logic := '0';

signal tb_OP_FILTER : std_logic;
signal tb_COMAND_READY : std_logic;
signal tb_COMANDO : std_logic_vector(7 downto 0);

begin

  uReceiver : lcd_receiver port map (

    CLK => tb_CLK,
    RESET_L => tb_RESET_L,

    RX => tb_RX,
    FILTER_DONE => tb_FILTER_DONE,
    RX_BIT => tb_RX_BIT,
    DONE => tb_DONE,

    OP_FILTER => tb_OP_FILTER,
    COMAND_READY => tb_COMAND_READY,
    COMANDO => tb_COMANDO

  );

  tb_CLK <= not tb_CLK after 10 ns;

  simulacion : process
  begin
    wait for 20 ns;             -- E0 -> E1 (desactivo reset_l)
    tb_RESET_L <= '1';
    wait for 40 ns;             -- E1 -> E2 Cambio en RX
    tb_RX <= '0';
    wait for 40 ns;             -- E2 -> E3 FILTER_DONE se activa y guardo RX_BIT en StartBit
    tb_FILTER_DONE <= '1';
    tb_RX <= '0';               -- ##> START BIT <##
    tb_RX_BIT <= '0';
    wait for 20 ns;             -- E3 -> E4
    tb_FILTER_DONE <= '0';
    wait for 40 ns;
    tb_FILTER_DONE <= '1';      --
    tb_RX <= '0';               -- ##> RX BIT 1 - 0 <##
    tb_RX_BIT <= '0';           --
    wait for 20 ns;
    tb_FILTER_DONE <= '0';
    wait for 40 ns;
    tb_FILTER_DONE <= '1';      --
    tb_RX <= '0';               -- ##> RX BIT 2 - 0 <##
    tb_RX_BIT <= '0';           --
    wait for 20 ns;
    tb_FILTER_DONE <= '0';
    wait for 40 ns;
    tb_FILTER_DONE <= '1';      --
    tb_RX <= '1';               -- ##> RX BIT 3 - 1 <##
    tb_RX_BIT <= '1';           --
    wait for 20 ns;
    tb_FILTER_DONE <= '0';
    wait for 40 ns;
    tb_FILTER_DONE <= '1';      --
    tb_RX <= '1';               -- ##> RX BIT 4 - 1 <##
    tb_RX_BIT <= '1';           --
    wait for 20 ns;
    tb_FILTER_DONE <= '0';
    wait for 40 ns;
    tb_FILTER_DONE <= '1';      --
    tb_RX <= '0';               -- ##> RX BIT 5 - 0 <##
    tb_RX_BIT <= '0';           --
    wait for 20 ns;
    tb_FILTER_DONE <= '0';
    wait for 40 ns;
    tb_FILTER_DONE <= '1';      --
    tb_RX <= '1';               -- ##> RX BIT 6 - 1 <##
    tb_RX_BIT <= '1';           --
    wait for 20 ns;
    tb_FILTER_DONE <= '0';
    wait for 40 ns;
    tb_FILTER_DONE <= '1';      --
    tb_RX <= '0';               -- ##> RX BIT 7 - 0 <##
    tb_RX_BIT <= '0';           --
    wait for 20 ns;
    tb_FILTER_DONE <= '0';
    wait for 40 ns;
    tb_FILTER_DONE <= '1';      --
    tb_RX <= '1';               -- ##> RX BIT 8 - 1 <##
    tb_RX_BIT <= '1';           --
    wait for 20 ns;
    tb_FILTER_DONE <= '0';
    wait for 40 ns;
    tb_FILTER_DONE <= '1';      --
    tb_RX <= '0';               -- ##> PARITY BIT - 0 <##
    tb_RX_BIT <= '0';           --
    wait for 20 ns;
    tb_FILTER_DONE <= '0';
    wait for 40 ns;
    tb_FILTER_DONE <= '1';      --
    tb_RX <= '1';               -- ##> STOP BIT - 0 <##
    tb_RX_BIT <= '1';           --
    wait for 20 ns;
    tb_FILTER_DONE <= '0';
    wait for 80 ns;
    tb_DONE <= '1';
    wait for 20 ns;
    tb_DONE <= '0';

    wait for 200 ns;
    wait;
  end process ;

end arq_lcd_receiver_tb;
