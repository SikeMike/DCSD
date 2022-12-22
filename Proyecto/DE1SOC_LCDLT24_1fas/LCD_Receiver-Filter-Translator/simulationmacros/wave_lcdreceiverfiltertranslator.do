onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lcd_receiverfiltertranslator_tb/tb_CLK
add wave -noupdate /lcd_receiverfiltertranslator_tb/tb_RESET_L
add wave -noupdate -divider LCD_RECEIVER
add wave -noupdate /lcd_receiverfiltertranslator_tb/uReceiver/RX
add wave -noupdate /lcd_receiverfiltertranslator_tb/uReceiver/FILTER_DONE
add wave -noupdate /lcd_receiverfiltertranslator_tb/uReceiver/RX_BIT
add wave -noupdate /lcd_receiverfiltertranslator_tb/uReceiver/DONE
add wave -noupdate /lcd_receiverfiltertranslator_tb/uReceiver/OP_FILTER
add wave -noupdate /lcd_receiverfiltertranslator_tb/uReceiver/COMAND_READY
add wave -noupdate /lcd_receiverfiltertranslator_tb/uReceiver/COMAND
add wave -noupdate /lcd_receiverfiltertranslator_tb/uReceiver/EP
add wave -noupdate /lcd_receiverfiltertranslator_tb/uReceiver/ES
add wave -noupdate -divider LCD_FILTER
add wave -noupdate /lcd_receiverfiltertranslator_tb/uFilter/SPEED
add wave -noupdate /lcd_receiverfiltertranslator_tb/uFilter/EP
add wave -noupdate /lcd_receiverfiltertranslator_tb/uFilter/ES
add wave -noupdate -divider LCD_TRANSLATOR
add wave -noupdate /lcd_receiverfiltertranslator_tb/uTranslator/DEL_SCREEN
add wave -noupdate /lcd_receiverfiltertranslator_tb/uTranslator/DRAW_FIG
add wave -noupdate /lcd_receiverfiltertranslator_tb/uTranslator/EP
add wave -noupdate /lcd_receiverfiltertranslator_tb/uTranslator/ES
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {49668874172 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 363
configure wave -valuecolwidth 68
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
WaveRestoreZoom {0 ps} {41622516556 ps}
