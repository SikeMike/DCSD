onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 30 LCD_CONTROL
add wave -noupdate -divider {> Señales de Entrada}
add wave -noupdate -color Coral /lcd_control_tb/uControl/CLK
add wave -noupdate /lcd_control_tb/uControl/RESET_L
add wave -noupdate /lcd_control_tb/uControl/LCD_Init_Done
add wave -noupdate /lcd_control_tb/uControl/OP_SETCURSOR
add wave -noupdate -color Cyan /lcd_control_tb/uControl/XCOL
add wave -noupdate -color Cyan -expand -subitemconfig {/lcd_control_tb/uControl/YROW(8) {-color Cyan} /lcd_control_tb/uControl/YROW(7) {-color Cyan} /lcd_control_tb/uControl/YROW(6) {-color Cyan} /lcd_control_tb/uControl/YROW(5) {-color Cyan} /lcd_control_tb/uControl/YROW(4) {-color Cyan} /lcd_control_tb/uControl/YROW(3) {-color Cyan} /lcd_control_tb/uControl/YROW(2) {-color Cyan} /lcd_control_tb/uControl/YROW(1) {-color Cyan} /lcd_control_tb/uControl/YROW(0) {-color Cyan}} /lcd_control_tb/uControl/YROW
add wave -noupdate /lcd_control_tb/uControl/OP_DRAWCOLOUR
add wave -noupdate -color Gray55 /lcd_control_tb/uControl/RGB
add wave -noupdate -color Gray55 /lcd_control_tb/uControl/NUM_PIX
add wave -noupdate -divider {> Señales de Salida}
add wave -noupdate -color Blue /lcd_control_tb/uControl/DONE_CURSOR
add wave -noupdate -color Blue /lcd_control_tb/uControl/DONE_COLOUR
add wave -noupdate /lcd_control_tb/uControl/LCD_CS_N
add wave -noupdate /lcd_control_tb/uControl/LCD_WR_N
add wave -noupdate /lcd_control_tb/uControl/LCD_RS
add wave -noupdate -color Sienna /lcd_control_tb/uControl/LCD_DATA
add wave -noupdate -divider {Señales de Control}
add wave -noupdate /lcd_control_tb/uControl/EP
add wave -noupdate -color Cyan /lcd_control_tb/uControl/RXCOL
add wave -noupdate -color Cyan /lcd_control_tb/uControl/RYROW
add wave -noupdate /lcd_control_tb/uControl/RRGB
add wave -noupdate /lcd_control_tb/uControl/CONT_Q
add wave -noupdate /lcd_control_tb/uControl/LD_INF
add wave -noupdate /lcd_control_tb/uControl/DEC_PIX
add wave -noupdate /lcd_control_tb/uControl/END_PIX
add wave -noupdate /lcd_control_tb/uControl/CL_DAT
add wave -noupdate /lcd_control_tb/uControl/INC_DAT
add wave -noupdate /lcd_control_tb/uControl/LD_2C
add wave -noupdate /lcd_control_tb/uControl/RS_DAT
add wave -noupdate /lcd_control_tb/uControl/RS_COM
add wave -noupdate /lcd_control_tb/uControl/aux_contpix
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {747258 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 275
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
WaveRestoreZoom {0 ps} {754717 ps}
