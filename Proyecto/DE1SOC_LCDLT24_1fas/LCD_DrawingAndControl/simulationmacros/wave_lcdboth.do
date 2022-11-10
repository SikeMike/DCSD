onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 30 {LCD_CONTROL Y LCD_DRAWING}
add wave -noupdate -divider {Reloj y ResetL}
add wave -noupdate -color Orange /lcd_controlanddrawing_tb/tb_CLK
add wave -noupdate -color {Green Yellow} /lcd_controlanddrawing_tb/tb_RESET_L
add wave -noupdate -divider LCD_DRAWING
add wave -noupdate -color Blue /lcd_controlanddrawing_tb/uDraw/DEL_SCREEN
add wave -noupdate -color Blue /lcd_controlanddrawing_tb/uDraw/DRAW_FIG
add wave -noupdate -color Blue /lcd_controlanddrawing_tb/uDraw/DONE_CURSOR
add wave -noupdate -color Blue /lcd_controlanddrawing_tb/uDraw/DONE_COLOUR
add wave -noupdate -color Blue /lcd_controlanddrawing_tb/uDraw/COLOUR_CODE
add wave -noupdate -color {Violet Red} /lcd_controlanddrawing_tb/uDraw/XCOL
add wave -noupdate -color {Violet Red} /lcd_controlanddrawing_tb/uDraw/YROW
add wave -noupdate -color {Violet Red} /lcd_controlanddrawing_tb/uDraw/RGB
add wave -noupdate -color {Violet Red} /lcd_controlanddrawing_tb/uDraw/NUM_PIX
add wave -noupdate -color {Violet Red} /lcd_controlanddrawing_tb/uDraw/OP_SETCURSOR
add wave -noupdate -color {Violet Red} /lcd_controlanddrawing_tb/uDraw/OP_DRAWCOLOUR
add wave -noupdate /lcd_controlanddrawing_tb/uDraw/EP
add wave -noupdate -divider LCD_CONTROL
add wave -noupdate -color Cyan /lcd_controlanddrawing_tb/uCont/LCD_Init_Done
add wave -noupdate -color Cyan /lcd_controlanddrawing_tb/uCont/OP_SETCURSOR
add wave -noupdate -color Cyan /lcd_controlanddrawing_tb/uCont/XCOL
add wave -noupdate -color Cyan /lcd_controlanddrawing_tb/uCont/YROW
add wave -noupdate -color Cyan /lcd_controlanddrawing_tb/uCont/OP_DRAWCOLOUR
add wave -noupdate -color Cyan /lcd_controlanddrawing_tb/uCont/RGB
add wave -noupdate -color Cyan /lcd_controlanddrawing_tb/uCont/NUM_PIX
add wave -noupdate -color Salmon /lcd_controlanddrawing_tb/uCont/DONE_CURSOR
add wave -noupdate -color Salmon /lcd_controlanddrawing_tb/uCont/DONE_COLOUR
add wave -noupdate -color Salmon /lcd_controlanddrawing_tb/uCont/LCD_CS_N
add wave -noupdate -color Salmon /lcd_controlanddrawing_tb/uCont/LCD_WR_N
add wave -noupdate -color Salmon /lcd_controlanddrawing_tb/uCont/LCD_RS
add wave -noupdate -color Salmon /lcd_controlanddrawing_tb/uCont/LCD_DATA
add wave -noupdate /lcd_controlanddrawing_tb/uCont/EP
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6022346369 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 314
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {6300 us}
