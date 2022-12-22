onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lcd_translator_tb/uTranslator/CLK
add wave -noupdate /lcd_translator_tb/uTranslator/RESET_L
add wave -noupdate -divider ENTRADA/SALIDA
add wave -noupdate /lcd_translator_tb/uTranslator/COMAND_READY
add wave -noupdate /lcd_translator_tb/uTranslator/COMAND
add wave -noupdate /lcd_translator_tb/uTranslator/DEL_SCREEN
add wave -noupdate /lcd_translator_tb/uTranslator/DRAW_FIG
add wave -noupdate /lcd_translator_tb/uTranslator/DONE
add wave -noupdate -divider {SENIALES DE CONTROL}
add wave -noupdate /lcd_translator_tb/uTranslator/EP
add wave -noupdate /lcd_translator_tb/uTranslator/ES
add wave -noupdate /lcd_translator_tb/uTranslator/LD_Com
add wave -noupdate /lcd_translator_tb/uTranslator/Clear
add wave -noupdate /lcd_translator_tb/uTranslator/Q_Com
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {113838 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 292
configure wave -valuecolwidth 58
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
WaveRestoreZoom {0 ps} {201162 ps}
