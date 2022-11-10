library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE1SOC_LCDLT24_1fas is
 port(
	-- CLOCK ----------------
	CLOCK_50	: in	std_logic;
--	CLOCK2_50	: in	std_logic;
--	CLOCK3_50	: in	std_logic;
--	CLOCK4_50	: in	std_logic;
	-- KEY ----------------
	KEY 		: in	std_logic_vector(3 downto 0);
	-- SW ----------------
	SW 			: in	std_logic_vector(2 downto 0);
	-- LEDR ----------------
	LEDR 		: out	std_logic_vector(9 downto 0);
	-- LT24_LCD ----------------
   LT24_LCD_ON     : out std_logic;
   LT24_RESET_N    : out std_logic;
   LT24_CS_N       : out std_logic;
   LT24_RD_N       : out std_logic;
   LT24_RS         : out std_logic;
   LT24_WR_N       : out std_logic;
   LT24_D          : out   std_logic_vector(15 downto 0)

	-- GPIO ----------------
--	GPIO_0 		: inout	std_logic_vector(35 downto 0);

	-- SEG7 ----------------
--	HEX0	: out	std_logic_vector(6 downto 0);
--	HEX1	: out	std_logic_vector(6 downto 0);
--	HEX2	: out	std_logic_vector(6 downto 0);
--	HEX3	: out	std_logic_vector(6 downto 0);
--	HEX4	: out	std_logic_vector(6 downto 0);
--	HEX5	: out	std_logic_vector(6 downto 0);

 );
end;

architecture str of DE1SOC_LCDLT24_1fas is 
	
component LT24Setup 
 port(
      -- CLOCK and Reset_l ----------------
      clk            : in      std_logic;
      reset_l        : in      std_logic;
		
      LT24_CS_N_Int        : in std_logic;
      LT24_WR_N_Int        : in std_logic;
      LT24_RD_N_Int        : in std_logic;
      LT24_RS_Int          : in std_logic;
      LT24_D_Int           : in std_logic_vector(15 downto 0);

      LT24_LCD_ON      : out std_logic;
      LT24_RESET_N     : out std_logic;
      LT24_CS_N        : out std_logic;
      LT24_WR_N        : out std_logic;
      LT24_RD_N        : out std_logic;
      LT24_RS          : out std_logic;
      LT24_D           : out std_logic_vector(15 downto 0);
      LT24_Init_Done       : out std_logic
  );
  end component;
  
component lcd_control
	port
	(
		CLK : in std_logic;
		RESET_L : in std_logic;
		
		LCD_INIT_DONE	: in std_logic;
		OP_SETCURSOR	: in	std_logic;
		XCOL				: in std_logic_vector(7 downto 0);
		YROW				: in std_logic_vector(8 downto 0);
		OP_DRAWCOLOUR	: in	std_logic;
		RGB				: in std_logic_vector(15 downto 0);
		NUM_PIX			: in std_logic_vector(16 downto 0);
		
		DONE_CURSOR	: out std_logic;
		DONE_COLOUR : out std_logic;
		
		LCD_CS_N	: out std_logic;
		LCD_WR_N	: out std_logic;
		LCD_RS	: out std_logic;
		LCD_DATA	: out std_logic_vector(15 downto 0)
		
	);
end component;

component lcd_drawing
	port
	(
		CLK : in std_logic;
		RESET_L : in std_logic;
		
		DEL_SCREEN	: in std_logic;
		DRAW_FIG		: in std_logic;
		COLOUR_CODE	: in std_logic_vector(2 downto 0);
		DONE_CURSOR	: in std_logic;
		DONE_COLOUR	: in std_logic;
		
		OP_SETCURSOR 	: out std_logic;
		XCOL				: out std_logic_vector(7 downto 0);
		YROW				: out std_logic_vector(8 downto 0);
		OP_DRAWCOLOUR	: out std_logic;
		RGB				: out std_logic_vector(15 downto 0);
		NUM_PIX			: out std_logic_vector(16 downto 0)
	);
end component;

  -- LT24Setup COMPONENT
  signal TOP_clk, TOP_reset, TOP_reset_l :  std_logic;

  signal  TOP_LT24_CS_N_Int        :  std_logic;
  signal  TOP_LT24_WR_N_Int        :  std_logic;
  signal  TOP_LT24_RD_N_Int        :  std_logic;
  signal  TOP_LT24_RS_Int          :  std_logic;
  signal  TOP_LT24_D_Int           :  std_logic_vector(15 downto 0);
  
  signal TOP_LT24_LCD_ON      : std_logic;
  signal TOP_LT24_RESET_N     : std_logic;
  signal TOP_LT24_CS_N        : std_logic;
  signal TOP_LT24_WR_N        : std_logic;
  signal TOP_LT24_RD_N        : std_logic;
  signal TOP_LT24_RS          : std_logic;
  signal TOP_LT24_D           : std_logic_vector(15 downto 0);
  signal TOP_LT24_Init_Done   : std_logic;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  
  -- LCD_DRAWING COMPONENT
  
  --TOP_clk, TOP_reset, TOP_reset_l :  std_logic;
  --signal TOP_LCD_Init_Done : std_logic := '0';
  signal TOP_OP_SETCURSOR : std_logic := '0';
  signal TOP_XCOL : std_logic_vector(7 downto 0) := "00000000";
  signal TOP_YROW : std_logic_vector(8 downto 0) := "000000000";
  signal TOP_OP_DRAWCOLOUR : std_logic := '0';
  signal TOP_RGB : std_logic_vector(15 downto 0) := "0000000000000000";
  signal TOP_NUM_PIX : std_logic_vector(16 downto 0) := "00000000000000000";

  signal TOP_DONE_CURSOR : std_logic;
  signal TOP_DONE_COLOUR : std_logic;
  
  -->Estas salidas del lcd_drawing son las entradas del setup
  --signal TOP_LCD_CS_N : std_logic;
  --signal TOP_LCD_WR_N : std_logic;
  --signal TOP_LCD_RS : std_logic;
  --signal TOP_LCD_DATA : std_logic_vector(15 downto 0);
    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  
  -- LCD_CONTROL COMPONENT
  
  --clk, reset, reset_l :  std_logic;
  signal TOP_DEL_SCREEN : std_logic := '0';
  signal TOP_DRAW_FIG : std_logic := '0';
  signal TOP_COLOUR_CODE : std_logic_vector(2 downto 0);
  -- TOP_DONE_CURSOR : std_logic;
  -- TOP_DONE_COLOUR : std_logic;
  -- TOP_OP_SETCURSOR : std_logic := '0';
  -- TOP_XCOL : std_logic_vector(7 downto 0);
  -- TOP_YROW : std_logic_vector(8 downto 0);
  -- TOP_OP_DRAWCOLOUR : std_logic := '0';
  -- TOP_RGB : std_logic_vector(15 downto 0);
  -- TOP_NUM_PIX : std_logic_vector(16 downto 0);

  

begin

   TOP_clk <= CLOCK_50;
   TOP_reset <= not(KEY(0));
   TOP_reset_l <= KEY(0);
	
   TOP_LT24_RD_N_Int <= '1';
	
   LEDR(8) <= TOP_LT24_Init_Done;
	
	TOP_DEL_SCREEN <= not(KEY(3));
	TOP_DRAW_FIG <= not(KEY(2));
	TOP_COLOUR_CODE <= SW(2 downto 0);
	
	LEDR(6) <= not(KEY(3)); --OP_SETCURSOR 
	LEDR(5) <= not(KEY(2)); --OP_DRAWCOLOUR

    
-- Osagaien elkarketa        --------------    

  O1_SETUP:LT24Setup 
  port map(
  
      clk          => TOP_clk,
      reset_l      => TOP_reset_l,

      LT24_CS_N_Int       => TOP_LT24_CS_N_Int,
      LT24_RS_Int         => TOP_LT24_RS_Int,
      LT24_WR_N_Int       => TOP_LT24_WR_N_Int,
      LT24_RD_N_Int       => TOP_LT24_RD_N_Int,
      LT24_D_Int          => TOP_LT24_D_Int,

      LT24_LCD_ON      => LT24_LCD_ON,
      LT24_RESET_N     => LT24_RESET_N,
      LT24_CS_N        => LT24_CS_N,
      LT24_RS          => LT24_RS,
      LT24_WR_N        => LT24_WR_N,
      LT24_RD_N        => LT24_RD_N,
      LT24_D           => LT24_D,
		
      LT24_Init_Done		=> TOP_LT24_Init_Done
 );



  O2_LCDDRAW: lcd_drawing
  port map (
  
      CLK         => TOP_clk,
      RESET_L      => TOP_reset_l,
		
		DEL_SCREEN 		=> TOP_DEL_SCREEN,
		DRAW_FIG 		=> TOP_DRAW_FIG,
		COLOUR_CODE 	=> TOP_COLOUR_CODE,
		DONE_CURSOR 	=> TOP_DONE_CURSOR,
		DONE_COLOUR 	=> TOP_DONE_COLOUR,
		
		OP_SETCURSOR 	=> TOP_OP_SETCURSOR, 
		XCOL 				=> TOP_XCOL,
		YROW 				=> TOP_YROW,
		OP_DRAWCOLOUR 	=> TOP_OP_DRAWCOLOUR,
		RGB 				=> TOP_RGB,
		NUM_PIX 			=> TOP_NUM_PIX

		);
	
  O3_LCDCONT: lcd_control
  port map (
  
      CLK 		=> TOP_clk,
      RESET_L 	=> TOP_reset_l,
		
		LCD_Init_Done 	=> TOP_LT24_Init_Done,
		OP_SETCURSOR 	=> TOP_OP_SETCURSOR,
		XCOL 				=> TOP_XCOL,
		YROW 				=> TOP_YROW,
		OP_DRAWCOLOUR 	=> TOP_OP_DRAWCOLOUR,
		RGB 				=> TOP_RGB,
		NUM_PIX 			=> TOP_NUM_PIX,

		DONE_CURSOR => TOP_DONE_CURSOR,
		DONE_COLOUR => TOP_DONE_COLOUR, 
		LCD_CS_N 	=> TOP_LT24_CS_N_Int, 
		LCD_WR_N 	=> TOP_LT24_WR_N_Int, 
		LCD_RS 		=> TOP_LT24_RS_Int,
		LCD_DATA 	=> TOP_LT24_D_Int

		);
  
END str;
