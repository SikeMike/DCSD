onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 30 LCD_DRAWING
add wave -noupdate -divider {> Señales de Entrada}
add wave -noupdate -color Orange /lcd_drawing_tb/uDrawing/CLK
add wave -noupdate /lcd_drawing_tb/uDrawing/RESET_L
add wave -noupdate -color Yellow /lcd_drawing_tb/uDrawing/DEL_SCREEN
add wave -noupdate -color Yellow /lcd_drawing_tb/uDrawing/DRAW_FIG
add wave -noupdate -color Red /lcd_drawing_tb/uDrawing/DONE_CURSOR
add wave -noupdate -color Red /lcd_drawing_tb/uDrawing/DONE_COLOUR
add wave -noupdate /lcd_drawing_tb/uDrawing/COLOUR_CODE
add wave -noupdate -divider {> Señales de Salida}
add wave -noupdate /lcd_drawing_tb/uDrawing/XCOL
add wave -noupdate /lcd_drawing_tb/uDrawing/YROW
add wave -noupdate /lcd_drawing_tb/uDrawing/RGB
add wave -noupdate /lcd_drawing_tb/uDrawing/NUM_PIX
add wave -noupdate /lcd_drawing_tb/uDrawing/OP_SETCURSOR
add wave -noupdate /lcd_drawing_tb/uDrawing/OP_DRAWCOLOUR
add wave -noupdate -divider {Señales de Control}
add wave -noupdate /lcd_drawing_tb/uDrawing/EP
add wave -noupdate /lcd_drawing_tb/uDrawing/ES
add wave -noupdate /lcd_drawing_tb/uDrawing/LD_Square
add wave -noupdate /lcd_drawing_tb/uDrawing/Next_Row
add wave -noupdate /lcd_drawing_tb/uDrawing/END_Square
add wave -noupdate /lcd_drawing_tb/uDrawing/SEL_M
add wave -noupdate /lcd_drawing_tb/uDrawing/SEL_PIX
add wave -noupdate /lcd_drawing_tb/uDrawing/WHITE
add wave -noupdate /lcd_drawing_tb/uDrawing/Q_Square
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {523235 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 272
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
WaveRestoreZoom {0 ps} {527489 ps}
