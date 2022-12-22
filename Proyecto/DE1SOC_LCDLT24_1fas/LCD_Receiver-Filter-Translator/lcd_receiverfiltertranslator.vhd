library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.ALL;

entity lcd_receiverfiltertranslator_tb is

  -- Entidad vacia

end lcd_receiverfiltertranslator_tb;

architecture arq_lcd_receiverfiltertranslator_tb of lcd_receiverfiltertranslator_tb is

component lcd_receiver
  port(
    CLK :     in std_logic;
    RESET_L : in std_logic;

    RX :          in std_logic;
    FILTER_DONE : in std_logic;
    RX_BIT :      in std_logic;
    DONE :        in std_logic;

    OP_FILTER :    out std_logic;
    COMAND_READY : out std_logic;
    COMAND :      out std_logic_vector(7 downto 0)
  );

end component;

component lcd_filter
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

component lcd_translator
  port(
    CLK :     in std_logic;
    RESET_L : in std_logic;

    COMAND_READY :          in std_logic;
    COMAND : in std_logic_vector(7 downto 0);

    DEL_SCREEN :    out std_logic;
    DRAW_FIG : out std_logic;
    DONE :      out std_logic
  );

end component;

--SIGNALS DE LCD_RECEIVER
signal tb_CLK : std_logic := '0';
signal tb_RESET_L : std_logic := '0';

signal tb_RX : std_logic := '1';
signal tb_FILTER_DONE : std_logic;
signal tb_RX_BIT : std_logic;
signal tb_DONE : std_logic := '0';

signal tb_OP_FILTER : std_logic;
signal tb_COMAND_READY : std_logic;
signal tb_COMAND : std_logic_vector(7 downto 0);

--SIGNALS DE LCD_FILTER
--signal tb_CLK : std_logic;
--signal tb_RESET_L : std_logic;

--signal tb_OP_FILTER : std_logic;
--signal tb_RX : std_logic;
signal tb_SPEED : std_logic_vector(1 downto 0) := "01";

--signal tb_FILTER_DONE : std_logic;
--signal tb_RX_BIT : std_logic;

--SIGNALS DE LCD_TRANSLATOR
--signal tb_CLK : std_logic := '0';
--signal tb_RESET_L : std_logic := '0';

--signal tb_COMAND_READY : std_logic := '0';
--signal tb_COMAND : std_logic_vector(7 downto 0) := (others => '0');

signal tb_DEL_SCREEN : std_logic;
signal tb_DRAW_FIG : std_logic;
--signal tb_DONE : std_logic;


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
    COMAND => tb_COMAND

  );

  uFilter : lcd_filter port map (

    CLK => tb_CLK,
    RESET_L => tb_RESET_L,

    OP_FILTER => tb_OP_FILTER,
    RX => tb_RX,
    SPEED => tb_SPEED,

    FILTER_DONE => tb_FILTER_DONE,
    RX_BIT => tb_RX_BIT

  );

  uTranslator : lcd_translator port map (

    CLK => tb_CLK,
    RESET_L => tb_RESET_L,

    COMAND_READY => tb_COMAND_READY,
    COMAND => tb_COMAND,

    DEL_SCREEN => tb_DEL_SCREEN,
    DRAW_FIG => tb_DRAW_FIG,
    DONE => tb_DONE

  );

  tb_CLK <= not tb_CLK after 10 ns;

  sim_receANDfilt : process
  begin
    wait for 20 ns;     -- ciclo 1
    tb_RESET_L <= '1';
    wait for 2000000 ns;     -- start bit
    tb_RX <= '0';
    wait for 3333333 ns;     -- 1 bit
    tb_RX <= '0';
    wait for 3333333 ns;     -- 2 bit
    tb_RX <= '1';
    wait for 3333333 ns;     -- 3 bit
    tb_RX <= '1';
    wait for 3333333 ns;     -- 4 bit
    tb_RX <= '0';
    wait for 3333333 ns;     -- 5 bit
    tb_RX <= '0';
    wait for 3333333 ns;     -- 6 bit
    tb_RX <= '1';
    wait for 3333333 ns;     -- 7 bit
    tb_RX <= '0';
    wait for 3333333 ns;     -- 8 bit
    tb_RX <= '0';
    wait for 3333333 ns;     -- parity bit
    tb_RX <= '1';
    wait for 3333333 ns;     -- stop bit
    tb_RX <= '1';
    wait for 5000000 ns;
    wait;
  end process ;

end arq_lcd_receiverfiltertranslator_tb;
